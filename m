Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:56411 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754886Ab1GOCMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 22:12:08 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices bridge (ddbridge)
Date: Fri, 15 Jul 2011 04:11:43 +0200
Cc: linux-media@vger.kernel.org, Ralph Metzler <rjkm@metzlerbros.de>
References: <201107032321.46092@orion.escape-edv.de> <201107150145.29547@orion.escape-edv.de> <4E1F8E1F.3000008@redhat.com>
In-Reply-To: <4E1F8E1F.3000008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201107150411.45222@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 15 July 2011 02:47:27 Mauro Carvalho Chehab wrote:
> Em 14-07-2011 20:45, Oliver Endriss escreveu:
> > On Monday 04 July 2011 02:17:52 Mauro Carvalho Chehab wrote:
> >> Em 03-07-2011 20:24, Oliver Endriss escreveu:
> > ...
> >>> Anyway, I spent the whole weekend to re-format the code carefully
> >>> and create both patch series, trying not to break anything.
> >>> I simply cannot go through the driver code and verify everything.
> >>
> >> As the changes on CHK_ERROR were done via script, it is unlikely that it
> >> introduced any problems (well, except if some function is returning
> >> a positive value as an error code, but I think that this is not the
> >> case).
> >>
> >> I did the same replacement when I've cleanup the drx-d driver (well, the 
> >> script were not the same, but it used a similar approach), and the changes 
> >> didn't break anything, but it is safer to have a test, to be sure that no
> >> functional changes were introduced.
> >>
> >> A simple test with the code and some working board is probably enough
> >> to verify that nothing broke.
> > 
> > Finally I found some time to do this 'simple' test.
> 
> Thanks for testing it. Big changes on complex driver require testing.
> 
> > Congratulations! You completely broke the DRXK for ngene and ddbridge:
> > - DVB-T tuning does not work anymore.
> 
> I don't have any DVB-T signal here. I'll double check what changed there
> and see if I can identify a possible cause for it, but eventually I may
> not discover what's wrong. 
> 
> Before I start bisecting, I need to know if the starting point is working.
> So, had you test that DVB-T was working after your cleanup patches?

Yes, it worked.

And now I double checked with media_build of July 3th + my patch series:
It works as expected.

Well, I did not test DVB-C, but people reported that DVB-C was working
before I applied my cleanups. So I assume it worked.

> > - Module unloading fails as well. drxk is 'in use' due to bad reference count.
> 
> I was eventually expecting a feedback about that. The patch that changed the
> behavior is this one:
> 
> 	http://git.linuxtv.org/media_tree.git?a=commitdiff;h=f087cdd6f4fa8bef0e7588b124f52649d3cebe67
> 
> What happens is that drxk_attach() allocates one state struct each time it is called,
> and it initializes both frontends with the state:

drxk_attach() was meant to be called once.
See dvb_input_attach() in ddbridge-core.c:

       case DDB_TUNER_DVBCT_TR:
                if (demod_attach_drxk(input) < 0)
                        return -ENODEV;
                if (tuner_attach_tda18271(input) < 0)
                        return -ENODEV;
                if (input->fe) {
                        if (dvb_register_frontend(adap, input->fe) < 0)
                                return -ENODEV;
                }
                if (input->fe2) {
                        if (dvb_register_frontend(adap, input->fe2) < 0)
                                return -ENODEV;
                        input->fe2->tuner_priv=input->fe->tuner_priv;
                        memcpy(&input->fe2->ops.tuner_ops,
                               &input->fe->ops.tuner_ops,
                               sizeof(struct dvb_tuner_ops));
                }
                break;


demod_attach_drxk() returns two frontends: fe and fe2.

> 	state = kzalloc(sizeof(struct drxk_state), GFP_KERNEL);
> ...
>        	state->c_frontend.demodulator_priv = state;
>       	state->t_frontend.demodulator_priv = state;
> ...
> 	*fe_t = &state->t_frontend;
> ...
> 	return &state->c_frontend;
> 
> If you call it twice, the driver will loose the references for the first struct, and you'll
> end by having a memory leak at driver removal, if both DVB-T and DVB-C are registered.

See above.

> On my code, I've made sure to call it only once, and then I ended by having a reference = (u32) -1
> for device removal, preventing me to remove the driver, as .
> 
> So, clearly, that function should be called just once. However, at DVB unregister,
> dvb_frontend_detach() will be called twice:
> 
> static void unregister_dvb(struct em28xx_dvb *dvb)
> {
>         dvb_net_release(&dvb->net);
>         dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
>         dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
>         dvb_dmxdev_release(&dvb->dmxdev);
>         dvb_dmx_release(&dvb->demux);
>         if (dvb->fe[1])
>                 dvb_unregister_frontend(dvb->fe[1]);
>         dvb_unregister_frontend(dvb->fe[0]);
>         if (dvb->fe[1])
>                 dvb_frontend_detach(dvb->fe[1]);
>         dvb_frontend_detach(dvb->fe[0]);
>         dvb_unregister_adapter(&dvb->adapter);
> }

>From ddbridge-core.c:
                if (input->fe2)
                        dvb_unregister_frontend(input->fe2);
                if (input->fe) {
                        dvb_unregister_frontend(input->fe);
                        dvb_frontend_detach(input->fe);
                        input->fe = NULL;
                }

So dvb_frontend_detach() was called exactly once.

Mauro, you must not change the logic of the frontend driver, unless you
verified what the bridge driver does...

> Or we would need to write a special unregister function at the driver just to
> cover the cases where DRX-K is used, as, on all other drivers, the attach
> function is called twice, even when the frontend supports two different types.
> 
> See cxd2820r_attach, for example: instead of initializing both frontends
> with just one call, it can be called twice. If called a second time, it will
> just use the previously allocated data.
> 
> I think that the better is to revert my patch and apply a solution similar
> to cxd2820r_attach. It should work fine if called just once (like ngene/ddbridge)
> or twice (like em28xx).
> 
> > (DVB-C not tested: I currently do not have access to a DVB-C signal.)
> 
> Hmm... are you sure that DVB-C used to work? I found an error on DVB-C setup for
> the device I used for test, fixed on this patch:
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=21ff98772327ff182f54d2fcca69448e440e23d3
> 
> Basically, on the device I tested, scu command:
> 	SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM
> requires 2 parameters, instead of 4.
> 
> I've preserved the old behavior there, assuming that your code was working, but I suspect that
> at least you need to do this:
> 
> +               setParamParameters[0] = QAM_TOP_ANNEX_A;
> +               if (state->m_OperationMode == OM_QAM_ITU_C)
> +                       setEnvParameters[0] = QAM_TOP_ANNEX_C;  /* Annex */
> +               else
> +                       setEnvParameters[0] = 0;
> +
> +               status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 1, setEnvParameters, 1, &cmdResult);
> 
> Due to this logic there, at SetQAM:
> 
>        	/* Env parameters */
>         setEnvParameters[2] = QAM_TOP_ANNEX_A;  /* Annex */
>         if (state->m_OperationMode == OM_QAM_ITU_C)
>                 setEnvParameters[2] = QAM_TOP_ANNEX_C;  /* Annex */
> 
> This var is filled, but there's no call to SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV. Also,
> iti initializes it as parameters[2], instead of parameters[0].

Sorry, I can't test it. Maybe Ralph can comment on this.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------

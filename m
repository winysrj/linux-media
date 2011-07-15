Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab1GOArf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 20:47:35 -0400
Message-ID: <4E1F8E1F.3000008@redhat.com>
Date: Thu, 14 Jul 2011 21:47:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rjkm@metzlerbros.de>
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices
 bridge (ddbridge)
References: <201107032321.46092@orion.escape-edv.de> <201107040124.04924@orion.escape-edv.de> <4E1106B0.7030102@redhat.com> <201107150145.29547@orion.escape-edv.de>
In-Reply-To: <201107150145.29547@orion.escape-edv.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-07-2011 20:45, Oliver Endriss escreveu:
> On Monday 04 July 2011 02:17:52 Mauro Carvalho Chehab wrote:
>> Em 03-07-2011 20:24, Oliver Endriss escreveu:
> ...
>>> Anyway, I spent the whole weekend to re-format the code carefully
>>> and create both patch series, trying not to break anything.
>>> I simply cannot go through the driver code and verify everything.
>>
>> As the changes on CHK_ERROR were done via script, it is unlikely that it
>> introduced any problems (well, except if some function is returning
>> a positive value as an error code, but I think that this is not the
>> case).
>>
>> I did the same replacement when I've cleanup the drx-d driver (well, the 
>> script were not the same, but it used a similar approach), and the changes 
>> didn't break anything, but it is safer to have a test, to be sure that no
>> functional changes were introduced.
>>
>> A simple test with the code and some working board is probably enough
>> to verify that nothing broke.
> 
> Finally I found some time to do this 'simple' test.

Thanks for testing it. Big changes on complex driver require testing.

> Congratulations! You completely broke the DRXK for ngene and ddbridge:
> - DVB-T tuning does not work anymore.

I don't have any DVB-T signal here. I'll double check what changed there
and see if I can identify a possible cause for it, but eventually I may
not discover what's wrong. 

Before I start bisecting, I need to know if the starting point is working.
So, had you test that DVB-T was working after your cleanup patches?

> - Module unloading fails as well. drxk is 'in use' due to bad reference count.

I was eventually expecting a feedback about that. The patch that changed the
behavior is this one:

	http://git.linuxtv.org/media_tree.git?a=commitdiff;h=f087cdd6f4fa8bef0e7588b124f52649d3cebe67

What happens is that drxk_attach() allocates one state struct each time it is called,
and it initializes both frontends with the state:

	state = kzalloc(sizeof(struct drxk_state), GFP_KERNEL);
...
       	state->c_frontend.demodulator_priv = state;
      	state->t_frontend.demodulator_priv = state;
...
	*fe_t = &state->t_frontend;
...
	return &state->c_frontend;

If you call it twice, the driver will loose the references for the first struct, and you'll
end by having a memory leak at driver removal, if both DVB-T and DVB-C are registered.

On my code, I've made sure to call it only once, and then I ended by having a reference = (u32) -1
for device removal, preventing me to remove the driver, as .

So, clearly, that function should be called just once. However, at DVB unregister,
dvb_frontend_detach() will be called twice:

static void unregister_dvb(struct em28xx_dvb *dvb)
{
        dvb_net_release(&dvb->net);
        dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
        dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
        dvb_dmxdev_release(&dvb->dmxdev);
        dvb_dmx_release(&dvb->demux);
        if (dvb->fe[1])
                dvb_unregister_frontend(dvb->fe[1]);
        dvb_unregister_frontend(dvb->fe[0]);
        if (dvb->fe[1])
                dvb_frontend_detach(dvb->fe[1]);
        dvb_frontend_detach(dvb->fe[0]);
        dvb_unregister_adapter(&dvb->adapter);
}

Or we would need to write a special unregister function at the driver just to
cover the cases where DRX-K is used, as, on all other drivers, the attach
function is called twice, even when the frontend supports two different types.

See cxd2820r_attach, for example: instead of initializing both frontends
with just one call, it can be called twice. If called a second time, it will
just use the previously allocated data.

I think that the better is to revert my patch and apply a solution similar
to cxd2820r_attach. It should work fine if called just once (like ngene/ddbridge)
or twice (like em28xx).

> (DVB-C not tested: I currently do not have access to a DVB-C signal.)

Hmm... are you sure that DVB-C used to work? I found an error on DVB-C setup for
the device I used for test, fixed on this patch:

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=21ff98772327ff182f54d2fcca69448e440e23d3

Basically, on the device I tested, scu command:
	SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM
requires 2 parameters, instead of 4.

I've preserved the old behavior there, assuming that your code was working, but I suspect that
at least you need to do this:

+               setParamParameters[0] = QAM_TOP_ANNEX_A;
+               if (state->m_OperationMode == OM_QAM_ITU_C)
+                       setEnvParameters[0] = QAM_TOP_ANNEX_C;  /* Annex */
+               else
+                       setEnvParameters[0] = 0;
+
+               status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 1, setEnvParameters, 1, &cmdResult);

Due to this logic there, at SetQAM:

       	/* Env parameters */
        setEnvParameters[2] = QAM_TOP_ANNEX_A;  /* Annex */
        if (state->m_OperationMode == OM_QAM_ITU_C)
                setEnvParameters[2] = QAM_TOP_ANNEX_C;  /* Annex */

This var is filled, but there's no call to SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV. Also,
iti initializes it as parameters[2], instead of parameters[0].

> Loading the driver:
> Jul 15 00:52:48 darkstar kernel: [  184.487399] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH
> Jul 15 00:52:48 darkstar kernel: [  184.487460] DDBridge 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> Jul 15 00:52:48 darkstar kernel: [  184.487469] DDBridge driver detected: Digital Devices Octopus DVB adapter
> Jul 15 00:52:48 darkstar kernel: [  184.487491] HW 00010001 FW 00010000
> Jul 15 00:52:48 darkstar kernel: [  184.488321] Port 0 (TAB 1): DUAL DVB-S2
> Jul 15 00:52:48 darkstar kernel: [  184.488837] Port 1 (TAB 2): NO MODULE
> Jul 15 00:52:48 darkstar kernel: [  184.489654] Port 2 (TAB 3): DUAL DVB-C/T
> Jul 15 00:52:48 darkstar kernel: [  184.490159] Port 3 (TAB 4): NO MODULE
> Jul 15 00:52:48 darkstar kernel: [  184.491245] DVB: registering new adapter (DDBridge)
> Jul 15 00:52:48 darkstar kernel: [  184.644296] LNBx2x attached on addr=b
> Jul 15 00:52:48 darkstar kernel: [  184.644363] stv6110x_attach: Attaching STV6110x
> Jul 15 00:52:48 darkstar kernel: [  184.644365] attach tuner input 0 adr 60
> Jul 15 00:52:48 darkstar kernel: [  184.644368] DVB: registering adapter 2 frontend 0 (STV090x Multistandard)...
> Jul 15 00:52:48 darkstar kernel: [  184.644435] DVB: registering new adapter (DDBridge)
> Jul 15 00:52:48 darkstar kernel: [  184.680305] LNBx2x attached on addr=9
> Jul 15 00:52:48 darkstar kernel: [  184.680373] stv6110x_attach: Attaching STV6110x
> Jul 15 00:52:48 darkstar kernel: [  184.680375] attach tuner input 1 adr 63
> Jul 15 00:52:48 darkstar kernel: [  184.680378] DVB: registering adapter 3 frontend 0 (STV090x Multistandard)...
> Jul 15 00:52:48 darkstar kernel: [  184.680445] DVB: registering new adapter (DDBridge)
> Jul 15 00:52:48 darkstar kernel: [  184.688938] drxk: detected a drx-3913k, spin A3, xtal 27.000 MHz
> Jul 15 00:52:48 darkstar kernel: [  185.108839] DRXK driver version 0.9.4300
> Jul 15 00:52:50 darkstar kernel: [  186.796361] DVB: registering adapter 4 frontend 0 (DRXK DVB-C)...
> Jul 15 00:52:50 darkstar kernel: [  186.796429] DVB: registering adapter 4 frontend 0 (DRXK DVB-T)...
> Jul 15 00:52:50 darkstar kernel: [  186.796471] DVB: registering new adapter (DDBridge)
> Jul 15 00:52:50 darkstar kernel: [  186.804923] drxk: detected a drx-3913k, spin A3, xtal 27.000 MHz
> Jul 15 00:52:50 darkstar kernel: [  187.224841] DRXK driver version 0.9.4300
> Jul 15 00:52:52 darkstar kernel: [  188.912354] DVB: registering adapter 5 frontend 0 (DRXK DVB-C)...
> Jul 15 00:52:52 darkstar kernel: [  188.912424] DVB: registering adapter 5 frontend 0 (DRXK DVB-T)...
> 
> When trying to tune, the log is flooded with:
> Jul 15 00:53:15 darkstar kernel: [  211.537173] drxk: Error -22 on DVBTScCommand
> Jul 15 00:53:15 darkstar kernel: [  211.538206] drxk: Error -22 on DVBTStart
> Jul 15 00:53:15 darkstar kernel: [  211.539151] drxk: Error -22 on Start
> Jul 15 00:53:15 darkstar kernel: [  211.940231] drxk: SCU not ready
> Jul 15 00:53:15 darkstar kernel: [  211.941310] drxk: Error -5 on SetDVBT
> Jul 15 00:53:15 darkstar kernel: [  211.942243] drxk: Error -5 on Start
> Jul 15 00:53:15 darkstar kernel: [  212.340237] drxk: SCU not ready
> Jul 15 00:53:15 darkstar kernel: [  212.341286] drxk: Error -5 on SetDVBT
> Jul 15 00:53:15 darkstar kernel: [  212.342202] drxk: Error -5 on Start
> Jul 15 00:53:16 darkstar kernel: [  212.740238] drxk: SCU not ready
> ...
> 
> Unloading:
> ERROR: Module drxk is in use
> 
> lsmod:
> Module                  Size  Used by
> drxk                   47332  2
> 
> 
> Sorry, I currently do not have the time to dig through your changesets.
> 
> With these bugs the driver is unusable and not ready for the kernel.
> 
> I hereby NACK submission of the driver to the kernel!
> 
> CU
> Oliver
> 


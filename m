Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KfLfe-00028O-EP
	for linux-dvb@linuxtv.org; Mon, 15 Sep 2008 23:31:48 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	DA9B21801457
	for <linux-dvb@linuxtv.org>; Mon, 15 Sep 2008 21:31:06 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Paul Chubb" <paulc@singlespoon.org.au>
Date: Tue, 16 Sep 2008 07:31:06 +1000
Message-Id: <20080915213106.A786B164293@ws1-4.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] xc3028 config issue. Re: Why I need to choose
 better Subject: headers [was: Re: Why (etc.)]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> 
> Message: 5
> Date: Mon, 15 Sep 2008 16:39:24 +1000
> From: Paul Chubb <paulc@singlespoon.org.au>
> Subject: Re: [linux-dvb] xc3028 config issue. Re: Why I need to choose
> 	better Subject: headers [was: Re: Why (etc.)]
> To: Steven Toth <stoth@linuxtv.org>, linux dvb
> 	<linux-dvb@linuxtv.org>, 	mchehab@infradead.org
> Message-ID: <48CE031C.1000805@singlespoon.org.au>
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
> 
> Steven Toth wrote:
> >
> > Mauro, see question below.
> >
> > Paul Chubb wrote:
> >> Steven Toth wrote:
> >>> Paul Chubb wrote:
> >>>> Barry,
> >>>> I drew the line at porting the xc3028 tuner module from mcentral.de into v4l-dvb, so no 
> >>>> didn't solve the firmware issues. If you know what you are doing it should be trivial work 
> >>>> - just linking in yet another tuner module and then calling it like all the others. For me 
> >>>> because I don't know the code well it would take a week or two.
> >>>
> >>> No porting required.
> >>>
> >>> xc3028 tuner is already in the kernel, it should just be a case of configuring the 
> >>> attach/config structs correctly.
> >>>
> >>> - Steve
> >>>
> >> Steve,
> >>           I think we are talking about two different things. Yes the xc3028 tuner is 
> >> supported via tuner-xc2028 and works for many xc3028 based cards. This support uses the 
> >> xc3028-v27.fw file that contains say 80 firmware modules. This firmware was extracted from a 
> >> Haupage windows driver.
> >
> > Correct.
> >
> > (I changed the subject by the way)
> >
> >>
> >> I believe that the 1800H has some incompatibility with this firmware. The mcentral.de tree 
> >> has a different firmware loading and tuner support module for xc3028 that loads individual 
> >> firmware modules - you literally put twenty or thirty files into /lib/firmware. This firmware 
> >> is the standard firmware from xceive before the card manufacturers get to it. Comparing the 
> >> dmesg listing from a working mcentral.de setup and the non-working v4l tree the only thing 
> >> that leaps out is the different firmware. If I was continuing the next step would be to port 
> >> that tuner module into the v4l code and set it up in the normal way.
> >
> > the v27.fw file does contain the correct firmware, so the fact that the inkernel tuner driver 
> > isn't select the correct version (or that it needs a hint in the config struct) is probably a 
> > very small fix.
> >
> > Mauro (cc'd) generally maintains that driver and he should be able to help. My suggestion is 
> > that you cut/paste the attach/config struct from your leadtek code into this email thread. 
> > From you email address I guess you're trying to get DVB-T 7MHz working in Australia. Mauro can 
> > review it.
> >
> > Ideally, we'd point you at a different card struct for the same tuner that we know works in 
> > Australia, so you build the leadtek config struct based on something that we know works.
> >
> > Mauro, what should the attach/config struct look like for a xc2028/3028 tune in Australia? Can 
> > you point to a working example or suggest a change?
> >
> > Regards,
> >
> > - Steve
> >
> >
> >
> >
> static struct zl10353_config cx88_dtv1800h = {
>         .demod_address = (0x1e >> 1),
>         .no_tuner = 1,
> };
> 
> case CX88_BOARD_WINFAST_DTV1800H:
>                  dev->dvb.frontend = dvb_attach(zl10353_attach,
>                                                 &cx88_dtv1800h,
>                                                 &dev->core->i2c_adap);
>                  if (dev->dvb.frontend != NULL) {
>                     struct dvb_frontend *fe;
>                     struct xc2028_config cfg = {
>                        .i2c_adap  = &dev->core->i2c_adap,
>                        .i2c_addr  = 0x61,
>                        .video_dev = dev->core,
>                                  .callback  = cx88_xc3028_callback,
>                     };
>                     static struct xc2028_ctrl ctl = {
>                        .fname       = "xc3028-v27",
>                        .max_len     = 64,
>                    };
> 
>                    fe = dvb_attach(xc2028_attach, dev->dvb.frontend, &cfg);
>                    if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
>                        fe->ops.tuner_ops.set_config(fe, &ctl);
>                 }
>                 dev->dvb.frontend->ops.i2c_gate_ctrl = NULL;
>                 dev->dvb.frontend->ops.sleep = NULL;
>                 break;
> 
> This produces the following dmesg when attempting to scan
> 
---Snip---


Paul,

Here is the config I used for the DViCO Dual DVB Express, Leadtek Winfast PxDVR 3200 H and most of the Compro VideoMate E series. Note that this in the cx23885 driver. I live in Melbourne so it does definitely work with Australian frequencies.  As all these cards have the same demod and tuner it should be pretty similar config structs.

Key differences that may effect you are:
* .fname - I have the .fw after the file, but I don't think this is your problem as it loads the firmware from the file.
* .demod - XC3028_FE_ZARLINK456, this hepls the firmware loader load the correct firmware. Definitely try this one.

case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP: {
		i2c_bus = &dev->i2c_bus[port->nr - 1];

		port->dvb.frontend = dvb_attach(zl10353_attach,
					       &dvico_fusionhdtv_xc3028,
					       &i2c_bus->i2c_adap);
		if (port->dvb.frontend != NULL) {
			struct dvb_frontend      *fe;
			struct xc2028_config	  cfg = {
				.i2c_adap  = &i2c_bus->i2c_adap,
				.i2c_addr  = 0x61,
				.video_dev = port,
				.callback  = cx23885_tuner_callback,
			};
			static struct xc2028_ctrl ctl = {
				.fname       = "xc3028-v27.fw",
				.max_len     = 64,
				.demod       = XC3028_FE_ZARLINK456,
			};

			fe = dvb_attach(xc2028_attach, port->dvb.frontend,
					&cfg);
			if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
				fe->ops.tuner_ops.set_config(fe, &ctl);
		}
		break;

I hope this helps.

Regards,
Stephen.



-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

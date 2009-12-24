Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:62246 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbZLXQYr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2009 11:24:47 -0500
Subject: Re: [ivtv-devel] PVR150 Tinny/fuzzy audio w/ patch?
From: Andy Walls <awalls@radix.net>
To: Martin Dauskardt <martin.dauskardt@gmx.de>
Cc: linux-media@vger.kernel.org,
	Argus <pthorn-ivtvd@styx2002.no-ip.org>,
	Chris Kennedy <ivtv@groovy.org>,
	Moasat <ivtv@moasat.dyndns.org>, Mike Isely <isely@isely.net>,
	isely@pobox.com, Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>
In-Reply-To: <200912061944.43481.martin.dauskardt@gmx.de>
References: <mailman.1.1260010802.13507.ivtv-devel@ivtvdriver.org>
	 <200912061944.43481.martin.dauskardt@gmx.de>
Content-Type: text/plain
Date: Thu, 24 Dec 2009 11:23:09 -0500
Message-Id: <1261671789.12520.14.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Martin,

(Moving discussion to the linux-media list since the ivtv-devel list was
unresponsive/dead recently.)

On Sun, 2009-12-06 at 19:44 +0100, Martin Dauskardt wrote:
> > From: Andy Walls <awalls@radix.net>
> > Martin,
> > 
> > It is not "turning the digitizer on/off" but really "enable/disable the
> > clock output pins of the digitizer".  The cause of the tinny audio is
> > likely that the clock pins from the CX2584x are floating.
> > 
> > This call makes sure the clock output enables are turned on and the pins
> > are not floating.  I suspect no where else are they explciity enabled in
> > the driver before the first capture (I can go back and verify).
> > 
> > > I am only a hobbyist, so please forgive me if there is an error ...
> > 
> > No that's fine too; as long as *somewhere* in the ivtv driver we turn on
> > the CX2584x's output enables before the first capture.
> > 
> 
> It really seems that no where else the clock output pins are enabled. I did 
> not find another s_stream call to the digitizer. But amazing: Even I comment 
> out the line
> v4l2_subdev_call(itv->sd_video, video, s_stream, 1);
> the stream starts most of the time (but fails occasionally).
> 
> You wrote "I suspect that these signals floating cause the CX23416 to make 
> some bad guesses about audio sample rate when CX2341X_ENC_INTIALIZE_INPUT is
> called. "
> Then we have to enable the digitizer before CX2341X_ENC_INTIALIZE_INPUT.
> 
> But the first patch from Argus -which helped him to solve the problem- does 
> not enable the output. So this is either not necessary or the real problem is 
> something else. (I made a lot of testing with a PVR150 and an unpatched driver 
> and had never any audio problems)
> 
> Unfortunately there was a mistake in my last code. The if-statement has to be 
> in additionally brackets, otherwise it is never true and the digitizer is not 
> disabled for saa7115-based card.
> 
> I tested this code now with PVR150 and PVR350:
> 
>         if (atomic_read(&itv->capturing) == 0) {
>                 /* Clear all Pending Interrupts */
>                 ivtv_set_irq_mask(itv, IVTV_IRQ_MASK_CAPTURE);
> 
>                 clear_bit(IVTV_F_I_EOS, &itv->i_flags);
> 
>                 /* Turn off non-cx25840 digitizer to avoid flickering */
>                 if (!(itv->sd_video->grp_id & IVTV_HW_CX25840)) {
>                         v4l2_subdev_call(itv->sd_video, video, s_stream, 0);
>                 }
>                 else {
>                 /* make sure the cx25840 clock output pins are enabled and not 
> floating */
>                         v4l2_subdev_call(itv->sd_video, video, s_stream, 1);
>                 }
> 
>                 ivtv_vapi(itv, CX2341X_ENC_INITIALIZE_INPUT, 0);
> 
>                 /* Turn on non-cx25840 digitizer and allow clock
>                    output of the digitizer to stabilize before starting 
> capture */
>                 if (!(itv->sd_video->grp_id & IVTV_HW_CX25840)) {
>                         v4l2_subdev_call(itv->sd_video, video, s_stream, 1);
>                         ivtv_msleep_timeout(300, 1);
>                 }
>         }
> 
> You mentioned that the 300ms sleep is probably needed for the clock output of 
> the digitizer to stabilize. For me it seems more logical  if this is done 
> after ***enabling*** the digitizer output, so I moved this. It seems to work 
> fine.
> 
> I made a similar test with the pvrusb2 driver (which has a black video problem 
> and currently no timeout sleep after the digitizer switches). There it works 
> better when we place the sleep after re-enabling the digitizer. So I think the 
> above solution should be right.
> 
> I also tested if we can avoid disabling the digitizer for saa7115. Both 
> pvrusb2 (old model 29xxx) and PVR350 show disturbance (sync problems) when 
> stopping/starting a stream. This leads to flickering with cx23415 (PVR350). 
> The cx23416 has no flickering problem, but it is annoying to see sync problems 
> during channel switches. 
> The cx25840 devices (PVR150 and the pvrusb2-based HVR1900) do not show these 
> problems. The connection to the cx23416 must be different - the new stream 
> appears always without any snc issues.
> 
> Suggestion: 
> We need more testers to see if a driver change like above is safe for 
> everybody. Even if it turns out that it is no reliable fix against tinny 
> audio, it improves the speed for encoder stop/start on cx25840 devices.
> I don't know if Myth is stopping/starting the stream for every channel switch, 
> but for vdr (pvrinput-plugin) we are doing this. And there I recognize that 
> channel switching is faster now with cx25840 devices.      
> 
> And we shouldn't do anything without hearing Hans.... Hans, where are you?
> 
> Greets,
> Martin

I have a version of the change for the ivtv/PVR-150 tinny audio fix at

	http://linuxtv.org/hg/~awalls/v4l-dvb-bugfix
	http://linuxtv.org/hg/~awalls/v4l-dvb-bugfix/rev/7753cdcebd28


It separates out the enable/disable of audio & video streaming from each
other for the cx25840 module.  Then the ivtv driver can set them
independently to avoid both the unpredictable PCI hang and the tinny
audio in a very generic way.  Please test when you can.


Hans,

This touches the v4l2_subdev_audio_ops to add a s_stream operatrion for
audio.

Steve,

This change should  not affect the cx231xx and cx23885 modules as they
only use s_stream to affect a very minor change in the video output, and
leave audio alone.

Mike,

I had to add another subdev call to pvrusb2 to get the same end result
of s_stream calls to the cx25840 module.

Regards,
Andy


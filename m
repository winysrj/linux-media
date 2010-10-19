Return-path: <mchehab@pedra>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:46152 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0JSV5h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 17:57:37 -0400
Received: from TheShoveller.local
 (ool-4572125f.dyn.optonline.net [69.114.18.95]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0LAK001WC3LZZ1H0@mta1.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 19 Oct 2010 17:27:36 -0400 (EDT)
Date: Tue, 19 Oct 2010 17:27:35 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx23885 module
In-reply-to: <BLU0-SMTP179D180C75C88F1B693AA73A75A0@phx.gbl>
To: Daniel Lee Kim <danlkim@hotmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4CBE0D47.7080201@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <BLU0-SMTP179D180C75C88F1B693AA73A75A0@phx.gbl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Dan,

Thanks for writing.

I can't do one-on-one end user support without copying in the Linux Media 
mailing list. I'm taking the liberty of doing so. Please reply-all when 
discussing this issue - so everyone can benefit.

[Dan is having issues being up an AverMedia board with a LG demod and a MT2131 
tuner via the cx23885 driver]

> However, I am having some trouble getting the tuner to be recognized. I was

It's the GPIO probably holding the tuner in reset, I suspect your gpio 
configuration is wrong. That's my first guess. What makes you think the gpio 
settings in your patch are correct?

> hoping that you might be willing to look over the code a bit to see what I am
> missing. I have altered the following 3 files: cx23885.h, cx23885-cards.c, and
> cx23885-dvb.c. I am attaching the 3 files in this email. I have been trying to
> do 3 things. First, to have the module auto-detect my card which was successful.
> Second, I wanted to attach the LGDT330X as my frontend which was successful.
> Third, I wanted to attach the MT2131 tuner. This third step is where I am having
> my troubles. I feel so close but I am not there yet. I know that you wrote the
> code a while back but if you would be willing to help me, I'd really appreciate
> it. Some folks have gotten the ngene module to work with the M780 board which

Yeah, I worked on the ngene with Devin as part of our KernelLabs.com projects, 
we brought up the digital side of the card as a pre-test while investigating 
ngene analog support.

If the 2131 isn't attaching then it's because you think it's on a different I2C 
bus, or the LG demod has it's I2C gate closed (unlikely) or the tuner is not 
responding because it's being held in reset.

Do you see the tuner if you perform and I2C scan (modprobe i2c_scan=1)?

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com



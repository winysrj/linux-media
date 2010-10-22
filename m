Return-path: <mchehab@pedra>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:61528 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab0JVNGR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 09:06:17 -0400
Received: from [IPv6:::1] (ool-4572125f.dyn.optonline.net [69.114.18.95])
 by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0LAP00KZW0EFQJL0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Fri, 22 Oct 2010 09:06:15 -0400 (EDT)
Date: Fri, 22 Oct 2010 09:06:15 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx23885 module
In-reply-to: <SNT130-w25B4AAC1A5FC7F00372440A75E0@phx.gbl>
To: Daniel Lee Kim <danlkim@hotmail.com>
Cc: linux-media@vger.kernel.org
Message-id: <4CC18C47.9070305@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <BLU0-SMTP179D180C75C88F1B693AA73A75A0@phx.gbl>
 <4CBE0D47.7080201@kernellabs.com>
 <BLU0-SMTP3076739B1A745CCB3563D3A75C0@phx.gbl>
 <4CBF57F3.1000008@kernellabs.com> <SNT130-w25B4AAC1A5FC7F00372440A75E0@phx.gbl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/22/10 9:02 AM, Daniel Lee Kim wrote:
> Steve,
>
>
>  > > [ 3072.621974] MT2131: successfully identified at address 0x60
>
> Would the above message indicate that the tuner has been taken out of reset mode?

Yes.

>  > It's probably the I/F (intermediate frequency) between the
>  > MT2131 and the LG3305 is incorrect, so the demod does not see the RF correctly
>  > from the tuner. Try stepping the LG I/F through it's various combination (see
>  > the LG header .h file) then repeat the test with spectral inversion inverted.
>  >
>  > Use azap to tune during each test and watch for status bits 0x1f (meaning the
>  > demod is locked).
>  >
>  > If no lock, adjust the I/F and/or spectral inversion and try again.
>  >
>  > - Steve
>
> Are you suggesting that the above test might resolve the issue of not being able
> to tune using the MT2131? I'll take a look at the LG header though I'm using the
> LGDT330X driver since mine is the 3303 chip.

Yes.

>
> How do I know that the tuner is working? The modprobe i2c_scan=1 returned a
> fatal error, not found. Is there another way to test it?

If the MT2131 was detected then it's probably working. modprobe cx23885 
i2c_scan=1 should work and show a tuner at address 0xC0, 2 or 4 etc.

>
> One more question, is there a place I can go to learn how to compile just the
> cx23885.ko module? I am not able to compile only that module and so I have to
> wait until it compiles all the modules. I apologize as this is my first time
> tweaking a driver module. I've searched all over the net but have not found
> anyone who wrote about this. Thanks,

The wiki at linuxtv.org should contain everything you need for compiling, 
modifying and submitting patches.

Regards,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com


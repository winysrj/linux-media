Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638Ab2EFSRK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 May 2012 14:17:10 -0400
Message-ID: <4FA6C024.9090408@redhat.com>
Date: Sun, 06 May 2012 20:17:08 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: gspca zc3xx - JPEG quality / frame overflow
References: <20120505205409.312e271f@tele>
In-Reply-To: <20120505205409.312e271f@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/05/2012 08:54 PM, Jean-Francois Moine wrote:
> Hi Hans,
>
> I quickly looked at your patches about the changes for the JPEG
> quality, and I have some remarks.
>
> Indeed, as I don't have any zc3xx webcam nor a lot of documentation
> about the zc3xx bridge, my information come only from USB trace
> analysis, and I am not sure there are fully valid.

I think you've done a very good job given that you've only used traces!

I do have a datasheet now a days (for the VC0302) which is where I got
the information mentioned in the commit messages. Unfortunately I'm not
at liberty to share the datasheet. But if you've questions about any
other registers feel free to ask and I'll try to answer them.

> - the register 08 always have values 0..3 (bits 0 and 1). I never saw
>    the bits 2 or 3 set when the frame transfer regulation is active.

Note that my patch is not setting bit 3 either. I'm not surprised
that you've never seen bit 2 get set, that means a JPEG quality of either
87% or 94% which leads to way too much bandwidth usage. But setting bit
2 is a valid setting (note that later on in my patchset I disable
the 94 setting completely as it is simply unusable).

> - when frame overflows occur or disappear, the register 07 is always
>    updated before the register 08. There are bug fixes about the setting
>    of the registers 07 and 08 in my gspca test tarball 2.15.17.

As said in the patches I see no need to change register 8 when we detect
overflows, at the default quality of 75% BRC (bit rate control, the zc3xx
feature controlled by register 7) is almost never necessary, and even at a
setting of 87%, the BRC does a good job of keeping things working without
any visible image quality degrading (unlike at 94% where BRC also keeps
things working but the image is very much degraded).

Also changing register 8 while streaming leaves to clearly visible
flashing of the video stream, which is not good, esp. not when caused
by automatic adjustments.

I've not looked at your bugfixes, but I do know that the code before
my patches is buggy. I first noticed this when I tried the jpeg quality
controls on a camera with a sensor other then the hv7131r or pas202b,
and 2 out of 4 settings were good, and the other 2 were wrong, and it
seemed as if 2 out of 4 settings (the ones only changing bit 0) did
not make any quality difference.

Then I remembered I have a datasheet and looked up the register,
and indeed bit 0 of reg 8 does not affect the quantization tables
used. Where as bit 1 and 2 do.

The datasheet is also where the change of quality at reg8 == 3 from
70 to 75 comes from, its hard to see the difference, but the datasheet
says 75% is correct.

As for setting reg07, if you look at my patches you'll see that the
resulting code for controlling reg07 is much simpler.

So all in all I think my new code is a big improvement, please let me
know if you see anything specific there which you think should be
improved.

> - as it is (read the register 11 every 100 ms), the work queue is
>    usefull when there is no polling of the snapshot button, because the
>    frame overflow is reported as the bit 0 in the forth byte (data[3])
>    of the interrupt messages.

Interesting, so if the interrupt is enabled, then as soon as an overflow
happens, we get notified through the interrupt data?

That may be an alternative to the worker thread, although the current
solution does work rather well, so I wonder if we should meddle with it.

>    In fact, in the traces I have, only the webcams which don't do button
>    polling by interrupt messages have to read the register 11. Why only
>    when the sensor is hv7131r or pas202b?

I've seen the camera being unable to produce an image due to bandwidth
issues with other sensors too (at 87% quality), and enabling brc for those
sensors fixed it too. Since brc and quality are pure bridge settings and
not really sensor specific at all I've enabled it for all sensors,
simplifying the code and I believe this is better.

I've tested my changes with the following cams:

Creative WebCam NX Pro          041e:401e       zc3xx   HV7131B
Creative WebCam Notebook        041e:401f       zc3xx   TAS5130C
Creative Live! Cam Video IM     041e:4053       zc3xx   TAS5130-VF250
Logitech QuickCam IM/Connect    046d:08d9       zc3xx   HV7131R
Logitech QuickCam E2500         046d:089d       zc3xx   MC501CB
Labtec notebook cam             046d:08aa       zc3xx   PAS202B
Philips SPC 200NC               0471:0325       zc3xx   PAS106
No brand                        0ac8:307b       zc3xx   ADCM2700

Regards,

Hans

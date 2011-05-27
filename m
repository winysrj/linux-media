Return-path: <mchehab@pedra>
Received: from nm10-vm1.bullet.mail.sp2.yahoo.com ([98.139.91.199]:29256 "HELO
	nm10-vm1.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758637Ab1E0Cqw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 22:46:52 -0400
Message-ID: <514198.1853.qm@web112012.mail.gq1.yahoo.com>
Date: Thu, 26 May 2011 19:46:51 -0700 (PDT)
From: Chris Rodley <carlighting@yahoo.co.nz>
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with power managament.
To: javier Martin <javier.martin@vista-silicon.com>
Cc: beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	koen@beagleboard.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 26/05/11 19:24, javier Martin wrote:

> On 25 May 2011 15:38, Koen Kooi <koen@beagleboard.org> wrote:
>> >
>> > Op 25 mei 2011, om 13:16 heeft Javier Martin het volgende geschreven:
>> >
>>> >> It includes several fixes pointed out by Laurent Pinchart. However,
>>> >> the BUG which shows artifacts in the image (horizontal lines) still
>>> >> persists. It won't happen if 1v8 regulator is not disabled (i.e.
>>> >> comment line where it is disabled in function "mt9p031_power_off").
>>> >> I know there can be some other details to fix but I would like someone
>>> >> could help in the power management issue.
>> >
>> > I tried this + your beagle patch on 2.6.39 and both ISP and sensor being builtin to the kernel, I get the following:
>> >
>> > root@beagleboardxMC:~# media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1 ], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>> > Resetting all links to inactive
>> > Setting up link 16:0 -> 5:0 [1]
>> > Setting up link 5:1 -> 6:0 [1]
>> >
>> > root@beagleboardxMC:~# media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3  ISP CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
>> > Setting up format SGRBG12 320x240 on pad mt9p031 2-0048/0
>> > Format set: SGRBG12 320x240
>> > Setting up format SGRBG12 320x240 on pad OMAP3 ISP CCDC/0
>> > Format set: SGRBG12 320x240
>> > Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/0
>> > Format set: SGRBG8 320x240
>> > Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/1
>> > Format set: SGRBG8 320x240
>> >
>> > oot@beagleboardxMC:~# yavta -f SGRBG8 -s 320x240 -n 4 --capture=10 --skip 3 -F  `media-ctl -e "OMAP3 ISP CCDC output"`
>> > Device /dev/video2 opened.
>> > Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
>> > Video format set: SGRBG8 (47425247) 320x240 buffer size 76800
>> > Video format: SGRBG8 (47425247) 320x240 buffer size 76800
>> > 4 buffers requested.
>> > length: 76800 offset: 0
>> > Buffer 0 mapped at address 0x4030d000.
>> > length: 76800 offset: 77824
>> > Buffer 1 mapped at address 0x40330000.
>> > length: 76800 offset: 155648
>> > Buffer 2 mapped at address 0x4042d000.
>> > length: 76800 offset: 233472
>> > Buffer 3 mapped at address 0x40502000.
>> > [ 4131.459930] omap3isp omap3isp: CCDC won't become idle!
> Please, test it again using new RFC v3 I've just submitted.
> I have personally tested it against kernel 2.6.39 with the following
> .config file:

Hi,

No improvements here for me with v3.
Still:

# yavta --stdout -f SGRBG8 -s 320x240 -n 4 --capture=100 --skip 3 -F `media-ctl -e "OMAP3 ISP CCDC output"` | nc 10.1.1.16 3000
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: width: 320 height: 240 buffer size: 76800
Video format: GRBG (47425247) 320x240
4 buffers requested.
length: 76800 offset: 0
Buffer 0 mapped at address 0x400d8000.
length: 76800 offset: 77824
Buffer 1 mapped at address 0x40292000.
length: 76800 offset: 155648
Buffer 2 mapped at address 0x40345000.
length: 76800 offset: 233472
Buffer 3 mapped at address 0x40377000.

Will wait and see if Koen finds anything.

Cheers,
Chris


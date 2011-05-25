Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34945 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1EYHAW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 03:00:22 -0400
Received: by iyb14 with SMTP id 14so5939587iyb.19
        for <linux-media@vger.kernel.org>; Wed, 25 May 2011 00:00:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <551158.38796.qm@web112009.mail.gq1.yahoo.com>
References: <551158.38796.qm@web112009.mail.gq1.yahoo.com>
Date: Wed, 25 May 2011 09:00:21 +0200
Message-ID: <BANLkTi=7mssSFd=HYwVReoKw6VEC_Qvs0Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] MT9P031: Add support for Aptina mt9p031 sensor.
From: javier Martin <javier.martin@vista-silicon.com>
To: Chris Rodley <carlighting@yahoo.co.nz>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	beagleboard@googlegroups.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Please, do not remove anyone from the CC list.

On 25 May 2011 05:45, Chris Rodley <carlighting@yahoo.co.nz> wrote:
> Hi,
>
> Have upgraded the driver to Javier's latest RFC driver.
> Still having problems viewing output.
>
> Setting up with:
> # media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> Resetting all links to inactive
> Setting up link 16:0 -> 5:0 [1]
> Setting up link 5:1 -> 6:0 [1]
>
> # media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3 ISP CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
> Setting up format SGRBG12 320x240 on pad mt9p031 2-0048/0
> Format set: SGRB
> Setting up format SGRBG12 320x240 on pad OMAP3 ISP CCDC/0
> Format set: SGRBG12 320x240
> Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/0
> Format set: SGRBG8 320x240
> Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/1
> Format set: SGRBG8 320x240
>
> Then:
> # yavta -f SGRBG8 -s 320x240 -n 4 --capture=100 -F /dev/video2
> Device /dev/video2 opened.
> Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
> Video format set: width: 320 height: 240 buffer size: 76800
> Video format: GRBG (47425247) 320x240
> 4 buffers requested.
> length: 76800 offset: 0
> Buffer 0 mapped at address 0x4006c000.
> length: 76800 offset: 77824
> Buffer 1 mapped at address 0x40222000.
> length: 76800 offset: 155648
> Buffer 2 mapped at address 0x4025e000.
> length: 76800 offset: 233472
> Buffer 3 mapped at address 0x402f0000.
>
> After this it hangs and will exit on 'ctrl c':
> omap3isp omap3isp: CCDC stop timeout!
>
> Any ideas what is causing this problem?
>

No idea,
it works for me. Note you have to apply RFC + PATCH v2 2/2. Please,
double check.

Also, if you have problems with last RFC patch you should answer RFC
mail. Not this one.

Thank you.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com

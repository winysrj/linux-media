Return-path: <linux-media-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:38792 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab1K1JUI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 04:20:08 -0500
Message-ID: <4ED34FBF.30902@cit-ec.uni-bielefeld.de>
Date: Mon, 28 Nov 2011 10:09:19 +0100
From: Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>
MIME-Version: 1.0
To: whittenburg@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: mt9p031 on omap3530, no interrupts from ISP
References: <CABcw_O=YQqwXp1h4qLPpQ5zX0Y6xvfih3e_FMuMUDhD2Qz_Vpw@mail.gmail.com>
In-Reply-To: <CABcw_O=YQqwXp1h4qLPpQ5zX0Y6xvfih3e_FMuMUDhD2Qz_Vpw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 27.11.2011 19:32, schrieb Chris Whittenburg:
> I'm using the 3.0.8 kernel, with a few changes to add support for
> mt9p031 on a beagleboard xm.
>
> I'm configuring with:
>
> media-ctl -v -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>
> media-ctl -v -f '"mt9p031 2-0048":0[SGRBG12 370x243], "OMAP3 ISP
> CCDC":0[SGRBG12 370x243], "OMAP3 ISP CCDC":1[SGRBG12 370x243]'
>
> and then running:
>
> yavta -f SGRBG12 -s 368x243 -n 4 --capture=10 --skip 3 -F `media-ctl
> -e "OMAP3 ISP CCDC output"`
>
> Which hangs trying to de-queue a buffer:
>
> root@beagleboard:~# yavta -f SGRBG12 -s 368x243 -n 4 --capture=10
> --skip 3 -F `media-ctl -e "OMAP3 ISP CCDC output"`
> Device /dev/video2 opened.
> Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
> Video format set: SGRBG12 (32314142) 368x243 buffer size 178848
> Video format: SGRBG12 (32314142) 368x243 buffer size 178848
> 4 buffers requested.
> length: 178848 offset: 0
> Buffer 0 mapped at address 0x4023d000.
> length: 178848 offset: 180224
> Buffer 1 mapped at address 0x402b9000.
> length: 178848 offset: 360448
> Buffer 2 mapped at address 0x4039e000.
> length: 178848 offset: 540672
> Buffer 3 mapped at address 0x40435000.
>
> Communication is good with the mt9p031, and I can see pclk, and
> signals on the data lines, but I don't seem to be getting any
> interrupts from the ISP.
>
> Any pointers on what I should check?
Do you have the cam_xclk always enabled?

The isp only works if you set the cam_xclk to zero, when you don't use 
the camera.


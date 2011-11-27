Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46408 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1K0ScS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 13:32:18 -0500
Received: by bke11 with SMTP id 11so7340518bke.19
        for <linux-media@vger.kernel.org>; Sun, 27 Nov 2011 10:32:17 -0800 (PST)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
Date: Sun, 27 Nov 2011 12:32:17 -0600
Message-ID: <CABcw_O=YQqwXp1h4qLPpQ5zX0Y6xvfih3e_FMuMUDhD2Qz_Vpw@mail.gmail.com>
Subject: mt9p031 on omap3530, no interrupts from ISP
From: Chris Whittenburg <whittenburg@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm using the 3.0.8 kernel, with a few changes to add support for
mt9p031 on a beagleboard xm.

I'm configuring with:

media-ctl -v -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'

media-ctl -v -f '"mt9p031 2-0048":0[SGRBG12 370x243], "OMAP3 ISP
CCDC":0[SGRBG12 370x243], "OMAP3 ISP CCDC":1[SGRBG12 370x243]'

and then running:

yavta -f SGRBG12 -s 368x243 -n 4 --capture=10 --skip 3 -F `media-ctl
-e "OMAP3 ISP CCDC output"`

Which hangs trying to de-queue a buffer:

root@beagleboard:~# yavta -f SGRBG12 -s 368x243 -n 4 --capture=10
--skip 3 -F `media-ctl -e "OMAP3 ISP CCDC output"`
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: SGRBG12 (32314142) 368x243 buffer size 178848
Video format: SGRBG12 (32314142) 368x243 buffer size 178848
4 buffers requested.
length: 178848 offset: 0
Buffer 0 mapped at address 0x4023d000.
length: 178848 offset: 180224
Buffer 1 mapped at address 0x402b9000.
length: 178848 offset: 360448
Buffer 2 mapped at address 0x4039e000.
length: 178848 offset: 540672
Buffer 3 mapped at address 0x40435000.

Communication is good with the mt9p031, and I can see pclk, and
signals on the data lines, but I don't seem to be getting any
interrupts from the ISP.

Any pointers on what I should check?

Thanks,
Chris

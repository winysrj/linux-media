Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36294 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab1JRNdg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 09:33:36 -0400
Received: by iaek3 with SMTP id k3so778150iae.19
        for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 06:33:36 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 18 Oct 2011 16:33:35 +0300
Message-ID: <CAFYgh7z4r+oZg4K7Zh6-CTm2Th9RNujOS-b8W_qb-C8q9LRr2w@mail.gmail.com>
Subject: omap3isp: BT.656 support
From: Boris Todorov <boris.st.todorov@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I'm trying to run OMAP + TVP5151 in BT656 mode.

I'm using omap3isp-omap3isp-yuv (git.linuxtv.org/pinchartl/media.git).
Plus the following patches:

TVP5151:
https://github.com/ebutera/meta-igep/tree/testing-v2/recipes-kernel/linux/linux-3.0+3.1rc/tvp5150

The latest RFC patches for BT656 support:

Enrico Butera (2):
  omap3isp: ispvideo: export isp_video_mbus_to_pix
  omap3isp: ispccdc: configure CCDC registers and add BT656 support

Javier Martinez Canillas (1):
  omap3isp: ccdc: Add interlaced field mode to platform data


I'm able to configure with media-ctl:

media-ctl -v -r -l '"tvp5150 3-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3
ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
media-ctl -v --set-format '"tvp5150 3-005c":0 [UYVY2X8 720x525]'
media-ctl -v --set-format '"OMAP3 ISP CCDC":0 [UYVY2X8 720x525]'
media-ctl -v --set-format '"OMAP3 ISP CCDC":1 [UYVY2X8 720x525]'

But
./yavta -f UYVY -s 720x525 -n 4 --capture=4 -F /dev/video4

sleeps after
...
Buffer 1 mapped at address 0x4021d000.
length: 756000 offset: 1515520
Buffer 2 mapped at address 0x402d6000.
length: 756000 offset: 2273280
Buffer 3 mapped at address 0x4038f000.

Anyone with the same issue??? This happens with every other v4l test app I used.
I can see data from TVP5151 but there are no interrupts in ISP.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:40112 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab2AKTrP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 14:47:15 -0500
Received: from localhost (unknown [88.169.254.133])
	by smtp1-g21.free.fr (Postfix) with ESMTP id B7A6D9401CF
	for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 20:47:07 +0100 (CET)
Date: Wed, 11 Jan 2012 20:47:12 +0100
From: Trinine <trinine@free.fr>
To: Liste de diffusion linux-media <linux-media@vger.kernel.org>
Subject: Winfast DV2000 card remote control
Message-ID: <20120111204712.2ab21128@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have a Winfast DV2000 card ( this one:
http://www.leadtek.com/eng/multimedia/overview.asp?lineid=6&pronameid=92&check=f
). This card is bundled with a remote named Y0400046 (picture here :
http://old.nabble.com/attachment/24449803/0/Winfast_remote.jpg ) which
is not recognized by the Linux kernel.

The remote is the only feature that I want to use, I got to make it
work correctly by simply using this patch:

--8<--

--- /usr/src/linux/drivers/media/video/cx88/cx88-input.c.old
+++ /usr/src/linux/drivers/media/video/cx88/cx88-input.c.new
@@ -302,6 +302,7 @@
 	case CX88_BOARD_WINFAST2000XP_EXPERT:
 	case CX88_BOARD_WINFAST_DTV1000:
 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
+	case CX88_BOARD_WINFAST_DV2000:
 		ir_codes = RC_MAP_WINFAST;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;

--8<--

The only bug I found is the one described here:
http://www.spinics.net/lists/vfl/msg35108.html
So I just have to unload the CX8800 module before hibernation (and
reload it after resume).

Cheers,

T.

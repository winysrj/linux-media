Return-path: <linux-media-owner@vger.kernel.org>
Received: from vint.altlinux.org ([194.107.17.35]:60560 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZL1Ue4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2009 15:34:56 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vint.altlinux.org (Postfix) with ESMTP id D79183F80219
	for <linux-media@vger.kernel.org>; Mon, 28 Dec 2009 20:24:48 +0000 (UTC)
To: linux-media@vger.kernel.org
Subject: cx18: leadtec pvr 2100 card fix
From: Sergey Bolshakov <sbolshakov@altlinux.ru>
Date: Mon, 28 Dec 2009 23:22:18 +0300
Message-ID: <m31vieyhl1.fsf@hammer.lioka.obninsk.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=


Hi.
Seems cx18 module has incorrect .xceive_pin value for card,
as i see lots of i2c errors in dmesg from xc2028.
i'm using 2.6.32.2, my hardware is:

# lspci -vnns 00:09.0
00:09.0 Multimedia video controller [0400]: Conexant Systems, Inc. CX23418 Single-Chip MPEG-2 Encoder with Integrated Analog Video/Broadcast Audio Decoder [14f1:5b7a]
        Subsystem: LeadTek Research Inc. Device [107d:6f27]
        Flags: bus master, medium devsel, latency 64, IRQ 17
        Memory at f0000000 (32-bit, non-prefetchable) [size=64M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: cx18
        Kernel modules: cx18

Following fixes this problem for me, the rest seems working:


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=pvr2100.diff

diff --git a/drivers/media/video/cx18/cx18-cards.c b/drivers/media/video/cx18/cx18-cards.c
index f11e47a..f808fb6 100644
--- a/drivers/media/video/cx18/cx18-cards.c
+++ b/drivers/media/video/cx18/cx18-cards.c
@@ -393,7 +393,7 @@ static const struct cx18_card cx18_card_leadtek_pvr2100 = {
 	.gpio_init.direction = 0x7,
 	.gpio_audio_input = { .mask   = 0x7,
 			      .tuner  = 0x6, .linein = 0x2, .radio  = 0x2 },
-	.xceive_pin = 15,
+	.xceive_pin = 1,
 	.pci_list = cx18_pci_leadtek_pvr2100,
 	.i2c = &cx18_i2c_std,
 };

--=-=-=


-- 

--=-=-=--

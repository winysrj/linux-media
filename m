Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:49742 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751410Ab2DQRBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 13:01:13 -0400
From: Nils Kassube <kassube@gmx.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [Patch] bttv: Enable radio if the card description has no radio flag but the tuner has FM
Date: Tue, 17 Apr 2012 19:00:38 +0200
MIME-Version: 1.0
Message-Id: <201204171900.38809.kassube@gmx.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some bttv cards (e.g. card=24) have a tuner which can receive FM radio 
but the card description doesn't have the has_radio flag set, because 
the description is used for cards with and without FM capability. The 
function bttv_init_tuner can detect the tuner either automatically or by 
insmod option. However the original code only partly uses the detected 
tuner capabilities. While the radio device node is created, the device 
is not usable due to the wrong mode_mask. This patch uses the has_radio 
flag from the detected tuner instead of the card description.

Signed-off-by: Nils Kassube <kassube@gmx.net>

--- media_build/linux/drivers/media/video/bt8xx/bttv-cards.c.orig	
2012-04-17 15:17:55.000000000 +0200
+++ media_build/linux/drivers/media/video/bt8xx/bttv-cards.c	
2012-04-17 15:50:48.000000000 +0200
@@ -3665,7 +3665,7 @@
 		tun_setup.type = btv->tuner_type;
 		tun_setup.addr = addr;
 
-		if (bttv_tvcards[btv->c.type].has_radio)
+		if (btv->has_radio)
 			tun_setup.mode_mask |= T_RADIO;
 
 		bttv_call_all(btv, tuner, s_type_addr, &tun_setup);

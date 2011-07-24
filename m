Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44048 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1GXBRS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 21:17:18 -0400
Received: by ewy4 with SMTP id 4so2082260ewy.19
        for <linux-media@vger.kernel.org>; Sat, 23 Jul 2011 18:17:17 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 23 Jul 2011 21:17:17 -0400
Message-ID: <CAGoCfiyp4TB6RvF75WFrFLkTxha0-XKrXnR8L13BwJu938PaHg@mail.gmail.com>
Subject: [PATCH] Fix regression introduced which broke the Hauppauge USBLive 2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch addresses the regression introduced in the cx231xx
driver which stopped the Hauppauge USBLive2 from working.

Confirmed working by both myself and the user who reported the issue
on the KernelLabs blog (Robert DeLuca).

cx231xx: Fix regression introduced which broke the Hauppauge USBLive 2

From: Devin Heitmueller <dheitmueller@kernellabs.com>

At some point during refactoring of the cx231xx driver, the USBLive 2 device
became broken.  This patch results in the device working again.

Thanks to Robert DeLuca for sponsoring this work.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Robert DeLuca <robertdeluca@me.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c
b/drivers/media/video/cx231xx/cx231xx-cards.c
index 4b22afe..d02c63a 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -387,6 +387,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.norm = V4L2_STD_NTSC,
 		.no_alt_vanc = 1,
 		.external_av = 1,
+		.dont_use_port_3 = 1,
 		.input = {{
 			.type = CX231XX_VMUX_COMPOSITE1,
 			.vmux = CX231XX_VIN_2_1,

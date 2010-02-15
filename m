Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:56567 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755838Ab0BORiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 12:38:18 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 03/11] tm6000: add additional init register
Date: Mon, 15 Feb 2010 18:37:16 +0100
Message-Id: <1266255444-7422-3-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266255444-7422-2-git-send-email-stefan.ringel@arcor.de>
References: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-2-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 9d66a3f..2c9eb74 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -414,6 +414,13 @@ struct reg_init tm6010_init_tab[] = {
 
 	{ REQ_05_SET_GET_USBREG, 0x18, 0x00 },
 
+	{ REQ_07_SET_GET_AVREG, 0xdc, 0xaa },
+	{ REQ_07_SET_GET_AVREG, 0xdd, 0x30 },
+	{ REQ_07_SET_GET_AVREG, 0xde, 0x20 },
+	{ REQ_07_SET_GET_AVREG, 0xdf, 0xd0 },
+	{ REQ_04_EN_DISABLE_MCU_INT, 0x02, 0x00 },
+	{ REQ_07_SET_GET_AVREG, 0xd8, 0x2f },
+
 	/* set remote wakeup key:any key wakeup */
 	{ REQ_07_SET_GET_AVREG,  0xe5,  0xfe },
 	{ REQ_07_SET_GET_AVREG,  0xda,  0xff },
-- 
1.6.6.1


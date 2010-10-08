Return-path: <mchehab@pedra>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:11373 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759677Ab0JHVEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 17:04:16 -0400
From: Daniel Drake <dsd@laptop.org>
To: corbet@lwn.net
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/3] ov7670: remove QCIF mode
Message-Id: <20101008210412.E85769D401B@zog.reactivated.net>
Date: Fri,  8 Oct 2010 22:04:12 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This super-low-resolution mode only captures from a small portion of
the sensor FOV, making it a bit useless.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/ov7670.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index a18dcd0..7017e5c 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -618,6 +618,7 @@ static struct ov7670_format_struct {
  * which is allegedly provided by the sensor.  So here's the weird register
  * settings.
  */
+#if 0
 static struct regval_list ov7670_qcif_regs[] = {
 	{ REG_COM3, COM3_SCALEEN|COM3_DCWEN },
 	{ REG_COM3, COM3_DCWEN },
@@ -636,6 +637,7 @@ static struct regval_list ov7670_qcif_regs[] = {
 	{ REG_COM13, 0xc0 },
 	{ 0xff, 0xff },
 };
+#endif
 
 static struct ov7670_win_size {
 	int	width;
@@ -681,7 +683,8 @@ static struct ov7670_win_size {
 		.vstop		= 494,
 		.regs 		= NULL,
 	},
-	/* QCIF */
+#if 0
+	/* QCIF - disabled because it only shows a small portion of sensor FOV */
 	{
 		.width		= QCIF_WIDTH,
 		.height		= QCIF_HEIGHT,
@@ -692,6 +695,7 @@ static struct ov7670_win_size {
 		.vstop		= 494,
 		.regs 		= ov7670_qcif_regs,
 	},
+#endif
 };
 
 #define N_WIN_SIZES (ARRAY_SIZE(ov7670_win_sizes))
-- 
1.7.2.3


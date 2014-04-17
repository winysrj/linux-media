Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3758 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaDQKja (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 06:39:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 04/11] saa7134: swap ts_init_encoder and ts_reset_encoder
Date: Thu, 17 Apr 2014 12:39:07 +0200
Message-Id: <1397731154-34337-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
References: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This will make the next patch a bit easier to read.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-empress.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 07bd06c..393c9f1 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -48,17 +48,7 @@ MODULE_PARM_DESC(debug,"enable debug messages");
 
 /* ------------------------------------------------------------------ */
 
-static void ts_reset_encoder(struct saa7134_dev* dev)
-{
-	if (!dev->empress_started)
-		return;
-
-	saa_writeb(SAA7134_SPECIAL_MODE, 0x00);
-	msleep(10);
-	saa_writeb(SAA7134_SPECIAL_MODE, 0x01);
-	msleep(100);
-	dev->empress_started = 0;
-}
+static void ts_reset_encoder(struct saa7134_dev* dev);
 
 static int ts_init_encoder(struct saa7134_dev* dev)
 {
@@ -79,6 +69,18 @@ static int ts_init_encoder(struct saa7134_dev* dev)
 	return 0;
 }
 
+static void ts_reset_encoder(struct saa7134_dev* dev)
+{
+	if (!dev->empress_started)
+		return;
+
+	saa_writeb(SAA7134_SPECIAL_MODE, 0x00);
+	msleep(10);
+	saa_writeb(SAA7134_SPECIAL_MODE, 0x01);
+	msleep(100);
+	dev->empress_started = 0;
+}
+
 /* ------------------------------------------------------------------ */
 
 static int ts_open(struct file *file)
-- 
1.9.2


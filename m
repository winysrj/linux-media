Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49911 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914Ab2FUTyC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 15:54:02 -0400
Received: by mail-yx0-f174.google.com with SMTP id l2so879477yen.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 12:54:02 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Collins <bcollins@bluecherry.net>,
	<linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 10/10] staging: solo6x10: Avoid extern declaration by reworking module parameter
Date: Thu, 21 Jun 2012 16:52:12 -0300
Message-Id: <1340308332-1118-10-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch moves video_nr module parameter to core.c
and then passes that parameter as an argument to functions
that need it.
This way we avoid the extern declaration and parameter
dependencies are better exposed.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/solo6x10/core.c     |    8 ++++++--
 drivers/staging/media/solo6x10/solo6x10.h |    4 ++--
 drivers/staging/media/solo6x10/v4l2-enc.c |    9 ++++-----
 drivers/staging/media/solo6x10/v4l2.c     |    6 +-----
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
index 2cfe906..c2e3932 100644
--- a/drivers/staging/media/solo6x10/core.c
+++ b/drivers/staging/media/solo6x10/core.c
@@ -31,6 +31,10 @@ MODULE_AUTHOR("Ben Collins <bcollins@bluecherry.net>");
 MODULE_VERSION(SOLO6X10_VERSION);
 MODULE_LICENSE("GPL");
 
+unsigned int video_nr = -1;
+module_param(video_nr, uint, 0644);
+MODULE_PARM_DESC(video_nr, "videoX start number, -1 is autodetect (default)");
+
 void solo_irq_on(struct solo_dev *solo_dev, u32 mask)
 {
 	solo_dev->irq_mask |= mask;
@@ -261,7 +265,7 @@ static int __devinit solo_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto fail_probe;
 
-	ret = solo_v4l2_init(solo_dev);
+	ret = solo_v4l2_init(solo_dev, video_nr);
 	if (ret)
 		goto fail_probe;
 
@@ -269,7 +273,7 @@ static int __devinit solo_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto fail_probe;
 
-	ret = solo_enc_v4l2_init(solo_dev);
+	ret = solo_enc_v4l2_init(solo_dev, video_nr);
 	if (ret)
 		goto fail_probe;
 
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 5e9b399..7837cc2 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -286,13 +286,13 @@ void solo_i2c_exit(struct solo_dev *solo_dev);
 int solo_p2m_init(struct solo_dev *solo_dev);
 void solo_p2m_exit(struct solo_dev *solo_dev);
 
-int solo_v4l2_init(struct solo_dev *solo_dev);
+int solo_v4l2_init(struct solo_dev *solo_dev, unsigned int video_nr);
 void solo_v4l2_exit(struct solo_dev *solo_dev);
 
 int solo_enc_init(struct solo_dev *solo_dev);
 void solo_enc_exit(struct solo_dev *solo_dev);
 
-int solo_enc_v4l2_init(struct solo_dev *solo_dev);
+int solo_enc_v4l2_init(struct solo_dev *solo_dev, unsigned int video_nr);
 void solo_enc_v4l2_exit(struct solo_dev *solo_dev);
 
 int solo_g723_init(struct solo_dev *solo_dev);
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index fd52a42..bf5c390 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -34,8 +34,6 @@
 
 static int solo_enc_thread(void *data);
 
-extern unsigned video_nr;
-
 struct solo_enc_fh {
 	struct			solo_enc_dev *enc;
 	u32			fmt;
@@ -1724,7 +1722,8 @@ static struct video_device solo_enc_template = {
 	.current_norm		= V4L2_STD_NTSC_M,
 };
 
-static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
+static struct solo_enc_dev *
+solo_enc_alloc(struct solo_dev *solo_dev, u8 ch, unsigned int video_nr)
 {
 	struct solo_enc_dev *solo_enc;
 	int ret;
@@ -1787,12 +1786,12 @@ static void solo_enc_free(struct solo_enc_dev *solo_enc)
 	kfree(solo_enc);
 }
 
-int solo_enc_v4l2_init(struct solo_dev *solo_dev)
+int solo_enc_v4l2_init(struct solo_dev *solo_dev, unsigned int video_nr)
 {
 	int i;
 
 	for (i = 0; i < solo_dev->nr_chans; i++) {
-		solo_dev->v4l2_enc[i] = solo_enc_alloc(solo_dev, i);
+		solo_dev->v4l2_enc[i] = solo_enc_alloc(solo_dev, i, video_nr);
 		if (IS_ERR(solo_dev->v4l2_enc[i]))
 			break;
 	}
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index acc0ca0..3669d85 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -50,10 +50,6 @@ struct solo_filehandle {
 	int			desc_idx;
 };
 
-unsigned video_nr = -1;
-module_param(video_nr, uint, 0644);
-MODULE_PARM_DESC(video_nr, "videoX start number, -1 is autodetect (default)");
-
 static void erase_on(struct solo_dev *solo_dev)
 {
 	solo_reg_write(solo_dev, SOLO_VO_DISP_ERASE, SOLO_VO_DISP_ERASE_ON);
@@ -907,7 +903,7 @@ static struct video_device solo_v4l2_template = {
 	.current_norm		= V4L2_STD_NTSC_M,
 };
 
-int solo_v4l2_init(struct solo_dev *solo_dev)
+int solo_v4l2_init(struct solo_dev *solo_dev, unsigned int video_nr)
 {
 	int ret;
 	int i;
-- 
1.7.4.4


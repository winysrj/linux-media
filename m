Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54334 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914Ab2FUTyA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 15:54:00 -0400
Received: by gglu4 with SMTP id u4so881447ggl.19
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 12:53:59 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Collins <bcollins@bluecherry.net>,
	<linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 09/10] staging: solo6x10: Fix several over 80 character lines
Date: Thu, 21 Jun 2012 16:52:11 -0300
Message-Id: <1340308332-1118-9-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/solo6x10/i2c.c      |    3 ++-
 drivers/staging/media/solo6x10/v4l2-enc.c |   28 ++++++++++++++--------------
 drivers/staging/media/solo6x10/v4l2.c     |    5 ++++-
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/media/solo6x10/i2c.c b/drivers/staging/media/solo6x10/i2c.c
index ef95a50..795818b 100644
--- a/drivers/staging/media/solo6x10/i2c.c
+++ b/drivers/staging/media/solo6x10/i2c.c
@@ -288,7 +288,8 @@ int solo_i2c_init(struct solo_dev *solo_dev)
 	for (i = 0; i < SOLO_I2C_ADAPTERS; i++) {
 		struct i2c_adapter *adap = &solo_dev->i2c_adap[i];
 
-		snprintf(adap->name, I2C_NAME_SIZE, "%s I2C %d", SOLO6X10_NAME, i);
+		snprintf(adap->name, I2C_NAME_SIZE,
+			"%s I2C %d", SOLO6X10_NAME, i);
 		adap->algo = &solo_i2c_algo;
 		adap->algo_data = solo_dev;
 		adap->retries = 1;
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 9333a00..fd52a42 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -297,19 +297,19 @@ static int enc_get_mpeg_dma_sg(struct solo_dev *solo_dev,
 
 	if (off + size <= SOLO_MP4E_EXT_SIZE(solo_dev)) {
 		return solo_p2m_dma_sg(solo_dev, SOLO_P2M_DMA_ID_MP4E,
-				       desc, 0, sglist, skip,
-				       SOLO_MP4E_EXT_ADDR(solo_dev) + off, size);
+				desc, 0, sglist, skip,
+				SOLO_MP4E_EXT_ADDR(solo_dev) + off, size);
 	}
 
 	/* Buffer wrap */
 	ret = solo_p2m_dma_sg(solo_dev, SOLO_P2M_DMA_ID_MP4E, desc, 0,
-			      sglist, skip, SOLO_MP4E_EXT_ADDR(solo_dev) + off,
-			      SOLO_MP4E_EXT_SIZE(solo_dev) - off);
+			sglist, skip, SOLO_MP4E_EXT_ADDR(solo_dev) + off,
+			SOLO_MP4E_EXT_SIZE(solo_dev) - off);
 
 	ret |= solo_p2m_dma_sg(solo_dev, SOLO_P2M_DMA_ID_MP4E, desc, 0,
-			       sglist, skip + SOLO_MP4E_EXT_SIZE(solo_dev) - off,
-			       SOLO_MP4E_EXT_ADDR(solo_dev),
-			       size + off - SOLO_MP4E_EXT_SIZE(solo_dev));
+			sglist, skip + SOLO_MP4E_EXT_SIZE(solo_dev) - off,
+			SOLO_MP4E_EXT_ADDR(solo_dev),
+			size + off - SOLO_MP4E_EXT_SIZE(solo_dev));
 
 	return ret;
 }
@@ -366,19 +366,19 @@ static int enc_get_jpeg_dma_sg(struct solo_dev *solo_dev,
 
 	if (off + size <= SOLO_JPEG_EXT_SIZE(solo_dev)) {
 		return solo_p2m_dma_sg(solo_dev, SOLO_P2M_DMA_ID_JPEG,
-				       desc, 0, sglist, skip,
-				       SOLO_JPEG_EXT_ADDR(solo_dev) + off, size);
+			       desc, 0, sglist, skip,
+			       SOLO_JPEG_EXT_ADDR(solo_dev) + off, size);
 	}
 
 	/* Buffer wrap */
 	ret = solo_p2m_dma_sg(solo_dev, SOLO_P2M_DMA_ID_JPEG, desc, 0,
-			      sglist, skip, SOLO_JPEG_EXT_ADDR(solo_dev) + off,
-			      SOLO_JPEG_EXT_SIZE(solo_dev) - off);
+		      sglist, skip, SOLO_JPEG_EXT_ADDR(solo_dev) + off,
+		      SOLO_JPEG_EXT_SIZE(solo_dev) - off);
 
 	ret |= solo_p2m_dma_sg(solo_dev, SOLO_P2M_DMA_ID_JPEG, desc, 0,
-			       sglist, skip + SOLO_JPEG_EXT_SIZE(solo_dev) - off,
-			       SOLO_JPEG_EXT_ADDR(solo_dev),
-			       size + off - SOLO_JPEG_EXT_SIZE(solo_dev));
+		       sglist, skip + SOLO_JPEG_EXT_SIZE(solo_dev) - off,
+		       SOLO_JPEG_EXT_ADDR(solo_dev),
+		       size + off - SOLO_JPEG_EXT_SIZE(solo_dev));
 
 	return ret;
 }
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index 1f896b9..acc0ca0 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -324,7 +324,10 @@ static void solo_fillbuf(struct solo_filehandle *fh,
 			continue;
 		}
 
-		/* Shove as many lines into a repeating descriptor as possible */
+		/*
+		 * Shove as many lines into a repeating
+		 * descriptor as possible
+		 */
 		lines = min(sg_size_left / line_len,
 			    solo_vlines(solo_dev) - i);
 
-- 
1.7.4.4


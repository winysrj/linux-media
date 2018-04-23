Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39373 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754692AbeDWLWY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 07:22:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: davinci: don't override the error code
Date: Mon, 23 Apr 2018 07:22:19 -0400
Message-Id: <f58d196d5d71450efab15afe01661923a3a7e28f.1524482537.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by Coverity:
	CID 1415211 (#1 of 1): Unused value (UNUSED_VALUE)assigned_value:
	Assigning value -22 to ret here, but that stored value is
	overwritten before it can be used.

On all cases where the there's a goto 'unlock_out' or 'streamof',
ret was filled with a non-sero value. It toesn't make sense to override
such error code with a videobuf_streamoff() error.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/vpfe_capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 6f44abf7fa31..8613358ed245 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1509,7 +1509,7 @@ static int vpfe_streamon(struct file *file, void *priv,
 unlock_out:
 	mutex_unlock(&vpfe_dev->lock);
 streamoff:
-	ret = videobuf_streamoff(&vpfe_dev->buffer_queue);
+	videobuf_streamoff(&vpfe_dev->buffer_queue);
 	return ret;
 }
 
-- 
2.14.3

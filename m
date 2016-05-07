Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:58451 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbcEGFOt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 May 2016 01:14:49 -0400
From: ayaka <ayaka@soulik.info>
To: linux-kernel@vger.kernel.org
Cc: m.szyprowski@samsung.com, nicolas.dufresne@collabora.com,
	shuahkh@osg.samsung.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, kyungmin.park@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	ayaka <ayaka@soulik.info>
Subject: [PATCH 3/3] [media] s5p-mfc: fix a typo in s5p_mfc_dec
Date: Sat,  7 May 2016 13:05:26 +0800
Message-Id: <1462597526-31559-4-git-send-email-ayaka@soulik.info>
In-Reply-To: <1462597526-31559-1-git-send-email-ayaka@soulik.info>
References: <1462597526-31559-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is a cosmetic commit.

Signed-off-by: ayaka <ayaka@soulik.info>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index f2d6376..391ed9c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -573,7 +573,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 
 	if (reqbufs->memory != V4L2_MEMORY_MMAP) {
-		mfc_err("Only V4L2_MEMORY_MAP is supported\n");
+		mfc_err("Only V4L2_MEMORY_MMAP is supported\n");
 		return -EINVAL;
 	}
 
-- 
2.5.5


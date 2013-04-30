Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:36502 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3D3G3R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 02:29:17 -0400
Received: by mail-pb0-f53.google.com with SMTP id un1so106050pbc.40
        for <linux-media@vger.kernel.org>; Mon, 29 Apr 2013 23:29:17 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 3/4] [media] s3c-camif: Staticize local symbols
Date: Tue, 30 Apr 2013 11:46:20 +0530
Message-Id: <1367302581-15478-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1367302581-15478-1-git-send-email-sachin.kamat@linaro.org>
References: <1367302581-15478-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These symbols are local to the file and should be static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s3c-camif/camif-regs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-regs.c b/drivers/media/platform/s3c-camif/camif-regs.c
index 1a3b4fc..7b22d6c 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.c
+++ b/drivers/media/platform/s3c-camif/camif-regs.c
@@ -379,7 +379,7 @@ static void camif_hw_set_prescaler(struct camif_vp *vp)
 	camif_write(camif, S3C_CAMIF_REG_CISCPREDST(vp->id, vp->offset), cfg);
 }
 
-void camif_s3c244x_hw_set_scaler(struct camif_vp *vp)
+static void camif_s3c244x_hw_set_scaler(struct camif_vp *vp)
 {
 	struct camif_dev *camif = vp->camif;
 	struct camif_scaler *scaler = &vp->scaler;
@@ -426,7 +426,7 @@ void camif_s3c244x_hw_set_scaler(struct camif_vp *vp)
 		 scaler->main_h_ratio, scaler->main_v_ratio);
 }
 
-void camif_s3c64xx_hw_set_scaler(struct camif_vp *vp)
+static void camif_s3c64xx_hw_set_scaler(struct camif_vp *vp)
 {
 	struct camif_dev *camif = vp->camif;
 	struct camif_scaler *scaler = &vp->scaler;
-- 
1.7.9.5


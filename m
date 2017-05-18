Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34597 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754053AbdERBto (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 21:49:44 -0400
From: Manny Vindiola <mannyv@gmail.com>
To: mannyv@gmail.com, mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: media: fix missing blank line coding style issue in atomisp_tpg.c
Date: Wed, 17 May 2017 21:48:38 -0400
Message-Id: <1495072118-912-1-git-send-email-mannyv@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a patch to the atomisp_tpg.c file that fixes up a missing
blank line warning found by the checkpatch.pl tool

Signed-off-by: Manny Vindiola <mannyv@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
index 996d1bd..48b9604 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
@@ -56,6 +56,7 @@ static int tpg_set_fmt(struct v4l2_subdev *sd,
 		       struct v4l2_subdev_format *format)
 {
 	struct v4l2_mbus_framefmt *fmt = &format->format;
+
 	if (format->pad)
 		return -EINVAL;
 	/* only raw8 grbg is supported by TPG */
-- 
2.7.4

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34750 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754564AbdDGMl0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 08:41:26 -0400
From: Manny Vindiola <mannyv@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Manny Vindiola <mannyv@gmail.com>
Subject: [PATCH] add blank line after declarations
Date: Fri,  7 Apr 2017 08:41:11 -0400
Message-Id: <1491568871-22111-1-git-send-email-mannyv@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add blank line after variable declarations as part of checkpatch.pl style fixup.

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

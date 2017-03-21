Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36373 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754691AbdCUCRl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 22:17:41 -0400
Date: Tue, 21 Mar 2017 11:13:32 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, singhalsimran0@gmail.com,
        dan.carpenter@oracle.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 4/4 V2] staging: atomisp: remove redudant condition in
 if-statement
Message-ID: <20170321021332.GA1678@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_FIELD_ANY is zero, so the (!field) is same meaning
with (field == V4L2_FIELD_ANY) in if-statement.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: one(2/4) of this series was updated so I tried to send them again.

 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index f7c0705..943a7ae 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -5084,7 +5084,7 @@ int atomisp_try_fmt(struct video_device *vdev, struct v4l2_format *f,
 
 	depth = get_pixel_depth(pixelformat);
 
-	if (!field || field == V4L2_FIELD_ANY)
+	if (field == V4L2_FIELD_ANY)
 		field = V4L2_FIELD_NONE;
 	else if (field != V4L2_FIELD_NONE) {
 		dev_err(isp->dev, "Wrong output field\n");
-- 
1.9.1

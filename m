Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33286 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753602AbdCTLiD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 07:38:03 -0400
Received: by mail-pg0-f65.google.com with SMTP id 79so10783429pgf.0
        for <linux-media@vger.kernel.org>; Mon, 20 Mar 2017 04:36:36 -0700 (PDT)
Date: Mon, 20 Mar 2017 20:00:29 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 4/4] staging: atomisp: remove redudant condition in
 if-statement
Message-ID: <20170320110029.GA18111@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_FIELD_ANY is zero, so the (!field) is same meaning
with (field == V4L2_FIELD_ANY) in if-statement.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 929ed80..2437162 100644
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

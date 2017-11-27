Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:44564 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752275AbdK0Vp2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 16:45:28 -0500
Received: by mail-wr0-f194.google.com with SMTP id l22so27853889wrc.11
        for <linux-media@vger.kernel.org>; Mon, 27 Nov 2017 13:45:27 -0800 (PST)
From: Riccardo Schirone <sirmy15@gmail.com>
To: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org
Cc: Riccardo Schirone <sirmy15@gmail.com>
Subject: [PATCH 4/4] staging: fix indentation in atomisp-ov5693
Date: Mon, 27 Nov 2017 22:44:13 +0100
Message-Id: <20171127214413.10749-5-sirmy15@gmail.com>
In-Reply-To: <20171127214413.10749-1-sirmy15@gmail.com>
References: <20171127214413.10749-1-sirmy15@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix "suspect code indent for conditional statements" issue

Signed-off-by: Riccardo Schirone <sirmy15@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
index 4eeb478ae84b..6eb6afdc730e 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
@@ -776,7 +776,7 @@ static int __ov5693_otp_read(struct v4l2_subdev *sd, u8 *buf)
 			if ((*b) == 0) {
 				dev->otp_size = 32;
 				break;
-		} else {
+			} else {
 				b = buf;
 				continue;
 			}
-- 
2.14.3

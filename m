Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32811 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753037AbdK1Ukj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 15:40:39 -0500
Received: by mail-wm0-f65.google.com with SMTP id g130so33464164wme.0
        for <linux-media@vger.kernel.org>; Tue, 28 Nov 2017 12:40:38 -0800 (PST)
From: Riccardo Schirone <sirmy15@gmail.com>
To: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org
Cc: Riccardo Schirone <sirmy15@gmail.com>
Subject: [PATCHv2 4/4] staging: fix indentation in atomisp-ov5693
Date: Tue, 28 Nov 2017 21:40:04 +0100
Message-Id: <20171128204004.9345-5-sirmy15@gmail.com>
In-Reply-To: <20171128204004.9345-1-sirmy15@gmail.com>
References: <20171127214413.10749-1-sirmy15@gmail.com>
 <20171128204004.9345-1-sirmy15@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix "suspect code indent for conditional statements" checkpatch issue

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

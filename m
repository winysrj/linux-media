Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34418 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbdHJPEM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 11:04:12 -0400
Date: Thu, 10 Aug 2017 20:34:06 +0530
From: Harold Gomez <haroldgmz11@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:media:atomisp:Fix code indent error
Message-ID: <20170810150406.GA5152@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

code indent should use tabs where possible
change spaces to tabs

Signed-off-by: Harold Gomez <haroldgmz11@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ap1302.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
index bacffbe..538a064 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.c
+++ b/drivers/staging/media/atomisp/i2c/ap1302.c
@@ -606,7 +606,7 @@ static s32 ap1302_try_mbus_fmt_locked(struct v4l2_subdev *sd,
 
 
 static int ap1302_get_fmt(struct v4l2_subdev *sd,
-	                 struct v4l2_subdev_pad_config *cfg,
+					 struct v4l2_subdev_pad_config *cfg,
 					 struct v4l2_subdev_format *format)
 
 {
-- 
2.1.4

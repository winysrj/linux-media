Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36816 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752140AbdC2Q6P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 12:58:15 -0400
From: Daniel Cashman <dan.a.cashman@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com
Cc: rvarsha016@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.a.cashman@gmail.com
Subject: [PATCH v2] staging: media: atomisp: Fix style. remove space before ',' and convert to tabs.
Date: Wed, 29 Mar 2017 09:57:57 -0700
Message-Id: <1490806677-4500-1-git-send-email-dan.a.cashman@gmail.com>
In-Reply-To: <20170329070815.GA11051@kroah.com>
References: <20170329070815.GA11051@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Cashman <dan.a.cashman@gmail.com>

Signed-off-by: Dan Cashman <dan.a.cashman@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ap1302.c | 4 ++--
 drivers/staging/media/atomisp/i2c/gc0310.c | 2 +-
 drivers/staging/media/atomisp/i2c/gc2235.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
index bacffbe..8432ee9 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.c
+++ b/drivers/staging/media/atomisp/i2c/ap1302.c
@@ -606,8 +606,8 @@ static s32 ap1302_try_mbus_fmt_locked(struct v4l2_subdev *sd,
 
 
 static int ap1302_get_fmt(struct v4l2_subdev *sd,
-	                 struct v4l2_subdev_pad_config *cfg,
-					 struct v4l2_subdev_format *format)
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *format)
 
 {
     struct v4l2_mbus_framefmt *fmt = &format->format;
diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/gc0310.c
index add8b90..1ec616a 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/gc0310.c
@@ -54,7 +54,7 @@ static int gc0310_read_reg(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	memset(msg, 0 , sizeof(msg));
+	memset(msg, 0, sizeof(msg));
 
 	msg[0].addr = client->addr;
 	msg[0].flags = 0;
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 9b41023..50f4317 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -55,7 +55,7 @@ static int gc2235_read_reg(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	memset(msg, 0 , sizeof(msg));
+	memset(msg, 0, sizeof(msg));
 
 	msg[0].addr = client->addr;
 	msg[0].flags = 0;
-- 
2.7.4

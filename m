Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32934 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753965AbdCIWvJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 17:51:09 -0500
From: simran singhal <singhalsimran0@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: [PATCH v1 3/7] staging: gc2235: Replace NULL with "!"
Date: Fri, 10 Mar 2017 04:20:25 +0530
Message-Id: <1489099829-1264-4-git-send-email-singhalsimran0@gmail.com>
In-Reply-To: <1489099829-1264-1-git-send-email-singhalsimran0@gmail.com>
References: <1489099829-1264-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use ! in comparison tests using "==NULL" rather than moving the
"==NULL" to the right side of the test.

Addesses multiple instances of the checkpatch.pl warning:
WARNING: Comparisons should place the constant on the right side of the
test

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 7de7e24..2ef876a 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -603,7 +603,7 @@ static int power_up(struct v4l2_subdev *sd)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret;
 
-	if (NULL == dev->platform_data) {
+	if (!dev->platform_data) {
 		dev_err(&client->dev,
 			"no camera_sensor_platform_data");
 		return -ENODEV;
@@ -647,7 +647,7 @@ static int power_down(struct v4l2_subdev *sd)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret = 0;
 
-	if (NULL == dev->platform_data) {
+	if (!dev->platform_data) {
 		dev_err(&client->dev,
 			"no camera_sensor_platform_data");
 		return -ENODEV;
-- 
2.7.4

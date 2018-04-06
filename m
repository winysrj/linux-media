Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42984 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756614AbeDFOXg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Douglas Fischer <fischerdouglasc@gmail.com>
Subject: [PATCH 11/21] media: si470x: fix __be16 annotations
Date: Fri,  6 Apr 2018 10:23:12 -0400
Message-Id: <fb726fa1be204240b4eee355a5843a087af137b0.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The annotations there are wrong as warned:
   drivers/media/radio/si470x/radio-si470x-i2c.c:107:35: warning: cast to restricted __be16
   drivers/media/radio/si470x/radio-si470x-i2c.c:107:35: warning: cast to restricted __be16
   drivers/media/radio/si470x/radio-si470x-i2c.c:107:35: warning: cast to restricted __be16
   drivers/media/radio/si470x/radio-si470x-i2c.c:107:35: warning: cast to restricted __be16
   drivers/media/radio/si470x/radio-si470x-i2c.c:129:24: warning: incorrect type in assignment (different base types)
   drivers/media/radio/si470x/radio-si470x-i2c.c:129:24:    expected unsigned short [unsigned] [short] <noident>
   drivers/media/radio/si470x/radio-si470x-i2c.c:129:24:    got restricted __be16 [usertype] <noident>
   drivers/media/radio/si470x/radio-si470x-i2c.c:163:39: warning: cast to restricted __be16
   drivers/media/radio/si470x/radio-si470x-i2c.c:163:39: warning: cast to restricted __be16
   drivers/media/radio/si470x/radio-si470x-i2c.c:163:39: warning: cast to restricted __be16
   drivers/media/radio/si470x/radio-si470x-i2c.c:163:39: warning: cast to restricted __be16

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 1b3720b1e737..e3b3ecd14a4d 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -91,7 +91,7 @@ MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");
  */
 static int si470x_get_register(struct si470x_device *radio, int regnr)
 {
-	u16 buf[READ_REG_NUM];
+	__be16 buf[READ_REG_NUM];
 	struct i2c_msg msgs[1] = {
 		{
 			.addr = radio->client->addr,
@@ -116,7 +116,7 @@ static int si470x_get_register(struct si470x_device *radio, int regnr)
 static int si470x_set_register(struct si470x_device *radio, int regnr)
 {
 	int i;
-	u16 buf[WRITE_REG_NUM];
+	__be16 buf[WRITE_REG_NUM];
 	struct i2c_msg msgs[1] = {
 		{
 			.addr = radio->client->addr,
@@ -146,7 +146,7 @@ static int si470x_set_register(struct si470x_device *radio, int regnr)
 static int si470x_get_all_registers(struct si470x_device *radio)
 {
 	int i;
-	u16 buf[READ_REG_NUM];
+	__be16 buf[READ_REG_NUM];
 	struct i2c_msg msgs[1] = {
 		{
 			.addr = radio->client->addr,
-- 
2.14.3

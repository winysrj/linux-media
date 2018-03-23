Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56906 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753880AbeCWL50 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 10/30] media: tvaudio: improve error handling
Date: Fri, 23 Mar 2018 07:56:56 -0400
Message-Id: <b0121ca03865ec5fa46f2ffc9d354cd5e5613023.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The error handling logic at tvaudio is broken on several ways,
as it doesn't really check right when an error occurs.

Change it to return the proper error code from read/write
routines and fix the errors on reads.

Shuts up the following warnings:
	drivers/media/i2c/tvaudio.c:222 chip_read() error: uninitialized symbol 'buffer'.
	drivers/media/i2c/tvaudio.c:223 chip_read() error: uninitialized symbol 'buffer'.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/tvaudio.c | 92 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 72 insertions(+), 20 deletions(-)

diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index 772164b848ef..5919214a56bf 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -156,14 +156,18 @@ static int chip_write(struct CHIPSTATE *chip, int subaddr, int val)
 	struct v4l2_subdev *sd = &chip->sd;
 	struct i2c_client *c = v4l2_get_subdevdata(sd);
 	unsigned char buffer[2];
+	int rc;
 
 	if (subaddr < 0) {
 		v4l2_dbg(1, debug, sd, "chip_write: 0x%x\n", val);
 		chip->shadow.bytes[1] = val;
 		buffer[0] = val;
-		if (1 != i2c_master_send(c, buffer, 1)) {
+		rc = i2c_master_send(c, buffer, 1);
+		if (rc != 1) {
 			v4l2_warn(sd, "I/O error (write 0x%x)\n", val);
-			return -1;
+			if (rc < 0)
+				return rc;
+			return -EIO;
 		}
 	} else {
 		if (subaddr + 1 >= ARRAY_SIZE(chip->shadow.bytes)) {
@@ -178,10 +182,13 @@ static int chip_write(struct CHIPSTATE *chip, int subaddr, int val)
 		chip->shadow.bytes[subaddr+1] = val;
 		buffer[0] = subaddr;
 		buffer[1] = val;
-		if (2 != i2c_master_send(c, buffer, 2)) {
+		rc = i2c_master_send(c, buffer, 2);
+		if (rc != 2) {
 			v4l2_warn(sd, "I/O error (write reg%d=0x%x)\n",
 				subaddr, val);
-			return -1;
+			if (rc < 0)
+				return rc;
+			return -EIO;
 		}
 	}
 	return 0;
@@ -214,10 +221,14 @@ static int chip_read(struct CHIPSTATE *chip)
 	struct v4l2_subdev *sd = &chip->sd;
 	struct i2c_client *c = v4l2_get_subdevdata(sd);
 	unsigned char buffer;
+	int rc;
 
-	if (1 != i2c_master_recv(c, &buffer, 1)) {
+	rc = i2c_master_recv(c, &buffer, 1);
+	if (rc != 1) {
 		v4l2_warn(sd, "I/O error (read)\n");
-		return -1;
+		if (rc < 0)
+			return rc;
+		return -EIO;
 	}
 	v4l2_dbg(1, debug, sd, "chip_read: 0x%x\n", buffer);
 	return buffer;
@@ -227,6 +238,7 @@ static int chip_read2(struct CHIPSTATE *chip, int subaddr)
 {
 	struct v4l2_subdev *sd = &chip->sd;
 	struct i2c_client *c = v4l2_get_subdevdata(sd);
+	int rc;
 	unsigned char write[1];
 	unsigned char read[1];
 	struct i2c_msg msgs[2] = {
@@ -245,9 +257,12 @@ static int chip_read2(struct CHIPSTATE *chip, int subaddr)
 
 	write[0] = subaddr;
 
-	if (2 != i2c_transfer(c->adapter, msgs, 2)) {
+	rc = i2c_transfer(c->adapter, msgs, 2);
+	if (rc != 2) {
 		v4l2_warn(sd, "I/O error (read2)\n");
-		return -1;
+		if (rc < 0)
+			return rc;
+		return -EIO;
 	}
 	v4l2_dbg(1, debug, sd, "chip_read2: reg%d=0x%x\n",
 		subaddr, read[0]);
@@ -258,7 +273,7 @@ static int chip_cmd(struct CHIPSTATE *chip, char *name, audiocmd *cmd)
 {
 	struct v4l2_subdev *sd = &chip->sd;
 	struct i2c_client *c = v4l2_get_subdevdata(sd);
-	int i;
+	int i, rc;
 
 	if (0 == cmd->count)
 		return 0;
@@ -284,9 +299,12 @@ static int chip_cmd(struct CHIPSTATE *chip, char *name, audiocmd *cmd)
 		printk(KERN_CONT "\n");
 
 	/* send data to the chip */
-	if (cmd->count != i2c_master_send(c, cmd->bytes, cmd->count)) {
+	rc = i2c_master_send(c, cmd->bytes, cmd->count);
+	if (rc != cmd->count) {
 		v4l2_warn(sd, "I/O error (%s)\n", name);
-		return -1;
+		if (rc < 0)
+			return rc;
+		return -EIO;
 	}
 	return 0;
 }
@@ -400,8 +418,12 @@ static int tda9840_getrxsubchans(struct CHIPSTATE *chip)
 	struct v4l2_subdev *sd = &chip->sd;
 	int val, mode;
 
-	val = chip_read(chip);
 	mode = V4L2_TUNER_SUB_MONO;
+
+	val = chip_read(chip);
+	if (val < 0)
+		return mode;
+
 	if (val & TDA9840_DS_DUAL)
 		mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	if (val & TDA9840_ST_STEREO)
@@ -445,7 +467,12 @@ static void tda9840_setaudmode(struct CHIPSTATE *chip, int mode)
 static int tda9840_checkit(struct CHIPSTATE *chip)
 {
 	int rc;
+
 	rc = chip_read(chip);
+	if (rc < 0)
+		return 0;
+
+
 	/* lower 5 bits should be 0 */
 	return ((rc & 0x1f) == 0) ? 1 : 0;
 }
@@ -563,6 +590,9 @@ static int  tda985x_getrxsubchans(struct CHIPSTATE *chip)
 	/* Allows forced mono */
 	mode = V4L2_TUNER_SUB_MONO;
 	val = chip_read(chip);
+	if (val < 0)
+		return mode;
+
 	if (val & TDA985x_STP)
 		mode = V4L2_TUNER_SUB_STEREO;
 	if (val & TDA985x_SAPP)
@@ -720,8 +750,12 @@ static int tda9873_getrxsubchans(struct CHIPSTATE *chip)
 	struct v4l2_subdev *sd = &chip->sd;
 	int val,mode;
 
-	val = chip_read(chip);
 	mode = V4L2_TUNER_SUB_MONO;
+
+	val = chip_read(chip);
+	if (val < 0)
+		return mode;
+
 	if (val & TDA9873_STEREO)
 		mode = V4L2_TUNER_SUB_STEREO;
 	if (val & TDA9873_DUAL)
@@ -780,7 +814,8 @@ static int tda9873_checkit(struct CHIPSTATE *chip)
 {
 	int rc;
 
-	if (-1 == (rc = chip_read2(chip,254)))
+	rc = chip_read2(chip, 254);
+	if (rc < 0)
 		return 0;
 	return (rc & ~0x1f) == 0x80;
 }
@@ -926,11 +961,14 @@ static int tda9874a_getrxsubchans(struct CHIPSTATE *chip)
 
 	mode = V4L2_TUNER_SUB_MONO;
 
-	if(-1 == (dsr = chip_read2(chip,TDA9874A_DSR)))
+	dsr = chip_read2(chip, TDA9874A_DSR);
+	if (dsr < 0)
 		return mode;
-	if(-1 == (nsr = chip_read2(chip,TDA9874A_NSR)))
+	nsr = chip_read2(chip, TDA9874A_NSR);
+	if (nsr < 0)
 		return mode;
-	if(-1 == (necr = chip_read2(chip,TDA9874A_NECR)))
+	necr = chip_read2(chip, TDA9874A_NECR);
+	if (necr < 0)
 		return mode;
 
 	/* need to store dsr/nsr somewhere */
@@ -1059,9 +1097,11 @@ static int tda9874a_checkit(struct CHIPSTATE *chip)
 	struct v4l2_subdev *sd = &chip->sd;
 	int dic,sic;	/* device id. and software id. codes */
 
-	if(-1 == (dic = chip_read2(chip,TDA9874A_DIC)))
+	dic = chip_read2(chip, TDA9874A_DIC);
+	if (dic < 0)
 		return 0;
-	if(-1 == (sic = chip_read2(chip,TDA9874A_SIC)))
+	sic = chip_read2(chip, TDA9874A_SIC);
+	if (sic < 0)
 		return 0;
 
 	v4l2_dbg(1, debug, sd, "tda9874a_checkit(): DIC=0x%X, SIC=0x%X.\n", dic, sic);
@@ -1201,7 +1241,11 @@ static int tda9875_checkit(struct CHIPSTATE *chip)
 	int dic, rev;
 
 	dic = chip_read2(chip, 254);
+	if (dic < 0)
+		return 0;
 	rev = chip_read2(chip, 255);
+	if (rev < 0)
+		return 0;
 
 	if (dic == 0 || dic == 2) { /* tda9875 and tda9875A */
 		v4l2_info(sd, "found tda9875%s rev. %d.\n",
@@ -1377,8 +1421,12 @@ static int ta8874z_getrxsubchans(struct CHIPSTATE *chip)
 {
 	int val, mode;
 
-	val = chip_read(chip);
 	mode = V4L2_TUNER_SUB_MONO;
+
+	val = chip_read(chip);
+	if (val < 0)
+		return mode;
+
 	if (val & TA8874Z_B1){
 		mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	}else if (!(val & TA8874Z_B0)){
@@ -1431,7 +1479,11 @@ static void ta8874z_setaudmode(struct CHIPSTATE *chip, int mode)
 static int ta8874z_checkit(struct CHIPSTATE *chip)
 {
 	int rc;
+
 	rc = chip_read(chip);
+	if (rc < 0)
+		return rc;
+
 	return ((rc & 0x1f) == 0x1f) ? 1 : 0;
 }
 
-- 
2.14.3

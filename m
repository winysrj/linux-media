Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab3EUOli (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 10:41:38 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4LEfcMF030366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 21 May 2013 10:41:38 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] saa7115: Don't use a dynamic array
Date: Tue, 21 May 2013 11:41:33 -0300
Message-Id: <1369147293-30592-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At least on s390, gcc complains about that:
    drivers/media/i2c/saa7115.c: In function 'saa711x_detect_chip.constprop.2':
    drivers/media/i2c/saa7115.c:1647:1: warning: 'saa711x_detect_chip.constprop.2' uses dynamic stack allocation [enabled by default]

While for me the above report seems utterly bogus, as the
compiler should be optimizing saa711x_detect_chip, merging
it with saa711x_detect_chip and changing:
	char chip_ver[size - 1];
to
	char chip_ver[16];

because this function is only called on this code snippet:
	char name[17];
	...
	ident = saa711x_detect_chip(client, id, name, sizeof(name));

It seems that gcc is not optimizing it, at least on s390.

As getting rid of it is easy, let's do it.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/i2c/saa7115.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index be32688..8316ae4 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1602,6 +1602,8 @@ static const struct v4l2_subdev_ops saa711x_ops = {
 	.vbi = &saa711x_vbi_ops,
 };
 
+#define CHIP_VER_SIZE	16
+
 /* ----------------------------------------------------------------------- */
 
 /**
@@ -1609,7 +1611,6 @@ static const struct v4l2_subdev_ops saa711x_ops = {
  * @client:		I2C client structure.
  * @id:			I2C device ID structure.
  * @name:		Name of the device to be filled.
- * @size:		Size of the name var.
  *
  * Detects the Philips/NXP saa711x chip, or some clone of it.
  * if 'id' is NULL or id->driver_data is equal to 1, it auto-probes
@@ -1621,9 +1622,9 @@ static const struct v4l2_subdev_ops saa711x_ops = {
  */
 static int saa711x_detect_chip(struct i2c_client *client,
 			       const struct i2c_device_id *id,
-			       char *name, unsigned size)
+			       char *name)
 {
-	char chip_ver[size - 1];
+	char chip_ver[CHIP_VER_SIZE];
 	char chip_id;
 	int i;
 	int autodetect;
@@ -1631,7 +1632,7 @@ static int saa711x_detect_chip(struct i2c_client *client,
 	autodetect = !id || id->driver_data == 1;
 
 	/* Read the chip version register */
-	for (i = 0; i < size - 1; i++) {
+	for (i = 0; i < CHIP_VER_SIZE; i++) {
 		i2c_smbus_write_byte_data(client, 0, i);
 		chip_ver[i] = i2c_smbus_read_byte_data(client, 0);
 		name[i] = (chip_ver[i] & 0x0f) + '0';
@@ -1643,7 +1644,7 @@ static int saa711x_detect_chip(struct i2c_client *client,
 	/* Check if it is a Philips/NXP chip */
 	if (!memcmp(name + 1, "f711", 4)) {
 		chip_id = name[5];
-		snprintf(name, size, "saa711%c", chip_id);
+		snprintf(name, CHIP_VER_SIZE, "saa711%c", chip_id);
 
 		if (!autodetect && strcmp(name, id->name))
 			return -EINVAL;
@@ -1651,7 +1652,7 @@ static int saa711x_detect_chip(struct i2c_client *client,
 		switch (chip_id) {
 		case '1':
 			if (chip_ver[0] & 0xf0) {
-				snprintf(name, size, "saa711%ca", chip_id);
+				snprintf(name, CHIP_VER_SIZE, "saa711%ca", chip_id);
 				v4l_info(client, "saa7111a variant found\n");
 				return V4L2_IDENT_SAA7111A;
 			}
@@ -1689,7 +1690,7 @@ static int saa711x_detect_chip(struct i2c_client *client,
 		 * the lower nibble is a gm7113c.
 		 */
 
-		strlcpy(name, "gm7113c", size);
+		strlcpy(name, "gm7113c", CHIP_VER_SIZE);
 
 		if (!autodetect && strcmp(name, id->name))
 			return -EINVAL;
@@ -1714,13 +1715,13 @@ static int saa711x_probe(struct i2c_client *client,
 	struct v4l2_subdev *sd;
 	struct v4l2_ctrl_handler *hdl;
 	int ident;
-	char name[17];
+	char name[CHIP_VER_SIZE + 1];
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	ident = saa711x_detect_chip(client, id, name, sizeof(name));
+	ident = saa711x_detect_chip(client, id, name);
 	if (ident == -EINVAL) {
 		/* Chip exists, but doesn't match */
 		v4l_warn(client, "found %s while %s was expected\n",
-- 
1.8.1.4


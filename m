Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59176 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757056AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 30/57] [media] si470x: don't break long lines
Date: Fri, 14 Oct 2016 17:20:18 -0300
Message-Id: <dda230de63041b08d9ea8f12786b6f2374f580c3.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c |  6 ++----
 drivers/media/radio/si470x/radio-si470x-usb.c | 12 ++++--------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index ee0470a3196b..ba622439f121 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -387,8 +387,7 @@ static int si470x_i2c_probe(struct i2c_client *client,
 			radio->registers[DEVICEID], radio->registers[SI_CHIPID]);
 	if ((radio->registers[SI_CHIPID] & SI_CHIPID_FIRMWARE) < RADIO_FW_VERSION) {
 		dev_warn(&client->dev,
-			"This driver is known to work with "
-			"firmware version %hu,\n", RADIO_FW_VERSION);
+			"This driver is known to work with firmware version %hu,\n", RADIO_FW_VERSION);
 		dev_warn(&client->dev,
 			"but the device has firmware version %hu.\n",
 			radio->registers[SI_CHIPID] & SI_CHIPID_FIRMWARE);
@@ -400,8 +399,7 @@ static int si470x_i2c_probe(struct i2c_client *client,
 		dev_warn(&client->dev,
 			"If you have some trouble using this driver,\n");
 		dev_warn(&client->dev,
-			"please report to V4L ML at "
-			"linux-media@vger.kernel.org\n");
+			"please report to V4L ML at linux-media@vger.kernel.org\n");
 	}
 
 	/* set initial frequency */
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 4b132c29f290..18e0c7ec2056 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -351,8 +351,7 @@ static int si470x_get_scratch_page_versions(struct si470x_device *radio)
 	retval = si470x_get_report(radio, radio->usb_buf, SCRATCH_REPORT_SIZE);
 
 	if (retval < 0)
-		dev_warn(&radio->intf->dev, "si470x_get_scratch: "
-			"si470x_get_report returned %d\n", retval);
+		dev_warn(&radio->intf->dev, "si470x_get_scratch: si470x_get_report returned %d\n", retval);
 	else {
 		radio->software_version = radio->usb_buf[1];
 		radio->hardware_version = radio->usb_buf[2];
@@ -688,8 +687,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 			radio->registers[DEVICEID], radio->registers[SI_CHIPID]);
 	if ((radio->registers[SI_CHIPID] & SI_CHIPID_FIRMWARE) < RADIO_FW_VERSION) {
 		dev_warn(&intf->dev,
-			"This driver is known to work with "
-			"firmware version %hu,\n", RADIO_FW_VERSION);
+			"This driver is known to work with firmware version %hu,\n", RADIO_FW_VERSION);
 		dev_warn(&intf->dev,
 			"but the device has firmware version %hu.\n",
 			radio->registers[SI_CHIPID] & SI_CHIPID_FIRMWARE);
@@ -705,8 +703,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 			radio->software_version, radio->hardware_version);
 	if (radio->hardware_version < RADIO_HW_VERSION) {
 		dev_warn(&intf->dev,
-			"This driver is known to work with "
-			"hardware version %hu,\n", RADIO_HW_VERSION);
+			"This driver is known to work with hardware version %hu,\n", RADIO_HW_VERSION);
 		dev_warn(&intf->dev,
 			"but the device has hardware version %hu.\n",
 			radio->hardware_version);
@@ -718,8 +715,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 		dev_warn(&intf->dev,
 			"If you have some trouble using this driver,\n");
 		dev_warn(&intf->dev,
-			"please report to V4L ML at "
-			"linux-media@vger.kernel.org\n");
+			"please report to V4L ML at linux-media@vger.kernel.org\n");
 	}
 
 	/* set led to connect state */
-- 
2.7.4



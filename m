Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51517 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934504AbcJRUqU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 28/58] si470x: don't break long lines
Date: Tue, 18 Oct 2016 18:45:40 -0200
Message-Id: <af20cd46211400ebe618194ebba2efe37666890d.1476822925.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c |  7 +++----
 drivers/media/radio/si470x/radio-si470x-usb.c | 15 +++++++--------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index ee0470a3196b..9b81969d76b5 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -387,8 +387,8 @@ static int si470x_i2c_probe(struct i2c_client *client,
 			radio->registers[DEVICEID], radio->registers[SI_CHIPID]);
 	if ((radio->registers[SI_CHIPID] & SI_CHIPID_FIRMWARE) < RADIO_FW_VERSION) {
 		dev_warn(&client->dev,
-			"This driver is known to work with "
-			"firmware version %hu,\n", RADIO_FW_VERSION);
+			"This driver is known to work with firmware version %hu,\n",
+			RADIO_FW_VERSION);
 		dev_warn(&client->dev,
 			"but the device has firmware version %hu.\n",
 			radio->registers[SI_CHIPID] & SI_CHIPID_FIRMWARE);
@@ -400,8 +400,7 @@ static int si470x_i2c_probe(struct i2c_client *client,
 		dev_warn(&client->dev,
 			"If you have some trouble using this driver,\n");
 		dev_warn(&client->dev,
-			"please report to V4L ML at "
-			"linux-media@vger.kernel.org\n");
+			"please report to V4L ML at linux-media@vger.kernel.org\n");
 	}
 
 	/* set initial frequency */
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 4b132c29f290..1add136d37a3 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -351,8 +351,8 @@ static int si470x_get_scratch_page_versions(struct si470x_device *radio)
 	retval = si470x_get_report(radio, radio->usb_buf, SCRATCH_REPORT_SIZE);
 
 	if (retval < 0)
-		dev_warn(&radio->intf->dev, "si470x_get_scratch: "
-			"si470x_get_report returned %d\n", retval);
+		dev_warn(&radio->intf->dev, "si470x_get_scratch: si470x_get_report returned %d\n",
+			 retval);
 	else {
 		radio->software_version = radio->usb_buf[1];
 		radio->hardware_version = radio->usb_buf[2];
@@ -688,8 +688,8 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 			radio->registers[DEVICEID], radio->registers[SI_CHIPID]);
 	if ((radio->registers[SI_CHIPID] & SI_CHIPID_FIRMWARE) < RADIO_FW_VERSION) {
 		dev_warn(&intf->dev,
-			"This driver is known to work with "
-			"firmware version %hu,\n", RADIO_FW_VERSION);
+			"This driver is known to work with firmware version %hu,\n",
+			RADIO_FW_VERSION);
 		dev_warn(&intf->dev,
 			"but the device has firmware version %hu.\n",
 			radio->registers[SI_CHIPID] & SI_CHIPID_FIRMWARE);
@@ -705,8 +705,8 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 			radio->software_version, radio->hardware_version);
 	if (radio->hardware_version < RADIO_HW_VERSION) {
 		dev_warn(&intf->dev,
-			"This driver is known to work with "
-			"hardware version %hu,\n", RADIO_HW_VERSION);
+			"This driver is known to work with hardware version %hu,\n",
+			RADIO_HW_VERSION);
 		dev_warn(&intf->dev,
 			"but the device has hardware version %hu.\n",
 			radio->hardware_version);
@@ -718,8 +718,7 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
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



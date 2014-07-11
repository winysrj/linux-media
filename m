Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:3237 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbaGKM5D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 08:57:03 -0400
From: Antonio Ospite <ao2@ao2.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ao2@ao2.it>, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] gspca_stv06xx: enable button found on some Quickcam Express variant
Date: Fri, 11 Jul 2014 14:56:57 +0200
Message-Id: <1405083417-20615-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 drivers/media/usb/gspca/stv06xx/stv06xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
index 49d209b..6ac93d8 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
@@ -505,13 +505,13 @@ static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 {
 	int ret = -EINVAL;
 
-	if (len == 1 && data[0] == 0x80) {
+	if (len == 1 && (data[0] == 0x80 || data[0] == 0x10)) {
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
 		input_sync(gspca_dev->input_dev);
 		ret = 0;
 	}
 
-	if (len == 1 && data[0] == 0x88) {
+	if (len == 1 && (data[0] == 0x88 || data[0] == 0x11)) {
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
 		input_sync(gspca_dev->input_dev);
 		ret = 0;
-- 
2.0.1


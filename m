Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57978 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaCXTcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:32:50 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so4852226eek.13
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:32:49 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 01/19] em28xx: move sub-module data structs to a common place in the main struct
Date: Mon, 24 Mar 2014 20:33:07 +0100
Message-Id: <1395689605-2705-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 4beb1fa..9a3c496 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -541,6 +541,11 @@ struct em28xx_i2c_bus {
 struct em28xx {
 	struct kref ref;
 
+	/* Sub-module data */
+	struct em28xx_dvb *dvb;
+	struct em28xx_audio adev;
+	struct em28xx_IR *ir;
+
 	/* generic device properties */
 	char name[30];		/* name (including minor) of the device */
 	int model;		/* index in the device_data struct */
@@ -576,8 +581,6 @@ struct em28xx {
 
 	struct em28xx_fmt *format;
 
-	struct em28xx_IR *ir;
-
 	/* Some older em28xx chips needs a waiting time after writing */
 	unsigned int wait_after_write;
 
@@ -623,8 +626,6 @@ struct em28xx {
 	unsigned long i2c_hash;	/* i2c devicelist hash -
 				   for boards with generic ID */
 
-	struct em28xx_audio adev;
-
 	/* capture state tracking */
 	int capture_type;
 	unsigned char top_field:1;
@@ -704,8 +705,6 @@ struct em28xx {
 	/* Snapshot button input device */
 	char snapshot_button_path[30];	/* path of the input dev */
 	struct input_dev *sbutton_input_dev;
-
-	struct em28xx_dvb *dvb;
 };
 
 #define kref_to_dev(d) container_of(d, struct em28xx, ref)
-- 
1.8.4.5


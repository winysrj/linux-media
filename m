Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33750 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaAVEP5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jan 2014 23:15:57 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] devices.txt: add video4linux device for Software Defined Radio
Date: Wed, 22 Jan 2014 06:15:30 +0200
Message-Id: <1390364130-8909-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new	video4linux device named /dev/swradio for Software Defined
Radio use. V4L device minor numbers are allocated dynamically
nowadays.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/devices.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 80b7241..6bd551a 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -1493,6 +1493,9 @@ Your cooperation is appreciated.
 		224 = /dev/vbi0		Vertical blank interrupt
 		    ...
 		255 = /dev/vbi31	Vertical blank interrupt
+		0   = /dev/swradio0	Software Defined Radio device
+		1   = /dev/swradio1	Software Defined Radio device
+		    ...
 
  81 block	I2O hard disk
 		  0 = /dev/i2o/hdq	17th I2O hard disk, whole disk
-- 
1.8.4.2


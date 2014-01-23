Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56309 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbaAWVJO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 16:09:14 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [REVIEW PATCH 13/13] devices.txt: add video4linux device for Software Defined Radio
Date: Thu, 23 Jan 2014 23:08:53 +0200
Message-Id: <1390511333-25837-14-git-send-email-crope@iki.fi>
In-Reply-To: <1390511333-25837-1-git-send-email-crope@iki.fi>
References: <1390511333-25837-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new video4linux device named /dev/swradio for Software Defined
Radio use. V4L device minor numbers are allocated dynamically
nowadays, but there is still configuration option for old fixed style.
Add note to mention that configuration option too.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/devices.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 80b7241..e852855 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -1490,10 +1490,17 @@ Your cooperation is appreciated.
 		 64 = /dev/radio0	Radio device
 		    ...
 		127 = /dev/radio63	Radio device
+		128 = /dev/swradio0	Software Defined Radio device
+		    ...
+		191 = /dev/swradio63	Software Defined Radio device
 		224 = /dev/vbi0		Vertical blank interrupt
 		    ...
 		255 = /dev/vbi31	Vertical blank interrupt
 
+		Minor numbers are allocated dynamically unless
+		CONFIG_VIDEO_FIXED_MINOR_RANGES (default n)
+		configuration option is set.
+
  81 block	I2O hard disk
 		  0 = /dev/i2o/hdq	17th I2O hard disk, whole disk
 		 16 = /dev/i2o/hdr	18th I2O hard disk, whole disk
-- 
1.8.5.3


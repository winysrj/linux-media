Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4533 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3CTSjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 14:39:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 09/11] hdpvr: recognize firmware version 0x1e.
Date: Wed, 20 Mar 2013 19:39:00 +0100
Message-Id: <1363804742-5355-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
References: <1363804742-5355-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is the latest firmware version and - it seems - the most reliable.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-core.c |    1 +
 drivers/media/usb/hdpvr/hdpvr.h      |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 248835b..8247c19 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -174,6 +174,7 @@ static int device_authorization(struct hdpvr_device *dev)
 	case HDPVR_FIRMWARE_VERSION_AC3:
 	case HDPVR_FIRMWARE_VERSION_0X12:
 	case HDPVR_FIRMWARE_VERSION_0X15:
+	case HDPVR_FIRMWARE_VERSION_0X1E:
 		dev->flags |= HDPVR_FLAG_AC3_CAP;
 		break;
 	default:
diff --git a/drivers/media/usb/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
index 9450093..1c12981 100644
--- a/drivers/media/usb/hdpvr/hdpvr.h
+++ b/drivers/media/usb/hdpvr/hdpvr.h
@@ -38,6 +38,7 @@
 #define HDPVR_FIRMWARE_VERSION_AC3	0x0d
 #define HDPVR_FIRMWARE_VERSION_0X12	0x12
 #define HDPVR_FIRMWARE_VERSION_0X15	0x15
+#define HDPVR_FIRMWARE_VERSION_0X1E	0x1e
 
 /* #define HDPVR_DEBUG */
 
-- 
1.7.10.4


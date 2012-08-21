Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43956 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2HUJFQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 05:05:16 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.126.78])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5CDCF35A85
	for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 11:05:15 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] uvcvideo: Remove outdated comment
Date: Tue, 21 Aug 2012 11:05:35 +0200
Message-Id: <1345539935-4441-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The uvcvideo driver now supports USERPTR, and isn't limited to YUYV and
MJPEG anymore.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

Small non-functional patch, I will push it through my tree for v3.7.

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 45d7aa1..287f731 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -11,18 +11,6 @@
  *
  */
 
-/*
- * This driver aims to support video input and ouput devices compliant with the
- * 'USB Video Class' specification.
- *
- * The driver doesn't support the deprecated v4l1 interface. It implements the
- * mmap capture method only, and doesn't do any image format conversion in
- * software. If your user-space application doesn't support YUYV or MJPEG, fix
- * it :-). Please note that the MJPEG data have been stripped from their
- * Huffman tables (DHT marker), you will need to add it back if your JPEG
- * codec can't handle MJPEG data.
- */
-
 #include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
-- 
Regards,

Laurent Pinchart


Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42356 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbaBRPdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 10:33:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 0/3] uvcvideo VIDIOC_CREATE_BUFS support
Date: Tue, 18 Feb 2014 16:34:13 +0100
Message-Id: <1392737656-16177-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's the second version of the VIDIOC_CREATE_BUFS support for uvcvideo patch
set.

Compared to v1, patch 3/3 acquires privileges instead of merely checking for
them. Now the driver passes the VIDIOC_CREATE_BUFS v4l2-compliance test.

Laurent Pinchart (2):
  uvcvideo: Remove duplicate check for number of buffers in queue_setup
  uvcvideo: Support allocating buffers larger than the current frame
    size

Philipp Zabel (1):
  uvcvideo: Enable VIDIOC_CREATE_BUFS

 drivers/media/usb/uvc/uvc_queue.c | 20 +++++++++++++++++---
 drivers/media/usb/uvc/uvc_v4l2.c  | 11 +++++++++++
 drivers/media/usb/uvc/uvcvideo.h  |  4 ++--
 3 files changed, 30 insertions(+), 5 deletions(-)

-- 
Regards,

Laurent Pinchart


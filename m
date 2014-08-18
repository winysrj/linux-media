Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43837 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaHRRFs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Aug 2014 13:05:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-usb@vger.kernel.org
Cc: linux-media@vger.kernel.org,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Michael Grzeschik <mgr@pengutronix.de>
Subject: [PATCH 0/2] Move UVC gagdet to video_ioctl2
Date: Mon, 18 Aug 2014 19:06:15 +0200
Message-Id: <1408381577-31901-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This small patch series replaces manual handling of V4L2 ioctls in the UVC
gadget function driver with the video_ioctl2 infrastructure. This simplifies
the driver and brings support for V4L2 tracing features.

The series is based on top of Michael Grzeschik's "usb: gadget/uvc: remove
DRIVER_VERSION{,_NUMBER}" patch. The result can be found at

	git://linuxtv.org/pinchartl/media.git uvc/gadget

The patches have been compile-tested only so far. I'd appreciate if someone
could test them on real hardware.

Laurent Pinchart (2):
  usb: gadget: f_uvc: Store EP0 control request state during setup stage
  usb: gadget: f_uvc: Move to video_ioctl2

 drivers/usb/gadget/function/f_uvc.c    |   7 +
 drivers/usb/gadget/function/uvc_v4l2.c | 315 ++++++++++++++++-----------------
 2 files changed, 164 insertions(+), 158 deletions(-)

-- 
Regards,

Laurent Pinchart


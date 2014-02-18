Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41969 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbaBRO0r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 09:26:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 0/3] uvcvideo VIDIOC_CREATE_BUFS support
Date: Tue, 18 Feb 2014 15:27:46 +0100
Message-Id: <1392733669-5281-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Here's a patch set that enables VIDIOC_CREATE_BUFS support in the uvcvideo
driver. It's based on the patch you've submitted (3/3), with two additional
cleanup patches to simplify the queue_setup implementation and supporting
allocation of buffers larger than the current frame size.

As you've submitted patch 3/3 I assume you have a use case, could you then
please test the patch set to make sure 1/3 and 2/3 don't break anything ?

Laurent Pinchart (2):
  uvcvideo: Remove duplicate check for number of buffers in queue_setup
  uvcvideo: Support allocating buffers larger than the current frame
    size

Philipp Zabel (1):
  uvcvideo: Enable VIDIOC_CREATE_BUFS

 drivers/media/usb/uvc/uvc_queue.c | 20 +++++++++++++++++---
 drivers/media/usb/uvc/uvc_v4l2.c  | 10 ++++++++++
 drivers/media/usb/uvc/uvcvideo.h  |  4 ++--
 3 files changed, 29 insertions(+), 5 deletions(-)

-- 
Regards,

Laurent Pinchart


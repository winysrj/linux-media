Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47377 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752310AbdHHM4R (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 08:56:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 0/5] UVC patches for v4.14
Date: Tue,  8 Aug 2017 15:56:19 +0300
Message-Id: <20170808125624.11328-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Here are the patches to the uvcvideo driver that I have queued for v4.14.

Guennadi Liakhovetski (2):
  uvcvideo: Fix .queue_setup() to check the number of planes
  uvcvideo: Convert from using an atomic variable to a reference count

Guenter Roeck (1):
  uvcvideo: Prevent heap overflow when accessing mapped controls

Jim Lin (1):
  uvcvideo: Fix incorrect timeout for Get Request

Julia Lawall (1):
  uvcvideo: Constify video_subdev structures

 drivers/media/usb/uvc/uvc_ctrl.c   |  7 +++++++
 drivers/media/usb/uvc/uvc_driver.c | 25 +++++++++----------------
 drivers/media/usb/uvc/uvc_entity.c |  2 +-
 drivers/media/usb/uvc/uvc_queue.c  |  9 +++++++--
 drivers/media/usb/uvc/uvcvideo.h   |  4 ++--
 5 files changed, 26 insertions(+), 21 deletions(-)

-- 
Regards,

Laurent Pinchart

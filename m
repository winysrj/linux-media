Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40800 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbdLDXXb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 18:23:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 0/2] uvcvideo: Refactor code to ease metadata implementation
Date: Tue,  5 Dec 2017 01:23:31 +0200
Message-Id: <20171204232333.30084-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

This small patch series refactors the uvc_video_register() function to extract
the code that you need into a new uvc_video_register_device() function. Please
let me know if it can help.

Laurent Pinchart (2):
  uvcvideo: Factor out video device registration to a function
  uvcvideo: Report V4L2 device caps through the video_device structure

 drivers/media/usb/uvc/uvc_driver.c | 77 +++++++++++++++++++++++++-------------
 drivers/media/usb/uvc/uvc_v4l2.c   |  4 --
 drivers/media/usb/uvc/uvcvideo.h   |  8 ++++
 3 files changed, 60 insertions(+), 29 deletions(-)

-- 
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37870 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751088AbdLMJfK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 04:35:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: [PATCH v2 0/2] uvcvideo: Refactor code to ease metadata implementation
Date: Wed, 13 Dec 2017 11:35:07 +0200
Message-Id: <20171213093509.25563-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

This small patch series refactors the uvc_video_register() function to extract
the code that you need into a new uvc_video_register_device() function. Please
let me know if it can help.

Compared to v1, the first patch has been updated not to rely on the fact that
VFL_DIR_RX equals to zero.

Laurent Pinchart (2):
  uvcvideo: Factor out video device registration to a function
  uvcvideo: Report V4L2 device caps through the video_device structure

 drivers/media/usb/uvc/uvc_driver.c | 79 ++++++++++++++++++++++++++------------
 drivers/media/usb/uvc/uvc_v4l2.c   |  4 --
 drivers/media/usb/uvc/uvcvideo.h   |  8 ++++
 3 files changed, 62 insertions(+), 29 deletions(-)

-- 
Regards,

Laurent Pinchart

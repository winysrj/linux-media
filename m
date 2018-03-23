Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59101 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbeCWJW5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 05:22:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v7 0/2] uvcvideo: asynchronous controls
Date: Fri, 23 Mar 2018 11:23:59 +0200
Message-Id: <20180323092401.12162-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

As your v7 of this patch series conflicted with the current version of
the uvcvideo driver, I thought it would be easier to rebase it myself
before reviewing, instead of asking you to do so. Here's the result,
I'll send my review comments as replies.

Guennadi Liakhovetski (2):
  uvcvideo: send a control event when a Control Change interrupt arrives
  uvcvideo: handle control pipe protocol STALLs

 drivers/media/usb/uvc/uvc_ctrl.c   | 166 +++++++++++++++++++++++++++++++++----
 drivers/media/usb/uvc/uvc_status.c | 111 ++++++++++++++++++++++---
 drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
 drivers/media/usb/uvc/uvc_video.c  |  59 +++++++++++--
 drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
 include/uapi/linux/uvcvideo.h      |   2 +
 6 files changed, 322 insertions(+), 35 deletions(-)

-- 
Regards,

Laurent Pinchart

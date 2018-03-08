Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58143 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934121AbeCHRUp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 12:20:45 -0500
Date: Thu, 8 Mar 2018 18:20:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH RESEND 0/2 v6] uvcvideo: asynchronous controls
Message-ID: <alpine.DEB.2.20.1803081815510.17344@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an update of the two patches, adding asynchronous control
support to the uvcvideo driver. If a control is sent, while the camera
is still processing an earlier control, it will generate a protocol
STALL condition on the control pipe.

Thanks
Guennadi

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
1.9.3

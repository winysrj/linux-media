Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54537 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753576AbdLMPe4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 10:34:56 -0500
Received: from axis700.grange ([84.44.207.202]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MQMBU-1ebCpn1EoW-00ToIf for
 <linux-media@vger.kernel.org>; Wed, 13 Dec 2017 16:34:55 +0100
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 33855619BF
        for <linux-media@vger.kernel.org>; Wed, 13 Dec 2017 16:34:54 +0100 (CET)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 0/2 v6] uvcvideo: asynchronous controls
Date: Wed, 13 Dec 2017 16:34:51 +0100
Message-Id: <1513179293-17324-1-git-send-email-guennadi.liakhovetski@intel.com>
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

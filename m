Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58629 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754088AbdBGQ3p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 11:29:45 -0500
Received: from axis700.grange ([81.173.166.100]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MegeC-1cm3n20fZw-00OEm3 for
 <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 17:29:40 +0100
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 3D9238B113
        for <linux-media@vger.kernel.org>; Tue,  7 Feb 2017 17:29:37 +0100 (CET)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 0/4] uvcvideo: asynchronous control reporting
Date: Tue,  7 Feb 2017 17:29:32 +0100
Message-Id: <1486484976-17365-1-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The UVC standard defines a way to implement controls, that take a
relatively long time to process. Such controls can deliver a status
update once their processing has completed. This patch implements
such asynchronous control completion reporting, using V4L2 events.

Support is also added for compound controls, however, V4L2 events
for them will not deliver updated data, since V4L2 events only
support integer (up to 64 bits) controls.

Asynchronous control processing also includes more advanced protocol
STALL handling, which can be caused by racing controls.

Guennadi Liakhovetski (4):
  uvcvideo: prepare to support compound controls
  uvcvideo: send a control event when a Control Change interrupt arrives
  uvcvideo: handle control pipe protocol STALLs
  uvcvideo: support compound controls

 drivers/media/usb/uvc/uvc_ctrl.c   | 397 ++++++++++++++++++++++++++++++-------
 drivers/media/usb/uvc/uvc_status.c | 112 ++++++++++-
 drivers/media/usb/uvc/uvc_v4l2.c   |  10 +-
 drivers/media/usb/uvc/uvc_video.c  |  59 +++++-
 drivers/media/usb/uvc/uvcvideo.h   |  25 ++-
 include/uapi/linux/uvcvideo.h      |   2 +
 6 files changed, 503 insertions(+), 102 deletions(-)

-- 
1.9.3

Thanks
Guennadi


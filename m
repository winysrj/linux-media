Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55379 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932599AbeEHPHr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 11:07:47 -0400
Received: from axis700.grange ([87.78.226.14]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0M4002-1ePkoN2J2A-00ra6H for
 <linux-media@vger.kernel.org>; Tue, 08 May 2018 17:07:45 +0200
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 920B860EC3
        for <linux-media@vger.kernel.org>; Tue,  8 May 2018 17:07:44 +0200 (CEST)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v8 0/3] uvcvideo: asynchronous controls
Date: Tue,  8 May 2018 17:07:41 +0200
Message-Id: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added a patch to remove a redundant check, addressed Laurent's
comments.

Guennadi Liakhovetski (3):
  uvcvideo: remove a redundant check
  uvcvideo: send a control event when a Control Change interrupt arrives
  uvcvideo: handle control pipe protocol STALLs

 drivers/media/usb/uvc/uvc_ctrl.c   | 168 ++++++++++++++++++++++++++++++-------
 drivers/media/usb/uvc/uvc_status.c | 112 ++++++++++++++++++++++---
 drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
 drivers/media/usb/uvc/uvc_video.c  |  52 ++++++++++--
 drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
 include/uapi/linux/uvcvideo.h      |   2 +
 6 files changed, 302 insertions(+), 51 deletions(-)

-- 
1.9.3

Thanks
Guennadi

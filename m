Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:41013 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932719AbeEHPHr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 11:07:47 -0400
Received: from axis700.grange ([87.78.226.14]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LqQnR-1ec2VM39ZB-00e0h5 for
 <linux-media@vger.kernel.org>; Tue, 08 May 2018 17:07:45 +0200
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id B9BE761809
        for <linux-media@vger.kernel.org>; Tue,  8 May 2018 17:07:44 +0200 (CEST)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: [PATCH v8 1/3] uvcvideo: remove a redundant check
Date: Tue,  8 May 2018 17:07:42 +0200
Message-Id: <1525792064-30836-2-git-send-email-guennadi.liakhovetski@intel.com>
In-Reply-To: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com>
References: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Event subscribers cannot have a NULL file handle. They are only added
at a single location in the code, and the .fh pointer is used without
checking there.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index a36b4fb..2a213c8 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1229,9 +1229,9 @@ static void uvc_ctrl_send_event(struct uvc_fh *handle,
 	uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping, value, changes);
 
 	list_for_each_entry(sev, &mapping->ev_subs, node) {
-		if (sev->fh && (sev->fh != &handle->vfh ||
+		if (sev->fh != &handle->vfh ||
 		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK) ||
-		    (changes & V4L2_EVENT_CTRL_CH_FLAGS)))
+		    (changes & V4L2_EVENT_CTRL_CH_FLAGS))
 			v4l2_event_queue_fh(sev->fh, &ev);
 	}
 }
-- 
1.9.3

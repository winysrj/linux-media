Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53476 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751673AbdG1Mda (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 08:33:30 -0400
Received: from axis700.grange ([87.78.105.5]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MRWzQ-1d8UzY3en2-00Seve for
 <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 14:33:28 +0200
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 231468B111
        for <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 14:30:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: [PATCH 1/6 v5]  UVC: fix .queue_setup() to check the number of planes
Date: Fri, 28 Jul 2017 14:33:20 +0200
Message-Id: <1501245205-15802-2-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to documentation of struct vb2_ops the .queue_setup() callback
should return an error if the number of planes parameter contains an
invalid value on input. Fix this instead of ignoring the value.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index aa21997..371a4ad 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -84,7 +84,7 @@ static int uvc_queue_setup(struct vb2_queue *vq,
 
 	/* Make sure the image size is large enough. */
 	if (*nplanes)
-		return sizes[0] < size ? -EINVAL : 0;
+		return sizes[0] < size || *nplanes != 1 ? -EINVAL : 0;
 	*nplanes = 1;
 	sizes[0] = size;
 	return 0;
-- 
1.9.3

Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48875 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab0JFI7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:42 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id C009B35FEA
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:39 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 07/14] uvcvideo: Set bandwidth to at least 1024 with the FIX_BANDWIDTH quirk
Date: Wed,  6 Oct 2010 10:59:45 +0200
Message-Id: <1286355592-13603-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The bandwidth estimate computed with the FIX_BANDIWDTH quirk is too low
for many cameras. Don't use maximum packet sizes lower than 1024 bytes
to try and work around the problem. According to measurements done on
two different camera models, the value is high enough to get most
resolutions working while not preventing two simultaneous VGA streams at
15 fps.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_video.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index ee5e233..5a2022c 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -138,6 +138,15 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 			bandwidth /= 8;
 		bandwidth += 12;
 
+		/* The bandwidth estimate is too low for many cameras. Don't use
+		 * maximum packet sizes lower than 1024 bytes to try and work
+		 * around the problem. According to measurements done on two
+		 * different camera models, the value is high enough to get most
+		 * resolutions working while not preventing two simultaneous
+		 * VGA streams at 15 fps.
+		 */
+		bandwidth = max_t(u32, bandwidth, 1024);
+
 		ctrl->dwMaxPayloadTransferSize = bandwidth;
 	}
 }
-- 
1.7.2.2


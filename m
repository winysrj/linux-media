Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48874 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab0JFI7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:41 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 3373E35DA9
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:39 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 04/14] uvcvideo: Constify the uvc_entity_match_guid arguments
Date: Wed,  6 Oct 2010 10:59:42 +0200
Message-Id: <1286355592-13603-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

They're not modified by the function, make them const.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index bce29fd..d8dc1e1 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -727,7 +727,8 @@ static const __u8 uvc_camera_guid[16] = UVC_GUID_UVC_CAMERA;
 static const __u8 uvc_media_transport_input_guid[16] =
 	UVC_GUID_UVC_MEDIA_TRANSPORT_INPUT;
 
-static int uvc_entity_match_guid(struct uvc_entity *entity, __u8 guid[16])
+static int uvc_entity_match_guid(const struct uvc_entity *entity,
+	const __u8 guid[16])
 {
 	switch (UVC_ENTITY_TYPE(entity)) {
 	case UVC_ITT_CAMERA:
-- 
1.7.2.2


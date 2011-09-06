Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37057 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab1IFW3L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 18:29:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: JJosh Boyer <jwboyer@redhat.com>, Dave Jones <davej@redhat.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Daniel Dickinson <libre@cshore.neomailbox.net>,
	637740@bugs.debian.org
Subject: [PATCH] uvcvideo: Fix crash when linking entities
Date: Wed,  7 Sep 2011 00:29:08 +0200
Message-Id: <1315348148-7207-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The uvc_mc_register_entity() function wrongfully selects the
media_entity associated with a UVC entity when creating links. This
results in access to uninitialized media_entity structures and can hit a
BUG_ON statement in media_entity_create_link(). Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_entity.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

This patch should fix a v3.0 regression that results in a kernel crash as
reported in http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=637740 and
https://bugzilla.redhat.com/show_bug.cgi?id=735437.

Test results will be welcome.

diff --git a/drivers/media/video/uvc/uvc_entity.c b/drivers/media/video/uvc/uvc_entity.c
index 48fea37..29e2399 100644
--- a/drivers/media/video/uvc/uvc_entity.c
+++ b/drivers/media/video/uvc/uvc_entity.c
@@ -49,7 +49,7 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 		if (remote == NULL)
 			return -EINVAL;
 
-		source = (UVC_ENTITY_TYPE(remote) != UVC_TT_STREAMING)
+		source = (UVC_ENTITY_TYPE(remote) == UVC_TT_STREAMING)
 		       ? (remote->vdev ? &remote->vdev->entity : NULL)
 		       : &remote->subdev.entity;
 		if (source == NULL)
-- 
Regards,

Laurent Pinchart


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab2DHP56 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Apr 2012 11:57:58 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 10/10] uvcvideo: Drop unused ctrl member from struct uvc_control_mapping
Date: Sun,  8 Apr 2012 17:59:54 +0200
Message-Id: <1333900794-1932-11-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
References: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |    1 -
 drivers/media/video/uvc/uvcvideo.h |    2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 38d633a..d520c5c 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1876,7 +1876,6 @@ static int __uvc_ctrl_add_mapping(struct uvc_device *dev,
 	if (map->set == NULL)
 		map->set = uvc_set_le_value;
 
-	map->ctrl = &ctrl->info;
 	list_add_tail(&map->list, &ctrl->info.mappings);
 	uvc_trace(UVC_TRACE_CONTROL,
 		"Adding mapping '%s' to control %pUl/%u.\n",
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 777bb75..7c3d082 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -157,8 +157,6 @@ struct uvc_control_mapping {
 	struct list_head list;
 	struct list_head ev_subs;
 
-	struct uvc_control_info *ctrl;
-
 	__u32 id;
 	__u8 name[32];
 	__u8 entity[16];
-- 
1.7.9.3


Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37230 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab3AKNMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:12:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/3] uvcvideo: Return -EACCES when trying to access a read/write-only control
Date: Fri, 11 Jan 2013 14:13:58 +0100
Message-Id: <1357910040-27463-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1357910040-27463-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1357910040-27463-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit ba68c8530a263dc4de440fa10bb20a1c5b9d4ff5 (Partly revert "[media]
uvcvideo: Set error_idx properly for extended controls API failures")
also reverted commit 30ecb936cbcd83e3735625ac63e1b4466546f5fe
("uvcvideo: Return -EACCES when trying to access a read/write-only
control") by mistake. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 2bb7613..d5baab1 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1431,8 +1431,10 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 	int ret;
 
 	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
-	if (ctrl == NULL || (ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR) == 0)
+	if (ctrl == NULL)
 		return -EINVAL;
+	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR))
+		return -EACCES;
 
 	/* Clamp out of range values. */
 	switch (mapping->v4l2_type) {
-- 
1.7.8.6


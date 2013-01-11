Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37231 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab3AKNMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:12:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/3] uvcvideo: Cleanup leftovers of partial revert
Date: Fri, 11 Jan 2013 14:13:59 +0100
Message-Id: <1357910040-27463-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1357910040-27463-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1357910040-27463-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit ba68c8530a263dc4de440fa10bb20a1c5b9d4ff5 (Partly revert "[media]
uvcvideo: Set error_idx properly for extended controls API failures")
missed two modifications. Clean them up.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_v4l2.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index f2ee8c6..5eb8989 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -657,8 +657,7 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			ret = uvc_ctrl_get(chain, ctrl);
 			if (ret < 0) {
 				uvc_ctrl_rollback(handle);
-				ctrls->error_idx = ret == -ENOENT
-						 ? ctrls->count : i;
+				ctrls->error_idx = i;
 				return ret;
 			}
 		}
@@ -686,9 +685,7 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			ret = uvc_ctrl_set(chain, ctrl);
 			if (ret < 0) {
 				uvc_ctrl_rollback(handle);
-				ctrls->error_idx = (ret == -ENOENT &&
-						    cmd == VIDIOC_S_EXT_CTRLS)
-						 ? ctrls->count : i;
+				ctrls->error_idx = i;
 				return ret;
 			}
 		}
-- 
1.7.8.6


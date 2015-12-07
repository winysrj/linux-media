Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57856 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbLGIpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2015 03:45:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
Subject: [PATCH] v4l: Fix dma buf single plane compat handling
Date: Mon,  7 Dec 2015 10:45:39 +0200
Message-Id: <1449477939-5658-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>

Buffer length is needed for single plane as well, otherwise
is uninitialized and behaviour is undetermined.

Signed-off-by: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8fd84a67478a..b0faa1f7e3a9 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -482,8 +482,10 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 				return -EFAULT;
 			break;
 		case V4L2_MEMORY_DMABUF:
-			if (get_user(kp->m.fd, &up->m.fd))
+			if (get_user(kp->m.fd, &up->m.fd) ||
+			    get_user(kp->length, &up->length))
 				return -EFAULT;
+
 			break;
 		}
 	}
@@ -550,7 +552,8 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 				return -EFAULT;
 			break;
 		case V4L2_MEMORY_DMABUF:
-			if (put_user(kp->m.fd, &up->m.fd))
+			if (put_user(kp->m.fd, &up->m.fd) ||
+			    put_user(kp->length, &up->length))
 				return -EFAULT;
 			break;
 		}
-- 
2.4.10


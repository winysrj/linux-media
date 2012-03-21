Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:31263 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2CUGf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 02:35:56 -0400
Date: Wed, 21 Mar 2012 09:35:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] uvcvideo: remove unneeded access_ok() check
Message-ID: <20120321063523.GA20062@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

copy_in_user() already checks for write permission, so we don't need to
do it here.  This was added in 1a5e4c867c "[media] uvcvideo: Implement
compat_ioctl32 for custom ioctls".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index ff2cddd..111bfff 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1105,8 +1105,6 @@ static int uvc_v4l2_put_xu_mapping(const struct uvc_xu_control_mapping *kp,
 	if (get_user(p, &up->menu_info))
 		return -EFAULT;
 	umenus = compat_ptr(p);
-	if (!access_ok(VERIFY_WRITE, umenus, kp->menu_count * sizeof(*umenus)))
-		return -EFAULT;
 
 	if (copy_in_user(umenus, kmenus, kp->menu_count * sizeof(*umenus)))
 		return -EFAULT;

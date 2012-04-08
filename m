Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815Ab2DHP5u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Apr 2012 11:57:50 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 04/10] =?UTF-8?q?uvcvideo:=20Fix=20a=20"ignoring=20return=20?= =?UTF-8?q?value=20of=20=E2=80=98=5F=5Fclear=5Fuser=E2=80=99"=20warning?=
Date: Sun,  8 Apr 2012 17:59:48 +0200
Message-Id: <1333900794-1932-5-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
References: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/uvc/uvc_v4l2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index ff2cddd..8db90ef 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1097,7 +1097,8 @@ static int uvc_v4l2_put_xu_mapping(const struct uvc_xu_control_mapping *kp,
 	    __put_user(kp->menu_count, &up->menu_count))
 		return -EFAULT;
 
-	__clear_user(up->reserved, sizeof(up->reserved));
+	if (__clear_user(up->reserved, sizeof(up->reserved)))
+		return -EFAULT;
 
 	if (kp->menu_count == 0)
 		return 0;
-- 
1.7.9.3


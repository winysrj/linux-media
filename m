Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:49036 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZFFJQy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 05:16:54 -0400
Received: by rv-out-0506.google.com with SMTP id f9so826360rvb.1
        for <linux-media@vger.kernel.org>; Sat, 06 Jun 2009 02:16:56 -0700 (PDT)
Subject: [PATCH] zr364xx.c: vfree does its own NULL check
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 17:16:21 +0800
Message-Id: <1244279782.3185.9.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vfree() does it's own NULL checking, no need for explicit check before
calling it.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 
 drivers/media/video/zr364xx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index ac169c9..fc976f4 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -882,9 +882,11 @@ static void zr364xx_disconnect(struct usb_interface *intf)
 		video_unregister_device(cam->vdev);
 	cam->vdev = NULL;
 	kfree(cam->buffer);
-	if (cam->framebuf)
-		vfree(cam->framebuf);
+	cam->buffer = NULL;
+	vfree(cam->framebuf);
+	cam->framebuf = NULL;
 	kfree(cam);
+	cam = NULL;
 }
 
 

 

 
 



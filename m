Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37897 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbbIPXzO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 19:55:14 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] go7007: Fix returned errno code in gen_mjpeghdr_to_package()
Date: Thu, 17 Sep 2015 01:55:04 +0200
Message-Id: <1442447704-3355-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver is using -1 instead of the -ENOMEM defined macro to specify
that a buffer allocation failed. Since the error number is propagated,
the caller will get a -EPERM which is the wrong error condition.

Also, the smatch tool complains with the following warning:

gen_mjpeghdr_to_package() warn: returning -1 instead of -ENOMEM is sloppy

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/usb/go7007/go7007-fw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-fw.c b/drivers/media/usb/go7007/go7007-fw.c
index 5f4c9b9e899a..60bf5f0644d1 100644
--- a/drivers/media/usb/go7007/go7007-fw.c
+++ b/drivers/media/usb/go7007/go7007-fw.c
@@ -379,7 +379,7 @@ static int gen_mjpeghdr_to_package(struct go7007 *go, __le16 *code, int space)
 
 	buf = kzalloc(4096, GFP_KERNEL);
 	if (buf == NULL)
-		return -1;
+		return -ENOMEM;
 
 	for (i = 1; i < 32; ++i) {
 		mjpeg_frame_header(go, buf + size, i);
@@ -646,7 +646,7 @@ static int gen_mpeg1hdr_to_package(struct go7007 *go,
 
 	buf = kzalloc(5120, GFP_KERNEL);
 	if (buf == NULL)
-		return -1;
+		return -ENOMEM;
 
 	framelen[0] = mpeg1_frame_header(go, buf, 0, 1, PFRAME);
 	if (go->interlace_coding)
@@ -832,7 +832,7 @@ static int gen_mpeg4hdr_to_package(struct go7007 *go,
 
 	buf = kzalloc(5120, GFP_KERNEL);
 	if (buf == NULL)
-		return -1;
+		return -ENOMEM;
 
 	framelen[0] = mpeg4_frame_header(go, buf, 0, PFRAME);
 	i = 368;
-- 
2.4.3


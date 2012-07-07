Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab2GGIkf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jul 2012 04:40:35 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] media/video: Add v4l2-common.h to userspace headers
Date: Sat,  7 Jul 2012 10:45:31 +0200
Message-Id: <1341650731-6520-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The user header CHECK in usr/include/linux was (rightfully) failing because of
v4l2-common.h missing, this patch fixes this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index d38b3a8..ef4cc94 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -382,6 +382,7 @@ header-y += usbdevice_fs.h
 header-y += utime.h
 header-y += utsname.h
 header-y += uvcvideo.h
+header-y += v4l2-common.h
 header-y += v4l2-dv-timings.h
 header-y += v4l2-mediabus.h
 header-y += v4l2-subdev.h
-- 
1.7.10.4


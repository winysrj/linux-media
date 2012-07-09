Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48207 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751764Ab2GIJTt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jul 2012 05:19:49 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: sfr@canb.auug.org.au
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	s.nawrocki@samsung.com
Subject: [PATCH 1/1] v4l: Export v4l2-common.h in include/linux/Kbuild
Date: Mon,  9 Jul 2012 12:10:26 +0300
Message-Id: <1341825026-29120-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120709115046.f09fe2d15e33e7502cbad222@canb.auug.org.au>
References: <20120709115046.f09fe2d15e33e7502cbad222@canb.auug.org.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-common.h is a header file that's used in user space, thus it must be
exported using header-y.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
Hi Stephen,

Could you try is this patch fixes your issue? The header file indeed should
be exported which wasn't done previously.

 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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
1.7.2.5


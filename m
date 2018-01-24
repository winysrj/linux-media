Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44564 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932474AbeAXVkz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 16:40:55 -0500
From: =?UTF-8?q?Christopher=20D=C3=ADaz=20Riveros?= <chrisadr@gentoo.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com,
        arvind.yadav.cs@gmail.com, dean@sensoray.com,
        keescook@chromium.org, bhumirks@gmail.com,
        sakari.ailus@linux.intel.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH-next] media: s2255drv: Remove unneeded if else blocks
Date: Wed, 24 Jan 2018 16:40:43 -0500
Message-Id: <20180124214043.16429-1-chrisadr@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Given the following definitions from s2255drv.c

 #define LINE_SZ_4CIFS_NTSC      640
 #define LINE_SZ_2CIFS_NTSC      640
 #define LINE_SZ_1CIFS_NTSC      320

and

 #define LINE_SZ_4CIFS_PAL       704
 #define LINE_SZ_2CIFS_PAL       704
 #define LINE_SZ_1CIFS_PAL       352

f->fmt.pix.width possible values can be reduced to
LINE_SZ_4CIFS_NTSC or LINE_SZ_1CIFS_NTSC.

This patch removes unneeded if else blocks in vidioc_try_fmt_vid_cap
function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Christopher Díaz Riveros <chrisadr@gentoo.org>
---
 drivers/media/usb/s2255/s2255drv.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 8c2a86d71e8a..a00a15f55d37 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -803,10 +803,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		}
 		if (f->fmt.pix.width >= LINE_SZ_4CIFS_NTSC)
 			f->fmt.pix.width = LINE_SZ_4CIFS_NTSC;
-		else if (f->fmt.pix.width >= LINE_SZ_2CIFS_NTSC)
-			f->fmt.pix.width = LINE_SZ_2CIFS_NTSC;
-		else if (f->fmt.pix.width >= LINE_SZ_1CIFS_NTSC)
-			f->fmt.pix.width = LINE_SZ_1CIFS_NTSC;
 		else
 			f->fmt.pix.width = LINE_SZ_1CIFS_NTSC;
 	} else {
@@ -820,10 +816,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		}
 		if (f->fmt.pix.width >= LINE_SZ_4CIFS_PAL)
 			f->fmt.pix.width = LINE_SZ_4CIFS_PAL;
-		else if (f->fmt.pix.width >= LINE_SZ_2CIFS_PAL)
-			f->fmt.pix.width = LINE_SZ_2CIFS_PAL;
-		else if (f->fmt.pix.width >= LINE_SZ_1CIFS_PAL)
-			f->fmt.pix.width = LINE_SZ_1CIFS_PAL;
 		else
 			f->fmt.pix.width = LINE_SZ_1CIFS_PAL;
 	}
-- 
2.16.0

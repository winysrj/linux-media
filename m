Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725873AbeKLTyS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 14:54:18 -0500
Date: Mon, 12 Nov 2018 11:01:46 +0100
From: Jean Delvare <jdelvare@suse.de>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] media: v4l: v4l2-controls.h must include types.h
Message-ID: <20181112110146.5baee2ea@endymion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following build-time warning:
./usr/include/linux/v4l2-controls.h:1105: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: c27bb30e7b6d ("media: v4l: Add definitions for MPEG-2 slice format and metadata")
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
---
 include/uapi/linux/v4l2-controls.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-4.20-rc2.orig/include/uapi/linux/v4l2-controls.h	2018-11-12 09:34:20.869048454 +0100
+++ linux-4.20-rc2/include/uapi/linux/v4l2-controls.h	2018-11-12 10:54:38.864904194 +0100
@@ -50,6 +50,8 @@
 #ifndef __LINUX_V4L2_CONTROLS_H
 #define __LINUX_V4L2_CONTROLS_H
 
+#include <linux/types.h>		/* for __u* typedefs */
+
 /* Control classes */
 #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls */
 #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls */


-- 
Jean Delvare
SUSE L3 Support

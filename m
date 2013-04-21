Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab3DUTAr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 15:00:47 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3LJ0lam022601
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 21 Apr 2013 15:00:47 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv3 02/10] [media] videodev2.h: Remove the unused old V4L1 buffer types
Date: Sun, 21 Apr 2013 16:00:31 -0300
Message-Id: <1366570839-662-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366570839-662-1-git-send-email-mchehab@redhat.com>
References: <1366570839-662-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those aren't used anywhere for a long time. Drop it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/uapi/linux/videodev2.h | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 4aa24c3..5d8ee92 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -72,27 +72,6 @@
 #define VIDEO_MAX_FRAME               32
 #define VIDEO_MAX_PLANES               8
 
-#ifndef __KERNEL__
-
-/* These defines are V4L1 specific and should not be used with the V4L2 API!
-   They will be removed from this header in the future. */
-
-#define VID_TYPE_CAPTURE	1	/* Can capture */
-#define VID_TYPE_TUNER		2	/* Can tune */
-#define VID_TYPE_TELETEXT	4	/* Does teletext */
-#define VID_TYPE_OVERLAY	8	/* Overlay onto frame buffer */
-#define VID_TYPE_CHROMAKEY	16	/* Overlay by chromakey */
-#define VID_TYPE_CLIPPING	32	/* Can clip */
-#define VID_TYPE_FRAMERAM	64	/* Uses the frame buffer memory */
-#define VID_TYPE_SCALES		128	/* Scalable */
-#define VID_TYPE_MONOCHROME	256	/* Monochrome only */
-#define VID_TYPE_SUBCAPTURE	512	/* Can capture subareas of the image */
-#define VID_TYPE_MPEG_DECODER	1024	/* Can decode MPEG streams */
-#define VID_TYPE_MPEG_ENCODER	2048	/* Can encode MPEG streams */
-#define VID_TYPE_MJPEG_DECODER	4096	/* Can decode MJPEG streams */
-#define VID_TYPE_MJPEG_ENCODER	8192	/* Can encode MJPEG streams */
-#endif
-
 /*
  *	M I S C E L L A N E O U S
  */
-- 
1.8.1.4


Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:16067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab1EYVeu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 17:34:50 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4PLYoM6008200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 25 May 2011 17:34:50 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] [media] gspca/kinect: wrap gspca_debug with GSPCA_DEBUG
Date: Wed, 25 May 2011 17:34:32 -0400
Message-Id: <1306359272-30792-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1306305788.2390.4.camel@porites>
References: <1306305788.2390.4.camel@porites>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fixes media_build, and presumably certain other upstream kernel build
option combos.

Before:
  CC [M]  /home/jarod/src/media_build/v4l/kinect.o
/home/jarod/src/media_build/v4l/kinect.c:38:19: error: 'D_ERR' undeclared here (not in a function)
/home/jarod/src/media_build/v4l/kinect.c:38:27: error: 'D_PROBE' undeclared here (not in a function)
/home/jarod/src/media_build/v4l/kinect.c:38:37: error: 'D_CONF' undeclared here (not in a function)
/home/jarod/src/media_build/v4l/kinect.c:38:46: error: 'D_STREAM' undeclared here (not in a function)
/home/jarod/src/media_build/v4l/kinect.c:38:57: error: 'D_FRAM' undeclared here (not in a function)
/home/jarod/src/media_build/v4l/kinect.c:38:66: error: 'D_PACK' undeclared here (not in a function)
/home/jarod/src/media_build/v4l/kinect.c:39:2: error: 'D_USBI' undeclared here (not in a function)
/home/jarod/src/media_build/v4l/kinect.c:39:11: error: 'D_USBO' undeclared here (not in a function)
/home/jarod/src/media_build/v4l/kinect.c:39:20: error: 'D_V4L2' undeclared here (not in a function)
make[3]: *** [/home/jarod/src/media_build/v4l/kinect.o] Error 1

After:
  CC [M]  /home/jarod/src/media_build/v4l/kinect.o
  ...
  LD [M]  /home/jarod/src/media_build/v4l/gspca_kinect.ko
  ...
  profit

Reported-by: Nicolas Will <nico@youplala.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/video/gspca/kinect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/gspca/kinect.c
index 66671a4..26fc206 100644
--- a/drivers/media/video/gspca/kinect.c
+++ b/drivers/media/video/gspca/kinect.c
@@ -34,7 +34,7 @@ MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
 MODULE_DESCRIPTION("GSPCA/Kinect Sensor Device USB Camera Driver");
 MODULE_LICENSE("GPL");
 
-#ifdef DEBUG
+#ifdef GSPCA_DEBUG
 int gspca_debug = D_ERR | D_PROBE | D_CONF | D_STREAM | D_FRAM | D_PACK |
 	D_USBI | D_USBO | D_V4L2;
 #endif
-- 
1.7.1


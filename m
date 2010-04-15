Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway08.websitewelcome.com ([67.18.34.19]:42739 "HELO
	gateway08.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751403Ab0DOXSh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 19:18:37 -0400
Date: Thu, 15 Apr 2010 15:51:52 -0700 (PDT)
From: sensoray-dev <linux-dev@sensoray.com>
Subject: s2255drv: V4L2_MODE_HIGHQUALITY fix
To: linux-media@vger.kernel.org
Message-ID: <tkrat.001f6db5e6ea287d@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <linux-dev@sensoray.com>
# Date 1271371685 25200
# Node ID fae20d178e2cc96d75a43c50e0f84140022091a3
# Parent  f12b3074bb02dbb9b9d5af3aa816bd53e6b61dd1
s2255drv: V4L2 mode high quality fix

From: Dean Anderson <linux-dev@sensoray.com>

fix for last patch in case it is applied. submitted incorrect patch (channel/stream).

Priority: high

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>

diff -r f12b3074bb02 -r fae20d178e2c linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Thu Apr 15 15:40:56 2010 -0700
+++ b/linux/drivers/media/video/s2255drv.c	Thu Apr 15 15:48:05 2010 -0700
@@ -1660,7 +1660,7 @@
 	}
 	mode.fdec = fdec;
 	sp->parm.capture.timeperframe.denominator = def_dem;
-	stream->cap_parm = sp->parm.capture;
+	channel->cap_parm = sp->parm.capture;
 	s2255_set_mode(channel, &mode);
 	dprintk(4, "%s capture mode, %d timeperframe %d/%d, fdec %d\n",
 		__func__,


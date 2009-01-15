Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:62556 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbZAOC7k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 21:59:40 -0500
Received: by ewy10 with SMTP id 10so1041169ewy.13
        for <linux-media@vger.kernel.org>; Wed, 14 Jan 2009 18:59:38 -0800 (PST)
From: Kyle Guinn <elyk03@gmail.com>
To: moinejf@free.fr
Subject: [PATCH 1/2] Add Mars-Semi MR97310A format
Date: Wed, 14 Jan 2009 20:59:34 -0600
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901142059.34943.elyk03@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Kyle Guinn <elyk03@gmail.com>
# Date 1231822560 21600
# Node ID 1bf7a4403e5f1cd10f12a69a9d9239f1bf4a58b6
# Parent  b09b5128742f75bb0ce4375b23feac6c5f560aec
Add Mars-Semi MR97310A format

From: Kyle Guinn <elyk03@gmail.com>

Add a pixel format for the Mars-Semi MR97310A webcam controller.

The MR97310A is a dual-mode webcam controller that provides compressed BGGR
Bayer frames.  The decompression algorithm for still images is the same as for
video, and is currently implemented in libgphoto2.

Priority: normal

Signed-off-by: Kyle Guinn <elyk03@gmail.com>

diff --git a/linux/include/linux/videodev2.h b/linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h
+++ b/linux/include/linux/videodev2.h
@@ -344,6 +344,7 @@
 #define V4L2_PIX_FMT_SPCA508  v4l2_fourcc('S', '5', '0', '8') /* YUVY per line */
 #define V4L2_PIX_FMT_SPCA561  v4l2_fourcc('S', '5', '6', '1') /* compressed GBRG bayer */
 #define V4L2_PIX_FMT_PAC207   v4l2_fourcc('P', '2', '0', '7') /* compressed BGGR bayer */
+#define V4L2_PIX_FMT_MR97310A v4l2_fourcc('M', '3', '1', '0') /* compressed BGGR bayer */
 #define V4L2_PIX_FMT_PJPG     v4l2_fourcc('P', 'J', 'P', 'G') /* Pixart 73xx JPEG */
 #define V4L2_PIX_FMT_YVYU    v4l2_fourcc('Y', 'V', 'Y', 'U') /* 16  YVU 4:2:2     */
 

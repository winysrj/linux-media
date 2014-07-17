Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2596 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaGQWYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 18:24:39 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6HMOZ3f029531
	for <linux-media@vger.kernel.org>; Fri, 18 Jul 2014 00:24:38 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0C1DA2A1FD1
	for <linux-media@vger.kernel.org>; Fri, 18 Jul 2014 00:24:34 +0200 (CEST)
Message-ID: <53C84D21.5000505@xs4all.nl>
Date: Fri, 18 Jul 2014 00:24:33 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v3.17] DocBook media: fix incorrect note about packed
 RGB and colorspace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fact that the pixelformat is using a packed RGB format has nothing
to do with the colorspace that is being used. Those are very different
things. The colorspace decides what color a triplet of RGB numbers
actually map to. E.g. a red color with values (255, 0, 0) is a different
type of red depending on the colorspace. If the original pixelformat was
e.g. YUV in colorspace REC709, then after the conversion to RGB the
colorspace is still REC709. Unless the hardware actually converted the
colorspace as well from REC709 to sRGB, but that rarely if ever happens.

Remove this incorrect comment.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
index 5f1602f..2aae8e9 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
@@ -15,9 +15,6 @@ typical PC graphics frame buffers. They occupy 8, 16, 24 or 32 bits
 per pixel. These are all packed-pixel formats, meaning all the data
 for a pixel lie next to each other in memory.</para>
 
-    <para>When one of these formats is used, drivers shall report the
-colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
-
     <table pgwide="1" frame="none" id="rgb-formats">
       <title>Packed RGB Image Formats</title>
       <tgroup cols="37" align="center">
-- 
2.0.0


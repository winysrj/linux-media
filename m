Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:55020 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751940AbbFONxB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 09:53:01 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 24A552A007E
	for <linux-media@vger.kernel.org>; Mon, 15 Jun 2015 15:52:40 +0200 (CEST)
Message-ID: <557ED8A8.3010407@xs4all.nl>
Date: Mon, 15 Jun 2015 15:52:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] videodev2.h: fix copy-and-paste error in V4L2_MAP_XFER_FUNC_DEFAULT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The colorspace argument was compared against a V4L2_XFER_FUNC define instead
of against a V4L2_COLORSPACE define, returning the wrong answer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 3d5fc72..3228fbe 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -270,7 +270,7 @@ enum v4l2_xfer_func {
  * This depends on the colorspace.
  */
 #define V4L2_MAP_XFER_FUNC_DEFAULT(colsp) \
-	((colsp) == V4L2_XFER_FUNC_ADOBERGB ? V4L2_XFER_FUNC_ADOBERGB : \
+	((colsp) == V4L2_COLORSPACE_ADOBERGB ? V4L2_XFER_FUNC_ADOBERGB : \
 	 ((colsp) == V4L2_COLORSPACE_SMPTE240M ? V4L2_XFER_FUNC_SMPTE240M : \
 	  ((colsp) == V4L2_COLORSPACE_RAW ? V4L2_XFER_FUNC_NONE : \
 	   ((colsp) == V4L2_COLORSPACE_SRGB || (colsp) == V4L2_COLORSPACE_JPEG ? \

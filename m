Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:52100 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756367AbcISHWa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 03:22:30 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Tiffany Lin <tiffany.lin@mediatek.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pixfmt-reserved.rst: Improve MT21C documentation
Message-ID: <82516dbf-d85e-ac69-0059-8235e4903e5a@xs4all.nl>
Date: Mon, 19 Sep 2016 09:22:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve the MT21C documentation, making it clearer that this format requires the MDP
for further processing.

Also fix the fourcc (it was a fivecc :-) )

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
index 0989e99..a019f15 100644
--- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
@@ -343,13 +343,13 @@ please make a proposal on the linux-media mailing list.

        -  ``V4L2_PIX_FMT_MT21C``

-       -  'MT21C'
+       -  'MT21'

        -  Compressed two-planar YVU420 format used by Mediatek MT8173.
           The compression is lossless.
-          It is an opaque intermediate format, and MDP HW could convert
-          V4L2_PIX_FMT_MT21C to V4L2_PIX_FMT_NV12M,
-          V4L2_PIX_FMT_YUV420M and V4L2_PIX_FMT_YVU420.
+          It is an opaque intermediate format and the MDP hardware must be
+	  used to convert ``V4L2_PIX_FMT_MT21C`` to ``V4L2_PIX_FMT_NV12M``,
+          ``V4L2_PIX_FMT_YUV420M`` or ``V4L2_PIX_FMT_YVU420``.

 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|


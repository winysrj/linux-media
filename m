Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:48305 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750760AbcIIPsP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 11:48:15 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <Tiffany.lin@mediatek.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v2 2/4] docs-rst: Add compressed video formats used on MT8173 codec driver
Date: Fri, 9 Sep 2016 23:48:05 +0800
Message-ID: <1473436087-21943-3-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1473436087-21943-2-git-send-email-tiffany.lin@mediatek.com>
References: <1473436087-21943-1-git-send-email-tiffany.lin@mediatek.com>
 <1473436087-21943-2-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_PIX_FMT_MT21C documentation

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 Documentation/media/uapi/v4l/pixfmt-reserved.rst |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
index 0dd2f7f..0989e99 100644
--- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
@@ -339,7 +339,17 @@ please make a proposal on the linux-media mailing list.
 	  array. Anything what's in between the UYVY lines is JPEG data and
 	  should be concatenated to form the JPEG stream.
 
+    -  .. _V4L2-PIX-FMT-MT21C:
 
+       -  ``V4L2_PIX_FMT_MT21C``
+
+       -  'MT21C'
+
+       -  Compressed two-planar YVU420 format used by Mediatek MT8173.
+          The compression is lossless.
+          It is an opaque intermediate format, and MDP HW could convert
+          V4L2_PIX_FMT_MT21C to V4L2_PIX_FMT_NV12M,
+          V4L2_PIX_FMT_YUV420M and V4L2_PIX_FMT_YVU420.
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
-- 
1.7.9.5


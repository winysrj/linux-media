Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:30768 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932471AbcIGG4y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 02:56:54 -0400
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
Subject: [PATCH 2/4] docs-rst: Add compressed video formats used on MT8173 codec driver
Date: Wed, 7 Sep 2016 14:56:41 +0800
Message-ID: <1473231403-14900-3-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1473231403-14900-2-git-send-email-tiffany.lin@mediatek.com>
References: <1473231403-14900-1-git-send-email-tiffany.lin@mediatek.com>
 <1473231403-14900-2-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_PIX_FMT_MT21C documentation

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 Documentation/media/uapi/v4l/pixfmt-reserved.rst |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
index 0dd2f7f..2e21fbc 100644
--- a/Documentation/media/uapi/v4l/pixfmt-reserved.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-reserved.rst
@@ -339,7 +339,13 @@ please make a proposal on the linux-media mailing list.
 	  array. Anything what's in between the UYVY lines is JPEG data and
 	  should be concatenated to form the JPEG stream.
 
+    -  .. _V4L2-PIX-FMT-MT21C:
 
+       -  ``V4L2_PIX_FMT_MT21C``
+
+       -  'MT21C'
+
+       -  Compressed two-planar YVU420 format used by Mediatek MT8173.
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
-- 
1.7.9.5


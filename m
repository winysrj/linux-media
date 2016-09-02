Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:64374 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752679AbcIBMUO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 08:20:14 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
        <Tiffany.lin@mediatek.com>, Tiffany Lin <tiffany.lin@mediatek.com>,
        Wu-Cheng Li <wuchengli@chromium.org>
Subject: [PATCH v5 8/9] Add documentation for V4L2_PIX_FMT_VP9.
Date: Fri, 2 Sep 2016 20:19:59 +0800
Message-ID: <1472818800-22558-9-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1472818800-22558-8-git-send-email-tiffany.lin@mediatek.com>
References: <1472818800-22558-1-git-send-email-tiffany.lin@mediatek.com>
 <1472818800-22558-2-git-send-email-tiffany.lin@mediatek.com>
 <1472818800-22558-3-git-send-email-tiffany.lin@mediatek.com>
 <1472818800-22558-4-git-send-email-tiffany.lin@mediatek.com>
 <1472818800-22558-5-git-send-email-tiffany.lin@mediatek.com>
 <1472818800-22558-6-git-send-email-tiffany.lin@mediatek.com>
 <1472818800-22558-7-git-send-email-tiffany.lin@mediatek.com>
 <1472818800-22558-8-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for V4L2_PIX_FMT_VP9.

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
---
 Documentation/media/uapi/v4l/pixfmt-013.rst |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst b/Documentation/media/uapi/v4l/pixfmt-013.rst
index bfef4f4..58e3ce6 100644
--- a/Documentation/media/uapi/v4l/pixfmt-013.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-013.rst
@@ -129,3 +129,11 @@ Compressed Formats
        -  'VP80'
 
        -  VP8 video elementary stream.
+
+    -  .. _V4L2-PIX-FMT-VP9:
+
+       -  ``V4L2_PIX_FMT_VP9``
+
+       -  'VP90'
+
+       -  VP9 video elementary stream.
-- 
1.7.9.5


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:56758 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932802AbcIFGfl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 02:35:41 -0400
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
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Subject: [PATCH] vcodec: mediatek: add Maintainers entry for Mediatek MT8173 vcodec drivers
Date: Tue, 6 Sep 2016 14:35:30 +0800
Message-ID: <1473143730-22156-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Tiffany Lin and Andrew-CT Chen as maintainers for
Mediatek MT8173 vcodec drivers

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
---
 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0a16a82..ed830c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7590,6 +7590,15 @@ F:	include/uapi/linux/meye.h
 F:	include/uapi/linux/ivtv*
 F:	include/uapi/linux/uvcvideo.h
 
+MT8173 MEDIA DRIVER
+M:	Tiffany Lin <tiffany.lin@mediatek.com>
+M:	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
+S:	Supported
+F:	drivers/media/platform/mtk-vcodec/
+F:	drivers/media/platform/mtk-vpu/
+F:	Documentation/devicetree/bindings/media/mediatek-vcodec.txt
+F:	Documentation/devicetree/bindings/media/mediatek-vpu.txt
+
 MEDIATEK ETHERNET DRIVER
 M:	Felix Fietkau <nbd@openwrt.org>
 M:	John Crispin <blogic@openwrt.org>
-- 
1.7.9.5


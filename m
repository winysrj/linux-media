Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:64582 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756118AbcK3DLe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Nov 2016 22:11:34 -0500
From: Rick Chang <rick.chang@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Rick Chang <rick.chang@mediatek.com>,
        Bin Liu <bin.liu@mediatek.com>
Subject: [PATCH v8 4/4] vcodec: mediatek: Add Maintainers entry for Mediatek JPEG driver
Date: Wed, 30 Nov 2016 11:09:00 +0800
Message-ID: <1480475340-21893-5-git-send-email-rick.chang@mediatek.com>
In-Reply-To: <1480475340-21893-1-git-send-email-rick.chang@mediatek.com>
References: <1480475340-21893-1-git-send-email-rick.chang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Rick Chang <rick.chang@mediatek.com>
Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Signed-off-by: Bin Liu <bin.liu@mediatek.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93e9f42..6f68fb6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7818,6 +7818,13 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/mediatek/
 
+MEDIATEK JPEG DRIVER
+M:	Rick Chang <rick.chang@mediatek.com>
+M:	Bin Liu <bin.liu@mediatek.com>
+S:	Supported
+F:	drivers/media/platform/mtk-jpeg/
+F:	Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt
+
 MEDIATEK MEDIA DRIVER
 M:	Tiffany Lin <tiffany.lin@mediatek.com>
 M:	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
-- 
1.9.1


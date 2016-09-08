Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:52706 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754673AbcIHNJQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 09:09:16 -0400
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
CC: <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Houlong Wei <houlong.wei@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Subject: [PATCH v6 6/6] media: mtk-mdp: add Maintainers entry for Mediatek MDP driver
Date: Thu, 8 Sep 2016 21:09:06 +0800
Message-ID: <1473340146-6598-7-git-send-email-minghsiu.tsai@mediatek.com>
In-Reply-To: <1473340146-6598-1-git-send-email-minghsiu.tsai@mediatek.com>
References: <1473340146-6598-1-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Minghsiu Tsai, Houlong Wei and Andrew-CT Chen as
maintainers for Mediatek MDP driver

Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Signed-off-by: Houlong Wei <houlong.wei@mediatek.com>
Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
---
 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 20bb1d0..e17e681 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7605,6 +7605,15 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/mediatek/
 
+MEDIATEK MDP DRIVER
+M:	Minghsiu Tsai <minghsiu.tsai@mediatek.com>
+M:	Houlong Wei <houlong.wei@mediatek.com>
+M:	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
+S:	Supported
+F:	drivers/media/platform/mtk-mdp/
+F:	drivers/media/platform/mtk-vpu/
+F:	Documentation/devicetree/bindings/media/mediatek-mdp.txt
+
 MEDIATEK MT7601U WIRELESS LAN DRIVER
 M:	Jakub Kicinski <kubakici@wp.pl>
 L:	linux-wireless@vger.kernel.org
-- 
1.7.9.5


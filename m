Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:12419 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752099AbdELDPX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 23:15:23 -0400
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Houlong Wei <houlong.wei@mediatek.com>
CC: <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Subject: [PATCH v2 0/3] Fix mdp device tree 
Date: Fri, 12 May 2017 11:15:11 +0800
Message-ID: <1494558914-41591-1-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the mdp_* nodes are under an mdp sub-node, their corresponding
platform device does not automatically get its iommu assigned properly.

Fix this by moving the mdp component nodes up a level such that they are
siblings of mdp and all other SoC subsystems.  This also simplifies the
device tree.

Although it fixes iommu assignment issue, it also break compatibility
with old device tree. So, the patch in driver is needed to iterate over
sibling mdp device nodes, not child ones, to keep driver work properly.

Daniel Kurtz (2):
  arm64: dts: mt8173: Fix mdp device tree
  media: mtk-mdp: Fix mdp device tree

Minghsiu Tsai (1):
  dt-bindings: mt8173: Fix mdp device tree

 .../devicetree/bindings/media/mediatek-mdp.txt     |  12 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           | 126 ++++++++++-----------
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c      |   2 +-
 3 files changed, 64 insertions(+), 76 deletions(-)

-- 
1.9.1

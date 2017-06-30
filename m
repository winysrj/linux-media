Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:5166 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752347AbdF3GDc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 02:03:32 -0400
From: <sean.wang@mediatek.com>
To: <mchehab@osg.samsung.com>, <sean@mess.org>, <hdegoede@redhat.com>,
        <hkallweit1@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <matthias.bgg@gmail.com>
CC: <andi.shyti@samsung.com>, <hverkuil@xs4all.nl>,
        <ivo.g.dimitrov.75@gmail.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH v1 0/4] media: rc: add support for IR receiver on MT7622 SoC
Date: Fri, 30 Jun 2017 14:03:03 +0800
Message-ID: <cover.1498794408.git.sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sean Wang <sean.wang@mediatek.com>

This patchset introduces Consumer IR (CIR) support for MT7622 SoC
implements raw mode for more compatibility with different protocols
as previously SoC did. Before adding support to MT7622 SoC, extra
code refactor is done since there're major differences in register and
field definition from the previous SoC.

Sean Wang (4):
  dt-bindings: media: mtk-cir: Add support for MT7622 SoC
  media: rc: mtk-cir: add platform data to adapt into various hardware
  media: rc: mtk-cir: add support for MediaTek MT7622 SoC
  MAINTAINERS: add entry for MediaTek CIR driver

 .../devicetree/bindings/media/mtk-cir.txt          |   8 +-
 MAINTAINERS                                        |   5 +
 drivers/media/rc/mtk-cir.c                         | 242 ++++++++++++++++-----
 3 files changed, 197 insertions(+), 58 deletions(-)

-- 
2.7.4

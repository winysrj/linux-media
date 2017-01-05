Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:20498 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751394AbdAEQHM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2017 11:07:12 -0500
From: <sean.wang@mediatek.com>
To: <mchehab@osg.samsung.com>, <hdegoede@redhat.com>,
        <hkallweit1@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <matthias.bgg@gmail.com>
CC: <andi.shyti@samsung.com>, <hverkuil@xs4all.nl>, <sean@mess.org>,
        <ivo.g.dimitrov.75@gmail.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <keyhaede@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 0/2] media: rc: add support for IR receiver on MT7623 SoC
Date: Fri, 6 Jan 2017 00:06:22 +0800
Message-ID: <1483632384-8107-1-git-send-email-sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sean Wang <sean.wang@mediatek.com>

This patchset introduces Consumer IR (CIR) support for MT7623 SoC 
or other similar SoC and implements raw mode for more compatibility
with different protocols. The driver simply reports the duration of 
pulses and spaces to rc core logic to decode.

Sean Wang (2):
  Documentation: devicetree: Add document bindings for mtk-cir
  media: rc: add driver for IR remote receiver on MT7623 SoC

 .../devicetree/bindings/media/mtk-cir.txt          |  23 ++
 drivers/media/rc/Kconfig                           |  10 +
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/mtk-cir.c                         | 319 +++++++++++++++++++++
 4 files changed, 353 insertions(+)
 create mode 100644 linux-4.8.rc1_p0/Documentation/devicetree/bindings/media/mtk-cir.txt
 create mode 100644 linux-4.8.rc1_p0/drivers/media/rc/mtk-cir.c

-- 
1.9.1


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:6471 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751711AbdAJJOD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 04:14:03 -0500
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
Subject: [PATCH v2 0/2] media: rc: add support for IR receiver on MT7623 SoC
Date: Tue, 10 Jan 2017 17:13:49 +0800
Message-ID: <1484039631-25120-1-git-send-email-sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sean Wang <sean.wang@mediatek.com>

This patchset introduces consumer IR (CIR) support on MT7623 SoC 
that also works on other similar SoCs and implements raw mode for
more compatibility with different protocols. The driver simply
reports the duration of pulses and spaces to rc-core logic to
decode.

Changes since v1:
- change compatible string from "mediatek,mt7623-ir" into 
"mediatek,mt7623-cir"
- use KBUILD_MODNAME to provide consistent device name used in driver.
- remove unused fields in struct mtk_ir.
- use synchronize_irq to give protection between IRQ handler and 
remove handler.
- use devm_rc_allocate_device based on Andi Shyti's work.
- simplify error handling patch with devm_rc_register_device and devm_rc_allocate_device.
- remove unused spinlock.
- add comments about hardware limitation and related workarounds.
- enhance the caculation of sampling period for easiler assigned specific 
value.
- refine git description.
- fix IR message handling between IR hardware and rc-core.

Sean Wang (2):
  Documentation: devicetree: Add document bindings for mtk-cir
  media: rc: add driver for IR remote receiver on MT7623 SoC

 .../devicetree/bindings/media/mtk-cir.txt          |  24 ++
 drivers/media/rc/Kconfig                           |  11 +
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/mtk-cir.c                         | 326 +++++++++++++++++++++
 4 files changed, 362 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mtk-cir.txt
 create mode 100644 drivers/media/rc/mtk-cir.c

-- 
2.7.4


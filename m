Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:52093 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751861AbdF3GDg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 02:03:36 -0400
From: <sean.wang@mediatek.com>
To: <mchehab@osg.samsung.com>, <sean@mess.org>, <hdegoede@redhat.com>,
        <hkallweit1@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <matthias.bgg@gmail.com>
CC: <andi.shyti@samsung.com>, <hverkuil@xs4all.nl>,
        <ivo.g.dimitrov.75@gmail.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH v1 4/4] MAINTAINERS: add entry for MediaTek CIR driver
Date: Fri, 30 Jun 2017 14:03:07 +0800
Message-ID: <66add79b9e331edfbf3a797cb3fcbcf3fd119eb2.1498794408.git.sean.wang@mediatek.com>
In-Reply-To: <cover.1498794408.git.sean.wang@mediatek.com>
References: <cover.1498794408.git.sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sean Wang <sean.wang@mediatek.com>

I work for MediaTek on maintaining the MediaTek CIR driver
for the existing SoCs and adding support for the following
SoCs.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2a1290a..1bc1fb1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8261,6 +8261,11 @@ L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/mediatek/mt7601u/
 
+MEDIATEK CIR DRIVER
+M:      Sean Wang <sean.wang@mediatek.com>
+S:      Maintained
+F:      drivers/media/rc/mtk-cir.c
+
 MEDIATEK RANDOM NUMBER GENERATOR SUPPORT
 M:      Sean Wang <sean.wang@mediatek.com>
 S:      Maintained
-- 
2.7.4

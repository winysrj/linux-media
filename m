Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:41926 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751387AbdH3OlZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 10:41:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Mats Randgaard <matrandg@cisco.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] tc358743_regs.h: add CEC registers
Date: Wed, 30 Aug 2017 16:41:21 +0200
Message-Id: <20170830144122.29054-2-hverkuil@xs4all.nl>
In-Reply-To: <20170830144122.29054-1-hverkuil@xs4all.nl>
References: <20170830144122.29054-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the missing CEC register defines.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/tc358743_regs.h | 94 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tc358743_regs.h b/drivers/media/i2c/tc358743_regs.h
index 657ef50f215f..227b46471793 100644
--- a/drivers/media/i2c/tc358743_regs.h
+++ b/drivers/media/i2c/tc358743_regs.h
@@ -193,8 +193,98 @@
 #define CSI_START                             0x0518
 #define MASK_STRT                             0x00000001
 
-#define CECEN                                 0x0600
-#define MASK_CECEN                            0x0001
+/* *** CEC (32 bit) *** */
+#define CECHCLK				      0x0028	/* 16 bits */
+#define MASK_CECHCLK			      (0x7ff << 0)
+
+#define CECLCLK				      0x002a	/* 16 bits */
+#define MASK_CECLCLK			      (0x7ff << 0)
+
+#define CECEN				      0x0600
+#define MASK_CECEN			      0x0001
+
+#define CECADD				      0x0604
+#define CECRST				      0x0608
+#define MASK_CECRESET			      0x0001
+
+#define CECREN				      0x060c
+#define MASK_CECREN			      0x0001
+
+#define CECRCTL1			      0x0614
+#define MASK_CECACKDIS			      (1 << 24)
+#define MASK_CECHNC			      (3 << 20)
+#define MASK_CECLNC			      (7 << 16)
+#define MASK_CECMIN			      (7 << 12)
+#define MASK_CECMAX			      (7 << 8)
+#define MASK_CECDAT			      (7 << 4)
+#define MASK_CECTOUT			      (3 << 2)
+#define MASK_CECRIHLD			      (1 << 1)
+#define MASK_CECOTH			      (1 << 0)
+
+#define CECRCTL2			      0x0618
+#define MASK_CECSWAV3			      (7 << 12)
+#define MASK_CECSWAV2			      (7 << 8)
+#define MASK_CECSWAV1			      (7 << 4)
+#define MASK_CECSWAV0			      (7 << 0)
+
+#define CECRCTL3			      0x061c
+#define MASK_CECWAV3			      (7 << 20)
+#define MASK_CECWAV2			      (7 << 16)
+#define MASK_CECWAV1			      (7 << 12)
+#define MASK_CECWAV0			      (7 << 8)
+#define MASK_CECACKEI			      (1 << 4)
+#define MASK_CECMINEI			      (1 << 3)
+#define MASK_CECMAXEI			      (1 << 2)
+#define MASK_CECRSTEI			      (1 << 1)
+#define MASK_CECWAVEI			      (1 << 0)
+
+#define CECTEN				      0x0620
+#define MASK_CECTBUSY			      (1 << 1)
+#define MASK_CECTEN			      (1 << 0)
+
+#define CECTCTL				      0x0628
+#define MASK_CECSTRS			      (7 << 20)
+#define MASK_CECSPRD			      (7 << 16)
+#define MASK_CECDTRS			      (7 << 12)
+#define MASK_CECDPRD			      (15 << 8)
+#define MASK_CECBRD			      (1 << 4)
+#define MASK_CECFREE			      (15 << 0)
+
+#define CECRSTAT			      0x062c
+#define MASK_CECRIWA			      (1 << 6)
+#define MASK_CECRIOR			      (1 << 5)
+#define MASK_CECRIACK			      (1 << 4)
+#define MASK_CECRIMIN			      (1 << 3)
+#define MASK_CECRIMAX			      (1 << 2)
+#define MASK_CECRISTA			      (1 << 1)
+#define MASK_CECRIEND			      (1 << 0)
+
+#define CECTSTAT			      0x0630
+#define MASK_CECTIUR			      (1 << 4)
+#define MASK_CECTIACK			      (1 << 3)
+#define MASK_CECTIAL			      (1 << 2)
+#define MASK_CECTIEND			      (1 << 1)
+
+#define CECRBUF1			      0x0634
+#define MASK_CECRACK			      (1 << 9)
+#define MASK_CECEOM			      (1 << 8)
+#define MASK_CECRBYTE			      (0xff << 0)
+
+#define CECTBUF1			      0x0674
+#define MASK_CECTEOM			      (1 << 8)
+#define MASK_CECTBYTE			      (0xff << 0)
+
+#define CECRCTR				      0x06b4
+#define MASK_CECRCTR			      (0x1f << 0)
+
+#define CECIMSK				      0x06c0
+#define MASK_CECTIM			      (1 << 1)
+#define MASK_CECRIM			      (1 << 0)
+
+#define CECICLR				      0x06cc
+#define MASK_CECTICLR			      (1 << 1)
+#define MASK_CECRICLR			      (1 << 0)
+
 
 #define HDMI_INT0                             0x8500
 #define MASK_I_KEY                            0x80
-- 
2.14.1

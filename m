Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44926 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754986AbdGKLUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 07:20:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eric Anholt <eric@anholt.net>, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] drm/vc4: Add register defines for CEC.
Date: Tue, 11 Jul 2017 13:20:20 +0200
Message-Id: <20170711112021.38525-4-hverkuil@xs4all.nl>
In-Reply-To: <20170711112021.38525-1-hverkuil@xs4all.nl>
References: <20170711112021.38525-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Eric Anholt <eric@anholt.net>

Basic usage:

poweron: HSM clock should be running.  Set the bit clock divider,
set all the other _US timeouts based on bit clock rate.  Bring RX/TX
reset up and then down.

powerdown: Set RX/TX reset.

interrupt: read CPU_STATUS, write bits that have been handled to
CPU_CLEAR.

Bits are added to /debug/dri/0/hdmi_regs so you can check out the
power-on values.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c |  16 ++++++
 drivers/gpu/drm/vc4/vc4_regs.h | 108 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index e0104f96011e..b0521e6cc281 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -149,6 +149,22 @@ static const struct {
 	HDMI_REG(VC4_HDMI_VERTB1),
 	HDMI_REG(VC4_HDMI_TX_PHY_RESET_CTL),
 	HDMI_REG(VC4_HDMI_TX_PHY_CTL0),
+
+	HDMI_REG(VC4_HDMI_CEC_CNTRL_1),
+	HDMI_REG(VC4_HDMI_CEC_CNTRL_2),
+	HDMI_REG(VC4_HDMI_CEC_CNTRL_3),
+	HDMI_REG(VC4_HDMI_CEC_CNTRL_4),
+	HDMI_REG(VC4_HDMI_CEC_CNTRL_5),
+	HDMI_REG(VC4_HDMI_CPU_STATUS),
+
+	HDMI_REG(VC4_HDMI_CEC_RX_DATA_1),
+	HDMI_REG(VC4_HDMI_CEC_RX_DATA_2),
+	HDMI_REG(VC4_HDMI_CEC_RX_DATA_3),
+	HDMI_REG(VC4_HDMI_CEC_RX_DATA_4),
+	HDMI_REG(VC4_HDMI_CEC_TX_DATA_1),
+	HDMI_REG(VC4_HDMI_CEC_TX_DATA_2),
+	HDMI_REG(VC4_HDMI_CEC_TX_DATA_3),
+	HDMI_REG(VC4_HDMI_CEC_TX_DATA_4),
 };
 
 static const struct {
diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_regs.h
index d382c34c1b9e..b18cc20ee185 100644
--- a/drivers/gpu/drm/vc4/vc4_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_regs.h
@@ -561,16 +561,124 @@
 # define VC4_HDMI_VERTB_VBP_MASK		VC4_MASK(8, 0)
 # define VC4_HDMI_VERTB_VBP_SHIFT		0
 
+#define VC4_HDMI_CEC_CNTRL_1			0x0e8
+/* Set when the transmission has ended. */
+# define VC4_HDMI_CEC_TX_EOM			BIT(31)
+/* If set, transmission was acked on the 1st or 2nd attempt (only one
+ * retry is attempted).  If in continuous mode, this means TX needs to
+ * be filled if !TX_EOM.
+ */
+# define VC4_HDMI_CEC_TX_STATUS_GOOD		BIT(30)
+# define VC4_HDMI_CEC_RX_EOM			BIT(29)
+# define VC4_HDMI_CEC_RX_STATUS_GOOD		BIT(28)
+/* Number of bytes received for the message. */
+# define VC4_HDMI_CEC_REC_WRD_CNT_MASK		VC4_MASK(27, 24)
+# define VC4_HDMI_CEC_REC_WRD_CNT_SHIFT		24
+/* Sets continuous receive mode.  Generates interrupt after each 8
+ * bytes to signal that RX_DATA should be consumed, and at RX_EOM.
+ *
+ * If disabled, maximum 16 bytes will be received (including header),
+ * and interrupt at RX_EOM.  Later bytes will be acked but not put
+ * into the RX_DATA.
+ */
+# define VC4_HDMI_CEC_RX_CONTINUE		BIT(23)
+# define VC4_HDMI_CEC_TX_CONTINUE		BIT(22)
+/* Set this after a CEC interrupt. */
+# define VC4_HDMI_CEC_CLEAR_RECEIVE_OFF		BIT(21)
+/* Starts a TX.  Will wait for appropriate idel time before CEC
+ * activity. Must be cleared in between transmits.
+ */
+# define VC4_HDMI_CEC_START_XMIT_BEGIN		BIT(20)
+# define VC4_HDMI_CEC_MESSAGE_LENGTH_MASK	VC4_MASK(19, 16)
+# define VC4_HDMI_CEC_MESSAGE_LENGTH_SHIFT	16
+/* Device's CEC address */
+# define VC4_HDMI_CEC_ADDR_MASK			VC4_MASK(15, 12)
+# define VC4_HDMI_CEC_ADDR_SHIFT		12
+/* Divides off of HSM clock to generate CEC bit clock. */
+# define VC4_HDMI_CEC_DIV_CLK_CNT_MASK		VC4_MASK(11, 0)
+# define VC4_HDMI_CEC_DIV_CLK_CNT_SHIFT		0
+
+/* Set these fields to how many bit clock cycles get to that many
+ * microseconds.
+ */
+#define VC4_HDMI_CEC_CNTRL_2			0x0ec
+# define VC4_HDMI_CEC_CNT_TO_1500_US_MASK	VC4_MASK(30, 24)
+# define VC4_HDMI_CEC_CNT_TO_1500_US_SHIFT	24
+# define VC4_HDMI_CEC_CNT_TO_1300_US_MASK	VC4_MASK(23, 17)
+# define VC4_HDMI_CEC_CNT_TO_1300_US_SHIFT	17
+# define VC4_HDMI_CEC_CNT_TO_800_US_MASK	VC4_MASK(16, 11)
+# define VC4_HDMI_CEC_CNT_TO_800_US_SHIFT	11
+# define VC4_HDMI_CEC_CNT_TO_600_US_MASK	VC4_MASK(10, 5)
+# define VC4_HDMI_CEC_CNT_TO_600_US_SHIFT	5
+# define VC4_HDMI_CEC_CNT_TO_400_US_MASK	VC4_MASK(4, 0)
+# define VC4_HDMI_CEC_CNT_TO_400_US_SHIFT	0
+
+#define VC4_HDMI_CEC_CNTRL_3			0x0f0
+# define VC4_HDMI_CEC_CNT_TO_2750_US_MASK	VC4_MASK(31, 24)
+# define VC4_HDMI_CEC_CNT_TO_2750_US_SHIFT	24
+# define VC4_HDMI_CEC_CNT_TO_2400_US_MASK	VC4_MASK(23, 16)
+# define VC4_HDMI_CEC_CNT_TO_2400_US_SHIFT	16
+# define VC4_HDMI_CEC_CNT_TO_2050_US_MASK	VC4_MASK(15, 8)
+# define VC4_HDMI_CEC_CNT_TO_2050_US_SHIFT	8
+# define VC4_HDMI_CEC_CNT_TO_1700_US_MASK	VC4_MASK(7, 0)
+# define VC4_HDMI_CEC_CNT_TO_1700_US_SHIFT	0
+
+#define VC4_HDMI_CEC_CNTRL_4			0x0f4
+# define VC4_HDMI_CEC_CNT_TO_4300_US_MASK	VC4_MASK(31, 24)
+# define VC4_HDMI_CEC_CNT_TO_4300_US_SHIFT	24
+# define VC4_HDMI_CEC_CNT_TO_3900_US_MASK	VC4_MASK(23, 16)
+# define VC4_HDMI_CEC_CNT_TO_3900_US_SHIFT	16
+# define VC4_HDMI_CEC_CNT_TO_3600_US_MASK	VC4_MASK(15, 8)
+# define VC4_HDMI_CEC_CNT_TO_3600_US_SHIFT	8
+# define VC4_HDMI_CEC_CNT_TO_3500_US_MASK	VC4_MASK(7, 0)
+# define VC4_HDMI_CEC_CNT_TO_3500_US_SHIFT	0
+
+#define VC4_HDMI_CEC_CNTRL_5			0x0f8
+# define VC4_HDMI_CEC_TX_SW_RESET		BIT(27)
+# define VC4_HDMI_CEC_RX_SW_RESET		BIT(26)
+# define VC4_HDMI_CEC_PAD_SW_RESET		BIT(25)
+# define VC4_HDMI_CEC_MUX_TP_OUT_CEC		BIT(24)
+# define VC4_HDMI_CEC_RX_CEC_INT		BIT(23)
+# define VC4_HDMI_CEC_CLK_PRELOAD_MASK		VC4_MASK(22, 16)
+# define VC4_HDMI_CEC_CLK_PRELOAD_SHIFT		16
+# define VC4_HDMI_CEC_CNT_TO_4700_US_MASK	VC4_MASK(15, 8)
+# define VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT	8
+# define VC4_HDMI_CEC_CNT_TO_4500_US_MASK	VC4_MASK(7, 0)
+# define VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT	0
+
+/* Transmit data, first byte is low byte of the 32-bit reg.  MSB of
+ * each byte transmitted first.
+ */
+#define VC4_HDMI_CEC_TX_DATA_1			0x0fc
+#define VC4_HDMI_CEC_TX_DATA_2			0x100
+#define VC4_HDMI_CEC_TX_DATA_3			0x104
+#define VC4_HDMI_CEC_TX_DATA_4			0x108
+#define VC4_HDMI_CEC_RX_DATA_1			0x10c
+#define VC4_HDMI_CEC_RX_DATA_2			0x110
+#define VC4_HDMI_CEC_RX_DATA_3			0x114
+#define VC4_HDMI_CEC_RX_DATA_4			0x118
+
 #define VC4_HDMI_TX_PHY_RESET_CTL		0x2c0
 
 #define VC4_HDMI_TX_PHY_CTL0			0x2c4
 # define VC4_HDMI_TX_PHY_RNG_PWRDN		BIT(25)
 
+/* Interrupt status bits */
+#define VC4_HDMI_CPU_STATUS			0x340
+#define VC4_HDMI_CPU_SET			0x344
+#define VC4_HDMI_CPU_CLEAR			0x348
+# define VC4_HDMI_CPU_CEC			BIT(6)
+# define VC4_HDMI_CPU_HOTPLUG			BIT(0)
+
 #define VC4_HDMI_GCP(x)				(0x400 + ((x) * 0x4))
 #define VC4_HDMI_RAM_PACKET(x)			(0x400 + ((x) * 0x24))
 #define VC4_HDMI_PACKET_STRIDE			0x24
 
 #define VC4_HD_M_CTL				0x00c
+/* Debug: Current receive value on the CEC pad. */
+# define VC4_HD_CECRXD				BIT(9)
+/* Debug: Override CEC output to 0. */
+# define VC4_HD_CECOVR				BIT(8)
 # define VC4_HD_M_REGISTER_FILE_STANDBY		(3 << 6)
 # define VC4_HD_M_RAM_STANDBY			(3 << 4)
 # define VC4_HD_M_SW_RST			BIT(2)
-- 
2.11.0

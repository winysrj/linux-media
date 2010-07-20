Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:55967 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753419Ab0GTBSL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:18:11 -0400
Subject: [PATCH 08/17] cx25840: Add s_io_pin_config core subdev ops for the
 CX2388[578]
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>,
	Kenney Phillisjr <kphillisjr@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>,
	"Igor M.Liplianin" <liplianin@me.by>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:18:04 -0400
Message-ID: <1279588684.31145.3.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add s_io_pin_config core subdev op for the CX2388[578] AV cores.
This is complete for IR_RX, IR_TX, GPIOs 16,19-23, and IRQ_N.
It likely needs work for the I2S signal direction.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx25840/cx25840-core.c |  153 ++++++++++++++++++++++++++++
 include/media/cx25840.h                    |   75 ++++++++++++++
 2 files changed, 228 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index 4f908fa..46a046d 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -144,6 +144,158 @@ static int set_input(struct i2c_client *client, enum cx25840_video_input vid_inp
 
 /* ----------------------------------------------------------------------- */
 
+static int cx23885_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
+				      struct v4l2_subdev_io_pin_config *p)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int i;
+	u32 pin_ctrl;
+	u8 gpio_oe, gpio_data, strength;
+
+	pin_ctrl = cx25840_read4(client, 0x120);
+	gpio_oe = cx25840_read(client, 0x160);
+	gpio_data = cx25840_read(client, 0x164);
+
+	for (i = 0; i < n; i++) {
+		strength = p[i].strength;
+		if (strength > CX25840_PIN_DRIVE_FAST)
+			strength = CX25840_PIN_DRIVE_FAST;
+
+		switch (p[i].pin) {
+		case CX23885_PIN_IRQ_N_GPIO16:
+			if (p[i].function != CX23885_PAD_IRQ_N) {
+				/* GPIO16 */
+				pin_ctrl &= ~(0x1 << 25);
+			} else {
+				/* IRQ_N */
+				if (p[i].flags &
+					(V4L2_SUBDEV_IO_PIN_DISABLE |
+					 V4L2_SUBDEV_IO_PIN_INPUT)) {
+					pin_ctrl &= ~(0x1 << 25);
+				} else {
+					pin_ctrl |= (0x1 << 25);
+				}
+				if (p[i].flags &
+					V4L2_SUBDEV_IO_PIN_ACTIVE_LOW) {
+					pin_ctrl &= ~(0x1 << 24);
+				} else {
+					pin_ctrl |= (0x1 << 24);
+				}
+			}
+			break;
+		case CX23885_PIN_IR_RX_GPIO19:
+			if (p[i].function != CX23885_PAD_GPIO19) {
+				/* IR_RX */
+				gpio_oe |= (0x1 << 0);
+				pin_ctrl &= ~(0x3 << 18);
+				pin_ctrl |= (strength << 18);
+			} else {
+				/* GPIO19 */
+				gpio_oe &= ~(0x1 << 0);
+				if (p[i].flags & V4L2_SUBDEV_IO_PIN_SET_VALUE) {
+					gpio_data &= ~(0x1 << 0);
+					gpio_data |= ((p[i].value & 0x1) << 0);
+				}
+				pin_ctrl &= ~(0x3 << 12);
+				pin_ctrl |= (strength << 12);
+			}
+			break;
+		case CX23885_PIN_IR_TX_GPIO20:
+			if (p[i].function != CX23885_PAD_GPIO20) {
+				/* IR_TX */
+				gpio_oe |= (0x1 << 1);
+				if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE)
+					pin_ctrl &= ~(0x1 << 10);
+				else
+					pin_ctrl |= (0x1 << 10);
+				pin_ctrl &= ~(0x3 << 18);
+				pin_ctrl |= (strength << 18);
+			} else {
+				/* GPIO20 */
+				gpio_oe &= ~(0x1 << 1);
+				if (p[i].flags & V4L2_SUBDEV_IO_PIN_SET_VALUE) {
+					gpio_data &= ~(0x1 << 1);
+					gpio_data |= ((p[i].value & 0x1) << 1);
+				}
+				pin_ctrl &= ~(0x3 << 12);
+				pin_ctrl |= (strength << 12);
+			}
+			break;
+		case CX23885_PIN_I2S_SDAT_GPIO21:
+			if (p[i].function != CX23885_PAD_GPIO21) {
+				/* I2S_SDAT */
+				/* TODO: Input or Output config */
+				gpio_oe |= (0x1 << 2);
+				pin_ctrl &= ~(0x3 << 22);
+				pin_ctrl |= (strength << 22);
+			} else {
+				/* GPIO21 */
+				gpio_oe &= ~(0x1 << 2);
+				if (p[i].flags & V4L2_SUBDEV_IO_PIN_SET_VALUE) {
+					gpio_data &= ~(0x1 << 2);
+					gpio_data |= ((p[i].value & 0x1) << 2);
+				}
+				pin_ctrl &= ~(0x3 << 12);
+				pin_ctrl |= (strength << 12);
+			}
+			break;
+		case CX23885_PIN_I2S_WCLK_GPIO22:
+			if (p[i].function != CX23885_PAD_GPIO22) {
+				/* I2S_WCLK */
+				/* TODO: Input or Output config */
+				gpio_oe |= (0x1 << 3);
+				pin_ctrl &= ~(0x3 << 22);
+				pin_ctrl |= (strength << 22);
+			} else {
+				/* GPIO22 */
+				gpio_oe &= ~(0x1 << 3);
+				if (p[i].flags & V4L2_SUBDEV_IO_PIN_SET_VALUE) {
+					gpio_data &= ~(0x1 << 3);
+					gpio_data |= ((p[i].value & 0x1) << 3);
+				}
+				pin_ctrl &= ~(0x3 << 12);
+				pin_ctrl |= (strength << 12);
+			}
+			break;
+		case CX23885_PIN_I2S_BCLK_GPIO23:
+			if (p[i].function != CX23885_PAD_GPIO23) {
+				/* I2S_BCLK */
+				/* TODO: Input or Output config */
+				gpio_oe |= (0x1 << 4);
+				pin_ctrl &= ~(0x3 << 22);
+				pin_ctrl |= (strength << 22);
+			} else {
+				/* GPIO23 */
+				gpio_oe &= ~(0x1 << 4);
+				if (p[i].flags & V4L2_SUBDEV_IO_PIN_SET_VALUE) {
+					gpio_data &= ~(0x1 << 4);
+					gpio_data |= ((p[i].value & 0x1) << 4);
+				}
+				pin_ctrl &= ~(0x3 << 12);
+				pin_ctrl |= (strength << 12);
+			}
+			break;
+		}
+	}
+
+	cx25840_write(client, 0x164, gpio_data);
+	cx25840_write(client, 0x160, gpio_oe);
+	cx25840_write4(client, 0x120, pin_ctrl);
+	return 0;
+}
+
+static int common_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
+				      struct v4l2_subdev_io_pin_config *pincfg)
+{
+	struct cx25840_state *state = to_state(sd);
+
+	if (is_cx2388x(state))
+		return cx23885_s_io_pin_config(sd, n, pincfg);
+	return 0;
+}
+
+/* ----------------------------------------------------------------------- */
+
 static void init_dll1(struct i2c_client *client)
 {
 	/* This is the Hauppauge sequence used to
@@ -1610,6 +1762,7 @@ static const struct v4l2_subdev_core_ops cx25840_core_ops = {
 	.s_std = cx25840_s_std,
 	.reset = cx25840_reset,
 	.load_fw = cx25840_load_fw,
+	.s_io_pin_config = common_s_io_pin_config,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = cx25840_g_register,
 	.s_register = cx25840_s_register,
diff --git a/include/media/cx25840.h b/include/media/cx25840.h
index 0b0cb17..1bba39e 100644
--- a/include/media/cx25840.h
+++ b/include/media/cx25840.h
@@ -97,4 +97,79 @@ enum cx25840_audio_input {
 	CX25840_AUDIO8,
 };
 
+enum cx25840_io_pin {
+	CX25840_PIN_DVALID_PRGM0 = 0,
+	CX25840_PIN_FIELD_PRGM1,
+	CX25840_PIN_HRESET_PRGM2,
+	CX25840_PIN_VRESET_HCTL_PRGM3,
+	CX25840_PIN_IRQ_N_PRGM4,
+	CX25840_PIN_IR_TX_PRGM6,
+	CX25840_PIN_IR_RX_PRGM5,
+	CX25840_PIN_GPIO0_PRGM8,
+	CX25840_PIN_GPIO1_PRGM9,
+	CX25840_PIN_SA_SDIN,		/* Alternate GP Input only */
+	CX25840_PIN_SA_SDOUT,		/* Alternate GP Input only */
+	CX25840_PIN_PLL_CLK_PRGM7,
+	CX25840_PIN_CHIP_SEL_VIPCLK,	/* Output only */
+};
+
+enum cx25840_io_pad {
+	/* Output pads */
+	CX25840_PAD_DEFAULT = 0,
+	CX25840_PAD_ACTIVE,
+	CX25840_PAD_VACTIVE,
+	CX25840_PAD_CBFLAG,
+	CX25840_PAD_VID_DATA_EXT0,
+	CX25840_PAD_VID_DATA_EXT1,
+	CX25840_PAD_GPO0,
+	CX25840_PAD_GPO1,
+	CX25840_PAD_GPO2,
+	CX25840_PAD_GPO3,
+	CX25840_PAD_IRQ_N,
+	CX25840_PAD_AC_SYNC,
+	CX25840_PAD_AC_SDOUT,
+	CX25840_PAD_PLL_CLK,
+	CX25840_PAD_VRESET,
+	CX25840_PAD_RESERVED,
+	/* Pads for PLL_CLK output only */
+	CX25840_PAD_XTI_X5_DLL,
+	CX25840_PAD_AUX_PLL,
+	CX25840_PAD_VID_PLL,
+	CX25840_PAD_XTI,
+	/* Input Pads */
+	CX25840_PAD_GPI0,
+	CX25840_PAD_GPI1,
+	CX25840_PAD_GPI2,
+	CX25840_PAD_GPI3,
+};
+
+enum cx25840_io_pin_strength {
+	CX25840_PIN_DRIVE_MEDIUM = 0,
+	CX25840_PIN_DRIVE_SLOW,
+	CX25840_PIN_DRIVE_FAST,
+};
+
+enum cx23885_io_pin {
+	CX23885_PIN_IR_RX_GPIO19,
+	CX23885_PIN_IR_TX_GPIO20,
+	CX23885_PIN_I2S_SDAT_GPIO21,
+	CX23885_PIN_I2S_WCLK_GPIO22,
+	CX23885_PIN_I2S_BCLK_GPIO23,
+	CX23885_PIN_IRQ_N_GPIO16,
+};
+
+enum cx23885_io_pad {
+	CX23885_PAD_IR_RX,
+	CX23885_PAD_GPIO19,
+	CX23885_PAD_IR_TX,
+	CX23885_PAD_GPIO20,
+	CX23885_PAD_I2S_SDAT,
+	CX23885_PAD_GPIO21,
+	CX23885_PAD_I2S_WCLK,
+	CX23885_PAD_GPIO22,
+	CX23885_PAD_I2S_BCLK,
+	CX23885_PAD_GPIO23,
+	CX23885_PAD_IRQ_N,
+	CX23885_PAD_GPIO16,
+};
 #endif
-- 
1.7.1.1



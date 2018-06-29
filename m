Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:59078 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936030AbeF2VAK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 17:00:10 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RESEND][PATCH v6 3/6] cx25840: add pin to pad mapping and output format configuration
Date: Fri, 29 Jun 2018 23:00:00 +0200
Message-Id: <69af3169d998d78c4ce1fe8702ff795dbe89b4b7.1530305665.git.mail@maciej.szmigiero.name>
In-Reply-To: <cover.1530305665.git.mail@maciej.szmigiero.name>
References: <cover.1530305665.git.mail@maciej.szmigiero.name>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit adds pin to pad mapping and output format configuration support
in CX2584x-series chips to cx25840 driver.

This functionality is then used to allow disabling ivtv-specific hacks
(called a "generic mode"), so cx25840 driver can be used for other devices
not needing them without risking compatibility problems.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 396 ++++++++++++++++++++++-
 drivers/media/i2c/cx25840/cx25840-core.h |  13 +
 drivers/media/i2c/cx25840/cx25840-vbi.c  |   3 +
 include/media/drv-intf/cx25840.h         |  74 ++++-
 4 files changed, 484 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index b168bf3635b6..7dc3d0870808 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -21,6 +21,9 @@
  * CX23888 DIF support for the HVR1850
  * Copyright (C) 2011 Steven Toth <stoth@kernellabs.com>
  *
+ * CX2584x pin to pad mapping and output format configuration support are
+ * Copyright (C) 2011 Maciej S. Szmigiero <mail@maciej.szmigiero.name>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version 2
@@ -316,6 +319,260 @@ static int cx23885_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
 	return 0;
 }
 
+static u8 cx25840_function_to_pad(struct i2c_client *client, u8 function)
+{
+	switch (function) {
+	case CX25840_PAD_ACTIVE:
+		return 1;
+
+	case CX25840_PAD_VACTIVE:
+		return 2;
+
+	case CX25840_PAD_CBFLAG:
+		return 3;
+
+	case CX25840_PAD_VID_DATA_EXT0:
+		return 4;
+
+	case CX25840_PAD_VID_DATA_EXT1:
+		return 5;
+
+	case CX25840_PAD_GPO0:
+		return 6;
+
+	case CX25840_PAD_GPO1:
+		return 7;
+
+	case CX25840_PAD_GPO2:
+		return 8;
+
+	case CX25840_PAD_GPO3:
+		return 9;
+
+	case CX25840_PAD_IRQ_N:
+		return 10;
+
+	case CX25840_PAD_AC_SYNC:
+		return 11;
+
+	case CX25840_PAD_AC_SDOUT:
+		return 12;
+
+	case CX25840_PAD_PLL_CLK:
+		return 13;
+
+	case CX25840_PAD_VRESET:
+		return 14;
+
+	default:
+		if (function != CX25840_PAD_DEFAULT)
+			v4l_err(client,
+				"invalid function %u, assuming default\n",
+				(unsigned int)function);
+		return 0;
+	}
+}
+
+static void cx25840_set_invert(u8 *pinctrl3, u8 *voutctrl4, u8 function,
+			       u8 pin, bool invert)
+{
+	switch (function) {
+	case CX25840_PAD_IRQ_N:
+		if (invert)
+			*pinctrl3 &= ~2;
+		else
+			*pinctrl3 |= 2;
+		break;
+
+	case CX25840_PAD_ACTIVE:
+		if (invert)
+			*voutctrl4 |= BIT(2);
+		else
+			*voutctrl4 &= ~BIT(2);
+		break;
+
+	case CX25840_PAD_VACTIVE:
+		if (invert)
+			*voutctrl4 |= BIT(5);
+		else
+			*voutctrl4 &= ~BIT(5);
+		break;
+
+	case CX25840_PAD_CBFLAG:
+		if (invert)
+			*voutctrl4 |= BIT(4);
+		else
+			*voutctrl4 &= ~BIT(4);
+		break;
+
+	case CX25840_PAD_VRESET:
+		if (invert)
+			*voutctrl4 |= BIT(0);
+		else
+			*voutctrl4 &= ~BIT(0);
+		break;
+	}
+
+	if (function != CX25840_PAD_DEFAULT)
+		return;
+
+	switch (pin) {
+	case CX25840_PIN_DVALID_PRGM0:
+		if (invert)
+			*voutctrl4 |= BIT(6);
+		else
+			*voutctrl4 &= ~BIT(6);
+		break;
+
+	case CX25840_PIN_HRESET_PRGM2:
+		if (invert)
+			*voutctrl4 |= BIT(1);
+		else
+			*voutctrl4 &= ~BIT(1);
+		break;
+	}
+}
+
+static int cx25840_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
+				   struct v4l2_subdev_io_pin_config *p)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	unsigned int i;
+	u8 pinctrl[6], pinconf[10], voutctrl4;
+
+	for (i = 0; i < 6; i++)
+		pinctrl[i] = cx25840_read(client, 0x114 + i);
+
+	for (i = 0; i < 10; i++)
+		pinconf[i] = cx25840_read(client, 0x11c + i);
+
+	voutctrl4 = cx25840_read(client, 0x407);
+
+	for (i = 0; i < n; i++) {
+		u8 strength = p[i].strength;
+
+		if (strength != CX25840_PIN_DRIVE_SLOW &&
+		    strength != CX25840_PIN_DRIVE_MEDIUM &&
+		    strength != CX25840_PIN_DRIVE_FAST) {
+
+			v4l_err(client,
+				"invalid drive speed for pin %u (%u), assuming fast\n",
+				(unsigned int)p[i].pin,
+				(unsigned int)strength);
+
+			strength = CX25840_PIN_DRIVE_FAST;
+		}
+
+		switch (p[i].pin) {
+		case CX25840_PIN_DVALID_PRGM0:
+			if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE)
+				pinctrl[0] &= ~BIT(6);
+			else
+				pinctrl[0] |= BIT(6);
+
+			pinconf[3] &= 0xf0;
+			pinconf[3] |= cx25840_function_to_pad(client,
+							      p[i].function);
+
+			cx25840_set_invert(&pinctrl[3], &voutctrl4,
+					   p[i].function,
+					   CX25840_PIN_DVALID_PRGM0,
+					   p[i].flags &
+					   V4L2_SUBDEV_IO_PIN_ACTIVE_LOW);
+
+			pinctrl[4] &= ~(3 << 2); /* CX25840_PIN_DRIVE_MEDIUM */
+			switch (strength) {
+			case CX25840_PIN_DRIVE_SLOW:
+				pinctrl[4] |= 1 << 2;
+				break;
+
+			case CX25840_PIN_DRIVE_FAST:
+				pinctrl[4] |= 2 << 2;
+				break;
+			}
+
+			break;
+
+		case CX25840_PIN_HRESET_PRGM2:
+			if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE)
+				pinctrl[1] &= ~BIT(0);
+			else
+				pinctrl[1] |= BIT(0);
+
+			pinconf[4] &= 0xf0;
+			pinconf[4] |= cx25840_function_to_pad(client,
+							      p[i].function);
+
+			cx25840_set_invert(&pinctrl[3], &voutctrl4,
+					   p[i].function,
+					   CX25840_PIN_HRESET_PRGM2,
+					   p[i].flags &
+					   V4L2_SUBDEV_IO_PIN_ACTIVE_LOW);
+
+			pinctrl[4] &= ~(3 << 2); /* CX25840_PIN_DRIVE_MEDIUM */
+			switch (strength) {
+			case CX25840_PIN_DRIVE_SLOW:
+				pinctrl[4] |= 1 << 2;
+				break;
+
+			case CX25840_PIN_DRIVE_FAST:
+				pinctrl[4] |= 2 << 2;
+				break;
+			}
+
+			break;
+
+		case CX25840_PIN_PLL_CLK_PRGM7:
+			if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE)
+				pinctrl[2] &= ~BIT(2);
+			else
+				pinctrl[2] |= BIT(2);
+
+			switch (p[i].function) {
+			case CX25840_PAD_XTI_X5_DLL:
+				pinconf[6] = 0;
+				break;
+
+			case CX25840_PAD_AUX_PLL:
+				pinconf[6] = 1;
+				break;
+
+			case CX25840_PAD_VID_PLL:
+				pinconf[6] = 5;
+				break;
+
+			case CX25840_PAD_XTI:
+				pinconf[6] = 2;
+				break;
+
+			default:
+				pinconf[6] = 3;
+				pinconf[6] |=
+					cx25840_function_to_pad(client,
+								p[i].function)
+					<< 4;
+			}
+
+			break;
+
+		default:
+			v4l_err(client, "invalid or unsupported pin %u\n",
+				(unsigned int)p[i].pin);
+			break;
+		}
+	}
+
+	cx25840_write(client, 0x407, voutctrl4);
+
+	for (i = 0; i < 6; i++)
+		cx25840_write(client, 0x114 + i, pinctrl[i]);
+
+	for (i = 0; i < 10; i++)
+		cx25840_write(client, 0x11c + i, pinconf[i]);
+
+	return 0;
+}
+
 static int common_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
 				      struct v4l2_subdev_io_pin_config *pincfg)
 {
@@ -323,6 +580,8 @@ static int common_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
 
 	if (is_cx2388x(state))
 		return cx23885_s_io_pin_config(sd, n, pincfg);
+	else if (is_cx2584x(state))
+		return cx25840_s_io_pin_config(sd, n, pincfg);
 	return 0;
 }
 
@@ -455,6 +714,22 @@ static void cx25840_initialize(struct i2c_client *client)
 	/* (re)set input */
 	set_input(client, state->vid_input, state->aud_input);
 
+	if (state->generic_mode) {
+		/* set datasheet video output defaults */
+		cx25840_vconfig(client, CX25840_VCONFIG_FMT_BT656 |
+				CX25840_VCONFIG_RES_8BIT |
+				CX25840_VCONFIG_VBIRAW_DISABLED |
+				CX25840_VCONFIG_ANCDATA_ENABLED |
+				CX25840_VCONFIG_TASKBIT_ONE |
+				CX25840_VCONFIG_ACTIVE_HORIZONTAL |
+				CX25840_VCONFIG_VALID_NORMAL |
+				CX25840_VCONFIG_HRESETW_NORMAL |
+				CX25840_VCONFIG_CLKGATE_NONE |
+				CX25840_VCONFIG_DCMODE_DWORDS |
+				CX25840_VCONFIG_IDID0S_NORMAL |
+				CX25840_VCONFIG_VIPCLAMP_DISABLED);
+	}
+
 	/* start microcontroller */
 	cx25840_and_or(client, 0x803, ~0x10, 0x10);
 }
@@ -1403,7 +1678,9 @@ static int cx25840_set_fmt(struct v4l2_subdev *sd,
 		Hsrc |= (cx25840_read(client, 0x471) & 0xf0) >> 4;
 	}
 
-	Vlines = fmt->height + (is_50Hz ? 4 : 7);
+	Vlines = fmt->height;
+	if (!state->generic_mode)
+		Vlines += is_50Hz ? 4 : 7;
 
 	/*
 	 * We keep 1 margin for the Vsrc < Vlines check since the
@@ -1647,6 +1924,119 @@ static void log_audio_status(struct i2c_client *client)
 	}
 }
 
+#define CX25840_VCONFIG_OPTION(state, cfg_in, opt_msk)			\
+	do {								\
+		if ((cfg_in) & (opt_msk)) {				\
+			(state)->vid_config &= ~(opt_msk);		\
+			(state)->vid_config |= (cfg_in) & (opt_msk);	\
+		}							\
+	} while (0)
+
+#define CX25840_VCONFIG_SET_BIT(state, opt_msk, voc, idx, bit, oneval)	\
+	do {								\
+		if ((state)->vid_config & (opt_msk)) {			\
+			if (((state)->vid_config & (opt_msk)) ==	\
+			    (oneval))					\
+				(voc)[idx] |= BIT(bit);		\
+			else						\
+				(voc)[idx] &= ~BIT(bit);		\
+		}							\
+	} while (0)
+
+int cx25840_vconfig(struct i2c_client *client, u32 cfg_in)
+{
+	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
+	u8 voutctrl[3];
+	unsigned int i;
+
+	/* apply incoming options to the current state */
+	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_FMT_MASK);
+	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_RES_MASK);
+	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_VBIRAW_MASK);
+	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_ANCDATA_MASK);
+	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_TASKBIT_MASK);
+	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_ACTIVE_MASK);
+	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_VALID_MASK);
+	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_HRESETW_MASK);
+	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_CLKGATE_MASK);
+	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_DCMODE_MASK);
+	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_IDID0S_MASK);
+	CX25840_VCONFIG_OPTION(state, cfg_in, CX25840_VCONFIG_VIPCLAMP_MASK);
+
+	for (i = 0; i < 3; i++)
+		voutctrl[i] = cx25840_read(client, 0x404 + i);
+
+	/* apply state to hardware regs */
+	if (state->vid_config & CX25840_VCONFIG_FMT_MASK)
+		voutctrl[0] &= ~3;
+	switch (state->vid_config & CX25840_VCONFIG_FMT_MASK) {
+	case CX25840_VCONFIG_FMT_BT656:
+		voutctrl[0] |= 1;
+		break;
+
+	case CX25840_VCONFIG_FMT_VIP11:
+		voutctrl[0] |= 2;
+		break;
+
+	case CX25840_VCONFIG_FMT_VIP2:
+		voutctrl[0] |= 3;
+		break;
+
+	case CX25840_VCONFIG_FMT_BT601:
+		/* zero */
+	default:
+		break;
+	}
+
+	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_RES_MASK, voutctrl,
+				0, 2, CX25840_VCONFIG_RES_10BIT);
+	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_VBIRAW_MASK, voutctrl,
+				0, 3, CX25840_VCONFIG_VBIRAW_ENABLED);
+	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_ANCDATA_MASK, voutctrl,
+				0, 4, CX25840_VCONFIG_ANCDATA_ENABLED);
+	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_TASKBIT_MASK, voutctrl,
+				0, 5, CX25840_VCONFIG_TASKBIT_ONE);
+	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_ACTIVE_MASK, voutctrl,
+				1, 2, CX25840_VCONFIG_ACTIVE_HORIZONTAL);
+	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_VALID_MASK, voutctrl,
+				1, 3, CX25840_VCONFIG_VALID_ANDACTIVE);
+	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_HRESETW_MASK, voutctrl,
+				1, 4, CX25840_VCONFIG_HRESETW_PIXCLK);
+
+	if (state->vid_config & CX25840_VCONFIG_CLKGATE_MASK)
+		voutctrl[1] &= ~(3 << 6);
+	switch (state->vid_config & CX25840_VCONFIG_CLKGATE_MASK) {
+	case CX25840_VCONFIG_CLKGATE_VALID:
+		voutctrl[1] |= 2;
+		break;
+
+	case CX25840_VCONFIG_CLKGATE_VALIDACTIVE:
+		voutctrl[1] |= 3;
+		break;
+
+	case CX25840_VCONFIG_CLKGATE_NONE:
+		/* zero */
+	default:
+		break;
+	}
+
+
+	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_DCMODE_MASK, voutctrl,
+				2, 0, CX25840_VCONFIG_DCMODE_BYTES);
+	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_IDID0S_MASK, voutctrl,
+				2, 1, CX25840_VCONFIG_IDID0S_LINECNT);
+	CX25840_VCONFIG_SET_BIT(state, CX25840_VCONFIG_VIPCLAMP_MASK, voutctrl,
+				2, 4, CX25840_VCONFIG_VIPCLAMP_ENABLED);
+
+	for (i = 0; i < 3; i++)
+		cx25840_write(client, 0x404 + i, voutctrl[i]);
+
+	return 0;
+}
+
+#undef CX25840_VCONFIG_SET_BIT
+#undef CX25840_VCONFIG_OPTION
+
 /* ----------------------------------------------------------------------- */
 
 /* This load_fw operation must be called to load the driver's firmware.
@@ -1836,6 +2226,9 @@ static int cx25840_s_video_routing(struct v4l2_subdev *sd,
 	if (is_cx23888(state))
 		cx23888_std_setup(client);
 
+	if (is_cx2584x(state) && state->generic_mode)
+		cx25840_vconfig(client, config);
+
 	return set_input(client, input, state->aud_input);
 }
 
@@ -5335,6 +5728,7 @@ static int cx25840_probe(struct i2c_client *client,
 		struct cx25840_platform_data *pdata = client->dev.platform_data;
 
 		state->pvr150_workaround = pdata->pvr150_workaround;
+		state->generic_mode = pdata->generic_mode;
 	}
 
 	cx25840_ir_probe(sd);
diff --git a/drivers/media/i2c/cx25840/cx25840-core.h b/drivers/media/i2c/cx25840/cx25840-core.h
index c323b1af1f83..e5f52b8d6d9c 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.h
+++ b/drivers/media/i2c/cx25840/cx25840-core.h
@@ -54,10 +54,12 @@ enum cx25840_media_pads {
  * @mute:		audio mute V4L2 control (non-cx2583x devices only)
  * @pvr150_workaround:	whether we enable workaround for Hauppauge PVR150
  *			hardware bug (audio dropping out)
+ * @generic_mode:	whether we disable ivtv-specific hacks
  * @radio:		set if we are currently in the radio mode, otherwise
  *			the current mode is non-radio (that is, video)
  * @std:		currently set video standard
  * @vid_input:		currently set video input
+ * @vid_config:	currently set video output configuration
  * @aud_input:		currently set audio input
  * @audclk_freq:	currently set audio sample rate
  * @audmode:		currently set audio mode (when in non-radio mode)
@@ -84,9 +86,11 @@ struct cx25840_state {
 		struct v4l2_ctrl *mute;
 	};
 	int pvr150_workaround;
+	int generic_mode;
 	int radio;
 	v4l2_std_id std;
 	enum cx25840_video_input vid_input;
+	u32 vid_config;
 	enum cx25840_audio_input aud_input;
 	u32 audclk_freq;
 	int audmode;
@@ -119,6 +123,14 @@ static inline bool is_cx2583x(struct cx25840_state *state)
 	       state->id == CX25837;
 }
 
+static inline bool is_cx2584x(struct cx25840_state *state)
+{
+	return state->id == CX25840 ||
+	       state->id == CX25841 ||
+	       state->id == CX25842 ||
+	       state->id == CX25843;
+}
+
 static inline bool is_cx231xx(struct cx25840_state *state)
 {
 	return state->id == CX2310X_AV;
@@ -156,6 +168,7 @@ int cx25840_and_or(struct i2c_client *client, u16 addr, unsigned mask, u8 value)
 int cx25840_and_or4(struct i2c_client *client, u16 addr, u32 and_mask,
 		    u32 or_value);
 void cx25840_std_setup(struct i2c_client *client);
+int cx25840_vconfig(struct i2c_client *client, u32 cfg_in);
 
 /* ----------------------------------------------------------------------- */
 /* cx25850-firmware.c                                                      */
diff --git a/drivers/media/i2c/cx25840/cx25840-vbi.c b/drivers/media/i2c/cx25840/cx25840-vbi.c
index 8c99a79fb726..23b7c1fb28ab 100644
--- a/drivers/media/i2c/cx25840/cx25840-vbi.c
+++ b/drivers/media/i2c/cx25840/cx25840-vbi.c
@@ -95,6 +95,7 @@ int cx25840_g_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *
 	memset(svbi->service_lines, 0, sizeof(svbi->service_lines));
 	svbi->service_set = 0;
 	/* we're done if raw VBI is active */
+	/* this will have to be changed for generic_mode VBI */
 	if ((cx25840_read(client, 0x404) & 0x10) == 0)
 		return 0;
 
@@ -137,6 +138,7 @@ int cx25840_s_raw_fmt(struct v4l2_subdev *sd, struct v4l2_vbi_format *fmt)
 		cx25840_write(client, 0x54f, vbi_offset);
 	else
 		cx25840_write(client, 0x47f, vbi_offset);
+	/* this will have to be changed for generic_mode VBI */
 	cx25840_write(client, 0x404, 0x2e);
 	return 0;
 }
@@ -157,6 +159,7 @@ int cx25840_s_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *
 	cx25840_std_setup(client);
 
 	/* Sliced VBI */
+	/* this will have to be changed for generic_mode VBI */
 	cx25840_write(client, 0x404, 0x32);	/* Ancillary data */
 	cx25840_write(client, 0x406, 0x13);
 	if (is_cx23888(state))
diff --git a/include/media/drv-intf/cx25840.h b/include/media/drv-intf/cx25840.h
index 783c5bdd63eb..dc104b4f09eb 100644
--- a/include/media/drv-intf/cx25840.h
+++ b/include/media/drv-intf/cx25840.h
@@ -88,6 +88,70 @@ enum cx25840_video_input {
 	CX25840_DIF_ON = 0x80000400,
 };
 
+/* arguments to video s_routing config param */
+#define CX25840_VCONFIG_FMT_SHIFT 0
+#define CX25840_VCONFIG_FMT_MASK GENMASK(2, 0)
+#define CX25840_VCONFIG_FMT_BT601 BIT(0)
+#define CX25840_VCONFIG_FMT_BT656 BIT(1)
+#define CX25840_VCONFIG_FMT_VIP11 GENMASK(1, 0)
+#define CX25840_VCONFIG_FMT_VIP2 BIT(2)
+
+#define CX25840_VCONFIG_RES_SHIFT 3
+#define CX25840_VCONFIG_RES_MASK GENMASK(4, 3)
+#define CX25840_VCONFIG_RES_8BIT BIT(3)
+#define CX25840_VCONFIG_RES_10BIT BIT(4)
+
+#define CX25840_VCONFIG_VBIRAW_SHIFT 5
+#define CX25840_VCONFIG_VBIRAW_MASK GENMASK(6, 5)
+#define CX25840_VCONFIG_VBIRAW_DISABLED BIT(5)
+#define CX25840_VCONFIG_VBIRAW_ENABLED BIT(6)
+
+#define CX25840_VCONFIG_ANCDATA_SHIFT 7
+#define CX25840_VCONFIG_ANCDATA_MASK GENMASK(8, 7)
+#define CX25840_VCONFIG_ANCDATA_DISABLED BIT(7)
+#define CX25840_VCONFIG_ANCDATA_ENABLED BIT(8)
+
+#define CX25840_VCONFIG_TASKBIT_SHIFT 9
+#define CX25840_VCONFIG_TASKBIT_MASK GENMASK(10, 9)
+#define CX25840_VCONFIG_TASKBIT_ZERO BIT(9)
+#define CX25840_VCONFIG_TASKBIT_ONE BIT(10)
+
+#define CX25840_VCONFIG_ACTIVE_SHIFT 11
+#define CX25840_VCONFIG_ACTIVE_MASK GENMASK(12, 11)
+#define CX25840_VCONFIG_ACTIVE_COMPOSITE BIT(11)
+#define CX25840_VCONFIG_ACTIVE_HORIZONTAL BIT(12)
+
+#define CX25840_VCONFIG_VALID_SHIFT 13
+#define CX25840_VCONFIG_VALID_MASK GENMASK(14, 13)
+#define CX25840_VCONFIG_VALID_NORMAL BIT(13)
+#define CX25840_VCONFIG_VALID_ANDACTIVE BIT(14)
+
+#define CX25840_VCONFIG_HRESETW_SHIFT 15
+#define CX25840_VCONFIG_HRESETW_MASK GENMASK(16, 15)
+#define CX25840_VCONFIG_HRESETW_NORMAL BIT(15)
+#define CX25840_VCONFIG_HRESETW_PIXCLK BIT(16)
+
+#define CX25840_VCONFIG_CLKGATE_SHIFT 17
+#define CX25840_VCONFIG_CLKGATE_MASK GENMASK(18, 17)
+#define CX25840_VCONFIG_CLKGATE_NONE BIT(17)
+#define CX25840_VCONFIG_CLKGATE_VALID BIT(18)
+#define CX25840_VCONFIG_CLKGATE_VALIDACTIVE GENMASK(18, 17)
+
+#define CX25840_VCONFIG_DCMODE_SHIFT 19
+#define CX25840_VCONFIG_DCMODE_MASK GENMASK(20, 19)
+#define CX25840_VCONFIG_DCMODE_DWORDS BIT(19)
+#define CX25840_VCONFIG_DCMODE_BYTES BIT(20)
+
+#define CX25840_VCONFIG_IDID0S_SHIFT 21
+#define CX25840_VCONFIG_IDID0S_MASK GENMASK(22, 21)
+#define CX25840_VCONFIG_IDID0S_NORMAL BIT(21)
+#define CX25840_VCONFIG_IDID0S_LINECNT BIT(22)
+
+#define CX25840_VCONFIG_VIPCLAMP_SHIFT 23
+#define CX25840_VCONFIG_VIPCLAMP_MASK GENMASK(24, 23)
+#define CX25840_VCONFIG_VIPCLAMP_ENABLED BIT(23)
+#define CX25840_VCONFIG_VIPCLAMP_DISABLED BIT(24)
+
 enum cx25840_audio_input {
 	/* Audio inputs: serial or In4-In8 */
 	CX25840_AUDIO_SERIAL,
@@ -180,9 +244,17 @@ enum cx23885_io_pad {
    audio autodetect fails on some channels for these models and the workaround
    is to select the audio standard explicitly. Many thanks to Hauppauge for
    providing this information.
-   This platform data only needs to be supplied by the ivtv driver. */
+   This platform data only needs to be supplied by the ivtv driver.
+
+   generic_mode disables some of the ivtv-related hacks in this driver,
+   enables setting video output config and sets it according to datasheet
+   defaults on initialization.
+   This flag is to be used for example with USB video capture devices
+   using this chip.
+*/
 struct cx25840_platform_data {
 	int pvr150_workaround;
+	int generic_mode;
 };
 
 #endif

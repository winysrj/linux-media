Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29592 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab3EFJei (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 05:34:38 -0400
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC 2/2] media: added max77693-led driver
Date: Mon, 06 May 2013 11:33:48 +0200
Message-id: <1367832828-30771-3-git-send-email-a.hajda@samsung.com>
In-reply-to: <1367832828-30771-1-git-send-email-a.hajda@samsung.com>
References: <1367832828-30771-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch adds led-flash support to Maxim max77693 chipset.
Device is exposed to user space as a V4L2 subdevice.
It can be accessed via V4L2 controls interface.
Device supports up to two leds which can work in
flash and torch mode. Leds can be triggered externally or
by software.
Device is also exposed via LED API using v4l2-leddev helper.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v3:
- added v4l2-leddev support

v2:
- kzalloc replaced by devm_kzalloc
- corrected cleanup code on probe fail
- simplified clamp routine
- cosmetic changes
---
 drivers/media/i2c/max77693-led.c |  650 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 650 insertions(+)
 create mode 100644 drivers/media/i2c/max77693-led.c

diff --git a/drivers/media/i2c/max77693-led.c b/drivers/media/i2c/max77693-led.c
new file mode 100644
index 0000000..a597611
--- /dev/null
+++ b/drivers/media/i2c/max77693-led.c
@@ -0,0 +1,650 @@
+/*
+ * Copyright (C) 2013, Samsung Electronics Co., Ltd.
+ * Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <asm/div64.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/mfd/max77693.h>
+#include <linux/mfd/max77693-private.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-leddev.h>
+
+#define MAX77693_TORCH_IOUT_BITS	4
+
+#define MAX77693_TORCH_NO_TIMER		0x40
+#define MAX77693_FLASH_TIMER_LEVEL	0x80
+
+#define MAX77693_FLASH_EN_OFF		0
+#define MAX77693_FLASH_EN_FLASH		1
+#define MAX77693_FLASH_EN_TORCH		2
+#define MAX77693_FLASH_EN_ON		3
+
+#define MAX77693_FLASH_EN1_SHIFT	6
+#define MAX77693_FLASH_EN2_SHIFT	4
+#define MAX77693_TORCH_EN1_SHIFT	2
+#define MAX77693_TORCH_EN2_SHIFT	0
+
+#define MAX77693_FLASH_LOW_BATTERY_EN	0x80
+
+#define MAX77693_FLASH_BOOST_FIXED	0x04
+#define MAX77693_FLASH_BOOST_LEDNUM_2	0x80
+
+#define MAX77693_FLASH_TIMEOUT_MIN	62500
+#define MAX77693_FLASH_TIMEOUT_MAX	1000000
+#define MAX77693_FLASH_TIMEOUT_STEP	62500
+
+#define MAX77693_TORCH_TIMEOUT_MIN	262000
+#define MAX77693_TORCH_TIMEOUT_MAX	15728000
+
+#define MAX77693_FLASH_IOUT_MIN		15625
+#define MAX77693_FLASH_IOUT_MAX_1LED	1000000
+#define MAX77693_FLASH_IOUT_MAX_2LEDS	625000
+#define MAX77693_FLASH_IOUT_STEP	15625
+
+#define MAX77693_TORCH_IOUT_MIN		15625
+#define MAX77693_TORCH_IOUT_MAX		250000
+#define MAX77693_TORCH_IOUT_STEP	15625
+
+#define MAX77693_FLASH_VSYS_MIN		2400
+#define MAX77693_FLASH_VSYS_MAX		3400
+#define MAX77693_FLASH_VSYS_STEP	33
+
+#define MAX77693_FLASH_VOUT_MIN		3300
+#define MAX77693_FLASH_VOUT_MAX		5500
+#define MAX77693_FLASH_VOUT_STEP	25
+#define MAX77693_FLASH_VOUT_RMIN	0x0c
+
+#define MAX77693_LED_STATUS_FLASH_ON	(1 << 3)
+#define MAX77693_LED_STATUS_TORCH_ON	(1 << 2)
+
+enum {
+	FLASH1,
+	FLASH2,
+	TORCH1,
+	TORCH2
+};
+
+enum {
+	FLASH,
+	TORCH
+};
+
+struct max77693_led {
+	struct regmap *regmap;
+	struct v4l2_subdev subdev;
+	struct platform_device *pdev;
+	struct max77693_led_platform_data *pdata;
+	struct v4l2_leddev leddev;
+
+	struct v4l2_ctrl_handler hdl;
+	struct {
+		struct v4l2_ctrl *led_mode;
+		struct v4l2_ctrl *source;
+	} ctrl;
+};
+
+static u8 max77693_led_iout_to_reg(u32 ua)
+{
+	if (ua < MAX77693_FLASH_IOUT_MIN)
+		ua = MAX77693_FLASH_IOUT_MIN;
+	return (ua - MAX77693_FLASH_IOUT_MIN) / MAX77693_FLASH_IOUT_STEP;
+}
+
+static u8 max77693_led_timeout_to_reg(u32 us)
+{
+	return (us - MAX77693_FLASH_TIMEOUT_MIN) / MAX77693_FLASH_TIMEOUT_STEP;
+}
+
+static const u32 max77693_torch_timeouts[] = {
+	262000, 524000, 786000, 1048000,
+	1572000, 2096000, 2620000, 3144000,
+	4193000, 5242000, 6291000, 7340000,
+	9437000, 11534000, 13631000, 1572800
+};
+
+static u8 max77693_torch_timeout_to_reg(u32 us)
+{
+	int i, b = 0, e = ARRAY_SIZE(max77693_torch_timeouts);
+
+	while (e - b > 1) {
+		i = b + (e - b) / 2;
+		if (us < max77693_torch_timeouts[i])
+			e = i;
+		else
+			b = i;
+	}
+	return b;
+}
+
+static u32 max77693_torch_timeout_from_reg(u8 reg)
+{
+	return max77693_torch_timeouts[reg];
+}
+
+static u8 max77693_led_vsys_to_reg(u32 mv)
+{
+	return ((mv - MAX77693_FLASH_VSYS_MIN) / MAX77693_FLASH_VSYS_STEP) << 2;
+}
+
+static u8 max77693_led_vout_to_reg(u32 mv)
+{
+	return (mv - MAX77693_FLASH_VOUT_MIN) / MAX77693_FLASH_VOUT_STEP +
+		MAX77693_FLASH_VOUT_RMIN;
+}
+
+enum max77693_led_mode {
+	MODE_OFF,
+	MODE_FLASH,
+	MODE_TORCH,
+	MODE_EXTERNAL
+};
+
+static int max77693_led_set_mode(struct max77693_led *flash,
+			    enum max77693_led_mode mode)
+{
+	struct max77693_led_platform_data *p = flash->pdata;
+	struct regmap *rmap = flash->regmap;
+	int ret, v = 0;
+
+	switch (mode) {
+	case MODE_OFF:
+		break;
+	case MODE_FLASH:
+		if (p->trigger[FLASH1] & MAX77693_LED_TRIG_SOFT)
+			v |= MAX77693_FLASH_EN_ON << MAX77693_FLASH_EN1_SHIFT;
+		if (p->trigger[FLASH2] & MAX77693_LED_TRIG_SOFT)
+			v |= MAX77693_FLASH_EN_ON << MAX77693_FLASH_EN2_SHIFT;
+		break;
+	case MODE_TORCH:
+		if (p->trigger[TORCH1] & MAX77693_LED_TRIG_SOFT)
+			v |= MAX77693_FLASH_EN_ON << MAX77693_TORCH_EN1_SHIFT;
+		if (p->trigger[TORCH2] & MAX77693_LED_TRIG_SOFT)
+			v |= MAX77693_FLASH_EN_ON << MAX77693_TORCH_EN2_SHIFT;
+		break;
+	case MODE_EXTERNAL:
+		v |= (p->trigger[FLASH1] & MAX77693_LED_TRIG_EXT) <<
+						MAX77693_FLASH_EN1_SHIFT;
+		v |= (p->trigger[FLASH2] & MAX77693_LED_TRIG_EXT) <<
+						MAX77693_FLASH_EN2_SHIFT;
+		v |= (p->trigger[TORCH1] & MAX77693_LED_TRIG_EXT) <<
+						MAX77693_TORCH_EN1_SHIFT;
+		v |= (p->trigger[TORCH2] & MAX77693_LED_TRIG_EXT) <<
+						MAX77693_TORCH_EN2_SHIFT;
+		break;
+	}
+	if (v != 0)
+		max77693_write_reg(rmap, MAX77693_LED_REG_FLASH_EN, 0);
+	ret = max77693_write_reg(rmap, MAX77693_LED_REG_FLASH_EN, v);
+
+	return ret;
+}
+
+static int max77693_led_setup(struct max77693_led *flash)
+{
+	struct max77693_led_platform_data *p = flash->pdata;
+	struct regmap *rmap = flash->regmap;
+	int ret;
+	u8 v;
+
+	v = max77693_led_iout_to_reg(p->iout[FLASH1]);
+	ret = max77693_write_reg(rmap, MAX77693_LED_REG_IFLASH1, v);
+	if (ret < 0)
+		return ret;
+
+	v = max77693_led_iout_to_reg(p->iout[FLASH2]);
+	ret = max77693_write_reg(rmap, MAX77693_LED_REG_IFLASH2, v);
+	if (ret < 0)
+		return ret;
+
+	v = max77693_led_iout_to_reg(p->iout[TORCH1]);
+	v |= max77693_led_iout_to_reg(p->iout[TORCH2]) <<
+						MAX77693_TORCH_IOUT_BITS;
+	ret = max77693_write_reg(rmap, MAX77693_LED_REG_ITORCH, v);
+	if (ret < 0)
+		return ret;
+
+	if (p->timeout[TORCH] > 0)
+		v = max77693_torch_timeout_to_reg(p->timeout[TORCH]);
+	else
+		v = MAX77693_TORCH_NO_TIMER;
+	if (p->trigger_type[TORCH] == MAX77693_LED_TRIG_TYPE_LEVEL)
+		v |= MAX77693_FLASH_TIMER_LEVEL;
+	ret = max77693_write_reg(rmap, MAX77693_LED_REG_ITORCHTIMER, v);
+	if (ret < 0)
+		return ret;
+
+	v = max77693_led_timeout_to_reg(p->timeout[FLASH]);
+	if (p->trigger_type[FLASH] == MAX77693_LED_TRIG_TYPE_LEVEL)
+		v |= MAX77693_FLASH_TIMER_LEVEL;
+	ret = max77693_write_reg(rmap, MAX77693_LED_REG_FLASH_TIMER, v);
+	if (ret < 0)
+		return ret;
+
+	if (p->low_vsys > 0)
+		v = max77693_led_vsys_to_reg(p->low_vsys) |
+						MAX77693_FLASH_LOW_BATTERY_EN;
+	else
+		v = 0;
+
+	ret = max77693_write_reg(rmap, MAX77693_LED_REG_MAX_FLASH1, v);
+	if (ret < 0)
+		return ret;
+	ret = max77693_write_reg(rmap, MAX77693_LED_REG_MAX_FLASH2, 0);
+	if (ret < 0)
+		return ret;
+
+	if (p->boost_mode[FLASH1] == MAX77693_LED_BOOST_FIXED ||
+	    p->boost_mode[FLASH2] == MAX77693_LED_BOOST_FIXED)
+		v = MAX77693_FLASH_BOOST_FIXED;
+	else
+		v = p->boost_mode[FLASH1] | (p->boost_mode[FLASH2] << 1);
+	if (p->boost_mode[FLASH1] && p->boost_mode[FLASH2])
+		v |= MAX77693_FLASH_BOOST_LEDNUM_2;
+	ret = max77693_write_reg(rmap, MAX77693_LED_REG_VOUT_CNTL, v);
+	if (ret < 0)
+		return ret;
+
+	v = max77693_led_vout_to_reg(p->boost_vout);
+	ret = max77693_write_reg(rmap, MAX77693_LED_REG_VOUT_FLASH1, v);
+	if (ret < 0)
+		return ret;
+
+	ret = max77693_led_set_mode(flash, MODE_OFF);
+
+	return ret;
+}
+
+static struct max77693_led *ctrl_to_flash(struct v4l2_ctrl *c)
+{
+	return container_of(c->handler, struct max77693_led, hdl);
+}
+
+static struct max77693_led *subdev_to_flash(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct max77693_led, subdev);
+}
+
+static int max77693_led_get_ctrl(struct v4l2_ctrl *c)
+{
+	struct max77693_led *flash = ctrl_to_flash(c);
+	struct regmap *rmap = flash->regmap;
+	int ret;
+	u8 v;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_STROBE_STATUS:
+		ret = max77693_read_reg(rmap, MAX77693_LED_REG_FLASH_INT_STATUS,
+									&v);
+		c->val = !!(v & MAX77693_LED_STATUS_FLASH_ON);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/* split composite current @i into two @iout according to @imax weights */
+static void max77693_led_calc_iout(u32 iout[2], u32 i, u32 imax[2])
+{
+	u64 t = i;
+
+	t *= imax[1];
+	do_div(t, imax[0] + imax[1]);
+
+	iout[1] = (u32)t / MAX77693_FLASH_IOUT_STEP * MAX77693_FLASH_IOUT_STEP;
+	iout[0] = i - iout[1];
+}
+
+static int max77693_led_set_ctrl(struct v4l2_ctrl *c)
+{
+	struct max77693_led *flash = ctrl_to_flash(c);
+	struct max77693_led_platform_data *p = flash->pdata;
+	struct regmap *rmap = flash->regmap;
+	int v, ret = 0;
+	u32 iout[2];
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_LED_MODE:
+		switch (c->val) {
+		case V4L2_FLASH_LED_MODE_NONE:
+			ret = max77693_led_set_mode(flash, MODE_OFF);
+			break;
+		case V4L2_FLASH_LED_MODE_FLASH:
+			if (flash->ctrl.source->val ==
+					V4L2_FLASH_STROBE_SOURCE_EXTERNAL)
+				ret = max77693_led_set_mode(flash,
+								MODE_EXTERNAL);
+			else
+				ret = max77693_led_set_mode(flash, MODE_OFF);
+			break;
+		case V4L2_FLASH_LED_MODE_TORCH:
+			ret = max77693_led_set_mode(flash, MODE_TORCH);
+			break;
+		}
+		break;
+	case V4L2_CID_FLASH_STROBE_SOURCE:
+		if (c->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL)
+			ret = max77693_led_set_mode(flash, MODE_EXTERNAL);
+		else
+			ret = max77693_led_set_mode(flash, MODE_OFF);
+		break;
+	case V4L2_CID_FLASH_STROBE:
+		if (flash->ctrl.led_mode->val != V4L2_FLASH_LED_MODE_FLASH ||
+		   flash->ctrl.source->val != V4L2_FLASH_STROBE_SOURCE_SOFTWARE)
+			return -EINVAL;
+		ret = max77693_led_set_mode(flash, MODE_FLASH);
+		break;
+	case V4L2_CID_FLASH_STROBE_STOP:
+		ret = max77693_led_set_mode(flash, MODE_OFF);
+		break;
+	case V4L2_CID_FLASH_TIMEOUT:
+		v = max77693_led_timeout_to_reg(c->val);
+		if (p->trigger_type[FLASH] == MAX77693_LED_TRIG_TYPE_LEVEL)
+			v |= MAX77693_FLASH_TIMER_LEVEL;
+		ret = max77693_write_reg(rmap, MAX77693_LED_REG_FLASH_TIMER, v);
+		break;
+	case V4L2_CID_FLASH_INTENSITY:
+		max77693_led_calc_iout(iout, 1000 * c->val, &p->iout[FLASH1]);
+		v = max77693_led_iout_to_reg(iout[0]);
+		ret = max77693_write_reg(rmap, MAX77693_LED_REG_IFLASH1, v);
+		if (ret < 0)
+			break;
+		v = max77693_led_iout_to_reg(iout[1]);
+		ret = max77693_write_reg(rmap, MAX77693_LED_REG_IFLASH2, v);
+		break;
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+		max77693_led_calc_iout(iout, 1000 * c->val, &p->iout[TORCH1]);
+		v = max77693_led_iout_to_reg(iout[0]);
+		v |= max77693_led_iout_to_reg(iout[1]) <<
+						MAX77693_TORCH_IOUT_BITS;
+		ret = max77693_write_reg(rmap, MAX77693_LED_REG_ITORCH, v);
+	}
+
+	return ret;
+}
+
+static const struct v4l2_ctrl_ops max77693_led_ctrl_ops = {
+	.g_volatile_ctrl = max77693_led_get_ctrl,
+	.s_ctrl = max77693_led_set_ctrl,
+};
+
+static int max77693_init_controls(struct max77693_led *flash)
+{
+	struct max77693_led_platform_data *p = flash->pdata;
+	struct v4l2_ctrl *ctrl;
+	int mask, max;
+
+	v4l2_ctrl_handler_init(&flash->hdl, 8);
+
+	mask = 1 << V4L2_FLASH_LED_MODE_NONE;
+	max = V4L2_FLASH_LED_MODE_NONE;
+
+	if (p->trigger[FLASH1] | p->trigger[FLASH2] |
+	    ((p->trigger[TORCH1] | p->trigger[TORCH2]) &
+	     ~MAX77693_LED_TRIG_SOFT)) {
+		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;
+		max = V4L2_FLASH_LED_MODE_FLASH;
+	}
+	if (p->trigger[TORCH1] | p->trigger[TORCH2]) {
+		mask |= 1 << V4L2_FLASH_LED_MODE_TORCH;
+		max = V4L2_FLASH_LED_MODE_TORCH;
+	}
+
+	flash->ctrl.led_mode = v4l2_ctrl_new_std_menu(&flash->hdl,
+			&max77693_led_ctrl_ops, V4L2_CID_FLASH_LED_MODE,
+			max, ~mask, V4L2_FLASH_LED_MODE_NONE);
+
+	mask = 1 << V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+	max = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+
+	if ((p->trigger[FLASH1] | p->trigger[FLASH2] | p->trigger[TORCH1] |
+	     p->trigger[TORCH2]) & ~MAX77693_LED_TRIG_SOFT) {
+		mask |= 1 << V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
+		max = V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
+	}
+
+	flash->ctrl.source = v4l2_ctrl_new_std_menu(&flash->hdl,
+			&max77693_led_ctrl_ops, V4L2_CID_FLASH_STROBE_SOURCE,
+			max, ~mask, V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
+
+
+	v4l2_ctrl_new_std(&flash->hdl, &max77693_led_ctrl_ops,
+			  V4L2_CID_FLASH_STROBE, 0, 0, 0, 0);
+
+
+	v4l2_ctrl_new_std(&flash->hdl, &max77693_led_ctrl_ops,
+			  V4L2_CID_FLASH_STROBE_STOP, 0, 0, 0, 0);
+
+
+	ctrl = v4l2_ctrl_new_std(&flash->hdl, &max77693_led_ctrl_ops,
+				 V4L2_CID_FLASH_STROBE_STATUS, 0, 1, 1, 1);
+	if (ctrl != NULL)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
+	v4l2_ctrl_new_std(&flash->hdl, &max77693_led_ctrl_ops,
+			  V4L2_CID_FLASH_TIMEOUT, MAX77693_FLASH_TIMEOUT_MIN,
+			  MAX77693_FLASH_TIMEOUT_MAX,
+			  MAX77693_FLASH_TIMEOUT_STEP, p->timeout[FLASH]);
+
+	max = (p->iout[FLASH1] + p->iout[FLASH2]) / 1000;
+	v4l2_ctrl_new_std(&flash->hdl, &max77693_led_ctrl_ops,
+			  V4L2_CID_FLASH_INTENSITY,
+			  MAX77693_FLASH_IOUT_MIN / 1000, max, 1, max);
+
+	max = (p->iout[TORCH1] + p->iout[TORCH2]) / 1000;
+	v4l2_ctrl_new_std(&flash->hdl, &max77693_led_ctrl_ops,
+			  V4L2_CID_FLASH_TORCH_INTENSITY,
+			  MAX77693_TORCH_IOUT_MIN / 1000, max, 1, max);
+
+	flash->subdev.ctrl_handler = &flash->hdl;
+
+	return flash->hdl.error;
+}
+
+static void max77693_led_parse_dt(struct max77693_led_platform_data *p,
+			    struct device_node *node)
+{
+	of_property_read_u32_array(node, "maxim,iout", p->iout, 4);
+	of_property_read_u32_array(node, "maxim,trigger", p->trigger, 4);
+	of_property_read_u32_array(node, "maxim,trigger-type", p->trigger_type,
+									2);
+	of_property_read_u32_array(node, "maxim,timeout", p->timeout, 2);
+	of_property_read_u32_array(node, "maxim,boost-mode", p->boost_mode, 2);
+	of_property_read_u32(node, "maxim,boost-vout", &p->boost_vout);
+	of_property_read_u32(node, "maxim,low-vsys", &p->low_vsys);
+}
+
+static void clamp_align(u32 *v, u32 min, u32 max, u32 step)
+{
+	*v = clamp_val(*v, min, max);
+	if (step > 1)
+		*v = (*v - min) / step * step + min;
+}
+
+static void max77693_led_validate_platform_data(
+					struct max77693_led_platform_data *p)
+{
+	u32 max;
+	int i;
+
+	for (i = 0; i < 2; ++i)
+		clamp_align(&p->boost_mode[i], MAX77693_LED_BOOST_NONE,
+			    MAX77693_LED_BOOST_FIXED, 1);
+	/* boost, if enabled, should be the same on both leds */
+	if (p->boost_mode[0] != MAX77693_LED_BOOST_NONE &&
+	    p->boost_mode[1] != MAX77693_LED_BOOST_NONE)
+		p->boost_mode[1] = p->boost_mode[0];
+
+	max = (p->boost_mode[FLASH1] && p->boost_mode[FLASH2]) ?
+		  MAX77693_FLASH_IOUT_MAX_2LEDS : MAX77693_FLASH_IOUT_MAX_1LED;
+
+	clamp_align(&p->iout[FLASH1], MAX77693_FLASH_IOUT_MIN,
+		    max, MAX77693_FLASH_IOUT_STEP);
+	clamp_align(&p->iout[FLASH2], MAX77693_FLASH_IOUT_MIN,
+		    max, MAX77693_FLASH_IOUT_STEP);
+	clamp_align(&p->iout[TORCH1], MAX77693_TORCH_IOUT_MIN,
+		    MAX77693_TORCH_IOUT_MAX, MAX77693_TORCH_IOUT_STEP);
+	clamp_align(&p->iout[TORCH2], MAX77693_TORCH_IOUT_MIN,
+		    MAX77693_TORCH_IOUT_MAX, MAX77693_TORCH_IOUT_STEP);
+
+	for (i = 0; i < 4; ++i)
+		clamp_align(&p->trigger[i], 0, 7, 1);
+	for (i = 0; i < 2; ++i)
+		clamp_align(&p->trigger_type[i], MAX77693_LED_TRIG_TYPE_EDGE,
+			    MAX77693_LED_TRIG_TYPE_LEVEL, 1);
+
+	clamp_align(&p->timeout[FLASH], MAX77693_FLASH_TIMEOUT_MIN,
+		    MAX77693_FLASH_TIMEOUT_MAX, MAX77693_FLASH_TIMEOUT_STEP);
+
+	if (p->timeout[TORCH]) {
+		clamp_align(&p->timeout[TORCH], MAX77693_TORCH_TIMEOUT_MIN,
+			    MAX77693_TORCH_TIMEOUT_MAX, 1);
+		p->timeout[TORCH] = max77693_torch_timeout_from_reg(
+			      max77693_torch_timeout_to_reg(p->timeout[TORCH]));
+	}
+
+	clamp_align(&p->boost_vout, MAX77693_FLASH_VOUT_MIN,
+		    MAX77693_FLASH_VOUT_MAX, MAX77693_FLASH_VOUT_STEP);
+
+	if (p->low_vsys) {
+		clamp_align(&p->low_vsys, MAX77693_FLASH_VSYS_MIN,
+			    MAX77693_FLASH_VSYS_MAX, MAX77693_FLASH_VSYS_STEP);
+	}
+}
+
+static int max77693_led_get_platform_data(struct max77693_led *flash)
+{
+	struct max77693_led_platform_data *p;
+	struct device *dev = &flash->pdev->dev;
+
+	if (dev->of_node) {
+		p = devm_kzalloc(dev, sizeof(*flash->pdata), GFP_KERNEL);
+		if (!p)
+			return -ENOMEM;
+		max77693_led_parse_dt(p, dev->of_node);
+	} else {
+		p = dev_get_platdata(dev);
+		if (!p)
+			return -ENODEV;
+	}
+	flash->pdata = p;
+
+	max77693_led_validate_platform_data(p);
+
+	dev_info(dev, "Iout[uA]=%d,%d,%d,%d; Triggers=%d,%d,%d,%d;"
+		 "TriggerTypes=%d,%d;Timeouts[us]=%d,%d;BM=%d,%d;"
+		 "Vout[mV]=%d;LowVsys[mV]=%d\n",
+		 p->iout[0], p->iout[1], p->iout[2], p->iout[3],
+		 p->trigger[0], p->trigger[1], p->trigger[2], p->trigger[3],
+		 p->trigger_type[0], p->trigger_type[1],
+		 p->timeout[0], p->timeout[1],
+		 p->boost_mode[0], p->boost_mode[1],
+		 p->boost_vout, p->low_vsys);
+
+	return 0;
+}
+
+/* v4l2_subdev_init requires this structure */
+static struct v4l2_subdev_ops max77693_led_subdev_ops = {
+};
+
+static int max77693_led_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct max77693_dev *iodev = dev_get_drvdata(dev->parent);
+	struct max77693_led *flash;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	flash = devm_kzalloc(dev, sizeof(*flash), GFP_KERNEL);
+	if (!flash)
+		return -ENOMEM;
+
+	flash->pdev = pdev;
+	flash->regmap = iodev->regmap;
+	ret = max77693_led_get_platform_data(flash);
+	if (ret < 0)
+		return ret;
+
+	sd = &flash->subdev;
+	v4l2_subdev_init(sd, &max77693_led_subdev_ops);
+	sd->owner = pdev->dev.driver->owner;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	strlcpy(sd->name, "max77693-led", sizeof(sd->name));
+	platform_set_drvdata(pdev, sd);
+
+	ret = max77693_init_controls(flash);
+	if (ret < 0)
+		goto err;
+
+	ret = media_entity_init(&sd->entity, 0, NULL, 0);
+	if (ret < 0)
+		goto err;
+
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
+
+	ret = max77693_led_setup(flash);
+	if (!ret) {
+		flash->leddev.sd = sd;
+		ret = v4l2_leddev_register(dev, &flash->leddev);
+	}
+	if (!ret)
+		return 0;
+
+	media_entity_cleanup(&sd->entity);
+err:
+	v4l2_ctrl_handler_free(&flash->hdl);
+	return ret;
+}
+
+static int max77693_led_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct max77693_led *flash = subdev_to_flash(sd);
+
+	v4l2_leddev_unregister(&flash->leddev);
+	v4l2_device_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_ctrl_handler_free(&flash->hdl);
+
+	return 0;
+}
+
+static struct of_device_id max77693_led_dt_match[] = {
+	{.compatible = "maxim,max77693-led"},
+	{},
+};
+
+static struct platform_driver max77693_led_driver = {
+	.probe		= max77693_led_probe,
+	.remove		= max77693_led_remove,
+	.driver		= {
+		.name	= "max77693-led",
+		.owner	= THIS_MODULE,
+		.of_match_table = max77693_led_dt_match,
+	},
+};
+
+module_platform_driver(max77693_led_driver);
+
+MODULE_AUTHOR("Andrzej Hajda <a.hajda@samsung.com>");
+MODULE_DESCRIPTION("Maxim MAX77693 led flash driver");
+MODULE_LICENSE("GPL");
-- 
1.7.10.4


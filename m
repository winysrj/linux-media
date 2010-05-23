Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2729 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab0EWMkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 08:40:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Subject: Re: [PATCH v3 6/8] V4L2 subdev patchset for Intel Moorestown Camera Imaging Subsystem
Date: Sun, 23 May 2010 14:42:04 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <33AB447FBD802F4E932063B962385B351E895733@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <33AB447FBD802F4E932063B962385B351E895733@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005231442.04623.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 18 May 2010 11:23:34 Zhang, Xiaolin wrote:
> From 46bf8433c86a7450604a981981c8ce487130dce0 Mon Sep 17 00:00:00 2001
> From: Xiaolin Zhang <xiaolin.zhang@intel.com>
> Date: Tue, 18 May 2010 15:25:50 +0800
> Subject: [PATCH 6/8] This patch is to add AD5820 VCM (for ov5630)driver support
>  which is based on the video4linux2 sub-dev driver framework.
> 
> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
> ---
>  drivers/media/video/ov5630_motor.c |  365 ++++++++++++++++++++++++++++++++++++
>  drivers/media/video/ov5630_motor.h |   77 ++++++++
>  2 files changed, 442 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/ov5630_motor.c
>  create mode 100644 drivers/media/video/ov5630_motor.h
> 
> diff --git a/drivers/media/video/ov5630_motor.c b/drivers/media/video/ov5630_motor.c
> new file mode 100644
> index 0000000..dfac612
> --- /dev/null
> +++ b/drivers/media/video/ov5630_motor.c
> @@ -0,0 +1,365 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <media/v4l2-device.h>
> +
> +#include "ov5630_motor.h"
> +
> +static int mrstov5630_motor_debug;
> +module_param(mrstov5630_motor_debug, int, 0644);
> +MODULE_PARM_DESC(mrstov5630_motor_debug, "Debug level (0-1)");
> +
> +#define dprintk(level, fmt, arg...) do {			\
> +	if (mrstov5630_motor_debug >= level) 				\
> +		printk(KERN_DEBUG "mrstisp@%s: " fmt "\n", \
> +		       __func__, ## arg); } \
> +	while (0)
> +
> +#define eprintk(fmt, arg...)	\
> +	printk(KERN_ERR "mrstisp@%s: line %d: " fmt "\n",	\
> +	       __func__, __LINE__, ## arg);
> +
> +static inline struct ov5630_motor *to_motor_config(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct ov5630_motor, sd);
> +}
> +
> +static int motor_read(struct i2c_client *c, u16 *reg)
> +{
> +	int ret;
> +	struct i2c_msg msg;
> +	u8 msgbuf[2];
> +
> +	msgbuf[0] = 0;
> +	msgbuf[1] = 0;
> +
> +	memset(&msg, 0, sizeof(msg));
> +	msg.addr = c->addr;
> +	msg.buf = msgbuf;
> +	msg.len = 2;
> +	msg.flags = I2C_M_RD;
> +
> +	ret = i2c_transfer(c->adapter, &msg, 1);
> +	*reg = (msgbuf[0] << 8 | msgbuf[1]);
> +
> +	ret = (ret == 1) ? 0 : -1;
> +	return ret;
> +}
> +
> +static int motor_write(struct i2c_client *c, u16 reg)
> +{
> +	int ret;
> +	struct i2c_msg msg;
> +	u8 msgbuf[2];
> +
> +	memset(&msg, 0, sizeof(msg));
> +	msgbuf[0] = reg >> 8;
> +	msgbuf[1] = reg;
> +
> +	msg.addr = c->addr;
> +	msg.flags = 0;
> +	msg.buf = msgbuf;
> +	msg.len = 2;
> +
> +	ret = i2c_transfer(c->adapter, &msg, 1);
> +	ret = (ret == 1) ? 0 : -1;
> +	return ret;
> +}
> +
> +static int ov5630_motor_goto_position(struct i2c_client *c,
> +				      unsigned short code,
> +				      struct ov5630_motor *config)
> +{
> +	int max_code, min_code;
> +	u8 cmdh, cmdl;
> +	u16 cmd, val = 0;
> +
> +	max_code = config->macro_code;
> +	min_code = config->infin_code;
> +
> +	if (code > max_code)
> +		code = max_code;
> +	if (code < min_code)
> +		code = min_code;
> +
> +	cmdh = (MOTOR_DAC_CODE_H(code));
> +	cmdl = (MOTOR_DAC_CODE_L(code) | MOTOR_DAC_CTRL_MODE_2(SUB_MODE_4));
> +	cmd = cmdh << 8 | cmdl;
> +
> +	motor_write(c, cmd);
> +	msleep(8);
> +	motor_read(c, &val);
> +
> +	return (cmd == val ? 0 : -1);
> +}
> +
> +int ov5630_motor_init(struct i2c_client *client, struct ov5630_motor *config)

Why is this not static?

> +{
> +	int ret;
> +	int infin_cur, macro_cur;
> +
> +	infin_cur = max(MOTOR_INFIN_CUR, MOTOR_DAC_MIN_CUR);
> +	macro_cur = min(MOTOR_MACRO_CUR, MOTOR_DAC_MAX_CUR);
> +
> +	config->infin_cur = infin_cur;
> +	config->macro_cur = macro_cur;
> +	config->infin_code = (int)((infin_cur * MOTOR_DAC_MAX_CODE)
> +				   / MOTOR_DAC_MAX_CUR);
> +	config->macro_code = (int)((macro_cur * MOTOR_DAC_MAX_CODE)
> +				   / MOTOR_DAC_MAX_CUR);
> +
> +	config->max_step = ((config->macro_code - config->infin_code)
> +			    >> MOTOR_STEP_SHIFT) + 1;
> +	ret = ov5630_motor_goto_position(client, config->infin_code, config);
> +	if (!ret)
> +		config->cur_code = config->infin_code;
> +	else
> +		printk(KERN_ERR "Error while initializing motor\n");
> +
> +	return ret;
> +}
> +
> +int ov5630_motor_set_focus(struct i2c_client *c, int step,
> +			   struct ov5630_motor *config)

Missing static?

> +{
> +	int s_code, ret;
> +	int max_step = config->max_step;
> +	unsigned int val = step;
> +
> +	dprintk(1, "setting setp %d", step);
> +	if (val > max_step)
> +		val = max_step;
> +
> +	s_code = (val << MOTOR_STEP_SHIFT);
> +	s_code += config->infin_code;
> +
> +	ret = ov5630_motor_goto_position(c, s_code, config);
> +	if (!ret)
> +		config->cur_code = s_code;
> +
> +	return ret;
> +}
> +
> +static int ov5630_motor_s_ctrl(struct v4l2_subdev *sd,
> +			       struct v4l2_control *ctrl)
> +{
> +	int ret = -EINVAL;
> +	struct i2c_client *c = v4l2_get_subdevdata(sd);
> +	struct ov5630_motor *config = to_motor_config(sd);
> +	if (!sd || !ctrl)
> +		return ret;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_FOCUS_ABSOLUTE:
> +		ret = ov5630_motor_set_focus(c, ctrl->value, config);
> +		if (ret) {
> +			eprintk("error call ov5630_motor_set_focue");
> +			return ret;
> +		}
> +		break;
> +	default:
> +		dprintk(1, "not supported ctrl id");
> +		break;
> +	}
> +	return ret;
> +}
> +
> +int ov5630_motor_get_focus(struct i2c_client *c, unsigned int *step,
> +			   struct ov5630_motor *config)

Missing static?

> +{
> +	int ret_step;
> +
> +	ret_step = ((config->cur_code - config->infin_code)
> +		    >> MOTOR_STEP_SHIFT);
> +
> +	if (ret_step <= config->max_step)
> +		*step = ret_step;
> +	else
> +		*step = config->max_step;
> +
> +	return 0;
> +}
> +
> +static int ov5630_motor_g_ctrl(struct v4l2_subdev *sd,
> +			       struct v4l2_control *ctrl)
> +{
> +	int ret = -EINVAL;
> +	struct i2c_client *c = v4l2_get_subdevdata(sd);
> +	struct ov5630_motor *config = to_motor_config(sd);

Please add an empty line after variable declarations!

> +	if (!sd || !ctrl)
> +		return ret;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_FOCUS_ABSOLUTE:
> +		ret = ov5630_motor_get_focus(c, &ctrl->value, config);
> +		if (ret) {
> +			eprintk("error call ov5630_motor_get_focue");
> +			return ret;
> +		}
> +		break;
> +	default:
> +		dprintk(1, "not supported ctrl id");
> +		break;
> +	}
> +	return ret;
> +}
> +
> +static int ov5630_motor_queryctrl(struct v4l2_subdev *sd,
> +			    struct v4l2_queryctrl *qc)
> +{
> +	int ret = -EINVAL;
> +	struct ov5630_motor *config;
> +	if (!sd)
> +		return -ENODEV;
> +	if (!qc)
> +		return ret;
> +	config = to_motor_config(sd);
> +
> +	switch (qc->id) {
> +	case V4L2_CID_FOCUS_ABSOLUTE:
> +		ret = v4l2_ctrl_query_fill(qc, 0, config->max_step,
> +				 config->max_step, config->cur_code);
> +		break;
> +	default:
> +		dprintk(1, "not supported queryctrl id");
> +		break;
> +	}
> +	return ret;
> +}
> +
> +static const struct v4l2_subdev_core_ops ov5630_motor_core_ops = {
> +	.g_ctrl = ov5630_motor_g_ctrl,
> +	.s_ctrl = ov5630_motor_s_ctrl,
> +	.queryctrl = ov5630_motor_queryctrl,
> +};
> +
> +static const struct v4l2_subdev_ops ov5630_motor_ops = {
> +	.core = &ov5630_motor_core_ops,
> +};
> +
> +static int ov5630_motor_detect(struct i2c_client *client)
> +{
> +	struct i2c_adapter *adapter = client->adapter;
> +	int adap_id = i2c_adapter_id(adapter);
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
> +		eprintk("error i2c check func");
> +		return -ENODEV;
> +	}
> +
> +	if (adap_id != 1) {
> +		eprintk("adap_id != 1");
> +		return -ENODEV;
> +	}
> +
> +	ssleep(1);
> +
> +	return 0;
> +}
> +
> +static int ov5630_motor_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct ov5630_motor *info;
> +	struct v4l2_subdev *sd;
> +	int ret = -1;
> +
> +	v4l_info(client, "chip found @ 0x%x (%s)\n",
> +		 client->addr << 1, client->adapter->name);
> +
> +	info = kzalloc(sizeof(struct ov5630_motor), GFP_KERNEL);
> +	if (!info) {
> +		eprintk("fail to malloc for ci_motor");
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = ov5630_motor_detect(client);
> +	if (ret) {
> +		eprintk("error ov5630_motor_detect");
> +		goto out_free;
> +	}
> +
> +	sd = &info->sd;
> +	v4l2_i2c_subdev_init(sd, client, &ov5630_motor_ops);
> +
> +	ret = ov5630_motor_init(client, info);
> +	if (ret) {
> +		eprintk("error calling ov5630_motor_init");
> +		goto out_free;
> +	}
> +
> +	ret = 0;
> +	goto out;
> +
> +out_free:
> +	kfree(info);
> +out:
> +	return ret;
> +}
> +
> +static int ov5630_motor_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(to_motor_config(sd));
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id ov5630_motor_id[] = {
> +	{"ov5630_motor", 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, ov5630_motor_id);
> +
> +static struct i2c_driver ov5630_motor_i2c_driver = {
> +	.driver = {
> +		.name = "ov5630_motor",
> +	},
> +	.probe = ov5630_motor_probe,
> +	.remove = ov5630_motor_remove,
> +	.id_table = ov5630_motor_id,
> +};
> +
> +static int __init ov5630_motor_drv_init(void)
> +{
> +	return i2c_add_driver(&ov5630_motor_i2c_driver);
> +}
> +
> +static void __exit ov5630_motor_drv_cleanup(void)
> +{
> +	i2c_del_driver(&ov5630_motor_i2c_driver);
> +}
> +
> +module_init(ov5630_motor_drv_init);
> +module_exit(ov5630_motor_drv_cleanup);
> +
> +MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
> +MODULE_DESCRIPTION("A low-level driver for OmniVision 5630 sensors");
> +MODULE_LICENSE("GPL");

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

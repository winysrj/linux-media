Return-path: <mchehab@pedra>
Received: from msa105.auone-net.jp ([61.117.18.165]:45914 "EHLO
	msa105.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab1DRNzq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 09:55:46 -0400
Date: Mon, 18 Apr 2011 22:55:39 +0900
From: Akira Tsukamoto <akira-t@s9.dion.ne.jp>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc_camera with V4L2 driver 
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1104131540100.3565@axis700.grange>
References: <20110413222332.59A5.B41FCDD0@s9.dion.ne.jp> <Pine.LNX.4.64.1104131540100.3565@axis700.grange>
Message-Id: <20110418225538.155F.B41FCDD0@s9.dion.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Guennadi,

> > Sorry for the sudden email but may I have your advice on soc_camera?

> You can have a look at another driver 
> for a Sharp camera sensor:
> 
> drivers/media/video/rj54n1cb0c.c
> 
> and at its platform glue in arch/sh/boards/mach-kfr2r09/setup.c, there you 
> find
> 
> struct platform_device kfr2r09_camera
> 
> which links to
> 
> struct soc_camera_link rj54n1_link

> > The ARM cpu is made by Renesas.
> 
> Then, perhaps, something similar to
> 
> arch/arm/mach-shmobile/board-ap4evb.c

Thank you for your suggestion, I was able to bind my driver
with soc_camera(I believe...).

I attached my draft driver files at the end of this email
for any suggestions.

In the beginning, I would like to explain the fundamental 
information.

1) 2 megapixel camera module is connected to 
   the ARM board, Renesas ag5evm, through I2C.
    arch/arm/mach-shmobile/board-ag5evm.c
2) The camera module is connected to CEU on the ag5evm.
3) I followed your instruction to bind the camera
   sensor driver to soc_camera as attached and 
   builds and boots fine.
4) I have not received the data sheet from the vender 
   for the camera yet ;)
5) But I have the prototype board on my hand.
6) I can not implement the details of the driver without
   the data sheet but would like to start implement the 
   outline, so I could save my time while I am waiting 
   for the data sheet.

Also,
I would like to know, if I need to bind to 
   sh_mobile_ceu_camera.c
too, and how, because the camera is connected to CEU.
(I never knew the word CEU until I started to work with
this project...)

Thank you and best regards,

Akira

------------- rj65na20.c
/*
 *  Copyright (C) 2011 Nomovok Ltd.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; version 2 of the License.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <linux/slab.h>
#include <linux/delay.h>
#include <linux/i2c.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/videodev2.h>
#include <media/v4l2-device.h>
#include <media/soc_camera.h>
#include <media/soc_mediabus.h>

MODULE_DESCRIPTION("Sharp RJ65NA20 sensor driver");
MODULE_AUTHOR("Akira Tsukamoto <akira.tsukamoto@nomovok.com>");
MODULE_LICENSE("GPL");

static int debug;
module_param(debug, int, 1);
MODULE_PARM_DESC(debug, "Debug level (0-1)");

/* 
 * TODO This should go inside the following
 * include/media/v4l2-chip-ident.h
 */
/* Sharp RJ65NA20, 0x???? = ?? */
#define V4L2_IDENT_RJ65NA20	00


#define I2C_WRITE_BYTES		2
#define I2C_READ_BYTES		1

#define R00_RJ65NA20_CHIP_VERSION	0x00 /* TODO fix me when after receiving data sheet */
#define R00				0x00
#define R01				0x01

#define RJ65NA20_VERSION		0x01

#define RJ65NA20_WIDTH			1600
#define RJ65NA20_HEIGHT			1200

/* supported controls */
static struct v4l2_queryctrl rj65na20_qctrl[] = { /* TODO fix me when after receiving data sheet */
	{
		.id      = V4L2_CID_AUTO_WHITE_BALANCE,
		.type    = V4L2_CTRL_TYPE_BOOLEAN,
		.name    = "Auto White Balance",
		.minimum = 0,
		.maximum = 1,
		.step    = 1,
		.default_value = 1,
		.flags = 0,
	}, {
		.id	 = V4L2_CID_EXPOSURE_AUTO,
		.type    = V4L2_CTRL_TYPE_INTEGER,
		.name    = "Auto Exposure",
		.minimum = 0,
		.maximum = 1,
		.step    = 1,
		.default_value  = 1,
		.flags = 0,
	}, {
		.id      = V4L2_CID_HFLIP,
		.type    = V4L2_CTRL_TYPE_BOOLEAN,
		.name    = "Mirror",
		.minimum = 0,
		.maximum = 1,
		.step    = 1,
		.default_value = 0,
		.flags = 0,
	}, {
		.id      = V4L2_CID_VFLIP,
		.type    = V4L2_CTRL_TYPE_BOOLEAN,
		.name    = "Vflip",
		.minimum = 0,
		.maximum = 1,
		.step    = 1,
		.default_value = 0,
		.flags = 0,
	}, {
	}
};

struct rj65na20 {
	struct v4l2_subdev sd;
	unsigned int width, height;
	unsigned int autowhitebalance:1;
	unsigned int autoexposure:1;
	unsigned int hflip:1;
	unsigned int vflip:1;
};

static inline struct rj65na20 *to_rj65na20(struct v4l2_subdev *sd)
{
	return container_of(sd, struct rj65na20, sd);
}

static u8 rj65na20_read(struct v4l2_subdev *sd, u8 addr)
{
	struct i2c_client *c = v4l2_get_subdevdata(sd);
	u8 buffer, val;
	int rc;

	rc = i2c_master_send(c, &addr, I2C_READ_BYTES);
	if (rc != I2C_READ_BYTES)
		v4l2_dbg(0, debug, sd,
			"i2c i/o error: rc == %d (should be %d)\n",
			rc, I2C_READ_BYTES);

	msleep(10); /* TODO specify correct value later */

	rc = i2c_master_recv(c, (char *)&buffer, I2C_READ_BYTES);
	if (rc != I2C_READ_BYTES)
		v4l2_dbg(0, debug, sd,
			"i2c i/o error: rc == %d (should be %d)\n",
		rc, I2C_READ_BYTES);

	val = buffer;

	v4l2_dbg(2, debug, sd, "rj65na20: read 0x%02x = 0x%02x\n", addr, val);

	return val;
}

static void rj65na20_write(struct v4l2_subdev *sd, u8 addr, u8 value)
{
	struct i2c_client *c = v4l2_get_subdevdata(sd);
	u8 buffer[I2C_WRITE_BYTES];
	int rc;

	buffer[0] = addr;
	buffer[1] = value;

	v4l2_dbg(2, debug, sd,
		 "rj65na20: writing 0x%02x 0x%02x\n", addr, value);
	rc = i2c_master_send(c, buffer, I2C_WRITE_BYTES);
	if (rc != I2C_WRITE_BYTES)
		v4l2_dbg(0, debug, sd,
			"i2c i/o error: rc == %d (should be %d)\n",
			rc, I2C_WRITE_BYTES);
}


struct i2c_reg_value {
	u8	reg;
	u8	value;
};

/*
 * Initialization values of registers for the device
 * likly to change on final hardware
 */
#define INIT_REGS_PAGE	0x100
#define INIT_PAGES	22
static const struct i2c_reg_value rj65na20_init_page[][0x100] = {
/* TODO this is dummy values, need to fix it with correct values */
	{
		/* PAGE0 */
		{0x00, 0x00},
		{0xff, 0x00},
	{

	},
};

static void set_resolution(struct v4l2_subdev *sd)
{
	/* TODO fix me when after receiving data sheet */
}

static void set_white_balance(struct v4l2_subdev *sd)
{
	/* TODO fix me when after receiving data sheet */
}

static void set_exposure(struct v4l2_subdev *sd)
{
	/* TODO fix me when after receiving data sheet */
}

static void set_flip(struct v4l2_subdev *sd)
{
	/* TODO fix me when after receiving data sheet */
}

static int rj65na20_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
{
	struct rj65na20 *core = to_rj65na20(sd);

	v4l2_dbg(1, debug, sd, "g_ctrl called\n");

	switch (ctrl->id) {
	case V4L2_CID_AUTO_WHITE_BALANCE:
		ctrl->value = core->autowhitebalance;
		return 0;
	case V4L2_CID_EXPOSURE_AUTO:
		ctrl->value = core->autoexposure;
		return 0;
	case V4L2_CID_HFLIP:
		ctrl->value = core->hflip ? 1 : 0;
		return 0;
	case V4L2_CID_VFLIP:
		ctrl->value = core->vflip ? 1 : 0;
		return 0;
	}

	return -EINVAL;
}

static int rj65na20_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
{
	struct rj65na20 *core = to_rj65na20(sd);
	u8 i, n;
	int ret = -EINVAL;

	n = ARRAY_SIZE(rj65na20_qctrl);

	/* varify args */
	for (i = 0; i < n; i++) {
		if (ctrl->id != rj65na20_qctrl[i].id)
			continue;
		if (ctrl->value < rj65na20_qctrl[i].minimum ||
		    ctrl->value > rj65na20_qctrl[i].maximum)
			return -ERANGE;
		v4l2_dbg(1, debug, sd, "s_ctrl: id=%d, value=%d\n",
					ctrl->id, ctrl->value);
	}

	switch (ctrl->id) {
	case V4L2_CID_AUTO_WHITE_BALANCE:
		core->autowhitebalance = ctrl->value;
		set_white_balance(sd);
		return 0;
	case V4L2_CID_EXPOSURE_AUTO:
		core->autoexposure = ctrl->value;
		set_exposure(sd);
		return 0;
	case V4L2_CID_HFLIP:
		core->hflip = ctrl->value;
		set_flip(sd);
		return 0;
	case V4L2_CID_VFLIP:
		core->vflip = ctrl->value;
		set_flip(sd);
		return 0;
	default:
		return -EINVAL;
	}

	return ret;
}

#if 0 /* TODO does the camera need to specify colorspace? */
static int rj65na20_try_fmt(struct v4l2_subdev *sd,
				struct v4l2_mbus_framefmt *mf)
{
	/* TODO fix me when after receiving data sheet */
	const struct rj65na20_datafmt *fmt = rj65na20_find_datafmt(mf->code);

	v4l2_dbg(1, debug, sd, "rj65na20_try_fmt called: %u\n", mf->code);

	if (!fmt) {
		mf->code        = rj65na20_colour_fmts[0].code;
		mf->colorspace  = rj65na20_colour_fmts[0].colorspace;
	}

	mf->width       = RJ65NA20_WIDTH;
	mf->height      = RJ65NA20_HEIGHT;
	mf->field	= V4L2_FIELD_NONE;

	return 0;
}

static int rj65na20_s_fmt(struct v4l2_subdev *sd,
			struct v4l2_mbus_framefmt *mf)
{
	/* TODO fix me when after receiving data sheet */
	struct rj65na20 *core = to_rj65na20(sd);

	v4l2_dbg(1, debug, sd, "rj65na20_s_fmt called: %u\n", mf->code);

	if (!rj65na20_find_datafmt(mf->code))
		return -EINVAL;

	rj65na20_try_fmt(sd, mf);

	core->fmt = rj65na20_find_datafmt(mf->code);

	return 0;
}

static int rj65na20_g_fmt(struct v4l2_subdev *sd,
			struct v4l2_mbus_framefmt *mf)
{
	/* TODO fix me when after receiving data sheet */
	struct rj65na20 *core = to_rj65na20(sd);

	const struct rj65na20_datafmt *fmt = core->fmt;

	mf->code        = fmt->code;
	mf->colorspace  = fmt->colorspace;
	mf->width       = RJ65NA20_WIDTH;
	mf->height      = RJ65NA20_HEIGHT;
	mf->field	= V4L2_FIELD_NONE;

	return 0;
}
#endif 

static int rj65na20_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
{
	/* TODO fix me when after receiving data sheet */
	struct v4l2_rect *rect = &a->c;

	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
	rect->top	= 0;
	rect->left	= 0;
	rect->width	= RJ65NA20_WIDTH;
	rect->height	= RJ65NA20_HEIGHT;

	return 0;
}

static int rj65na20_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
{
	/* TODO fix me when after receiving data sheet */
	a->bounds.left                  = 0;
	a->bounds.top                   = 0;
	a->bounds.width                 = RJ65NA20_WIDTH;
	a->bounds.height                = RJ65NA20_HEIGHT;
	a->defrect                      = a->bounds;
	a->type                         = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	a->pixelaspect.numerator        = 1;
	a->pixelaspect.denominator      = 1;

	return 0;
}

static int rj65na20_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
				enum v4l2_mbus_pixelcode *code)
{
	/* TODO fix me when after receiving data sheet */
	/*
	if ((unsigned int)index >= ARRAY_SIZE(rj65na20_colour_fmts))
		return -EINVAL;

	*code = rj65na20_colour_fmts[index].code;
	*/
	return 0;
}

static int rj65na20_s_stream(struct v4l2_subdev *sd, int enable)
{
	/* TODO fix me when after receiving data sheet */
//	struct i2c_client *client = v4l2_get_subdevdata(sd);
//	return rj65na20_write(client, MODE_SELECT, !!enable);
	return 0;
}

static int rj65na20_g_chip_ident(struct v4l2_subdev *sd,
			       struct v4l2_dbg_chip_ident *id)
{
	struct i2c_client *client = v4l2_get_subdevdata(sd);

	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
		return -EINVAL;

	if (id->match.addr != client->addr)
		return -ENODEV;

	id->ident	= V4L2_IDENT_RJ65NA20;
	id->revision	= 0;

	return 0;
}

static struct v4l2_subdev_video_ops rj65na20_subdev_video_ops = {
	.s_stream	= rj65na20_s_stream,
//	.s_mbus_fmt	= rj65na20_s_fmt,
//	.g_mbus_fmt	= rj65na20_g_fmt,
//	.try_mbus_fmt	= rj65na20_try_fmt,
	.enum_mbus_fmt	= rj65na20_enum_fmt,
	.g_crop		= rj65na20_g_crop,
	.cropcap	= rj65na20_cropcap,
};

static struct v4l2_subdev_core_ops rj65na20_subdev_core_ops = {
	.g_chip_ident	= rj65na20_g_chip_ident,
};

static struct v4l2_subdev_ops rj65na20_subdev_ops = {
	.core	= &rj65na20_subdev_core_ops,
	.video	= &rj65na20_subdev_video_ops,
};

/* The camera is connected through CEU */
static unsigned long rj65na20_query_bus_param(struct soc_camera_device *icd)
{
	return 0;
}

static int rj65na20_set_bus_param(struct soc_camera_device *icd,
				  unsigned long flags)
{
	return -1;
}

static struct soc_camera_ops rj65na20_ops = {
	.query_bus_param	= rj65na20_query_bus_param,
	.set_bus_param		= rj65na20_set_bus_param,
};

/****************************************************************************
                        I2C Client & Driver
 ****************************************************************************/

/*
 * This is i2c testing purpose, 
 * this function will be removed from final code
 */
static int rj65na20_probe_test(struct i2c_client *c,
				const struct i2c_device_id *id)
{
	struct rj65na20 *core;
	struct v4l2_subdev *sd;
	int rc;
	u8 addr, value, read;
	u8 write[I2C_WRITE_BYTES];

	printk("APE5R: 2M camera probe: start\n");

	sd = &core->sd;

	/* Check if the adapter supports the needed features */
	if (!i2c_check_functionality(c->adapter,
	     I2C_FUNC_SMBUS_READ_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
		return -EIO;

	addr = 0x03;
	value = 0x01;

	printk("APE5R: 2M camera probe: write before\n");

	write[0] = addr;
	write[1] = value;

	v4l2_dbg(2, debug, sd,
		 "rj65na20: writing 0x%02x 0x%04x\n", addr, value);
	rc = i2c_master_send(c, write, I2C_WRITE_BYTES);
	if (rc != I2C_WRITE_BYTES)
		v4l2_dbg(0, debug, sd,
			"i2c i/o error: rc == %d (should be %d)\n", 
			rc, I2C_WRITE_BYTES);

	printk("APE5R: 2M camera probe: write after\n");

	rc = i2c_master_send(c, &addr, I2C_READ_BYTES);
	if (rc != I2C_READ_BYTES)
		v4l2_dbg(0, debug, sd,
			"i2c i/o error: rc == %d (should be %d)\n", 
			rc, I2C_READ_BYTES);

	msleep(10);

	printk("APE5R: 2M camera probe: read send addr\n");

	rc = i2c_master_recv(c, (char *)&read, I2C_READ_BYTES);
	if (rc != I2C_READ_BYTES)
		v4l2_dbg(0, debug, sd,
			"i2c i/o error: rc == %d (should be %d)\n", 
			rc, I2C_READ_BYTES);

	printk("APE5R: 2M camera probe: read=0x%02X\n", read);

	printk("APE5R: 2M camera probe: end\n");

//	BUG_ON(__func__); /* halt the testing */

	return 0;
}

static int rj65na20_probe(struct i2c_client *c,
				const struct i2c_device_id *id)
{
	u8 version;
	struct rj65na20 *core;
	struct v4l2_subdev *sd;
	struct soc_camera_device *icd = c->dev.platform_data;
	struct soc_camera_link *icl;

	if (!icd) {
		dev_err(&c->dev, "rj65na20: missing soc-camera data!\n");
		return -EINVAL;
	}

	icl = to_soc_camera_link(icd);
	if (!icl) {
		dev_err(&c->dev, "rj65na20: missing platform data!\n");
		return -EINVAL;
	}

	/* Check if the adapter supports the needed i2c features */
	if (!i2c_check_functionality(c->adapter,
	     I2C_FUNC_SMBUS_READ_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
		return -EIO;

	core = kzalloc(sizeof(struct rj65na20), GFP_KERNEL);
	if (!core)
		return -ENOMEM;

	sd = &core->sd;
	v4l2_i2c_subdev_init(sd, c, &rj65na20_subdev_ops);

	/* Check if the sensor is really a Sharp RJ65NA20 */
	version = rj65na20_read(sd, 0x01);
	if ((version != RJ65NA20_VERSION)) {
		v4l2_info(sd, "*** unknown camera chip detected (0x%02x).\n",
			  version);
		kfree(core);
		return -EINVAL;
	}

	icd->ops     = &rj65na20_ops;

	core->width  = RJ65NA20_WIDTH;
	core->height = RJ65NA20_HEIGHT;

	v4l_info(c, "chip found @ 0x%02x (%s - chip version 0x%04x)\n",
		 c->addr << 1, c->adapter->name, version);

	return 0;
}

static int rj65na20_remove(struct i2c_client *c)
{
	struct v4l2_subdev *sd = i2c_get_clientdata(c);

	v4l2_dbg(1, debug, sd,
		"rj65na20.c: removing rj65na20 adapter on address 0x%x\n",
		c->addr << 1);

	v4l2_device_unregister_subdev(sd);

	kfree(to_rj65na20(sd));

	return 0;
}

/* ----------------------------------------------------------------------- */

static const struct i2c_device_id rj65na20_id[] = {
	{ "rj65na20", 0 },
	{ }
};

MODULE_DEVICE_TABLE(i2c, rj65na20_id);

static struct i2c_driver rj65na20_driver = {
	.driver = {
		.owner  = THIS_MODULE,
		.name   = "rj65na20",
	},
	.probe          = rj65na20_probe_test,
	.remove         = rj65na20_remove,
	.id_table       = rj65na20_id,
};

static __init int init_rj65na20(void)
{
	return i2c_add_driver(&rj65na20_driver);
}

static __exit void exit_rj65na20(void)
{
	i2c_del_driver(&rj65na20_driver);
}

module_init(init_rj65na20);
module_exit(exit_rj65na20);

EOF (rj65na20.c)
-----------------------------

--- linux_kernel_bsp/arch/arm/mach-shmobile/board-ag5evm.c	2011-03-22 12:30:14.000000000 +0900
+++ linux_kernel/arch/arm/mach-shmobile/board-ag5evm.c	2011-04-18 14:39:20.000000000 +0900
@@ -59,6 +59,7 @@
 
 #include <sound/sh_fsi.h>
 #include <video/sh_mobile_lcdc.h>
+#include <media/soc_camera.h>
 
 static struct r8a66597_platdata usb_host_data = {
 	.on_chip	= 1,
@@ -317,11 +318,38 @@ static struct platform_device fsi_device
 	},
 };
 
+static struct i2c_board_info rj65na20_info = {
+	I2C_BOARD_INFO("rj65na20", 0x40),
+};
+
+struct soc_camera_link rj65na20_link = {
+	.bus_id         = 0,
+	.board_info     = &rj65na20_info,
+	.i2c_adapter_id = 0,
+	.module_name    = "rj65na20",
+};
+
+static struct platform_device rj65na20_camera = {
+	.name	= "soc-camera-pdrv-2M",
+	.id	= 0,
+	.dev	= {
+		.platform_data = &rj65na20_link,
+	},
+};
+
 static struct i2c_board_info i2c0_devices[] = {
 	{
 		I2C_BOARD_INFO("ag5evm_ts", 0x20),
 		.irq	= pint2irq(12),	/* PINTC3 */
 	},
+	/* 2M camera */
+	{
+		I2C_BOARD_INFO("rj65na20", 0x40),
+	},
 };
 
 static struct i2c_board_info i2c1_devices[] = {
@@ -548,6 +576,8 @@ static struct platform_device *ag5evm_de
 
 	&usb_mass_storage_device,
 	&android_usb_device,
+
+	&rj65na20_camera,
 };
 
 static struct map_desc ag5evm_io_desc[] __initdata = {
@@ -748,6 +778,7 @@ static void __init ag5evm_init(void)
 	struct clk *sub_clk = clk_get(NULL, "sub_clk");
 	struct clk *extal2_clk = clk_get(NULL, "extal2");
 	struct clk *fsia_clk = clk_get(NULL, "fsia_clk");
+	struct clk *vck1_clk = clk_get(NULL, "vck1_clk");
 	clk_set_parent(sub_clk, extal2_clk);
 
 	__raw_writel(__raw_readl(SUBCKCR) & ~(1<<9), SUBCKCR);
@@ -853,6 +884,43 @@ static void __init ag5evm_init(void)
 	__raw_writel(0x2a8b9111, DSI1PHYCR);
 	clk_enable(clk_get(NULL, "dsi-tx"));

+	/* 2M camera */
+	gpio_request(GPIO_PORT44, NULL);
+	gpio_direction_output(GPIO_PORT44, 0);
+	udelay(10);
+	gpio_set_value(GPIO_PORT44, 1);
+
 	/* Unreset LCD Panel */
 	gpio_request(GPIO_PORT217, NULL);
 	gpio_direction_output(GPIO_PORT217, 0);

-- 
Akira Tsukamoto


Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43396 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab3GOKKG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 06:10:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1UyfjH-0000GY-9W
	for linux-media@vger.kernel.org; Mon, 15 Jul 2013 12:10:03 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Jul 2013 12:10:03 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Jul 2013 12:10:03 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: implement ov3640 driver using subdev-api with omap3-isp
Date: Mon, 15 Jul 2013 09:23:19 +0000 (UTC)
Message-ID: <loom.20130715T104602-373@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am working with a gumstix overo board connected with a e-con-systems 
camera module using a ov3640 camera sensor.

Along with the board I got a camera driver 
(https://github.com/scottellis/econ-cam-driver) 
which can be used with linux 
kernel 2.6.34, but I want to use the camera 
along with the linux kernel 3.5.

So I tried to implement the driver into the kernel sources by 
referring to a existing drivers like /driver/media/video/ov9640.c 
and /driver/media/video/mt9v032.c.

The old driver has an isp implementation integrated 
and it registers itself once as a video device. 
So the application which is going to use the camera 
sensor just needs to open the right video device 
and by calling ioctl the corresponding functions will be called. 

By going through the linux 3.5 kernel sources 
I found out that the omap3-isp registers itself 
as an video-device and should support sensors using the
v4l2-subdev interface. 

So am I right when I think that I just need to 
add the ov3640 subdev to the isp_v4l2_subdevs_group 
in the board-overo.c file and then just open the 
video device of the isp to use it via application (ioctl)?

I read an article which told me that I need to use the 
v4l2_subdev_pad_ops to interact from isp with 
the ov3640 subdev, but it does not work. 
I don't know what I am doing wrong.

Is there already an implemenation of the ov3640 
using subdev-api which I couldn't find 
or can someone give me a hint what I need to do to get the 
sensor with the isp working?

My Code Snippet board-overo.c:

#define LM3553_SLAVE_ADDRESS	0x53
#define OV3640_I2C_ADDR		(0x78 >> 1)
int omap3evm_ov3640_platform_data;
int lm3553_platform_data;

static struct i2c_board_info omap3_i2c_boardinfo_ov3640 = {
		I2C_BOARD_INFO("ov3640", OV3640_I2C_ADDR),
		.platform_data = &omap3evm_ov3640_platform_data,
};

static struct i2c_board_info omap3_i2c_boardinfo_lm3553 = {
		I2C_BOARD_INFO("lm3553",LM3553_SLAVE_ADDRESS),
		.platform_data = &lm3553_platform_data,
};

static struct i2c_board_info mt9v032_i2c_device = {
	I2C_BOARD_INFO("mt9v032", MT9V032_I2C_ADDR),
	.platform_data = &mt9v032_platform_data,
};

/*static struct isp_subdev_i2c_board_info mt9v032_subdevs[] = {
	{
		.board_info = &mt9v032_i2c_device,
		.i2c_adapter_id = MT9V032_I2C_BUS_NUM,
	},
	{ NULL, 0, },
};*/

static struct isp_subdev_i2c_board_info overo_subdevs[] = {
	/*{
		.board_info = &mt9v032_i2c_device,
		.i2c_adapter_id = MT9V032_I2C_BUS_NUM,
	},*/
	{
		.board_info = &omap3_i2c_boardinfo_ov3640,
		.i2c_adapter_id = MT9V032_I2C_BUS_NUM,
	},
	{ NULL, 0, },
};

static struct isp_v4l2_subdevs_group overo_camera_subdevs[] = {
	{
		//.subdevs = mt9v032_subdevs,
		.subdevs = overo_subdevs,
		.interface = ISP_INTERFACE_PARALLEL,
		.bus = {
				.parallel = {
					.data_lane_shift = 0,
					.clk_pol = 0,
					.bridge = ISPCTRL_PAR_BRIDGE_DISABLE,
				}
		},
	},
	{ NULL, 0, },
};

static struct isp_platform_data overo_isp_platform_data = {
	.subdevs = overo_camera_subdevs,
};

static int __init overo_camera_init(void)
{
       return omap3_init_camera(&overo_isp_platform_data);
}



My Code Snippet ov3640.c:

static struct v4l2_subdev_pad_ops ov3640_subdev_pad_ops = {
	.enum_mbus_code = test2,
	.enum_frame_size = test2,
	.get_fmt = test2,
	.set_fmt = test2,
	.get_crop = test2,
	.set_crop = test2,
};

static struct v4l2_subdev_core_ops ov3640_subdev_core_ops = {
	.g_chip_ident	= test2,
	.g_ctrl		= test2,
	.s_ctrl		= test2,
	//.g_register	= test2,
	//.s_register	= test2,
};

static struct v4l2_subdev_video_ops ov3640_subdev_video_ops = {
	.s_stream	= test2,
	.try_mbus_fmt	= test2,
	.s_mbus_fmt	= test2,
	.g_mbus_fmt	= test2,
	.enum_mbus_fmt	= test2,
	.enum_framesizes = test2,
	.enum_frameintervals = test2,
	.g_parm = test2,
	.s_parm = test2,
};

static struct v4l2_subdev_sensor_ops ov3640_subdev_sensor_ops = {
	.g_skip_frames	= test2,
	//.g_interface_parms = test2,
};

static struct v4l2_subdev_ops ov3640_subdev_ops = {
	.core	= &ov3640_subdev_core_ops,
	.video	= &ov3640_subdev_video_ops,
	.sensor	= &ov3640_subdev_sensor_ops,
	.pad	= &ov3640_subdev_pad_ops,
};

/*static struct soc_camera_ops ov3640_ops = {

	.set_bus_param		= test2,

	.query_bus_param	= test2,

	.controls		= ov3640_controls,

	.num_controls		= ARRAY_SIZE(ov3640_controls),

};*/

static int mt9v032_registered(struct v4l2_subdev *subdev)
{
	printk("TOM OPEN NEW ##########\n");
	return 0;
}

static int mt9v032_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
{
	printk("TOM OPEN NEW ##########\n");
	return 0;
}

static int mt9v032_close(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
{
	printk("TOM CLOSE NEW ##########\n");
	return 0;
	//return mt9v032_set_power(subdev, 0);
}

static const struct v4l2_subdev_internal_ops mt9v032_subdev_internal_ops = {
	.registered = mt9v032_registered,
	.open = mt9v032_open,
	.close = mt9v032_close,
};


static INT32 ov3640_probe(struct i2c_client *client, const struct
i2c_device_id *id)
{
	FNRESLT ret_val;
	cam_data *cam;
	struct soc_camera_link *icl;
	struct v4l2_subdev *sd;

	int ret;

	cam = kzalloc(sizeof(cam_data), GFP_KERNEL);

	if (!cam)
		return -ENOMEM;
	
	ret_val	= v4l2_base_struct(&cam,SET_ADDRESS);
	if(CHECK_IN_FAIL_LIMIT(ret_val))
	{
		printk(KERN_ERR "Failed to register the camera device\n");
		//TRACE_ERR_AND_RET(FAIL);
	}

	ret_val	= init_phy_mem();
	/*if(CHECK_IN_FAIL_LIMIT(ret_val))
	{
		goto exit;
	}*/

	if (!i2c_check_functionality(client->adapter,
				     I2C_FUNC_SMBUS_WORD_DATA)) {
		dev_warn(&client->adapter->dev,
			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
		return -EIO;
	}
	
	sd = &cam->subdev;
	cam->cam_sensor.client = client;

	v4l2_i2c_subdev_init(sd, client, &ov3640_subdev_ops);
	printk("TOM SUBDEV NAME: %s ##########\n",sd->name);
	sd->internal_ops = &mt9v032_subdev_internal_ops;

	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;

	cam->pad.flags = MEDIA_PAD_FL_SOURCE;

	ret = media_entity_init(&sd->entity, 1, &cam->pad, 0);

	printk("TOM OV3640 PROBE PAD %08x ##########\n",&cam->pad);

/*********************************************************/
	gpio_request(RESET_GPIO,"ov3640");
	gpio_request(STANDBY_GPIO,"ov3640");

	gpio_direction_output(RESET_GPIO, true);
	gpio_direction_output(STANDBY_GPIO, true);
	/* Turn ON Omnivision sensor */
	gpio_set_value(RESET_GPIO, ENABLE);
	gpio_set_value(STANDBY_GPIO, DISABLE);
	udelay(100);

	/* RESET Omnivision sensor */
	gpio_set_value(RESET_GPIO, DISABLE);
	udelay(100);
	gpio_set_value(RESET_GPIO, ENABLE);

	udelay(100);
/*********************************************************/
	//ret = ov3640_video_probe(client);

	if (ret) {

		//icd->ops = NULL;

		kfree(cam);
	}

	ret_val	= ov3640_init(cam);
	if(CHECK_IN_FAIL_LIMIT(ret_val))
	{
		return ret_val;
	}

	return 0;
}

static const struct i2c_device_id ov3640_id[] = {
	{ "ov3640", 0 },
	{ }
};
MODULE_DEVICE_TABLE(i2c, ov3640_id);

static struct i2c_driver ov3640_driver = {
	.class		= I2C_CLASS_HWMON,
	.driver = {
		.owner	= THIS_MODULE,
		.name	= "ov3640",
	},
	.probe		= ov3640_probe,
	.remove		= __exit_p(ov3640_remove),
	.id_table	= ov3640_id,
};

Regards, Tom



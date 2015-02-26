Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58080 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753205AbbBZATc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 19:19:32 -0500
Message-ID: <54EE666C.8080501@iki.fi>
Date: Thu, 26 Feb 2015 02:18:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] media: i2c: add support for omnivision's ov2659 sensor
References: <1424532167-11212-1-git-send-email-prabhakar.csengg@gmail.com> <20150224110951.GE6539@valkosipuli.retiisi.org.uk> <CA+V-a8uyLT59kies1beV3K+M5mgNr=Q3FcYP12wKraARS+nW+w@mail.gmail.com>
In-Reply-To: <CA+V-a8uyLT59kies1beV3K+M5mgNr=Q3FcYP12wKraARS+nW+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Lad, Prabhakar wrote:
...
>>> +
>>> +For further reading on port node refer to
>>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>>> +
>>> +Example:
>>> +
>>> +     i2c0@1c22000 {
>>> +             ...
>>> +             ...
>>> +              ov2659@30 {
>>> +                     compatible = "ovti,ov2659";
>>> +                     reg = <0x30>;
>>> +
>>> +                     clocks = <&clk_ov2659>;
>>> +                     clock-names = "xvclk";
>>> +
>>> +                     assigned-clocks = <&clk_ov2659>;
>>> +                     assigned-clock-rates = <12000000>;
>>
>> These don't quite match with the documentation above.
>>
> These are the standard clock properties, which I thought could be ignored
> for documenting ?

I think you still should say the device / driver needs or can use them.

>>> +
>>> +                     port {
>>> +                             ov2659_0: endpoint {
>>> +                                     remote-endpoint = <&vpfe_ep>;
>>> +                                     xvclk-frequency = <12000000>;
>>> +                             };
>>> +                     };
>>> +             };
>>> +             ...
>>> +     };
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index becb274..1126c9e 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -8758,6 +8758,16 @@ T:     git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
>>>  S:   Maintained
>>>  F:   drivers/media/platform/am437x/
>>>
>>> +OV2659 OMNIVISION SENSOR DRIVER
>>> +M:   Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>> +L:   linux-media@vger.kernel.org
>>> +W:   http://linuxtv.org/
>>> +Q:   http://patchwork.linuxtv.org/project/linux-media/list/
>>> +T:   git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
>>> +S:   Maintained
>>> +F:   drivers/media/i2c/ov2659.c
>>> +F:   include/media/ov2659.h
>>> +
>>>  SIS 190 ETHERNET DRIVER
>>>  M:   Francois Romieu <romieu@fr.zoreil.com>
>>>  L:   netdev@vger.kernel.org
>>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>>> index da58c9b..6f30ea7 100644
>>> --- a/drivers/media/i2c/Kconfig
>>> +++ b/drivers/media/i2c/Kconfig
>>> @@ -466,6 +466,17 @@ config VIDEO_APTINA_PLL
>>>  config VIDEO_SMIAPP_PLL
>>>       tristate
>>>
>>> +config VIDEO_OV2659
>>> +     tristate "OmniVision OV2659 sensor support"
>>> +     depends on VIDEO_V4L2 && I2C
>>> +     depends on MEDIA_CAMERA_SUPPORT

Please add VIDEO_V4L2_SUBDEV_API .

>>> +     ---help---
>>> +       This is a Video4Linux2 sensor-level driver for the OmniVision
>>> +       OV2659 camera.
>>> +
>>> +       To compile this driver as a module, choose M here: the
>>> +       module will be called ov2659.
>>> +
>>>  config VIDEO_OV7640
>>>       tristate "OmniVision OV7640 sensor support"
>>>       depends on I2C && VIDEO_V4L2
>>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>>> index 98589001..f165fae 100644
>>> --- a/drivers/media/i2c/Makefile
>>> +++ b/drivers/media/i2c/Makefile
>>> @@ -77,3 +77,4 @@ obj-$(CONFIG_VIDEO_SMIAPP_PLL)      += smiapp-pll.o
>>>  obj-$(CONFIG_VIDEO_AK881X)           += ak881x.o
>>>  obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
>>>  obj-$(CONFIG_VIDEO_ML86V7667)        += ml86v7667.o
>>> +obj-$(CONFIG_VIDEO_OV2659)   += ov2659.o
>>> diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
>>> new file mode 100644
>>> index 0000000..e79298b
>>> --- /dev/null
>>> +++ b/drivers/media/i2c/ov2659.c
...
>>> +
>>> +struct sensor_register {
>>> +     u16 addr;
>>> +     u8 value;
>>> +};
>>> +
>>> +struct ov2659_framesize {
>>> +     u16 width;
>>> +     u16 height;
>>> +     u16 max_exp_lines;
>>> +     const struct sensor_register *regs;
>>> +};
>>> +
>>> +struct ov2659_pll_ctrl {
>>> +     u8 ctrl1;
>>> +     u8 ctrl2;
>>> +     u8 ctrl3;
>>> +};
>>> +
>>> +struct ov2659_pixfmt {
>>> +     u32 code;
>>> +     u32 colorspace;
>>> +     /* Output format Register Value (REG_FORMAT_CTRL00) */
>>> +     struct sensor_register *format_ctrl_regs;
>>> +};
>>> +
>>> +struct pll_ctrl_reg {
>>> +     unsigned int div;
>>> +     unsigned char reg;
>>> +};
>>> +
>>> +struct ov2659 {
>>> +     struct v4l2_subdev sd;
>>> +     struct media_pad pad;
>>> +     enum v4l2_mbus_type bus_type;
>>> +     struct v4l2_mbus_framefmt format;
>>> +     const struct ov2659_platform_data *pdata;
>>> +     struct mutex lock;
>>> +     struct i2c_client *client;
>>> +     const struct ov2659_framesize *frame_size;
>>> +     struct sensor_register *format_ctrl_regs;
>>> +     struct ov2659_pll_ctrl pll;
>>> +     int streaming;
>>> +};
>>> +
>>> +static const struct sensor_register ov2659_init_regs[] = {
>>> +     {0x3000, 0x03}, /* IO CTRL */
>>> +     {0x3001, 0xff}, /* IO CTRL */
>>> +     {0x3002, 0xe0}, /* IO CTRL */
>>> +     {0x3633, 0x3d},
>>> +     {0x3620, 0x02},
>>> +     {0x3631, 0x11},
>>> +     {0x3612, 0x04},
>>> +     {0x3630, 0x20},
>>> +     {0x4702, 0x02}, /* DVP Debug mode */
>>> +     {0x370c, 0x34},
>>> +     {0x3004, 0x10}, /* System Divider */
>>> +     {0x3005, 0x22}, /* Pixel clock Multiplier */
>>
>> Do these belong here?
>>
>>> +     {0x3800, 0x00}, /* TIMING */
>>> +     {0x3801, 0x00}, /* TIMING */
>>> +     {0x3802, 0x00}, /* TIMING */
>>> +     {0x3803, 0x00}, /* TIMING */
>>> +     {0x3804, 0x06}, /* TIMING */
>>> +     {0x3805, 0x5f}, /* TIMING */
>>> +     {0x3806, 0x04}, /* TIMING */
>>> +     {0x3807, 0xb7}, /* TIMING */
>>> +     {0x3808, 0x03}, /* Horizontal High Byte */
>>> +     {0x3809, 0x20}, /* Horizontal Low Byte */
>>> +     {0x380a, 0x02}, /* Vertical High Byte */
>>> +     {0x380b, 0x58}, /* Vertical Low Byte */
>>> +     {0x380c, 0x05}, /* TIMING */
>>> +     {0x380d, 0x14}, /* TIMING */
>>> +     {0x380e, 0x02}, /* TIMING */
>>> +     {0x380f, 0x68}, /* TIMING */
>>> +     {0x3811, 0x08}, /* TIMING */
>>> +     {0x3813, 0x02}, /* TIMING */
>>> +     {0x3814, 0x31}, /* TIMING */
>>> +     {0x3815, 0x31}, /* TIMING */
>>> +     {0x3a02, 0x02}, /* AEC */
>>> +     {0x3a03, 0x68}, /* AEC */
>>> +     {0x3a08, 0x00}, /* AEC */
>>> +     {0x3a09, 0x5c}, /* AEC */
>>> +     {0x3a0a, 0x00}, /* AEC */
>>> +     {0x3a0b, 0x4d}, /* AEC */
>>> +     {0x3a0d, 0x08}, /* AEC */
>>> +     {0x3a0e, 0x06}, /* AEC */
>>> +     {0x3a14, 0x02}, /* AEC */
>>> +     {0x3a15, 0x28}, /* AEC */
>>> +     {0x4708, 0x01}, /* DVP */
>>> +     {0x3623, 0x00},
>>> +     {0x3634, 0x76},
>>> +     {0x3701, 0x44},
>>> +     {0x3702, 0x18},
>>> +     {0x3703, 0x24},
>>> +     {0x3704, 0x24},
>>> +     {0x3705, 0x0c},
>>> +     {0x3820, 0x81}, /* TIMING */
>>> +     {0x3821, 0x01}, /* TIMING */
>>> +     {0x370a, 0x52},
>>> +     {0x4608, 0x00}, /* VFIFO */
>>> +     {0x4609, 0x80}, /* VFIFO */
>>> +     {0x4300, 0x30}, /* Format */
>>> +     {0x5086, 0x02},
>>> +     {0x5000, 0xfb}, /* DPC/ISP */
>>> +     {0x5001, 0x1f}, /* ISP */
>>> +     {0x5002, 0x00}, /* ISP */
>>> +     {0x5025, 0x0e}, /* GAMMA */
>>> +     {0x5026, 0x18}, /* GAMMA */
>>> +     {0x5027, 0x34}, /* GAMMA */
>>> +     {0x5028, 0x4c}, /* GAMMA */
>>> +     {0x5029, 0x62}, /* GAMMA */
>>> +     {0x502a, 0x74}, /* GAMMA */
>>> +     {0x502b, 0x85}, /* GAMMA */
>>> +     {0x502c, 0x92}, /* GAMMA */
>>> +     {0x502d, 0x9e}, /* GAMMA */
>>> +     {0x502e, 0xb2}, /* GAMMA */
>>> +     {0x502f, 0xc0}, /* GAMMA */
>>> +     {0x5030, 0xcc}, /* GAMMA */
>>> +     {0x5031, 0xe0}, /* GAMMA */
>>> +     {0x5032, 0xee}, /* GAMMA */
>>> +     {0x5033, 0xf6}, /* GAMMA */
>>> +     {0x5034, 0x11}, /* GAMMA */
>>> +     {0x5070, 0x1c}, /* CMX */
>>> +     {0x5071, 0x5b}, /* CMX */
>>> +     {0x5072, 0x05}, /* CMX */
>>> +     {0x5073, 0x20}, /* CMX */
>>> +     {0x5074, 0x94}, /* CMX */
>>> +     {0x5075, 0xb4}, /* CMX */
>>> +     {0x5076, 0xb4}, /* CMX */
>>> +     {0x5077, 0xaf}, /* CMX */
>>> +     {0x5078, 0x05}, /* CMX */
>>> +     {0x5079, 0x98}, /* CMX */
>>> +     {0x507a, 0x21}, /* CMX */
>>> +     {0x5035, 0x6a}, /* AWB */
>>> +     {0x5036, 0x11}, /* AWB */
>>> +     {0x5037, 0x92}, /* AWB */
>>> +     {0x5038, 0x21}, /* AWB */
>>> +     {0x5039, 0xe1}, /* AWB */
>>> +     {0x503a, 0x01}, /* AWB */
>>> +     {0x503c, 0x05}, /* AWB */
>>> +     {0x503d, 0x08}, /* AWB */
>>> +     {0x503e, 0x08}, /* AWB */
>>> +     {0x503f, 0x64}, /* AWB */
>>> +     {0x5040, 0x58}, /* AWB */
>>> +     {0x5041, 0x2a}, /* AWB */
>>> +     {0x5042, 0xc5}, /* AWB */
>>> +     {0x5043, 0x2e}, /* AWB */
>>> +     {0x5044, 0x3a}, /* AWB */
>>> +     {0x5045, 0x3c}, /* AWB */
>>> +     {0x5046, 0x44}, /* AWB */
>>> +     {0x5047, 0xf8}, /* AWB */
>>> +     {0x5048, 0x08}, /* AWB */
>>> +     {0x5049, 0x70}, /* AWB */
>>> +     {0x504a, 0xf0}, /* AWB */
>>> +     {0x504b, 0xf0}, /* AWB */
>>> +     {0x500c, 0x03}, /* LENC/ISP TOP Debug */
>>> +     {0x500d, 0x20}, /* LENC/ISP TOP Debug */
>>> +     {0x500e, 0x02}, /* LENC/ISP TOP Debug */
>>> +     {0x500f, 0x5c}, /* LENC/ISP TOP Debug */
>>> +     {0x5010, 0x48}, /* LENC/ISP TOP Debug */
>>> +     {0x5011, 0x00}, /* LENC/ISP TOP Debug */
>>> +     {0x5012, 0x66}, /* LENC/ISP TOP Debug */
>>> +     {0x5013, 0x03}, /* LENC/ISP TOP Debug */
>>> +     {0x5014, 0x30}, /* LENC/ISP TOP Debug */
>>> +     {0x5015, 0x02}, /* LENC/ISP TOP Debug */
>>> +     {0x5016, 0x7c}, /* LENC/ISP TOP Debug */
>>> +     {0x5017, 0x40}, /* LENC/ISP TOP Debug */
>>> +     {0x5018, 0x00}, /* LENC/ISP TOP Debug */
>>> +     {0x5019, 0x66}, /* LENC/ISP TOP Debug */
>>> +     {0x501a, 0x03}, /* LENC/ISP TOP Debug */
>>> +     {0x501b, 0x10}, /* LENC/ISP TOP Debug */
>>> +     {0x501c, 0x02}, /* LENC/ISP TOP Debug */
>>> +     {0x501d, 0x7c}, /* LENC/ISP TOP Debug */
>>> +     {0x501e, 0x3a}, /* LENC/ISP TOP Debug */
>>> +     {0x501f, 0x00}, /* LENC/ISP TOP Debug */
>>> +     {0x5020, 0x66}, /* LENC/ISP TOP Debug */
>>> +     {0x506e, 0x44}, /* CIP/DNS */
>>> +     {0x5064, 0x08}, /* CIP/DNS */
>>> +     {0x5065, 0x10}, /* CIP/DNS */
>>> +     {0x5066, 0x12}, /* CIP/DNS */
>>> +     {0x5067, 0x02}, /* CIP/DNS */
>>> +     {0x506c, 0x08}, /* CIP/DNS */
>>> +     {0x506d, 0x10}, /* CIP/DNS */
>>> +     {0x506f, 0xa6}, /* CIP/DNS */
>>> +     {0x5068, 0x08}, /* CIP/DNS */
>>> +     {0x5069, 0x10}, /* CIP/DNS */
>>> +     {0x506a, 0x04}, /* CIP/DNS */
>>> +     {0x506b, 0x12}, /* CIP/DNS */
>>> +     {0x507e, 0x40}, /* SDE */
>>> +     {0x507f, 0x20}, /* SDE */
>>> +     {0x507b, 0x02}, /* SDE */
>>> +     {0x507a, 0x01}, /* CMX/SDE */
>>> +     {0x5084, 0x0c}, /* SDE */
>>> +     {0x5085, 0x3e}, /* SDE */
>>> +     {0x5005, 0x80}, /* ISP TOP Debug */
>>> +     {0x3a0f, 0x30}, /* AEC */
>>> +     {0x3a10, 0x28}, /* AEC */
>>> +     {0x3a1b, 0x32}, /* AEC */
>>> +     {0x3a1e, 0x26}, /* AEC */
>>> +     {0x3a11, 0x60}, /* AEC */
>>> +     {0x3a1f, 0x14}, /* AEC */
>>> +     {0x5060, 0x69}, /* Y AVG */
>>> +     {0x5061, 0x7d}, /* Y AVG */
>>> +     {0x5062, 0x7d}, /* Y AVG */
>>> +     {0x5063, 0x69}, /* Y AVG */
>>> +     {0x0000, 0x00}
>>> +};

These register lists look rather nasty.

Often these register lists contain board specific configurations, and
it'd be nice to be able to make this a bit more generic, also in terms
of sensor configuration.

On the other hand, sometimes even the sensor datasheets do not provide
enough information to do much else.

>>> +
>>> +/* 1280X720 720p */
>>> +static struct sensor_register ov2659_720p[] = {
>>> +     {0x3800, 0x00},
>>> +     {0x3801, 0xa0},
>>> +     {0x3802, 0x00},
>>> +     {0x3803, 0xf0},
>>> +     {0x3804, 0x05},
>>> +     {0x3805, 0xbf},
>>> +     {0x3806, 0x03},
>>> +     {0x3807, 0xcb},
>>> +     {0x3808, 0x05},
>>> +     {0x3809, 0x00},
>>> +     {0x380a, 0x02},
>>> +     {0x380b, 0xd0},
>>> +     {0x380c, 0x06},
>>> +     {0x380d, 0x4c},
>>> +     {0x380e, 0x02},
>>> +     {0x380f, 0xe8},
>>> +     {0x3811, 0x10},
>>> +     {0x3813, 0x06},
>>> +     {0x3814, 0x11},
>>> +     {0x3815, 0x11},
>>> +     {0x3820, 0x80},
>>> +     {0x3821, 0x00},
>>> +     {0x3a03, 0xe8},
>>> +     {0x3a09, 0x6f},
>>> +     {0x3a0b, 0x5d},
>>> +     {0x3a15, 0x9a},
>>> +     {0x0000, 0x00}
>>> +};
>>> +
>>> +/* 1600X1200 UXGA */
>>> +static struct sensor_register ov2659_uxga[] = {
>>> +     {0x3800, 0x00},
>>> +     {0x3801, 0x00},
>>> +     {0x3802, 0x00},
>>> +     {0x3803, 0x00},
>>> +     {0x3804, 0x06},
>>> +     {0x3805, 0x5f},
>>> +     {0x3806, 0x04},
>>> +     {0x3807, 0xbb},
>>> +     {0x3808, 0x06},
>>> +     {0x3809, 0x40},
>>> +     {0x380a, 0x04},
>>> +     {0x380b, 0xb0},
>>> +     {0x380c, 0x07},
>>> +     {0x380d, 0x9f},
>>> +     {0x380e, 0x04},
>>> +     {0x380f, 0xd0},
>>> +     {0x3811, 0x10},
>>> +     {0x3813, 0x06},
>>> +     {0x3814, 0x11},
>>> +     {0x3815, 0x11},
>>> +     {0x3a02, 0x04},
>>> +     {0x3a03, 0xd0},
>>> +     {0x3a08, 0x00},
>>> +     {0x3a09, 0xb8},
>>> +     {0x3a0a, 0x00},
>>> +     {0x3a0b, 0x9a},
>>> +     {0x3a0d, 0x08},
>>> +     {0x3a0e, 0x06},
>>> +     {0x3a14, 0x04},
>>> +     {0x3a15, 0x50},
>>> +     {0x3623, 0x00},
>>> +     {0x3634, 0x44},
>>> +     {0x3701, 0x44},
>>> +     {0x3702, 0x30},
>>> +     {0x3703, 0x48},
>>> +     {0x3704, 0x48},
>>> +     {0x3705, 0x18},
>>> +     {0x3820, 0x80},
>>> +     {0x3821, 0x00},
>>> +     {0x370a, 0x12},
>>> +     {0x4608, 0x00},
>>> +     {0x4609, 0x80},
>>> +     {0x5002, 0x00},
>>> +     {0x0000, 0x00}
>>> +};
>>> +
>>> +/* 1280X1024 SXGA */
>>> +static struct sensor_register ov2659_sxga[] = {
>>> +     {0x3800, 0x00},
>>> +     {0x3801, 0x00},
>>> +     {0x3802, 0x00},
>>> +     {0x3803, 0x00},
>>> +     {0x3804, 0x06},
>>> +     {0x3805, 0x5f},
>>> +     {0x3806, 0x04},
>>> +     {0x3807, 0xb7},
>>> +     {0x3808, 0x05},
>>> +     {0x3809, 0x00},
>>> +     {0x380a, 0x04},
>>> +     {0x380b, 0x00},
>>> +     {0x380c, 0x07},
>>> +     {0x380d, 0x9c},
>>> +     {0x380e, 0x04},
>>> +     {0x380f, 0xd0},
>>> +     {0x3811, 0x10},
>>> +     {0x3813, 0x06},
>>> +     {0x3814, 0x11},
>>> +     {0x3815, 0x11},
>>> +     {0x3a02, 0x02},
>>> +     {0x3a03, 0x68},
>>> +     {0x3a08, 0x00},
>>> +     {0x3a09, 0x5c},
>>> +     {0x3a0a, 0x00},
>>> +     {0x3a0b, 0x4d},
>>> +     {0x3a0d, 0x08},
>>> +     {0x3a0e, 0x06},
>>> +     {0x3a14, 0x02},
>>> +     {0x3a15, 0x28},
>>> +     {0x3623, 0x00},
>>> +     {0x3634, 0x76},
>>> +     {0x3701, 0x44},
>>> +     {0x3702, 0x18},
>>> +     {0x3703, 0x24},
>>> +     {0x3704, 0x24},
>>> +     {0x3705, 0x0c},
>>> +     {0x3820, 0x80},
>>> +     {0x3821, 0x00},
>>> +     {0x370a, 0x52},
>>> +     {0x4608, 0x00},
>>> +     {0x4609, 0x80},
>>> +     {0x5002, 0x00},
>>> +     {0x0000, 0x00}
>>> +};
>>> +
>>> +/* 1024X768 SXGA */
>>> +static struct sensor_register ov2659_xga[] = {
>>> +     {0x3800, 0x00},
>>> +     {0x3801, 0x00},
>>> +     {0x3802, 0x00},
>>> +     {0x3803, 0x00},
>>> +     {0x3804, 0x06},
>>> +     {0x3805, 0x5f},
>>> +     {0x3806, 0x04},
>>> +     {0x3807, 0xb7},
>>> +     {0x3808, 0x04},
>>> +     {0x3809, 0x00},
>>> +     {0x380a, 0x03},
>>> +     {0x380b, 0x00},
>>> +     {0x380c, 0x07},
>>> +     {0x380d, 0x9c},
>>> +     {0x380e, 0x04},
>>> +     {0x380f, 0xd0},
>>> +     {0x3811, 0x10},
>>> +     {0x3813, 0x06},
>>> +     {0x3814, 0x11},
>>> +     {0x3815, 0x11},
>>> +     {0x3a02, 0x02},
>>> +     {0x3a03, 0x68},
>>> +     {0x3a08, 0x00},
>>> +     {0x3a09, 0x5c},
>>> +     {0x3a0a, 0x00},
>>> +     {0x3a0b, 0x4d},
>>> +     {0x3a0d, 0x08},
>>> +     {0x3a0e, 0x06},
>>> +     {0x3a14, 0x02},
>>> +     {0x3a15, 0x28},
>>> +     {0x3623, 0x00},
>>> +     {0x3634, 0x76},
>>> +     {0x3701, 0x44},
>>> +     {0x3702, 0x18},
>>> +     {0x3703, 0x24},
>>> +     {0x3704, 0x24},
>>> +     {0x3705, 0x0c},
>>> +     {0x3820, 0x80},
>>> +     {0x3821, 0x00},
>>> +     {0x370a, 0x52},
>>> +     {0x4608, 0x00},
>>> +     {0x4609, 0x80},
>>> +     {0x5002, 0x00},
>>> +     {0x0000, 0x00}
>>> +};
>>> +
>>> +/* 800X600 SVGA */
>>> +static struct sensor_register ov2659_svga[] = {
>>> +     {0x3800, 0x00},
>>> +     {0x3801, 0x00},
>>> +     {0x3802, 0x00},
>>> +     {0x3803, 0x00},
>>> +     {0x3804, 0x06},
>>> +     {0x3805, 0x5f},
>>> +     {0x3806, 0x04},
>>> +     {0x3807, 0xb7},
>>> +     {0x3808, 0x03},
>>> +     {0x3809, 0x20},
>>> +     {0x380a, 0x02},
>>> +     {0x380b, 0x58},
>>> +     {0x380c, 0x05},
>>> +     {0x380d, 0x14},
>>> +     {0x380e, 0x02},
>>> +     {0x380f, 0x68},
>>> +     {0x3811, 0x08},
>>> +     {0x3813, 0x02},
>>> +     {0x3814, 0x31},
>>> +     {0x3815, 0x31},
>>> +     {0x3a02, 0x02},
>>> +     {0x3a03, 0x68},
>>> +     {0x3a08, 0x00},
>>> +     {0x3a09, 0x5c},
>>> +     {0x3a0a, 0x00},
>>> +     {0x3a0b, 0x4d},
>>> +     {0x3a0d, 0x08},
>>> +     {0x3a0e, 0x06},
>>> +     {0x3a14, 0x02},
>>> +     {0x3a15, 0x28},
>>> +     {0x3623, 0x00},
>>> +     {0x3634, 0x76},
>>> +     {0x3701, 0x44},
>>> +     {0x3702, 0x18},
>>> +     {0x3703, 0x24},
>>> +     {0x3704, 0x24},
>>> +     {0x3705, 0x0c},
>>> +     {0x3820, 0x81},
>>> +     {0x3821, 0x01},
>>> +     {0x370a, 0x52},
>>> +     {0x4608, 0x00},
>>> +     {0x4609, 0x80},
>>> +     {0x5002, 0x00},
>>> +     {0x0000, 0x00}
>>> +};
>>> +
>>> +/* 640X480 VGA */
>>> +static struct sensor_register ov2659_vga[] = {
>>> +     {0x3800, 0x00},
>>> +     {0x3801, 0x00},
>>> +     {0x3802, 0x00},
>>> +     {0x3803, 0x00},
>>> +     {0x3804, 0x06},
>>> +     {0x3805, 0x5f},
>>> +     {0x3806, 0x04},
>>> +     {0x3807, 0xb7},
>>> +     {0x3808, 0x02},
>>> +     {0x3809, 0x80},
>>> +     {0x380a, 0x01},
>>> +     {0x380b, 0xe0},
>>> +     {0x380c, 0x05},
>>> +     {0x380d, 0x14},
>>> +     {0x380e, 0x02},
>>> +     {0x380f, 0x68},
>>> +     {0x3811, 0x08},
>>> +     {0x3813, 0x02},
>>> +     {0x3814, 0x31},
>>> +     {0x3815, 0x31},
>>> +     {0x3a02, 0x02},
>>> +     {0x3a03, 0x68},
>>> +     {0x3a08, 0x00},
>>> +     {0x3a09, 0x5c},
>>> +     {0x3a0a, 0x00},
>>> +     {0x3a0b, 0x4d},
>>> +     {0x3a0d, 0x08},
>>> +     {0x3a0e, 0x06},
>>> +     {0x3a14, 0x02},
>>> +     {0x3a15, 0x28},
>>> +     {0x3623, 0x00},
>>> +     {0x3634, 0x76},
>>> +     {0x3701, 0x44},
>>> +     {0x3702, 0x18},
>>> +     {0x3703, 0x24},
>>> +     {0x3704, 0x24},
>>> +     {0x3705, 0x0c},
>>> +     {0x3820, 0x81},
>>> +     {0x3821, 0x01},
>>> +     {0x370a, 0x52},
>>> +     {0x4608, 0x00},
>>> +     {0x4609, 0x80},
>>> +     {0x5002, 0x10},
>>> +     {0x0000, 0x00}
>>> +};
>>> +
>>> +/* 320X240 QVGA */
>>> +static  struct sensor_register ov2659_qvga[] = {
>>> +     {0x3800, 0x00},
>>> +     {0x3801, 0x00},
>>> +     {0x3802, 0x00},
>>> +     {0x3803, 0x00},
>>> +     {0x3804, 0x06},
>>> +     {0x3805, 0x5f},
>>> +     {0x3806, 0x04},
>>> +     {0x3807, 0xb7},
>>> +     {0x3808, 0x01},
>>> +     {0x3809, 0x40},
>>> +     {0x380a, 0x00},
>>> +     {0x380b, 0xf0},
>>> +     {0x380c, 0x05},
>>> +     {0x380d, 0x14},
>>> +     {0x380e, 0x02},
>>> +     {0x380f, 0x68},
>>> +     {0x3811, 0x08},
>>> +     {0x3813, 0x02},
>>> +     {0x3814, 0x31},
>>> +     {0x3815, 0x31},
>>> +     {0x3a02, 0x02},
>>> +     {0x3a03, 0x68},
>>> +     {0x3a08, 0x00},
>>> +     {0x3a09, 0x5c},
>>> +     {0x3a0a, 0x00},
>>> +     {0x3a0b, 0x4d},
>>> +     {0x3a0d, 0x08},
>>> +     {0x3a0e, 0x06},
>>> +     {0x3a14, 0x02},
>>> +     {0x3a15, 0x28},
>>> +     {0x3623, 0x00},
>>> +     {0x3634, 0x76},
>>> +     {0x3701, 0x44},
>>> +     {0x3702, 0x18},
>>> +     {0x3703, 0x24},
>>> +     {0x3704, 0x24},
>>> +     {0x3705, 0x0c},
>>> +     {0x3820, 0x81},
>>> +     {0x3821, 0x01},
>>> +     {0x370a, 0x52},
>>> +     {0x4608, 0x00},
>>> +     {0x4609, 0x80},
>>> +     {0x5002, 0x10},
>>> +     {0x0000, 0x00}
>>> +};

...

>>> +static unsigned int ov2659_pll_calc_params(struct ov2659 *ov2659)
>>> +{
>>> +     const struct ov2659_platform_data *pdata = ov2659->pdata;
>>> +     u8 ctrl1_reg = 0, ctrl2_reg = 0, ctrl3_reg = 0;
>>> +     struct i2c_client *client = ov2659->client;
>>> +     u32 s_prediv = 1, s_postdiv = 1, s_mult = 1;
>>> +     u32 desired = OV2659_PIXEL_CLOCK;
>>> +     u32 prediv, postdiv, mult;
>>> +     u32 bestdelta = -1;
>>> +     u32 delta, actual;
>>> +     int i, j;
>>> +
>>> +     for (i = 0; ctrl1[i].div != 0; i++) {
>>> +             postdiv = ctrl1[i].div;
>>> +             for (j = 0; ctrl3[j].div != 0; j++) {
>>> +                     prediv = ctrl3[j].div;
>>> +                     for (mult = 1; mult <= 63; mult++) {
>>> +                             actual  = pdata->xvclk_frequency;
>>> +                             actual *= mult;
>>
>> I don't know about the exact composition of the PLL you have in this sensor,
>> however there typically are frequency limits in different parts of the PLL
>> tree. They are not checked here.
>>
> Ok will add a check for those.

If you have a datasheet, does it specify limits? I do like the presence
of a function that calculates them rather than leaving them up to the
user to do that for every given link frequency.

>>> +                             actual /= prediv;
>>> +                             actual /= postdiv;
>>> +                             delta = (actual-desired);
>>> +                             delta = abs(delta);
>>> +
>>> +                             if ((delta < bestdelta) || (bestdelta == -1)) {
>>> +                                     bestdelta = delta;
>>> +                                     s_mult    = mult;
>>> +                                     s_prediv  = prediv;
>>> +                                     s_postdiv = postdiv;
>>> +                                     ctrl1_reg = ctrl1[i].reg;
>>> +                                     ctrl2_reg = mult;
>>> +                                     ctrl3_reg = ctrl3[j].reg;
>>> +                             }
>>> +                     }
>>> +             }
>>> +     }
>>> +     actual = pdata->xvclk_frequency * (s_mult);
>>> +     actual /= (s_prediv) * (s_postdiv);
>>> +
>>> +     dev_dbg(&client->dev, "Actual osc: %u pixel_clock: %u\n",
>>> +             pdata->xvclk_frequency, actual);
>>> +
>>> +     ov2659->pll.ctrl1 = ctrl1_reg;
>>> +     ov2659->pll.ctrl2 = ctrl2_reg;
>>> +     ov2659->pll.ctrl3 = ctrl3_reg;
>>> +
>>> +     dev_dbg(&client->dev,
>>> +             "Actual reg config: ctrl1_reg: %02x ctrl2_reg: %02x ctrl3_reg: %02x\n",
>>> +             ctrl1_reg, ctrl2_reg, ctrl3_reg);
>>> +
>>> +     return actual;
>>> +}

...

>>> +     { .compatible = "ovti,ov2659", },
>>
>> This is not documented in
>> Documentation/devicetree/bindings/vendor-prefixes.txt . Could you add a
>> patch for that, please?
>>
> I did post it along with v1, but there was patch already posted [1]
> which is probably queued in Rob's tree.
> 
> [1] http://patchwork.ozlabs.org/patch/416685/

Ok, I missed that.

Thanks!

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi

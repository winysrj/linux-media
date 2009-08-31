Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbZHaCZB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 22:25:01 -0400
Date: Sun, 30 Aug 2009 23:24:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Brian Johnson <brijohn@gmail.com>
Cc: Joe Perches <joe@perches.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sn9c20x: Reduce data usage, make functions static
Message-ID: <20090830232450.2ed2b07d@pedra.chehab.org>
In-Reply-To: <1250820538.29546.5.camel@Joe-Laptop.home>
References: <1250820538.29546.5.camel@Joe-Laptop.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Brian,

Any news about the patch? It is always a good idea to try to reduce the kernel
size footprint.

Cheers,
Mauro.

Em Thu, 20 Aug 2009 19:08:58 -0700
Joe Perches <joe@perches.com> escreveu:

> Compiled, not tested, no hardware
> 
> Reduces size of object
> 
> Use s16 instead of int where possible.
> Use struct instead of arrays
> 
> Before:
> $ size drivers/media/video/gspca/sn9c20x.o
>    text	   data	    bss	    dec	    hex	filename
>   29346	   1124	   4128	  34598	   8726	drivers/media/video/gspca/sn9c20x.o
> 
> After:
> $ size drivers/media/video/gspca/sn9c20x.o
>    text	   data	    bss	    dec	    hex	filename
>   25042	   1124	   4112	  30278	   7646	drivers/media/video/gspca/sn9c20x.o
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/video/gspca/sn9c20x.c |  101 +++++++++++++++++++---------------
>  1 files changed, 56 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/media/video/gspca/sn9c20x.c b/drivers/media/video/gspca/sn9c20x.c
> index fcfbbd3..8ddf738 100644
> --- a/drivers/media/video/gspca/sn9c20x.c
> +++ b/drivers/media/video/gspca/sn9c20x.c
> @@ -403,7 +403,7 @@ static const struct v4l2_pix_format sxga_mode[] = {
>  		.priv = 3 | MODE_RAW | MODE_SXGA},
>  };
>  
> -static const int hsv_red_x[] = {
> +static const s16 hsv_red_x[] = {
>  	41,  44,  46,  48,  50,  52,  54,  56,
>  	58,  60,  62,  64,  66,  68,  70,  72,
>  	74,  76,  78,  80,  81,  83,  85,  87,
> @@ -451,7 +451,7 @@ static const int hsv_red_x[] = {
>  	24,  26,  28,  30,  33,  35,  37,  39, 41
>  };
>  
> -static const int hsv_red_y[] = {
> +static const s16 hsv_red_y[] = {
>  	82,  80,  78,  76,  74,  73,  71,  69,
>  	67,  65,  63,  61,  58,  56,  54,  52,
>  	50,  48,  46,  44,  41,  39,  37,  35,
> @@ -499,7 +499,7 @@ static const int hsv_red_y[] = {
>  	96, 94, 92, 91, 89, 87, 85, 84, 82
>  };
>  
> -static const int hsv_green_x[] = {
> +static const s16 hsv_green_x[] = {
>  	-124, -124, -125, -125, -125, -125, -125, -125,
>  	-125, -126, -126, -125, -125, -125, -125, -125,
>  	-125, -124, -124, -124, -123, -123, -122, -122,
> @@ -547,7 +547,7 @@ static const int hsv_green_x[] = {
>  	-120, -120, -121, -122, -122, -123, -123, -124, -124
>  };
>  
> -static const int hsv_green_y[] = {
> +static const s16 hsv_green_y[] = {
>  	-100, -99, -98, -97, -95, -94, -93, -91,
>  	-90, -89, -87, -86, -84, -83, -81, -80,
>  	-78, -76, -75, -73, -71, -70, -68, -66,
> @@ -595,7 +595,7 @@ static const int hsv_green_y[] = {
>  	-109, -108, -107, -106, -105, -104, -103, -102, -100
>  };
>  
> -static const int hsv_blue_x[] = {
> +static const s16 hsv_blue_x[] = {
>  	112, 113, 114, 114, 115, 116, 117, 117,
>  	118, 118, 119, 119, 120, 120, 120, 121,
>  	121, 121, 122, 122, 122, 122, 122, 122,
> @@ -643,7 +643,7 @@ static const int hsv_blue_x[] = {
>  	104, 105, 106, 107, 108, 109, 110, 111, 112
>  };
>  
> -static const int hsv_blue_y[] = {
> +static const s16 hsv_blue_y[] = {
>  	-11, -13, -15, -17, -19, -21, -23, -25,
>  	-27, -29, -31, -33, -35, -37, -39, -41,
>  	-43, -45, -46, -48, -50, -52, -54, -55,
> @@ -792,7 +792,17 @@ static u8 hv7131r_gain[] = {
>  	0x78 /* 8x */
>  };
>  
> -static u8 soi968_init[][2] = {
> +struct i2c_reg_u8 {
> +	u8 reg;
> +	u8 val;
> +};
> +
> +struct i2c_reg_u16 {
> +	u8 reg;
> +	u16 val;
> +};
> +
> +static struct i2c_reg_u8 soi968_init[] = {
>  	{0x12, 0x80}, {0x0c, 0x00}, {0x0f, 0x1f},
>  	{0x11, 0x80}, {0x38, 0x52}, {0x1e, 0x00},
>  	{0x33, 0x08}, {0x35, 0x8c}, {0x36, 0x0c},
> @@ -806,7 +816,7 @@ static u8 soi968_init[][2] = {
>  	{0x00, 0x00}, {0x01, 0x80}, {0x02, 0x80},
>  };
>  
> -static u8 ov7660_init[][2] = {
> +static struct i2c_reg_u8 ov7660_init[] = {
>  	{0x0e, 0x80}, {0x0d, 0x08}, {0x0f, 0xc3},
>  	{0x04, 0xc3}, {0x10, 0x40}, {0x11, 0x40},
>  	{0x12, 0x05}, {0x13, 0xba}, {0x14, 0x2a},
> @@ -815,7 +825,7 @@ static u8 ov7660_init[][2] = {
>  	{0x2e, 0x0b}, {0x01, 0x78}, {0x02, 0x50},
>  };
>  
> -static u8 ov7670_init[][2] = {
> +static struct i2c_reg_u8 ov7670_init[] = {
>  	{0x12, 0x80}, {0x11, 0x80}, {0x3a, 0x04}, {0x12, 0x01},
>  	{0x32, 0xb6}, {0x03, 0x0a}, {0x0c, 0x00}, {0x3e, 0x00},
>  	{0x70, 0x3a}, {0x71, 0x35}, {0x72, 0x11}, {0x73, 0xf0},
> @@ -872,7 +882,7 @@ static u8 ov7670_init[][2] = {
>  	{0x93, 0x00},
>  };
>  
> -static u8 ov9650_init[][2] = {
> +static struct i2c_reg_u8 ov9650_init[] = {
>  	{0x12, 0x80}, {0x00, 0x00}, {0x01, 0x78},
>  	{0x02, 0x78}, {0x03, 0x36}, {0x04, 0x03},
>  	{0x05, 0x00}, {0x06, 0x00}, {0x08, 0x00},
> @@ -902,7 +912,7 @@ static u8 ov9650_init[][2] = {
>  	{0xaa, 0x92}, {0xab, 0x0a},
>  };
>  
> -static u8 ov9655_init[][2] = {
> +static struct i2c_reg_u8 ov9655_init[] = {
>  	{0x12, 0x80}, {0x12, 0x01}, {0x0d, 0x00}, {0x0e, 0x61},
>  	{0x11, 0x80}, {0x13, 0xba}, {0x14, 0x2e}, {0x16, 0x24},
>  	{0x1e, 0x04}, {0x1e, 0x04}, {0x1e, 0x04}, {0x27, 0x08},
> @@ -939,7 +949,7 @@ static u8 ov9655_init[][2] = {
>  	{0x00, 0x03}, {0x00, 0x0a}, {0x00, 0x10}, {0x00, 0x13},
>  };
>  
> -static u16 mt9v112_init[][2] = {
> +static struct i2c_reg_u16 mt9v112_init[] = {
>  	{0xf0, 0x0000}, {0x0d, 0x0021}, {0x0d, 0x0020},
>  	{0x34, 0xc019}, {0x0a, 0x0011}, {0x0b, 0x000b},
>  	{0x20, 0x0703}, {0x35, 0x2022}, {0xf0, 0x0001},
> @@ -958,7 +968,7 @@ static u16 mt9v112_init[][2] = {
>  	{0x2c, 0x00ae}, {0x2d, 0x00ae}, {0x2e, 0x00ae},
>  };
>  
> -static u16 mt9v111_init[][2] = {
> +static struct i2c_reg_u16 mt9v111_init[] = {
>  	{0x01, 0x0004}, {0x0d, 0x0001}, {0x0d, 0x0000},
>  	{0x01, 0x0001}, {0x02, 0x0016}, {0x03, 0x01e1},
>  	{0x04, 0x0281}, {0x05, 0x0004}, {0x07, 0x3002},
> @@ -985,7 +995,7 @@ static u16 mt9v111_init[][2] = {
>  	{0x0e, 0x0008},	{0x06, 0x002d},	{0x05, 0x0004},
>  };
>  
> -static u16 mt9v011_init[][2] = {
> +static struct i2c_reg_u16 mt9v011_init[] = {
>  	{0x07, 0x0002},	{0x0d, 0x0001},	{0x0d, 0x0000},
>  	{0x01, 0x0008},	{0x02, 0x0016},	{0x03, 0x01e1},
>  	{0x04, 0x0281},	{0x05, 0x0083},	{0x06, 0x0006},
> @@ -1012,7 +1022,7 @@ static u16 mt9v011_init[][2] = {
>  	{0x06, 0x0029},	{0x05, 0x0009},
>  };
>  
> -static u16 mt9m001_init[][2] = {
> +static struct i2c_reg_u16 mt9m001_init[] = {
>  	{0x0d, 0x0001}, {0x0d, 0x0000}, {0x01, 0x000e},
>  	{0x02, 0x0014}, {0x03, 0x03c1}, {0x04, 0x0501},
>  	{0x05, 0x0083}, {0x06, 0x0006}, {0x0d, 0x0002},
> @@ -1025,14 +1035,14 @@ static u16 mt9m001_init[][2] = {
>  	{0x2e, 0x0029}, {0x07, 0x0002},
>  };
>  
> -static u16 mt9m111_init[][2] = {
> +static struct i2c_reg_u16 mt9m111_init[] = {
>  	{0xf0, 0x0000}, {0x0d, 0x0008}, {0x0d, 0x0009},
>  	{0x0d, 0x0008}, {0xf0, 0x0001}, {0x3a, 0x4300},
>  	{0x9b, 0x4300}, {0xa1, 0x0280}, {0xa4, 0x0200},
>  	{0x06, 0x308e}, {0xf0, 0x0000},
>  };
>  
> -static u8 hv7131r_init[][2] = {
> +static struct i2c_reg_u8 hv7131r_init[] = {
>  	{0x02, 0x08}, {0x02, 0x00}, {0x01, 0x08},
>  	{0x02, 0x00}, {0x20, 0x00}, {0x21, 0xd0},
>  	{0x22, 0x00}, {0x23, 0x09}, {0x01, 0x08},
> @@ -1043,7 +1053,7 @@ static u8 hv7131r_init[][2] = {
>  	{0x23, 0x09}, {0x01, 0x08},
>  };
>  
> -int reg_r(struct gspca_dev *gspca_dev, u16 reg, u16 length)
> +static int reg_r(struct gspca_dev *gspca_dev, u16 reg, u16 length)
>  {
>  	struct usb_device *dev = gspca_dev->dev;
>  	int result;
> @@ -1062,7 +1072,8 @@ int reg_r(struct gspca_dev *gspca_dev, u16 reg, u16 length)
>  	return 0;
>  }
>  
> -int reg_w(struct gspca_dev *gspca_dev, u16 reg, const u8 *buffer, int length)
> +static int reg_w(struct gspca_dev *gspca_dev, u16 reg,
> +		 const u8 *buffer, int length)
>  {
>  	struct usb_device *dev = gspca_dev->dev;
>  	int result;
> @@ -1082,13 +1093,13 @@ int reg_w(struct gspca_dev *gspca_dev, u16 reg, const u8 *buffer, int length)
>  	return 0;
>  }
>  
> -int reg_w1(struct gspca_dev *gspca_dev, u16 reg, const u8 value)
> +static int reg_w1(struct gspca_dev *gspca_dev, u16 reg, const u8 value)
>  {
>  	u8 data[1] = {value};
>  	return reg_w(gspca_dev, reg, data, 1);
>  }
>  
> -int i2c_w(struct gspca_dev *gspca_dev, const u8 *buffer)
> +static int i2c_w(struct gspca_dev *gspca_dev, const u8 *buffer)
>  {
>  	int i;
>  	reg_w(gspca_dev, 0x10c0, buffer, 8);
> @@ -1104,7 +1115,7 @@ int i2c_w(struct gspca_dev *gspca_dev, const u8 *buffer)
>  	return -1;
>  }
>  
> -int i2c_w1(struct gspca_dev *gspca_dev, u8 reg, u8 val)
> +static int i2c_w1(struct gspca_dev *gspca_dev, u8 reg, u8 val)
>  {
>  	struct sd *sd = (struct sd *) gspca_dev;
>  
> @@ -1126,7 +1137,7 @@ int i2c_w1(struct gspca_dev *gspca_dev, u8 reg, u8 val)
>  	return i2c_w(gspca_dev, row);
>  }
>  
> -int i2c_w2(struct gspca_dev *gspca_dev, u8 reg, u16 val)
> +static int i2c_w2(struct gspca_dev *gspca_dev, u8 reg, u16 val)
>  {
>  	struct sd *sd = (struct sd *) gspca_dev;
>  	u8 row[8];
> @@ -1201,8 +1212,8 @@ static int ov9650_init_sensor(struct gspca_dev *gspca_dev)
>  	struct sd *sd = (struct sd *) gspca_dev;
>  
>  	for (i = 0; i < ARRAY_SIZE(ov9650_init); i++) {
> -		if (i2c_w1(gspca_dev, ov9650_init[i][0],
> -				ov9650_init[i][1]) < 0) {
> +		if (i2c_w1(gspca_dev, ov9650_init[i].reg,
> +				ov9650_init[i].val) < 0) {
>  			err("OV9650 sensor initialization failed");
>  			return -ENODEV;
>  		}
> @@ -1218,8 +1229,8 @@ static int ov9655_init_sensor(struct gspca_dev *gspca_dev)
>  	struct sd *sd = (struct sd *) gspca_dev;
>  
>  	for (i = 0; i < ARRAY_SIZE(ov9655_init); i++) {
> -		if (i2c_w1(gspca_dev, ov9655_init[i][0],
> -				ov9655_init[i][1]) < 0) {
> +		if (i2c_w1(gspca_dev, ov9655_init[i].reg,
> +				ov9655_init[i].val) < 0) {
>  			err("OV9655 sensor initialization failed");
>  			return -ENODEV;
>  		}
> @@ -1237,8 +1248,8 @@ static int soi968_init_sensor(struct gspca_dev *gspca_dev)
>  	struct sd *sd = (struct sd *) gspca_dev;
>  
>  	for (i = 0; i < ARRAY_SIZE(soi968_init); i++) {
> -		if (i2c_w1(gspca_dev, soi968_init[i][0],
> -				soi968_init[i][1]) < 0) {
> +		if (i2c_w1(gspca_dev, soi968_init[i].reg,
> +				soi968_init[i].val) < 0) {
>  			err("SOI968 sensor initialization failed");
>  			return -ENODEV;
>  		}
> @@ -1256,8 +1267,8 @@ static int ov7660_init_sensor(struct gspca_dev *gspca_dev)
>  	struct sd *sd = (struct sd *) gspca_dev;
>  
>  	for (i = 0; i < ARRAY_SIZE(ov7660_init); i++) {
> -		if (i2c_w1(gspca_dev, ov7660_init[i][0],
> -				ov7660_init[i][1]) < 0) {
> +		if (i2c_w1(gspca_dev, ov7660_init[i].reg,
> +				ov7660_init[i].val) < 0) {
>  			err("OV7660 sensor initialization failed");
>  			return -ENODEV;
>  		}
> @@ -1275,8 +1286,8 @@ static int ov7670_init_sensor(struct gspca_dev *gspca_dev)
>  	struct sd *sd = (struct sd *) gspca_dev;
>  
>  	for (i = 0; i < ARRAY_SIZE(ov7670_init); i++) {
> -		if (i2c_w1(gspca_dev, ov7670_init[i][0],
> -				ov7670_init[i][1]) < 0) {
> +		if (i2c_w1(gspca_dev, ov7670_init[i].reg,
> +				ov7670_init[i].val) < 0) {
>  			err("OV7670 sensor initialization failed");
>  			return -ENODEV;
>  		}
> @@ -1299,8 +1310,8 @@ static int mt9v_init_sensor(struct gspca_dev *gspca_dev)
>  	ret = i2c_r2(gspca_dev, 0xff, &value);
>  	if ((ret == 0) && (value == 0x8243)) {
>  		for (i = 0; i < ARRAY_SIZE(mt9v011_init); i++) {
> -			if (i2c_w2(gspca_dev, mt9v011_init[i][0],
> -					mt9v011_init[i][1]) < 0) {
> +			if (i2c_w2(gspca_dev, mt9v011_init[i].reg,
> +					mt9v011_init[i].val) < 0) {
>  				err("MT9V011 sensor initialization failed");
>  				return -ENODEV;
>  			}
> @@ -1317,8 +1328,8 @@ static int mt9v_init_sensor(struct gspca_dev *gspca_dev)
>  	ret = i2c_r2(gspca_dev, 0xff, &value);
>  	if ((ret == 0) && (value == 0x823a)) {
>  		for (i = 0; i < ARRAY_SIZE(mt9v111_init); i++) {
> -			if (i2c_w2(gspca_dev, mt9v111_init[i][0],
> -					mt9v111_init[i][1]) < 0) {
> +			if (i2c_w2(gspca_dev, mt9v111_init[i].reg,
> +					mt9v111_init[i].val) < 0) {
>  				err("MT9V111 sensor initialization failed");
>  				return -ENODEV;
>  			}
> @@ -1339,8 +1350,8 @@ static int mt9v_init_sensor(struct gspca_dev *gspca_dev)
>  	ret = i2c_r2(gspca_dev, 0x00, &value);
>  	if ((ret == 0) && (value == 0x1229)) {
>  		for (i = 0; i < ARRAY_SIZE(mt9v112_init); i++) {
> -			if (i2c_w2(gspca_dev, mt9v112_init[i][0],
> -					mt9v112_init[i][1]) < 0) {
> +			if (i2c_w2(gspca_dev, mt9v112_init[i].reg,
> +					mt9v112_init[i].val) < 0) {
>  				err("MT9V112 sensor initialization failed");
>  				return -ENODEV;
>  			}
> @@ -1360,8 +1371,8 @@ static int mt9m111_init_sensor(struct gspca_dev *gspca_dev)
>  	struct sd *sd = (struct sd *) gspca_dev;
>  	int i;
>  	for (i = 0; i < ARRAY_SIZE(mt9m111_init); i++) {
> -		if (i2c_w2(gspca_dev, mt9m111_init[i][0],
> -				mt9m111_init[i][1]) < 0) {
> +		if (i2c_w2(gspca_dev, mt9m111_init[i].reg,
> +				mt9m111_init[i].val) < 0) {
>  			err("MT9M111 sensor initialization failed");
>  			return -ENODEV;
>  		}
> @@ -1376,8 +1387,8 @@ static int mt9m001_init_sensor(struct gspca_dev *gspca_dev)
>  	struct sd *sd = (struct sd *) gspca_dev;
>  	int i;
>  	for (i = 0; i < ARRAY_SIZE(mt9m001_init); i++) {
> -		if (i2c_w2(gspca_dev, mt9m001_init[i][0],
> -				mt9m001_init[i][1]) < 0) {
> +		if (i2c_w2(gspca_dev, mt9m001_init[i].reg,
> +				mt9m001_init[i].val) < 0) {
>  			err("MT9M001 sensor initialization failed");
>  			return -ENODEV;
>  		}
> @@ -1395,8 +1406,8 @@ static int hv7131r_init_sensor(struct gspca_dev *gspca_dev)
>  	struct sd *sd = (struct sd *) gspca_dev;
>  
>  	for (i = 0; i < ARRAY_SIZE(hv7131r_init); i++) {
> -		if (i2c_w1(gspca_dev, hv7131r_init[i][0],
> -				hv7131r_init[i][1]) < 0) {
> +		if (i2c_w1(gspca_dev, hv7131r_init[i].reg,
> +				hv7131r_init[i].val) < 0) {
>  			err("HV7131R Sensor initialization failed");
>  			return -ENODEV;
>  		}


-- 

Cheers,
Mauro

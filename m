Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:52190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab1BANWp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Feb 2011 08:22:45 -0500
Message-ID: <4D480919.4050500@redhat.com>
Date: Tue, 01 Feb 2011 11:22:33 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Julian Scheel <julian@jusst.de>
CC: Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-2200 analog
References: <4CFE14A1.3040801@jusst.de> <1291726869.2073.5.camel@morgan.silverblock.net> <4D07A829.6080406@jusst.de> <4D07CAA6.3030300@kernellabs.com> <67DB049D-B91E-4457-93CE-2CE0164C5B54@jusst.de> <4D2283AD.3000006@jusst.de> <4D2642CA.4080309@jusst.de> <4D288565.6040503@jusst.de>
In-Reply-To: <4D288565.6040503@jusst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 08-01-2011 13:40, Julian Scheel escreveu:
> Am 06.01.2011 23:31, schrieb Julian Scheel:
>>
>>> Attached is the diff I currently use.
>>>
>> Some more process. Attached is a new patch, which allows me to capture video and audio from a PAL tuner. Imho the video has wrong colours though (using PAL-B). Maybe someone would want to test that patch and give some feedback?
> Ok some hours of debugging later, I figured out that only encoder 1 was not working properly. This was due to a wrong addressing when sending the dif setup commands. The attached new patch fixes this.
> 

Is this patch already working properly?

If so, please:
	1) Check its codingstyle with ./scripts/checkpatch.pl
		(there are some issues there, like commenting with //)
	2) Remove the dead code;
	3) Provide a patch description and your Signed-off-by:

> 
> saa7164-card-pal.diff
> 
> 
> Nur in linux-2.6.37/drivers/media/video/saa7164/: modules.order.
> diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37.a/drivers/media/video/saa7164//saa7164-api.c linux-2.6.37/drivers/media/video/saa7164//saa7164-api.c
> --- linux-2.6.37.a/drivers/media/video/saa7164//saa7164-api.c	2011-01-05 01:50:19.000000000 +0100
> +++ linux-2.6.37/drivers/media/video/saa7164//saa7164-api.c	2011-01-08 16:10:32.000000000 +0100
> @@ -548,7 +548,7 @@
>  		tvaudio.std = TU_STANDARD_NTSC_M;
>  		tvaudio.country = 1;
>  	} else {
> -		tvaudio.std = TU_STANDARD_PAL_I;
> +		tvaudio.std = 0x04; //TU_STANDARD_PAL_I;

Probably, you need to add a define for 0x04 and use its symbol here.

>  		tvaudio.country = 44;
>  	}
>  
> @@ -608,7 +608,7 @@
>  	dprintk(DBGLVL_API, "%s(nr=%d type=%d val=%x)\n", __func__,
>  		port->nr, port->type, val);
>  
> -	if (port->nr == 0)
> +	if (port->nr < 3) //== 0)
>  		mas = 0xd0;
>  	else
>  		mas = 0xe0;
> diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37.a/drivers/media/video/saa7164//saa7164-cards.c linux-2.6.37/drivers/media/video/saa7164//saa7164-cards.c
> --- linux-2.6.37.a/drivers/media/video/saa7164//saa7164-cards.c	2011-01-05 01:50:19.000000000 +0100
> +++ linux-2.6.37/drivers/media/video/saa7164//saa7164-cards.c	2011-01-06 16:16:56.000000000 +0100
> @@ -203,6 +203,66 @@
>  			.i2c_reg_len	= REGLEN_8bit,
>  		} },
>  	},
> +	[SAA7164_BOARD_HAUPPAUGE_HVR2200_4] = {
> +		.name		= "Hauppauge WinTV-HVR2200",
> +		.porta		= SAA7164_MPEG_DVB,
> +		.portb		= SAA7164_MPEG_DVB,
> +                .portc          = SAA7164_MPEG_ENCODER,
> +                .portd          = SAA7164_MPEG_ENCODER,
> +                .porte          = SAA7164_MPEG_VBI,
> +                .portf          = SAA7164_MPEG_VBI,
> +		.chiprev	= SAA7164_CHIP_REV3,
> +		.unit		= {{
> +			.id		= 0x1d,
> +			.type		= SAA7164_UNIT_EEPROM,
> +			.name		= "4K EEPROM",
> +			.i2c_bus_nr	= SAA7164_I2C_BUS_0,
> +			.i2c_bus_addr	= 0xa0 >> 1,
> +			.i2c_reg_len	= REGLEN_8bit,
> +		}, {
> +			.id		= 0x04,
> +			.type		= SAA7164_UNIT_TUNER,
> +			.name		= "TDA18271-1",
> +			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
> +			.i2c_bus_addr	= 0xc0 >> 1,
> +			.i2c_reg_len	= REGLEN_8bit,
> +		}, {
> +			.id		= 0x05,
> +			.type		= SAA7164_UNIT_ANALOG_DEMODULATOR,
> +			.name		= "TDA8290-1",
> +			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
> +			.i2c_bus_addr	= 0x84 >> 1,
> +			.i2c_reg_len	= REGLEN_8bit,
> +		}, {
> +			.id		= 0x1b,
> +			.type		= SAA7164_UNIT_TUNER,
> +			.name		= "TDA18271-2",
> +			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
> +			.i2c_bus_addr	= 0xc0 >> 1,
> +			.i2c_reg_len	= REGLEN_8bit,
> +		}, {
> +			.id		= 0x1c,
> +			.type		= SAA7164_UNIT_ANALOG_DEMODULATOR,
> +			.name		= "TDA8290-2",
> +			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
> +			.i2c_bus_addr	= 0x84 >> 1,
> +			.i2c_reg_len	= REGLEN_8bit,
> +		}, {
> +			.id		= 0x1e,
> +			.type		= SAA7164_UNIT_DIGITAL_DEMODULATOR,
> +			.name		= "TDA10048-1",
> +			.i2c_bus_nr	= SAA7164_I2C_BUS_1,
> +			.i2c_bus_addr	= 0x10 >> 1,
> +			.i2c_reg_len	= REGLEN_8bit,
> +		}, {
> +			.id		= 0x1f,
> +			.type		= SAA7164_UNIT_DIGITAL_DEMODULATOR,
> +			.name		= "TDA10048-2",
> +			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
> +			.i2c_bus_addr	= 0x12 >> 1,
> +			.i2c_reg_len	= REGLEN_8bit,
> +		} },
> +	},
>  	[SAA7164_BOARD_HAUPPAUGE_HVR2250] = {
>  		.name		= "Hauppauge WinTV-HVR2250",
>  		.porta		= SAA7164_MPEG_DVB,
> @@ -426,6 +486,10 @@
>  		.subvendor = 0x0070,
>  		.subdevice = 0x8851,
>  		.card      = SAA7164_BOARD_HAUPPAUGE_HVR2250_2,
> +	}, {
> +		.subvendor = 0x0070,
> +		.subdevice = 0x8940,
> +		.card      = SAA7164_BOARD_HAUPPAUGE_HVR2200_4,
>  	},
>  };
>  const unsigned int saa7164_idcount = ARRAY_SIZE(saa7164_subids);
> @@ -469,6 +533,7 @@
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2200:
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2200_2:
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2200_3:
> +	case SAA7164_BOARD_HAUPPAUGE_HVR2200_4:
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2250:
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2250_2:
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2250_3:
> @@ -549,6 +614,7 @@
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2200:
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2200_2:
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2200_3:
> +	case SAA7164_BOARD_HAUPPAUGE_HVR2200_4:
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2250:
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2250_2:
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2250_3:
> diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37.a/drivers/media/video/saa7164//saa7164-dvb.c linux-2.6.37/drivers/media/video/saa7164//saa7164-dvb.c
> --- linux-2.6.37.a/drivers/media/video/saa7164//saa7164-dvb.c	2011-01-05 01:50:19.000000000 +0100
> +++ linux-2.6.37/drivers/media/video/saa7164//saa7164-dvb.c	2011-01-06 16:16:56.000000000 +0100
> @@ -475,6 +475,7 @@
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2200:
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2200_2:
>  	case SAA7164_BOARD_HAUPPAUGE_HVR2200_3:
> +	case SAA7164_BOARD_HAUPPAUGE_HVR2200_4:
>  		i2c_bus = &dev->i2c_bus[port->nr + 1];
>  		switch (port->nr) {
>  		case 0:
> diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37.a/drivers/media/video/saa7164//saa7164-encoder.c linux-2.6.37/drivers/media/video/saa7164//saa7164-encoder.c
> --- linux-2.6.37.a/drivers/media/video/saa7164//saa7164-encoder.c	2011-01-05 01:50:19.000000000 +0100
> +++ linux-2.6.37/drivers/media/video/saa7164//saa7164-encoder.c	2011-01-08 16:11:04.000000000 +0100
> @@ -32,7 +32,25 @@
>  	}, {
>  		.name      = "NTSC-JP",
>  		.id        = V4L2_STD_NTSC_M_JP,
> -	}
> +	}, {
> +                .name      = "PAL-I",
> +                .id        = V4L2_STD_PAL_I,
> +	}, {
> +                .name      = "PAL-M",
> +                .id        = V4L2_STD_PAL_M,
> +	}, {
> +                .name      = "PAL-N",
> +                .id        = V4L2_STD_PAL_N,
> +	}, {
> +                .name      = "PAL-Nc",
> +                .id        = V4L2_STD_PAL_Nc,
> +	}, {
> +                .name      = "PAL-B",
> +                .id        = V4L2_STD_PAL_B,
> +	}, {
> +                .name      = "PAL-DK",
> +                .id        = V4L2_STD_PAL_DK,
> +        }
>  };
>  
>  static const u32 saa7164_v4l2_ctrls[] = {
> @@ -1359,7 +1377,7 @@
>  	.ioctl_ops     = &mpeg_ioctl_ops,
>  	.minor         = -1,
>  	.tvnorms       = SAA7164_NORMS,
> -	.current_norm  = V4L2_STD_NTSC_M,
> +	.current_norm  = V4L2_STD_PAL_B,
>  };
>  
>  static struct video_device *saa7164_encoder_alloc(
> @@ -1407,7 +1425,7 @@
>  
>  	/* Establish encoder defaults here */
>  	/* Set default TV standard */
> -	port->encodernorm = saa7164_tvnorms[0];
> +	port->encodernorm = saa7164_tvnorms[6];
>  	port->width = 720;
>  	port->mux_input = 1; /* Composite */
>  	port->video_format = EU_VIDEO_FORMAT_MPEG_2;
> diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37.a/drivers/media/video/saa7164//saa7164-fw.c linux-2.6.37/drivers/media/video/saa7164//saa7164-fw.c
> --- linux-2.6.37.a/drivers/media/video/saa7164//saa7164-fw.c	2011-01-05 01:50:19.000000000 +0100
> +++ linux-2.6.37/drivers/media/video/saa7164//saa7164-fw.c	2011-01-08 16:13:11.000000000 +0100
> @@ -29,6 +29,9 @@
>  
>  #define SAA7164_REV3_FIRMWARE		"NXP7164-2010-03-10.1.fw"
>  #define SAA7164_REV3_FIRMWARE_SIZE	4019072
> +//#define SAA7164_REV3_FIRMWARE		"v4l-saa7164-1.0.3-3.fw"
> +//#define SAA7164_REV3_FIRMWARE_SIZE	4038864
> +

Hmm... the above seems weird for me.
>  
>  struct fw_header {
>  	u32	firmwaresize;
> diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37.a/drivers/media/video/saa7164//saa7164.h linux-2.6.37/drivers/media/video/saa7164//saa7164.h
> --- linux-2.6.37.a/drivers/media/video/saa7164//saa7164.h	2011-01-05 01:50:19.000000000 +0100
> +++ linux-2.6.37/drivers/media/video/saa7164//saa7164.h	2011-01-06 23:13:06.000000000 +0100
> @@ -83,6 +83,7 @@
>  #define SAA7164_BOARD_HAUPPAUGE_HVR2200_3	6
>  #define SAA7164_BOARD_HAUPPAUGE_HVR2250_2	7
>  #define SAA7164_BOARD_HAUPPAUGE_HVR2250_3	8
> +#define SAA7164_BOARD_HAUPPAUGE_HVR2200_4	9
>  
>  #define SAA7164_MAX_UNITS		8
>  #define SAA7164_TS_NUMBER_OF_LINES	312
> @@ -113,7 +114,7 @@
>  #define DBGLVL_THR 4096
>  #define DBGLVL_CPU 8192
>  
> -#define SAA7164_NORMS (V4L2_STD_NTSC_M |  V4L2_STD_NTSC_M_JP |  V4L2_STD_NTSC_443)
> +#define SAA7164_NORMS (V4L2_STD_NTSC_M |  V4L2_STD_NTSC_M_JP |  V4L2_STD_NTSC_443 | V4L2_STD_PAL_I | V4L2_STD_PAL_M | V4L2_STD_PAL_N | V4L2_STD_PAL_Nc | V4L2_STD_PAL_B | V4L2_STD_PAL_DK)

You may eventually simplify the above with things like 
V4L_STD_MN (that covers NTSC/PAL_M/PAL_N and some variants). See videodev2.h
for the macros that group video standards.

>  
>  enum port_t {
>  	SAA7164_MPEG_UNDEFINED = 0,
> diff -x '*.o' -x '*.ko' -x '*.cmd' -x '*.mod.*' -ru linux-2.6.37.a/drivers/media/video/saa7164//saa7164-vbi.c linux-2.6.37/drivers/media/video/saa7164//saa7164-vbi.c
> --- linux-2.6.37.a/drivers/media/video/saa7164//saa7164-vbi.c	2011-01-05 01:50:19.000000000 +0100
> +++ linux-2.6.37/drivers/media/video/saa7164//saa7164-vbi.c	2011-01-08 15:30:50.000000000 +0100
> @@ -28,7 +28,25 @@
>  	}, {
>  		.name      = "NTSC-JP",
>  		.id        = V4L2_STD_NTSC_M_JP,
> -	}
> +	}, {
> +                .name      = "PAL-I",
> +                .id        = V4L2_STD_PAL_I,
> +        }, {
> +                .name      = "PAL-M",
> +                .id        = V4L2_STD_PAL_M,
> +        }, {
> +                .name      = "PAL-N",
> +                .id        = V4L2_STD_PAL_N,
> +        }, {
> +                .name      = "PAL-Nc",
> +                .id        = V4L2_STD_PAL_Nc,
> +        }, {
> +                .name      = "PAL-B",
> +                .id        = V4L2_STD_PAL_B,
> +        }, {
> +                .name      = "PAL-DK",
> +                .id        = V4L2_STD_PAL_DK,
> +        }
>  };
>  
>  static const u32 saa7164_v4l2_ctrls[] = {


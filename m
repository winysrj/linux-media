Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2267 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab0BLL1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 06:27:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pete Eberlein <pete@sensoray.com>
Subject: Re: [PATCH 2/5] sony-tuner: Subdev conversion from wis-sony-tuner
Date: Fri, 12 Feb 2010 12:29:43 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1265934787.4626.251.camel@pete-desktop>
In-Reply-To: <1265934787.4626.251.camel@pete-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002121229.43924.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 February 2010 01:33:07 Pete Eberlein wrote:
> From: Pete Eberlein <pete@sensoray.com>
> 
> This is a subdev conversion of the go7007 wis-sony-tuner i2c driver,
> and places it with the other tuner drivers.  This obsoletes the
> wis-sony-tuner driver in the go7007 staging directory.

Thanks! Here is a quick review...

> 
> Priority: normal
> 
> Signed-off-by: Pete Eberlein <pete@sensoray.com>
> 
> diff -r 2d2a250ca33b -r 628119533574 linux/Documentation/video4linux/CARDLIST.tuner
> --- a/linux/Documentation/video4linux/CARDLIST.tuner	Wed Feb 10 11:25:59 2010 -0800
> +++ b/linux/Documentation/video4linux/CARDLIST.tuner	Thu Feb 11 15:21:11 2010 -0800
> @@ -81,3 +81,6 @@
>  tuner=81 - Partsnic (Daewoo) PTI-5NF05
>  tuner=82 - Philips CU1216L
>  tuner=83 - NXP TDA18271
> +tuner=84 - Sony PAL+SECAM (BTF-PG472Z)
> +tuner=85 - Sony NTSC_JP (BTF-PK467Z)
> +tuner=86 - Sony NTSC (BTF-PB463Z)
> diff -r 2d2a250ca33b -r 628119533574 linux/drivers/media/common/tuners/Kconfig
> --- a/linux/drivers/media/common/tuners/Kconfig	Wed Feb 10 11:25:59 2010 -0800
> +++ b/linux/drivers/media/common/tuners/Kconfig	Thu Feb 11 15:21:11 2010 -0800
> @@ -179,4 +179,12 @@
>  	help
>  	  A driver for the silicon tuner MAX2165 from Maxim.
>  
> +config MEDIA_TUNER_SONY
> +	tristate "Sony TV tuner"
> +	depends on VIDEO_MEDIA && I2C
> +	default m if MEDIA_TUNER_CUSTOMISE
> +	help
> +	  A driver for the Sony tuners BTF-PG472Z, BTF-PK467Z, BTF-PB463Z.
> +
> +
>  endif # MEDIA_TUNER_CUSTOMISE
> diff -r 2d2a250ca33b -r 628119533574 linux/drivers/media/common/tuners/Makefile
> --- a/linux/drivers/media/common/tuners/Makefile	Wed Feb 10 11:25:59 2010 -0800
> +++ b/linux/drivers/media/common/tuners/Makefile	Thu Feb 11 15:21:11 2010 -0800
> @@ -24,6 +24,7 @@
>  obj-$(CONFIG_MEDIA_TUNER_MXL5007T) += mxl5007t.o
>  obj-$(CONFIG_MEDIA_TUNER_MC44S803) += mc44s803.o
>  obj-$(CONFIG_MEDIA_TUNER_MAX2165) += max2165.o
> +obj-$(CONFIG_MEDIA_TUNER_SONY) += sony-tuner.o
>  
>  EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
>  EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
> diff -r 2d2a250ca33b -r 628119533574 linux/drivers/media/common/tuners/sony-tuner.c
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/drivers/media/common/tuners/sony-tuner.c	Thu Feb 11 15:21:11 2010 -0800
> @@ -0,0 +1,695 @@
> +/*
> + * Copyright (C) 2005-2006 Micronas USA Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License (Version 2) as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software Foundation,
> + * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/videodev2.h>
> +#include <media/tuner.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-i2c-drv.h>

The v4l2-i2c-drv.h is to be used only for drivers that also need to be compiled
for kernels < 2.6.26. If I am not mistaken that is the case for this driver,
right? I remember you mentioning that customers of yours use this on such old
kernels. Just making sure.

> +
> +MODULE_DESCRIPTION("Sony TV Tuner driver");
> +MODULE_LICENSE("GPL v2");
> +
> +/* #define MPX_DEBUG */
> +
> +/* AS(IF/MPX) pin:      LOW      HIGH/OPEN
> + * IF/MPX address:   0x42/0x40   0x43/0x44
> + */
> +#define IF_I2C_ADDR	0x43
> +#define MPX_I2C_ADDR	0x44
> +
> +static v4l2_std_id force_band;
> +static char force_band_str[] = "-";
> +module_param_string(force_band, force_band_str, sizeof(force_band_str), 0644);
> +static int force_mpx_mode = -1;
> +module_param(force_mpx_mode, int, 0644);
> +
> +/* Store tuner info in the same format as tuner.c, so maybe we can put the
> + * Sony tuner support in there. */
> +struct sony_tunertype {
> +	char *name;

This probably should be const char *.

> +	unsigned char Vendor; /* unused here */
> +	unsigned char Type; /* unused here */
> +
> +	unsigned short thresh1; /*  band switch VHF_LO <=> VHF_HI */
> +	unsigned short thresh2; /*  band switch VHF_HI <=> UHF */
> +	unsigned char VHF_L;
> +	unsigned char VHF_H;
> +	unsigned char UHF;
> +	unsigned char config;
> +	unsigned short IFPCoff;
> +};
> +
> +/* This array is indexed by (tuner_type - TUNER_SONY_BTF_PG472Z) */
> +static struct sony_tunertype sony_tuners[] = {

This probably should be const as well.

> +	{ "Sony PAL+SECAM (BTF-PG472Z)", 0, 0,
> +	  16*144.25, 16*427.25, 0x01, 0x02, 0x04, 0xc6, 623},
> +	{ "Sony NTSC_JP (BTF-PK467Z)", 0, 0,
> +	  16*220.25, 16*467.25, 0x01, 0x02, 0x04, 0xc6, 940},
> +	{ "Sony NTSC (BTF-PB463Z)", 0, 0,
> +	  16*130.25, 16*364.25, 0x01, 0x02, 0x04, 0xc6, 732},
> +};
> +
> +struct sony_tuner {
> +	struct v4l2_subdev sd;
> +	int type;
> +	v4l2_std_id std;
> +	unsigned int freq;
> +	int mpxmode;
> +	u32 audmode;
> +};
> +
> +static inline struct sony_tuner *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct sony_tuner, sd);
> +}
> +
> +/* Basically the same as default_set_tv_freq() in tuner.c */
> +static int set_freq(struct i2c_client *client, int freq)
> +{
> +	struct sony_tuner *t = to_state(i2c_get_clientdata(client));
> +	char *band_name;

const char *

> +	int n;
> +	int band_select;
> +	struct sony_tunertype *tun;
> +	u8 buffer[4];
> +
> +	tun = &sony_tuners[t->type - TUNER_SONY_BTF_PG472Z];
> +	if (freq < tun->thresh1) {
> +		band_name = "VHF_L";
> +		band_select = tun->VHF_L;
> +	} else if (freq < tun->thresh2) {
> +		band_name = "VHF_H";
> +		band_select = tun->VHF_H;
> +	} else {
> +		band_name = "UHF";
> +		band_select = tun->UHF;
> +	}
> +	v4l2_info(client, "tuning to frequency %d.%04d (%s)\n",
> +			freq / 16, (freq % 16) * 625, band_name);

OK, this is something that happens a lot in this driver. Drivers like this
should not produce any logging during normal usage. So this should either
be removed or replaced by v4l2_dbg. Please check this driver for similar
constructs.

> +	n = freq + tun->IFPCoff;
> +
> +	buffer[0] = n >> 8;
> +	buffer[1] = n & 0xff;
> +	buffer[2] = tun->config;
> +	buffer[3] = band_select;
> +	i2c_master_send(client, buffer, 4);
> +
> +	return 0;
> +}
> +
> +static int mpx_write(struct i2c_client *client, int dev, int addr, int val)
> +{
> +	u8 buffer[5];
> +	struct i2c_msg msg;
> +
> +	buffer[0] = dev;
> +	buffer[1] = addr >> 8;
> +	buffer[2] = addr & 0xff;
> +	buffer[3] = val >> 8;
> +	buffer[4] = val & 0xff;
> +	msg.addr = MPX_I2C_ADDR;
> +	msg.flags = 0;
> +	msg.len = 5;
> +	msg.buf = buffer;
> +	i2c_transfer(client->adapter, &msg, 1);
> +	return 0;
> +}
> +
> +/*
> + * MPX register values for the BTF-PG472Z:
> + *
> + *                                 FM_     NICAM_  SCART_
> + *          MODUS  SOURCE    ACB   PRESCAL PRESCAL PRESCAL SYSTEM  VOLUME
> + *         10/0030 12/0008 12/0013 12/000E 12/0010 12/0000 10/0020 12/0000
> + *         ---------------------------------------------------------------
> + * Auto     1003    0020    0100    2603    5000    XXXX    0001    7500
> + *
> + * B/G
> + *  Mono    1003    0020    0100    2603    5000    XXXX    0003    7500
> + *  A2      1003    0020    0100    2601    5000    XXXX    0003    7500
> + *  NICAM   1003    0120    0100    2603    5000    XXXX    0008    7500
> + *
> + * I
> + *  Mono    1003    0020    0100    2603    7900    XXXX    000A    7500
> + *  NICAM   1003    0120    0100    2603    7900    XXXX    000A    7500
> + *
> + * D/K
> + *  Mono    1003    0020    0100    2603    5000    XXXX    0004    7500
> + *  A2-1    1003    0020    0100    2601    5000    XXXX    0004    7500
> + *  A2-2    1003    0020    0100    2601    5000    XXXX    0005    7500
> + *  A2-3    1003    0020    0100    2601    5000    XXXX    0007    7500
> + *  NICAM   1003    0120    0100    2603    5000    XXXX    000B    7500
> + *
> + * L/L'
> + *  Mono    0003    0200    0100    7C03    5000    2200    0009    7500
> + *  NICAM   0003    0120    0100    7C03    5000    XXXX    0009    7500
> + *
> + * M
> + *  Mono    1003    0200    0100    2B03    5000    2B00    0002    7500
> + *
> + * For Asia, replace the 0x26XX in FM_PRESCALE with 0x14XX.
> + *
> + * Bilingual selection in A2/NICAM:
> + *
> + *         High byte of SOURCE     Left chan   Right chan
> + *                 0x01              MAIN         SUB
> + *                 0x03              MAIN         MAIN
> + *                 0x04              SUB          SUB
> + *
> + * Force mono in NICAM by setting the high byte of SOURCE to 0x02 (L/L') or
> + * 0x00 (all other bands).  Force mono in A2 with FMONO_A2:
> + *
> + *                      FMONO_A2
> + *                      10/0022
> + *                      --------
> + *     Forced mono ON     07F0
> + *     Forced mono OFF    0190
> + */
> +
> +static struct {
> +	enum { AUD_MONO, AUD_A2, AUD_NICAM, AUD_NICAM_L } audio_mode;
> +	u16 modus;
> +	u16 source;
> +	u16 acb;
> +	u16 fm_prescale;
> +	u16 nicam_prescale;
> +	u16 scart_prescale;
> +	u16 system;
> +	u16 volume;
> +} mpx_audio_modes[] = {
> +	/* Auto */	{ AUD_MONO,	0x1003, 0x0020, 0x0100, 0x2603,
> +					0x5000, 0x0000, 0x0001, 0x7500 },
> +	/* B/G Mono */	{ AUD_MONO,	0x1003, 0x0020, 0x0100, 0x2603,
> +					0x5000, 0x0000, 0x0003, 0x7500 },
> +	/* B/G A2 */	{ AUD_A2,	0x1003, 0x0020, 0x0100, 0x2601,
> +					0x5000, 0x0000, 0x0003, 0x7500 },
> +	/* B/G NICAM */ { AUD_NICAM,	0x1003, 0x0120, 0x0100, 0x2603,
> +					0x5000, 0x0000, 0x0008, 0x7500 },
> +	/* I Mono */	{ AUD_MONO,	0x1003, 0x0020, 0x0100, 0x2603,
> +					0x7900, 0x0000, 0x000A, 0x7500 },
> +	/* I NICAM */	{ AUD_NICAM,	0x1003, 0x0120, 0x0100, 0x2603,
> +					0x7900, 0x0000, 0x000A, 0x7500 },
> +	/* D/K Mono */	{ AUD_MONO,	0x1003, 0x0020, 0x0100, 0x2603,
> +					0x5000, 0x0000, 0x0004, 0x7500 },
> +	/* D/K A2-1 */	{ AUD_A2,	0x1003, 0x0020, 0x0100, 0x2601,
> +					0x5000, 0x0000, 0x0004, 0x7500 },
> +	/* D/K A2-2 */	{ AUD_A2,	0x1003, 0x0020, 0x0100, 0x2601,
> +					0x5000, 0x0000, 0x0005, 0x7500 },
> +	/* D/K A2-3 */	{ AUD_A2,	0x1003, 0x0020, 0x0100, 0x2601,
> +					0x5000, 0x0000, 0x0007, 0x7500 },
> +	/* D/K NICAM */	{ AUD_NICAM,	0x1003, 0x0120, 0x0100, 0x2603,
> +					0x5000, 0x0000, 0x000B, 0x7500 },
> +	/* L/L' Mono */	{ AUD_MONO,	0x0003, 0x0200, 0x0100, 0x7C03,
> +					0x5000, 0x2200, 0x0009, 0x7500 },
> +	/* L/L' NICAM */{ AUD_NICAM_L,	0x0003, 0x0120, 0x0100, 0x7C03,
> +					0x5000, 0x0000, 0x0009, 0x7500 },
> +};
> +
> +#define MPX_NUM_MODES	ARRAY_SIZE(mpx_audio_modes)
> +
> +static int mpx_setup(struct i2c_client *client)
> +{
> +	struct sony_tuner *t = i2c_get_clientdata(client);
> +	u16 source = 0;
> +	u8 buffer[3];
> +	struct i2c_msg msg;
> +
> +	/* reset MPX */
> +	buffer[0] = 0x00;
> +	buffer[1] = 0x80;
> +	buffer[2] = 0x00;
> +	msg.addr = MPX_I2C_ADDR;
> +	msg.flags = 0;
> +	msg.len = 3;
> +	msg.buf = buffer;
> +	i2c_transfer(client->adapter, &msg, 1);
> +	buffer[1] = 0x00;
> +	i2c_transfer(client->adapter, &msg, 1);
> +
> +	if (mpx_audio_modes[t->mpxmode].audio_mode != AUD_MONO) {
> +		switch (t->audmode) {
> +		case V4L2_TUNER_MODE_MONO:
> +			switch (mpx_audio_modes[t->mpxmode].audio_mode) {
> +			case AUD_A2:
> +				source = mpx_audio_modes[t->mpxmode].source;
> +				break;
> +			case AUD_NICAM:
> +				source = 0x0000;
> +				break;
> +			case AUD_NICAM_L:
> +				source = 0x0200;
> +				break;
> +			default:
> +				break;
> +			}
> +			break;
> +		case V4L2_TUNER_MODE_STEREO:
> +			source = mpx_audio_modes[t->mpxmode].source;
> +			break;
> +		case V4L2_TUNER_MODE_LANG1:
> +			source = 0x0300;
> +			break;
> +		case V4L2_TUNER_MODE_LANG2:
> +			source = 0x0400;
> +			break;
> +		}
> +		source |= mpx_audio_modes[t->mpxmode].source & 0x00ff;
> +	} else
> +		source = mpx_audio_modes[t->mpxmode].source;
> +
> +	mpx_write(client, 0x10, 0x0030, mpx_audio_modes[t->mpxmode].modus);
> +	mpx_write(client, 0x12, 0x0008, source);
> +	mpx_write(client, 0x12, 0x0013, mpx_audio_modes[t->mpxmode].acb);
> +	mpx_write(client, 0x12, 0x000e,
> +			mpx_audio_modes[t->mpxmode].fm_prescale);
> +	mpx_write(client, 0x12, 0x0010,
> +			mpx_audio_modes[t->mpxmode].nicam_prescale);
> +	mpx_write(client, 0x12, 0x000d,
> +			mpx_audio_modes[t->mpxmode].scart_prescale);
> +	mpx_write(client, 0x10, 0x0020, mpx_audio_modes[t->mpxmode].system);
> +	mpx_write(client, 0x12, 0x0000, mpx_audio_modes[t->mpxmode].volume);
> +	if (mpx_audio_modes[t->mpxmode].audio_mode == AUD_A2)
> +		mpx_write(client, 0x10, 0x0022,
> +			t->audmode == V4L2_TUNER_MODE_MONO ?  0x07f0 : 0x0190);
> +
> +#ifdef MPX_DEBUG
> +	{
> +		u8 buf1[3], buf2[2];
> +		struct i2c_msg msgs[2];
> +
> +		v4l2_info(client, "MPX registers: %04x %04x "
> +				"%04x %04x %04x %04x %04x %04x\n",
> +				mpx_audio_modes[t->mpxmode].modus,
> +				source,
> +				mpx_audio_modes[t->mpxmode].acb,
> +				mpx_audio_modes[t->mpxmode].fm_prescale,
> +				mpx_audio_modes[t->mpxmode].nicam_prescale,
> +				mpx_audio_modes[t->mpxmode].scart_prescale,
> +				mpx_audio_modes[t->mpxmode].system,
> +				mpx_audio_modes[t->mpxmode].volume);
> +		buf1[0] = 0x11;
> +		buf1[1] = 0x00;
> +		buf1[2] = 0x7e;
> +		msgs[0].addr = MPX_I2C_ADDR;
> +		msgs[0].flags = 0;
> +		msgs[0].len = 3;
> +		msgs[0].buf = buf1;
> +		msgs[1].addr = MPX_I2C_ADDR;
> +		msgs[1].flags = I2C_M_RD;
> +		msgs[1].len = 2;
> +		msgs[1].buf = buf2;
> +		i2c_transfer(client->adapter, msgs, 2);
> +		v4l2_info(client, "MPX system: %02x%02x\n",
> +				buf2[0], buf2[1]);
> +		buf1[0] = 0x11;
> +		buf1[1] = 0x02;
> +		buf1[2] = 0x00;
> +		i2c_transfer(client->adapter, msgs, 2);
> +		v4l2_info(client, "MPX status: %02x%02x\n",
> +				buf2[0], buf2[1]);
> +	}
> +#endif
> +	return 0;
> +}
> +
> +/*
> + * IF configuration values for the BTF-PG472Z:
> + *
> + *	B/G: 0x94 0x70 0x49
> + *	I:   0x14 0x70 0x4a
> + *	D/K: 0x14 0x70 0x4b
> + *	L:   0x04 0x70 0x4b
> + *	L':  0x44 0x70 0x53
> + *	M:   0x50 0x30 0x4c
> + */
> +
> +static int set_if(struct i2c_client *client)
> +{
> +	struct sony_tuner *t = i2c_get_clientdata(client);
> +	u8 buffer[4];
> +	struct i2c_msg msg;
> +	int default_mpx_mode = 0;
> +
> +	/* configure IF */
> +	buffer[0] = 0;
> +	if (t->std & V4L2_STD_PAL_BG) {
> +		buffer[1] = 0x94;
> +		buffer[2] = 0x70;
> +		buffer[3] = 0x49;
> +		default_mpx_mode = 1;
> +	} else if (t->std & V4L2_STD_PAL_I) {
> +		buffer[1] = 0x14;
> +		buffer[2] = 0x70;
> +		buffer[3] = 0x4a;
> +		default_mpx_mode = 4;
> +	} else if (t->std & V4L2_STD_PAL_DK) {
> +		buffer[1] = 0x14;
> +		buffer[2] = 0x70;
> +		buffer[3] = 0x4b;
> +		default_mpx_mode = 6;
> +	} else if (t->std & V4L2_STD_SECAM_L) {
> +		buffer[1] = 0x04;
> +		buffer[2] = 0x70;
> +		buffer[3] = 0x4b;
> +		default_mpx_mode = 11;
> +	}
> +	msg.addr = IF_I2C_ADDR;
> +	msg.flags = 0;
> +	msg.len = 4;
> +	msg.buf = buffer;
> +	i2c_transfer(client->adapter, &msg, 1);
> +
> +	/* Select MPX mode if not forced by the user */
> +	if (force_mpx_mode >= 0 && force_mpx_mode < MPX_NUM_MODES)
> +		t->mpxmode = force_mpx_mode;
> +	else
> +		t->mpxmode = default_mpx_mode;
> +	v4l2_info(client, "setting MPX to mode %d\n", t->mpxmode);
> +	mpx_setup(client);
> +
> +	return 0;
> +}
> +
> +static int sony_tuner_s_mode(struct v4l2_subdev *sd,
> +				 enum v4l2_tuner_type type)

The s_mode op is used when switching a tuner between TV and radio mode.
Since this tuner does not support radio, you do not have to support s_mode.

So just move the code in this function to s_type_addr below.

> +{
> +	struct sony_tuner *t = to_state(sd);
> +
> +	if (t->type >= 0) {
> +		if (t->type != type)
> +			v4l2_err(sd, "type already set to %d, "
> +				"ignoring request for %d\n",
> +				t->type, type);
> +		return 0;
> +	}
> +	t->type = type;
> +	switch (t->type) {
> +	case TUNER_SONY_BTF_PG472Z:
> +		switch (force_band_str[0]) {
> +		case 'b':
> +		case 'B':
> +		case 'g':
> +		case 'G':
> +			v4l2_info(sd, "forcing tuner to PAL-B/G bands\n");
> +			force_band = V4L2_STD_PAL_BG;
> +			break;
> +		case 'i':
> +		case 'I':
> +			v4l2_info(sd, "forcing tuner to PAL-I band\n");
> +			force_band = V4L2_STD_PAL_I;
> +			break;
> +		case 'd':
> +		case 'D':
> +		case 'k':
> +		case 'K':
> +			v4l2_info(sd, "forcing tuner to PAL-D/K bands\n");
> +			force_band = V4L2_STD_PAL_I;
> +			break;
> +		case 'l':
> +		case 'L':
> +			v4l2_info(sd, "forcing tuner to SECAM-L band\n");
> +			force_band = V4L2_STD_SECAM_L;
> +			break;
> +		default:
> +			force_band = 0;
> +			break;
> +		}
> +		if (force_band)
> +			t->std = force_band;
> +		else
> +			t->std = V4L2_STD_PAL_BG;
> +		set_if(v4l2_get_subdevdata(sd));
> +		break;
> +	case TUNER_SONY_BTF_PK467Z:
> +		t->std = V4L2_STD_NTSC_M_JP;
> +		break;
> +	case TUNER_SONY_BTF_PB463Z:
> +		t->std = V4L2_STD_NTSC_M;
> +		break;
> +	default:
> +		v4l2_err(sd, "tuner type %d is not supported by this module\n",
> +			type);
> +		return -EINVAL;
> +	}
> +	if (type >= 0)
> +		v4l2_info(sd, "type set to %d (%s)\n",
> +			t->type,
> +			sony_tuners[t->type - TUNER_SONY_BTF_PG472Z].name);
> +	return 0;
> +}
> +
> +static int sony_tuner_s_type_addr(struct v4l2_subdev *sd,
> +				      struct tuner_setup *type)
> +{
> +	return sony_tuner_s_mode(sd, type->type);
> +}
> +
> +static int sony_tuner_g_frequency(struct v4l2_subdev *sd,
> +				      struct v4l2_frequency *freq)
> +{
> +	struct sony_tuner *t = to_state(sd);
> +
> +	freq->frequency = t->freq;

You need to check both the tuner and type field of struct v4l2_frequency here.

> +	return 0;
> +}
> +
> +static int sony_tuner_s_frequency(struct v4l2_subdev *sd,
> +				      struct v4l2_frequency *freq)
> +{
> +	struct sony_tuner *t = to_state(sd);
> +
> +	t->freq = freq->frequency;

Ditto.

> +	set_freq(v4l2_get_subdevdata(sd), t->freq);
> +	return 0;
> +}
> +
> +
> +
> +static int sony_tuner_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
> +{
> +	struct sony_tuner *t = to_state(sd);
> +	v4l2_std_id old = t->std;
> +
> +	switch (t->type) {
> +	case TUNER_SONY_BTF_PG472Z:
> +		if (force_band && (norm & force_band) != norm &&
> +				norm != V4L2_STD_PAL &&
> +				norm != V4L2_STD_SECAM) {
> +			v4l2_info(sd, "ignoring requested TV standard in "
> +					"favor of force_band value\n");
> +			t->std = force_band;
> +		} else if (norm & V4L2_STD_PAL_BG) { /* default */
> +			t->std = V4L2_STD_PAL_BG;
> +		} else if (norm & V4L2_STD_PAL_I) {
> +			t->std = V4L2_STD_PAL_I;
> +		} else if (norm & V4L2_STD_PAL_DK) {
> +			t->std = V4L2_STD_PAL_DK;
> +		} else if (norm & V4L2_STD_SECAM_L) {
> +			t->std = V4L2_STD_SECAM_L;
> +		} else {
> +			v4l2_err(sd, "TV standard not supported\n");

Remove or use v4l2_dbg.

> +			return -EINVAL;
> +		}
> +		if (old != t->std)
> +			set_if(v4l2_get_subdevdata(sd));
> +		break;
> +	case TUNER_SONY_BTF_PK467Z:
> +		if (!(norm & V4L2_STD_NTSC_M_JP)) {
> +			v4l2_err(sd, "TV standard not supported\n");
> +			return -EINVAL;
> +		}
> +		break;
> +	case TUNER_SONY_BTF_PB463Z:
> +		if (!(norm & V4L2_STD_NTSC_M)) {
> +			v4l2_err(sd, "TV standard not supported\n");
> +			return -EINVAL;
> +		}
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int sony_tuner_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
> +{
> +	struct sony_tuner *t = to_state(sd);
> +
> +	switch (t->type) {
> +	case TUNER_SONY_BTF_PG472Z:
> +		if (force_band)
> +			*std = force_band;
> +		else
> +			*std = V4L2_STD_PAL_BG | V4L2_STD_PAL_I |
> +				V4L2_STD_PAL_DK | V4L2_STD_SECAM_L;
> +		break;
> +	case TUNER_SONY_BTF_PK467Z:
> +		*std = V4L2_STD_NTSC_M_JP;
> +		break;
> +	case TUNER_SONY_BTF_PB463Z:
> +		*std = V4L2_STD_NTSC_M;
> +		break;
> +	}

You can remove this op. querystd is meant to detect the standard on the input,
not to return the current standard. Tuners generally cannot detect a standard
anyway.

> +	return 0;
> +}
> +
> +static int sony_tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
> +{
> +	struct sony_tuner *t = to_state(sd);
> +
> +	memset(vt, 0, sizeof(*vt));

No need to memset, that's already been done by the v4l core.

You should check the vt->index field here.

> +	strcpy(vt->name, "Television");

Please use strlcpy.

> +	vt->type = V4L2_TUNER_ANALOG_TV;
> +	vt->rangelow = 0UL; /* does anything use these? */
> +	vt->rangehigh = 0xffffffffUL;

If you know the minimum and maximum frequencies then you should set them
here. Applications that scan for channel will typically use this.

> +	switch (t->type) {
> +	case TUNER_SONY_BTF_PG472Z:
> +		vt->capability = V4L2_TUNER_CAP_NORM |
> +			V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LANG1 |
> +			V4L2_TUNER_CAP_LANG2;
> +		vt->rxsubchans = V4L2_TUNER_SUB_MONO |
> +			V4L2_TUNER_SUB_STEREO | V4L2_TUNER_SUB_LANG1 |
> +			V4L2_TUNER_SUB_LANG2;
> +		break;
> +	case TUNER_SONY_BTF_PK467Z:
> +	case TUNER_SONY_BTF_PB463Z:
> +		vt->capability = V4L2_TUNER_CAP_STEREO;
> +		vt->rxsubchans = V4L2_TUNER_SUB_MONO |
> +					V4L2_TUNER_SUB_STEREO;
> +		break;
> +	}
> +	vt->audmode = t->audmode;
> +	return 0;
> +}
> +
> +static int sony_tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
> +{
> +	struct sony_tuner *t = to_state(sd);
> +

Check the vt->index field here.

> +	switch (t->type) {
> +	case TUNER_SONY_BTF_PG472Z:
> +		if (vt->audmode != t->audmode) {
> +			t->audmode = vt->audmode;
> +			mpx_setup(v4l2_get_subdevdata(sd));
> +		}
> +		break;
> +	case TUNER_SONY_BTF_PK467Z:
> +	case TUNER_SONY_BTF_PB463Z:
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int sony_tuner_log_status(struct v4l2_subdev *sd)
> +{
> +	struct sony_tuner *t = to_state(sd);
> +
> +	v4l2_info(sd, "Standard: %s\n", t->std == V4L2_STD_NTSC ? "NTSC" :
> +					t->std == V4L2_STD_PAL ? "PAL" :
> +					t->std == V4L2_STD_SECAM ? "SECAM" :
> +					"unknown");
> +	v4l2_info(sd, "Frequency: %ud\n", t->freq);
> +	return 0;
> +}
> +
> +/* --------------------------------------------------------------------------*/
> +
> +static const struct v4l2_subdev_core_ops sony_tuner_core_ops = {
> +	.log_status = sony_tuner_log_status,
> +	.s_std = sony_tuner_s_std,
> +};
> +
> +static const struct v4l2_subdev_tuner_ops sony_tuner_tuner_ops = {
> +	.s_mode = sony_tuner_s_mode,
> +	.s_frequency = sony_tuner_s_frequency,
> +	.g_frequency = sony_tuner_g_frequency,
> +	.s_tuner = sony_tuner_s_tuner,
> +	.g_tuner = sony_tuner_g_tuner,
> +	.s_type_addr = sony_tuner_s_type_addr,
> +};
> +
> +static const struct v4l2_subdev_video_ops sony_tuner_video_ops = {
> +	.querystd = sony_tuner_querystd,
> +};
> +
> +static const struct v4l2_subdev_ops sony_tuner_ops = {
> +	.core = &sony_tuner_core_ops,
> +	.tuner = &sony_tuner_tuner_ops,
> +	.video = &sony_tuner_video_ops,
> +};
> +
> +/* --------------------------------------------------------------------------*/
> +
> +static int sony_tuner_probe(struct i2c_client *client,
> +				const struct i2c_device_id *id)
> +{
> +	struct sony_tuner *t;
> +	struct v4l2_subdev *sd;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
> +		return -ENODEV;
> +
> +	v4l2_info(client, "initializing Sony TV Tuner at address 0x%x on %s\n",
> +		client->addr, client->adapter->name);
> +
> +	t = kmalloc(sizeof(struct sony_tuner), GFP_KERNEL);

Use kzalloc.

> +	if (t == NULL)
> +		return -ENOMEM;
> +
> +	sd = &t->sd;
> +	v4l2_i2c_subdev_init(sd, client, &sony_tuner_ops);
> +
> +	/* Initialize sony_tuner */
> +	t->type = -1;
> +	t->freq = 0;
> +	t->mpxmode = 0;
> +	t->audmode = V4L2_TUNER_MODE_STEREO;
> +
> +	return 0;
> +}
> +
> +static int sony_tuner_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(to_state(sd));
> +
> +	return 0;
> +}
> +
> +/* ----------------------------------------------------------------------- */
> +
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
> +static const struct i2c_device_id sony_tuner_id[] = {
> +	{ "sony_tuner", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, sony_tuner_id);
> +#endif
> +
> +static struct v4l2_i2c_driver_data v4l2_i2c_data = {
> +	.name = "sony_tuner",
> +	.probe = sony_tuner_probe,
> +	.remove = sony_tuner_remove,
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
> +	.id_table = sony_tuner_id,
> +#endif
> +};
> diff -r 2d2a250ca33b -r 628119533574 linux/drivers/media/common/tuners/tuner-types.c
> --- a/linux/drivers/media/common/tuners/tuner-types.c	Wed Feb 10 11:25:59 2010 -0800
> +++ b/linux/drivers/media/common/tuners/tuner-types.c	Thu Feb 11 15:21:11 2010 -0800
> @@ -1806,6 +1806,18 @@
>  		.name   = "NXP TDA18271",
>  		/* see tda18271-fe.c for details */
>  	},
> +	[TUNER_SONY_BTF_PG472Z] = {
> +		.name   = "Sony PAL+SECAM (BTF-PG472Z)",
> +		/* see sony-tuner.c for details */
> +	},
> +	[TUNER_SONY_BTF_PK467Z] = {
> +		.name   = "Sony NTSC_JP (BTF-PK467Z)",
> +		/* see sony-tuner.c for details */
> +	},
> +	[TUNER_SONY_BTF_PB463Z] = {
> +		.name   = "Sony NTSC (BTF-PB463Z)",
> +		/* see sony-tuner.c for details */
> +	},
>  };
>  EXPORT_SYMBOL(tuners);
>  
> diff -r 2d2a250ca33b -r 628119533574 linux/drivers/staging/go7007/go7007-priv.h
> --- a/linux/drivers/staging/go7007/go7007-priv.h	Wed Feb 10 11:25:59 2010 -0800
> +++ b/linux/drivers/staging/go7007/go7007-priv.h	Thu Feb 11 15:21:11 2010 -0800
> @@ -292,9 +292,3 @@
>  /* We re-use the I2C_M_TEN value so the flag passes through the masks in the
>   * core I2C code.  Major kludge, but the I2C layer ain't exactly flexible. */
>  #define	I2C_CLIENT_SCCB			0x10
> -
> -/* Sony tuner types */
> -
> -#define TUNER_SONY_BTF_PG472Z		200
> -#define TUNER_SONY_BTF_PK467Z		201
> -#define TUNER_SONY_BTF_PB463Z		202
> diff -r 2d2a250ca33b -r 628119533574 linux/drivers/staging/go7007/go7007-usb.c
> --- a/linux/drivers/staging/go7007/go7007-usb.c	Wed Feb 10 11:25:59 2010 -0800
> +++ b/linux/drivers/staging/go7007/go7007-usb.c	Thu Feb 11 15:21:11 2010 -0800
> @@ -27,6 +27,7 @@
>  #include <linux/i2c.h>
>  #include <asm/byteorder.h>
>  #include <media/tvaudio.h>
> +#include <media/tuner.h>
>  
>  #include "go7007-priv.h"
>  
> @@ -217,7 +218,7 @@
>  				.addr	= 0x1a,
>  			},
>  			{
> -				.type	= "wis_sony_tuner",
> +				.type	= "sony_tuner",
>  				.addr	= 0x60,
>  			},
>  		},
> diff -r 2d2a250ca33b -r 628119533574 linux/include/media/tuner.h
> --- a/linux/include/media/tuner.h	Wed Feb 10 11:25:59 2010 -0800
> +++ b/linux/include/media/tuner.h	Thu Feb 11 15:21:11 2010 -0800
> @@ -130,6 +130,10 @@
>  #define TUNER_PHILIPS_CU1216L           82
>  #define TUNER_NXP_TDA18271		83
>  
> +#define TUNER_SONY_BTF_PG472Z		84	/* PAL+SECAM */
> +#define TUNER_SONY_BTF_PK467Z		85	/* NTSC_JP */
> +#define TUNER_SONY_BTF_PB463Z		86	/* NTSC */
> +
>  /* tv card specific */
>  #define TDA9887_PRESENT 		(1<<0)
>  #define TDA9887_PORT1_INACTIVE 		(1<<1)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

Return-path: <linux-media-owner@vger.kernel.org>
Received: from server.road.de ([85.10.209.111]:40365 "EHLO mail.road.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592AbZLCIsk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 03:48:40 -0500
From: Uwe Taeubert <u.taeubert@road.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Problem on RJ54N1CB0C
Date: Thu, 3 Dec 2009 09:48:43 +0100
References: <200911130950.30581.u.taeubert@road.de> <200911160807.25160.u.taeubert@road.de> <Pine.LNX.4.64.0911170909440.4504@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0911170909440.4504@axis700.grange>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rt3FLqtov2gnZRd"
Message-Id: <200912030948.43627.u.taeubert@road.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_rt3FLqtov2gnZRd
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Guennadi,
now  our driver is working. I found the registers to fix and manipulate the 
exposure values. So, now, if I switch from preview to heigher resolution 
pictures, the taken photo is as bright as the preview. I read out the preview 
exposure data, modify it according to the desired divider settings and then I 
switch to the new mode. 
Now it is also possible to change exposure values in case of flashlight use 
depending on AF values to prevent over exposure of near objects. But, it is 
not done, yet.
The resolution depending divider switching is not tested in all details, yet. 
It is done for our preferred resolutions.

I'm using the English version.

Regard
Uwe

Am Tuesday 17 November 2009 09:28:18 schrieben Sie:
> Hi Uwe
>
> On Mon, 16 Nov 2009, Uwe Taeubert wrote:
> > Hi Guennadi
> > You will find the driver sources for our Sharp module in lz0p39ha.c and
> > the initialization data in lz0p39ha_init.c. In lz0p35du_set_fmt_cap() you
> > can see the resolution depending change of the divider. In our system we
> > get correct pictures in all resolution mensioned there. But FYI, if no
> > flashlight is desired, we do not switch to still mode - only still mode
> > generates flash controll signals.
> > We are working with the Technical Manual Ver. 2.2C, also under NDA.
>
> May I ask you if you have an English or a Japanese version?:-) I've got a
> 2.3C Japanese...
>
> > Concerning the exposure control, I know the use of the registers 0x04d8
> > and 0x04d9 is more a hack but a solution. And the result is unsatisfying
> > - it was a try.divide  
> >
> > At the moment I'm checking the influence of RAMPCLK- TGCLK-ratio. I was
> > able to get higher exposer by changing RAMPCLK but I wasn't able to
> > calculate a well doing relation between all clocks and to have a fast
> > frame rate.
> >
> > The driver content is in a preliminary state. I'm working on
> > lz0p35du_set_fmt_cap function. We do not diffenrentialte between preview
> > and still mode. It makes it easier to handle buffers in VFL at the
> > moment.
>
> Thanks for the code. I looked briefly at it and one essential difference
> that occurred to me is, that you're setting the RESIZE registers at the
> beginning of the format-change function (lz0p35du_set_fmt_cap()), and I am
> doing this following code examples, that I had in the end, followed by a
> killer delay of 230ms... You might try to do that in the end, but it might
> only become worse, because, as I said, my version of the driver has
> problems with bigger images.
>
> My driver also doesn't set autofocus ATM, as there had been errors in
> examples that I had and I didn't have time to experiment with those
> values. I'm also relying on the automatic exposure area selection (0x58c
> bit 7) instead of setting it automatically. You also don't seem to
> dynamically adjust INC_USE_SEL registers, instead you just initialise them
> to 0xff. And in my experience that register does make a difference, so,
> you might try to play with it a bit. Have a look at my driver, although, I
> don't think values I configure there are perfect either.
>
> In fact, it might indeed become a problem for you, that you're updating
> the RESIZE registers too early and not pausing after that.
>
> Unfortunately, I do not have time now to look at the driver in detail ATM,
> let me know your results when you fix your problem.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/



--Boundary-00=_rt3FLqtov2gnZRd
Content-Type: text/x-csrc;
  charset="iso 8859-15";
  name="lz0p39ha.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lz0p39ha.c"

/*
 * Driver for LZ0P39HA CMOS Image Sensor from Sharp.
 *
 * Copyright (C) 2009, Norbert Roos <n.roos@road.de>
 *
 * The module consists of two parts: The actual sensor, named LZ0P35DU, and
 * the autofocus controller, AD5821 (a D/A converter).
 *
 * Derived from the mt9m001 driver by Guennadi Liakhovetski
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */



#if 0
(Cannot mark this comment with the ordinary comment sign, as there appears an
end-of-comment in this block)

Here is a script to convert a list of register settings of the form

[ADDRESS VALUE] [# comment]

(where ADDRESS and VALUE are in hex format with upper case characters) to a C
array:

#!/bin/bash

bank=00

while read line ; do

	[ "${line:0:1}" = "#" ] && line="- - $line"

	echo "$line" | tr -d \\r | (

		read address value comment

		while [ "${comment:0:1}" = "#" ] ; do
			comment=${comment:1}
		done

		[ ${#address} -gt 2 ] && address=${address:0-2}
		[ -n "$comment" ] && comment="/* $comment */"

		[ "$address" = FF ] && bank=$value

		[ "$address" != "-" -a "$value" != "-" ] && {
			echo "{ 0x$address, 0x$value },	$comment"
		}
	)
done

#endif

#define DEBUG 1

#include <linux/delay.h>
#include <linux/videodev2.h>
#include <linux/i2c.h>
#include <linux/workqueue.h>
#include <linux/platform_device.h>

#include <media/v4l2-common.h>
//#include <media/v4l2-chip-ident.h>
#include <media/soc_camera.h>

/* define USE_CENTRAL_EMPHASIS if the exposure controll with central emphasis 
   is desired*/
/*#define USE_CENTRAL_EMPHASIS

/* when SLOW_FOCUS is defined, during scanning the focus is set and 3 frames
   later the focus value is used; otherwise the scanning is done without the
   delay of 3 frames */

/*#define SLOW_FOCUS*/

/* When SUCCESSIVE_FOCUS_SEARCH is _not_ defined, the search for the best focus
   is done with the simple approach to scan through the whole focus range with
   a fixed number of steps, and finally take the focus setting with the best
   focus value.
   When SUCCESSIVE_FOCUS_SEARCH is defined, searching is performed by splitting
   the whole focus range into three equally large ranges, and the focus is set
   to the center of each range. The best focus value determines the range which
   will be looked at further in the next iteration, where will again be taken
   three samples and so on, untill the desired focus resolution is aquired. */

// #define SUCCESSIVE_FOCUS_SEARCH

#define LEDMODE_FLASH	1
#define LEDMODE_ON	2
#define LEDMODE_OFF	3

static int led_mode = LEDMODE_FLASH;
static void af_start(int);
static void af_stop(void);
static int af_is_auto(void);
static int af_is_scanning(void);
static void af_frame_ready(struct soc_camera_device *);
static void af_update(struct work_struct *);
static void af_set_percent(int);

static struct workqueue_struct *af_workqueue;
static DECLARE_MUTEX(lz0p35du_lock);

/*******************************************************************************


			LZ0P35DU (DSP) related functions


*******************************************************************************/

static struct i2c_client *lz0p35du_i2c_client = 0;
static int lz0p35du_sysfs_installed = 0;

static struct {

	int	address;
	int	value;

} init_sequence[] = {

#include "lz0p39ha_init.c"

};


/* suspend_register contains a list of registers which should be saved during a
   suspend; the values are stored and restored in the given order */

static const int suspend_register[] = {
	0x411,
	0x412,
	0x415,
	0x403,
	0x531,
	0x404,
	0x405,
	0x406,
	0x407,
	0x408,
	0x409,
	0x5c9,
	0x5ca,
	0x5cb,
	0x5cc,
	0x5cd,
	0x5ce,
	0x59B,
	0x59C,
	0x59E,
	0x580,
	0x585,
	0x58C,
	0x58D,
	0x58E,
	0x58F,
	0x590,
	0x597,
	0x598,
	0x419,
	0x423,
	0x428,
	0x418,
	0x5e4,
	0x5e2,
};

/* i2c addresses (including R/W LSB):
 *	0xc0 DSP
 *	0x18 Focus
 *
 * The platform has to define i2c_board_info
 * and call i2c_register_board_info() */


static const struct soc_camera_data_format lz0p35du_colour_formats[] = {
	{
		.name		= "RGB565",
		.depth		= 16,
		.fourcc		= V4L2_PIX_FMT_RGB565,
		.colorspace	= V4L2_COLORSPACE_SRGB,
	}, {
		.name		= "YUYV",
		.depth		= 16,
		.fourcc		= V4L2_PIX_FMT_YUYV,
		.colorspace	= V4L2_COLORSPACE_SRGB,
	}
};

struct lz0p35du {
	struct i2c_client *client;
	struct soc_camera_device icd;
	struct work_struct work;
#warning Kommentar anpassen
	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
	int flash_enabled;
	int flash_active;
	int width;
	int height;
	int zoom;
	int suspend_value[ARRAY_SIZE(suspend_register)];
};

static int dump_registers(void)
{
	int i;
	int bank = 0;

	/* THIS MUST BE KEPT SYNCHRONIZED:

	   When the camera gets register dumped, the GPIO settings for the
	   flash get overwritten; thus 'led_mode' must be adjusted to the
	   initialization sequence settings - when the initialization sequence
	   changes in the flash GPIO settings, 'led_mode' must be updated here,
	   too!

	   A different approach would be to not dump the flash GPIO registers
	   at all. */

	led_mode = LEDMODE_FLASH;

	down(&lz0p35du_lock);
	for (i = 0; i < ARRAY_SIZE(init_sequence); i++) {

		if (init_sequence[i].address == 0xff &&
					init_sequence[i].value == 0xff) {

			/* special encoding for 1ms sleep */

			msleep(1);
		} else {
			if (i2c_smbus_write_byte_data(lz0p35du_i2c_client,
						init_sequence[i].address,
						init_sequence[i].value) < 0) {
				printk(KERN_ERR "I2C write failed (dump) "
					"Register 0x%02x.\n",
					init_sequence[i].address);
				up(&lz0p35du_lock);
				return -1;
			}

			if (init_sequence[i].address == 0xff)
				bank = init_sequence[i].value;
		}

		if (bank == 0x07 && init_sequence[i].address == 0x04)
			msleep(1);	// after PLL enabling
	}
	up(&lz0p35du_lock);

	return 0;
}


static int lz0p35du_read(const u16 reg)
{
	int ret;

	down(&lz0p35du_lock);
	ret = i2c_smbus_write_byte_data(lz0p35du_i2c_client, 0xff, reg >> 8);

	if (ret < 0) {
		up(&lz0p35du_lock);
		return ret;
	}

	ret = i2c_smbus_read_byte_data(lz0p35du_i2c_client, reg & 0xff);

	up(&lz0p35du_lock);
	return ret;
}


static int lz0p35du_write(const u16 reg, const u8 data)
{
	int ret;

	down(&lz0p35du_lock);
	ret = i2c_smbus_write_byte_data(lz0p35du_i2c_client, 0xff, reg >> 8);

	if (ret < 0) {
		up(&lz0p35du_lock);
		return ret;
	}

	ret = i2c_smbus_write_byte_data(lz0p35du_i2c_client, reg & 0xff, data);

	up(&lz0p35du_lock);
	return ret;
}


static int lz0p35du_init(struct soc_camera_device *icd)
{
	if (dump_registers() < 0)
		return -EIO;

	return 0;
}

static int lz0p35du_release(struct soc_camera_device *icd)
{
	// enable soft-standby, but leave clock generation as it is (which is
	// actually not required as capturing is disabled anyway, but it's the
	// correct way, maybe)

	lz0p35du_write(0x0718, 0x97);
	return 0;
}

static int lz0p35du_start_capture(struct soc_camera_device *icd)
{
	return 0;
}

static int lz0p35du_stop_capture(struct soc_camera_device *icd)
{
	af_stop();
	return 0;
}

static int lz0p35du_set_bus_param(struct soc_camera_device *icd,
				 unsigned long flags)
{
	if ((flags & SOCAM_DATAWIDTH_MASK) != SOCAM_DATAWIDTH_8)
		return -EINVAL;

	return 0;
}

static unsigned long lz0p35du_query_bus_param(struct soc_camera_device *icd)
{
	icd->buswidth = 8;

	return SOCAM_PCLK_SAMPLE_FALLING |
		SOCAM_HSYNC_ACTIVE_HIGH |
		SOCAM_VSYNC_ACTIVE_HIGH |
		SOCAM_MASTER |
		SOCAM_DATAWIDTH_8;
}

static void updateResize(struct lz0p35du *lz0p35du)
{
	int	hfac,
		vfac,
		fac;

	/* - calculate the horizontal resize factor
	   - calculate the vertical resize factor
	   - use the one closer to the scaling factor 1, resulting in a
	     minimally shrinked picture

	   If the requested aspect ratio is not 1600/1200, the resized
	   picture size exceeds the requested size either horizontally or
	   vertically. This extra size will be clipped in the next step.
	*/

	hfac = 1600 * 1024 * 10 / (lz0p35du->width * lz0p35du->zoom);
	vfac = 1200 * 1024 * 10 / (lz0p35du->height * lz0p35du->zoom );
	fac = hfac < vfac ? hfac : vfac;

	if (fac < 1024)
		fac = 1024;

	/* some resize factors are not allowed, round them up */

	switch (fac & 0x3ff8) {

	case 0x07f8:
	case 0x0ff8:
	case 0x1ff8:
	case 0x3ff8:
		fac = (fac + 8) & 0xfff8;
		break;

	default:
		break;
	}
/*	printk(KERN_ERR "FAC: %d, FAC411: %d, FAC412: %d\n",fac,(fac & 0x3f00) >> 8,fac & 0xff);*/

	lz0p35du_write(0x411, (fac & 0x3f00) >> 8);
	lz0p35du_write(0x412, fac & 0xff);
	lz0p35du_write(0x415, 0x7);
}

static int lz0p35du_set_fmt_cap(struct soc_camera_device *icd,
		__u32 pixfmt, struct v4l2_rect *rect)
{
	int	tmp,tmp_h,tmp_l,tmp_a,
		hmin,
		hmax,
		vmin,
		vmax;
	int pixelcount;
#ifdef USE_CENTRAL_EMPHASIS	
	int	tmpwidth,
		tmphight;
	char	cEights;
#endif
	char divider2,divider6,divider7,divider8,divider11,divider12;
	struct lz0p35du *lz0p35du = container_of(icd, struct lz0p35du, icd);

	switch (pixfmt) {

	case V4L2_PIX_FMT_RGB565:

		lz0p35du_write(0x403, 0x11);	/* Format: RGB */
		lz0p35du_write(0x531, 0x0C);	/* swap byte order */
		break;

	case V4L2_PIX_FMT_YUYV:

		lz0p35du_write(0x403, 0x00);	/* Format: YUV */
		lz0p35du_write(0x531, 0x04);	/* don't swap byte order */
		break;

	default:
		return -EINVAL;
	}

	/* Resize the picture */
	dev_dbg(&icd->dev, "Setting width: %d, height: %d\n",rect->width,rect->height);

	lz0p35du->width = rect->width;
	lz0p35du->height = rect->height;
	updateResize(lz0p35du);

	/* Set output size */
	dev_dbg(&icd->dev, "Setting output still mode\n");

	tmp = (rect->width >> 8) & 0x07;
	tmp = tmp << 4;
	tmp = tmp | ((rect->height >> 8) & 0x07);
	lz0p35du_write(0x404, tmp);/*still mode x,y[10..8]*/
	lz0p35du_write(0x405, rect->width & 0xff);/*still mode x[7..0]*/
	lz0p35du_write(0x406, rect->height & 0xff);/*still mode y[7..0]*/

	dev_dbg(&icd->dev, "Setting output preview mode\n");
	tmp = (rect->width >> 8) & 0x07;
	tmp = tmp << 4;
	tmp = tmp | ((rect->height >> 8) & 0x07);
	lz0p35du_write(0x407, tmp);/*preview mode x,y[10..8]*/
	lz0p35du_write(0x408, rect->width & 0xff);/*preview mode x[7..0]*/
	lz0p35du_write(0x409, rect->height & 0xff);/*preview mode y[7..0]*/

	/* set the autofocus window; this must not exceed a size of 2^16
	   pixels, and a window of size 256x256 is used */

	if (rect->width <= 256) {
		hmin = 0;
		hmax = rect->width - 1;
	} else {
		hmin = (rect->width - 256) / 2;
		hmax = hmin + 255;
	}

	if (rect->height <= 256) {
		vmin = 0;
		vmax = rect->height - 1;
	} else {
		vmin = (rect->height - 256) / 2;
		vmax = vmin + 255;
	}

	dev_dbg(&icd->dev, "Setting AF min\n");
	tmp = (hmin >> 8) & 0x07;
	tmp = tmp << 4;
	tmp = tmp | ((vmin >> 8) & 0x07);
	lz0p35du_write(0x5c9, tmp);
	lz0p35du_write(0x5ca, hmin & 0xff);
	lz0p35du_write(0x5cb, vmin & 0xff);

	dev_dbg(&icd->dev, "Setting AF max\n");
	tmp = (hmax >> 8) & 0x07;
	tmp = tmp << 4;
	tmp = tmp | ((vmax >> 8) & 0x07);
	lz0p35du_write(0x5cc, tmp);
	lz0p35du_write(0x5cd, hmax & 0xff);
	lz0p35du_write(0x5ce, vmax & 0xff);

	/*read current shutter*/
	tmp_h = lz0p35du_read(0x0613);
	tmp_l = lz0p35du_read(0x0614);
	tmp = (tmp_h << 8) + tmp_l;
	/*compensate longer exposure time*/
	if(!lz0p35du->flash_enabled)
		tmp = tmp / 8;
	else{
		/*TBD AF value depending exposure compensation*/
		tmp = tmp / 16;
	}
	tmp_l = tmp & 0x000000ff;
	tmp_h = (tmp & 0x0000ff00) >> 8;
	/*read current AGC value*/
	tmp_a = lz0p35du_read(0x0615);
	pixelcount = rect->width * rect->height;
	if(76800 >= pixelcount){/* ... 320 x 240*/
		if(!lz0p35du->flash_enabled){/*preview or no flash*/
			/*reset sht_hold_sel, agc_hold_sel*/
			tmp = lz0p35du_read(0x059f) & 0x3F;
			lz0p35du_write(0x59f, tmp);
			/*reset sht_lim_p*/
			lz0p35du_write(0x59b, 0x06);
			lz0p35du_write(0x59c, 0x40);
			/*reset agc limit*/
			lz0p35du_write(0x59e, 0x58);
		}
		else{
			/*limit AGC*/
			lz0p35du_write(0x59d, tmp_a);
			lz0p35du_write(0x59e, tmp_a);
			/*set sht_lim_p 0x059b/c*/
			lz0p35du_write(0x59b, tmp_h);
			lz0p35du_write(0x59c, tmp_l);
			/*set sht_lim_s 0x0599/a*/
			lz0p35du_write(0x599, tmp_h);
			lz0p35du_write(0x59a, tmp_l);
			/*set sht_hold_sel, agc_hold_sel*/
			tmp = lz0p35du_read(0x059f) & 0x3F;
			tmp |= 0xc0;
			lz0p35du_write(0x59f, tmp);
		}
		divider2  = 98;
		divider6  = 15;
		divider7  = 0;
		divider8  = 0;
		divider11 = 13;
		divider12 = 1;
	}
	else if(307200 >= pixelcount){/*320 x 240 ... 640 x 480*/
		/*limit AGC*/
		lz0p35du_write(0x59d, tmp_a);
		lz0p35du_write(0x59e, tmp_a);
		/*set sht_lim_p 0x059b/c*/
		lz0p35du_write(0x59b, tmp_h);
		lz0p35du_write(0x59c, tmp_l);
		/*set sht_lim_s 0x0599/a*/
		lz0p35du_write(0x599, tmp_h);
		lz0p35du_write(0x59a, tmp_l);
		/*set sht_hold_sel, agc_hold_sel*/
		tmp = lz0p35du_read(0x059f) & 0x3F;
		tmp |= 0xc0;
		lz0p35du_write(0x59f, tmp);
		divider2  = 98;
		divider6  = 15;
		divider7  = 4;
		divider8  = 13;
		divider11 = 13;
		divider12 = 1;
	}
	else if(480000 >= pixelcount){/*640 x 480 ... 800 x 600*/
		/*limit AGC*/
		lz0p35du_write(0x59d, tmp_a);
		lz0p35du_write(0x59e, tmp_a);
		/*set sht_lim_p*/
		lz0p35du_write(0x59b, tmp_h);
		lz0p35du_write(0x59c, tmp_l);
		/*set sht_lim_s*/
		lz0p35du_write(0x599, tmp_h);
		lz0p35du_write(0x59a, tmp_l);
		/*set sht_hold_sel, agc_hold_sel*/
		tmp = lz0p35du_read(0x059f) & 0x3F;
		tmp |= 0xc0;
		lz0p35du_write(0x59f, tmp);
		divider2  = 98;
		divider6  = 15;
		divider7  = 4;
		divider8  = 2;
		divider11 = 13;
		divider12 = 1;
	}
	else if(1080000 >= pixelcount){/*800 x 600 ... 1200 x 900*/
		/*limit AGC*/
		lz0p35du_write(0x59d, tmp_a);
		lz0p35du_write(0x59e, tmp_a);
		/*set sht_lim_p*/
		lz0p35du_write(0x59b, tmp_h);
		lz0p35du_write(0x59c, tmp_l);
		/*set sht_lim_s*/
		lz0p35du_write(0x599, tmp_h);
		lz0p35du_write(0x59a, tmp_l);
		/*set sht_hold_sel, agc_hold_sel*/
		tmp = lz0p35du_read(0x059f) & 0x3F;
		tmp |= 0xc0;
		lz0p35du_write(0x59f, tmp);
		divider2  = 98;
		divider6  = 15;
		divider7  = 4;
		divider8  = 3;
		divider11 = 13;
		divider12 = 1;
	}
	else if(1965056 < pixelcount){/* > 1616 x 1216*/
		dev_dbg(&icd->dev, "Camera resolution error; Width: %d, Height: %d\n",rect->width,rect->height);
		return -EINVAL;
	}
	/*set divider values*/
	lz0p35du_write(0x717, 0);
	lz0p35du_write(0x702, divider2);
	lz0p35du_write(0x706, divider6);
	lz0p35du_write(0x707, divider7);
	lz0p35du_write(0x708, divider8);
	lz0p35du_write(0x711, divider11);
	lz0p35du_write(0x712, divider12);
	lz0p35du_write(0x717, 1);

#ifdef USE_CENTRAL_EMPHASIS	
	if((rect->width == 240) &&  (rect->height == 320)){
		lz0p35du_write(0x570, 0x22);
	}
	else if((rect->width == 480) && (rect->height == 640)){
 		lz0p35du_write(0x570, 0x22);
 	}
 	else if((rect->width == 600) && (rect->height == 800)){
		lz0p35du_write(0x570, 0x08);
	}
	else if((rect->width == 900) && (rect->height == 1200)){
		lz0p35du_write(0x570, 0x08);
	}
	else if((rect->width == 1200) && (rect->height == 1600)){
		lz0p35du_write(0x570, 0x08);
	}
	else return -EINVAL;
	/*center emphasis exposure*/
	/*4th of each dimension*/
	tmpwidth = rect->width >> 2;
	tmphight = rect->height>> 2;
	lz0p35du_write(0x580, 0);
	lz0p35du_write(0x585, 0);
	cEights = lz0p35du_read(0x058C);
	cEights &= 0x2A;/*set bit 7 to 0, bits 5, 3, 1 stay unchanged*/
	/*set central area (1/4 TO 3/4 FROM FROM UPPER LEFT)*/
	cEights |= (((tmpwidth >> 2) - 1) & 0x100) >> 2;/*8th bit of left upper X on bit 6*/
	cEights |= (((tmphight >> 2) - 1) & 0x100) >> 4;/*8th bit of left upper Y on bit 4*/
	cEights |= (((((tmpwidth * 3) - 3) >> 2) - 1) & 0x100) >> 6;/*8th bit of right lower X on bit 2*/
	cEights |= (((((tmphight * 3) - 3) >> 2) - 1) & 0x100) >> 8;/*8th bit of right lower Y on bit 0*/
	lz0p35du_write(0x58C, cEights);
	lz0p35du_write(0x58D, ((tmpwidth >> 2) - 1) & 0xFF);/*left upper X*/
	lz0p35du_write(0x58E, ((tmphight >> 2) - 1) & 0xFF);/*left upper Y*/
	lz0p35du_write(0x58F, ((((tmpwidth * 3) - 3) >> 2) - 1) & 0xFF);/*right lower X*/
	lz0p35du_write(0x590, ((((tmphight * 3) - 3) >> 2) - 1) & 0xFF);/*right lower Y*/
#endif

	if (lz0p35du->flash_enabled) {
		tmp = lz0p35du_read(0x418);

		if (tmp < 0) {
			printk(KERN_ERR "lz0p39ha: reading mode failed\n");
		} else {
			tmp |= 0x80;
			lz0p35du_write(0x419, 0x01);	/* flash delay */
			lz0p35du_write(0x423, 0x01);	/* still frames */
			lz0p35du_write(0x428, 0x1c);	/* ctrl mode */
			lz0p35du_write(0x418, tmp);	/* still mode */
			lz0p35du->flash_active = 1;
		}

		lz0p35du->flash_enabled = 0;
	}

	return 0;
}

static int lz0p35du_try_fmt_cap(struct soc_camera_device *icd,
			       struct v4l2_format *f)
{
	switch (f->fmt.pix.pixelformat) {

	case V4L2_PIX_FMT_RGB565:
	case V4L2_PIX_FMT_YUYV:
		break;

	default:
		return -EINVAL;
	}

	if (f->fmt.pix.width > 1600)
		f->fmt.pix.width = 1600;

	if (f->fmt.pix.height > 1200)
		f->fmt.pix.height = 1200;

	return 0;
}

static int lz0p35du_get_chip_id(struct soc_camera_device *icd,
			       struct v4l2_chip_ident *id)
{
	struct lz0p35du *lz0p35du = container_of(icd, struct lz0p35du, icd);

	if (id->match_type != V4L2_CHIP_MATCH_I2C_ADDR)
		return -EINVAL;

	if (id->match_chip != lz0p35du->client->addr)
		return -ENODEV;

	id->ident	= lz0p35du->model;
	id->revision	= 0;

	return 0;
}

static void lz0p35du_flashlight(struct soc_camera_device *icd, int stage,
					int camctrl, int enabled, int opened)
{
	static int is_camera_on = 0;

	if (camctrl) {
		if (opened) {

			/* Strobe LED should be controlled by camera if active,
			   and camera is active:
			   Stage 0: If camera is on, turn off LED
			   Stage 1: LED can be set to 'bright' by another module
			   Stage 2: LED is set to camera controlled strobe */

			if (stage == 0 && is_camera_on)
				lz0p35du_write(0x05e4, 0x00);	/* GPIO: Low */

			if (stage == 2) {
				lz0p35du_write(0x05e2, 0x04);	/* set strobe */
				is_camera_on = 1;
			}
		} else {

			/* Strobe LED should be controlled by camera if active,
			   but camera is not active, so set the LED according to
			   current settings:
			   Stage 0: -
			   Stage 1: LED can be set to 'dark' by another module
			   Stage 2: LED is set to user controlled mode and
				    enabled according to 'enabled' value */

			if (stage == 2) {
				int onoff = enabled ? 0x04 : 0x00;
				lz0p35du_write(0x05e4, onoff);	/* GPIO: L/H */
				lz0p35du_write(0x05e2, 0x05);	/* set GPIO */
				is_camera_on = enabled;
			}
		}
	} else {

		/* Strobe LED should always be user controlled:
		   Stage 0: -
		   Stage 1: LED can be set to 'dark by another module
		   Stage 2: LED is set to user controlled mode and enabled
			    according to 'enabled' value */

		if (stage == 2) {
			int onoff = enabled ? 0x04 : 0x00;
			lz0p35du_write(0x05e4, onoff);	/* GPIO: Low/High */
			lz0p35du_write(0x05e2, 0x05);	/* set GPIO */
			is_camera_on = enabled;
		}
	}
}


static const struct v4l2_queryctrl lz0p35du_controls[] = {
	{
		.id		= V4L2_CID_FOCUS_AUTO,
		.type		= V4L2_CTRL_TYPE_BOOLEAN,
		.name		= "Auto Focus",
		.minimum	= 0,
		.maximum	= 1,
		.step		= 1,
		.default_value	= 1,
	},
	{
		.id		= V4L2_CID_FOCUS_ABSOLUTE,
		.type		= V4L2_CTRL_TYPE_INTEGER,
		.name		= "Manual Focus",
		.minimum	= -1,
		.maximum	= 100,
		.step		= 1,
		.default_value	= 0,
	},
	{
		.id		= V4L2_CID_PRIVATE_BASE,
		.type		= V4L2_CTRL_TYPE_BOOLEAN,
		.name		= "Enable Flash",
		.minimum	= 0,
		.maximum	= 1,
		.step		= 1,
		.default_value	= 0,
	},
	{
		.id		= V4L2_CID_PRIVATE_BASE + 1,
		.type		= V4L2_CTRL_TYPE_INTEGER,
		.name		= "Zoom",
		.minimum	= 10,
		.maximum	= 50,
		.step		= 1,
		.default_value	= 0,
	},
	{
		.id		= V4L2_CID_PRIVATE_BASE + 2,
		.type		= V4L2_CTRL_TYPE_BOOLEAN,
		.name		= "Permanent Light",
		.minimum	= 0,
		.maximum	= 1,
		.step		= 1,
		.default_value	= 0,
	}
};


static int lz0p35du_video_probe(struct soc_camera_device *);
static void lz0p35du_video_remove(struct soc_camera_device *);
static int lz0p35du_suspend(struct soc_camera_device *, pm_message_t);
static int lz0p35du_resume(struct soc_camera_device *);

static int lz0p35du_get_control(struct soc_camera_device *,
							struct v4l2_control *);
static int lz0p35du_set_control(struct soc_camera_device *,
							struct v4l2_control *);

static struct soc_camera_ops lz0p35du_ops = {
	.owner			= THIS_MODULE,
	.probe			= lz0p35du_video_probe,
	.remove			= lz0p35du_video_remove,
	.suspend		= lz0p35du_suspend,
	.resume			= lz0p35du_resume,
	.init			= lz0p35du_init,
	.release		= lz0p35du_release,
	.start_capture		= lz0p35du_start_capture,
	.stop_capture		= lz0p35du_stop_capture,
	.set_fmt_cap		= lz0p35du_set_fmt_cap,
	.try_fmt_cap		= lz0p35du_try_fmt_cap,
	.set_bus_param		= lz0p35du_set_bus_param,
	.query_bus_param	= lz0p35du_query_bus_param,
	.controls		= lz0p35du_controls,
	.num_controls		= ARRAY_SIZE(lz0p35du_controls),
	.get_control		= lz0p35du_get_control,
	.set_control		= lz0p35du_set_control,
	.get_chip_id		= lz0p35du_get_chip_id,
	.frame_ready		= af_frame_ready,
	.flashlight		= lz0p35du_flashlight,
};

static int lz0p35du_get_control(struct soc_camera_device *icd,
						struct v4l2_control *ctrl)
{
	struct lz0p35du *lz0p35du = container_of(icd, struct lz0p35du, icd);

	switch (ctrl->id) {

	case V4L2_CID_FOCUS_AUTO:
		ctrl->value = af_is_auto() || af_is_scanning();
		break;

	case V4L2_CID_FOCUS_ABSOLUTE:
		ctrl->value = 0;
		break;

	case V4L2_CID_PRIVATE_BASE:	/* Enable Flash */
		ctrl->value = lz0p35du->flash_enabled;
		break;

	case V4L2_CID_PRIVATE_BASE + 1:	/* Zoom factor in 1/10 */
		ctrl->value = lz0p35du->zoom;
		break;

	default:
		return -1;
	}

	return 0;
}

static int lz0p35du_set_control(struct soc_camera_device *icd,
						struct v4l2_control *ctrl)
{
	struct lz0p35du *lz0p35du = container_of(icd, struct lz0p35du, icd);

	switch (ctrl->id) {

	case V4L2_CID_FOCUS_AUTO:
		if (ctrl->value && !af_is_auto()) {
			af_start(1);
		} else if (!ctrl->value && af_is_auto()){
			af_stop();
		}
		break;

	case V4L2_CID_FOCUS_ABSOLUTE:	/* Focus value in % */
		if (af_is_auto())
			return -1;

		if (ctrl->value == -1 && ! af_is_scanning()) {
			af_start(0);
			break;
		}

		if (ctrl->value < 0 || ctrl->value > 100)
			return -1;

		af_set_percent(ctrl->value);
		break;

	case V4L2_CID_PRIVATE_BASE:	/* Enable Flash */
		lz0p35du->flash_enabled = ctrl->value ? 1 : 0;
		break;

	case V4L2_CID_PRIVATE_BASE + 1:	/* Zoom factor in 1/10 */
		if (ctrl->value < 10)
			lz0p35du->zoom = 10;
		else if (ctrl->value > 50)
			lz0p35du->zoom = 50;
		else
			lz0p35du->zoom = ctrl->value;

		updateResize(lz0p35du);
		break;

	default:
		return -1;
	}

	return 0;
}

/* Interface active, can use i2c. If it fails, it can indeed mean, that
 * this wasn't our capture interface, so, we wait for the right one */

static int lz0p35du_video_probe(struct soc_camera_device *icd)
{
	struct lz0p35du *lz0p35du = container_of(icd, struct lz0p35du, icd);
	s32 id1;
	s32 id2;

	/* We must have a parent by now. And it cannot be a wrong one.
	 * So this entire test is completely redundant. */

	if (!icd->dev.parent || to_soc_camera_host(icd->dev.parent)->nr !=
								icd->iface)
		return -ENODEV;

	/* check the device id */

	id1 = lz0p35du_read(0x400);
	id2 = lz0p35du_read(0x401);

	if (id1 != 0x51 || id2 != 0x10) {
		printk(KERN_ERR "lz0p39ha_dsp: wrong id or read error\n");
		return -ENODEV;
	}

#warning create V4L identifier
//	lz0p35du->model = V4L2_IDENT_;
	lz0p35du->model = 0;

	/* set color formats */

	icd->formats = lz0p35du_colour_formats;
	icd->num_formats = ARRAY_SIZE(lz0p35du_colour_formats);

	return soc_camera_video_start(icd);
}

static void lz0p35du_video_remove(struct soc_camera_device *icd)
{
	struct lz0p35du *lz0p35du = container_of(icd, struct lz0p35du, icd);

	dev_dbg(&icd->dev, "Video %x removed: %p, %p\n",
			lz0p35du->client->addr, lz0p35du->icd.dev.parent,
			lz0p35du->icd.vdev);
	soc_camera_video_stop(&lz0p35du->icd);
}

static int lz0p35du_suspend(struct soc_camera_device *icd, pm_message_t state)
{
	int i;
	struct lz0p35du *lz0p35du = container_of(icd, struct lz0p35du, icd);

	for (i = 0; i < ARRAY_SIZE(suspend_register); i++)
		lz0p35du->suspend_value[i] = lz0p35du_read(suspend_register[i]);

	return 0;
}

static int lz0p35du_resume(struct soc_camera_device *icd)
{
	int i;
	struct lz0p35du *lz0p35du = container_of(icd, struct lz0p35du, icd);

	dump_registers();

	for (i = 0; i < ARRAY_SIZE(suspend_register); i++)
		lz0p35du_write(suspend_register[i], lz0p35du->suspend_value[i]);

	return 0;
}

static int lz0p35du_probe(struct i2c_client *client,
					 const struct i2c_device_id *did)
{
	struct lz0p35du *lz0p35du;
	struct soc_camera_device *icd;
	struct soc_camera_link *icl = client->dev.platform_data;
	int ret;

	lz0p35du_i2c_client = client;

	if (!icl) {
		dev_err(&client->dev,
				"LZ0P35DU driver needs platform data\n");
		return -EINVAL;
	}

	lz0p35du = kzalloc(sizeof(struct lz0p35du), GFP_KERNEL);

	if (!lz0p35du)
		return -ENOMEM;

	INIT_WORK(&lz0p35du->work, af_update);
	lz0p35du->flash_enabled = 0;
	lz0p35du->flash_active = 0;
	lz0p35du->zoom = 10;		/* Zoom factor in 1/10 */
	lz0p35du->client = client;
	i2c_set_clientdata(client, lz0p35du);

	/* Second stage probe - when a capture adapter is there */

	icd = &lz0p35du->icd;
	icd->ops	= &lz0p35du_ops;
	icd->control	= &client->dev;
	icd->x_min	= 20;
	icd->y_min	= 12;
	icd->x_current	= 20;
	icd->y_current	= 12;
	icd->width_min	= 48;
	icd->width_max	= 1600;
	icd->height_min	= 32;
	icd->height_max	= 1200;
	icd->y_skip_top	= 1;
	icd->iface	= icl->bus_id;

	ret = soc_camera_device_register(icd);

	if (ret)
		goto free_struct;

#if 0
	ret = platform_device_register(&lz0p35du_flashlight_pd);

	if (ret) {
		printk(KERN_ERR "lz0p39ha: Cannot install platform device for "
								"flashlight\n");
		goto remove_device;
	}

//	if (device_create_file(&client->dev, &dev_attr_enable))
//	if (device_create_file(&icd->dev, &dev_attr_enable))
	if (device_create_file(&lz0p35du_flashlight_pd.dev, &dev_attr_enable))
		printk(KERN_ERR "lz0p39ha: Cannot install sysfs stuff (DSP)\n");
	else
		lz0p35du_sysfs_installed = 1;
#endif

	af_workqueue = create_singlethread_workqueue("autofocus");

	return 0;

remove_device:
	soc_camera_device_unregister(icd);

free_struct:
	kfree(lz0p35du);
	return ret;
}

static int lz0p35du_remove(struct i2c_client *client)
{
	struct lz0p35du *lz0p35du = i2c_get_clientdata(client);

#if 0
	if (lz0p35du_sysfs_installed)
		device_remove_file(&client->dev, &dev_attr_enable);

	platform_device_unregister(&lz0p35du_flashlight_pd);
#endif
	soc_camera_device_unregister(&lz0p35du->icd);
	destroy_workqueue(af_workqueue);
	kfree(lz0p35du);

	return 0;
}


/*******************************************************************************


			AD5821 (Autofocus) related functions


*******************************************************************************/

static struct i2c_client *ad5821_i2c_client = 0;
static int ad5821_sysfs_installed = 0;
static int af_value = 0;

static int ad5821_write(u16 val)
{
	unsigned char msgbuf[2];
	int ret;

	if (val >= 0x0400)
		val = 0x3ff;

	val = val << 4;	/* AD5821 expects value in [13:4] */

	msgbuf[0] = (val & 0xff00) >> 8;
	msgbuf[1] = val & 0x00ff;

	if (i2c_master_send(ad5821_i2c_client, msgbuf, 2) != 2)
		return -1;
	else
		return 0;
}


static int ad5821_read(void)
{
	unsigned char msgbuf[2];

	if (i2c_master_recv(ad5821_i2c_client, msgbuf, 2) == 2) {
		return (((msgbuf[0] << 8) | msgbuf[1]) >> 4) & 0x3ff;
	} else {
		printk(KERN_ERR "lz0p39ha: reading AF failed\n");
		return -1;
	}
}


static ssize_t ad5821_show(struct device *dev, struct device_attribute *attr,
								char *buf)
{
	return sprintf(buf, "last set value: 0x%03x, current value: 0x%03x\n",
						af_value, ad5821_read());
}

static ssize_t ad5821_store(struct device *dev, struct device_attribute *attr,
						const char *buf, size_t size)
{
	int val = 0;
	int valid = 0;
	int len;

	if (buf[0] == '0' && buf[1] == 'x') {

		len = size > 5 ? 5 : size;
		len -= 2;
		buf += 2;

		while (len--) {
			if (*buf >= '0' && *buf <= '9') {
				val = (val << 4) | (*buf - '0');
				valid = 1;
			} else if (*buf >= 'a' && *buf <= 'f') {
				val = (val << 4) | (*buf + 10 - 'a');
				valid = 1;
			} else if (*buf >= 'A' && *buf <= 'F') {
				val = (val << 4) | (*buf + 10 - 'A');
				valid = 1;
			} else if (*buf == '\n' || *buf == '\r') {
				break;
			} else {
				valid = 0;
				break;
			}

			buf++;
		}
	} else {
		len = size > 4 ? 4 : size;

		while (len--) {
			if (*buf >= '0' && *buf <= '9') {
				val = val * 10 + *buf - '0';
				valid = 1;
			} else if (*buf == '\n' || *buf == '\r') {
				break;
			} else {
				valid = 0;
				break;
			}

			buf++;
		}
	}

	if (valid && val <= 0x3ff) {
		af_value = val;
		ad5821_write(val);
	}

	return size;
}

DEVICE_ATTR(autofocus, 0644, ad5821_show, ad5821_store);


static int ad5821_probe(struct i2c_client *client,
			 const struct i2c_device_id *did)
{
	ad5821_i2c_client = client;

	if (device_create_file(&client->dev, &dev_attr_autofocus))
		printk(KERN_ERR "lz0p39ha: Cannot install sysfs stuff (AF)\n");
	else
		ad5821_sysfs_installed = 1;

	return 0;
}

static int ad5821_remove(struct i2c_client *client)
{
	if (ad5821_sysfs_installed)
		device_remove_file(&client->dev, &dev_attr_autofocus);

	return 0;
}


/*******************************************************************************


		Autofocus related functions, using both I2C devices


*******************************************************************************/
#define AF_STEPS	5
static int af_setting;
static int af_stepsize;		/* must be a 2^N number, only one bit set! */
static int af_direction = 1;	/* always 1 or -1 */
static int af_last_value;
static int af_track = 0;
static int af_scanthrough = 0;
static int af_waitcnt;
static int af_val[AF_STEPS];
static int af_set[AF_STEPS];
static int af_current_idx;

#ifdef SUCCESSIVE_FOCUS_SEARCH
static int af_iteration;
static int af_min;
static int af_max;
#endif

static void af_start(int track)
{
	af_current_idx = 0;
#ifdef SUCCESSIVE_FOCUS_SEARCH
	af_iteration = 0;
#endif

	if (track) {
		af_track = 1;
		af_scanthrough = 0;
		af_stepsize = 0x40;	/* start value for stepsize with no
								 particular reason for this value */
		af_setting = 0x400 / 2;	/* start in the middle */
		af_waitcnt = 3;

		ad5821_write(af_setting);
	} else {
		af_track = 0;
		af_scanthrough = 1;
		af_last_value = -1;
#ifdef SUCCESSIVE_FOCUS_SEARCH
		af_min = 0;
		af_max = 0x400;
		ad5821_write(0x400 / 6);
#else
		af_set[0] = 0;
#endif
#ifdef SLOW_FOCUS
		af_waitcnt = 3;
#else
		af_waitcnt = 1;
#endif
		ad5821_write(0);
	}
}


static void af_stop()
{
	af_track = 0;
	af_scanthrough = 0;
}

static int af_is_auto()
{
	return af_track;
}

static int af_is_scanning()
{
	return af_scanthrough;
}

static void af_set_percent(int percent)
{
	ad5821_write(0x3ff * percent / 100);
}

static void af_frame_ready(struct soc_camera_device *icd)
{
	struct lz0p35du *lz0p35du = container_of(icd, struct lz0p35du, icd);
	queue_work(af_workqueue, &lz0p35du->work);
}


static void af_update(struct work_struct *ptr)
{
	int current_af_value = 0;
	int val;
	int addr;
	int restart;
	int stepsize;
#ifdef DEBUG
	int sh_out15_8,sh_out7_0,sh_out;
#endif

	struct lz0p35du *lz0p35du = container_of(ptr, struct lz0p35du, work);

	if (lz0p35du->flash_active) {
		lz0p35du->flash_active = 0;
		val = lz0p35du_read(0x418);

		if (val < 0) {
			printk(KERN_ERR "lz0p39ha: reading mode failed\n");
		} else {
			val = val & 0x7f;
			lz0p35du_write(0x418, val);
		}
	}

	if (!af_track && ! af_scanthrough){
#ifdef DEBUG
		sh_out15_8 = lz0p35du_read(0x0613);
		sh_out7_0 = lz0p35du_read(0x0614);
		sh_out = 0;
		sh_out = (sh_out15_8 << 8) + sh_out7_0;
		printk(KERN_ERR "sh_out (SH_Foto): %d\n",sh_out);
		sh_out15_8 = lz0p35du_read(0x0611);
		sh_out7_0 = lz0p35du_read(0x0612);
		sh_out = 0;
		sh_out = (sh_out15_8 << 8) + sh_out7_0;
		printk(KERN_ERR "sh_out (FL_Foto): %d\n",sh_out);
#endif
		return;
	}
	if (af_scanthrough) {
		if (af_waitcnt-- > 0)
			return;
	}

	/* read current AF value from DSP */

	for (addr = 0x0619; addr <= 0x061B; addr++) {

		val = lz0p35du_read(addr);

		if (val < 0)
			break;

		current_af_value = (current_af_value << 8) | val;
	}

	/* only if val >= 0, all three bytes of the automatic focus data could
	   be read and are valid */

	if (val < 0) {
		printk(KERN_ERR "lz0p39ha: reading autofocus data failed\n");
		return;
	}

	if (af_scanthrough) {
#ifdef SLOW_FOCUS
		af_waitcnt = 3;
#else
		af_waitcnt = 1;
#endif
		af_val[af_current_idx] = current_af_value;
#ifdef DEBUG
		printk(KERN_ERR "AF-Step: %d, AF-Value: %d\n",af_current_idx, current_af_value);
		sh_out15_8 = lz0p35du_read(0x0613);
		sh_out7_0 = lz0p35du_read(0x0614);
		sh_out = 0;
		sh_out = (sh_out15_8 << 8) + sh_out7_0;
		printk(KERN_ERR "sh_out (AF): %d\n",sh_out);
#endif
#ifdef SUCCESSIVE_FOCUS_SEARCH
		if (af_current_idx == 3) {
			/* if all focus values are the same, stay in the */
			/* middle of the checked range */

			int max_val = af_val[1];
			int max_idx = 1;
			int offset;
			int i;

			af_iteration++;

			for (i = 0; i < 3; i++) {
				if (af_val[i] > max_val) {
					max_val = af_val[i];
					max_idx = i;
				}
			}

			if (af_iteration == 3) {
				ad5821_write(af_set[max_idx]);
				af_scanthrough = 0;
				return;
			}

			offset = (af_max - af_min) / 6;
			af_min = af_set[max_idx] - offset;
			af_max = af_set[max_idx] + offset;
			af_current_idx = 0;
		} else {
			af_current_idx++;
		}

		stepsize = (af_max - af_min) / 3;
		af_set[af_current_idx] = af_min +
					(af_current_idx + 1) * stepsize -
					stepsize / 2;
		ad5821_write(af_set[af_current_idx]);
#else
		if (af_current_idx == AF_STEPS-1) {
// 		if (af_current_idx == 9) {

			int i, max_val = 0, max_set = 0;

			for (i = 0; i < AF_STEPS; i++) {
				if (af_val[i] > max_val) {
					max_val = af_val[i];
					max_set = af_set[i];
				}
			}

			printk(KERN_ERR "max value = 0x%08x, setting = %d\n",
							max_val, max_set);
			ad5821_write(max_set);
			af_scanthrough = 0;
		} else {
			af_current_idx++;
			af_set[af_current_idx] = af_current_idx * (0x400 / AF_STEPS);
			ad5821_write(af_set[af_current_idx]);
		}
#endif
	}

	if (af_track) {
		if (--af_waitcnt)
			return;

		af_waitcnt = 3;
		restart = 0;

		if (af_last_value == -1) {
			/* still initializing, just remember the current af
			   value and continue after the next frame */

			af_last_value = current_af_value;
			return;

		} else if (af_last_value < current_af_value) {

			/* check if there was a big change in the value; if so,
			   restart focusing */

			if (current_af_value - af_last_value > 5 &&
							af_last_value * 100 /
							current_af_value < 50) {
				af_direction = -af_direction;
				restart = 1;
			} else {

				/* we are moving to the wrong direction */

				af_direction = -af_direction;
				af_stepsize = af_stepsize >> 1;

				if (af_stepsize == 0)
					af_stepsize = 1;
			}
		} else if (af_last_value > current_af_value) {

			/* check if there was a big change in the value; if so,
			   restart focusing */

			if (af_last_value - current_af_value > 5 &&
							current_af_value * 100 /
							af_last_value < 50) {
				restart = 1;
			} else {

				/* we are moving to the correct direction */

				af_stepsize = af_stepsize << 1;

				if (af_stepsize > 0x80)
					af_stepsize = 0x80;
			}
		} else {

			/* optimum reached, set step size to minimum */

			af_stepsize = 1;
		}

		if (restart) {
			af_setting = 0x200;
			af_stepsize = 0x40;
		} else {
			af_setting = af_setting + (af_stepsize * af_direction);

			if (af_setting < 0) {
				af_setting = 0;
				af_direction = -af_direction;
				af_stepsize = 1;
			}

			if (af_setting > 0x3ff) {
				af_setting = 0x3ff;
				af_direction = -af_direction;
				af_stepsize = 1;
			}
		}

		af_last_value = current_af_value;

		ad5821_write(af_setting);
	}
}


/*******************************************************************************


			module related functions and structures


*******************************************************************************/

static const struct i2c_device_id lz0p39ha_id[] = {
	{ "lz0p39ha_dsp", 0 },
	{ }
};

MODULE_DEVICE_TABLE(i2c, lz0p39ha_id);

static struct i2c_driver lz0p35du_i2c_driver = {
	.driver = {
		.name = "lz0p39ha_dsp",
	},
	.probe		= lz0p35du_probe,
	.remove		= lz0p35du_remove,
	.id_table	= lz0p39ha_id,
};

static const struct i2c_device_id ad5821_id[] = {
	{ "lz0p39ha_af", 0 },
	{ }
};

MODULE_DEVICE_TABLE(i2c, ad5821_id);

static struct i2c_driver ad5821_i2c_driver = {
	.driver = {
		.name = "lz0p39ha_af",
	},
	.probe		= ad5821_probe,
	.remove		= ad5821_remove,
	.id_table	= ad5821_id,
};

static int __init lz0p39ha_mod_init(void)
{
	int ret;

	ret = i2c_add_driver(&lz0p35du_i2c_driver);

	if (ret) {
		printk(KERN_ERR "lz0p39ha: Cannot install DSP driver\n");
		return ret;
	}

	ret = i2c_add_driver(&ad5821_i2c_driver);

	if (ret) {
		printk(KERN_ERR "lz0p39ha: Cannot install AF driver\n");
		i2c_del_driver(&lz0p35du_i2c_driver);
		return ret;
	}

	return 0;
}

static void __exit lz0p39ha_mod_exit(void)
{
	i2c_del_driver(&lz0p35du_i2c_driver);
	i2c_del_driver(&ad5821_i2c_driver);
}

module_init(lz0p39ha_mod_init);
module_exit(lz0p39ha_mod_exit);

MODULE_DESCRIPTION("Sharp LZ0P39HA Camera driver");
MODULE_AUTHOR("Norbert Roos <n.roos@road.de>");
MODULE_LICENSE("GPL");


--Boundary-00=_rt3FLqtov2gnZRd
Content-Type: text/x-csrc;
  charset="utf-8";
  name="lz0p39ha_init.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="lz0p39ha_init.c"

/* modified init sequence in mail from 23.2.2008 */

#if 1
#define USE_YUV
#else
#define USE_RGB
#endif

/*
#I2C
# C0
#I2CS
# 7F
#ImageSize
# 1600
# 1200
# 0
#kimcmd I2C C0
#kimcmd I2CS 1A
#kimcmd ImageSize 1600 1200 UYVY(8bit)
#
*/

	{ 0xFF, 0x05 },	/* #BANK 05 */
	{ 0xEF, 0x00 },	/* noise filter of I2C */
	{ 0xFF, 0x07 },	/* BANK 07 */
	{ 0x18, 0x90 },	/* 0718 E_EXCLK,-,-,SOFT_STDBY,SEN_CLK_RSTX,SEN_RSTX,
							TG_RSTX,DSP_RSTX */
	{ 0x18, 0x80 },	/* 0718 E_EXCLK,-,-,SOFT_STDBY,SEN_CLK_RSTX,SEN_RSTX,
							TG_RSTX,DSP_RSTX */
			/* 0700 -,-,-,TG_BYPASS,-,-,PLL_SELLOCK,PLL_SELOUT */
	{ 0x01, 0x02 },	/* 0701 -,-,-,-,-,PLL_L[2:0] GEHT*/
/*	{ 0x01, 0x04 },	/* 0701 -,-,-,-,-,PLL_L[2:0] ORG*/
/*	{ 0x02, 0x6A },	/* 0702 PLL_N[7:0] (15fps)*/
	{ 0x02, 0x62 },	/* 0702 PLL_N[7:0] (15fps) GEHT*/
/*	{ 0x02, 0x5C },	/* 0702 PLL_N[7:0] (15fps)*/
/*	{ 0x02, 0x35 },	/* 0702 PLL_N[7:0] (7,5fps) ORG*/
	{ 0x03, 0x00 },	/* 0703 -,-,-,-,-,-,PLL_GAIN[1:0] */
			/* 0704 -,-,-,-,-,-,-,PLL_EN */
			/* 0705 (Read only) -,-,-,-,-,-,-,PLL_LOCK */
	{ 0x06, 0x0F },	/* 0706 -,-,-,-,RATIO_TG[3:0] GEHT*/
/*	{ 0x06, 0x03 },	/* 0706 -,-,-,-,RATIO_TG[3:0] */
/*	{ 0x06, 0x01 },	/* 0706 -,-,-,-,RATIO_TG[3:0] ORG*/
	{ 0x07, 0x00 },	/* 0707 -,-,-,-,RATIO_T[3:0] GEHT*/
/*	{ 0x07, 0x03 },	/* 0707 -,-,-,-,RATIO_T[3:0] */
/*	{ 0x07, 0x07 },	/* 0707 -,-,-,-,RATIO_T[3:0] ORG*/
	{ 0x08, 0x00 },	/* 0708 -,-,-,-,-,RATIO_R[2:0], for CulumAD 40MHz  GEHT*/
/*	{ 0x08, 0x03 },	/* 0708 -,-,-,-,-,RATIO_R[2:0], for CulumAD 40MHz  */
/*	{ 0x08, 0x07 },	/* 0708 -,-,-,-,-,RATIO_R[2:0], for CulumAD 40MHz  ORG*/
	{ 0x09, 0x03 },	/* 0709 -,-,-,-,-,-,RAMP_EN,TGCLK_EN */
	{ 0x0A, 0x00 },	/* 070A -,-,-,-,DLY_TGCLK[3:0] */
	{ 0x0B, 0x00 },	/* 070B -,-,-,-,DLY_RAMPCLK[3:0] */
			/* 070C BONUS1 */
			/* 070D BONUS2 */
			/* 070E -,-,-,-,-,-,-,- */
			/* 070F -,-,-,-,-,-,-,- */
	{ 0x10, 0x00 },	/* 0710 -,SEN_PIX_SEL,HS_O_SEL,DSP_BYPASS,BONUS0[3:0] */
	{ 0x11, 0x0D },	/* 0711 -,-,-,-,RATIO_OP[3:0] GEHT*/
/*	{ 0x11, 0x0B },	/* 0711 -,-,-,-,RATIO_OP[3:0] */
/*	{ 0x11, 0x01 },	/* 0711 -,-,-,-,RATIO_OP[3:0] ORG*/
	{ 0x12, 0x01 },	/* 0712 -,-,-,-,RATIO_O[3:0] GEHT*/
/*	{ 0x12, 0x03 },	/* 0712 -,-,-,-,RATIO_O[3:0] ORG */
			/* 0713 -,-,-,-,-,-,OCLKSEL,OCLK_EN */
			/* 0714 PCKEN_SHD,PCKEN_FL,PCKEN_AF,PCLKEN_RGB,
				PCKEN_IRIS,PCKEN_AW,PCKEN_OB,PCKEN_CAD */
			/* 0715 OCKEN_YSYS,OCKEN_RSZ,OCKEN_DLY,OCKEN_ROD,
				PCKEN_MCTL,PCKEN_ROD,PCKEN_GAM,PCKEN_WB */
			/* 0716 OCKEN_YSYS,OCKEN_RSZ,OCKEN_DLY,OCKEN_ROD,
				PCKEN_MCTL,PCKEN_ROD,PCKEN_GAM,PCKEN_WB */
			/* 0717 -,-,-,-,-,-,-,CLKRSTX */
			/* 0718 E_EXCLK,-,-,SOFT_STDBY,SEN_CLK_RSTX,SEN_RSTX,
							TG_RSTX,DSP_RSTX */
	{ 0x19, 0x00 },	/* 0719 DLY_PIX2[3:0],DLY_PIX1[3:0] */
	{ 0x1A, 0x00 },	/* 071A DLY_PIX4[3:0],DLY_PIX3[3:0] */
	{ 0x1B, 0x00 },	/* 071B DLY_O1[3:0],DLY_PIX5[3:0] */
	{ 0x1C, 0x00 },	/* 071C DLY_O3[3:0],DLY_O2[3:0] */
	{ 0x1D, 0x00 },	/* 071D DLY_OX2[3:0],DLY_O4[3:0] */
	{ 0x1E, 0xFF },	/* 071E BONUS1 */
	{ 0x1F, 0xFF },	/* 071F BONUS1 */
	{ 0x00, 0x02 },	/* 0700 -,-,-,TG_BYPASS,-,-,PLL_SELLOCK,PLL_SELOUT */
	{ 0x18, 0x84 },	/* 0718 E_EXCLK,-,-,SOFT_STDBY,SEN_CLK_RSTX,SEN_RSTX,
							TG_RSTX,DSP_RSTX */
	{ 0x04, 0x01 },	/* 0704 -,-,-,-,-,-,-,PLL_EN */
	{ 0xFF, 0xFF },	/* wait 1ms (special encoding...) */
	{ 0x17, 0x01 },	/* 0717 -,-,-,-,-,-,-,CLKRSTX */
	{ 0x10, 0x01 },	/* 0710 -,SEN_PIX_SEL,HS_O_SEL,DSP_BYPASS,BONUS0,
								VCO_EN */
/*	{ 0x13, 0x03 },	/* 0713 -,-,-,-,-,-,OCLKSEL,OCLK_EN */
	{ 0x13, 0x01 },	/* 0713 -,-,-,-,-,-,OCLKSEL,OCLK_EN */
	{ 0x14, 0xFF },	/* 0714 PCKEN_SHD,PCKEN_FL,PCKEN_AF,PCLKEN_RGB,
				PCKEN_IRIS,PCKEN_AW,PCKEN_OB,PCKEN_CAD */
	{ 0x15, 0xFF },	/* 0715 OCKEN_YSYS,OCKEN_RSZ,OCKEN_DLY,OCKEN_ROD,
				PCKEN_MCTL,PCKEN_ROD,PCKEN_GAM,PCKEN_WB */
	{ 0x16, 0x1F },	/* 0716 OCKEN_YSYS,OCKEN_RSZ,OCKEN_DLY,OCKEN_ROD,
				PCKEN_MCTL,PCKEN_ROD,PCKEN_GAM,PCKEN_WB */
	{ 0xFE, 0x02 },
	{ 0xFF, 0x10 },	/* BANK 10 */
	{ 0xBF, 0x69 },	/* 10BF I2CS_FSEL(Filter1 ON) */
	{ 0xFF, 0x04 },	/* BANK4 */
			/* 0400 (Read only) DEV_CODE */
			/* 0401 (Read only) DEV_CODE2 */
			/* 0402 -,-,-,-,-,-,-,- */
	{ 0x03, 0x00 },	/* 0403 -,OUT_SEL_S-,OUT_SEL_P  */
	{ 0x04, 0x64 },	/* 0404 -,X_OUTPUT_SIZE_S[10:8],-,
							Y_OUTPUT_SIZE_S[10:8] */
	{ 0x05, 0x40 },	/* 0405 X_OUTPUT_SIZE_S[7:0] */
	{ 0x06, 0xB0 },	/* 0406 Y_OUTPUT_SIZE_S[7:0] */
	{ 0x07, 0x64 },	/* 0407 -,X_OUTPUT_SIZE_P[10:8],-,
							Y_OUTPUT_SIZE_P[10:8] */
	{ 0x08, 0x40 },	/* 0408 X_OUTPUT_SIZE_P[7:0] */
	{ 0x09, 0xB0 },	/* 0409 Y_OUTPUT_SIZE_P[7:0] */
	{ 0x0A, 0x08 },	/* 040A LINE_LENGTH_PCK_S[15:8] (2100) */
	{ 0x0B, 0x34 },	/* 040B LINE_LENGTH_PCK_S[7:0] */
	{ 0x0C, 0x08 },	/* 040C LINE_LENGTH_PCK_P[15:8] (2100) */
	{ 0x0D, 0x34 },	/* 040D LINE_LENGTH_PCK_P[7:0] */
	{ 0x0E, 0x00 },	/* 040E RESIZE_N */
	{ 0x0F, 0x01 },	/* 040F RESIZE_N_STEP */
	{ 0x10, 0x20 },	/* 0410 RESIZE_STEP */
	{ 0x11, 0x04 },	/* 0411 -,-,RESIZE_HOLD[13:8] */
	{ 0x12, 0x00 },	/* 0412 RESIZE_HOLD[7:0] */
	{ 0x13, 0x00 },	/* 0413 H_OBEN_OFS */
	{ 0x14, 0x00 },	/* 0414 V_OBEN_OFS */
	{ 0x15, 0x01 },	/* 0415 MCTL_BONUS1,RESIZE_JUMP,RESIZE_HOLD_SEL,
							RESIZE_GO,INC_TYPE */
	{ 0x16, 0x01 },	/* 0416 MCTL_BONUS2,WAIT_FRAME_NUM */
	{ 0x17, 0x00 },	/* 0417 FRAME_MASK_CO,MASTER_REG_UP_CO */
	{ 0x18, 0x01 },	/* 0418 STILL_MODE,STILL_AWB_AUYO,STILL_IRIS_AUTO,
					STILL_IRIS_HOLD,FRAME_REGUP_CO */
/*	{ 0x19, 0x00 },	/* 0419 GS F_CO,FLASH_F_CO */
	{ 0x19, 0x01 },	/* changed by NR */
	{ 0x1A, 0x00 },	/* 041A FLASH_V_CO[15:8] */
	{ 0x1B, 0x00 },	/* 041B FLASH_V_CO[7:0] */
	{ 0x1C, 0x00 },	/* 041C GS V_CO[15:8] */
	{ 0x1D, 0x00 },	/* 041D GS V_CO[7:0] */
	{ 0x1E, 0x64 },	/* 041E -,X_SENSOR_SIZE[10:8],-,Y_SENSOR_SIZE[10:8] */
	{ 0x1F, 0x70 },	/* 041F X_SENSOR_SIZE[7:0] */
	{ 0x20, 0xD8 },	/* 0420 Y_SENSOR_SIZE[7:0] */
	{ 0x21, 0x00 },	/* 0421 X_OFFSET_OFS */
	{ 0x22, 0x00 },	/* 0422 Y_OFFSET_OFS */
	{ 0x23, 0x01 },	/* 0423 SIM_MODE,-,-,STILL_FRAME_NUM */
	{ 0x24, 0x00 },	/* 0424 -,-,-,-,-,-,WB_MODE */
	{ 0x25, 0xFF },	/* 0425 INC_USE_SEL[15:8] */
	{ 0x26, 0xFF },	/* 0426 INC_USE_SEL[7:0] */
/*	{ 0x27, 0xA4 },	/* 0427 APT_EN_SEL,MC_PULSE_SEL,STILL_CTRL_MODE,
					MODE_MASK,MIR_FLAG_INV,MIR_MODE*/
	{ 0x27, 0x84 },	/* changed by NR */
/*	{ 0x28, 0x00 },	/* 0428 GS_CTRL_MODE,TG_MANUAL_MODE,INIT_START */
	{ 0x28, 0x1C },	/* changed by NR */
	{ 0x29, 0xFF },	/* 0429 SCALE2_LEV,SCALE1_LEV */
	{ 0x2A, 0x0F },	/* 042A -,-,-,-,SCALE4_LEV */
	{ 0x2B, 0x00 },	/* 042B -,-,-,RD_START[12:8] */
	{ 0x2C, 0x00 },	/* 042C RD_START[7:0] */
	{ 0x2D, 0xF0 },	/* 042D SUNSPOT_H1[7:0] 13Nov06 */
	{ 0x2E, 0x00 },	/* 042E SUNSPOT_H2[7:0] 13Nov06 */
	{ 0x2F, 0x50 },	/* 042F SUNSPOT_LEV     14Nov06 */
	{ 0x30, 0xF5 },	/* 0430 SUNSPOT_H2[9:8],SUNSPOT_H1[9:8],CAD_RESERVE1,
								VOB_ST */
	{ 0x31, 0x16 },	/* 0431 CAD_RESERVE2,VOB_ED */
	{ 0x32, 0x20 },	/* 0432 HOT_PIXEL */
	{ 0x33, 0x00 },	/* 0433 BLK_CONST */
	{ 0x34, 0xC8 },	/* 0434 BAYER_SCALING_TYPE,SCALING_MODE,
					SPATIAL_SAMPLING,CLK_TH,-,-,BLK_ST */
	{ 0x35, 0x40 },	/* 0435 BLACK_LEVEL */
			/* 0436 (Read only) -,-,-,-,-,-,OB_AVRG[9:8] */
			/* 0437 (Read only) OB AVRG[7:0] */
	{ 0x38, 0x00 },	/* 0438 DSP_LINT1_CO[15:8] */
	{ 0x39, 0x00 },	/* 0439 DSP_LINT1_CO[7:0] */
	{ 0x3A, 0x00 },	/* 043A DSP_LINT2_CO[15:8] */
	{ 0x3B, 0x00 },	/* 043B DSP_LINT2_CO[7:0] */
	{ 0x3C, 0x08 },	/* 043C H_OB_NUM_CO */
	{ 0x3D, 0x08 },	/* 043D V_OB_NUM_CO */
	{ 0x3E, 0x80 },	/* 043E OB BONUS1,MASTER_MODE3_SEL,AUTO_RUN,CA_HOLD,
						CA_SEL,TH_MODE,OBCP_TH */
	{ 0x3F, 0xFF },	/* 043F DIN_LIM */
	{ 0x40, 0x00 },	/* 0440 KCBR */
	{ 0x41, 0x00 },	/* 0441 KCBB */
	{ 0x42, 0x00 },	/* 0442 KCBG1 */
	{ 0x43, 0x00 },	/* 0443 KCBG2 */
	{ 0x44, 0x00 },	/* 0444 INC_DATA_SEL,OB_BONUS2,INV_SIG */
	{ 0x45, 0x83 },	/* 0445 OB BONUS3 */
	{ 0x46, 0x00 }, /* 0446 OB BONUS4 */
	{ 0x47, 0x0C },	/* 0447 LEV_Gr_W1 */
	{ 0x48, 0x20 },	/* 0448 LEV_Gr_W2 */
	{ 0x49, 0xff },	/* 0449 LEV_Gr_W3 */
	{ 0x4A, 0xF0 },	/* 044A LEV_Gr_B1 */
	{ 0x4B, 0x04 },	/* 044B LEV_Gr_B2 */
	{ 0x4C, 0x18 },	/* 044C LEV_Gr_B3 */
	{ 0x4D, 0x08 },	/* 044D LEV_R_W1 */
	{ 0x4E, 0x20 },	/* 044E LEV_R_W2 */
	{ 0x4F, 0xff },	/* 044F LEV_R_W3 */
	{ 0x50, 0xF0 },	/* 0450 LEV_R_B1 */
	{ 0x51, 0x04 },	/* 0451 LEV_R_B2 */
	{ 0x52, 0x10 },	/* 0452 LEV_R_B3 */
	{ 0x53, 0x04 },	/* 0453 PRE_SKIP_OFF,CAL2_TH_W */
	{ 0x54, 0x7C },	/* 0454 CAL2_TH_B */
	{ 0x58, 0xFD },	/* 0458 MTX_G_R */
	{ 0x59, 0xFC },	/* 0459 MTX_B_G */
	{ 0x5A, 0xFE },	/* 045A MTX_B_R */
	{ 0x5B, 0xFC },	/* 045B MTX_R_G */
	{ 0x5C, 0xFC },	/* 045C MTX_G_B */
	{ 0x5D, 0xFB },	/* 045D MTX_R_B */
	{ 0x5E, 0x4A },	/* 045E MTX_R_R */
	{ 0x5F, 0x40 },	/* 045F MTX_G_G */
	{ 0x60, 0x46 },	/* 0460 MTX_B_B */
	{ 0x61, 0x80 },	/* 0461 MTX_REGRSTX,-,INV_SIG_V,INV_SIG_H,-,-,RGBMTX_TH,
								RGBMTX_OFF */
	{ 0x62, 0x00 },	/* 0462 RGBMTX_BONUS */
	{ 0x63, 0x08 },	/* 0463 LEV_B_W1 */
	{ 0x64, 0x20 },	/* 0464 LEV_B_W2 */
	{ 0x65, 0xff },	/* 0465 LEV_B_W3 */
	{ 0x66, 0xF0 },	/* 0466 LEV_B_B1 */
	{ 0x67, 0x04 },	/* 0467 LEV_B_B2 */
	{ 0x68, 0x10 },	/* 0468 LEV_B_B3 */
	{ 0x69, 0x03 },	/* 0469 */
	{ 0x6A, 0xFF },	/* 046A */
			/* 0470 (Read only) FL_LEVEL60,FL_LEVEL50 */
			/* 0471 (Read only) FL_OUT60,FL_OUT50,FL_DETECT60,
							FL_DETECT50,FL_STATE */
			/* 0472 - 0477 (Read only) PW50Y */
			/* 0478 - 047D (Read only) PW50U */
			/* 047E - 0483 (Read only) PW50V */
			/* 0484 - 0489 (Read only) PW60Y */
			/* 048A - 048F (Read only) PW60U */
			/* 0490 - 0495 (Read only) PW60V */
	{ 0x98, 0x0C },	/* 0498 LEV_Gb_W1 */
	{ 0x99, 0x20 },	/* 0499 LEV_Gb_W2 */
	{ 0x9A, 0xff },	/* 049A LEV_Gb_W3 */
	{ 0x9B, 0xF0 },	/* 049B LEV_Gb_B1 */
	{ 0x9C, 0x04 },	/* 049C LEV_Gb_B2 */
	{ 0x9D, 0x18 },	/* 049D LEV_Gb_B3 */
	{ 0x9E, 0x71 },	/* 049E JDG36_OFF,JDG27_ODD,JDG45_OFF,AWNC4X4_ON */
	{ 0xA0, 0x00 },	/* 04A0 GAM_OFSET0 */
	{ 0xA1, 0x0E },	/* 04A1 GAM_OFSET1 */
	{ 0xA2, 0x1E },	/* 04A2 GAM_OFSET2 */
	{ 0xA3, 0x26 },	/* 04A3 GAM_OFSET3 */
	{ 0xA4, 0x2E },	/* 04A4 GAM_OFSET4 */
	{ 0xA5, 0x3C },	/* 04A5 GAM_OFSET5 */
	{ 0xA6, 0x4A },	/* 04A6 GAM_OFSET6 */
	{ 0xA7, 0x60 },	/* 04A7 GAM_OFSET7 */
	{ 0xA8, 0x70 },	/* 04A8 GAM_OFSET8 */
	{ 0xA9, 0x88 },	/* 04A9 GAM_OFSET9 */
	{ 0xAA, 0xA8 },	/* 04AA GAM_OFSET10 */
	{ 0xAB, 0xBE },	/* 04AB GAM_OFSET11 */
	{ 0xAC, 0xEF },	/* 04AC GAM_OFSET12 */
	{ 0xAD, 0x04 },	/* 04AD GAM_RANGE1 */
	{ 0xAE, 0x08 },	/* 04AE GAM_RANGE2 */
	{ 0xAF, 0x0A },	/* 04AF GAM_RANGE3 */
	{ 0xB0, 0x0C },	/* 04B0 GAM_RANGE4 */
	{ 0xB1, 0x10 },	/* 04B1 GAM_RANGE5 */
	{ 0xB2, 0x14 },	/* 04B2 GAM_RANGE6 */
	{ 0xB3, 0x1C },	/* 04B3 GAM_RANGE7 */
	{ 0xB4, 0x24 },	/* 04B4 GAM_RANGE8 */
	{ 0xB5, 0x34 },	/* 04B5 GAM_RANGE9 */
	{ 0xB6, 0x54 },	/* 04B6 GAM_RANGE1 */
	{ 0xB7, 0x74 },	/* 04B7 GAM_RANGE1 */
	{ 0xB8, 0x10 },	/* 04B8 GAMMA_SLP */
	{ 0xB9, 0x00 },	/* 04B9 GAM_BONUS0,GAMMA_LEV[8] */
	{ 0xBA, 0x58 },	/* 04BA GAMMA_LEV[7:0] */
	{ 0xBB, 0x03 },	/* 04BB K_GAMMA */
	{ 0xBC, 0x18 },	/* 04BC K_GAMMA_OUT */
			/* 04BD GAM_BONUS1 */
			/* 04BE - 04BF -,-,-,-,-,-,-,- */
	{ 0xBD, 0x00 },	/* 04BD GAM_BONUS1 */
	{ 0xC0, 0x40 },	/* 04C0 K0 MAT1 */
	{ 0xC1, 0x04 },	/* 04C1 K1 MAT1 */
	{ 0xC2, 0x40 },	/* 04C2 K2 MAT1 */
	{ 0xC3, 0xF8 },	/* 04C3 K3 MAT1 */
	{ 0xC4, 0x40 },	/* 04C4 K0 MAT2 */
	{ 0xC5, 0xF6 },	/* 04C5 K1 MAT2 */
	{ 0xC6, 0x40 },	/* 04C6 K2 MAT2 */
	{ 0xC7, 0xFA },	/* 04C7 K3 MAT2 */
	{ 0xC8, 0x40 },	/* 04C8 K0 MAT3 */
	{ 0xC9, 0x04 },	/* 04C9 K1 MAT3 */
	{ 0xCA, 0x40 },	/* 04CA K2 MAT3 */
	{ 0xCB, 0xF8 },	/* 04CB K3 MAT3 */
	{ 0xCC, 0x00 },	/* 04CC K_K0_MAT */
	{ 0xCD, 0x00 },	/* 04CD K_K1_MAT */
	{ 0xCE, 0x00 },	/* 04CE K_K2_MAT */
	{ 0xCF, 0x00 },	/* 04CF K_K3_MAT */
	{ 0xD0, 0x00 },	/* 04D0 K1P,K1M */
	{ 0xD1, 0x00 },	/* 04D1 K3P,K3M */
	{ 0xD2, 0x00 },	/* 04D2 RSZ_BONUS,INV_SIG_7,INV_SIG_5 */
			/* 04D3 - 04D7 -,-,-,-,-,-,-,- */
	{ 0xD8, 0x8D },	/* 04D8 Y_GAIN */
	{ 0xD9, 0xF0 },	/* 04D9 KSU */
	{ 0xDA, 0x00 },	/* 04DA NPDAT */
	{ 0xDB, 0x04 },	/* 04DB Y_DAMP */
			/* 04DD - 04DF -,-,-,-,-,-,-,- */
	{ 0xDC, 0x00 }, /* 04DC YSYS_BONUS */
	{ 0xE0, 0x01 },	/* 04E0 -,KCCR */
	{ 0xE1, 0x03 },	/* 04E1 -,KCCB */
	{ 0xE2, 0x58 },	/* 04E2 KCRGA */
	{ 0xE3, 0x60 },	/* 04E3 KCBGA */
	{ 0xE4, 0x4C },	/* 04E4 KCRGA1 */
	{ 0xE5, 0x58 },	/* 04E5 KCBGA1 */
	{ 0xE6, 0x54 },	/* 04E6 KCRGA2 */
	{ 0xE7, 0x60 },	/* 04E7 KCBGA2 */
	{ 0xE8, 0xB0 },	/* 04E8 KCLC */
	{ 0xE9, 0xD0 },	/* 04E9 KCHC */
	{ 0xEA, 0x13 },	/* 04EA KLGL,KLGH */
	{ 0xEB, 0x14 },	/* 04EB KLGE 23Nov06 */
	{ 0xEC, 0x40 },	/* 04EC KILL_AGC */
	{ 0xED, 0x30 },	/* 04ED KILL_IRIS */
	{ 0xEE, 0x13 },	/* 04EE KILL_IRISG,KILL_AGCG */
	{ 0xEF, 0xF8 },	/* 04EF K_KCRGA */
	{ 0xF0, 0x00 },	/* 04F0 K_KCBGA */
	{ 0xF1, 0x10 },	/* 04F1 -,CKIL_LEV */
	{ 0xF2, 0xE0 },	/* 04F2 SEPIA_U */
	{ 0xF3, 0x20 },	/* 04F3 SEPIA_V */
	{ 0xF4, 0x00 },	/* 04F4 UV OUT_SEL,-,-,-,UV_SEL,NP_SEL,SEPIA_SEL */
	{ 0xF5, 0x00 },	/* 04F5 R_Y_OFS */
	{ 0xF6, 0x00 },	/* 04F6 G_Y_OFS */
	{ 0xF7, 0x00 },	/* 04F7 CSYS_BONUS */
	{ 0xF8, 0x00 },	/* 04F8 EMBOSS_FIL_SEL,EMBOSS_ON,SKETCH_FIL_SEL,
								SKETCH_ON */
	{ 0xF9, 0x00 },	/* 04F9 APT_HOLD_LEV */
	{ 0xFA, 0x00 },	/* 04FA -,-,-,-,-,-,APT_GAIN_UP,APT_HOLD_SEL */
			/* 04FB - 04FD -,-,-,-,-,-,-,- */
	{ 0xFE, 0x02 },
	{ 0xFF, 0x05 },	/* BANK 05 */
	{ 0x00, 0xE0 },	/* 0500 C_MTX_U_CENTER */
	{ 0x01, 0x10 },	/* 0501 C_MTX_V_CENTER */
	{ 0x02, 0x00 },	/* 0502 C_MTX_U_VALUE */
	{ 0x03, 0x10 },	/* 0503 C_MTX_V_VALUE */
	{ 0x04, 0x10 },	/* 0504 C_MTX_RANGE_B */
	{ 0x05, 0x10 },	/* 0505 C_MTX_RANGE */
	{ 0x06, 0x00 },	/* 0506 C_MTX_YC */
	{ 0x07, 0x00 },	/* 0507 C_MTX_Y_VALUE */
	{ 0x08, 0xFF },	/* 0508 C_MTX_Y_RANGE */
	{ 0x09, 0x00 },	/* 0509 C_MTX_Y_RANGE_B */
	{ 0x0A, 0xE0 },	/* 050A C_MTX_U_CENTER2 */
	{ 0x0B, 0xE0 },	/* 050B C_MTX_V_CENTER2 */
	{ 0x0C, 0xE8 },	/* 050C C_MTX_U_VALUE2 */
	{ 0x0D, 0xE8 },	/* 050D C_MTX_V_VALUE2 */
	{ 0x0E, 0x20 },	/* 050E C_MTX_RANGE_B2 */
	{ 0x0F, 0x08 },	/* 050F C_MTX_RANGE2 */
	{ 0x10, 0x00 },	/* 0510 C_MTX_YC2 */
	{ 0x11, 0x00 },	/* 0511 C_MTX_Y_VALUE2 */
	{ 0x12, 0x00 },	/* 0512 C_MTX_Y_RANGE2 */
	{ 0x13, 0x00 },	/* 0513 C_MTX_Y_RANGE_B2 */
	{ 0x14, 0x00 },	/* 0514 APT_K_RESIZE_LIM */
	{ 0x15, 0x80 },	/* 0515 APT_K_U(APT_K) */
	{ 0x16, 0x00 },	/* 0516 APT_K_L */
	{ 0x17, 0x00 },	/* 0517 APT_K_SLP,APT_K_SLP2 */
	{ 0x18, 0x00 },	/* 0518 APT_LIM_RESIZE_LIM */
	{ 0x19, 0x20 },	/* 0519 APT_LIM_U(APT_LIM) */
	{ 0x1A, 0x00 },	/* 051A APT_LIM_L */
	{ 0x1B, 0x00 },	/* 051B APT_LIM_SLP,APT_LIM_SLP2 */
	{ 0x1C, 0x00 },	/* 051C APT_CL_RESIZE_LIM */
	{ 0x1D, 0xFF },	/* 051D APT_CL_U */
	{ 0x1E, 0x04 },	/* 051E APT_CL_L(APT_CL) */
	{ 0x1F, 0x00 },	/* 051F APT_CL_SLP,APT_CL_SLP2 */
	{ 0x20, 0xFF },	/* 0520 APT_RESIZE_CL */
	{ 0x21, 0x0F },	/* 0521 -,-,-,-,APT_SS_CL */
	{ 0x22, 0xD0 },	/* 0522 APT_CL2 */
	{ 0x23, 0x10 },	/* 0523 APT_K2 */
	{ 0x24, 0x30 },	/* 0524 APT_AGC */
	{ 0x25, 0x88 },	/* 0525 APT_AGCG,-,APT_FIL_SEL,APT_BPS,APT_OFF */
	{ 0x26, 0x08 },	/* 0526 MHP_CL */
	{ 0x27, 0x18 },	/* 0527 MHP_K */
	{ 0x28, 0x05 },	/* 0528 -,-,-,-,-,APT_RESC,APT_RES2,APT_RES1 */
	{ 0x29, 0xFF },	/* 0529 Y_LIM_H */
	{ 0x2A, 0x00 },	/* 052A Y_LIM_L */
	{ 0x2B, 0xFF },	/* 052B U_LIM_H */
	{ 0x2C, 0x00 },	/* 052C U_LIM_L */
	{ 0x2D, 0xFF },	/* 052D V_LIM_H */
	{ 0x2E, 0x00 },	/* 052E V_LIM_L */
	{ 0x2F, 0x00 },	/* 052F APT_BONUS */
	{ 0x30, 0x00 },	/* 0530 INV_SEL,PARCKOFF,PARVHOFF,PARAOFF,RA_SEL_UL,
							RB_SEL_UL,-,VS_DELAY */
	{ 0x31, 0x04 },	/* 0531 TSTCHT,CHT10,SHUTSU_BONUS2,BYTE_SWAP,
					HEADER_IN_OB,ITUR656_VSEL,ITU656 */
	{ 0x32, 0x00 },	/* 0532 SHUTSU_BONUS */
	{ 0x33, 0x00 },	/* 0533 KRU */
	{ 0x34, 0xE6 },	/* 0534 KRV */
	{ 0x35, 0x27 },	/* 0535 KGU */
	{ 0x36, 0xC9 },	/* 0536 KGV */
	{ 0x37, 0x46 },	/* 0537 KBU */
	{ 0x38, 0x00 },	/* 0538 KBV */
	{ 0x39, 0x80 },	/* 0539 BLNK_UV_CODE */
	{ 0x3A, 0x10 },	/* 053A BLNK_Y_CODE */
	{ 0x3B, 0x00 },	/* 053B OUT_SIGPO */
			/* 053C - 053D -,-,-,-,-,-,-,- */
	{ 0x3E, 0x40 },	/* 053E KG */
	{ 0x3F, 0x00 },	/* 053F -,-,-,-,-,-,INV_SIG6,INV_SIG4 */
	{ 0x40, 0x01 },	/* 0540 A_WAIT_TIME */
	{ 0x41, 0x20 },	/* 0541 LIMIM */
	{ 0x42, 0x28 },	/* 0542 LIMIP */
	{ 0x43, 0x10 },	/* 0543 LIMQM */
	{ 0x44, 0x14 },	/* 0544 LIMQP */
	{ 0x45, 0x28 },	/* 0545 YLCL (OLD: 48) */
	{ 0x46, 0xD8 },	/* 0546 YHCL */
	{ 0x47, 0x38 },	/* 0547 KGBGR1 */
	{ 0x48, 0x4C },	/* 0548 KGBGR2 */
	{ 0x49, 0x30 },	/* 0549 KGBGR3 */
	{ 0x4A, 0x50 },	/* 054A KGBGR4 */
	{ 0x4B, 0x22 },	/* 054B LIMWIIM,LIMWIIP */
	{ 0x4C, 0x22 },	/* 054C LIMWIQM,LIMWIQP */
	{ 0x4D, 0x33 },	/* 054D LIMWOI,LIMWOQ */
	{ 0x4E, 0x10 },	/* 054E WB_SEL,WB_WEIGHT_I */
	{ 0x4F, 0x10 },	/* 054F WB_ADR[8],WB_WEIGHT_O */
	{ 0x50, 0x14 },	/* 0550 WB_ADR[7:0] */
	{ 0x51, 0x80 },	/* 0551 WBR_MIN */
	{ 0x52, 0x90 },	/* 0552 WBR_MAX */
	{ 0x53, 0x60 },	/* 0553 WBB_MIN */
	{ 0x54, 0x70 },	/* 0554 WBB_MAX */
	{ 0x55, 0x00 },	/* 0555 K_WBR_MIN */
	{ 0x56, 0x0A },	/* 0556 K_WBR_MAX */
	{ 0x57, 0x03 },	/* 0557 K_WBB_MIN */
	{ 0x58, 0x00 },	/* 0558 K_WBB_MAX */
	{ 0x59, 0x80 },	/* 0559 WBR_MIN_LIM */
	{ 0x5A, 0x90 },	/* 055A WBR_MAX_LIM */
	{ 0x5B, 0x50 },	/* 055B WBB_MIN_LIM */
	{ 0x5C, 0x60 },	/* 055C WBB_MAX_LIM */
	{ 0x5D, 0x00 },	/* 055D WB_LIM_IRIS1 */
	{ 0x5E, 0x00 },	/* 055E WB_LIM_IRIS2 */
	{ 0x5F, 0x00 },	/* 055F WB_LIM_GAIN_I */
	{ 0x60, 0x00 },	/* 0560 WB_LIM_GAIN_Q */
	{ 0x61, 0x00 },	/* 0561 WBL_BONUS,WB_STOP,WBFIX1,SELLPF */
	{ 0x62, 0x80 },	/* 0562 WBR2 */
	{ 0x63, 0x44 },	/* 0563 WBB2 */
	{ 0x64, 0x56 },	/* 0564 WBR1 */
	{ 0x65, 0x5C },	/* 0565 WBB1 */
	{ 0x66, 0x40 },	/* 0566 WBR_STILL */
	{ 0x67, 0x40 },	/* 0567 WBB_STILL */
	{ 0x68, 0x00 },	/* 0568 -,-,-,-,-,MAT_STILL_HOLD,GAIN_STILL_HOLD,
							AWB_STILL_HOLD */
	{ 0x69, 0x05 },	/* 0569 -,HCAPS_WB[8],-,VCAPS_WB[8],-,HCAPE_WB[8],-,
								VCAPE_WB[8] */
	{ 0x6A, 0x00 },	/* 056A HCAPS_WB[7:0] */
	{ 0x6B, 0x00 },	/* 056B VCAPS_WB[7:0] */
	{ 0x6C, 0x8F },	/* 056C HCAPE_WB[7:0] */
	{ 0x6D, 0x2B },	/* 056D VCAPE_WB[7:0] */
	{ 0x6E, 0x00 },	/* 056E SUNSPOT_IRIS_LEV[15:8] */
	{ 0x6F, 0x28 },	/* 056F SUNSPOT_IRIS_LEV[7:0] */
	{ 0x70, 0x22 },	/* 0570 REF_IRIS */
	{ 0x71, 0x38 },	/* 0571 CTRL_OH */
	{ 0x72, 0x20 },	/* 0572 CTRL_OL */
	{ 0x73, 0x38 },	/* 0573 CTRL_IH */
	{ 0x74, 0x20 },	/* 0574 CTRL_IL */
	{ 0x75, 0x40 },	/* 0575 AGC_DLY_SEL,CTRD_OH[8],CTRD_OL[8],CTRD_IH[8],
				CTRD_IL[8],CTRL_IL_LIM[8],CTRL_IH_LIM[8] */
	{ 0x76, 0x48 },	/* 0576 CTRD_OH[7:0] */
	{ 0x77, 0x38 },	/* 0577 CTRD_OL[7:0] */
	{ 0x78, 0x44 },	/* 0578 CTRD_IH[7:0] */
	{ 0x79, 0x3A },	/* 0579 CTRD_IL[7:0] */
	{ 0x7A, 0x3E },	/* 057A CTRL_IL_LIM[7:0] */
	{ 0x7B, 0x44 },	/* 057B CTRL_IH_LIM[7:0] */
	{ 0x7C, 0xF0 },	/* 057C IRIS_U_LIM[15:8] */
	{ 0x7D, 0x60 },	/* 057D IRIS_U_LIM[7:0] */
	{ 0x7E, 0x00 },	/* 057E IRIS_L_LIM[15:8] */
	{ 0x7F, 0x02 },	/* 057F IRIS_L_LIM[7:0] */
	{ 0x80, 0x40 },	/* 0580 IRIS_INIT_SEL,FL_ON,FL_HOLD,FL_HOLD_SEL,
								I_WAIT_TIME2 */
	{ 0x81, 0x00 },	/* 0581 AGC_OFS_RB */
	{ 0x82, 0xE0 },	/* 0582 EE_CLIP_H */
	{ 0x83, 0x08 },	/* 0583 EE_CLIP_L */
	{ 0x84, 0x20 },	/* 0584 K_IRIS_W */
	{ 0x85, 0x00 },	/* 0585 I_WAIT_TIME */
	{ 0x86, 0x40 },	/* 0586 SCENE_CHANGE_H */
	{ 0x87, 0x20 },	/* 0587 SCENE_CHANGE_L */
	{ 0x88, 0x03 },	/* 0588 TG_MANUAL_MODE2,IRIS_OUT_MODE,IRIS_LPF,
								EE_RATIO */
	{ 0x89, 0x01 },	/* 0589 IRIS_CTR_SEL */
	{ 0x8A, 0x00 },	/* 058A IRIS_INIT_DATA[15:8] */
	{ 0x8B, 0x00 },	/* 058B IRIS_INIT_DATA[7:0] */
	{ 0x8C, 0x85 },	/* 058C IRIS_AREA_AUTO,HCAPS[8],-,VCAPS[8],-,HCAPE[8],-,
								VCAPE[8] */
	{ 0x8D, 0x00 },	/* 058D HCAPS[7:0] */
	{ 0x8E, 0x00 },	/* 058E VCAPS[7:0] */
	{ 0x8F, 0x8F },	/* 058F HCAPE[7:0] */
	{ 0x90, 0x2B },	/* 0590 VCAPE[7:0] */
	{ 0x91, 0x03 },	/* 0591 MODE_GAIN_S2P[9:8],-,SHT_OFS_S */
	{ 0x92, 0x40 },	/* 0592 MODE_GAIN_S2P[7:0] */
	{ 0x93, 0x04 },	/* 0593 MODE_GAIN_P2S[9:8],-,SHT_OFS_P */
	{ 0x94, 0x40 },	/* 0594 MODE_GAIN_P2S[7:0] */
	{ 0x95, 0x04 },	/* 0595 FRAME_LENGTH_S[15:8] (1260) */
	{ 0x96, 0xEC },	/* 0596 FRAME_LENGTH_S[7:0] */
	{ 0x97, 0x04 },	/* 0597 FRAME_LENGTH_P[15:8] (1260) */
	{ 0x98, 0xEC },	/* 0598 FRAME_LENGTH_P[7:0] */
	{ 0x99, 0x03 },	/* 0599 SHT_LIM_S[15:8] changed by UT*/
	{ 0x9A, 0x40 },	/* 059A SHT_LIM_S[7:0] changed by UT*/
	{ 0x9B, 0x06 },	/* 059B SHT_LIM_P[15:8] changed by UT */
	{ 0x9C, 0x40 },	/* 059C SHT_LIM_P[7:0] changed by UT */
/* 	{ 0x99, 0x07 },	/* 0599 SHT_LIM_S[15:8] */
/*	{ 0x9A, 0x68 },	/* 059A SHT_LIM_S[7:0] */
/*	{ 0x9B, 0x07 },	/* 059B SHT_LIM_P[15:8] */
/*	{ 0x9B, 0x01 },	/* 059B SHT_LIM_P[15:8] changed by NR */
/*	{ 0x9C, 0x68 },	/* 059C SHT_LIM_P[7:0] */
/*	{ 0x9C, 0x00 },	/* 059C SHT_LIM_P[7:0] changed by NR */
	{ 0x9D, 0x00 },	/* 059D AGC_STILL */
	{ 0x9E, 0x58 },	/* 059E AGC_LIM  changed by UT */
/*	{ 0x9E, 0x30 },	/* changed by NR */
	{ 0x9F, 0x00 },	/* 059F SHT_HOLD_SEL,AGC_HOLD_SEL,-,
							FL_SHT_50_S[20:16] */
	{ 0xA0, 0x17 },	/* 05A0 FL_SHT_50_S[15:8] */
	{ 0xA1, 0xA9 },	/* 05A1 FL_SHT_50_S[7:0] */
	{ 0xA2, 0x00 },	/* 05A2 -,-,-,FL_SHT_60_S[20:16] */
	{ 0xA3, 0x13 },	/* 05A3 FL_SHT_60_S[15:8] */
	{ 0xA4, 0xB7 },	/* 05A4 FL_SHT_60_S[7:0] */
	{ 0xA5, 0x00 },	/* 05A5 SHT_STILL[15:8] */
	{ 0xA6, 0x00 },	/* 05A6 SHT_STILL[7:0] */
	{ 0xA7, 0x00 },	/* 05A7 -,-,-,FL_SHT_50_P[20:16] */
	{ 0xA8, 0x17 },	/* 05A8 FL_SHT_50_P[15:8] */
	{ 0xA9, 0xA9 },	/* 05A9 FL_SHT_50_P[7:0] */
	{ 0xAA, 0x00 },	/* 05AA -,-,-,FL_SHT_60_P[20:16] */
	{ 0xAB, 0x13 },	/* 05AB FL_SHT_60_P[15:8] */
	{ 0xAC, 0xB7 },	/* 05AC FL_SHT_60_P[7:0] */
	{ 0xAD, 0x20 },	/* 05AD AGC_MIN_GAIN */
	{ 0xAE, 0x00 },	/* 05AE FRAME_LENGTH_LINE_REG[15:8] */
	{ 0xAF, 0x00 },	/* 05AF FRAME_LENGTH_LINE_REG[7:0] */
	{ 0xB0, 0x10 },	/* 05B0 FL_TIMES */
	{ 0xB1, 0x00 },	/* 05B1 FL_TY_TH_50 */
	{ 0xB2, 0x00 },	/* 05B2 FL_TY_TH_60 */
	{ 0xB3, 0x00 },	/* 05B3 FL_W_LINE_A */
	{ 0xB4, 0x00 },	/* 05B4 FL_W_LINE_B */
	{ 0xB5, 0x00 },	/* 05B5 FL_W_SLP */
	{ 0xB6, 0x00 },	/* 05B6 FL_W_AREA_B */
	{ 0xB7, 0x00 },	/* 05B7 PEAK_50[11:8],PEAK_60[11:8] */
	{ 0xB8, 0xAD },	/* 05B8 PEAK_50[7:0] */
	{ 0xB9, 0xCF },	/* 05B9 PEAK_60[7:0] */
	{ 0xBA, 0x06 },	/* 05BA PEAK_DIFF */
	{ 0xBB, 0x4A },	/* 05BB LEVEL_TH,FL_W_OFF,FL_DEC_SEL */
	{ 0xBC, 0x48 },	/* 05BC FL_START_NUM,FL_CHANGE_NUM */
	{ 0xBD, 0x00 },	/* 05BD FL_BONUS,FL_Y_LIMIT */
	{ 0xBE, 0x00 },	/* 05BE FL_V_LIMIT,FL_U_LIMIT */
			/* 05BF -,-,-,-,-,-,-,- */
			/* 05C0 -,-,-,-,-,-,-,- */
	{ 0xC1, 0x06 },	/* 05C1 -,-,-,-,-,SRSTX,FL_RFLG,SCENE_CHANGE */
			/* 05C2 - 05C7 -,-,-,-,-,-,-,- */
	{ 0xC8, 0x83 },	/* 05C8 AF_UPEN,AF_MODE_7,-,-,-,-,AF_MODE0 */
	{ 0xC9, 0x21 },	/* 05C9 -,H_STT_AF_EN0[10:8],-,V_STT_AF_EN0[10:8] */
	{ 0xCA, 0x20 },	/* 05CA H_STT_AF_EN0[7:0] */
	{ 0xCB, 0x58 },	/* 05CB V_STT_AF_EN0[7:0] */
	{ 0xCC, 0x32 },	/* 05CC -,H_END_AF_EN0[10:8],-,V_END_AF_EN0[10:8] */
	{ 0xCD, 0x20 },	/* 05CD H_END_AF_EN0[7:0] */
	{ 0xCE, 0x58 },	/* 05CE V_END_AF_EN0[7:0] */
			/* 05CF -,-,-,-,-,-,-,- */
	{ 0xD0, 0x3E },	/* 05D0 -,AF_COEF */
	{ 0xD1, 0x01 },	/* 05D1 AF_OFFSET0 */
			/* 05D2 - 05DF -,-,-,-,-,-,-,- */
	{ 0xD8, 0x00 },	/* 05D8 */
	{ 0xE0, 0x05 },	/* 05E0 CHBPAT16[1],CHBPAT16[0],GIO0_SEL */
	{ 0xE1, 0x05 },	/* 05E1 CHBPAT16[3],CHBPAT16[2],GIO1_SEL */
/*	{ 0xE2, 0x81 },	/* 05E2 CHBPAT16[5],CHBPAT16[4],GIO2_SEL */
	{ 0xE2, 0x04 },	/* changed by NR */
	{ 0xE3, 0x88 },	/* 05E3 CHBPAT16[7],CHBPAT16[6],GIO3_SEL */
	{ 0xE4, 0x00 },	/* 05E4 DLY_RCLK,GIO_REG */
	{ 0xE5, 0x11 },	/* 05E5 DLY_HREF,DLY_VREF */
	{ 0xE6, 0x43 },	/* 05E6 DLY_DO,DLY_D1 */
	{ 0xE7, 0x33 },	/* 05E7 DLY_D2,DLY_D3 */
	{ 0xE8, 0x21 },	/* 05E8 DLY_D4,DLY_D5 */
	{ 0xE9, 0x30 },	/* 05E9 DLY_D6,DLY_D7 */
	{ 0xEA, 0x00 },	/* 05EA CHBPAT8 */
	{ 0xEB, 0xA5 },	/* 05EB DS_VREF,DS_HREF,DS_DO,DS_RCLK (OLD:AA) */
	{ 0xEC, 0xFF },	/* 05EB DS_VREF,DS_HREF,DS_DO,DS_RCLK (OLD:AA) */
	{ 0xED, 0x00 },	/* 05ED SL_INT,SL_STRB,SL_EXO0,SL_EXO=EF=BF=BDP,SL_DO,SL_H=
REF,
							SL_VREF,SL_RCLK */
	{ 0xEE, 0x00 },	/* 05EE STBSEL,-,-,RAM_SEL */
/*	{ 0xEF, 0xC0 },	/* 05EF IOC,HS_SDA,DO_HOLD,DO_LSEL,TMUX_TMODE */
/*	{ 0xF0, 0x0F },	/* 05F0 RAM_DIN0_H[19:16],RAM_DIN1_H[19:16] */
/*	{ 0xF1, 0x00 },	/* 05F1 RAM_DIN0_M[15:8] */
/*	{ 0xF2, 0x00 },	/* 05F2 RAM_DIN0_L7:0] */
/*	{ 0xF3, 0xFF },	/* 05F3 RAM_DIN1_M[15:8] */
/*	{ 0xF4, 0xFF },	/* 05F4 RAM_DIN1_L[7:0] */
/*	{ 0xF5, 0x18 },	/* 05F5 BISTOFF,-,CHBPAT4,RAM_TADR[9:8] */
/*	{ 0xF6, 0x00 },	/* 05F6 RAM_TADR_L[7:0] */
	{ 0xF7, 0x00 },	/* 05F7 GIO_BONUS,SEL_D0 */
/*	{ 0xF8, 0xAA },	/* 05F8 CHBPAT16[15],CHBPAT16[14],CHBPAT16[13],
					CHBPAT16[12],CHBPAT16[11],CHBPAT16[10],
					CHBPAT16[9],CHBPAT16[8] */
	{ 0xF9, 0x00 },	/* 05F9 -,-,RAN_ON,PG_ON,DHCNTINV,DHGR1INV,DHGR2INV */
	{ 0xFA, 0x39 },	/* 05FA PG_AREA3,PG_AREA2,PG_AREA1,PG_AREA0 */
	{ 0xFB, 0xFF },	/* 05FB PG_DATA */
	{ 0xFC, 0x00 },	/* 05FC -,-,-,-,-,-,RANDOM[9:8] */
	{ 0xFD, 0x00 },	/* 05FD RANDOM[7:0] */
	{ 0xFE, 0x02 },
	{ 0xFF, 0x06 },	/* BANK6 */
			/* 0600 (Read only) -,-,OB_DATA */
			/* 0601 (Read only) RCA_DATA */
			/* 0602 (Read only) GRCA_DATA */
			/* 0603 (Read only) BCA_DATA */
			/* 0604 (Read only) GBCA_DATA */
			/* 0605 (Read only) R_DATA[11:8],G_DATA[11:8] */
			/* 0606 (Read only) B_DATA[11:8],-,-,I_DATA[8],
								Q_DATA[8] */
			/* 0607 (Read only) R_DATA[7:0] */
			/* 0608 (Read only) G_DATA[7:0] */
			/* 0609 (Read only) B_DATA[7:0] */
			/* 060A (Read only) I_DATA[7:0] */
			/* 060B (Read only) Q_DATA[7:0] */
			/* 060C (Read only) WBR_GAIN */
			/* 060D (Read only) WBB_GAIN */
			/* 060E (Read only) IRIS_DATA1 */
			/* 060F (Read only) IRIS_DATA2 */
			/* 0610 (Read only) IRIS_W_DATA */
			/* 0611 (Read only) FRAME_LENGTH[15:8] */
			/* 0612 (Read only) FRAME_LENGTH[7:0] */
			/* 0613 (Read only) SH_OUT[15:8] */
			/* 0614 (Read only) SH_OUT[7:0] */
			/* 0615 (Read only) AGC_GAIN_G */
			/* 0616 (Read only) IRIS_CTRL_DATA */
			/* 0617 (Read only) AF_CNT0[15:8] */
			/* 0618 (Read only) AF_CNT0[7:0] */
			/* 0619 (Read only) AF0[23:16] */
			/* 061A (Read only) AF0[15:8] */
			/* 061B (Read only) AF0[7:0] */
			/* 061C - 0620 -,-,-,-,-,-,-,- */
			/* 0621 (Read only) T_RAM_DATA_H */
			/* 0622 (Read only) T_RAM_DATA_M */
			/* 0623 (Read only) T_RAM_DATA_L */
			/* 0624 (Read only) -,-,-,-,-,MSTATE */
			/* 0625 (Read only) -,-,-,-,-,-,APT_Q2_C,APT_Q1_C */
			/* 0626 (Read only) APT_Q0_C,DLY_Q9_C,DLY_Q8_C,DLY_Q7_C,
					DLY_Q6_C,DLY_Q5_C,DLY_Q4_C,DLY_Q3_C */
			/* 0627 (Read only) DLY_Q2_C,DLY_Q1_C,DLY_Q0_C,ROD_Q3_C,
					ROD_Q2_C,ROD_Q1_C,ROD_Q0_C,MTX_Q_C */
			/* 0628 (Read only) PIN_DATA0 */
			/* 0629 (Read only) 0444h W-Buf */
			/* 062A (Read only) PIN_DATA1 */
			/* 062B (Read only) PIN_DATA2 */
			/* 062C (Read only) PIN_DATA3 */
			/* 062D (Read only) -,-,-,-,-,-,RAM_TADR[9:8] */
			/* 062E (Read only) RAM_TADR[7:0] */
			/* 062F - 063F -,-,-,-,-,-,-,- */
			/* 0640 SC_CTRL7,SC_TH,SC_R_SEL,SC_CTRL3,SC_CTRL2,
							SC_H_SEL,SC_V_SEL */
	{ 0x40, 0x20 },
	{ 0x41, 0x88 },
	{ 0x42, 0x80 },
	{ 0x43, 0x01 },
	{ 0x44, 0x00 },	/* Gr00 */
	{ 0x45, 0x00 },	/* Gr40 */
	{ 0x46, 0x00 },	/* Gr80 */
	{ 0x47, 0x06 },	/* GrC0 */
	{ 0x48, 0x00 },	/* Gr */
	{ 0x49, 0x00 },	/* Gr */
	{ 0x4A, 0x00 },	/* Gr */
	{ 0x4B, 0x00 },	/* Gr */
	{ 0x4C, 0x50 },	/* GrX+ */
	{ 0x4D, 0xA0 },	/* GrX- */
	{ 0x4E, 0x80 },	/* GrY+ */
	{ 0x4F, 0x80 },	/* GrY- */
	{ 0x50, 0x00 },	/* GrXcenter */
	{ 0x51, 0x00 },	/* GrYcenter */
	{ 0x52, 0x40 },	/* Gr */
	{ 0x53, 0x00 },
	{ 0x54, 0x00 },	/* R 00 */
	{ 0x55, 0x03 },	/* R 40 */
	{ 0x56, 0x00 },	/* R 80 */
	{ 0x57, 0x03 },	/* R C0 */
	{ 0x58, 0x00 },	/* R */
	{ 0x59, 0x00 },	/* R */
	{ 0x5A, 0x00 },	/* R */
	{ 0x5B, 0x00 },	/* R */
	{ 0x5C, 0x00 },	/* R X+ */
	{ 0x5D, 0xA0 },	/* R X- */
	{ 0x5E, 0x60 },	/* R Y+ */
	{ 0x5F, 0x50 },	/* R Y- */
	{ 0x60, 0x00 },	/* R Xcenter */
	{ 0x61, 0x30 },	/* R Ycenter */
	{ 0x62, 0x40 },	/* R */
	{ 0x63, 0x00 },
	{ 0x64, 0xFE },	/* B 00 */
	{ 0x65, 0x00 },	/* B 40 */
	{ 0x66, 0x02 },	/* B 80 */
	{ 0x67, 0x00 },	/* B C0 */
	{ 0x68, 0x00 },	/* B */
	{ 0x69, 0x00 },	/* B */
	{ 0x6A, 0x00 },	/* B */
	{ 0x6B, 0x00 },	/* B */
	{ 0x6C, 0x20 },	/* B X+ */
	{ 0x6D, 0x86 },	/* B X- */
	{ 0x6E, 0x40 },	/* B Y+ */
	{ 0x6F, 0x80 },	/* B Y- */
	{ 0x70, 0x00 },	/* B Xcenter */
	{ 0x71, 0x00 },	/* B Ycenter */
	{ 0x72, 0x40 },	/* B */
	{ 0x73, 0x00 },
	{ 0x74, 0x00 },	/* Gb00 */
	{ 0x75, 0x00 },	/* Gb40 */
	{ 0x76, 0x00 },	/* Gb80 */
	{ 0x77, 0x06 },	/* GbC0 */
	{ 0x78, 0x00 },	/* Gb */
	{ 0x79, 0x00 },	/* Gb */
	{ 0x7A, 0x00 },	/* Gb */
	{ 0x7B, 0x00 },	/* Gb */
	{ 0x7C, 0x50 },	/* GbX+ */
	{ 0x7D, 0xA0 },	/* GbX- */
	{ 0x7E, 0x80 },	/* GbY+ */
	{ 0x7F, 0x80 },	/* GbY- */
	{ 0x80, 0x00 },	/* GbXcenter */
	{ 0x81, 0x00 },	/* GbYcenter */
	{ 0x82, 0x40 },	/* Gb */
	{ 0x83, 0x00 },
	{ 0xA0, 0x8A },
	{ 0xA1, 0x00 },
	{ 0xA2, 0x88 },
	{ 0xA3, 0xE0 },
	{ 0xA4, 0x40 },
	{ 0xA5, 0xD0 },
	{ 0xA6, 0x40 },
	{ 0xA7, 0xC0 },
	{ 0xA8, 0x00 },
	{ 0xA9, 0x00 },
	{ 0xAA, 0x40 },
	{ 0xAB, 0xD0 },
	{ 0xAC, 0x40 },
	{ 0xAD, 0xC0 },
	{ 0xAE, 0x00 },
	{ 0xAF, 0x00 },
	{ 0xB0, 0x40 },
	{ 0xB1, 0xD0 },
	{ 0xB2, 0x40 },
	{ 0xB3, 0xC0 },
	{ 0xB4, 0x00 },
	{ 0xB5, 0x00 },
	{ 0xB6, 0x40 },
	{ 0xB7, 0xD0 },
	{ 0xB8, 0x40 },
	{ 0xB9, 0xC0 },
	{ 0xBA, 0x00 },
	{ 0xBB, 0x00 },
			/* 06BC - 06BF -,-,-,-,-,-,-,- */
			/* 06C0 (Read only) MASTER_MODE1,MASTER_MODE2,
					MASTER_MODE3_EN,MASTER_REGUP_EN,
					FLICKER_EN,AWB_EN,IRIS_EN,SIGNAL_MASK */
			/* 06C1 (Read only) IMAGE_ORIENTATION_OUT,-,
					SENSOR_CHANGE, 0xSEL_STIL,RESIZE_EN,
					PREVIEW_CHANGE,STILL_CHANGE */
			/* 06C2 (Read only) X_EVEN_INC_OUT,X_ODD_INC_OUT */
			/* 06C3 (Read only) Y_EVEN_INC_OUT,Y_ODD_INC_OUT */
			/* 06C4 (Read only) LINE_LENGTH_PCK_OUT[15:8] */
			/* 06C5 (Read only) LINE_LENGTH_PCK_OUT[7:0] */
			/* 06C6 (Read only) -,X_OUTPUT_SIZE_OUT[10:8],-,
						Y_OUTPUT_SIZE_OUT[10:8] */
			/* 06C7 (Read only) X_OUTPUT_SIZE_OUT[7:0] */
			/* 06C8 (Read only) Y_OUTPUT_SIZE_OUT[7:0] */
			/* 06C9 (Read only) -,X_ADDR_START_OUT[10:8],-,
						Y_ADDR_START_OUT[10:8] */
			/* 06CA (Read only) X_ADDR_START_OUT[7:0] */
			/* 06CB (Read only) Y_ADDR_START_OUT[7:0] */
			/* 06CC (Read only) -,X_ADDR_END_OUT[10:8],-,
							Y_ADDR_END_OUT[10:8] */
			/* 06CD (Read only) X_ADDR_END_OUT[7:0] */
			/* 06CE (Read only) Y_ADDR_END_OUT[7:0] */
			/* 06CF (Read only) -,-,-,-,DSP_RESIZE_OUT[11:8] */
			/* 06D0 (Read only) DSP_RESIZE_OUT[7:0] */
			/* 06D1 (Read only) -,PIX_NUM_CO_OUT[10:8],-,
							LINE_NUM_CO_OUT[10:8] */
			/* 06D2 (Read only) PIX_NUM_CO_OUT[7:0] */
			/* 06D3 (Read only) LINE_NUM_CO_OUT[7:0] */
			/* 06D4 (Read only) -,-,-,STATE */
			/* 06D5 (Read only) -,-,-,-,INC_MODE */
			/* 06D6 (Read only) SCALE_M_OUT */
			/* 06D7 - 06DF -,-,-,-,-,-,-,- */
/*	{ 0xE0, 0x00 },	/* 06E0 -,X_ADDR_START_T[10:8],-,Y_ADDR_START_T[10:8] */
/*	{ 0xE1, 0x00 },	/* 06E1 X_ADDR_START_T[7:0] */
/*	{ 0xE2, 0x00 },	/* 06E2 Y_ADDR_START_T[7:0] */
/*	{ 0xE3, 0x64 },	/* 06E3 -,X_ADDR_END_T[10:8],-,Y_ADDR_END_T[10:8] */
/*	{ 0xE4, 0x6F },	/* 06E4 X_ADDR_END_T[7:0] */
/*	{ 0xE5, 0xCF },	/* 06E5 Y_ADDR_END_T[7:0] */
/*	{ 0xE6, 0x11 },	/* 06E6 X_EVEN_INC_T,X_ODD_INC_T */
/*	{ 0xE7, 0x11 },	/* 06E7 Y_EVEN_INC_T,Y_ODD_INC_T */
/*	{ 0xE8, 0x10 },	/* 06E8 SCALE_M_T */
			/* 06E9 - 06EF -,-,-,-,-,-,-,- */
	{ 0xF0, 0x1F },	/* 06F0 -,-,-,H_DMY_STT[12:8] */
	{ 0xF1, 0xFF },	/* 06F1 H_DMY_STT[7:0] */
	{ 0xF2, 0x00 },	/* 06F2 -,-,-,H_DMY_END[12:8] */
	{ 0xF3, 0x00 },	/* 06F3 H_DMY_END[7:0] */
	{ 0xF4, 0xFF },	/* 06F4 V_DMY_STT[15:8] */
	{ 0xF5, 0xFF },	/* 06F5 V_DMY_STT[7:0] */
	{ 0xF6, 0x00 },	/* 06F6 V_DMY_END[15:8] */
	{ 0xF7, 0x00 },	/* 06F7 V_DMY_END[7:0] */
	{ 0xFE, 0x03 },	/* 06F8 - 06FD -,-,-,-,-,-,-,- */
	{ 0xFF, 0x08 },	/* BANK8 */
	{ 0x00, 0x00 },	/* 0800 -,-,-,-,-,-,-,MASK_CORRUPTED_FRAMES */
	{ 0x01, 0x01 },	/* 0801 FINE_INTEGRATION_TIME_Hi */
	{ 0x02, 0x61 },	/* 0802 FINE_INTEGRATION_TIME_Lo */
			/* 0803 - 0804 -,-,-,-,-,-,-,- */
	{ 0x05, 0x00 },	/* 0805 -,-,-,-,-,TG_WP_ALL,TG_FWFLG,TG_FWFLG_SEL */
	{ 0x06, 0x00 },	/* 0806 Reserve */
	{ 0x07, 0x00 },	/* 0807 Reserve */
	{ 0x08, 0x00 },	/* 0808 Reserve,DB_GAIN_SEL,GAIN_DELAY_SEL,LP_OFF */
	{ 0x09, 0x01 },	/* 0809 -,-,-,-,-,-,TRNS_RD_CYC_Hi */
	{ 0x0A, 0x61 },	/* 080A TRNS_RD_CYC_Lo */
	{ 0x0B, 0x00 },	/* 080B -,-,-,-,-,-,XREADOUT_RD_S1_Hi */
	{ 0x0C, 0x01 },	/* 080C XREADOUT_RD_S1_Lo */
	{ 0x0D, 0x00 },	/* 080D -,-,-,-,-,-,XREADOUT_RD_R1_Hi */
	{ 0x0E, 0x00 },	/* 080E XREADOUT_RD_R1_Lo */
	{ 0x0F, 0x00 },	/* 080F -,-,-,-,-,-,XREADOUT_RD_S2_Hi */
	{ 0x10, 0x00 },	/* 0810 XREADOUT_RD_S2_Lo */
	{ 0x11, 0x01 },	/* 0811 -,-,-,-,-,-,XREADOUT_RD_R2_Hi */
	{ 0x12, 0x61 },	/* 0812 XREADOUT_RD_R2_Lo */
	{ 0x13, 0x00 },	/* 0813 -,-,-,-,-,-,SEL_RD_S1_Hi */
	{ 0x14, 0x11 },	/* 0814 SEL_RD_S1_Lo */
	{ 0x15, 0x00 },	/* 0815 -,-,-,-,-,-,SEL_RD_R1_Hi */
	{ 0x16, 0x41 },	/* 0816 SEL_RD_R1_Lo */
	{ 0x17, 0x00 },	/* 0817 -,-,-,-,-,-,SEL_RD_S2_Hi */
	{ 0x18, 0x51 },	/* 0818 SEL_RD_S2_Lo */
	{ 0x19, 0x01 },	/* 0819 -,-,-,-,-,-,SEL_RD_R2_Hi */
	{ 0x1A, 0x1F },	/* 081A SEL_RD_R2_Lo */
	{ 0x1B, 0x00 },	/* 081B -,-,-,-,-,-,RST_RD_S1_Hi */
	{ 0x1C, 0x01 },	/* 081C RST_RD_S1_Lo */
	{ 0x1D, 0x00 },	/* 081D -,-,-,-,-,-,RST_RD_R1_Hi */
	{ 0x1E, 0x11 },	/* 081E RST_RD_R1_Lo */
	{ 0x1F, 0x00 },	/* 081F -,-,-,-,-,-,RST_RD_S2_Hi */
	{ 0x20, 0x41 },	/* 0820 RST_RD_S2_Lo */
	{ 0x21, 0x00 },	/* 0821 -,-,-,-,-,-,RST_RD_R2_Hi */
	{ 0x22, 0x51 },	/* 0822 RST_RD_R2_Lo */
	{ 0x23, 0x00 },	/* 0823 -,-,-,-,-,-,RST_RD_S1_R_Hi */
	{ 0x24, 0x00 },	/* 0824 RST_RD_S1_R_Lo */
	{ 0x25, 0x00 },	/* 0825 -,-,-,-,-,-,RST_RD_R1_R_Hi */
	{ 0x26, 0x47 },	/* 0826 RST_RD_R1_R_Lo */
	{ 0x27, 0x01 },	/* 0827 -,-,-,-,-,-,RST_RD_S2_R_Hi */
	{ 0x28, 0x4F },	/* 0828 RST_RD_S2_R_Lo */
	{ 0x29, 0x00 },	/* 0829 -,-,-,-,-,-,RST_DR_R2_R_Hi */
	{ 0x2A, 0x00 },	/* 082A RST_DR_R2_R_Lo */
	{ 0x2B, 0x00 },	/* 082B -,-,-,-,-,-,TXCLK_RD_S0_Hi */
	{ 0x2C, 0x30 },	/* 082C TXCLK_RD_S0_Lo */
	{ 0x2D, 0x00 },	/* 082D -,-,-,-,-,-,TXCLK_RD_R0_Hi */
	{ 0x2E, 0x40 },	/* 082E TXCLK_RD_R0_Lo */
	{ 0x2F, 0x00 },	/* 082F -,-,-,-,-,-,TXCLK_RD_S1_Hi */
	{ 0x30, 0xB3 },	/* 0830 TXCLK_RD_S1_Lo */
	{ 0x31, 0x00 },	/* 0831 -,-,-,-,-,-,TXCLK_RD_R1_Hi */
	{ 0x32, 0xE3 },	/* 0832 TXCLK_RD_R1_Lo */
	{ 0x33, 0x00 },	/* 0833 -,-,-,-,-,-,TXCLK_RD_S2_Hi */
	{ 0x34, 0x00 },	/* 0834 TXCLK_RD_S2_Lo */
	{ 0x35, 0x00 },	/* 0835 -,-,-,-,-,-,TXCLK_RD_R2_Hi */
	{ 0x36, 0x00 },	/* 0836 TXCLK_RD_R2_Lo */
	{ 0x37, 0x00 },	/* 0837 -,-,-,-,-,-,-,SH_REG_SEL */
	{ 0x38, 0x00 },	/* 0838 PULSE_OFF */
	{ 0x39, 0x01 },	/* 0839 -,-,-,-,-,-,TRNS_SH_CYC_Hi */
	{ 0x3A, 0x61 },	/* 083A TRNS_SH_CYC_Lo */
	{ 0x3B, 0x00 },	/* 083B -,-,-,-,-,-,XREADOUT_SH_S1_Hi */
	{ 0x3C, 0x01 },	/* 083C XREADOUT_SH_S1_Lo */
	{ 0x3D, 0x00 },	/* 083D -,-,-,-,-,-,XREADOUT_SH_R1_Hi */
	{ 0x3E, 0x00 },	/* 083E XREADOUT_SH_R1_Lo */
	{ 0x3F, 0x00 },	/* 083F -,-,-,-,-,-,XREADOUT_SH_S2_Hi */
	{ 0x40, 0x00 },	/* 0840 XREADOUT_SH_S2_Lo */
	{ 0x41, 0x01 },	/* 0841 -,-,-,-,-,-,XREADOUT_SH_R2_Hi */
	{ 0x42, 0x61 },	/* 0842 XREADOUT_SH_R2_Lo */
	{ 0x43, 0x00 },	/* 0843 -,-,-,-,-,-,SEL_SH_S1_Hi */
	{ 0x44, 0x1D },	/* 0844 SEL_SH_S1_Lo */
	{ 0x45, 0x00 },	/* 0845 -,-,-,-,-,-,SEL_SH_R1_Hi */
	{ 0x46, 0x00 },	/* 0846 SEL_SH_R1_Lo */
	{ 0x47, 0x00 },	/* 0847 -,-,-,-,-,-,SEL_SH_S2_Hi */
	{ 0x48, 0x00 },	/* 0848 SEL_SH_S2_Lo */
	{ 0x49, 0x01 },	/* 0849 -,-,-,-,-,-,SEL_SH_R2_Hi */
	{ 0x4A, 0x1F },	/* 084A SEL_SH_R2_Lo */
	{ 0x4B, 0x00 },	/* 084B -,-,-,-,-,-,RST_SH_S1_Hi */
	{ 0x4C, 0x05 },	/* 084C RST_SH_S1_Lo */
	{ 0x4D, 0x00 },	/* 084D -,-,-,-,-,-,RST_SH_R1_Hi */
	{ 0x4E, 0x19 },	/* 084E RST_SH_R1_Lo */
	{ 0x4F, 0x01 },	/* 084F -,-,-,-,-,-,RST_SH_S2_Hi */
	{ 0x50, 0x21 },	/* 0850 RST_SH_S2_Lo */
	{ 0x51, 0x01 },	/* 0851 -,-,-,-,-,-,RST_SH_R2_Hi */
	{ 0x52, 0x5D },	/* 0852 RST_SH_R2_Lo */
	{ 0x53, 0x00 },	/* 0853 -,-,-,-,-,-,RST_SH_S1_R_Hi */
	{ 0x54, 0x00 },	/* 0854 RST_SH_S1_R_Lo */
	{ 0x55, 0x00 },	/* 0855 -,-,-,-,-,-,RST_SH_R1_R_Hi */
	{ 0x56, 0x19 },	/* 0856 RST_SH_R1_R_Lo */
	{ 0x57, 0x01 },	/* 0857 -,-,-,-,-,-,RST_SH_S2_R_Hi */
	{ 0x58, 0x21 },	/* 0858 RST_SH_S2_R_Lo */
	{ 0x59, 0x00 },	/* 0859 -,-,-,-,-,-,RST_SH_R2_R_Hi */
	{ 0x5A, 0x00 },	/* 085A RST_SH_R2_R_Lo */
	{ 0x5B, 0x00 },	/* 085B -,-,-,-,-,-,TXCLK_SH_S0_Hi */
	{ 0x5C, 0x00 },	/* 085C TXCLK_SH_S0_Lo */
	{ 0x5D, 0x00 },	/* 085D -,-,-,-,-,-,TXCLK_SH_R0_Hi */
	{ 0x5E, 0x00 },	/* 085E TXCLK_SH_R0_Lo */
	{ 0x5F, 0x00 },	/* 085F -,-,-,-,-,-,TXCLK_SH_S1_Hi */
	{ 0x60, 0xB3 },	/* 0860 TXCLK_SH_S1_Lo */
	{ 0x61, 0x00 },	/* 0861 -,-,-,-,-,-,TXCLK_SH_R1_Hi */
	{ 0x62, 0xE3 },	/* 0862 TXCLK_SH_R1_Lo */
	{ 0x63, 0x00 },	/* 0863 -,-,-,-,-,-,TXCLK_SH_S2_Hi */
	{ 0x64, 0x00 },	/* 0864 TXCLK_SH_S2_Lo */
	{ 0x65, 0x00 },	/* 0865 -,-,-,-,-,-,TXCLK_SH_R2_Hi */
	{ 0x66, 0x00 },	/* 0866 TXCLK_SH_R2_Lo */
	{ 0x67, 0x00 },	/* 0867 -,-,-,-,-,-,-,DV_SH_STDBY_MODE */
	{ 0x68, 0x00 },	/* 0868 TG_MFG */
	{ 0x69, 0xE2 },	/* 0869 -,-,-,SENSOR_RESERVE7,SENSOR_RESERVE6,
						SENSOR_RESERVE5,SENSOR_RESERVE4,
						SENSOR_RESERVE3 */
	{ 0x6A, 0x00 },	/* 086A -,-,-,-,-,-,-,OB_TX_EN */
	{ 0x6B, 0x01 },	/* 086B -,-,-,-,-,-,UPDATE_OB_EN */
	{ 0x6C, 0x06 },	/* 086C -,-,-,-,HBLK_HSEL_ON,VBLK_PULSE_ON,
						SHOFF_DMY_SEL,MASK_COR_F_OP */
	{ 0x6D, 0x00 },	/* 086D -,-,-,-,-,-,TRNS_END_OFF,WAIT1FRAME */
	{ 0x6E, 0x00 },	/* 086E SELCLK_DLY */
	{ 0x6F, 0x00 },	/* 086F -,-,-,-,-,-,-,DV_RSTREG */
	{ 0x70, 0x60 },	/* 0870 SENSOR_RESERVE2,P_LOAD_MODE,PL_PULL_EN,
					PL_LOAD_OFF,PL_BIAS_CNT1,PL_BIAS_CNT0,
						PL_READ_MODE1,PL_READ_MODE0 */
	{ 0x71, 0x8C },	/* 0871 SHUFFLE_EN,ReserveA4,XFIX_SEL1,XFIX_SEL0,
						SHUFFLE_MODE1,SHUFFLE_MODE0 */
	{ 0x72, 0x10 },	/* 0872 -,-,-,CNT_IB */
	{ 0x73, 0x00 },	/* 0873 -,-,-,-,-,VREF_SEL */
	{ 0x74, 0xE0 },	/* 0874 Reserve */
	{ 0x75, 0x00 },	/* 0875 Reserve */
	{ 0x76, 0x27 },	/* 0876 TRIMBGR */
	{ 0x77, 0x01 },	/* 0877 -,-,-,-,-,-,-,SYS_CLK_EN */
	{ 0x78, 0x00 },	/* 0878 -,-,-,-,-,-,-,SYS_CLK_OFF */
	{ 0x79, 0x00 },	/* 0879 -,-,-,-,-,-,SYS_CLK_SEL */
	{ 0x7A, 0x00 },	/* 087A -,-,-,-,-,-,-,RAMP_OFF */
	{ 0x7B, 0x03 },	/* 087B -,-,-,-,-,-,RAMP_GAIN_SEL */
	{ 0x7C, 0x00 },	/* 087C RAMP_GAIN_INIT */
	{ 0x7D, 0x00 },	/* 087D RAMPDIN0L */
	{ 0x7E, 0x00 },	/* 087E -,-,-,-,-,-,RAMPDIN0M */
	{ 0x7F, 0x00 },	/* 087F RAMPDIN1L */
	{ 0x80, 0x00 },	/* 0880 -,-,-,-,-,-,RAMPDIN1M */
	{ 0x81, 0x00 },	/* 0881 CNTSTOPL */
	{ 0x82, 0x00 },	/* 0882 -,-,-,-,-,CNTSTOPH */
	{ 0x83, 0x00 },	/* 0883 RAMP_HTIMEL */
	{ 0x84, 0x00 },	/* 0884 -,-,-,-,RAMP_HTIMEH */
	{ 0x85, 0x00 },	/* 0885 RAMP_BLACK_LEVEL */
	{ 0x86, 0xF8 },	/* 0886 RAMP_FIXED_BLKLVL */
	{ 0x87, 0x00 },	/* 0887 -,-,-,-,-,-,AD_RS_S_Hi */
	{ 0x88, 0x03 },	/* 0888 AD_RS_S_Lo */
	{ 0x89, 0x00 },	/* 0889 -,-,-,-,-,-,AD_RS_R_Hi */
	{ 0x8A, 0x64 },	/* 088A AD_RS_R_Lo (OLD:51) */
	{ 0x8B, 0x00 },	/* 088B -,-,-,-,-,-,AD_RSD_S_Hi */
	{ 0x8C, 0x03 },	/* 088C AD_RSD_S_Lo */
	{ 0x8D, 0x00 },	/* 088D -,-,-,-,-,-,AD_RSD_R_Hi */
	{ 0x8E, 0xB1 },	/* 088E AD_RSD_R_Lo */
	{ 0x8F, 0x00 },	/* 088F -,-,-,-,-,-,AD_SSA_S_Hi */
	{ 0x90, 0x03 },	/* 0890 AD_SSA_S_Lo */
	{ 0x91, 0x01 },	/* 0891 -,-,-,-,-,-,AD_SSA_R_Hi */
	{ 0x92, 0x1D },	/* 0892 AD_SSA_R_Lo */
	{ 0x93, 0x00 },	/* 0893 -,-,-,-,-,-,AD_SSB_S_Hi */
	{ 0x94, 0x03 },	/* 0894 AD_SSB_S_Lo */
	{ 0x95, 0x01 },	/* 0895 -,-,-,-,-,-,AD_SSB_R_Hi */
	{ 0x96, 0x4B },	/* 0896 AD_SSB_R_Lo */
	{ 0x97, 0x00 },	/* 0897 -,-,-,-,-,-,AD_RI_S_Hi */
	{ 0x98, 0xE5 },	/* 0898 AD_RI_S_Lo */
	{ 0x99, 0x00 },	/* 0899 -,-,-,-,-,-,AD_RI_R_Hi */
	{ 0x9A, 0x01 },	/* 089A AD_RI_R_Lo */
	{ 0x9B, 0x00 },	/* 089B -,-,-,-,-,AD_COMP3RD_EN_S_Hi */
	{ 0x9C, 0x01 },	/* 089C AD_COMP3RD_EN_S_Lo */
	{ 0x9D, 0x04 },	/* 089D -,-,-,-,-,AD_COMP3RD_EN_R_Hi */
	{ 0x9E, 0xC8 },	/* 089E AD_COMP3RD_EN_R_Lo */
	{ 0x9F, 0x00 },	/* 089F -,-,-,-,-,-,AD_RAMP_AZ_S_Hi */
	{ 0xA0, 0x01 },	/* 08A0 AD_RAMP_AZ_S_Lo */
	{ 0xA1, 0x01 },	/* 08A1 -,-,-,-,-,-,AD_RAMP_AZ_R_Hi */
	{ 0xA2, 0x61 },	/* 08A2 AD_RAMP_AZ_R_Lo */
	{ 0xA3, 0x00 },	/* 08A3 -,-,-,COLSHC */
	{ 0xA4, 0x01 },	/* 08A4 -,-,-,-,-,-,RAMP_DIRECT,PTHR_SEL */
	{ 0xA5, 0x00 },	/* 08A5 RAMP_START_PERIOD_Hi */
	{ 0xA6, 0x00 },	/* 08A6 RAMP_START_PERIOD_Lo */
	{ 0xA7, 0x00 },	/* 08A7 DECH_START_PERIOD_Hi */
	{ 0xA8, 0x00 },	/* 08A8 DECH_START_PERIOD_Lo */
	{ 0xA9, 0x00 },	/* 08A9 -,-,-,STLINE2LINE,PTHR_RD,RAMPHSEL_MOV_EN,
							PTHR_POS,HSEL_POS */
	{ 0xAA, 0x7F },	/* 08AA RAMP_BLK_OVER */
	{ 0xAB, 0x03 },	/* 08AB -,-,reserve,RAMP_BLK_OVER_EN,reserve,
						RAMP_8_STILL_EN,RAMP_4_STILL_EN,
						RAMP_0_STILL_EN */
	{ 0xAC, 0x00 },	/* 08AC -,-,-,-,-,-,VRAMP_OUT_AL_EN,VRAMP_VDD_AL_EN */
	{ 0xAD, 0x00 },	/* 08AD OBUP_1ONLY,GCNT_ONLY,OBUP_P3_OFF,OBDN_P3_OFF,
				OBUP_P2_OFF,OBDN_P2_OFF,OBUP_P1_OFF, 0xOBDN_P1_OFF
								 (AD 3D) */
	{ 0xAE, 0x00 },	/* 08AE reserve */
	{ 0xAF, 0x00 },	/* 08AF reserve */
	{ 0xB0, 0x00 },	/* 08B0 reserve */
	{ 0xB1, 0x00 },	/* 08B1 reserve */
			/* 08B2 (Read only) FINE_INTEGRATION_TIME_Hi */
			/* 08B3 (Read only) FINE_INTEGRATION_TIME_Lo */
			/* 08B4 (Read only) COARSE_INTEGRATION_TIME_Hi */
			/* 08B5 (Read only) COARSE_INTEGRATION_TIME_Lo */
	{ 0xB6, 0x00 },	/* 08B6 AD_PULSE_OFF */
	{ 0xB7, 0x01 },	/* 08B7 VBLK_DMY_SH0_ADDR */
	{ 0xB8, 0x00 },	/* 08B8 VBLK_DMY_SH1_ADDR */
	{ 0xB9, 0x00 },	/* 08B9 VBLK_DMY_RD_ADDR */
	{ 0xBA, 0x02 },	/* 08BA SENSOR_RESERVE15,SENSOR_RESERVE14,
				SENSOR_RESERVE13,SENSOR_RESERVE12,
				SENSOR_RESERVE11,SENSOR_RESERVE10,
				SENSOR_RESERVE9,reserve */
	{ 0xBB, 0x00 },	/* 08BB SENSOR_RESERVE23,SENSOR_RESERVE22,
				SENSOR_RESERVE21,SENSOR_RESERVE20,
				SENSOR_RESERVE19,SENSOR_RESERVE18,
				SENSOR_RESERVE17,SENSOR_RESERVE16 */
			/* 08BC - 08FD -,-,-,-,-,-,-,- */
	{ 0xBC, 0xFF },	/* 08BC */
	{ 0xBD, 0x00 },	/* 08BD */
	{ 0xFE, 0x02 },
	{ 0xFF, 0x07 },	/* BANK 07 */
	{ 0x18, 0x85 },	/* 0718 E_EXCLK,-,-,SOFT_STDBY,SEN_CLK_RSTX,SEN_RSTX,
							TG_RSTX,DSP_RSTX */
	{ 0xFF, 0x04 },	/* BANK 04 */
	{ 0x28, 0x01 },
	{ 0x28, 0x00 },
	{ 0xFF, 0x07 },	/* BANK 07 */
	{ 0x18, 0x87 },	/* 0718 E_EXCLK,-,-,SOFT_STDBY,SEN_CLK_RSTX,SEN_RSTX,
							TG_RSTX,DSP_RSTX */
	{ 0xFE, 0x02 },
	{ 0xFF, 0x05 },	/* BANK5 */
	{ 0x51, 0x2D },	/* 0551 WBR_MIN */
	{ 0x52, 0xA0 },	/* 0552 WBR_MAX */
	{ 0x53, 0x38 },	/* 0553 WBB_MIN */
	{ 0x54, 0x8C },	/* 0554 WBB_MAX */
	{ 0x59, 0x40 },	/* 0559 WBR_MIN_LIM */
	{ 0x5A, 0x88 },	/* 055A WBR_MAX_LIM */
	{ 0x5B, 0x48 },	/* 055B WBB_MIN_LIM */
	{ 0x5C, 0x78 }	/* 055C WBB_MAX_LIM */

--Boundary-00=_rt3FLqtov2gnZRd--

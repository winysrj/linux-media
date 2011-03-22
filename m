Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab1CVRxF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 13:53:05 -0400
Message-ID: <4D88E1FB.5070503@redhat.com>
Date: Tue, 22 Mar 2011 14:52:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mythri P K <mythripk@ti.com>
CC: linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] HDMI:Support for EDID parsing in kernel.
References: <1300815176-21206-1-git-send-email-mythripk@ti.com>
In-Reply-To: <1300815176-21206-1-git-send-email-mythripk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 22-03-2011 14:32, Mythri P K escreveu:
> Adding support for common EDID parsing in kernel.
> 
> EDID - Extended display identification data is a data structure provided by
> a digital display to describe its capabilities to a video source, This a 
> standard supported by CEA and VESA.
> 
> There are several custom implementations for parsing EDID in kernel, some
> of them are present in fbmon.c, drm_edid.c, sh_mobile_hdmi.c, Ideally
> parsing of EDID should be done in a library, which is agnostic of the
> framework (V4l2, DRM, FB)  which is using the functionality, just based on 
> the raw EDID pointer with size/segment information.
> 
> With other RFC's such as the one below, which tries to standardize HDMI API's
> It would be better to have a common EDID code in one place.It also helps to
> provide better interoperability with variety of TV/Monitor may be even by
> listing out quirks which might get missed with several custom implementation
> of EDID.
> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/30401
> 
> This patch tries to add functions to parse some portion EDID (detailed timing,
> monitor limits, AV delay information, deep color mode support, Audio and VSDB)
> If we can align on this library approach i can enhance this library to parse
> other blocks and probably we could also add quirks from other implementation
> as well.
> 
> Signed-off-by: Mythri P K <mythripk@ti.com>
> ---
>  arch/arm/include/asm/edid.h |  243 ++++++++++++++++++++++++++++++
>  drivers/video/edid.c        |  340 +++++++++++++++++++++++++++++++++++++++++++

Hmm... if you want this to be agnostic, the header file should not be inside
arch/arm, but on some other place, like include/video/.

>  2 files changed, 583 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/include/asm/edid.h
>  create mode 100644 drivers/video/edid.c
> 
> diff --git a/arch/arm/include/asm/edid.h b/arch/arm/include/asm/edid.h
> new file mode 100644
> index 0000000..843346a
> --- /dev/null
> +++ b/arch/arm/include/asm/edid.h
> @@ -0,0 +1,243 @@
> +/*
> + * edid.h
> + *
> + * Copyright (C) 2011 Texas Instruments
> + * Author: Mythri P K <mythripk@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + * History:
> + */
> +
> +#ifndef _EDID_H_
> +#define _EDID_H_
> +
> +/* HDMI EDID Length */
> +#define HDMI_EDID_MAX_LENGTH			512
> +
> +/* HDMI EDID Extension Data Block Tags  */
> +#define HDMI_EDID_EX_DATABLOCK_TAG_MASK		0xE0
> +#define HDMI_EDID_EX_DATABLOCK_LEN_MASK		0x1F
> +
> +#define EDID_TIMING_DESCRIPTOR_SIZE		0x12
> +#define EDID_DESCRIPTOR_BLOCK0_ADDRESS		0x36
> +#define EDID_DESCRIPTOR_BLOCK1_ADDRESS		0x80
> +#define EDID_SIZE_BLOCK0_TIMING_DESCRIPTOR	4
> +#define EDID_SIZE_BLOCK1_TIMING_DESCRIPTOR	4
> +
> +/* EDID Detailed Timing	Info 0 begin offset */
> +#define HDMI_EDID_DETAILED_TIMING_OFFSET	0x36
> +
> +#define HDMI_EDID_PIX_CLK_OFFSET		0
> +#define HDMI_EDID_H_ACTIVE_OFFSET		2
> +#define HDMI_EDID_H_BLANKING_OFFSET		3
> +#define HDMI_EDID_V_ACTIVE_OFFSET		5
> +#define HDMI_EDID_V_BLANKING_OFFSET		6
> +#define HDMI_EDID_H_SYNC_OFFSET			8
> +#define HDMI_EDID_H_SYNC_PW_OFFSET		9
> +#define HDMI_EDID_V_SYNC_OFFSET			10
> +#define HDMI_EDID_V_SYNC_PW_OFFSET		11
> +#define HDMI_EDID_H_IMAGE_SIZE_OFFSET		12
> +#define HDMI_EDID_V_IMAGE_SIZE_OFFSET		13
> +#define HDMI_EDID_H_BORDER_OFFSET		15
> +#define HDMI_EDID_V_BORDER_OFFSET		16
> +#define HDMI_EDID_FLAGS_OFFSET			17
> +
> +/* HDMI EDID DTDs */
> +#define HDMI_EDID_MAX_DTDS			4
> +
> +/* HDMI EDID DTD Tags */
> +#define HDMI_EDID_DTD_TAG_MONITOR_NAME		0xFC
> +#define HDMI_EDID_DTD_TAG_MONITOR_SERIALNUM	0xFF
> +#define HDMI_EDID_DTD_TAG_MONITOR_LIMITS	0xFD
> +#define HDMI_EDID_DTD_TAG_STANDARD_TIMING_DATA	0xFA
> +#define HDMI_EDID_DTD_TAG_COLOR_POINT_DATA	0xFB
> +#define HDMI_EDID_DTD_TAG_ASCII_STRING		0xFE
> +
> +#define HDMI_IMG_FORMAT_MAX_LENGTH		20
> +#define HDMI_AUDIO_FORMAT_MAX_LENGTH		10
> +
> +/* HDMI EDID Extenion Data Block Values: Video */
> +#define HDMI_EDID_EX_VIDEO_NATIVE		0x80
> +#define HDMI_EDID_EX_VIDEO_MASK			0x7F
> +#define HDMI_EDID_EX_VIDEO_MAX			35
> +
> +#define STANDARD_HDMI_TIMINGS_NB		34
> +#define STANDARD_HDMI_TIMINGS_VESA_START	15
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +enum extension_edid_db {
> +	DATABLOCK_AUDIO	= 1,
> +	DATABLOCK_VIDEO	= 2,
> +	DATABLOCK_VENDOR = 3,
> +	DATABLOCK_SPEAKERS = 4,
> +};
> +
> +struct img_edid {
> +	bool pref;
> +	int code;
> +};
> +
> +struct image_format {
> +	int length;
> +	struct img_edid fmt[HDMI_IMG_FORMAT_MAX_LENGTH];
> +};
> +
> +struct audio_edid {
> +	int num_of_ch;
> +	int format;
> +};
> +
> +struct audio_format {
> +	int length;
> +	struct audio_edid fmt[HDMI_AUDIO_FORMAT_MAX_LENGTH];
> +};
> +
> +struct latency {
> +	/* vid: if indicated, value=1+ms/2 with a max of 251 meaning 500ms */
> +	int vid_latency;
> +	int aud_latency;
> +	int int_vid_latency;
> +	int int_aud_latency;
> +};
> +
> +struct deep_color {
> +	bool bit_30;
> +	bool bit_36;
> +	int max_tmds_freq;
> +};
> +
> +/*  Video Descriptor Block  */
> +struct HDMI_EDID_DTD_VIDEO {
> +	u16	pixel_clock;		/* 54-55 */
> +	u8	horiz_active;		/* 56 */
> +	u8	horiz_blanking;		/* 57 */
> +	u8	horiz_high;		/* 58 */
> +	u8	vert_active;		/* 59 */
> +	u8	vert_blanking;		/* 60 */
> +	u8	vert_high;		/* 61 */
> +	u8	horiz_sync_offset;	/* 62 */
> +	u8	horiz_sync_pulse;	/* 63 */
> +	u8	vert_sync_pulse;	/* 64 */
> +	u8	sync_pulse_high;	/* 65 */
> +	u8	horiz_image_size;	/* 66 */
> +	u8	vert_image_size;	/* 67 */
> +	u8	image_size_high;	/* 68 */
> +	u8	horiz_border;		/* 69 */
> +	u8	vert_border;		/* 70 */
> +	u8	misc_settings;		/* 71 */
> +};
> +
> +/*	Monitor Limits Descriptor Block	*/
> +struct HDMI_EDID_DTD_MONITOR {
> +	u16	pixel_clock;		/* 54-55*/
> +	u8	_reserved1;		/* 56 */
> +	u8	block_type;		/* 57 */
> +	u8	_reserved2;		/* 58 */
> +	u8	min_vert_freq;		/* 59 */
> +	u8	max_vert_freq;		/* 60 */
> +	u8	min_horiz_freq;		/* 61 */
> +	u8	max_horiz_freq;		/* 62 */
> +	u8	pixel_clock_mhz;	/* 63 */
> +	u8	GTF[2];			/* 64 -65 */
> +	u8	start_horiz_freq;	/* 66	*/
> +	u8	C;			/* 67 */
> +	u8	M[2];			/* 68-69 */
> +	u8	K;			/* 70 */
> +	u8	J;			/* 71 */
> +
> +} __packed;
> +
> +/* Text Descriptor Block */
> +struct HDMI_EDID_DTD_TEXT {
> +	u16	pixel_clock;		/* 54-55 */
> +	u8	_reserved1;		/* 56 */
> +	u8	block_type;		/* 57 */
> +	u8	_reserved2;		/* 58 */
> +	u8	text[13];		/* 59-71 */
> +} __packed;
> +
> +/* DTD Union */
> +union HDMI_EDID_DTD {
> +	struct HDMI_EDID_DTD_VIDEO	video;
> +	struct HDMI_EDID_DTD_TEXT	monitor_name;
> +	struct HDMI_EDID_DTD_TEXT	monitor_serial_number;
> +	struct HDMI_EDID_DTD_TEXT	ascii;
> +	struct HDMI_EDID_DTD_MONITOR	monitor_limits;
> +} __packed;
> +
> +/*	EDID struct	*/
> +struct HDMI_EDID {
> +	u8	header[8];		/* 00-07 */
> +	u16	manufacturerID;		/* 08-09 */
> +	u16	product_id;		/* 10-11 */
> +	u32	serial_number;		/* 12-15 */
> +	u8	week_manufactured;	/* 16 */
> +	u8	year_manufactured;	/* 17 */
> +	u8	edid_version;		/* 18 */
> +	u8	edid_revision;		/* 19 */
> +	u8	video_in_definition;	/* 20 */
> +	u8	max_horiz_image_size;	/* 21 */
> +	u8	max_vert_image_size;	/* 22 */
> +	u8	display_gamma;		/* 23 */
> +	u8	power_features;		/* 24 */
> +	u8	chroma_info[10];	/* 25-34 */
> +	u8	timing_1;		/* 35 */
> +	u8	timing_2;		/* 36 */
> +	u8	timing_3;		/* 37 */
> +	u8	std_timings[16];	/* 38-53 */
> +	union	HDMI_EDID_DTD DTD[4];	/* 54-125 */
> +	u8	extension_edid;		/* 126 */
> +	u8	checksum;		/* 127 */
> +	u8	extension_tag;		/* 00 (extensions follow EDID) */
> +	u8	extention_rev;		/* 01 */
> +	u8	offset_dtd;		/* 02 */
> +	u8	num_dtd;		/* 03 */
> +	u8	data_block[123];	/* 04 - 126 */
> +	u8	extension_checksum;	/* 127 */
> +
> +	u8	ext_datablock[256];
> +} __packed;
> +
> +struct hdmi_timings {
> +
> +	u16 x_res;
> +	u16 y_res;
> +	u32 pixel_clock;	/* pixel clock in KHz */
> +	u16 hsw;		/* Horizontal synchronization pulse width */
> +	u16 hfp;		/* Horizontal front porch */
> +	u16 hbp;		/* Horizontal back porch */
> +	u16 vsw;		/* Vertical synchronization pulse width */
> +	u16 vfp;		/* Vertical front porch */
> +	u16 vbp;		/* Vertical back porch */
> +};
> +
> +int get_edid_timing_info(union HDMI_EDID_DTD *edid_dtd,
> +				struct hdmi_timings *timings);
> +void get_eedid_timing_info(int current_descriptor_addrs, u8 *edid ,
> +				struct hdmi_timings *timings);
> +int hdmi_get_datablock_offset(u8 *edid, enum extension_edid_db datablock,
> +				int *offset);
> +int hdmi_get_image_format(u8 *edid, struct image_format *format);
> +int hdmi_get_audio_format(u8 *edid, struct audio_format *format);
> +void hdmi_get_av_delay(u8 *edid, struct latency *lat);
> +void hdmi_deep_color_support_info(u8 *edid, struct deep_color *format);
> +bool hdmi_tv_yuv_supported(u8 *edid);
> +
> +#ifdef __cplusplus
> +};
> +#endif
> +
> +#endif
> diff --git a/drivers/video/edid.c b/drivers/video/edid.c
> new file mode 100644
> index 0000000..4eb2074
> --- /dev/null
> +++ b/drivers/video/edid.c
> @@ -0,0 +1,340 @@
> +/*
> + * edid.c
> + *
> + * Copyright (C) 2011 Texas Instruments
> + * Author: Mythri P K <mythripk@ti.com>
> + *         With EDID parsing for DVI Monitor from Rob Clark <rob@ti.com>
> + *
> + * EDID.c to parse the EDID content.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + * History:
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/err.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <asm/edid.h>
> +
> +/* Standard HDMI/VESA timings */
> +const struct hdmi_timings standard_hdmi_timings[STANDARD_HDMI_TIMINGS_NB] = {
> +	{640, 480, 25200, 96, 16, 48, 2, 10, 33},
> +	{1280, 720, 74250, 40, 440, 220, 5, 5, 20},
> +	{1280, 720, 74250, 40, 110, 220, 5, 5, 20},
> +	{720, 480, 27027, 62, 16, 60, 6, 9, 30},
> +	{2880, 576, 108000, 256, 48, 272, 5, 5, 39},
> +	{1440, 240, 27027, 124, 38, 114, 3, 4, 15},
> +	{1440, 288, 27000, 126, 24, 138, 3, 2, 19},
> +	{1920, 540, 74250, 44, 528, 148, 5, 2, 15},
> +	{1920, 540, 74250, 44, 88, 148, 5, 2, 15},
> +	{1920, 1080, 148500, 44, 88, 148, 5, 4, 36},
> +	{720, 576, 27000, 64, 12, 68, 5, 5, 39},
> +	{1440, 576, 54000, 128, 24, 136, 5, 5, 39},
> +	{1920, 1080, 148500, 44, 528, 148, 5, 4, 36},
> +	{2880, 480, 108108, 248, 64, 240, 6, 9, 30},
> +	{1920, 1080, 74250, 44, 638, 148, 5, 4, 36},
> +	/* Vesa frome here */
> +	{640, 480, 25175, 96, 16, 48, 2 , 11, 31},
> +	{800, 600, 40000, 128, 40, 88, 4 , 1, 23},
> +	{848, 480, 33750, 112, 16, 112, 8 , 6, 23},
> +	{1280, 768, 79500, 128, 64, 192, 7 , 3, 20},
> +	{1280, 800, 83500, 128, 72, 200, 6 , 3, 22},
> +	{1360, 768, 85500, 112, 64, 256, 6 , 3, 18},
> +	{1280, 960, 108000, 112, 96, 312, 3 , 1, 36},
> +	{1280, 1024, 108000, 112, 48, 248, 3 , 1, 38},
> +	{1024, 768, 65000, 136, 24, 160, 6, 3, 29},
> +	{1400, 1050, 121750, 144, 88, 232, 4, 3, 32},
> +	{1440, 900, 106500, 152, 80, 232, 6, 3, 25},
> +	{1680, 1050, 146250, 176 , 104, 280, 6, 3, 30},
> +	{1366, 768, 85500, 143, 70, 213, 3, 3, 24},
> +	{1920, 1080, 148500, 44, 88, 80, 5, 4, 36},
> +	{1280, 768, 68250, 32, 48, 80, 7, 3, 12},
> +	{1400, 1050, 101000, 32, 48, 80, 4, 3, 23},
> +	{1680, 1050, 119000, 32, 48, 80, 6, 3, 21},
> +	{1280, 800, 79500, 32, 48, 80, 6, 3, 14},
> +	{1280, 720, 74250, 40, 110, 220, 5, 5, 20}
> +};
> +
> +int get_edid_timing_info(union HDMI_EDID_DTD *edid_dtd,
> +					struct hdmi_timings *timings)
> +{
> +	if (edid_dtd->video.pixel_clock) {
> +		struct HDMI_EDID_DTD_VIDEO *vid = &edid_dtd->video;
> +
> +		timings->pixel_clock = 10 * vid->pixel_clock;
> +		timings->x_res = vid->horiz_active |
> +				(((u16)vid->horiz_high & 0xf0) << 4);
> +		timings->y_res = vid->vert_active |
> +				(((u16)vid->vert_high & 0xf0) << 4);
> +		timings->hfp = vid->horiz_sync_offset |
> +				(((u16)vid->sync_pulse_high & 0xc0) << 2);
> +		timings->hsw = vid->horiz_sync_pulse |
> +				(((u16)vid->sync_pulse_high & 0x30) << 4);
> +		timings->hbp = (vid->horiz_blanking |
> +				(((u16)vid->horiz_high & 0x0f) << 8)) -
> +				(timings->hfp + timings->hsw);
> +		timings->vfp = ((vid->vert_sync_pulse & 0xf0) >> 4) |
> +				((vid->sync_pulse_high & 0x0f) << 2);
> +		timings->vsw = (vid->vert_sync_pulse & 0x0f) |
> +				((vid->sync_pulse_high & 0x03) << 4);
> +		timings->vbp = (vid->vert_blanking |
> +				(((u16)vid->vert_high & 0x0f) << 8)) -
> +				(timings->vfp + timings->vsw);
> +		return 0;
> +	}
> +
> +	switch (edid_dtd->monitor_name.block_type) {
> +	case HDMI_EDID_DTD_TAG_STANDARD_TIMING_DATA:
> +		printk(KERN_INFO "standard timing data\n");
> +		return -EINVAL;
> +	case HDMI_EDID_DTD_TAG_COLOR_POINT_DATA:
> +		printk(KERN_INFO "color point data\n");
> +		return -EINVAL;
> +	case HDMI_EDID_DTD_TAG_MONITOR_NAME:
> +		printk(KERN_INFO "monitor name: %s\n",
> +						edid_dtd->monitor_name.text);
> +		return -EINVAL;
> +	case HDMI_EDID_DTD_TAG_MONITOR_LIMITS:
> +	{
> +		int i, max_area = 0, best_idx = -1;
> +		struct HDMI_EDID_DTD_MONITOR *limits =
> +						&edid_dtd->monitor_limits;
> +
> +		printk(KERN_DEBUG "  monitor limits\n");
> +		printk(KERN_DEBUG "  min_vert_freq=%d\n",
> +					limits->min_vert_freq);
> +		printk(KERN_DEBUG "  max_vert_freq=%d\n",
> +					limits->max_vert_freq);
> +		printk(KERN_DEBUG "  min_horiz_freq=%d\n",
> +					limits->min_horiz_freq);
> +		printk(KERN_DEBUG "  max_horiz_freq=%d\n",
> +					limits->max_horiz_freq);
> +		printk(KERN_DEBUG "  pixel_clock_mhz=%d\n",
> +					limits->pixel_clock_mhz * 10);
> +
> +		/* find the highest matching resolution (w*h) */
> +
> +		/*
> +		 * XXX since this is mainly for DVI monitors, should we only
> +		 * support VESA timings?  My monitor at home would pick
> +		 * 1920x1080 otherwise, but that seems to not work well (monitor
> +		 * blanks out and comes back, and picture doesn't fill full
> +		 * screen, but leaves a black bar on left (native res is
> +		 * 2048x1152). However if I only consider VESA timings, it picks
> +		 * 1680x1050 and the picture is stable and fills whole screen
> +		 */
> +		for (i = STANDARD_HDMI_TIMINGS_VESA_START;
> +					i < STANDARD_HDMI_TIMINGS_NB; i++) {
> +			const struct hdmi_timings *timings =
> +						 &standard_hdmi_timings[i];
> +			int hz, hscan, pixclock;
> +			int vtotal, htotal;
> +			htotal = timings->hbp + timings->hfp +
> +					timings->hsw + timings->x_res;
> +			vtotal = timings->vbp + timings->vfp +
> +					timings->vsw + timings->y_res;
> +
> +			/* NOTE: We don't support interlaced mode for VESA */
> +			pixclock = timings->pixel_clock * 1000;
> +			hscan = (pixclock + htotal / 2) / htotal;
> +			hscan = (hscan + 500) / 1000 * 1000;
> +			hz = (hscan + vtotal / 2) / vtotal;
> +			hscan /= 1000;
> +			pixclock /= 1000000;
> +			if ((pixclock < (limits->pixel_clock_mhz * 10)) &&
> +				(limits->min_horiz_freq <= hscan) &&
> +				(hscan <= limits->max_horiz_freq) &&
> +				(limits->min_vert_freq <= hz) &&
> +				(hz <= limits->max_vert_freq)) {
> +				int area = timings->x_res * timings->y_res;
> +				printk(KERN_INFO " -> %d: %dx%d\n", i,
> +					timings->x_res, timings->y_res);
> +				if (area > max_area) {
> +					max_area = area;
> +					best_idx = i;
> +				}
> +			}
> +		}
> +		if (best_idx > 0) {
> +			*timings = standard_hdmi_timings[best_idx];
> +			printk(KERN_DEBUG "found best resolution: %dx%d (%d)\n",
> +				timings->x_res, timings->y_res, best_idx);
> +		}
> +		return 0;
> +	}
> +	case HDMI_EDID_DTD_TAG_ASCII_STRING:
> +		printk(KERN_INFO "ascii string: %s\n", edid_dtd->ascii.text);
> +		return -EINVAL;
> +	case HDMI_EDID_DTD_TAG_MONITOR_SERIALNUM:
> +		printk(KERN_INFO "monitor serialnum: %s\n",
> +			edid_dtd->monitor_serial_number.text);
> +		return -EINVAL;
> +	default:
> +		printk(KERN_INFO "unsupported EDID descriptor block format\n");
> +		return -EINVAL;
> +	}
> +}
> +
> +void get_eedid_timing_info(int current_descriptor_addrs, u8 *edid ,
> +			struct hdmi_timings *timings)
> +{
> +	timings->x_res = (((edid[current_descriptor_addrs + 4] & 0xF0) << 4)
> +				| edid[current_descriptor_addrs + 2]);
> +	timings->y_res = (((edid[current_descriptor_addrs + 7] & 0xF0) << 4)
> +				| edid[current_descriptor_addrs + 5]);
> +	timings->pixel_clock = ((edid[current_descriptor_addrs + 1] << 8)
> +				| edid[current_descriptor_addrs]);
> +	timings->pixel_clock = 10 * timings->pixel_clock;
> +	timings->hfp = edid[current_descriptor_addrs + 8];
> +	timings->hsw = edid[current_descriptor_addrs + 9];
> +	timings->hbp = (((edid[current_descriptor_addrs + 4] & 0x0F) << 8)
> +				| edid[current_descriptor_addrs + 3]) -
> +				(timings->hfp + timings->hsw);
> +	timings->vfp = ((edid[current_descriptor_addrs + 10] & 0xF0) >> 4);
> +	timings->vsw = (edid[current_descriptor_addrs + 10] & 0x0F);
> +	timings->vbp = (((edid[current_descriptor_addrs + 7] & 0x0F) << 8)
> +				| edid[current_descriptor_addrs + 6]) -
> +				(timings->vfp + timings->vsw);
> +}
> +
> +int hdmi_get_datablock_offset(u8 *edid, enum extension_edid_db datablock,
> +								int *offset)
> +{
> +	int current_byte, disp, i = 0, length = 0;
> +
> +	if (edid[0x7e] == 0x00)
> +		return -EINVAL;
> +
> +	disp = edid[(0x80) + 2];
> +	if (disp == 0x4)
> +		return -EINVAL;
> +
> +	i = 0x80 + 0x4;
> +	printk(KERN_INFO "%x\n", i);
> +	while (i < (0x80 + disp)) {
> +		current_byte = edid[i];
> +		if ((current_byte >> 5)	== datablock) {
> +			*offset = i;
> +			printk(KERN_INFO "datablock %d %d\n",
> +							datablock, *offset);
> +			return 0;
> +		} else {
> +			length = (current_byte &
> +					HDMI_EDID_EX_DATABLOCK_LEN_MASK) + 1;
> +			i += length;
> +		}
> +	}
> +	return -EINVAL;
> +}
> +
> +int hdmi_get_image_format(u8 *edid, struct image_format *format)
> +{
> +	int offset, current_byte, j = 0, length = 0;
> +	enum extension_edid_db vsdb =  DATABLOCK_VIDEO;
> +	format->length = 0;
> +
> +	memset(format->fmt, 0, sizeof(format->fmt));
> +	if (!hdmi_get_datablock_offset(edid, vsdb, &offset)) {
> +		current_byte = edid[offset];
> +		length = current_byte & HDMI_EDID_EX_DATABLOCK_LEN_MASK;
> +
> +		if (length >= HDMI_IMG_FORMAT_MAX_LENGTH)
> +			format->length = HDMI_IMG_FORMAT_MAX_LENGTH;
> +		else
> +			format->length = length;
> +
> +		for (j = 1 ; j < length ; j++) {
> +			current_byte = edid[offset+j];
> +			format->fmt[j-1].code = current_byte & 0x7F;
> +			format->fmt[j-1].pref = current_byte & 0x80;
> +		}
> +	}
> +	return 0;
> +}
> +
> +int hdmi_get_audio_format(u8 *edid, struct audio_format *format)
> +{
> +	int offset, current_byte, j = 0, length = 0;
> +	enum extension_edid_db vsdb =  DATABLOCK_AUDIO;
> +
> +	format->length = 0;
> +	memset(format->fmt, 0, sizeof(format->fmt));
> +
> +	if (!hdmi_get_datablock_offset(edid, vsdb, &offset)) {
> +		current_byte = edid[offset];
> +		length = current_byte & HDMI_EDID_EX_DATABLOCK_LEN_MASK;
> +
> +		if (length >= HDMI_AUDIO_FORMAT_MAX_LENGTH)
> +			format->length = HDMI_AUDIO_FORMAT_MAX_LENGTH;
> +		else
> +			format->length = length;
> +
> +		for (j = 1 ; j < length ; j++) {
> +			if (j%3 == 1) {
> +				current_byte = edid[offset + j];
> +				format->fmt[j-1].format = current_byte & 0x78;
> +				format->fmt[j-1].num_of_ch =
> +						(current_byte & 0x07) + 1;
> +			}
> +		}
> +	}
> +	return 0;
> +}
> +
> +void hdmi_get_av_delay(u8 *edid, struct latency *lat)
> +{
> +	int offset, current_byte, length = 0;
> +	enum extension_edid_db vsdb =  DATABLOCK_VENDOR;
> +
> +	if (!hdmi_get_datablock_offset(edid, vsdb, &offset)) {
> +		current_byte = edid[offset];
> +		length = current_byte & HDMI_EDID_EX_DATABLOCK_LEN_MASK;
> +		if (length >= 8 && ((current_byte + 8) & 0x80)) {
> +			lat->vid_latency = (edid[offset + 8] - 1) * 2;
> +			lat->aud_latency = (edid[offset + 9] - 1) * 2;
> +		}
> +		if (length >= 8 && ((current_byte + 8) & 0xC0)) {
> +			lat->int_vid_latency = (edid[offset + 10] - 1) * 2;
> +			lat->int_aud_latency = (edid[offset + 11] - 1) * 2;
> +		}
> +	}
> +}
> +
> +void hdmi_deep_color_support_info(u8 *edid, struct deep_color *format)
> +{
> +	int offset, current_byte, length = 0;
> +	enum extension_edid_db vsdb = DATABLOCK_VENDOR;
> +	memset(format, 0, sizeof(*format));
> +
> +	if (!hdmi_get_datablock_offset(edid, vsdb, &offset)) {
> +		current_byte = edid[offset];
> +		length = current_byte & HDMI_EDID_EX_DATABLOCK_LEN_MASK;
> +		if (length >= 6) {
> +			format->bit_30 = (edid[offset + 6] & 0x10);
> +			format->bit_36 = (edid[offset + 6] & 0x20);
> +		}
> +		if (length >= 7)
> +			format->max_tmds_freq = (edid[offset + 7]) * 5;
> +	}
> +}
> +
> +bool hdmi_tv_yuv_supported(u8 *edid)
> +{
> +	if (edid[0x7e] != 0x00 && edid[0x83] & 0x30) {
> +		printk(KERN_INFO "YUV supported");
> +		return true;
> +	}
> +	return false;
> +}


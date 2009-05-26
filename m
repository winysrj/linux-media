Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:56046 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZEZXgf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 19:36:35 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: m-karicheri2@ti.com
Subject: Re: [PATCH 1/9] vpfe-capture bridge driver for DM355 & DM6446
Date: Wed, 27 May 2009 01:40:53 +0200
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1242412559-11325-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1242412559-11325-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200905270140.53696.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 15 May 2009 20:35:59 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
>
> VPFE Capture bridge driver
>
> This is the vpfe capture bridge driver for doing video capture on
> DM355 and DM6446 evms. The ccdc hw modules registers with the driver

s/registers/register/

> and are used for configuring the CCD Controller for a specific
> decoder interface. The driver also registers the sub devices required
> for a specific evm. More than one sub devices can be registered.
> This allows driver to switch dynamically to capture video from
> any sub device that is registered. Currently only one sub device
> (tvp5146) is supported. But in future this driver is expected
> to do capture from sensor devices such as Micron's MT9T001,MT9T031
> and MT9P031 etc. The driver currently supports MMAP based IO.
> video0 is the device instance used for the capture.

You can't guarantee that the driver will be bound to /dev/video0. Even if you 
request minor 0, video_register_device() can assign another minor if 0 is 
already in use. Can you let video_register_device() allocate a minor 
dynamically without requesting a specific one ?

> This has been ported to sub device model and has comments incorporated
> from previous review.
>
> Reviewed By "Hans Verkuil".
> Reviewed By "Laurent Pinchart".
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to v4l-dvb repository
>
>  drivers/media/video/davinci/vpfe_capture.c | 2323
> ++++++++++++++++++++++++++++ include/media/davinci/vpfe_capture.h       | 
> 223 +++
>  include/media/davinci/vpfe_types.h         |   71 +
>  3 files changed, 2617 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/davinci/vpfe_capture.c
>  create mode 100644 include/media/davinci/vpfe_capture.h
>  create mode 100644 include/media/davinci/vpfe_types.h
>
> diff --git a/drivers/media/video/davinci/vpfe_capture.c
> b/drivers/media/video/davinci/vpfe_capture.c new file mode 100644
> index 0000000..1db3ea5
> --- /dev/null
> +++ b/drivers/media/video/davinci/vpfe_capture.c
> @@ -0,0 +1,2323 @@
> +/*
> + * Copyright (C) 2008-2009 Texas Instruments Inc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
> USA
> + *
> + * Driver name : VPFE Capture driver
> + *    VPFE Capture driver allows applications to capture and stream video
> + *    frames on DaVinci SoCs (DM6446, DM355 etc) from a yuv source such as
> + *    TVP5146 or  Raw Bayer RGB image data from an image sensor
> + *    such as Microns' MT9T001, MT9T031 etc.
> + *
> + *    These SoCs have, in common, a Video Processing Subsystem (VPSS) that
> + *    consists of a Video Processing Front End (VPFE) for capturing
> + *    video/raw image data and Video Processing Back End (VPBE) for
> displaying
> + *    YUV data through an in-built analog encoder or Digital LCD port. This
> + *    driver is for capture through VPFE. A typical EVM using these SoCs
> have
> + *    following high level configuration.
> + *
> + *
> + *    decoder(TVP5146/		Yuv/
> + * 	     MT9T001)   -->  Raw Bayer RGB ---> MUX -> VPFE (CCDC/ISIF)
> + *    				data input              |      |
> + *							V      |
> + *						      SDRAM    |
> + *							       V
> + *							   Image Processor
> + *							       |
> + *							       V
> + *							     SDRAM
> + *    The data flow happens from a decoder connected to the VPFE over a
> + *    yuv embedded (BT.656/BT.1120) or seperate sync or raw bayer rgb

s/seperate/separate/

> interface
> + *    and to the input of VPFE through an optional MUX (if more inputs are
> + *    to be interfaced on the EVM). The input data is first passed through
> + *    CCDC (CCD Controller, a.k.a Image Sensor Interface, ISIF). The CCDC
> + *    does very little or no processing on Yuv data and does pre-process

You're using yuv, Yuv and YUV in comments. To be consistent you could 
standardize that on YUV.

> Raw
> + *    Bayer RGB data through modules such as Defect Pixel Correction (DFC)
> + *    Color Space Conversion (CSC), data gain/offset etc. After this, data
> + *    can be written to SDRAM or can be connected to the image processing
> + *    block such as IPIPE (on DM355 only).
> + *
> + *    Features supported
> + *		- MMAP IO
> + *		- Capture using TVP5146 over BT.656
> + *		- support for interfacing decoders using sub device model
> + *		- Work with DM355 or DM6446 CCDC to do Raw Bayer RGB/yuv
> + *		  data capture to SDRAM.
> + *    TODO list
> + *		- Support multiple REQBUF after open
> + *		- Support for de-allocating buffers through REQBUF
> + *		- Support for Raw Bayer RGB capture
> + *		- Support for chaining Image Processor
> + *		- Support for static allocation of buffers
> + *		- Support for USERPTR IO
> + *		- Support for STREAMON before QBUF
> + */
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/version.h>
> +#include <media/v4l2-common.h>
> +#include <linux/io.h>
> +#include <mach/cpu.h>

I don't think this header file is needed.

> +#include <media/davinci/vpfe_capture.h>
> +#include <media/tvp514x.h>

We should try to get rid of the TVP514x dependency. See below where TVP5146 
support is explicit for a discussion on this.

> +#include <linux/i2c.h>
> +
> +static int debug;
> +static u32 numbuffers = 3;
> +static u32 bufsize = (720 * 576 * 2);
> +
> +module_param(numbuffers, uint, S_IRUGO);
> +module_param(bufsize, uint, S_IRUGO);
> +module_param(debug, int, 0);

Is there a reason to forbid debug from being read at runtime ?

> +
> +MODULE_PARM_DESC(numbuffers, "buffer count (default:3)");
> +MODULE_PARM_DESC(bufsize, "buffer size (default:720 x 576 x 2)");
> +MODULE_PARM_DESC(debug, "Debug level 0-1");
> +
> +#define VPFE_PIXELASPECT_NTSC       {11, 10}
> +#define VPFE_PIXELASPECT_PAL        {54, 59}

Can you move those defines down to the place where they are used ?

> +/* Internal types */
> +/* standard information */
> +struct vpfe_standard {
> +	v4l2_std_id std_id;
> +	unsigned int width;
> +	unsigned int height;
> +	struct v4l2_fract pixelaspect;
> +	/* 0 - progressive, 1 - interlaced */
> +	char frame_format;

Use an int instead of char here. The structure size won't change as it gets 
padded to the size of its largest field, and access to native data widths is 
usually faster.

> +};
> +
> +/* ccdc configuration */
> +struct ccdc_config {
> +	/* This make sure vpfe is probed and ready to go */
> +	int vpfe_probed;
> +	/* name of ccdc device */
> +	char name[32];
> +	/* for storing mem maps for CCDC */
> +	int ccdc_addr_size;
> +	void *__iomem ccdc_addr;
> +	int vpss_addr_size;
> +	void *__iomem vpss_addr;
> +};
> +
> +/* data structures */
> +static struct vpfe_config_params config_params = {
> +	.min_numbuffers = 3,
> +	.numbuffers = 3,
> +	.min_bufsize = 720 * 480 * 2,
> +	.device_bufsize = 720 * 576 * 2,
> +};
> +
> +static int vpfe_nr[] = { 0 };

vpfe_nr isn't used anymore if you don't request a specific minor.

> +/* ccdc device registered */
> +static struct ccdc_hw_device *ccdc_dev;
> +/* lock for accessing ccdc information */
> +static DEFINE_MUTEX(ccdc_lock);
> +/* ccdc configuration */
> +static struct ccdc_config *ccdc_cfg;
> +
> +static struct v4l2_capability vpfe_videocap = {
> +	.driver = CAPTURE_DRV_NAME,
> +	.bus_info = "Platform",
> +	.version = VPFE_CAPTURE_VERSION_CODE,
> +	.capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING
> +};

Instead of predefining a global instance of struct v4l2_capability and copying 
it over using memcpy() when VIDIOC_QUERYCAP is called, we usually fill the 
fields manually in the VIDIOC_QUERYCAP handler. You could then get rid of this 
structure. See below in vpfe_querycap(). If you prefer the memcpy() solution, 
please move vpfe_videocap just before vpfe_querycap() or, even better, as a 
static member inside the function.

> +struct vpfe_standard vpfe_standards[] = {
> +	{V4L2_STD_NTSC,	720, 480, VPFE_PIXELASPECT_NTSC, 1},
> +	{V4L2_STD_PAL,	720, 576, VPFE_PIXELASPECT_PAL, 1},
> +};
> +
> +static int vpfe_max_standards = ARRAY_SIZE(vpfe_standards);

As this is a compile time constant, you might want to turn it into a define 
(VPFE_MAX_STANDARDS) or use ARRAY_SIZE directly in the code. The later is 
easier to read in my opinion, as it gets clear that you're comparing to the 
array size. Using a variable/macro makes it necessary for people to look up 
the value.

> +/* Used when raw Bayer image from ccdc is directly captured to SDRAM */
> +static struct vpfe_pixel_format
> + vpfe_pix_fmts[VPFE_MAX_PIX_FORMATS] = {

Use an unbounded array (vpfe_fix_fmts[]) and use ARRAY_SIZE in place of 
VPFE_MAX_PIX_FORMATS. That way you won't need to keep VPFE_MAX_PIX_FORMATS in 
sync with the content of the array.

> +	{
> +		.pix_fmt = V4L2_PIX_FMT_SBGGR8,
> +		.desc = "Raw Bayer GrRBGb 8bit A-Law compressed",
> +		.hw_fmt = VPFE_BAYER_8BIT_PACK_ALAW,
> +	},
> +	{
> +		.pix_fmt = V4L2_PIX_FMT_SBGGR16,
> +		.desc = "Raw Bayer GrRBGb - 16bit",
> +		.hw_fmt = VPFE_BAYER,
> +	},
> +	{
> +		.pix_fmt = V4L2_PIX_FMT_SGRBG10DPCM8,
> +		.desc = "Raw Bayer GrRBGb 8 bit DPCM compressed",
> +		.hw_fmt = VPFE_BAYER_8BIT_PACK_DPCM,
> +	},
> +	{
> +		.pix_fmt = V4L2_PIX_FMT_UYVY,
> +		.desc = "YCbCr 4:2:2 Interleaved UYVY",
> +		.hw_fmt = VPFE_UYVY,
> +	},
> +	{
> +		.pix_fmt = V4L2_PIX_FMT_YUYV,
> +		.desc = "YCbCr 4:2:2 Interleaved YUYV",
> +		.hw_fmt = VPFE_YUYV,
> +	},
> +	{
> +		.pix_fmt = V4L2_PIX_FMT_NV12,
> +		.desc = "Y/CbCr 4:2:0 - Semi planar",
> +		.hw_fmt = VPFE_YUV420,
> +	},
> +};
> +
> +static int vpfe_lookup_hw_format(u32 pix_format)
> +{
> +	int i;
> +
> +	for (i = 0; i < VPFE_MAX_PIX_FORMATS; i++) {
> +		if (pix_format == vpfe_pix_fmts[i].pix_fmt)
> +			return i;

What about returning &vpfe_pix_fmts[i] instead ? This will save a lookup 
operation that you would need to perform in the caller function.

> +	}
> +	return -EINVAL;
> +}
> +
> +static int vpfe_lookup_v4l2_pix_format(enum vpfe_hw_pix_format hw_pix)
> +{
> +	int i;
> +
> +	for (i = 0; i < VPFE_MAX_PIX_FORMATS; i++) {
> +		if (hw_pix == vpfe_pix_fmts[i].hw_fmt)
> +			return i;

Ditto.

> +	}
> +	return -EINVAL;
> +}
> +
> +static int vpfe_get_stdinfo(struct vpfe_device *vpfe_dev, v4l2_std_id
> *std_id) +{
> +	int i;
> +
> +	for (i = 0; i < vpfe_max_standards; i++) {
> +		if (vpfe_standards[i].std_id == *std_id) {
> +			vpfe_dev->std_info.activepixels =
> +					vpfe_standards[i].width;
> +			vpfe_dev->std_info.activelines =
> +					vpfe_standards[i].height;
> +			vpfe_dev->std_info.frame_format =
> +					vpfe_standards[i].frame_format;
> +			vpfe_dev->index = i;

vpfe_dev->index isn't really descriptive, you should call it std_index.

> +			return 0;
> +		}
> +	}
> +	v4l2_err(&vpfe_dev->v4l2_dev, "standard not supported\n");
> +	return -EINVAL;
> +}
> +
> +/*
> + * vpfe_register_ccdc_device. CCDC module calls this to
> + * register with vpfe capture
> + */
> +int vpfe_register_ccdc_device(struct ccdc_hw_device *dev)
> +{
> +	if (NULL == dev) {
> +		printk(KERN_ERR "invalid ccdc device ptr \n");
> +		return -1;
> +	}

This shouldn't happen unless there's a bug in the CCDC module, right ? In that 
case you can remove the check. The kernel will oops a few lines later, making 
it quite obvious to the developer where the problem lies.

> +	printk(KERN_NOTICE "vpfe_register_ccdc_device: %s\n", dev->name);
> +
> +	mutex_lock(&ccdc_lock);
> +	if (NULL == ccdc_cfg) {
> +		printk(KERN_ERR "vpfe capture not initialized\n");
> +		mutex_unlock(&ccdc_lock);
> +		return -1;
> +	}

This is a problem we need to fix if it can actually happen. The vpfe_capture 
module will always be loaded before any CCDC module, as the 
vpfe_register_ccdc_device symbol is required by CCDC modules. The probe 
function might not be called in time though, resulting in a failure to load 
the CCDC module.

The proper fix would be to add the CCDC device to a linked list, and walk that 
list whenever the VPFE is initialized. Can you add a TODO for this ?

> +	if (strcmp(dev->name, ccdc_cfg->name)) {
> +		/* ignore this ccdc */
> +		mutex_unlock(&ccdc_lock);
> +		return -1;
> +	}
> +
> +	if (ccdc_dev) {
> +		printk(KERN_ERR "ccdc already registered\n");
> +		mutex_unlock(&ccdc_lock);
> +		return -1;
> +	}
> +
> +	BUG_ON(!dev->open);
> +	BUG_ON(!dev->hw_ops.enable);
> +	BUG_ON(!dev->hw_ops.set_hw_if_params);
> +	BUG_ON(!dev->hw_ops.configure);
> +	BUG_ON(!dev->hw_ops.set_buftype);
> +	BUG_ON(!dev->hw_ops.get_buftype);
> +	BUG_ON(!dev->hw_ops.enum_pix);
> +	BUG_ON(!dev->hw_ops.set_frame_format);
> +	BUG_ON(!dev->hw_ops.get_frame_format);
> +	BUG_ON(!dev->hw_ops.get_pixelformat);
> +	BUG_ON(!dev->hw_ops.set_pixelformat);
> +	BUG_ON(!dev->hw_ops.setparams);
> +	BUG_ON(!dev->hw_ops.set_image_window);
> +	BUG_ON(!dev->hw_ops.get_image_window);
> +	BUG_ON(!dev->hw_ops.get_line_length);
> +	BUG_ON(!dev->hw_ops.setfbaddr);
> +	BUG_ON(!dev->hw_ops.getfid);

The BUG_ON's can be moved up outside of the mutex protected section.

> +	ccdc_dev = dev;
> +	dev->hw_ops.set_ccdc_base(ccdc_cfg->ccdc_addr,
> +				  ccdc_cfg->ccdc_addr_size);
> +	dev->hw_ops.set_vpss_base(ccdc_cfg->vpss_addr,
> +				  ccdc_cfg->vpss_addr_size);
> +	mutex_unlock(&ccdc_lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL(vpfe_register_ccdc_device);
> +
> +/*
> + * vpfe_unregister_ccdc_device. CCDC module calls this to
> + * unregister with vpfe capture
> + */
> +void vpfe_unregister_ccdc_device(struct ccdc_hw_device *dev)
> +{
> +	if (NULL == dev) {
> +		printk(KERN_ERR "invalid ccdc device ptr\n");
> +		return;
> +	}
> +
> +	printk(KERN_NOTICE "vpfe_unregister_ccdc_device, dev->name = %s\n",
> +		dev->name);
> +
> +	if (strcmp(dev->name, ccdc_cfg->name)) {
> +		/* ignore this ccdc */
> +		return;
> +	}
> +
> +	mutex_lock(&ccdc_lock);
> +	ccdc_dev = NULL;
> +	mutex_unlock(&ccdc_lock);
> +	return;
> +}
> +EXPORT_SYMBOL(vpfe_unregister_ccdc_device);
> +
> +/* Set interface params based on client interface */
> +static int vpfe_set_hw_if_params(struct vpfe_device *vpfe_dev)
> +{
> +	struct vpfe_subdev_info *subdev =
> +		&vpfe_dev->cfg->sub_devs[vpfe_dev->current_subdev];

What about storing a pointer to the current subdevice instead of the index ?

> +	struct v4l2_routing *route =
> +		&(subdev->routes[vpfe_dev->current_input]);

I think there's something wrong with how the current input is handled. 
current_input as assigned the input index number in vpfe_s_input, which is a 
global index across all subdevices. However, you use it as a subdevice local 
input index here.

> +	switch (route->output) {
> +	case OUTPUT_10BIT_422_EMBEDDED_SYNC:
> +		vpfe_dev->vpfe_if_params.if_type = VPFE_BT656;
> +		break;
> +	case OUTPUT_20BIT_422_SEPERATE_SYNC:
> +		vpfe_dev->vpfe_if_params.if_type = VPFE_YCBCR_SYNC_16;
> +		break;
> +	case OUTPUT_10BIT_422_SEPERATE_SYNC:
> +		vpfe_dev->vpfe_if_params.if_type = VPFE_YCBCR_SYNC_8;

A break is missing.

> +	default:
> +		v4l2_err(&vpfe_dev->v4l2_dev, "decoder output"
> +			" not supported, %d\n", route->output);
> +		return -EFAULT;

Wouldn't -EINVAL be better ?

> +	}
> +
> +	/* set if client specific interface param is available */
> +	if (subdev->pdata) {
> +		/* each client will have different interface requirements */
> +		if (!strcmp(subdev->name, "tvp5146")) {
> +			struct tvp514x_platform_data *pdata = subdev->pdata;
> +
> +			if (pdata->hs_polarity)
> +				vpfe_dev->vpfe_if_params.hdpol =
> +					VPFE_PINPOL_POSITIVE;
> +			else
> +				vpfe_dev->vpfe_if_params.hdpol =
> +					VPFE_PINPOL_NEGATIVE;
> +
> +			if (pdata->vs_polarity)
> +				vpfe_dev->vpfe_if_params.vdpol =
> +					VPFE_PINPOL_POSITIVE;
> +			else
> +				vpfe_dev->vpfe_if_params.hdpol =
> +					VPFE_PINPOL_NEGATIVE;
> +		} else {
> +			v4l2_err(&vpfe_dev->v4l2_dev, "No interface params"
> +				" defined for subdevice, %d\n", route->output);
> +			return -EFAULT;
> +		}

I'd really like to get rid of this. Instead of checking for a specific 
subdevice, we need a way to pass subdevice-agnostic data to the VPFE driver. 
Hans, what's your opinion on this ?

> +	}
> +	return ccdc_dev->hw_ops.set_hw_if_params(&vpfe_dev->vpfe_if_params);
> +}
> +
> +static int vpfe_get_image_format(struct vpfe_device *vpfe_dev,
> +				 struct v4l2_format *f)
> +{
> +	enum vpfe_hw_pix_format hw_pix;
> +	struct v4l2_rect image_win;
> +	enum ccdc_buftype buf_type;
> +	enum ccdc_frmfmt frm_fmt;
> +	int index;
> +
> +	memset(f, 0, sizeof(*f));
> +	f->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	ccdc_dev->hw_ops.get_image_window(&image_win);
> +	f->fmt.pix.width = image_win.width;
> +	f->fmt.pix.height = image_win.height;
> +	f->fmt.pix.bytesperline = ccdc_dev->hw_ops.get_line_length();
> +	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
> +				f->fmt.pix.height;
> +	buf_type = ccdc_dev->hw_ops.get_buftype();

Move this line right before or after frm_fmt, closer to where buf_type is 
used.

> +
> +	hw_pix = ccdc_dev->hw_ops.get_pixelformat();
> +	index = vpfe_lookup_v4l2_pix_format(hw_pix);
> +	if (index < 0) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid HW pix format detected");
> +		return -EINVAL;
> +	}
> +
> +	f->fmt.pix.pixelformat = vpfe_pix_fmts[index].pix_fmt;
> +	frm_fmt = ccdc_dev->hw_ops.get_frame_format();
> +	if (frm_fmt == CCDC_FRMFMT_PROGRESSIVE)
> +		f->fmt.pix.field = V4L2_FIELD_NONE;
> +	else if (frm_fmt == CCDC_FRMFMT_INTERLACED) {
> +		if (buf_type == CCDC_BUFTYPE_FLD_INTERLEAVED)
> +			f->fmt.pix.field = V4L2_FIELD_INTERLACED;
> +		else if (buf_type == CCDC_BUFTYPE_FLD_SEPARATED)
> +			f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
> +		else {
> +			v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf_type");
> +			return -EINVAL;
> +		}
> +	} else {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid frm_fmt");
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +/* vpfe_config_default_format: Update format information */
> +static int vpfe_config_default_format(struct vpfe_device *vpfe_dev)
> +{
> +	struct vpfe_config *cfg = vpfe_dev->cfg;
> +	struct vpfe_subdev_info *sub_dev =
> +		&cfg->sub_devs[vpfe_dev->current_subdev];
> +	struct v4l2_rect win;
> +	int ret = 0;
> +
> +	vpfe_dev->crop.top = 0;
> +	vpfe_dev->crop.left = 0;
> +	/*
> +	 * first get format information from the decoder.
> +	 * if not available, get it from CCDC
> +	 */
> +	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
> +			sub_dev->grp_id,
> +			video, g_fmt, &vpfe_dev->fmt);
> +
> +	if (ret) {
> +		ret = vpfe_get_image_format(vpfe_dev, &vpfe_dev->fmt);
> +		if (ret < 0)
> +			return ret;
> +	} else {

Don't you have to setup the CCDC parameters regardless of whether 
v4l2_device_call_until_err() is successful or not ?

> +		/* set up all parameters in CCDC */
> +		win.top = vpfe_dev->crop.top;
> +		win.left = vpfe_dev->crop.left;
> +		win.width = vpfe_dev->fmt.fmt.pix.width;
> +		win.height = vpfe_dev->fmt.fmt.pix.height;
> +		ccdc_dev->hw_ops.set_image_window(&win);
> +		if (vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_INTERLACED) {
> +			ret = ccdc_dev->hw_ops.set_buftype(
> +					CCDC_BUFTYPE_FLD_INTERLEAVED);
> +			if (ret)
> +				return ret;
> +			ret = ccdc_dev->hw_ops.set_frame_format(
> +					CCDC_FRMFMT_INTERLACED);
> +			if (ret)
> +				return ret;
> +		} else if (vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_SEQ_TB) {
> +			ret = ccdc_dev->hw_ops.set_buftype(
> +					CCDC_BUFTYPE_FLD_SEPARATED);
> +			if (ret)
> +				return ret;
> +			ret = ccdc_dev->hw_ops.set_frame_format(
> +					CCDC_FRMFMT_INTERLACED);
> +			if (ret)
> +				return ret;
> +		} else if (vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_NONE) {
> +			ret = ccdc_dev->hw_ops.set_frame_format(
> +					CCDC_FRMFMT_PROGRESSIVE);
> +			if (ret)
> +				return ret;
> +		} else {
> +			v4l2_err(&vpfe_dev->v4l2_dev, "Decoder field not"
> +				 " supported!\n");
> +			return -EINVAL;
> +		}

You could simplify this by storing the buffer type and frame format into 
variables and moving the calls to set_buftype() and set_frame_format() outside 
of the if...else blocks. I suspect that set_buftype() needs to be called in 
the V4L2_FIELD_NONE as well, to make sure it's not set to 
CCDC_BUFTYPE_FLD_INTERLEAVED in which case the DM355 and DM6446 CCDC drivers 
would setup the hardware differently.

> +	}
> +	/* set the crop limits */
> +	vpfe_dev->std_info.activepixels = vpfe_dev->fmt.fmt.pix.width;
> +	vpfe_dev->std_info.activelines = vpfe_dev->fmt.fmt.pix.height;
> +	return 0;
> +}
> +
> +static int vpfe_initialize_device(struct vpfe_device *vpfe_dev)
> +{
> +	int ret = 0;
> +
> +	vpfe_dev->out_from = VPFE_CCDC_OUT;

out_from is never changed. I believe it will be used later when 
previewer/resizer support will be implemented. Can't we just remove it now ?

> +	vpfe_dev->current_input = 0;
> +
> +	/* Configure the default format information */
> +	ret = vpfe_config_default_format(vpfe_dev);
> +

You can remove that newline.

> +	if (ret)
> +		return ret;
> +
> +	/* now open the ccdc device to initialize it */
> +	mutex_lock(&ccdc_lock);
> +	if (NULL == ccdc_dev) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "ccdc device not registered\n");
> +		mutex_unlock(&ccdc_lock);
> +		return -ENODEV;
> +	}
> +
> +	if (!try_module_get(ccdc_dev->owner)) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Couldn't lock ccdc module\n");
> +		mutex_unlock(&ccdc_lock);
> +		return -ENODEV;
> +	}
> +	mutex_unlock(&ccdc_lock);
> +	ccdc_dev->open(vpfe_dev->pdev);

Shouldn't you check the return value ?

> +	vpfe_dev->initialized = 1;
> +	return ret;
> +}
> +
> +/*
> + * vpfe_open : It creates object of file handle structure and
> + * stores it in private_data  member of filepointer
> + */
> +static int vpfe_open(struct file *file)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_fh *fh;
> +
> +	if (NULL == vpfe_dev)
> +		return -ENODEV;

Can this happen ?

> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_open\n");
> +
> +	if (!vpfe_dev->cfg->num_subdevs) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "No decoder registered\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Allocate memory for the file handle object */
> +	fh = kmalloc(sizeof(struct vpfe_fh), GFP_KERNEL);
> +	if (NULL == fh) {
> +		v4l2_err(&vpfe_dev->v4l2_dev,
> +			"unable to allocate memory for file handle object\n");
> +		return -ENOMEM;
> +	}
> +	/* store pointer to fh in private_data member of file */
> +	file->private_data = fh;
> +	fh->initialized = 0;

fh->initialized is never read, you can get rid of it.

> +	fh->vpfe_dev = vpfe_dev;
> +	mutex_lock(&vpfe_dev->lock);
> +	/* If decoder is not initialized. initialize it */
> +	if (!vpfe_dev->initialized) {
> +		if (vpfe_initialize_device(vpfe_dev))
> +			return -ENODEV;
> +		fh->initialized = 1;
> +	}
> +	/* Increment device usrs counter */
> +	vpfe_dev->usrs++;
> +	/* Set io_allowed member to false */
> +	mutex_unlock(&vpfe_dev->lock);
> +
> +	fh->io_allowed = 0;
> +	/* Initialize priority of this instance to default priority */
> +	fh->prio = V4L2_PRIORITY_UNSET;
> +	v4l2_prio_open(&vpfe_dev->prio, &fh->prio);
> +	return 0;
> +}
> +
> +/* ISR for VINT0*/
> +static irqreturn_t vpfe_isr(int irq, void *dev_id)
> +{
> +	struct vpfe_device *vpfe_dev = dev_id;
> +	struct timeval timevalue;
> +	enum v4l2_field field;
> +	unsigned long addr;
> +	int fid;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "\nStarting vpfe_isr...");
> +	field = vpfe_dev->fmt.fmt.pix.field;
> +	do_gettimeofday(&timevalue);
> +
> +	/* if streaming not started, don't do anything */
> +	if (!vpfe_dev->started)
> +		return IRQ_RETVAL(1);
> +
> +	/* only for 6446 this will be applicable */
> +	if (NULL != ccdc_dev->hw_ops.reset)
> +		ccdc_dev->hw_ops.reset();
> +
> +	if (field == V4L2_FIELD_INTERLACED || field == V4L2_FIELD_SEQ_TB) {
> +		/* Interlaced */
> +		/* check which field we are in hardware */
> +		fid = ccdc_dev->hw_ops.getfid();
> +		/* switch the software maintained field id */
> +		vpfe_dev->field_id ^= 1;
> +		v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "field id = %x:%x.\n",
> +			fid, vpfe_dev->field_id);
> +		if (fid == vpfe_dev->field_id) {
> +			/* we are in-sync here,continue */
> +			if (fid == 0) {
> +				/*
> +				 * One frame is just being captured. If the
> +				 * next frame is available, release the current
> +				 * frame and move on
> +				 */
> +				if (vpfe_dev->cur_frm != vpfe_dev->next_frm) {
> +					/* Copy frame capture time value in
> +					 * cur_frm->ts
> +					 */
> +					vpfe_dev->cur_frm->ts = timevalue;
> +					vpfe_dev->cur_frm->state =
> +						VIDEOBUF_DONE;
> +					wake_up_interruptible(
> +						&vpfe_dev->cur_frm->done);
> +					vpfe_dev->cur_frm = vpfe_dev->next_frm;
> +				}

The code blocks nesting level is getting quite high here. The interrupt 
handler would be easier to read if you split it in several functions (the 
above lines are good candidates as they are reused later in the interrupt 
handler).

By handling error/unusual/small cases first and returning immediately the code 
will also move towards the left side. For instance, instead of

if (condition) {
	lots;
	of;
	code;
	goes;
	here;
} else {
	one liner;
}
return IRQ_RETVAL(1);

you could write

if (!condition) {
	one liner;
	return IRQ_RETVAL(1);
}
lots;
of;
code;
goes;
here;
return IRQ_RETVAL(1);

This isn't a mandatory change in any way, just a small hint to help keeping 
the code easy to read. Don't feel pushed to change this specific function if 
you don't want to. You might just want to split the interlaced and non-
interlaced case into separate functions (the compiler will inline them 
anyway).

I've tested all this (splitting interlaced/non-interlaced into separate 
functions, extracting common code in a separate function and handling small 
cases first) for vpfe_isr(). Beside the code readability improvements each 
change had either no impact on the generated assembly code, or it resulted in 
a small code size improvement (I haven't checked how running time would be 
affected).

> +				/*
> +				 * based on whether the two fields are stored
> +				 * interleavely or separately in memory,
> +				 * reconfigure the CCDC memory address
> +				 */
> +				if (vpfe_dev->out_from == VPFE_CCDC_OUT &&
> +				    field == V4L2_FIELD_SEQ_TB) {
> +					addr =
> +					videobuf_to_dma_contig(
> +							vpfe_dev->cur_frm);
> +					addr += vpfe_dev->field_off;
> +					ccdc_dev->hw_ops.setfbaddr(addr);
> +				}
> +			} else {
> +				/*
> +				 * if one field is just being captured
> +				 * configure the next frame
> +				 * get the next frame from the empty queue
> +				 * if no frame is available
> +				 * hold on to the current buffer
> +				 */
> +				spin_lock(&vpfe_dev->dma_queue_lock);
> +				if (vpfe_dev->out_from == VPFE_CCDC_OUT &&
> +					!list_empty(&vpfe_dev->dma_queue) &&
> +					vpfe_dev->cur_frm ==
> +						vpfe_dev->next_frm) {
> +					vpfe_dev->next_frm =
> +					  list_entry(vpfe_dev->dma_queue.next,
> +						struct videobuf_buffer, queue);
> +					list_del(&vpfe_dev->next_frm->queue);
> +					vpfe_dev->next_frm->state =
> +						VIDEOBUF_ACTIVE;
> +					addr = videobuf_to_dma_contig(
> +							vpfe_dev->next_frm);
> +					ccdc_dev->hw_ops.setfbaddr(addr);
> +				}
> +				spin_unlock(&vpfe_dev->dma_queue_lock);
> +			}
> +		} else if (fid == 0) {
> +			/*
> +			 * recover from any hardware out-of-sync due to
> +			 * possible switch of video source
> +			 * for fid == 0, sync up the two fids
> +			 * for fid == 1, no action, one bad frame will
> +			 * go out, but it is not a big deal
> +			 */
> +			vpfe_dev->field_id = fid;
> +		}
> +	} else if (field == V4L2_FIELD_NONE) {
> +
> +		v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
> +			"frame format is progressive...\n");
> +		if (vpfe_dev->cur_frm != vpfe_dev->next_frm) {
> +			/* Copy frame capture time value in cur_frm->ts */
> +			vpfe_dev->cur_frm->ts = timevalue;
> +			vpfe_dev->cur_frm->state = VIDEOBUF_DONE;
> +			wake_up_interruptible(&vpfe_dev->cur_frm->done);
> +			vpfe_dev->cur_frm = vpfe_dev->next_frm;
> +		}
> +
> +	}
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "interrupt returned.\n");
> +	return IRQ_RETVAL(1);
> +}
> +
> +static irqreturn_t vdint1_isr(int irq, void *dev_id)
> +{
> +	struct vpfe_device *vpfe_dev = dev_id;
> +	unsigned long addr;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "\nInside vdint1_isr...");
> +
> +	/* if streaming not started, don't do anything */
> +	if (!vpfe_dev->started)
> +		return IRQ_RETVAL(1);
> +
> +	spin_lock(&vpfe_dev->dma_queue_lock);
> +	if ((vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_NONE) &&
> +	    !list_empty(&vpfe_dev->dma_queue) &&
> +	    vpfe_dev->cur_frm == vpfe_dev->next_frm) {
> +		vpfe_dev->next_frm =
> +		    list_entry(vpfe_dev->dma_queue.next,
> +			       struct videobuf_buffer, queue);
> +		list_del(&vpfe_dev->next_frm->queue);
> +		vpfe_dev->next_frm->state = VIDEOBUF_ACTIVE;
> +		addr = videobuf_to_dma_contig(vpfe_dev->next_frm);
> +		ccdc_dev->hw_ops.setfbaddr(addr);

This code block could be extracted into a separate function as well, shared 
with vpfe_isr().

> +	}
> +	spin_unlock(&vpfe_dev->dma_queue_lock);
> +	return IRQ_RETVAL(1);
> +}
> +
> +static void vpfe_detach_irq(struct vpfe_device *vpfe_dev)
> +{
> +	enum ccdc_frmfmt frame_format;
> +
> +	/* First clear irq if already in use */

There's a "first", but I can't see any "second" :-)

> +	if (vpfe_dev->irq_type == VPFE_USE_CCDC_IRQ) {
> +		frame_format = ccdc_dev->hw_ops.get_frame_format();
> +		if (frame_format == CCDC_FRMFMT_PROGRESSIVE)
> +			free_irq(IRQ_VDINT1, vpfe_dev);
> +		vpfe_dev->irq_type = VPFE_NO_IRQ;

You never assign vpfe_dev->irq_type to anything else than VPFE_NO_IRQ.

> +	}
> +}
> +
> +static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
> +{
> +	enum ccdc_frmfmt frame_format;
> +
> +	frame_format = ccdc_dev->hw_ops.get_frame_format();
> +	if (frame_format == CCDC_FRMFMT_PROGRESSIVE) {
> +		return request_irq(vpfe_dev->ccdc_irq1, vdint1_isr,
> +				    IRQF_DISABLED, "vpfe_capture1",
> +				    vpfe_dev);
> +	}
> +	return 0;
> +}
> +
> +/* vpfe_release : This function deletes buffer queue, frees the
> + * buffers and the vpfe file  handle
> + */
> +static int vpfe_release(struct file *file)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_fh *fh = file->private_data;
> +	struct vpfe_config *cfg = vpfe_dev->cfg;
> +	struct vpfe_subdev_info *subdev;
> +	int ret;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_release\n");
> +
> +	/* Get the device lock */
> +	mutex_lock(&vpfe_dev->lock);
> +	/* if this instance is doing IO */
> +	if (fh->io_allowed) {
> +		/* Reset io_usrs member of device object */
> +		if (vpfe_dev->started) {
> +			subdev = &cfg->sub_devs[vpfe_dev->current_subdev];
> +			ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
> +							 subdev->grp_id,
> +							 video, s_stream, 0);
> +			if (ret && (ret != -ENOIOCTLCMD))
> +				v4l2_err(&vpfe_dev->v4l2_dev,
> +				"stream off failed in subdev\n");
> +			ccdc_dev->hw_ops.enable(0);
> +			if (ccdc_dev->hw_ops.enable_out_to_sdram)
> +				ccdc_dev->hw_ops.enable_out_to_sdram(0);
> +			vpfe_detach_irq(vpfe_dev);
> +			videobuf_streamoff(&vpfe_dev->buffer_queue);

There's a very similar code block in vpfe_streamoff(), you can extract them 
into a separate function.

> +		}
> +		vpfe_dev->io_usrs = 0;
> +		vpfe_dev->started = 0;
> +		/* Free buffers allocated */

I don't see any buffer being freed here.

> +		vpfe_dev->numbuffers = config_params.numbuffers;
> +	}
> +
> +	/* Decrement device usrs counter */
> +	vpfe_dev->usrs--;
> +	/* Close the priority */
> +	v4l2_prio_close(&vpfe_dev->prio, &fh->prio);
> +	/* If this is the last file handle */
> +	if (!vpfe_dev->usrs) {
> +		vpfe_dev->initialized = 0;
> +		if (ccdc_dev->close)
> +			ccdc_dev->close(vpfe_dev->pdev);
> +		module_put(ccdc_dev->owner);
> +	}
> +	mutex_unlock(&vpfe_dev->lock);
> +	file->private_data = NULL;
> +	/* Free memory allocated to file handle object */
> +	kfree(fh);
> +	return 0;
> +}
> +
> +/*
> + * vpfe_mmap : It is used to map kernel space buffers
> + * into user spaces
> + */
> +static int vpfe_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	/* Get the device object and file handle object */
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_mmap\n");
> +
> +	return videobuf_mmap_mapper(&vpfe_dev->buffer_queue, vma);
> +}
> +
> +/*
> + * vpfe_poll: It is used for select/poll system call
> + */
> +static unsigned int vpfe_poll(struct file *file, poll_table *wait)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_poll\n");
> +
> +	if (vpfe_dev->started)
> +		return videobuf_poll_stream(file,
> +					    &vpfe_dev->buffer_queue, wait);
> +	return 0;
> +}
> +
> +/* vpfe capture driver file operations */
> +static struct v4l2_file_operations vpfe_fops = {
> +	.owner = THIS_MODULE,
> +	.open = vpfe_open,
> +	.release = vpfe_release,
> +	.ioctl = video_ioctl2,
> +	.mmap = vpfe_mmap,
> +	.poll = vpfe_poll
> +};
> +
> +static  struct vpfe_pixel_format *
> +	vpfe_check_format(struct vpfe_device *vpfe_dev,
> +			  struct v4l2_pix_format *pixfmt,
> +			  int check)
> +{
> +	int temp, found, hpitch, vpitch, bpp, min_height = 1,
> +		min_width = 32, max_width, max_height;
> +	struct vpfe_pixel_format *pix_fmt;
> +	enum vpfe_hw_pix_format hw_pix;
> +	
> +	temp = vpfe_lookup_hw_format(pixfmt->pixelformat);
> +	if (temp < 0) {
> +		if (check) {
> +			v4l2_err(&vpfe_dev->v4l2_dev, "invalid pixel format\n");
> +			return NULL;
> +		}

According to the V4L2 specification, the driver isn't supposed to return an 
error in response to TRY_FMT/S_FMT unless the input is ambiguous or the buffer 
type is unsupported. It should instead adjust the requested parameters 
according to its supported capabilities.

It seems to me that most V4L2 drivers don't obey this rule though. It might 
break userspace applications if we "fixed" those drivers. I'd like Hans' 
opinion on this.

> +		/* if invalid and this is a try format, then use hw default */
> +		pixfmt->pixelformat = vpfe_dev->fmt.fmt.pix.pixelformat;

Is this the hardware default format, or current format ?

> +		/* Since this is hw default, we will find this pix format */
> +		temp = vpfe_lookup_hw_format(pixfmt->pixelformat);
> +
> +	} else {
> +		/* check if hw supports it */
> +		pix_fmt = &vpfe_pix_fmts[temp];
> +		temp = 0;
> +		found = 0;
> +		while (ccdc_dev->hw_ops.enum_pix(&hw_pix, temp) >= 0) {
> +			if (pix_fmt->hw_fmt == hw_pix) {
> +				found = 1;
> +				break;
> +			}
> +			temp++;

Wouldn't it be better to have a try_frame_format CCDC operation for this ?

> +		}
> +		if (!found) {
> +			if (check) {
> +				v4l2_err(&vpfe_dev->v4l2_dev, "hw doesn't"
> +					 "support the pixel format\n");
> +				return NULL;
> +			}
> +			/*
> +			 * Since this is hw default, we will find this
> +			 * pix format
> +			 */
> +			pixfmt->pixelformat = vpfe_dev->fmt.fmt.pix.pixelformat;
> +			temp = vpfe_lookup_hw_format(pixfmt->pixelformat);
> +		}
> +	}
> +	pix_fmt = &vpfe_pix_fmts[temp];
> +	if (pixfmt->field == V4L2_FIELD_ANY) {
> +		/* if ANY set the field to match with decoder */
> +		pixfmt->field = vpfe_dev->fmt.fmt.pix.field;
> +	}
> +
> +	/* Try matching the field with the decoder scan field */
> +	if (vpfe_dev->fmt.fmt.pix.field != pixfmt->field) {
> +		if (!(VPFE_VALID_FIELD(pixfmt->field)) && check) {
> +			v4l2_err(&vpfe_dev->v4l2_dev, "invalid field format\n");
> +			return NULL;
> +		}
> +		if (vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_INTERLACED) {
> +			if (pixfmt->field != V4L2_FIELD_SEQ_TB) {
> +				if (check) {
> +					v4l2_err(&vpfe_dev->v4l2_dev,
> +						"invalid field format\n");
> +					return NULL;
> +				}
> +				pixfmt->field = vpfe_dev->fmt.fmt.pix.field;
> +			}
> +		} else if (vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_NONE) {
> +			if (check) {
> +				v4l2_err(&vpfe_dev->v4l2_dev,
> +					"invalid field format\n");
> +				return NULL;
> +			}
> +			pixfmt->field = vpfe_dev->fmt.fmt.pix.field;
> +		} else
> +			pixfmt->field = vpfe_dev->fmt.fmt.pix.field;
> +	}

This looks a bit complex. Could you explain the algorithm behind the code ?

> +
> +	if (pixfmt->field == V4L2_FIELD_INTERLACED)
> +		min_height = 2;
> +
> +	max_width = vpfe_dev->std_info.activepixels;
> +	max_height = vpfe_dev->std_info.activelines;
> +
> +	if ((pixfmt->pixelformat == V4L2_PIX_FMT_SBGGR8) ||
> +	   (pixfmt->pixelformat == V4L2_PIX_FMT_NV12) ||
> +	   (pixfmt->pixelformat == V4L2_PIX_FMT_SGRBG10DPCM8))
> +		bpp = 1;
> +	else
> +		bpp = 2;

You should store the bpp values in the vpfe_pix_fmts array.

> +	min_width /= bpp;
> +	hpitch = pixfmt->width;
> +	vpitch = pixfmt->height;
> +	v4l2_info(&vpfe_dev->v4l2_dev, "hpitch = %d, vpitch = %d, bpp = %d\n",
> +		  hpitch, vpitch, bpp);
> +	if (hpitch < min_width)
> +		hpitch = min_width;
> +	if (vpitch < min_width)
> +		vpitch = min_height;
> +
> +	/* Check for upper limits of pitch */
> +	if (hpitch > max_width)
> +		hpitch = max_width;
> +	if (vpitch > max_height)
> +		vpitch = max_height;

You can use the clamp macro defined in include/linux/kernel.h.

> +
> +	/*
> +	 * recalculate bytesperline and sizeimage since width
> +	 * and height might have changed
> +	 */
> +	pixfmt->bytesperline = (((hpitch * bpp) + 31) & ~31);
> +	if (pixfmt->pixelformat == V4L2_PIX_FMT_NV12)
> +		pixfmt->sizeimage = pixfmt->bytesperline * vpitch +
> +				    ((pixfmt->bytesperline * vpitch) >> 1);
> +	else
> +		pixfmt->sizeimage = pixfmt->bytesperline * vpitch;

Could this information be stored in the vpfe_pix_fmts array as well ?

> +	pixfmt->width = hpitch;
> +	pixfmt->height = vpitch;

Is there a reason not to perform the computation directly on pixfmt->width and 
pixfmt->height ?

> +	v4l2_info(&vpfe_dev->v4l2_dev, "adjusted hpitch = %d, vpitch ="
> +		  " %d, bpp = %d\n", hpitch, vpitch, bpp);
> +	return pix_fmt;

Shouldn't you return pixfmt ? Calling two distinct variables pix_fmt and 
pixfmt is a bit misleading in my opinion. You should rename (at least one of) 
them, maybe pixfmt to v4l2_fmt and pix_fmt to vpfe_fmt.

> +}
> +
> +static int vpfe_querycap(struct file *file, void  *priv,
> +			       struct v4l2_capability *cap)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querycap\n");
> +
> +	memset(cap, 0, sizeof(*cap));
> +	if (vpfe_dev->cfg->card_name)
> +		strcpy(vpfe_videocap.card, vpfe_dev->cfg->card_name);
> +	*cap = vpfe_videocap;

See comments at the top regarding vpfe_videocap.

> +	return 0;
> +}
> +
> +static int vpfe_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *fmt)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_fmt_vid_cap\n");
> +	/*
> +	 * Fill in the information about
> +	 * format
> +	 */
> +	ret = mutex_lock_interruptible(&vpfe_dev->lock);

Do we really need to make it interruptible (here and in most other places) ?

> +	if (ret)
> +		goto unlock_out;
> +	*fmt = vpfe_dev->fmt;
> +unlock_out:
> +	mutex_unlock(&vpfe_dev->lock);
> +	return ret;
> +}
> +
> +static int vpfe_enum_fmt_vid_cap(struct file *file, void  *priv,
> +				   struct v4l2_fmtdesc *fmt)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	enum vpfe_hw_pix_format hw_pix;
> +	int index;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_enum_fmt_vid_cap\n");
> +
> +	/* Fill in the information about format */
> +	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	if (ccdc_dev->hw_ops.enum_pix(&hw_pix, fmt->index) < 0)
> +		return -EINVAL;
> +
> +	index = vpfe_lookup_v4l2_pix_format(hw_pix);
> +	if (index >= 0) {
> +		strcpy(fmt->description, vpfe_pix_fmts[index].desc);
> +		fmt->pixelformat = vpfe_pix_fmts[index].pix_fmt;
> +		return 0;
> +	}
> +	return -EINVAL;
> +}
> +
> +static int vpfe_s_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *fmt)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_pixel_format *pix_fmts;
> +	struct v4l2_rect win;
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_fmt_vid_cap\n");
> +
> +	/* If streaming is started, return error */
> +	if (vpfe_dev->started) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Streaming is started\n");
> +		return -EBUSY;
> +	}
> +
> +	/* Check for valid frame format */
> +	pix_fmts = vpfe_check_format(vpfe_dev, &fmt->fmt.pix, 1);
> +
> +	if (NULL == pix_fmts)
> +		return -EINVAL;
> +
> +	/* store the pixel format in the device  object */
> +	ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +	if (ret)
> +		return ret;
> +
> +	/* First detach any IRQ if currently attached */
> +	vpfe_detach_irq(vpfe_dev);
> +	vpfe_dev->fmt = *fmt;
> +	/*
> +	 * we are using same variable for setting crop window
> +	 * at ccdc. For ccdc, this is same as image window
> +	 */
> +	ccdc_dev->hw_ops.get_image_window(&win);
> +	win.width = vpfe_dev->fmt.fmt.pix.width;
> +	win.height = vpfe_dev->fmt.fmt.pix.height;
> +	if (ccdc_dev->hw_ops.set_image_window(&win)) {
> +		ret = -EINVAL;
> +		goto unlock_out;
> +	}
> +
> +	if (ccdc_dev->hw_ops.set_pixelformat(pix_fmts->hw_fmt) < 0) {
> +		ret = -EINVAL;
> +		goto unlock_out;
> +	}
> +
> +	if (vpfe_dev->fmt.fmt.pix.field ==
> +	    V4L2_FIELD_INTERLACED) {

No need to split that across two lines.

> +		ccdc_dev->hw_ops.set_buftype(CCDC_BUFTYPE_FLD_INTERLEAVED);
> +		ccdc_dev->hw_ops.set_frame_format(CCDC_FRMFMT_INTERLACED);
> +	} else if (vpfe_dev->fmt.fmt.pix.field ==
> +		   V4L2_FIELD_SEQ_TB) {
> +		ccdc_dev->hw_ops.set_buftype(CCDC_BUFTYPE_FLD_SEPARATED);
> +		ccdc_dev->hw_ops.set_frame_format(CCDC_FRMFMT_INTERLACED);
> +	} else if (vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_NONE)
> +		ccdc_dev->hw_ops.set_frame_format(CCDC_FRMFMT_PROGRESSIVE);
> +	else {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "\n field error!");
> +		ret = -EINVAL;
> +	}

Identical code already exists in vpfe_config_default_format. You should 
extract it into a separate function.

> +unlock_out:
> +	mutex_unlock(&vpfe_dev->lock);
> +	return ret;
> +}
> +
> +static int vpfe_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_pixel_format *pix_fmts;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_try_fmt_vid_cap\n");
> +
> +	pix_fmts = vpfe_check_format(vpfe_dev, &f->fmt.pix, 0);
> +	if (NULL == pix_fmts)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static void vpfe_config_format(struct vpfe_device *vpfe_dev)
> +{
> +	vpfe_dev->crop.top = 0;
> +	vpfe_dev->crop.left = 0;
> +	vpfe_dev->crop.width = vpfe_dev->std_info.activepixels;
> +	vpfe_dev->fmt.fmt.pix.width = vpfe_dev->crop.width;
> +	vpfe_dev->crop.height = vpfe_dev->std_info.activelines;
> +	vpfe_dev->fmt.fmt.pix.height = vpfe_dev->std_info.activelines;
> +	ccdc_dev->hw_ops.set_image_window(&vpfe_dev->crop);
> +
> +	if (vpfe_dev->std_info.frame_format) {
> +		vpfe_dev->fmt.fmt.pix.field = V4L2_FIELD_INTERLACED;
> +		ccdc_dev->hw_ops.set_frame_format(CCDC_FRMFMT_INTERLACED);
> +		ccdc_dev->hw_ops.set_buftype(CCDC_BUFTYPE_FLD_INTERLEAVED);
> +	} else {
> +		vpfe_dev->fmt.fmt.pix.field = V4L2_FIELD_NONE;
> +		ccdc_dev->hw_ops.set_frame_format(CCDC_FRMFMT_PROGRESSIVE);
> +	}
> +
> +	vpfe_dev->fmt.fmt.pix.bytesperline = ccdc_dev->hw_ops.get_line_length();
> +	vpfe_dev->fmt.fmt.pix.sizeimage = vpfe_dev->fmt.fmt.pix.bytesperline *
> +				    vpfe_dev->fmt.fmt.pix.height;
> +}

Can you move this function down where it is used, and add a comment to 
describe what it does ? If I'm not mistaken it configures the format width and 
height (and related fields such as image size) to default values according to 
the select video standard. You might want to call it vpfe_config_standard 
then.

> +/*
> + * vpfe_get_subdev_input_index - Get subdev index and input index for a
> + * given app input index
> + */
> +static int vpfe_get_subdev_input_index(struct vpfe_device *vpfe_dev,
> +					int *subdev_index, int *subdev_input,
> +					int app_input)
> +{
> +	struct vpfe_config *cfg = vpfe_dev->cfg;
> +	struct vpfe_subdev_info *sub_dev;
> +	int i, j = 0;
> +
> +	for (i = 0; i < cfg->num_subdevs; i++) {
> +		sub_dev = &cfg->sub_devs[i];
> +		if (app_input <= (j + sub_dev->num_inputs)) {

If both app_input and subdev_input are zero-based, I believe this should be < 
instead of <=.

> +			*subdev_index = i;
> +			*subdev_input = app_input - j;
> +			return 0;
> +		}
> +		j += sub_dev->num_inputs;

By decrementing app_input instead you can get rid of j.

> +	}
> +	return -1;

Return -EINVAL instead.

> +}
> +
> +/*
> + * vpfe_get_app_input - Get app input index for a given subdev input index
> + */
> +static int vpfe_get_app_input_index(struct vpfe_device *vpfe_dev,
> +				    int subdev_index, int subdev_input,
> +				    int *app_input)
> +{
> +	struct vpfe_config *cfg = vpfe_dev->cfg;
> +	struct vpfe_subdev_info *sub_dev;
> +	int i, j = 0;
> +
> +	if (subdev_index > cfg->num_subdevs)
> +		return -1;
> +
> +	for (i = 0; i < cfg->num_subdevs; i++) {
> +		sub_dev = &cfg->sub_devs[i];
> +		if (i == subdev_index) {
> +			if (subdev_input >= sub_dev->num_inputs)
> +				return -1;
> +			*app_input = j + subdev_input;
> +			return 0;
> +		}
> +		j += sub_dev->num_inputs;
> +	}
> +	return -1;

Comments for the previous function apply here too.

> +}
> +
> +static int vpfe_enum_input(struct file *file, void *priv,
> +				 struct v4l2_input *inp)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_subdev_info *sub_dev;
> +	int subdev, index ;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_enum_input\n");
> +
> +	if (vpfe_get_subdev_input_index(vpfe_dev,
> +					&subdev,
> +					&index,
> +					inp->index) < 0) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "input information not found"
> +			 " for the subdev\n");
> +		return -EINVAL;
> +	}
> +	sub_dev = &vpfe_dev->cfg->sub_devs[subdev];
> +	memcpy(inp, &sub_dev->inputs[index],
> +		sizeof(struct v4l2_input));
> +	return 0;
> +}
> +
> +static int vpfe_g_input(struct file *file, void *priv, unsigned int
> *index) +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_input\n");
> +
> +	return vpfe_get_app_input_index(vpfe_dev, vpfe_dev->current_subdev,
> +					 vpfe_dev->current_input, index);
> +}
> +
> +
> +static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_subdev_info *sub_dev;
> +	int subdev_index, inp_index;
> +	struct v4l2_routing *route;
> +	u32 input = 0, output = 0;
> +	int ret = -EINVAL;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_input\n");
> +
> +	ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * If streaming is started return device busy
> +	 * error
> +	 */
> +	if (vpfe_dev->started) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Streaming is on\n");
> +		ret = -EBUSY;
> +		goto unlock_out;
> +	}
> +
> +	if (vpfe_get_subdev_input_index(vpfe_dev,
> +					&subdev_index,
> +					&inp_index,
> +					index) < 0) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "invalid input index\n");
> +		goto unlock_out;
> +	}
> +
> +	sub_dev = &vpfe_dev->cfg->sub_devs[subdev_index];
> +	route = &sub_dev->routes[inp_index];
> +	if (route && sub_dev->can_route) {
> +		input = route->input;
> +		output = route->output;
> +	}
> +
> +	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
> +					 sub_dev->grp_id,
> +					 video, s_routing, input,
> +					 output, 0);
> +
> +	if (ret) {
> +		v4l2_err(&vpfe_dev->v4l2_dev,
> +			"vpfe_doioctl:error in setting input in decoder \n");
> +		ret = -EINVAL;
> +		goto unlock_out;
> +	}
> +	vpfe_dev->current_subdev = subdev_index;
> +	vpfe_dev->current_input = index;
> +
> +	ret = vpfe_set_hw_if_params(vpfe_dev);
> +	if (ret)
> +		goto unlock_out;
> +
> +	ret = vpfe_config_default_format(vpfe_dev);
> +	if (ret)
> +		goto unlock_out;
> +
> +unlock_out:
> +	mutex_unlock(&vpfe_dev->lock);
> +	return ret;
> +}
> +
> +static int vpfe_querystd(struct file *file, void *priv, v4l2_std_id
> *std_id) +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_config *cfg = vpfe_dev->cfg;
> +	struct vpfe_subdev_info *subdev;
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querystd\n");
> +	subdev = &cfg->sub_devs[vpfe_dev->current_subdev];
> +
> +	ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +	if (ret)
> +		return ret;
> +	/* Call querystd function of decoder device */
> +	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
> +					 subdev->grp_id,
> +					 video, querystd, std_id);
> +	mutex_unlock(&vpfe_dev->lock);
> +	return ret;
> +}
> +
> +static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_config *cfg = vpfe_dev->cfg;
> +	struct vpfe_subdev_info *subdev;
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_std\n");
> +
> +	subdev = &cfg->sub_devs[vpfe_dev->current_subdev];
> +	/* Call decoder driver function to set the standard */
> +	ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +	if (ret)
> +		return ret;
> +
> +	/* If streaming is started, return device busy error */
> +	if (vpfe_dev->started) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "streaming is started\n");
> +		ret = -EBUSY;
> +		goto unlock_out;
> +	}
> +
> +	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, subdev->grp_id,
> +					 core, s_std, *std_id);
> +	if (ret < 0) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Failed to set standard\n");
> +		goto unlock_out;
> +	}
> +	ret = vpfe_get_stdinfo(vpfe_dev, std_id);
> +	/* update the format information for this standard */
> +	if (ret)
> +		vpfe_config_format(vpfe_dev);

vpfe_get_stdinfo() and vpfe_config_format() are both used to update the 
vpfe_device structure and configure the CCDC with information computed from 
the just selected video standard. Would it make sense to merge and refactor 
them ?

> +
> +unlock_out:
> +	mutex_unlock(&vpfe_dev->lock);
> +	return ret;
> +}
> +
> +static int vpfe_g_std(struct file *file, void *priv, v4l2_std_id *std_id)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_std\n");
> +
> +	*std_id = vpfe_standards[vpfe_dev->index].std_id;
> +	return 0;
> +}
> +/*
> + *  Videobuf operations
> + */
> +static int vpfe_videobuf_setup(struct videobuf_queue *vq,
> +				unsigned int *count,
> +				unsigned int *size)
> +{
> +	struct vpfe_fh *fh = vq->priv_data;
> +	struct vpfe_device *vpfe_dev = fh->vpfe_dev;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_setup\n");
> +	*size = config_params.device_bufsize;
> +
> +	if (*count < config_params.min_numbuffers)
> +		*count = config_params.min_numbuffers;
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
> +		"count=%d, size=%d\n", *count, *size);
> +	return 0;
> +}
> +
> +static int vpfe_videobuf_prepare(struct videobuf_queue *vq,
> +				struct videobuf_buffer *vb,
> +				enum v4l2_field field)
> +{
> +	struct vpfe_fh *fh = vq->priv_data;
> +	struct vpfe_device *vpfe_dev = fh->vpfe_dev;
> +	unsigned long addr;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_prepare\n");
> +
> +	if (V4L2_MEMORY_USERPTR == vpfe_dev->memory) {
> +		/* we don't support user ptr IO */
> +		v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_prepare:"
> +			 " USERPTR IO not supported>\n");
> +		return  -EINVAL;
> +	}

This should be checked in vpfe_reqbufs() instead.

> +
> +	/* If buffer is not initialized, initialize it */
> +	if (VIDEOBUF_NEEDS_INIT == vb->state) {
> +		vb->width = vpfe_dev->fmt.fmt.pix.width;
> +		vb->height = vpfe_dev->fmt.fmt.pix.height;
> +		vb->size = vpfe_dev->fmt.fmt.pix.sizeimage;
> +		vb->field = field;
> +	}
> +	addr = videobuf_to_dma_contig(vb);
> +	if (vq->streaming) {

Why does vq->streaming interfere with the check ?

> +		if (!IS_ALIGNED(addr, 32)) {
> +			v4l2_err(&vpfe_dev->v4l2_dev,
> +				"buffer_prepare:offset is"
> +				" not aligned to 32 bytes\n");
> +			return -EINVAL;

Can this happen ? If so, under what conditions ?

> +		}
> +	}
> +	vb->state = VIDEOBUF_PREPARED;
> +	return 0;
> +}
> +
> +static void vpfe_videobuf_queue(struct videobuf_queue *vq,
> +				struct videobuf_buffer *vb)
> +{
> +	/* Get the file handle object and device object */
> +	struct vpfe_fh *fh = vq->priv_data;
> +	struct vpfe_device *vpfe_dev = fh->vpfe_dev;
> +	unsigned long flags;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_queue\n");
> +
> +	/* disable local irq */
> +	local_irq_save(flags);
> +	/* add the buffer to the DMA queue */
> +	spin_lock(&vpfe_dev->dma_queue_lock);

Use spin_lock_irqsave() instead.

> +	list_add_tail(&vb->queue, &vpfe_dev->dma_queue);
> +	spin_unlock(&vpfe_dev->dma_queue_lock);
> +	local_irq_restore(flags);

Use spin_unlock_irqrestore() instead.

> +
> +	/* Change state of the buffer */
> +	vb->state = VIDEOBUF_QUEUED;
> +}
> +
> +static void vpfe_videobuf_release(struct videobuf_queue *vq,
> +				  struct videobuf_buffer *vb)
> +{
> +	struct vpfe_fh *fh = vq->priv_data;
> +	struct vpfe_device *vpfe_dev = fh->vpfe_dev;
> +	unsigned long flags;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_videobuf_release\n");
> +
> +	/*
> +	 * We need to flush the buffer from the dma queue since
> +	 * they are de-allocated
> +	 */
> +	local_irq_save(flags);
> +	spin_lock(&vpfe_dev->dma_queue_lock);
> +	INIT_LIST_HEAD(&vpfe_dev->dma_queue);
> +	spin_unlock(&vpfe_dev->dma_queue_lock);
> +	local_irq_restore(flags);

Same comments as for the previous function.

> +	videobuf_dma_contig_free(vq, vb);
> +	vb->state = VIDEOBUF_NEEDS_INIT;
> +}
> +
> +static struct videobuf_queue_ops vpfe_videobuf_qops = {
> +	.buf_setup      = vpfe_videobuf_setup,
> +	.buf_prepare    = vpfe_videobuf_prepare,
> +	.buf_queue      = vpfe_videobuf_queue,
> +	.buf_release    = vpfe_videobuf_release,
> +};
> +
> +/*
> + * vpfe_reqbufs. currently support REQBUF only once opening
> + * the device.
> + */
> +static int vpfe_reqbufs(struct file *file, void *priv,
> +			struct v4l2_requestbuffers *p)

p isn't a really descriptive name.

> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_fh *fh = file->private_data;
> +	enum v4l2_field field;
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_reqbufs\n");
> +
> +	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != p->type) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buffer type\n");
> +		return -EINVAL;
> +	}
> +
> +	if (vpfe_dev->io_usrs != 0) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Only one IO user allowed\n");
> +		return -EBUSY;
> +	}

This check should be moved inside the mutex protected section otherwise two 
users will be able to request buffers concurrently.

> +
> +	ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +	if (ret)
> +		return ret;
> +
> +	if (vpfe_dev->fmt.fmt.pix.field != V4L2_FIELD_ANY)
> +		field = vpfe_dev->fmt.fmt.pix.field;

Can vpfe_dev->fmt.fmt.pix.field be set to V4L2_FIELD_ANY when we arrive here ? 
I'm under the impression that it should have a defined value, but the code is 
hard to follow and I might be wrong.

> +	else if (vpfe_dev->vpfe_if_params.if_type == VPFE_RAW_BAYER)
> +		field = V4L2_FIELD_NONE;
> +	else
> +		field = V4L2_FIELD_INTERLACED;
> +
> +	vpfe_dev->memory = p->memory;
> +	videobuf_queue_dma_contig_init(&vpfe_dev->buffer_queue,
> +				&vpfe_videobuf_qops,
> +				NULL,
> +				&vpfe_dev->irqlock,
> +				p->type,
> +				field,
> +				sizeof(struct videobuf_buffer),
> +				fh);
> +
> +	fh->io_allowed = 1;
> +	vpfe_dev->io_usrs = 1;
> +	INIT_LIST_HEAD(&vpfe_dev->dma_queue);
> +	ret = videobuf_reqbufs(&vpfe_dev->buffer_queue, p);
> +	mutex_unlock(&vpfe_dev->lock);
> +	return ret;
> +}
> +
> +static int vpfe_querybuf(struct file *file, void *priv,
> +			 struct v4l2_buffer *p)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querybuf\n");
> +
> +	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != p->type) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
> +		return  -EINVAL;
> +	}
> +	if (vpfe_dev->memory != V4L2_MEMORY_MMAP) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid memory\n");
> +		return -EINVAL;
> +	}

This should be checked in vpfe_reqbufs() instead.

> +	/* Call videobuf_querybuf to get information */
> +	return videobuf_querybuf(&vpfe_dev->buffer_queue, p);
> +}
> +
> +static int vpfe_qbuf(struct file *file, void *priv,
> +		     struct v4l2_buffer *p)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_fh *fh = file->private_data;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_qbuf\n");
> +
> +	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != p->type) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * If this file handle is not allowed to do IO,
> +	 * return error
> +	 */
> +	if (!fh->io_allowed) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "fh->io_allowed\n");
> +		return -EACCES;
> +	}
> +	return videobuf_qbuf(&vpfe_dev->buffer_queue, p);
> +}

Missing newline.

> +static int vpfe_dqbuf(struct file *file, void *priv,
> +		      struct v4l2_buffer *p)

p still isn't descriptive :-)

> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_dqbuf\n");
> +
> +	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != p->type) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
> +		return -EINVAL;
> +	}
> +	if (file->f_flags & O_NONBLOCK)
> +		return videobuf_dqbuf(&vpfe_dev->buffer_queue, p, 1);
> +	else
> +		return videobuf_dqbuf(&vpfe_dev->buffer_queue, p, 0);

        return videobuf_dqbuf(&vpfe_dev->buffer_queue, p,
                              file->f_flags & O_NONBLOCK);
> +}
> +
> +/*
> + * vpfe_calculate_offsets : This function calculates buffers offset
> + * for top and bottom field
> + */
> +static void vpfe_calculate_offsets(struct vpfe_device *vpfe_dev)
> +{
> +	struct v4l2_rect image_win;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_calculate_offsets\n");
> +
> +	vpfe_dev->field_off = 0;

No need to initialise field_off to 0 as you overwrite it later.

> +	ccdc_dev->hw_ops.get_image_window(&image_win);
> +	vpfe_dev->field_off = (image_win.height - 2) * image_win.width;

Why image_win.height - 2 ?

> +}
> +
> +/*
> + * vpfe_streamon. Assume the DMA queue is not empty.
> + * application is expected to call QBUF before calling
> + * this ioctl. If not, driver returns error
> + */
> +static int vpfe_streamon(struct file *file, void *priv,
> +			 enum v4l2_buf_type i)

i doesn't sound like a descriptive name either.

> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_config *cfg = vpfe_dev->cfg;
> +	struct vpfe_fh *fh = file->private_data;
> +	struct vpfe_subdev_info *subdev;
> +	unsigned long addr;
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_streamon\n");
> +
> +	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != i) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
> +		return -EINVAL;
> +	}
> +
> +	/* If file handle is not allowed IO, return error */
> +	if (!fh->io_allowed) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "fh->io_allowed\n");
> +		return -EACCES;
> +	}
> +
> +	subdev = &cfg->sub_devs[vpfe_dev->current_subdev];
> +	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, subdev->grp_id,
> +					video, s_stream, 1);
> +
> +	if (ret && (ret != -ENOIOCTLCMD)) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "stream on failed in subdev\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Call videobuf_streamon to start streaming * in videobuf */
> +	ret = videobuf_streamon(&vpfe_dev->buffer_queue);
> +	if (ret)
> +		return ret;
> +
> +	ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +	if (ret)
> +		goto streamoff;
> +	/* If buffer queue is empty, return error */
> +	if (list_empty(&vpfe_dev->dma_queue)) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "buffer queue is empty\n");
> +		ret = -EIO;
> +		goto unlock_out;
> +	}

Why don't you check that before starting the stream ?

> +	/* Get the next frame from the buffer queue */
> +	vpfe_dev->next_frm = list_entry(vpfe_dev->dma_queue.next,
> +					struct videobuf_buffer, queue);
> +	vpfe_dev->cur_frm = vpfe_dev->next_frm;
> +	/* Remove buffer from the buffer queue */
> +	list_del(&vpfe_dev->cur_frm->queue);
> +	/* Mark state of the current frame to active */
> +	vpfe_dev->cur_frm->state = VIDEOBUF_ACTIVE;
> +	/* Initialize field_id and started member */
> +	vpfe_dev->field_id = 0;
> +	addr = videobuf_to_dma_contig(vpfe_dev->cur_frm);
> +
> +	/* Calculate field offset */
> +	vpfe_calculate_offsets(vpfe_dev);
> +
> +	if (vpfe_attach_irq(vpfe_dev) < 0) {
> +		v4l2_err(&vpfe_dev->v4l2_dev,
> +			 "Error in attaching interrupt handle\n");
> +		ret = -EFAULT;
> +		goto unlock_out;
> +	}
> +	ccdc_dev->hw_ops.configure();
> +	ccdc_dev->hw_ops.setfbaddr((unsigned long)(addr));
> +	ccdc_dev->hw_ops.enable(1);
> +	if (ccdc_dev->hw_ops.enable_out_to_sdram)
> +		ccdc_dev->hw_ops.enable_out_to_sdram(1);
> +	vpfe_dev->started = 1;
> +	mutex_unlock(&vpfe_dev->lock);
> +	return ret;
> +unlock_out:
> +	mutex_unlock(&vpfe_dev->lock);
> +streamoff:
> +	ret = videobuf_streamoff(&vpfe_dev->buffer_queue);
> +	return ret;
> +}
> +
> +static int vpfe_streamoff(struct file *file, void *priv,
> +			  enum v4l2_buf_type i)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_config *cfg = vpfe_dev->cfg;
> +	struct vpfe_fh *fh = file->private_data;
> +	struct vpfe_subdev_info *subdev;
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_streamoff\n");
> +
> +	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != i) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Invalid buf type\n");
> +		return -EINVAL;
> +	}
> +
> +	/* If io is allowed for this file handle, return error */
> +	if (!fh->io_allowed) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "fh->io_allowed\n");
> +		return -EACCES;
> +	}
> +
> +	/* If streaming is not started, return error */
> +	if (!vpfe_dev->started) {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "device started\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +	if (ret)
> +		return ret;
> +
> +	vpfe_dev->started = 0;
> +	ccdc_dev->hw_ops.enable(0);
> +	if (ccdc_dev->hw_ops.enable_out_to_sdram)
> +		ccdc_dev->hw_ops.enable_out_to_sdram(0);
> +
> +	vpfe_detach_irq(vpfe_dev);
> +
> +	subdev = &cfg->sub_devs[vpfe_dev->current_subdev];
> +	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, subdev->grp_id,
> +					video, s_stream, 0);
> +
> +	if (ret && (ret != -ENOIOCTLCMD))
> +		v4l2_err(&vpfe_dev->v4l2_dev, "stream off failed in subdev\n");
> +	ret = videobuf_streamoff(&vpfe_dev->buffer_queue);
> +	mutex_unlock(&vpfe_dev->lock);
> +	return ret;
> +}
> +
> +static int vpfe_queryctrl(struct file *file, void *priv,
> +				struct v4l2_queryctrl *qc)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_subdev_info *sub_dev =
> +			&vpfe_dev->cfg->sub_devs[vpfe_dev->current_subdev];
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_queryctrl\n");
> +
> +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sub_dev->grp_id,
> +					  core, queryctrl, qc);
> +}
> +
> +static int vpfe_g_ctrl(struct file *file, void *priv,
> +			struct v4l2_control *ctrl)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_subdev_info *sub_dev =
> +			&vpfe_dev->cfg->sub_devs[vpfe_dev->current_subdev];
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_ctrl\n");
> +
> +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sub_dev->grp_id,
> +					  core, g_ctrl, ctrl);
> +}
> +
> +static int vpfe_s_ctrl(struct file *file, void *priv,
> +			     struct v4l2_control *ctrl)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_subdev_info *sub_dev =
> +			&vpfe_dev->cfg->sub_devs[vpfe_dev->current_subdev];
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_ctrl\n");
> +
> +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sub_dev->grp_id,
> +					  core, s_ctrl, ctrl);
> +}
> +
> +static int vpfe_cropcap(struct file *file, void *priv,
> +			      struct v4l2_cropcap *crop)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_cropcap\n");
> +
> +	if (vpfe_dev->index > vpfe_max_standards)
> +		return -EINVAL;
> +
> +	memset(crop, 0, sizeof(struct v4l2_cropcap));
> +	crop->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	crop->bounds.width = crop->defrect.width =
> +		vpfe_standards[vpfe_dev->index].width;
> +	crop->bounds.height = crop->defrect.height =
> +		vpfe_standards[vpfe_dev->index].height;
> +	crop->pixelaspect = vpfe_standards[vpfe_dev->index].pixelaspect;
> +	return 0;
> +}
> +
> +static int vpfe_g_crop(struct file *file, void *priv,
> +			     struct v4l2_crop *crop)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_crop\n");
> +
> +	crop->c = vpfe_dev->crop;
> +	return 0;
> +}
> +
> +static int vpfe_s_crop(struct file *file, void *priv,
> +			     struct v4l2_crop *crop)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_crop\n");
> +
> +	if (vpfe_dev->started) {
> +		/* make sure streaming is not started */
> +		v4l2_err(&vpfe_dev->v4l2_dev,
> +			"Cannot change crop when streaming is ON\n");
> +		return -EBUSY;
> +	}
> +
> +	ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +	if (ret)
> +		return ret;
> +
> +	if (crop->c.top < 0 || crop->c.left < 0) {
> +		v4l2_err(&vpfe_dev->v4l2_dev,
> +			"doesn't support negative values for top & left\n");
> +		ret = -EINVAL;
> +		goto unlock_out;
> +	}
> +
> +	/* adjust the width to 16 pixel boundry */
> +	crop->c.width = ((crop->c.width + 15) & ~0xf);
> +
> +	/* make sure parameters are valid */
> +	if ((crop->c.left + crop->c.width <=
> +		vpfe_dev->std_info.activepixels) &&
> +	    (crop->c.top + crop->c.height <=
> +		vpfe_dev->std_info.activelines)) {
> +		ccdc_dev->hw_ops.set_image_window(&crop->c);
> +		vpfe_dev->fmt.fmt.pix.width = crop->c.width;
> +		vpfe_dev->fmt.fmt.pix.height = crop->c.height;
> +		vpfe_dev->fmt.fmt.pix.bytesperline =
> +			ccdc_dev->hw_ops.get_line_length();
> +		vpfe_dev->fmt.fmt.pix.sizeimage =
> +			vpfe_dev->fmt.fmt.pix.bytesperline *
> +			vpfe_dev->fmt.fmt.pix.height;
> +		vpfe_dev->crop = crop->c;
> +	} else {
> +		v4l2_err(&vpfe_dev->v4l2_dev, "Error in S_CROP params\n");
> +		ret = -EINVAL;
> +	}

Here again handling the error case before the normal case will result in less 
indented code.

> +unlock_out:
> +	mutex_unlock(&vpfe_dev->lock);
> +	return ret;
> +}
> +
> +
> +static long vpfe_param_handler(struct file *file, void *priv,
> +		int cmd, void *param)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_param_handler\n");
> +
> +	if (vpfe_dev->started) {
> +		/* only allowed if streaming is not started */
> +		v4l2_err(&vpfe_dev->v4l2_dev, "device already started\n");
> +		return -EBUSY;
> +	}
> +
> +	ret = mutex_lock_interruptible(&vpfe_dev->lock);
> +	if (ret)
> +		return ret;
> +
> +	switch (cmd) {
> +	case VPFE_CMD_S_CCDC_RAW_PARAMS:
> +		ret = ccdc_dev->hw_ops.setparams(param);
> +		if (ret) {
> +			v4l2_err(&vpfe_dev->v4l2_dev,
> +				"Error in setting parameters"
> +				" in CCDC \n");
> +			goto unlock_out;
> +		}
> +		if (vpfe_get_image_format(vpfe_dev, &vpfe_dev->fmt) < 0) {
> +			v4l2_err(&vpfe_dev->v4l2_dev,
> +				"Invalid image format at CCDC \n");
> +			goto unlock_out;
> +		}
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +unlock_out:
> +	mutex_unlock(&vpfe_dev->lock);
> +	return ret;
> +}
> +
> +
> +/* vpfe capture ioctl operations */
> +static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
> +	.vidioc_querycap	 = vpfe_querycap,
> +	.vidioc_g_fmt_vid_cap    = vpfe_g_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_cap = vpfe_enum_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap    = vpfe_s_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap  = vpfe_try_fmt_vid_cap,
> +	.vidioc_enum_input	 = vpfe_enum_input,
> +	.vidioc_g_input		 = vpfe_g_input,
> +	.vidioc_s_input		 = vpfe_s_input,
> +	.vidioc_querystd	 = vpfe_querystd,
> +	.vidioc_s_std		 = vpfe_s_std,
> +	.vidioc_g_std		 = vpfe_g_std,
> +	.vidioc_reqbufs		 = vpfe_reqbufs,
> +	.vidioc_querybuf	 = vpfe_querybuf,
> +	.vidioc_qbuf		 = vpfe_qbuf,
> +	.vidioc_dqbuf		 = vpfe_dqbuf,
> +	.vidioc_streamon	 = vpfe_streamon,
> +	.vidioc_streamoff	 = vpfe_streamoff,
> +	.vidioc_queryctrl	 = vpfe_queryctrl,
> +	.vidioc_g_ctrl		 = vpfe_g_ctrl,
> +	.vidioc_s_ctrl		 = vpfe_s_ctrl,
> +	.vidioc_cropcap		 = vpfe_cropcap,
> +	.vidioc_g_crop		 = vpfe_g_crop,
> +	.vidioc_s_crop		 = vpfe_s_crop,
> +	.vidioc_default		 = vpfe_param_handler,
> +};
> +
> +static struct vpfe_device *vpfe_initialize(void)
> +{
> +	struct vpfe_device *vpfe_dev;
> +
> +	/* Default number of buffers should be 3 */
> +	if ((numbuffers > 0) &&
> +	    (numbuffers < config_params.min_numbuffers))
> +		numbuffers = config_params.min_numbuffers;
> +
> +	/*
> +	 * Set buffer size to min buffers size if invalid buffer size is
> +	 * given
> +	 */
> +	if (bufsize < config_params.min_bufsize)
> +		bufsize = config_params.min_bufsize;
> +
> +	config_params.numbuffers = numbuffers;
> +
> +	if (numbuffers)
> +		config_params.device_bufsize = bufsize;
> +
> +	/* Allocate memory for device objects */
> +	vpfe_dev = kmalloc(sizeof(struct vpfe_device), GFP_KERNEL);

sizeof(*vpfe_dev)

> +
> +	/* If memory allocation fails, return error */
> +	if (vpfe_dev)
> +		memset(vpfe_dev, 0, sizeof(*vpfe_dev));

Use kzalloc instead of kmalloc+memset.

> +
> +	return vpfe_dev;
> +}
> +
> +static void vpfe_disable_clock(struct vpfe_device *vpfe_dev)
> +{
> +	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
> +
> +	clk_disable(vpfe_cfg->vpssclk);
> +	clk_put(vpfe_cfg->vpssclk);
> +	clk_disable(vpfe_cfg->slaveclk);
> +	clk_put(vpfe_cfg->slaveclk);
> +	v4l2_info(vpfe_dev->pdev->driver,
> +		 "vpfe vpss master & slave clocks disabled\n");
> +}
> +
> +static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
> +{
> +	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
> +	int ret = -ENOENT;
> +
> +	vpfe_cfg->vpssclk = clk_get(vpfe_dev->pdev, "vpss_master");
> +	if (NULL == vpfe_cfg->vpssclk) {
> +		v4l2_err(vpfe_dev->pdev->driver, "No clock defined for"
> +			 "vpss_master\n");
> +		return ret;
> +	}
> +
> +	if (clk_enable(vpfe_cfg->vpssclk)) {
> +		v4l2_err(vpfe_dev->pdev->driver,
> +			"vpfe vpss master clock not enabled");
> +		goto out;
> +	}
> +	v4l2_info(vpfe_dev->pdev->driver,
> +		 "vpfe vpss master clock enabled\n");
> +
> +	vpfe_cfg->slaveclk = clk_get(vpfe_dev->pdev, "vpss_slave");
> +	if (NULL == vpfe_cfg->slaveclk) {
> +		v4l2_err(vpfe_dev->pdev->driver,
> +			"No clock defined for vpss slave\n");
> +		goto out;
> +	}
> +
> +	if (clk_enable(vpfe_cfg->slaveclk)) {
> +		v4l2_err(vpfe_dev->pdev->driver,
> +			 "vpfe vpss slave clock not enabled");
> +		goto out;
> +	}
> +	v4l2_info(vpfe_dev->pdev->driver,
> +		 "vpfe vpss slave clock enabled\n");
> +	return 0;
> +out:
> +	if (vpfe_cfg->slaveclk)

This should be vpssclk.

> +		clk_put(vpfe_cfg->vpssclk);
> +	if (vpfe_cfg->slaveclk)
> +		clk_put(vpfe_cfg->slaveclk);
> +
> +	return 0;
> +}
> +
> +/*
> + * vpfe_probe : This function creates device entries by register
> + * itself to the V4L2 driver and initializes fields of each
> + * device objects
> + */
> +static __init int vpfe_probe(struct platform_device *pdev)
> +{
> +	struct vpfe_config *vpfe_cfg;
> +	struct resource *res1, *res2;
> +	struct vpfe_device *vpfe_dev;
> +	struct i2c_adapter *i2c_adap;
> +	struct i2c_client *client;
> +	struct video_device *vfd;
> +	int ret = -ENOMEM, i, j;
> +	int num_subdevs = 0;
> +
> +	/* Get the pointer to the device object */
> +	vpfe_dev = vpfe_initialize();
> +
> +	if (!vpfe_dev) {
> +		v4l2_err(pdev->dev.driver,
> +			"Failed to allocate memory for vpfe_dev\n");
> +		return ret;
> +	}
> +
> +	vpfe_dev->pdev = &pdev->dev;
> +
> +	if (NULL == pdev->dev.platform_data) {
> +		v4l2_err(pdev->dev.driver, "Unable to get vpfe config\n");
> +		return -ENOENT;

You're leaking memory here (and in a few error paths below), vpfe_dev is still 
allocated.

> +	}
> +
> +	vpfe_cfg = pdev->dev.platform_data;
> +	vpfe_dev->cfg = vpfe_cfg;
> +	if (NULL == vpfe_cfg->ccdc ||
> +	    NULL == vpfe_cfg->card_name ||
> +	    NULL == vpfe_cfg->sub_devs) {
> +		v4l2_err(pdev->dev.driver, "null ptr in vpfe_cfg\n");
> +		return -ENOENT;
> +	}
> +
> +	/* enable vpss clocks */
> +	ret = vpfe_enable_clock(vpfe_dev);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&ccdc_lock);
> +	/* Allocate memory for ccdc configuration */
> +	ccdc_cfg = kmalloc(sizeof(struct ccdc_config), GFP_KERNEL);
> +	if (NULL == ccdc_cfg) {
> +		v4l2_err(pdev->dev.driver, "Memory allocation failed for"
> +			"ccdc_cfg");
> +		goto probe_out_unlock;
> +	}
> +
> +	strncpy(ccdc_cfg->name, vpfe_cfg->ccdc, 32);
> +	vpfe_dev->irq_type = VPFE_NO_IRQ;
> +	/* Get VINT0 irq resource */
> +	res1 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!res1) {
> +		v4l2_err(pdev->dev.driver, "Unable to get interrupt for VINT0");
> +		ret = -ENOENT;
> +		goto probe_out_unlock;
> +	}
> +	vpfe_dev->ccdc_irq0 = res1->start;
> +
> +	/* Get VINT1 irq resource */
> +	res1 = platform_get_resource(pdev,
> +				IORESOURCE_IRQ, 1);
> +	if (!res1) {
> +		v4l2_err(pdev->dev.driver, "Unable to get interrupt for VINT1");
> +		ret = -ENOENT;
> +		goto probe_out_unlock;
> +	}
> +	vpfe_dev->ccdc_irq1 = res1->start;
> +
> +	/* Get address base of CCDC */
> +	res1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	res2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!res1 || !res2) {
> +		v4l2_err(pdev->dev.driver,
> +			"Unable to get register address map\n");
> +		ret = -ENOENT;
> +		goto probe_out_unlock;
> +	}
> +
> +	ccdc_cfg->ccdc_addr_size = res1->end - res1->start + 1;
> +	if (!request_mem_region(res1->start, ccdc_cfg->ccdc_addr_size,
> +				pdev->dev.driver->name)) {
> +		v4l2_err(pdev->dev.driver,
> +			"Failed request_mem_region for ccdc base\n");
> +		ret = -ENXIO;
> +		goto probe_out_unlock;
> +	}
> +	ccdc_cfg->ccdc_addr = ioremap_nocache(res1->start,
> +					     ccdc_cfg->ccdc_addr_size);
> +	if (!ccdc_cfg->ccdc_addr) {
> +		v4l2_err(pdev->dev.driver, "Unable to ioremap ccdc addr\n");
> +		ret = -ENXIO;
> +		goto probe_out_release_mem1;
> +	}
> +
> +	ccdc_cfg->vpss_addr_size = res2->end - res2->start + 1;
> +	if (!request_mem_region(res2->start, ccdc_cfg->vpss_addr_size,
> +				pdev->dev.driver->name)) {
> +		v4l2_err(pdev->dev.driver,
> +			"Failed request_mem_region for vpss base\n");
> +		ret = -ENXIO;
> +		goto probe_out_unmap1;
> +	}
> +
> +	ccdc_cfg->vpss_addr = ioremap_nocache(res2->start,
> +					     ccdc_cfg->vpss_addr_size);
> +	if (!ccdc_cfg->vpss_addr) {
> +		v4l2_err(pdev->dev.driver, "Unable to ioremap vpss addr\n");
> +		ret = -ENXIO;
> +		goto probe_out_release_mem2;
> +	}
> +
> +	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, IRQF_DISABLED,
> +			  "vpfe_capture0", vpfe_dev);
> +
> +	if (0 != ret) {
> +		v4l2_err(pdev->dev.driver, "Unable to request interrupt\n");
> +		goto probe_out_unmap2;
> +	}
> +
> +	/* Allocate memory for video device */
> +	vfd = video_device_alloc();
> +	if (NULL == vfd) {
> +		ret = ENOMEM;
> +		v4l2_err(pdev->dev.driver,
> +			"Unable to alloc video device\n");
> +		goto probe_out_release_irq;
> +	}
> +
> +	/* Initialize field of video device */
> +	vfd->release		= video_device_release;
> +	vfd->current_norm	= V4L2_STD_UNKNOWN;
> +	vfd->fops		= &vpfe_fops;
> +	vfd->ioctl_ops		= &vpfe_ioctl_ops;
> +	vfd->minor		= -1;
> +	vfd->tvnorms		= 0;
> +	vfd->current_norm	= V4L2_STD_PAL;
> +	vfd->v4l2_dev 		= &vpfe_dev->v4l2_dev;
> +	snprintf(vfd->name, sizeof(vfd->name),
> +		 "%s_V%d.%d.%d",
> +		 CAPTURE_DRV_NAME,
> +		 (VPFE_CAPTURE_VERSION_CODE >> 16) & 0xff,
> +		 (VPFE_CAPTURE_VERSION_CODE >> 8) & 0xff,
> +		 (VPFE_CAPTURE_VERSION_CODE) & 0xff);
> +	/* Set video_dev to the video device */
> +	vpfe_dev->video_dev	= vfd;
> +
> +	ret = v4l2_device_register(&pdev->dev, &vpfe_dev->v4l2_dev);
> +	if (ret) {
> +		v4l2_err(pdev->dev.driver,
> +			"Unable to register v4l2 device.\n");
> +		goto probe_out_video_release;
> +	}
> +	v4l2_info(&vpfe_dev->v4l2_dev, "v4l2 device registered\n");
> +	spin_lock_init(&vpfe_dev->irqlock);
> +	spin_lock_init(&vpfe_dev->dma_queue_lock);
> +	mutex_init(&vpfe_dev->lock);
> +
> +	/* Initialize field of the device objects */
> +	vpfe_dev->numbuffers = config_params.numbuffers;
> +
> +	/* Initialize prio member of device object */
> +	v4l2_prio_init(&vpfe_dev->prio);
> +	/* register video device */
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
> +		"trying to register vpfe device.\n");
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
> +		"video_dev=%x\n", (int)&vpfe_dev->video_dev);
> +	vpfe_dev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	ret = video_register_device(vpfe_dev->video_dev,
> +				    VFL_TYPE_GRABBER, vpfe_nr[0]);

Pass -1 instead of vpfe_nr[0] to let video_register_device allocate a minor 
dynamically.

> +
> +	if (ret) {
> +		v4l2_err(pdev->dev.driver,
> +			"Unable to register video device.\n");
> +		goto probe_out_v4l2_unregister;
> +	}
> +
> +	v4l2_info(&vpfe_dev->v4l2_dev, "video device registered\n");
> +	/* set the driver data in platform device */
> +	platform_set_drvdata(pdev, vpfe_dev);
> +	/* set driver private data */
> +	video_set_drvdata(vpfe_dev->video_dev, vpfe_dev);
> +	i2c_adap = i2c_get_adapter(1);
> +	vpfe_cfg = pdev->dev.platform_data;
> +	num_subdevs = vpfe_cfg->num_subdevs;
> +	vpfe_dev->sd = kmalloc(sizeof(struct v4l2_subdev *) * num_subdevs,
> +				GFP_KERNEL);
> +	if (NULL == vpfe_dev->sd) {
> +		v4l2_err(&vpfe_dev->v4l2_dev,
> +			"unable to allocate memory for subdevice pointers\n");
> +		ret = -ENOMEM;
> +		goto probe_out_video_unregister;
> +	}
> +
> +	for (i = 0; i < num_subdevs; i++) {
> +		struct vpfe_subdev_info *sub_dev = &vpfe_cfg->sub_devs[i];
> +		struct v4l2_input *inps;
> +
> +		list_for_each_entry(client, &i2c_adap->clients, list) {
> +			if (!strcmp(client->name, sub_dev->name))
> +				break;
> +		}
> +
> +		if (NULL == client) {
> +			v4l2_err(&vpfe_dev->v4l2_dev, "No Subdevice found\n");
> +			ret =  -ENODEV;
> +			goto probe_sd_out;
> +		}
> +
> +		/* Get subdevice data from the client */
> +		vpfe_dev->sd[i] = i2c_get_clientdata(client);
> +		sub_dev->pdata = client->dev.platform_data;
> +		if (NULL == vpfe_dev->sd[i] || NULL == sub_dev->pdata) {
> +			v4l2_err(&vpfe_dev->v4l2_dev,
> +				"No Subdevice or platform client data\n");
> +			ret =  -ENODEV;
> +			goto probe_sd_out;
> +		}
> +
> +		vpfe_dev->sd[i]->grp_id = sub_dev->grp_id;
> +		ret = v4l2_device_register_subdev(&vpfe_dev->v4l2_dev,
> +						  vpfe_dev->sd[i]);
> +		if (ret) {
> +			ret =  -ENODEV;
> +			v4l2_err(&vpfe_dev->v4l2_dev,
> +				"Error registering v4l2 sub-device\n");
> +			goto probe_sd_out;
> +		}
> +		v4l2_info(&vpfe_dev->v4l2_dev, "v4l2 sub device %s"
> +			  " registered\n", client->name);
> +
> +		/* update tvnorms from the sub devices */
> +		for (j = 0; j < sub_dev->num_inputs; j++) {
> +			inps = &sub_dev->inputs[j];
> +			vfd->tvnorms |= inps->std;
> +		}
> +	}
> +	mutex_unlock(&ccdc_lock);
> +	return 0;
> +
> +probe_sd_out:
> +	for (j = i; j >= 0; j--)
> +		v4l2_device_unregister_subdev(vpfe_dev->sd[j]);
> +	kfree(vpfe_dev->sd);
> +probe_out_video_unregister:
> +	video_unregister_device(vpfe_dev->video_dev);
> +probe_out_v4l2_unregister:
> +	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
> +probe_out_video_release:
> +	video_device_release(vpfe_dev->video_dev);
> +probe_out_release_irq:
> +	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
> +probe_out_unmap2:
> +	iounmap(ccdc_cfg->vpss_addr);
> +probe_out_release_mem2:
> +	release_mem_region(res2->start, res2->end - res2->start + 1);
> +probe_out_unmap1:
> +	iounmap(ccdc_cfg->ccdc_addr);
> +probe_out_release_mem1:
> +	release_mem_region(res1->start, res1->end - res1->start + 1);
> +probe_out_unlock:
> +	kfree(vpfe_dev);
> +	kfree(ccdc_cfg);
> +	mutex_unlock(&ccdc_lock);
> +	return ret;
> +}
> +
> +/*
> + * vpfe_remove : It un-register device from V4L2 driver
> + */
> +static int vpfe_remove(struct platform_device *pdev)
> +{
> +	struct vpfe_device *vpfe_dev = platform_get_drvdata(pdev);
> +	struct resource *res;
> +	int j;
> +
> +	v4l2_info(pdev->dev.driver, "vpfe_remove\n");
> +
> +	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
> +	/* Unregister video device */
> +	for (j = 0; j < vpfe_dev->cfg->num_subdevs; j++)
> +		v4l2_device_unregister_subdev(vpfe_dev->sd[j]);
> +	kfree(vpfe_dev->sd);
> +	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
> +	video_unregister_device(vpfe_dev->video_dev);
> +	mutex_lock(&ccdc_lock);
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	release_mem_region(res->start, res->end - res->start + 1);
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	release_mem_region(res->start, res->end - res->start + 1);
> +	iounmap(ccdc_cfg->ccdc_addr);
> +	iounmap(ccdc_cfg->vpss_addr);
> +	mutex_unlock(&ccdc_lock);
> +	vpfe_disable_clock(vpfe_dev);
> +	kfree(vpfe_dev);
> +	kfree(ccdc_cfg);
> +	return 0;
> +}
> +
> +static int
> +vpfe_suspend(struct platform_device *dev, pm_message_t state)
> +{
> +	/* add suspend code here later */
> +	return -1;
> +}
> +
> +static int
> +vpfe_resume(struct platform_device *dev)
> +{
> +	/* add resume code here later */
> +	return -1;
> +}
> +
> +static struct platform_driver vpfe_driver = {
> +	.driver = {
> +		.name = CAPTURE_DRV_NAME,
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = vpfe_probe,
> +	.remove = __devexit_p(vpfe_remove),
> +	.suspend = vpfe_suspend,
> +	.resume  = vpfe_resume,
> +};
> +
> +static __init int vpfe_init(void)
> +{
> +	printk(KERN_NOTICE "vpfe_init\n");
> +	/* Register driver to the kernel */
> +	return platform_driver_register(&vpfe_driver);
> +}
> +
> +/*
> + * vpfe_cleanup : This function un-registers device driver
> + */
> +static void vpfe_cleanup(void)
> +{
> +	platform_driver_unregister(&vpfe_driver);
> +}
> +
> +module_init(vpfe_init);
> +module_exit(vpfe_cleanup);
> +MODULE_AUTHOR("Texas Instruments.");
> +MODULE_DESCRIPTION("VPFE Video for Linux Capture Driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/media/davinci/vpfe_capture.h
> b/include/media/davinci/vpfe_capture.h new file mode 100644
> index 0000000..dc255fc
> --- /dev/null
> +++ b/include/media/davinci/vpfe_capture.h
> @@ -0,0 +1,223 @@
> +/*
> + * Copyright (C) 2008-2009 Texas Instruments Inc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
> USA + */
> +
> +#ifndef _VPFE_CAPTURE_H
> +#define _VPFE_CAPTURE_H
> +
> +#ifdef __KERNEL__
> +
> +/* Header files */
> +#include <media/v4l2-dev.h>
> +#include <linux/videodev2.h>
> +#include <linux/clk.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-device.h>
> +#include <media/videobuf-dma-contig.h>
> +#include <media/davinci/ccdc_hw_device.h>
> +
> +#define VPFE_CAPTURE_NUM_DECODERS        5
> +
> +/* Macros */
> +#define VPFE_MAJOR_RELEASE              0
> +#define VPFE_MINOR_RELEASE              0
> +#define VPFE_BUILD                      1
> +#define VPFE_CAPTURE_VERSION_CODE       ((VPFE_MAJOR_RELEASE << 16) | \
> +					(VPFE_MINOR_RELEASE << 8)  | \
> +					VPFE_BUILD)
> +
> +#define VPFE_VALID_FIELD(field)  ((V4L2_FIELD_ANY == field) || \
> +				(V4L2_FIELD_NONE == field) || \
> +				(V4L2_FIELD_INTERLACED == field) || \
> +				(V4L2_FIELD_SEQ_TB == field))
> +
> +#define VPFE_VALID_BUFFER_TYPE(buftype)	{ \
> +			(V4L2_BUF_TYPE_VIDEO_CAPTURE == buftype) }
> +
> +#define VPFE_CAPTURE_MAX_DEVICES	1
> +#define VPFE_MAX_DECODER_STD		50
> +#define VPFE_TIMER_COUNT		5

Those three constants are unused.

> +#define VPFE_MAX_PIX_FORMATS		6
> +#define CAPTURE_DRV_NAME		"vpfe-capture"
> +
> +/*
> + * VPFE_USE_IMP_IRQ will be used when driver is enhanced to support
> + * imp resizer. Currently only VPFE_USE_CCDC_IRQ is used
> + */
> +enum vpfe_irq_use_type {
> +	VPFE_USE_CCDC_IRQ,
> +	VPFE_USE_IMP_IRQ,
> +	VPFE_NO_IRQ
> +};
> +
> +/*
> + * Following enum used to indicate if driver output from CCDC
> + * or previewer/resizer blocks of imp. Only CCDC_OUT is used
> + * now, but the others will be used eventually when more
> + * features are ported to the driver
> + */
> +enum output_src {
> +	VPFE_CCDC_OUT,
> +	VPFE_IMP_PREV_OUT,
> +	VPFE_IMP_RSZ_OUT
> +};
> +
> +struct vpfe_pixel_format {
> +	unsigned int pix_fmt;
> +	char *desc;
> +	enum vpfe_hw_pix_format hw_fmt;
> +};
> +
> +struct vpfe_std_info {
> +	int activepixels;
> +	int activelines;

Most field names in your structures use _ to separate words. You might want to 
update those two.

> +	/* current frame format */
> +	int frame_format;
> +};
> +
> +struct vpfe_subdev_info {
> +	/* Sub device name */
> +	char name[32];
> +	/* Sub device group id */
> +	int grp_id;
> +	/* Number of inputs supported */
> +	int num_inputs;
> +	/* inputs available at the sub device */
> +	struct v4l2_input *inputs;
> +	/* Sub dev routing information for each input */
> +	struct v4l2_routing *routes;
> +	/* check if sub dev supports routing */
> +	int can_route;
> +	/* sub device private data */
> +	void *pdata;
> +};
> +
> +struct vpfe_config {
> +	/* Number of sub devices connected to vpfe */
> +	int num_subdevs;
> +	/* information about each subdev */
> +	struct vpfe_subdev_info *sub_devs;
> +	/* evm card info */
> +	char *card_name;
> +	/* ccdc name */
> +	char *ccdc;
> +	/* vpfe clock */
> +	struct clk *vpssclk;
> +	struct clk *slaveclk;
> +};
> +
> +struct vpfe_device {
> +	/* V4l2 specific parameters */
> +	/* Identifies video device for this channel */
> +	struct video_device *video_dev;
> +	/* sub devices */
> +	struct v4l2_subdev **sd;
> +	/* vpfe cfg */
> +	struct vpfe_config *cfg;
> +	/* V4l2 device */
> +	struct v4l2_device v4l2_dev;
> +	/* parent device */
> +	struct device *pdev;
> +	/* Used to keep track of state of the priority */
> +	struct v4l2_prio_state prio;
> +	/* number of open instances of the channel */
> +	u32 usrs;
> +	/* Indicates id of the field which is being displayed */
> +	u32 field_id;
> +	/* flag to indicate whether decoder is initialized */
> +	u8 initialized;
> +	/* current interface type */
> +	struct vpfe_hw_if_param vpfe_if_params;
> +	/* Index of the currently selected decoder */
> +	unsigned char current_subdev;
> +	/* current input at the sub device */
> +	int current_input;
> +	/* Keeps track of the information about the standard */
> +	struct vpfe_std_info std_info;
> +	/* index into std table */
> +	int index;
> +	/* To track if we need to attach IPIPE IRQ or CCDC IRQ */
> +	enum vpfe_irq_use_type irq_type;
> +	/* CCDC IRQs used when CCDC/ISIF output to SDRAM */
> +	unsigned int ccdc_irq0;
> +	unsigned int ccdc_irq1;
> +	/* Output from CCDC or IMP */
> +	enum output_src out_from;
> +	/* number of buffers in fbuffers */
> +	u32 numbuffers;
> +	/* List of buffer pointers for storing frames */
> +	u8 *fbuffers[VIDEO_MAX_FRAME];
> +	/* Pointer pointing to current v4l2_buffer */
> +	struct videobuf_buffer *cur_frm;
> +	/* Pointer pointing to next v4l2_buffer */
> +	struct videobuf_buffer *next_frm;
> +	/*
> +	 * This field keeps track of type of buffer exchange mechanism
> +	 * user has selected
> +	 */
> +	enum v4l2_memory memory;
> +	/* Used to store pixel format */
> +	struct v4l2_format fmt;
> +	/*
> +	 * used when IMP is chained to store the crop window which
> +	 * is different from the image window
> +	 */
> +	struct v4l2_rect crop;
> +	/* Buffer queue used in video-buf */
> +	struct videobuf_queue buffer_queue;
> +	/* Queue of filled frames */
> +	struct list_head dma_queue;
> +	/* Used in video-buf */
> +	spinlock_t irqlock;
> +	/* IRQ lock for DMA queue */
> +	spinlock_t dma_queue_lock;
> +	/* lock used to access this structure */
> +	struct mutex lock;
> +	/* number of users performing IO */
> +	u32 io_usrs;
> +	/* Indicates whether streaming started */
> +	u8 started;
> +	/*
> +	 * offset where second field starts from the starting of the
> +	 * buffer for field seperated YCbCr formats
> +	 */
> +	u32 field_off;
> +};
> +
> +/* File handle structure */
> +struct vpfe_fh {
> +	struct vpfe_device *vpfe_dev;
> +	/* Indicates whether this file handle is doing IO */
> +	u8 io_allowed;
> +	/* Used to keep track priority of this instance */
> +	enum v4l2_priority prio;
> +	/* Used to indicate channel is initialize or not */
> +	u8 initialized;
> +};
> +
> +struct vpfe_config_params {
> +	u8 min_numbuffers;
> +	u8 numbuffers;
> +	u32 min_bufsize;
> +	u32 device_bufsize;
> +};
> +
> +#endif				/* End of __KERNEL__ */
> +/* IOCTLs */
> +#define VPFE_CMD_S_CCDC_RAW_PARAMS _IOW('V', BASE_VIDIOC_PRIVATE + 1, \
> +					void *)
> +#endif				/* _DAVINCI_VPFE_H */

Code review for the other patches will follow as soon as possible.

Best regards,

Laurent Pinchart


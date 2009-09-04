Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:57334 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbZIDIhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2009 04:37:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] DVB/V4L: ov511 - export snapshot button through input layer
Date: Fri, 4 Sep 2009 10:37:46 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20090904054805.5C944526EA5@mailhub.coreip.homeip.net>
In-Reply-To: <20090904054805.5C944526EA5@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909041037.46690.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 04 September 2009 07:15:07 Dmitry Torokhov wrote:
> From: Bastien Nocera <hadess@hadess.net>
>
> Register an input device with one button, and for the supported
> OV511 webcams, poll and check whether the snapshot button has been
> pressed on each new frame.
>
> [dtor@mail.ru: fix freeing of phys, plug into Kconfig, make compile]
> Signed-off-by: Bastien Nocera <hadess@hadess.net>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>
> Mauro,
>
> This is something that's been sitting in my queue for quite some
> time, please consider applying.
>
> Thanks!
>
>  drivers/media/video/Kconfig |    8 +++
>  drivers/media/video/ov511.c |  109
> +++++++++++++++++++++++++++++++++++++++---- drivers/media/video/ov511.h |  
>  8 +++
>  3 files changed, 116 insertions(+), 9 deletions(-)
>
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index dcf9fa9..42573e0 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -888,6 +888,14 @@ config USB_OV511
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ov511.
>
> +config USB_OV511_SNAPSHOT_BUTTON
> +	bool "USB OV511 Snapshot Button support"
> +	depends on USB_OV511
> +	depends on INPUT
> +	---help---
> +	  Say Y here if you want the driver to report snapshot button through
> +	  input layer.
> +
>  config USB_SE401
>  	tristate "USB SE401 Camera support"
>  	depends on VIDEO_V4L1
> diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
> index 0bc2cf5..484165c 100644
> --- a/drivers/media/video/ov511.c
> +++ b/drivers/media/video/ov511.c
> @@ -44,6 +44,8 @@
>  #include <asm/processor.h>
>  #include <linux/mm.h>
>  #include <linux/device.h>
> +#include <linux/input.h>
> +#include <linux/usb/input.h>
>
>  #if defined (__i386__)
>  	#include <asm/cpufeature.h>
> @@ -92,7 +94,7 @@ static int cams			= 1;
>  static int compress;
>  static int testpat;
>  static int dumppix;
> -static int led 			= 1;
> +static int led			= 1;

There's a lot of white space cleanup in the patch that's unrelated to the 
subject. Could you put that in a separate patch ?

>  static int dump_bridge;
>  static int dump_sensor;
>  static int printph;
> @@ -352,6 +354,83 @@ rvfree(void *mem, unsigned long size)
>
>  /**********************************************************************
>   *
> + * Input device
> + *
> + **********************************************************************/
> +#ifdef CONFIG_USB_OV511_SNAPSHOT_BUTTON
> +
> +static int ov511_input_init(struct usb_ov511 *ov)
> +{
> +	struct usb_device *udev = ov->dev;
> +	struct input_dev *input;
> +	int err = -ENOMEM;
> +
> +	input = input_allocate_device();
> +	if (!input)
> +		goto err_out;
> +
> +	usb_make_path(udev, ov->key_phys, OV511_KEY_PHYS_SIZE);
> +	strlcat(ov->key_phys, "/input0", OV511_KEY_PHYS_SIZE);

What about sizeof(ov->key_phys) instead of OV511_KEY_PHYS_SIZE ?

> +
> +	input->name = "OV511 Snapshot Button";
> +	input->phys = ov->key_phys;
> +	usb_to_input_id(udev, &input->id);
> +	input->dev.parent = &udev->dev;
> +
> +	__set_bit(EV_KEY, input->evbit);
> +	__set_bit(KEY_CAMERA, input->keybit);
> +
> +	err = input_register_device(input);
> +	if (err)
> +		goto err_out;
> +
> +	ov->key_input = input;
> +	return 0;
> +
> +err_out:
> +	input_free_device(input);
> +	return err;
> +}
> +
> +static void ov511_input_cleanup(struct usb_ov511 *ov)
> +{
> +	if (ov->key_input) {
> +		input_unregister_device(ov->key_input);
> +		ov->key_input = NULL;
> +	}
> +}
> +
> +static void ov511_input_report_key(struct usb_ov511 *ov)
> +{
> +	struct input_dev *input = ov->key_input;
> +
> +	if (input) {
> +		input_report_key(input, KEY_CAMERA, 1);
> +		input_sync(input);
> +		input_report_key(input, KEY_CAMERA, 0);
> +		input_sync(input);
> +	}
> +}
> +
> +#else
> +
> +static inline int ov511_input_init(struct usb_ov511 *ov)
> +{
> +	return 0;
> +}
> +
> +static inline void ov511_input_cleanup(struct usb_ov511 *ov)
> +{
> +}
> +
> +static inline void ov511_input_report_key(struct usb_ov511 *ov)
> +{
> +}
> +
> +#endif /* CONFIG_USB_OV511_SNAPSHOT_BUTTON */
> +
> +/**********************************************************************
> + *
>   * Register I/O
>   *
>   **********************************************************************/
> @@ -1105,7 +1184,6 @@ ov51x_clear_snapshot(struct usb_ov511 *ov)
>  	}
>  }
>
> -#if 0
>  /* Checks the status of the snapshot button. Returns 1 if it was pressed
> since * it was last cleared, and zero in all other cases (including errors)
> */ static int
> @@ -1130,7 +1208,6 @@ ov51x_check_snapshot(struct usb_ov511 *ov)
>
>  	return status;
>  }
> -#endif
>
>  /* This does an initial reset of an OmniVision sensor and ensures that I2C
>   * is synchronized. Returns <0 for failure.
> @@ -3149,10 +3226,10 @@ ov51x_postprocess_yuv420(struct usb_ov511 *ov,
> struct ov511_frame *frame) }
>
>  /* Post-processes the specified frame. This consists of:
> - * 	1. Decompress frame, if necessary
> + *	1. Decompress frame, if necessary
>   *	2. Deinterlace frame and scale to proper size, if necessary
> - * 	3. Convert from YUV planar to destination format, if necessary
> - * 	4. Fix the RGB offset, if necessary
> + *	3. Convert from YUV planar to destination format, if necessary
> + *	4. Fix the RGB offset, if necessary
>   */
>  static void
>  ov51x_postprocess(struct usb_ov511 *ov, struct ov511_frame *frame)
> @@ -4387,6 +4464,11 @@ redo:
>  			if ((ov->snap_enabled) && (frame->snapshot)) {
>  				frame->snapshot = 0;
>  				ov51x_clear_snapshot(ov);
> +			} else if (!ov->snap_enabled && ov->bclass == BCL_OV511) {
> +				if (ov51x_check_snapshot(ov) == 1) {
> +					ov511_input_report_key(ov);
> +					ov51x_clear_snapshot(ov);
> +				}
>  			}
>
>  			/* Decompression, format conversion, etc... */
> @@ -5237,7 +5319,7 @@ ov511_configure(struct usb_ov511 *ov)
>  	};
>
>  	static struct ov511_regvals aRegvalsNorm511[] = {
> -		{ OV511_REG_BUS, R511_DRAM_FLOW_CTL, 	0x01 },
> +		{ OV511_REG_BUS, R511_DRAM_FLOW_CTL,	0x01 },
>  		{ OV511_REG_BUS, R51x_SYS_SNAP,		0x00 },
>  		{ OV511_REG_BUS, R51x_SYS_SNAP,		0x02 },
>  		{ OV511_REG_BUS, R51x_SYS_SNAP,		0x00 },
> @@ -5400,7 +5482,7 @@ ov518_configure(struct usb_ov511 *ov)
>  	static struct ov511_regvals aRegvalsNorm518[] = {
>  		{ OV511_REG_BUS, R51x_SYS_SNAP,		0x02 }, /* Reset */
>  		{ OV511_REG_BUS, R51x_SYS_SNAP,		0x01 }, /* Enable */
> -		{ OV511_REG_BUS, 0x31, 			0x0f },
> +		{ OV511_REG_BUS, 0x31,			0x0f },
>  		{ OV511_REG_BUS, 0x5d,			0x03 },
>  		{ OV511_REG_BUS, 0x24,			0x9f },
>  		{ OV511_REG_BUS, 0x25,			0x90 },
> @@ -5413,7 +5495,7 @@ ov518_configure(struct usb_ov511 *ov)
>  	static struct ov511_regvals aRegvalsNorm518Plus[] = {
>  		{ OV511_REG_BUS, R51x_SYS_SNAP,		0x02 }, /* Reset */
>  		{ OV511_REG_BUS, R51x_SYS_SNAP,		0x01 }, /* Enable */
> -		{ OV511_REG_BUS, 0x31, 			0x0f },
> +		{ OV511_REG_BUS, 0x31,			0x0f },
>  		{ OV511_REG_BUS, 0x5d,			0x03 },
>  		{ OV511_REG_BUS, 0x24,			0x9f },
>  		{ OV511_REG_BUS, 0x25,			0x90 },
> @@ -5880,6 +5962,13 @@ ov51x_probe(struct usb_interface *intf, const struct
> usb_device_id *id)
>
>  	mutex_lock(&ov->lock);
>
> +	/* Snapshot is currently only supported on OV511,
> +	 * so no need to register the input device if it's not supported */
> +	if (!ov->snap_enabled && ov->bclass == BCL_OV511) {
> +		if (ov511_input_init(ov) < 0)
> +			dev_warn(&ov->dev->dev, "Could not register input device\n");
> +	}
> +
>  	return 0;
>
>  error:
> @@ -5928,6 +6017,8 @@ ov51x_disconnect(struct usb_interface *intf)
>  	if (ov->vdev)
>  		video_unregister_device(ov->vdev);
>
> +	ov511_input_cleanup(ov);
> +
>  	for (n = 0; n < OV511_NUMFRAMES; n++)
>  		ov->frame[n].grabstate = FRAME_ERROR;
>
> diff --git a/drivers/media/video/ov511.h b/drivers/media/video/ov511.h
> index c450c92..7c0ade1 100644
> --- a/drivers/media/video/ov511.h
> +++ b/drivers/media/video/ov511.h
> @@ -259,6 +259,9 @@
>  /* Size of usb_make_path() buffer */
>  #define OV511_USB_PATH_LEN	64
>
> +/* Size of 'phys' field for the snapshot button input device */
> +#define OV511_KEY_PHYS_SIZE	64
> +
>  /* Bridge types */
>  enum {
>  	BRG_UNKNOWN,
> @@ -469,6 +472,11 @@ struct usb_ov511 {
>
>  	int snap_enabled;	/* Snapshot mode enabled */
>
> +#ifdef CONFIG_USB_OV511_SNAPSHOT_BUTTON
> +	struct input_dev *key_input;
> +	char key_phys[OV511_KEY_PHYS_SIZE];
> +#endif
> +
>  	int bridge;		/* Type of bridge (BRG_*) */
>  	int bclass;		/* Class of bridge (BCL_*) */
>  	int sensor;		/* Type of image sensor chip (SEN_*) */

-- 
Laurent Pinchart

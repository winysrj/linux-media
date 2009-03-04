Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42153 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbZCDSwb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 13:52:31 -0500
Date: Wed, 4 Mar 2009 15:51:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: kilgota@banach.math.auburn.edu
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] to gspca, to support SQ905C cameras.
Message-ID: <20090304155153.35c58fc0@pedra.chehab.org>
In-Reply-To: <alpine.LNX.2.00.0903031328290.21047@banach.math.auburn.edu>
References: <20090212121348.49eab19a@free.fr>
	<alpine.LNX.2.00.0903031328290.21047@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Mar 2009 13:54:59 -0600 (CST)
kilgota@banach.math.auburn.edu wrote:

> The SQ905C cameras (0x2770:0x905C) cameras, as well as two other closely 
> related varieties (0x2770:0x9050 and 0x2770:0x913D) are supported in what 
> follows.

Please check your patch with checkpatch.pl. There are lots of troubles, maybe
some introduced by your emailer, since you have tons of whitespace issues.

> 
> These cameras are the successors in the marketplace of the SQ905 cameras. 
> They are similar to the SQ905 cameras, in that they use bulk transport 
> while streaming, and thus the driver functions similarly, using a 
> workqueue to perform the streaming. However, there are also some serious
> differences. These differences include
> 
> -- a different structure of the commands
> -- commands do not pass a data byte to the camera
> -- commands do not require a subsequent "read" operation
> -- while streaming, there are no commands sent during a frame download, 
> nor is there an ack between frames. Thus, the only command sent during 
> streaming is a command to quit streaming.
> -- frame header is of a different size
> -- the SQ905C cameras all stream compressed data, whereas the data for
> the older SQ905 cameras is not compressed
> -- since compressed frames are of variable size, the frame header is read 
> first and contains the data size for the coming frame
> -- the supported resolution settings are different
> 
> I should also mention that the introduction of support for these cameras 
> requires an additional fourcc code to be introduced in 
> linux/include/linux/videodev2.h, and the addition of the decompression 
> algorithm in libv4lconvert. I have submitted the libv4lconvert patch a 
> couple of days ago.
> 
> The code in the new sq905c.c is based upon the structure of the code in 
> gspca/sq905.c, and upon the code in libgphoto2/camlibs/digigr8, which 
> supports the same set of cameras in stillcam mode. I am a co-author of 
> gspca/sq905.c and I am the sole author of libgphoto2/camlibs/digigr8, 
> which is licensed under the LGPL. I hereby give myself permission to use 
> my own code from libgphoto2 in gspca/sq905c.c.
> 
> Signed-off-by Theodore Kilgore <kilgota@auburn.edu>
> 
> contents of the file sq905c.patch follow
> -------------------------------------------------------------------------
> diff -uprN linuxa/drivers/media/video/gspca/Kconfig linuxb/drivers/media/video/gspca/Kconfig
> --- linuxa/drivers/media/video/gspca/Kconfig	2009-02-23 23:59:07.000000000 -0600
> +++ linuxb/drivers/media/video/gspca/Kconfig	2009-02-28 19:55:49.000000000 -0600
> @@ -185,6 +185,15 @@ config USB_GSPCA_SQ905
>   	  To compile this driver as a module, choose M here: the
>   	  module will be called gspca_sq905.
> 
> +config USB_GSPCA_SQ905C
> +	tristate "SQ Technologies SQ905C based USB Camera Driver"
> +	depends on VIDEO_V4L2 && USB_GSPCA
> +	help
> +	  Say Y here if you want support for cameras based on the SQ905C chip.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called gspca_sq905c.
> +
>   config USB_GSPCA_STK014
>   	tristate "Syntek DV4000 (STK014) USB Camera Driver"
>   	depends on VIDEO_V4L2 && USB_GSPCA
> diff -uprN linuxa/drivers/media/video/gspca/Makefile linuxb/drivers/media/video/gspca/Makefile
> --- linuxa/drivers/media/video/gspca/Makefile	2009-02-23 23:59:07.000000000 -0600
> +++ linuxb/drivers/media/video/gspca/Makefile	2009-02-28 19:54:54.000000000 -0600
> @@ -17,6 +17,7 @@ obj-$(CONFIG_USB_GSPCA_SPCA506)  += gspc
>   obj-$(CONFIG_USB_GSPCA_SPCA508)  += gspca_spca508.o
>   obj-$(CONFIG_USB_GSPCA_SPCA561)  += gspca_spca561.o
>   obj-$(CONFIG_USB_GSPCA_SQ905)    += gspca_sq905.o
> +obj-$(CONFIG_USB_GSPCA_SQ905C)    += gspca_sq905c.o
>   obj-$(CONFIG_USB_GSPCA_SUNPLUS)  += gspca_sunplus.o
>   obj-$(CONFIG_USB_GSPCA_STK014)   += gspca_stk014.o
>   obj-$(CONFIG_USB_GSPCA_T613)     += gspca_t613.o
> @@ -43,6 +44,7 @@ gspca_spca506-objs  := spca506.o
>   gspca_spca508-objs  := spca508.o
>   gspca_spca561-objs  := spca561.o
>   gspca_sq905-objs    := sq905.o
> +gspca_sq905c-objs    := sq905c.o
>   gspca_stk014-objs   := stk014.o
>   gspca_sunplus-objs  := sunplus.o
>   gspca_t613-objs     := t613.o
> diff -uprN linuxa/drivers/media/video/gspca/sq905c.c linuxb/drivers/media/video/gspca/sq905c.c
> --- linuxa/drivers/media/video/gspca/sq905c.c	1969-12-31 18:00:00.000000000 -0600
> +++ linuxb/drivers/media/video/gspca/sq905c.c	2009-03-02 20:42:42.000000000 -0600
> @@ -0,0 +1,330 @@
> +/*
> + * SQ905C subdriver
> + *
> + * Copyright (C) 2009 Theodore Kilgore
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +
> +/*
> + *
> + * This driver uses work done in
> + * libgphoto2/camlibs/digigr8, Copyright (C) Theodore Kilgore.
> + *
> + * This driver has also used as a base the sq905c driver 
> + * and may contain code fragments from it.
> + */
> +
> +#define MODULE_NAME "sq905c"
> +
> +#include <linux/workqueue.h>
> +#include "gspca.h"
> +
> +MODULE_AUTHOR("Theodore Kilgore <kilgota@auburn.edu>");
> +MODULE_DESCRIPTION("GSPCA/SQ905C USB Camera Driver");
> +MODULE_LICENSE("GPL");
> +
> +/* Default timeouts, in ms */
> +#define SQ905C_CMD_TIMEOUT 500
> +#define SQ905C_DATA_TIMEOUT 1000
> +
> +/* Maximum transfer size to use. */
> +#define SQ905C_MAX_TRANSFER 0x8000
> +
> +#define FRAME_HEADER_LEN 0x50
> +
> +/* Commands. These go in the "value" slot. */
> +#define SQ905C_CLEAR   0xa0		/* clear everything */
> +#define SQ905C_CAPTURE_LOW 0xa040	/* Starts capture at 160x120 */
> +#define SQ905C_CAPTURE_MED 0x1440	/* Starts capture at 320x240 */
> +#define SQ905C_CAPTURE_HI 0x2840	/* Starts capture at 320x240 */
> +
> +/* For capture, this must go in the "index" slot. */
> +#define SQ905C_CAPTURE_INDEX 0x110f
> +
> +/* Structure to hold all of our device specific stuff */
> +struct sd {
> +	struct gspca_dev gspca_dev;	/* !! must be the first item */
> +        const struct v4l2_pix_format *cap_mode;
> +	/* Driver stuff */
> +	struct work_struct work_struct;
> +	struct workqueue_struct *work_thread;
> +};
> +
> +/* 
> + * Most of these cameras will do 640x480 and 320x240. 160x120 works 
> + * in theory but gives very poor output. Therefore, not supported. 
> + * The 0x2770:0x9050 cameras have max resolution of 320x240.
> + */
> +static struct v4l2_pix_format sq905c_mode[] = {
> +	{ 320, 240, V4L2_PIX_FMT_SQ905C, V4L2_FIELD_NONE,
> +		.bytesperline = 320,
> +		.sizeimage = 320 * 240,
> +		.colorspace = V4L2_COLORSPACE_SRGB,
> +		.priv = 0},
> +	{ 640, 480, V4L2_PIX_FMT_SQ905C, V4L2_FIELD_NONE,
> +		.bytesperline = 640,
> +		.sizeimage = 640 * 480,
> +		.colorspace = V4L2_COLORSPACE_SRGB,
> +		.priv = 0}
> +};
> +
> +/* Send a command to the camera. */
> +static int sq905c_command(struct gspca_dev *gspca_dev, u16 command, u16 index)
> +{
> +	int ret;
> +
> +	ret = usb_control_msg(gspca_dev->dev,
> +			      usb_sndctrlpipe(gspca_dev->dev, 0),
> +			      USB_REQ_SYNCH_FRAME,                /* request */
> +			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			      command, index, NULL, 0,
> +			      SQ905C_CMD_TIMEOUT);
> +	if (ret < 0) {
> +		PDEBUG(D_ERR, "%s: usb_control_msg failed (%d)",
> +			__func__, ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/* This function is called as a workqueue function and runs whenever the camera
> + * is streaming data. Because it is a workqueue function it is allowed to sleep
> + * so we can use synchronous USB calls. To avoid possible collisions with other
> + * threads attempting to use the camera's USB interface the gspca usb_lock is 
> + * used when performing the one USB control operation inside the workqueue, 
> + * which tells the camera to close the stream. In practice the only thing 
> + * which needs to be protected against is the usb_set_interface call that 
> + * gspca makes during stream_off. Otherwise the camera doesn't provide any 
> + * controls that the user could try to change.
> + */
> +static void sq905c_dostream(struct work_struct *work)
> +{
> +	struct sd *dev = container_of(work, struct sd, work_struct);
> +	struct gspca_dev *gspca_dev = &dev->gspca_dev;
> +	struct gspca_frame *frame;
> +	int bytes_left; /* bytes remaining in current frame. */
> +	int data_len;   /* size to use for the next read. */
> +	int act_len;
> +	int discarding=0; /* true if we failed to get space for frame. */
> +	int packet_type;
> +	int ret;
> +	u8 *buffer;
> +
> +	buffer = kmalloc(SQ905C_MAX_TRANSFER, GFP_KERNEL | GFP_DMA);
> +	if (!buffer) {
> +		PDEBUG(D_ERR, "Couldn't allocate USB buffer");
> +		goto quit_stream;
> +	}
> +
> +	while (gspca_dev->present && gspca_dev->streaming) {
> +		if (!gspca_dev->present)
> +			goto quit_stream;
> +		/* Request the header, which tells the size to download */
> +		ret = usb_bulk_msg(gspca_dev->dev,
> +				usb_rcvbulkpipe(gspca_dev->dev, 0x81),
> +				buffer, FRAME_HEADER_LEN, &act_len, 
> +				SQ905C_DATA_TIMEOUT);
> +		PDEBUG(D_STREAM,
> +			"Got %d bytes out of %d for header",
> +			act_len, FRAME_HEADER_LEN);
> +		if (ret<0 || act_len<FRAME_HEADER_LEN) {
> +			goto quit_stream;
> +		} 
> +		/* size is read from 4 bytes starting 0x40, little endian */
> +		bytes_left = buffer[0x40]|(buffer[0x41]<<8)|(buffer[0x42]<<16)
> +					|(buffer[0x43]<<24);
> +		PDEBUG(D_STREAM, "bytes_left = 0x%x", bytes_left);
> +		/* We keep the header. It has other information, too. */
> +		packet_type = FIRST_PACKET;
> +		frame = gspca_get_i_frame(gspca_dev);
> +		if (frame && !discarding) {
> +			gspca_frame_add(gspca_dev, packet_type,
> +				frame, buffer, FRAME_HEADER_LEN);
> +			} else
> +				discarding = 1;
> +		while (bytes_left > 0) {
> +			data_len = bytes_left > SQ905C_MAX_TRANSFER ?
> +				SQ905C_MAX_TRANSFER : bytes_left;
> +			if (!gspca_dev->present)
> +				goto quit_stream;
> +			ret = usb_bulk_msg(gspca_dev->dev,
> +				usb_rcvbulkpipe(gspca_dev->dev, 0x81),
> +				buffer, data_len, &act_len, 
> +				SQ905C_DATA_TIMEOUT);
> +			if (ret<0 || act_len<data_len)
> +				goto quit_stream;
> +			PDEBUG(D_STREAM,
> +				"Got %d bytes out of %d for frame",
> +				data_len, bytes_left);
> +			bytes_left -= data_len;
> +			if (bytes_left == 0) {
> +				packet_type = LAST_PACKET;
> +			} else {
> +				packet_type = INTER_PACKET;
> +			}
> +			frame = gspca_get_i_frame(gspca_dev);
> +			if (frame && !discarding) 
> +				gspca_frame_add(gspca_dev, packet_type,
> +						frame, buffer, data_len);
> +			else
> +				discarding = 1;
> +		}
> +	}
> +quit_stream:
> +	mutex_lock(&gspca_dev->usb_lock);
> +	if (gspca_dev->present)
> +		sq905c_command(gspca_dev, SQ905C_CLEAR,0);
> +	mutex_unlock(&gspca_dev->usb_lock);
> +	kfree(buffer);
> +}
> +
> +/* This function is called at probe time just before sd_init */
> +static int sd_config(struct gspca_dev *gspca_dev,
> +		const struct usb_device_id *id)
> +{
> +	struct cam *cam = &gspca_dev->cam;
> +	struct sd *dev = (struct sd *) gspca_dev;
> +
> +        PDEBUG(D_PROBE,
> +                "SQ9050 camera detected"
> +                " (vid/pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
> +	cam->cam_mode = sq905c_mode;
> +	cam->nmodes = 2;
> +	if (id->idProduct == 0x9050)
> +	cam->nmodes = 1;
> +	/* We don't use the buffer gspca allocates so make it small. */
> +	cam->bulk_size = 32;
> +	INIT_WORK(&dev->work_struct, sq905c_dostream);
> +	return 0;
> +}
> +
> +/* called on streamoff with alt==0 and on disconnect */
> +/* the usb_lock is held at entry - restore on exit */
> +static void sd_stop0(struct gspca_dev *gspca_dev)
> +{
> +	struct sd *dev = (struct sd *) gspca_dev;
> +
> +	/* wait for the work queue to terminate */
> +	mutex_unlock(&gspca_dev->usb_lock);
> +	/* This waits for sq905c_dostream to finish */
> +	destroy_workqueue(dev->work_thread);
> +	dev->work_thread = NULL;
> +	mutex_lock(&gspca_dev->usb_lock);
> +}
> +
> +/* this function is called at probe and resume time */
> +static int sd_init(struct gspca_dev *gspca_dev)
> +{
> +	int ret;
> +
> +	/* connect to the camera and reset it. */
> +	ret = sq905c_command(gspca_dev, SQ905C_CLEAR, 0);
> +	return ret;
> +}
> +
> +/* Set up for getting frames. */
> +static int sd_start(struct gspca_dev *gspca_dev)
> +{
> +	struct sd *dev = (struct sd *) gspca_dev;
> +	int ret;
> +
> +        dev->cap_mode = gspca_dev->cam.cam_mode;
> +        /* "Open the shutter" and set size, to start capture */
> +        switch (gspca_dev->width) {
> +        case 640:
> +                PDEBUG(D_STREAM, "Start streaming at high resolution");
> +                dev->cap_mode ++;
> +		ret = sq905c_command(gspca_dev, SQ905C_CAPTURE_HI, 
> +						SQ905C_CAPTURE_INDEX);
> +		break;
> +        default: /* 320 */
> +                PDEBUG(D_STREAM, "Start streaming at high resolution");
> +		ret = sq905c_command(gspca_dev, SQ905C_CAPTURE_MED, 
> +						SQ905C_CAPTURE_INDEX);
> +	}
> + 
> +	if (ret < 0) {
> +		PDEBUG(D_ERR, "Start streaming command failed");
> +		return ret;
> +	}
> +	/* Start the workqueue function to do the streaming */
> +	dev->work_thread = create_singlethread_workqueue(MODULE_NAME);
> +	queue_work(dev->work_thread, &dev->work_struct);
> +
> +	return 0;
> +}
> +
> +/* Table of supported USB devices */
> +static const __devinitdata struct usb_device_id device_table[] = {
> +	{USB_DEVICE(0x2770, 0x905c)},
> +	{USB_DEVICE(0x2770, 0x9050)},
> +	{USB_DEVICE(0x2770, 0x913d)}, 
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(usb, device_table);
> +
> +/* sub-driver description */
> +static const struct sd_desc sd_desc = {
> +	.name   = MODULE_NAME,
> +	.config = sd_config,
> +	.init   = sd_init,
> +	.start  = sd_start,
> +	.stop0  = sd_stop0,
> +};
> +
> +/* -- device connect -- */
> +static int sd_probe(struct usb_interface *intf,
> +		const struct usb_device_id *id)
> +{
> +	return gspca_dev_probe(intf, id,
> +			&sd_desc,
> +			sizeof(struct sd),
> +			THIS_MODULE);
> +}
> +
> +static struct usb_driver sd_driver = {
> +	.name       = MODULE_NAME,
> +	.id_table   = device_table,
> +	.probe      = sd_probe,
> +	.disconnect = gspca_disconnect,
> +#ifdef CONFIG_PM
> +	.suspend = gspca_suspend,
> +	.resume  = gspca_resume,
> +#endif
> +};
> +
> +/* -- module insert / remove -- */
> +static int __init sd_mod_init(void)
> +{
> +	int ret;
> +
> +	ret = usb_register(&sd_driver);
> +	if (ret < 0)
> +		return ret;
> +	PDEBUG(D_PROBE, "registered");
> +	return 0;
> +}
> +
> +static void __exit sd_mod_exit(void)
> +{
> +	usb_deregister(&sd_driver);
> +	PDEBUG(D_PROBE, "deregistered");
> +}
> +
> +module_init(sd_mod_init);
> +module_exit(sd_mod_exit);
> diff -uprN linuxa/include/linux/videodev2.h linuxb/include/linux/videodev2.h
> --- linuxa/include/linux/videodev2.h	2009-03-03 13:15:18.000000000 -0600
> +++ linuxb/include/linux/videodev2.h	2009-03-03 13:14:19.000000000 -0600
> @@ -345,6 +345,7 @@ struct v4l2_pix_format {
>   #define V4L2_PIX_FMT_SPCA561  v4l2_fourcc('S', '5', '6', '1') /* compressed GBRG bayer */
>   #define V4L2_PIX_FMT_PAC207   v4l2_fourcc('P', '2', '0', '7') /* compressed BGGR bayer */
>   #define V4L2_PIX_FMT_MR97310A v4l2_fourcc('M', '3', '1', '0') /* compressed BGGR bayer */
> +#define V4L2_PIX_FMT_SQ905C   v4l2_fourcc('9', '0', '5', 'C') /* compressed RGGB bayer */
>   #define V4L2_PIX_FMT_PJPG     v4l2_fourcc('P', 'J', 'P', 'G') /* Pixart 73xx JPEG */
>   #define V4L2_PIX_FMT_YVYU    v4l2_fourcc('Y', 'V', 'Y', 'U') /* 16  YVU 4:2:2     */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro

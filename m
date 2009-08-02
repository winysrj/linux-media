Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:60267 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZHBNZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2009 09:25:30 -0400
Received: by ewy10 with SMTP id 10so2478652ewy.37
        for <linux-media@vger.kernel.org>; Sun, 02 Aug 2009 06:25:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0908011635020.26881@banach.math.auburn.edu>
References: <20090418183124.1c9160e3@free.fr>
	 <alpine.LNX.2.00.0908011635020.26881@banach.math.auburn.edu>
Date: Sun, 2 Aug 2009 17:25:29 +0400
Message-ID: <208cbae30908020625x400f6b3era5095c8bfc5c736b@mail.gmail.com>
Subject: Re: [PATCH] to add support for certain Jeilin dual-mode cameras.
From: Alexey Klimov <klimov.linux@gmail.com>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Andy Walls <awalls@radix.net>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Theodore

On Sun, Aug 2, 2009 at 1:56 AM, Theodore
Kilgore<kilgota@banach.math.auburn.edu> wrote:
> Several cameras are supported here, which all share the same USB
> Vendor:Product number when started up in streaming mode. All of these
> cameras use bulk transport for streaming, and all of them produce frames in
> JPEG format.
>
> Patch follows.
>
> Signed-off-by Theodore Kilgore <kilgota@auburn.edu>
>
> ------
> diff -r d189fb4be712 linux/Documentation/video4linux/gspca.txt
> --- a/linux/Documentation/video4linux/gspca.txt Wed Jul 29 10:01:54 2009
> +0200
> +++ b/linux/Documentation/video4linux/gspca.txt Sat Aug 01 15:42:02 2009
> -0500
> @@ -239,6 +239,9 @@
>  pac7311                093a:2629       Genious iSlim 300
>  pac7311                093a:262a       Webcam 300k
>  pac7311                093a:262c       Philips SPC 230 NC
> +jeilinj                0979:0280       Cobra DMC 300
> +jeilinj                0979:0280       FlyCamOne
> +jeilinj                0979:0280       Sakar 57379
>  zc3xx          0ac8:0302       Z-star Vimicro zc0302
>  vc032x         0ac8:0321       Vimicro generic vc0321
>  vc032x         0ac8:0323       Vimicro Vc0323
> diff -r d189fb4be712 linux/drivers/media/video/gspca/Kconfig
> --- a/linux/drivers/media/video/gspca/Kconfig   Wed Jul 29 10:01:54 2009
> +0200
> +++ b/linux/drivers/media/video/gspca/Kconfig   Sat Aug 01 15:42:02 2009
> -0500
> @@ -47,6 +47,15 @@
>          To compile this driver as a module, choose M here: the
>          module will be called gspca_finepix.
>
> +config USB_GSPCA_JEILINJ
> +       tristate "Jeilin JPEG USB V4L2 driver"
> +       depends on VIDEO_V4L2 && USB_GSPCA
> +       help
> +         Say Y here if you want support for cameras based on this Jeilin
> chip.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called gspca_jeilinj.
> +
>  config USB_GSPCA_MARS
>        tristate "Mars USB Camera Driver"
>        depends on VIDEO_V4L2 && USB_GSPCA
> diff -r d189fb4be712 linux/drivers/media/video/gspca/Makefile
> --- a/linux/drivers/media/video/gspca/Makefile  Wed Jul 29 10:01:54 2009
> +0200
> +++ b/linux/drivers/media/video/gspca/Makefile  Sat Aug 01 15:42:02 2009
> -0500
> @@ -2,6 +2,7 @@
>  obj-$(CONFIG_USB_GSPCA_CONEX)    += gspca_conex.o
>  obj-$(CONFIG_USB_GSPCA_ETOMS)    += gspca_etoms.o
>  obj-$(CONFIG_USB_GSPCA_FINEPIX)  += gspca_finepix.o
> +obj-$(CONFIG_USB_GSPCA_JEILINJ)  += gspca_jeilinj.o
>  obj-$(CONFIG_USB_GSPCA_MARS)     += gspca_mars.o
>  obj-$(CONFIG_USB_GSPCA_MR97310A) += gspca_mr97310a.o
>  obj-$(CONFIG_USB_GSPCA_OV519)    += gspca_ov519.o
> @@ -30,6 +31,7 @@
>  gspca_conex-objs    := conex.o
>  gspca_etoms-objs    := etoms.o
>  gspca_finepix-objs  := finepix.o
> +gspca_jeilinj-objs  := jeilinj.o
>  gspca_mars-objs     := mars.o
>  gspca_mr97310a-objs := mr97310a.o
>  gspca_ov519-objs    := ov519.o
> diff -r d189fb4be712 linux/drivers/media/video/gspca/jeilinj.c
> --- /dev/null   Thu Jan 01 00:00:00 1970 +0000
> +++ b/linux/drivers/media/video/gspca/jeilinj.c Sat Aug 01 15:42:02 2009
> -0500
> @@ -0,0 +1,387 @@
> +/*
> + * Jeilinj subdriver
> + *
> + * Supports some Jeilin dual-mode cameras which use bulk transport and
> + * download raw JPEG data.
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
> +#define MODULE_NAME "jeilinj"
> +
> +#include <linux/workqueue.h>
> +#include "gspca.h"
> +#include "jpeg.h"
> +
> +MODULE_AUTHOR("Theodore Kilgore <kilgota@auburn.edu>");
> +MODULE_DESCRIPTION("GSPCA/JEILINJ USB Camera Driver");
> +MODULE_LICENSE("GPL");
> +
> +/* Default timeouts, in ms */
> +#define JEILINJ_CMD_TIMEOUT 500
> +#define JEILINJ_DATA_TIMEOUT 1000
> +
> +/* Maximum transfer size to use. */
> +#define JEILINJ_MAX_TRANSFER 0x200
> +
> +#define FRAME_HEADER_LEN 0x10
> +
> +/* Structure to hold all of our device specific stuff */
> +struct sd {
> +       struct gspca_dev gspca_dev;     /* !! must be the first item */
> +       const struct v4l2_pix_format *cap_mode;
> +       /* Driver stuff */
> +       struct work_struct work_struct;
> +       struct workqueue_struct *work_thread;
> +       u8 quality;                              /* image quality */
> +       u8 jpegqual;                            /* webcam quality */
> +       u8 *jpeg_hdr;
> +};
> +
> +       struct jlj_command {
> +               unsigned char instruction[2];
> +               unsigned char ack_wanted;
> +       };
> +
> +/* AFAICT these cameras will only do 320x240. */
> +static struct v4l2_pix_format jlj_mode[] = {
> +       { 320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
> +               .bytesperline = 320,
> +               .sizeimage = 320 * 240,
> +               .colorspace = V4L2_COLORSPACE_JPEG,
> +               .priv = 0}
> +};
> +
> +/*
> + * cam uses endpoint 0x03 to send commands, 0x84 for read commands,
> + * and 0x82 for bulk transfer.
> + */
> +
> +/* All commands are two bytes only */
> +static int jlj_write2(struct gspca_dev *gspca_dev, unsigned char *command)
> +{
> +       int retval;
> +
> +       memcpy(gspca_dev->usb_buf, command, 2);
> +       retval = usb_bulk_msg(gspca_dev->dev,
> +                       usb_sndbulkpipe(gspca_dev->dev, 3),
> +                       gspca_dev->usb_buf, 2, NULL, 500);
> +       if (retval < 0)
> +               PDEBUG(D_ERR, "command write [%02x] error %d",
> +                               gspca_dev->usb_buf[0], retval);
> +       return retval;
> +}
> +
> +/* Responses are one byte only */
> +static int jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
> +{
> +       int retval;
> +
> +       retval = usb_bulk_msg(gspca_dev->dev,
> +       usb_rcvbulkpipe(gspca_dev->dev, 0x84),
> +                               gspca_dev->usb_buf, 1, NULL, 500);
> +       response = gspca_dev->usb_buf[0];
> +       if (retval < 0)
> +               PDEBUG(D_ERR, "read command [%02x] error %d",
> +                               gspca_dev->usb_buf[0], retval);
> +       return retval;
> +}
> +
> +static int jlj_start(struct gspca_dev *gspca_dev)
> +{
> +       int i;
> +       int retval = -1;
> +       u8 response = 0xff;
> +       struct jlj_command start_commands[] = {
> +               {{0x71, 0x81}, 0},
> +               {{0x70, 0x05}, 0},
> +               {{0x95, 0x70}, 1},
> +               {{0x71, 0x81}, 0},
> +               {{0x70, 0x04}, 0},
> +               {{0x95, 0x70}, 1},
> +               {{0x71, 0x00}, 0},
> +               {{0x70, 0x08}, 0},
> +               {{0x95, 0x70}, 1},
> +               {{0x94, 0x02}, 0},
> +               {{0xde, 0x24}, 0},
> +               {{0x94, 0x02}, 0},
> +               {{0xdd, 0xf0}, 0},
> +               {{0x94, 0x02}, 0},
> +               {{0xe3, 0x2c}, 0},
> +               {{0x94, 0x02}, 0},
> +               {{0xe4, 0x00}, 0},
> +               {{0x94, 0x02}, 0},
> +               {{0xe5, 0x00}, 0},
> +               {{0x94, 0x02}, 0},
> +               {{0xe6, 0x2c}, 0},
> +               {{0x94, 0x03}, 0},
> +               {{0xaa, 0x00}, 0},
> +               {{0x71, 0x1e}, 0},
> +               {{0x70, 0x06}, 0},
> +               {{0x71, 0x80}, 0},
> +               {{0x70, 0x07}, 0}
> +       };
> +       for (i = 0; i < ARRAY_SIZE(start_commands); i++) {
> +               retval = jlj_write2(gspca_dev,
> start_commands[i].instruction);
> +               if (retval < 0)
> +                       return retval;
> +               if (start_commands[i].ack_wanted)
> +                       retval = jlj_read1(gspca_dev, response);
> +               if (retval < 0)
> +                       return retval;
> +       }
> +       PDEBUG(D_ERR, "jlj_start retval is %d", retval);
> +       return retval;
> +}
> +
> +static int jlj_stop(struct gspca_dev *gspca_dev)
> +{
> +       int i;
> +       int retval;
> +       struct jlj_command stop_commands[] = {
> +               {{0x71, 0x00}, 0},
> +               {{0x70, 0x09}, 0},
> +               {{0x71, 0x80}, 0},
> +               {{0x70, 0x05}, 0}
> +       };
> +       for (i = 0; i < ARRAY_SIZE(stop_commands); i++) {
> +               retval = jlj_write2(gspca_dev,
> stop_commands[i].instruction);
> +               if (retval < 0)
> +                       return retval;
> +       }
> +       return retval;
> +}
> +
> +/* This function is called as a workqueue function and runs whenever the
> camera
> + * is streaming data. Because it is a workqueue function it is allowed to
> sleep
> + * so we can use synchronous USB calls. To avoid possible collisions with
> other
> + * threads attempting to use the camera's USB interface the gspca usb_lock
> is
> + * used when performing the one USB control operation inside the workqueue,
> + * which tells the camera to close the stream. In practice the only thing
> + * which needs to be protected against is the usb_set_interface call that
> + * gspca makes during stream_off. Otherwise the camera doesn't provide any
> + * controls that the user could try to change.
> + */
> +
> +static void jlj_dostream(struct work_struct *work)
> +{
> +       struct sd *dev = container_of(work, struct sd, work_struct);
> +       struct gspca_dev *gspca_dev = &dev->gspca_dev;
> +       struct gspca_frame *frame;
> +       int blocks_left; /* 0x200-sized blocks remaining in current frame.
> */
> +       int size_in_blocks;
> +       int act_len;
> +       int discarding = 0; /* true if we failed to get space for frame. */
> +       int packet_type;
> +       int ret;
> +       u8 *buffer;
> +
> +       buffer = kmalloc(JEILINJ_MAX_TRANSFER, GFP_KERNEL | GFP_DMA);
> +       if (!buffer) {
> +               PDEBUG(D_ERR, "Couldn't allocate USB buffer");
> +               goto quit_stream;
> +       }

This clean up on error path looks bad. On quit_stream you have:

> +quit_stream:
> +       mutex_lock(&gspca_dev->usb_lock);
> +       if (gspca_dev->present)
> +               jlj_stop(gspca_dev);
> +       mutex_unlock(&gspca_dev->usb_lock);
> +       kfree(buffer);

kfree() tries to free null buffer after kmalloc for buffer failed.
Please, check if i'm not wrong.


-- 
Best regards, Klimov Alexey

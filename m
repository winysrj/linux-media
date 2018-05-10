Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:38512 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965017AbeEJQc4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 May 2018 12:32:56 -0400
Received: by mail-pl0-f66.google.com with SMTP id c11-v6so1605700plr.5
        for <linux-media@vger.kernel.org>; Thu, 10 May 2018 09:32:56 -0700 (PDT)
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>
References: <m37eobudmo.fsf@t19.piap.pl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
Date: Thu, 10 May 2018 09:32:51 -0700
MIME-Version: 1.0
In-Reply-To: <m37eobudmo.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Krzysztof,


On 05/10/2018 01:19 AM, Krzysztof Hałasa wrote:
> Hi,
>
> I'm using analog PAL video in on GW53xx/54xx boards (through ADV7180
> chip and 8-bit parallel CSI input, with (presumably) BT.656).
> I'm trying to upgrade from e.g. Linux 4.2 + Steve's older MX6 camera
> driver (which works fine) to v.4.16 with the recently merged driver.
>
> media-ctl -r -l '"adv7180 2-0020":0->"ipu2_csi1_mux":1[1],
>                   "ipu2_csi1_mux":2->"ipu2_csi1":0[1],
>                   "ipu2_csi1":2->"ipu2_csi1 capture":0[1]'
>
> media-ctl -V '"adv7180 2-0020":0[fmt:UYVY2X8 720x576 field:interlaced]'
> media-ctl -V '"ipu2_csi1_mux":1[fmt:UYVY2X8 720x576 field:interlaced]'
> media-ctl -V '"ipu2_csi1_mux":2[fmt:UYVY2X8 720x576 field:interlaced]'
>
> It seems there are issues, though:
>
> First, I can't find a way to change to PAL standard. *s_std() doesn't
> propagate from "ipu2_csi1 capture" through "ipu2_csi1_mux" to adv7180.

Right. That's a current drawback, other mc drivers have this issue
too. One option, besides changing the default below, is to make
VIDIOC_QUERYSTD, VIDIOC_G_STD, and VIDIOC_S_STD ioctls
available for use via v4l2 subdevice node, as in:

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c 
b/drivers/media/v4l2-core/v4l2-subdev.c
index 43fefa7..fedc347 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -195,6 +195,15 @@ static long subdev_do_ioctl(struct file *file, 
unsigned int cmd, void *arg)
      case VIDIOC_QUERYMENU:
          return v4l2_querymenu(vfh->ctrl_handler, arg);

+    case VIDIOC_QUERYSTD:
+        return v4l2_subdev_call(sd, video, querystd, arg);
+
+    case VIDIOC_G_STD:
+        return v4l2_subdev_call(sd, video, g_std, arg);
+
+    case VIDIOC_S_STD:
+        return v4l2_subdev_call(sd, video, s_std, *(v4l2_std_id *)arg);
+
      case VIDIOC_G_CTRL:
          return v4l2_g_ctrl(vfh->ctrl_handler, arg);


>
> For now I have just changed the default:
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -1320,7 +1321,7 @@ static int adv7180_probe(struct i2c_client *client,
>   
>       state->irq = client->irq;
>       mutex_init(&state->mutex);
> -    state->curr_norm = V4L2_STD_NTSC;
> +    state->curr_norm = V4L2_STD_PAL;
>       if (state->chip_info->flags & ADV7180_FLAG_RESET_POWERED)
>           state->powered = true;
>       else
>
>
> Second, the image format information I'm getting out of "ipu2_csi1
> capture" device is:
>
> open("/dev/video6")
> ioctl(VIDIOC_S_FMT, {V4L2_BUF_TYPE_VIDEO_CAPTURE,
> 	fmt.pix={704x576, pixelformat=NV12, V4L2_FIELD_INTERLACED} =>
> 	fmt.pix={720x576, pixelformat=NV12, V4L2_FIELD_INTERLACED,
>          bytesperline=720, sizeimage=622080,
> 	colorspace=V4L2_COLORSPACE_SMPTE170M}})
>
> Now, the resulting image obtained via QBUF/DQBUF doesn't seem to be
> a single interlaced frame (like it was with older drivers). Actually,
> I'm getting the two fields, encoded with NV12 and concatenated
> together (I think it's V4L2_FIELD_SEQ_TB or V4L2_FIELD_SEQ_BT).
>
> What's wrong?

Set field type at /dev/video6 to NONE. That will enable IDMAC
interweaving of the top and bottom fields.

Steve

> Is it possible to get a real V4L2_FIELD_INTERLACED frame, so it can be
> passed straight to the CODA H.264 encoder?

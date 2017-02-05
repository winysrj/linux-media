Return-path: <linux-media-owner@vger.kernel.org>
Received: from b-painless.mh.aa.net.uk ([81.187.30.52]:42712 "EHLO
        b-painless.mh.aa.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751939AbdBEWdc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2017 17:33:32 -0500
Subject: Re: [PATCH 1/6] staging: Import the BCM2835 MMAL-based V4L2 camera
 driver.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Eric Anholt <eric@anholt.net>
References: <20170127215503.13208-1-eric@anholt.net>
 <20170127215503.13208-2-eric@anholt.net> <20170203165909.65aa0e35@vento.lan>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
From: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Message-ID: <f68d1a05-60e2-48eb-52c1-401cfeccd45e@destevenson.freeserve.co.uk>
Date: Sun, 5 Feb 2017 22:15:21 +0000
MIME-Version: 1.0
In-Reply-To: <20170203165909.65aa0e35@vento.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro.

I'm going to stick my head above the parapet as one of the original 
authors back when I worked at Broadcom.
As it happens I started working at Raspberry Pi last Monday, so that 
puts me in a place where I can work on this again a bit more. (The last 
two years have been just a spare time support role).
Whilst I have done kernel development work in various roles, it's all 
been downstream so I've not been that active on these lists before.

All formatting/checkpatch comments noted.
Checkpatch was whinging when this was first written around December 2013 
about long lines, so many got broken up to shut it up. Views on code 
style and checkpatch seem to have changed a little since then.
I thought we had made checkpatch happy before the driver was pushed, but 
with some of the comments still having // style I guess some slipped 
through the net.
Yes chunks of this could do with refactoring to reduce the levels of 
indentation - always more to do.
If I've removed any formatting/style type comments in my cuts it's not 
because I'm ignoring them, just that they're not something that needs 
discussion (just fixing). I've only taken out the really big lumps of 
code with no comments on.

Newbie question: if this has already been merged to staging, where am I 
looking for the relevant tree to add patches on top of? 
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git branch 
staging-next?

Responses to the rest inline.
TL;DR answer is that you are seeing the top edge of a full ISP 
processing pipe and optional encoders running on the GPU, mainly as 
there are blocks that can't be exposed for IP reasons (Raspberry Pi only 
being the customer not silicon vendor constrains what can and can't be 
made public).
That doesn't seem to fit very well into V4L2 which expects that it can 
see all the detail, so there are a few nasty spots to shoe-horn it in. 
If there are better ways to solve the problems, then I'm open to them.

Thanks
   Dave


On 03/02/17 18:59, Mauro Carvalho Chehab wrote:
> HI Eric,
>
> Em Fri, 27 Jan 2017 13:54:58 -0800
> Eric Anholt <eric@anholt.net> escreveu:
>
>> - Supports raw YUV capture, preview, JPEG and H264.
>> - Uses videobuf2 for data transfer, using dma_buf.
>> - Uses 3.6.10 timestamping
>> - Camera power based on use
>> - Uses immutable input mode on video encoder
>>
>> This code comes from the Raspberry Pi kernel tree (rpi-4.9.y) as of
>> a15ba877dab4e61ea3fc7b006e2a73828b083c52.
>
> First of all, thanks for that! Having an upstream driver for the
> RPi camera is something that has been long waited!
>
> Greg was kick on merging it on staging ;) Anyway, the real review
> will happen when the driver becomes ready to be promoted out of
> staging. When you address the existing issues and get it ready to
> merge, please send the patch with such changes to linux-media ML.
> I'll do a full review on it by then.

Is that even likely given the dependence on VCHI? I wasn't expecting 
VCHI to leave staging, which would force this to remain too.

> Still, let me do a quick review on this driver, specially at the
> non-MMAL code.
>
>>
>> Signed-off-by: Eric Anholt <eric@anholt.net>
>> ---
>>  .../media/platform/bcm2835/bcm2835-camera.c        | 2016 ++++++++++++++++++++
>>  .../media/platform/bcm2835/bcm2835-camera.h        |  145 ++
>>  drivers/staging/media/platform/bcm2835/controls.c  | 1345 +++++++++++++
>>  .../staging/media/platform/bcm2835/mmal-common.h   |   53 +
>>  .../media/platform/bcm2835/mmal-encodings.h        |  127 ++
>>  .../media/platform/bcm2835/mmal-msg-common.h       |   50 +
>>  .../media/platform/bcm2835/mmal-msg-format.h       |   81 +
>>  .../staging/media/platform/bcm2835/mmal-msg-port.h |  107 ++
>>  drivers/staging/media/platform/bcm2835/mmal-msg.h  |  404 ++++
>>  .../media/platform/bcm2835/mmal-parameters.h       |  689 +++++++
>>  .../staging/media/platform/bcm2835/mmal-vchiq.c    | 1916 +++++++++++++++++++
>>  .../staging/media/platform/bcm2835/mmal-vchiq.h    |  178 ++
>>  12 files changed, 7111 insertions(+)
>>  create mode 100644 drivers/staging/media/platform/bcm2835/bcm2835-camera.c
>>  create mode 100644 drivers/staging/media/platform/bcm2835/bcm2835-camera.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/controls.c
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-common.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-encodings.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-common.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-format.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-port.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-parameters.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-vchiq.c
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-vchiq.h
>>
>> diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
>> new file mode 100644
>> index 000000000000..4f03949aecf3
>> --- /dev/null
>> +++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
>> @@ -0,0 +1,2016 @@
>> +/*
>> + * Broadcom BM2835 V4L2 driver
>> + *
>> + * Copyright © 2013 Raspberry Pi (Trading) Ltd.
>> + *
>> + * This file is subject to the terms and conditions of the GNU General Public
>> + * License.  See the file COPYING in the main directory of this archive
>> + * for more details.
>> + *
>> + * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
>> + *          Dave Stevenson <dsteve@broadcom.com>
>> + *          Simon Mellor <simellor@broadcom.com>
>> + *          Luke Diamand <luked@broadcom.com>

All of these are now dead email addresses.
Mine could be updated to dave.stevenson@raspberrypi.org, but the others 
should probably be deleted.

>> + */
>> +
>> +#include <linux/errno.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <media/videobuf2-vmalloc.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-fh.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-common.h>
>> +#include <linux/delay.h>
>> +
>> +#include "mmal-common.h"
>> +#include "mmal-encodings.h"
>> +#include "mmal-vchiq.h"
>> +#include "mmal-msg.h"
>> +#include "mmal-parameters.h"
>> +#include "bcm2835-camera.h"
>> +
>> +#define BM2835_MMAL_VERSION "0.0.2"
>> +#define BM2835_MMAL_MODULE_NAME "bcm2835-v4l2"
>> +#define MIN_WIDTH 32
>> +#define MIN_HEIGHT 32
>> +#define MIN_BUFFER_SIZE (80*1024)
>> +
>> +#define MAX_VIDEO_MODE_WIDTH 1280
>> +#define MAX_VIDEO_MODE_HEIGHT 720
>
> Hmm... Doesn't the max resolution depend on the sensor?
>
>> +
>> +#define MAX_BCM2835_CAMERAS 2
>> +
>> +MODULE_DESCRIPTION("Broadcom 2835 MMAL video capture");
>> +MODULE_AUTHOR("Vincent Sanders");
>> +MODULE_LICENSE("GPL");
>> +MODULE_VERSION(BM2835_MMAL_VERSION);
>> +
>> +int bcm2835_v4l2_debug;
>> +module_param_named(debug, bcm2835_v4l2_debug, int, 0644);
>> +MODULE_PARM_DESC(bcm2835_v4l2_debug, "Debug level 0-2");
>> +
>> +#define UNSET (-1)
>> +static int video_nr[] = {[0 ... (MAX_BCM2835_CAMERAS - 1)] = UNSET };
>> +module_param_array(video_nr, int, NULL, 0644);
>> +MODULE_PARM_DESC(video_nr, "videoX start numbers, -1 is autodetect");
>> +
>> +static int max_video_width = MAX_VIDEO_MODE_WIDTH;
>> +static int max_video_height = MAX_VIDEO_MODE_HEIGHT;
>> +module_param(max_video_width, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
>> +MODULE_PARM_DESC(max_video_width, "Threshold for video mode");
>> +module_param(max_video_height, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
>> +MODULE_PARM_DESC(max_video_height, "Threshold for video mode");
>
> That seems a terrible hack! let the user specify the resolution via
> modprobe parameter... That should depend on the hardware capabilities
> instead.

This is sitting on top of an OpenMaxIL style camera component (though 
accessed via MMAL - long story, but basically MMAL removed a bundle of 
the ugly/annoying parts of IL).
It has the extension above V1.1.2 that you have a preview port, video 
capture port, and stills capture port. Stills captures have additional 
processing stages to improve image quality, whilst video has to maintain 
framerate.

If you're asked for YUV or RGB frame, how do you choose between video or 
stills? That's what is being set with these parameters, not the sensor 
resolution. Having independent stills and video processing options 
doesn't appear to be something that is supported in V4L2, but I'm open 
to suggestions.
There were thoughts that they could be exposed as different /dev/videoN 
devices, but that then poses a quandry to the client app as to which 
node to open, so complicates the client significantly. On the plus side 
it would then allow for things like zero shutter lag captures, and 
stills during video, where you want multiple streams (apparently) 
simultaneously, but is that worth the complexity? The general view was no.

>> +
>> +/* Gstreamer bug https://bugzilla.gnome.org/show_bug.cgi?id=726521
>> + * v4l2src does bad (and actually wrong) things when the vidioc_enum_framesizes
>> + * function says type V4L2_FRMSIZE_TYPE_STEPWISE, which we do by default.
>> + * It's happier if we just don't say anything at all, when it then
>> + * sets up a load of defaults that it thinks might work.
>> + * If gst_v4l2src_is_broken is non-zero, then we remove the function from
>> + * our function table list (actually switch to an alternate set, but same
>> + * result).
>> + */
>> +static int gst_v4l2src_is_broken;
>> +module_param(gst_v4l2src_is_broken, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
>> +MODULE_PARM_DESC(gst_v4l2src_is_broken, "If non-zero, enable workaround for Gstreamer");
>
> Not sure if I liked this hack here. AFAIKT, GStreamer fixed the bug with
> V4L2_FRMSIZE_TYPE_STEPWISE already.

I will double check on Monday. The main Raspberry Pi distribution is 
based on Debian, so packages can be quite out of date. This bug 
certainly affected Wheezy, but I don't know for certain about Jessie. 
Sid still hasn't been adopted.

Also be aware that exactly the same issue of not supporting 
V4L2_FRMSIZE_TYPE_STEPWISE affects Chromium for WebRTC, and they seem 
not to be too bothered about fixing it - 
https://bugs.chromium.org/p/chromium/issues/detail?id=249953
Now admittedly it's not the kernel's responsibility to work around 
application issues, but if it hobbles a board then that is an issue.

>> +
>> +/* global device data array */
>> +static struct bm2835_mmal_dev *gdev[MAX_BCM2835_CAMERAS];
>> +
>> +#define FPS_MIN 1
>> +#define FPS_MAX 90
>> +
>> +/* timeperframe: min/max and default */
>> +static const struct v4l2_fract
>> +	tpf_min     = {.numerator = 1,		.denominator = FPS_MAX},
>> +	tpf_max     = {.numerator = 1,	        .denominator = FPS_MIN},
>> +	tpf_default = {.numerator = 1000,	.denominator = 30000};
>> +
>> +/* video formats */
>> +static struct mmal_fmt formats[] = {
>> +	{
>> +	 .name = "4:2:0, planar, YUV",
>> +	 .fourcc = V4L2_PIX_FMT_YUV420,
>> +	 .flags = 0,
>> +	 .mmal = MMAL_ENCODING_I420,
>> +	 .depth = 12,
>> +	 .mmal_component = MMAL_COMPONENT_CAMERA,
>> +	 .ybbp = 1,
>
> Alignment here should be two tabs, instead.
>
>> +	 },
>> +	{
>
> I prefer if you use, instead:
>
> 	}, {
>
>> +	 .name = "4:2:2, packed, YUYV",
>> +	 .fourcc = V4L2_PIX_FMT_YUYV,
>> +	 .flags = 0,
>> +	 .mmal = MMAL_ENCODING_YUYV,
>> +	 .depth = 16,
>> +	 .mmal_component = MMAL_COMPONENT_CAMERA,
>> +	 .ybbp = 2,
>> +	 },
>> +	{
>> +	 .name = "RGB24 (LE)",
>> +	 .fourcc = V4L2_PIX_FMT_RGB24,
>> +	 .flags = 0,
>> +	 .mmal = MMAL_ENCODING_RGB24,
>> +	 .depth = 24,
>> +	 .mmal_component = MMAL_COMPONENT_CAMERA,
>> +	 .ybbp = 3,
>> +	 },
>> +	{
>> +	 .name = "JPEG",
>> +	 .fourcc = V4L2_PIX_FMT_JPEG,
>> +	 .flags = V4L2_FMT_FLAG_COMPRESSED,
>> +	 .mmal = MMAL_ENCODING_JPEG,
>> +	 .depth = 8,
>> +	 .mmal_component = MMAL_COMPONENT_IMAGE_ENCODE,
>> +	 .ybbp = 0,
>> +	 },
>> +	{
>> +	 .name = "H264",
>> +	 .fourcc = V4L2_PIX_FMT_H264,
>> +	 .flags = V4L2_FMT_FLAG_COMPRESSED,
>> +	 .mmal = MMAL_ENCODING_H264,
>> +	 .depth = 8,
>> +	 .mmal_component = MMAL_COMPONENT_VIDEO_ENCODE,
>> +	 .ybbp = 0,
>> +	 },
>> +	{
>> +	 .name = "MJPEG",
>> +	 .fourcc = V4L2_PIX_FMT_MJPEG,
>> +	 .flags = V4L2_FMT_FLAG_COMPRESSED,
>> +	 .mmal = MMAL_ENCODING_MJPEG,
>> +	 .depth = 8,
>> +	 .mmal_component = MMAL_COMPONENT_VIDEO_ENCODE,
>> +	 .ybbp = 0,
>> +	 },
>> +	{
>> +	 .name = "4:2:2, packed, YVYU",
>> +	 .fourcc = V4L2_PIX_FMT_YVYU,
>> +	 .flags = 0,
>> +	 .mmal = MMAL_ENCODING_YVYU,
>> +	 .depth = 16,
>> +	 .mmal_component = MMAL_COMPONENT_CAMERA,
>> +	 .ybbp = 2,
>> +	 },
>> +	{
>> +	 .name = "4:2:2, packed, VYUY",
>> +	 .fourcc = V4L2_PIX_FMT_VYUY,
>> +	 .flags = 0,
>> +	 .mmal = MMAL_ENCODING_VYUY,
>> +	 .depth = 16,
>> +	 .mmal_component = MMAL_COMPONENT_CAMERA,
>> +	 .ybbp = 2,
>> +	 },
>> +	{
>> +	 .name = "4:2:2, packed, UYVY",
>> +	 .fourcc = V4L2_PIX_FMT_UYVY,
>> +	 .flags = 0,
>> +	 .mmal = MMAL_ENCODING_UYVY,
>> +	 .depth = 16,
>> +	 .mmal_component = MMAL_COMPONENT_CAMERA,
>> +	 .ybbp = 2,
>> +	 },
>> +	{
>> +	 .name = "4:2:0, planar, NV12",
>> +	 .fourcc = V4L2_PIX_FMT_NV12,
>> +	 .flags = 0,
>> +	 .mmal = MMAL_ENCODING_NV12,
>> +	 .depth = 12,
>> +	 .mmal_component = MMAL_COMPONENT_CAMERA,
>> +	 .ybbp = 1,
>> +	 },
>> +	{
>> +	 .name = "RGB24 (BE)",
>> +	 .fourcc = V4L2_PIX_FMT_BGR24,
>> +	 .flags = 0,
>> +	 .mmal = MMAL_ENCODING_BGR24,
>> +	 .depth = 24,
>> +	 .mmal_component = MMAL_COMPONENT_CAMERA,
>> +	 .ybbp = 3,
>> +	 },
>> +	{
>> +	 .name = "4:2:0, planar, YVU",
>> +	 .fourcc = V4L2_PIX_FMT_YVU420,
>> +	 .flags = 0,
>> +	 .mmal = MMAL_ENCODING_YV12,
>> +	 .depth = 12,
>> +	 .mmal_component = MMAL_COMPONENT_CAMERA,
>> +	 .ybbp = 1,
>> +	 },
>> +	{
>> +	 .name = "4:2:0, planar, NV21",
>> +	 .fourcc = V4L2_PIX_FMT_NV21,
>> +	 .flags = 0,
>> +	 .mmal = MMAL_ENCODING_NV21,
>> +	 .depth = 12,
>> +	 .mmal_component = MMAL_COMPONENT_CAMERA,
>> +	 .ybbp = 1,
>> +	 },
>> +	{
>> +	 .name = "RGB32 (BE)",
>> +	 .fourcc = V4L2_PIX_FMT_BGR32,
>> +	 .flags = 0,
>> +	 .mmal = MMAL_ENCODING_BGRA,
>> +	 .depth = 32,
>> +	 .mmal_component = MMAL_COMPONENT_CAMERA,
>> +	 .ybbp = 4,
>> +	 },
>> +};
>> +
>> +static struct mmal_fmt *get_format(struct v4l2_format *f)
>> +{
>> +	struct mmal_fmt *fmt;
>> +	unsigned int k;
>> +
>> +	for (k = 0; k < ARRAY_SIZE(formats); k++) {
>> +		fmt = &formats[k];
>> +		if (fmt->fourcc == f->fmt.pix.pixelformat)
>> +			break;
>> +	}
>> +
>> +	if (k == ARRAY_SIZE(formats))
>> +		return NULL;
>
> Again, doesn't the formats depend on the camera sensor module?

Not in this case.
You're at the end of a full ISP processing pipe, and there is the option 
for including either JPEG, MJPEG, or H264 encoding on the end. It is 
supported to ask the camera component which formats it supports, but 
you'll still need a conversion table from those MMAL types to V4L2 
enums, and options for adding the encoded formats.

>> +
>> +	return &formats[k];
>> +}
>> +
>> +/* ------------------------------------------------------------------
>> +	Videobuf queue operations
>> +   ------------------------------------------------------------------*/
>> +
>> +static int queue_setup(struct vb2_queue *vq,
>> +		       unsigned int *nbuffers, unsigned int *nplanes,
>> +		       unsigned int sizes[], struct device *alloc_ctxs[])
>> +{
>> +	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
>> +	unsigned long size;
>> +
>> +	/* refuse queue setup if port is not configured */
>> +	if (dev->capture.port == NULL) {
>> +		v4l2_err(&dev->v4l2_dev,
>> +			 "%s: capture port not configured\n", __func__);
>> +		return -EINVAL;
>> +	}
>> +
>> +	size = dev->capture.port->current_buffer.size;
>> +	if (size == 0) {
>> +		v4l2_err(&dev->v4l2_dev,
>> +			 "%s: capture port buffer size is zero\n", __func__);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (*nbuffers < (dev->capture.port->current_buffer.num + 2))
>> +		*nbuffers = (dev->capture.port->current_buffer.num + 2);
>> +
>> +	*nplanes = 1;
>> +
>> +	sizes[0] = size;
>> +
>> +	/*
>> +	 * videobuf2-vmalloc allocator is context-less so no need to set
>> +	 * alloc_ctxs array.
>> +	 */
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "%s: dev:%p\n",
>> +		 __func__, dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static int buffer_prepare(struct vb2_buffer *vb)
>> +{
>> +	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
>> +	unsigned long size;
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "%s: dev:%p\n",
>> +		 __func__, dev);
>> +
>> +	BUG_ON(dev->capture.port == NULL);
>> +	BUG_ON(dev->capture.fmt == NULL);
>
> Please don't use BUG()/BUG_ON(), except if the driver would be doing
> something wrong enough to justify crashing the Kernel. That's not
> the case here. Instead, returning -ENODEV should be enough.
>
>> +
>> +	size = dev->capture.stride * dev->capture.height;
>> +	if (vb2_plane_size(vb, 0) < size) {
>> +		v4l2_err(&dev->v4l2_dev,
>> +			 "%s data will not fit into plane (%lu < %lu)\n",
>> +			 __func__, vb2_plane_size(vb, 0), size);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static inline bool is_capturing(struct bm2835_mmal_dev *dev)
>> +{
>> +	return dev->capture.camera_port ==
>> +	    &dev->
>> +	    component[MMAL_COMPONENT_CAMERA]->output[MMAL_CAMERA_PORT_CAPTURE];
>
> Weird indentation. Just merge everything on a single line.
>
>
>> +}
>> +
>> +static void buffer_cb(struct vchiq_mmal_instance *instance,
>> +		      struct vchiq_mmal_port *port,
>> +		      int status,
>> +		      struct mmal_buffer *buf,
>> +		      unsigned long length, u32 mmal_flags, s64 dts, s64 pts)
>> +{
>> +	struct bm2835_mmal_dev *dev = port->cb_ctx;
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +		 "%s: status:%d, buf:%p, length:%lu, flags %u, pts %lld\n",
>> +		 __func__, status, buf, length, mmal_flags, pts);
>> +
>> +	if (status != 0) {
>> +		/* error in transfer */
>> +		if (buf != NULL) {
>> +			/* there was a buffer with the error so return it */
>> +			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
>> +		}
>> +		return;
>> +	} else if (length == 0) {
>
> Doesn't need an else above. That would remove one indentation level,
> with is a good thing.
>
>> +		/* stream ended */
>> +		if (buf != NULL) {
>> +			/* this should only ever happen if the port is
>> +			 * disabled and there are buffers still queued
>> +			 */
>> +			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
>> +			pr_debug("Empty buffer");
>> +		} else if (dev->capture.frame_count) {
>> +			/* grab another frame */
>> +			if (is_capturing(dev)) {
>> +				pr_debug("Grab another frame");
>> +				vchiq_mmal_port_parameter_set(
>> +					instance,
>> +					dev->capture.
>> +					camera_port,
>> +					MMAL_PARAMETER_CAPTURE,
>> +					&dev->capture.
>> +					frame_count,
>> +					sizeof(dev->capture.frame_count));
>> +			}
>> +		} else {
>> +			/* signal frame completion */
>> +			complete(&dev->capture.frame_cmplt);
>> +		}
>
> Better to add a return here and avoid the else below. That makes it
> more readable, and avoid weird line breakages due to 80 column
> soft-limit.
>
>> +	} else {
>> +		if (dev->capture.frame_count) {
>> +			if (dev->capture.vc_start_timestamp != -1 &&
>> +			    pts != 0) {
>> +				struct timeval timestamp;
>> +				s64 runtime_us = pts -
>> +				    dev->capture.vc_start_timestamp;
>
> Please either put the statement on a single line or indent the second
> like with the argument after the equal operator.
>
>> +				u32 div = 0;
>> +				u32 rem = 0;
>> +
>> +				div =
>> +				    div_u64_rem(runtime_us, USEC_PER_SEC, &rem);
>> +				timestamp.tv_sec =
>> +				    dev->capture.kernel_start_ts.tv_sec + div;
>> +				timestamp.tv_usec =
>> +				    dev->capture.kernel_start_ts.tv_usec + rem;
>
> Please don't break the lines.
>> +
>> +				if (timestamp.tv_usec >=
>> +				    USEC_PER_SEC) {
>
> I suspect you could put it on a single line.
>
>> +					timestamp.tv_sec++;
>> +					timestamp.tv_usec -=
>> +					    USEC_PER_SEC;
>> +				}
>> +				v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +					 "Convert start time %d.%06d and %llu "
>> +					 "with offset %llu to %d.%06d\n",
>
> Don't break strings on multiple lines.
>
>> +					 (int)dev->capture.kernel_start_ts.
>> +					 tv_sec,
>> +					 (int)dev->capture.kernel_start_ts.
>> +					 tv_usec,
>> +					 dev->capture.vc_start_timestamp, pts,
>> +					 (int)timestamp.tv_sec,
>> +					 (int)timestamp.tv_usec);
>> +				buf->vb.vb2_buf.timestamp = timestamp.tv_sec * 1000000000ULL +
>> +					timestamp.tv_usec * 1000ULL;
>
> Not sure if I understood the above logic... Why don't you just do
> 	buf->vb.vb2_buf.timestamp = ktime_get_ns();

What's the processing latency through the ISP and optional 
H264/MJPG/JPEG encode to get to this point? Typically you're looking at 
30-80ms depending on exposure time and various other factors, which 
would be enough to put A/V sync out if not compensated for.

The GPU side is timestamping all buffers with the CSI frame start 
interrupt timestamp, but based on the GPU STC. There is a MMAL call to 
read the GPU STC which is made at streamon (stored in 
dev->capture.vc_start_timestamp), and therefore this is taking a delta 
from there to get a more accurate timestamp.
(An improvement would be to reread it every N seconds to ensure there 
was no drift, but the Linux kernel tick is actually off the same clock, 
so it is only clock corrections that would introduce a drift).
As I understand it UVC is doing a similar thing, although it is trying 
to compensate for clock drift too.

Now one could argue that ideally you want the timestamp for the start of 
exposure, but there is no event outside of the sensor to trigger that. 
You could compute it, but the exposure time control loop is running on 
the GPU so the kernel doesn't know the exposure time. It's also a bit of 
a funny thing anyway when dealing with rolling shutter sensors and 
therefore considering which line you want the start of exposure for.

>
>> +			} else {
>> +				buf->vb.vb2_buf.timestamp = ktime_get_ns();
>> +			}
>> +
>> +			vb2_set_plane_payload(&buf->vb.vb2_buf, 0, length);
>> +			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
>> +
>> +			if (mmal_flags & MMAL_BUFFER_HEADER_FLAG_EOS &&
>> +			    is_capturing(dev)) {
>> +				v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +					 "Grab another frame as buffer has EOS");
>> +				vchiq_mmal_port_parameter_set(
>> +					instance,
>> +					dev->capture.
>> +					camera_port,
>> +					MMAL_PARAMETER_CAPTURE,
>> +					&dev->capture.
>> +					frame_count,
>> +					sizeof(dev->capture.frame_count));
>> +			}
>> +		} else {
>> +			/* signal frame completion */
>> +			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
>> +			complete(&dev->capture.frame_cmplt);
>
> I would move the error condition to happen before and just return,
> in order to reduce the indentation.
>
>> +		}
>> +	}
>> +}
>> +

<snip>

>> +static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
>> +				   struct v4l2_fmtdesc *f)
>> +{
>> +	struct mmal_fmt *fmt;
>> +
>> +	if (f->index >= ARRAY_SIZE(formats))
>> +		return -EINVAL;
>> +
>> +	fmt = &formats[f->index];
>
> Shouldn't this be checking if the sensor is the Sony one or the Omnivision?
>
> Same applies to g_fmt and s_fmt.

Not when the ISP is in the way. This is effectively the list of output 
formats from the ISP (and optional encoders), not the sensor.

>> +
>> +	strlcpy(f->description, fmt->name, sizeof(f->description));
>> +	f->pixelformat = fmt->fourcc;
>> +	f->flags = fmt->flags;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>> +				struct v4l2_format *f)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +
>> +	f->fmt.pix.width = dev->capture.width;
>> +	f->fmt.pix.height = dev->capture.height;
>> +	f->fmt.pix.field = V4L2_FIELD_NONE;
>> +	f->fmt.pix.pixelformat = dev->capture.fmt->fourcc;
>> +	f->fmt.pix.bytesperline = dev->capture.stride;
>> +	f->fmt.pix.sizeimage = dev->capture.buffersize;
>> +
>> +	if (dev->capture.fmt->fourcc == V4L2_PIX_FMT_RGB24)
>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
>> +	else if (dev->capture.fmt->fourcc == V4L2_PIX_FMT_JPEG)
>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
>> +	else
>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +	f->fmt.pix.priv = 0;
>> +
>> +	v4l2_dump_pix_format(1, bcm2835_v4l2_debug, &dev->v4l2_dev, &f->fmt.pix,
>> +			     __func__);
>> +	return 0;
>> +}
>> +
>> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>> +				  struct v4l2_format *f)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +	struct mmal_fmt *mfmt;
>> +
>> +	mfmt = get_format(f);
>> +	if (!mfmt) {
>> +		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			 "Fourcc format (0x%08x) unknown.\n",
>> +			 f->fmt.pix.pixelformat);
>> +		f->fmt.pix.pixelformat = formats[0].fourcc;
>> +		mfmt = get_format(f);
>> +	}
>> +
>> +	f->fmt.pix.field = V4L2_FIELD_NONE;
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +		"Clipping/aligning %dx%d format %08X\n",
>> +		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.pixelformat);
>> +
>> +	v4l_bound_align_image(&f->fmt.pix.width, MIN_WIDTH, dev->max_width, 1,
>> +			      &f->fmt.pix.height, MIN_HEIGHT, dev->max_height,
>> +			      1, 0);
>
> Hmm... that looks weird... For YUY formats, the step is usually 2 or 4.
> Also, as most cameras use internally a bayer sensor, they don't allow
> aligning to 1, except when then have scallers.

Correct. It should be multiples of 2 in either direction.

>> +	f->fmt.pix.bytesperline = f->fmt.pix.width * mfmt->ybbp;
>> +
>> +	/* Image buffer has to be padded to allow for alignment, even though
>> +	 * we then remove that padding before delivering the buffer.
>> +	 */
>> +	f->fmt.pix.sizeimage = ((f->fmt.pix.height+15)&~15) *
>> +			(((f->fmt.pix.width+31)&~31) * mfmt->depth) >> 3;
>
> It seems that you're fixing the bug at the steps used by
> v4l_bound_align_image() by rounding up the buffer size. That's wrong!
> Just ensure that the width/height will be a valid resolution and
> remove this hack.

No, this is working around the fact that very few clients respect 
bytesperline (eg QV4L2 and libv4lconvert for many of the formats).

The ISP needs to be writing to buffers with the stride being a multiple 
of 32, and height a multiple of 16 (and that includes between planes of 
YUV420). V4L2 appears not to allow that, therefore there is then a 
second operation run in-place on the buffer to remove that padding, but 
the buffer needs to be sized sufficiently to handle the padded image first.
I had a conversation with Hans back in 2013 with regard this, and there 
wasn't a good solution proposed. It could potentially be specified using 
the cropping API, but that pushes the responsibility back onto every 
client app to drive things in a very specific manner. If they don't 
respect bytesperline they are even less likely to handle cropping.
You could restrict the resolution to being a multiple of 32 on the width 
and 16 on the height, but in doing so you're not exposing the full 
capabilities.

I'm open to suggestions as to how V4L2 can do this without just beating 
up client apps who do the wrong thing.

Multiplanar formats seem not to be an option as the ISP is expecting one 
contiguous buffer to be provided to take all the planes, but the 
multiplanar stuff supplies multiple independent buffers. Again please 
correct me if I'm wrong on that.

>> +
>> +	if ((mfmt->flags & V4L2_FMT_FLAG_COMPRESSED) &&
>> +	    f->fmt.pix.sizeimage < MIN_BUFFER_SIZE)
>> +		f->fmt.pix.sizeimage = MIN_BUFFER_SIZE;
>> +
>> +	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_RGB24)
>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
>> +	else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_JPEG)
>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
>> +	else
>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +	f->fmt.pix.priv = 0;
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +		"Now %dx%d format %08X\n",
>> +		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.pixelformat);
>> +
>> +	v4l2_dump_pix_format(1, bcm2835_v4l2_debug, &dev->v4l2_dev, &f->fmt.pix,
>> +			     __func__);
>> +	return 0;
>> +}
>> +
>> +static int mmal_setup_components(struct bm2835_mmal_dev *dev,
>> +				 struct v4l2_format *f)
>> +{
>> +	int ret;
>> +	struct vchiq_mmal_port *port = NULL, *camera_port = NULL;
>> +	struct vchiq_mmal_component *encode_component = NULL;
>> +	struct mmal_fmt *mfmt = get_format(f);
>> +
>> +	BUG_ON(!mfmt);
>> +
>> +	if (dev->capture.encode_component) {
>> +		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			 "vid_cap - disconnect previous tunnel\n");
>> +
>> +		/* Disconnect any previous connection */
>> +		vchiq_mmal_port_connect_tunnel(dev->instance,
>> +					       dev->capture.camera_port, NULL);
>> +		dev->capture.camera_port = NULL;
>> +		ret = vchiq_mmal_component_disable(dev->instance,
>> +						   dev->capture.
>> +						   encode_component);
>> +		if (ret)
>> +			v4l2_err(&dev->v4l2_dev,
>> +				 "Failed to disable encode component %d\n",
>> +				 ret);
>> +
>> +		dev->capture.encode_component = NULL;
>> +	}
>> +	/* format dependant port setup */
>> +	switch (mfmt->mmal_component) {
>> +	case MMAL_COMPONENT_CAMERA:
>> +		/* Make a further decision on port based on resolution */
>> +		if (f->fmt.pix.width <= max_video_width
>> +		    && f->fmt.pix.height <= max_video_height)
>> +			camera_port = port =
>> +			    &dev->component[MMAL_COMPONENT_CAMERA]->
>> +			    output[MMAL_CAMERA_PORT_VIDEO];
>> +		else
>> +			camera_port = port =
>> +			    &dev->component[MMAL_COMPONENT_CAMERA]->
>> +			    output[MMAL_CAMERA_PORT_CAPTURE];
>
> Not sure if I got this... What are you intending to do here?

As noted above, what do you consider a still when dealing with raw RGB 
or YUV buffers. This is switching between video and stills quality 
processing based on resolution.

>> +		break;
>> +	case MMAL_COMPONENT_IMAGE_ENCODE:
>> +		encode_component = dev->component[MMAL_COMPONENT_IMAGE_ENCODE];
>> +		port = &dev->component[MMAL_COMPONENT_IMAGE_ENCODE]->output[0];
>> +		camera_port =
>> +		    &dev->component[MMAL_COMPONENT_CAMERA]->
>> +		    output[MMAL_CAMERA_PORT_CAPTURE];
>> +		break;

<snip>

>> +/* timeperframe is arbitrary and continous */
>> +static int vidioc_enum_frameintervals(struct file *file, void *priv,
>> +					     struct v4l2_frmivalenum *fival)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +	int i;
>> +
>> +	if (fival->index)
>> +		return -EINVAL;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(formats); i++)
>> +		if (formats[i].fourcc == fival->pixel_format)
>> +			break;
>> +	if (i == ARRAY_SIZE(formats))
>> +		return -EINVAL;
>> +
>> +	/* regarding width & height - we support any within range */
>> +	if (fival->width < MIN_WIDTH || fival->width > dev->max_width ||
>> +	    fival->height < MIN_HEIGHT || fival->height > dev->max_height)
>> +		return -EINVAL;
>> +
>> +	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
>
> That seems wrong! Webcam sensors usually require a multiple of at least 2
> for both horizontal and vertical resolutions, due to the way the pixels
> are packaged internally.
>
> Typically, only analog TV uses V4L2_FRMIVAL_TYPE_CONTINUOUS.
>
> Ok, if you're using expensive sensors with sophisticated scalers on
> it, you could have a continuous resolution, but I doubt this is the
> case here.

Isn't this frame interval, not resolution, although yes, it ought to 
sanity check the resolution to be a multiple of 2 in each direction.

With regard frame interval, it could be specified as STEPWISE with an 
increment of 32.5usecs or 18.9usecs (the default line time for ov5647 
and imx219 respectively), but to most people that would count as continuous.

There is the added complication that the GPU code will select the most 
appropriate sensor mode (about 7 are defined) based on the frame rate 
and resolution requested, and each of the modes has different line 
times. Reading it back would be possible but just seemed excessive.


I'm curious now, how does analogue TV count as CONTINUOUS when surely it 
isn't something that can be set on a tuner that is only relaying the 
received video signal.

>> +
>> +	/* fill in stepwise (step=1.0 is requred by V4L2 spec) */
>> +	fival->stepwise.min  = tpf_min;
>> +	fival->stepwise.max  = tpf_max;
>> +	fival->stepwise.step = (struct v4l2_fract) {1, 1};
>> +
>> +	return 0;
>> +}
>> +

<snip>

>> +/* Returns the number of cameras, and also the max resolution supported
>> + * by those cameras.
>> + */
>> +static int get_num_cameras(struct vchiq_mmal_instance *instance,
>> +	unsigned int resolutions[][2], int num_resolutions)
>> +{
>> +	int ret;
>> +	struct vchiq_mmal_component  *cam_info_component;
>> +	struct mmal_parameter_camera_info_t cam_info = {0};
>> +	int param_size = sizeof(cam_info);
>> +	int i;
>> +
>> +	/* create a camera_info component */
>> +	ret = vchiq_mmal_component_init(instance, "camera_info",
>> +					&cam_info_component);
>> +	if (ret < 0)
>> +		/* Unusual failure - let's guess one camera. */
>> +		return 1;
>
> Hmm... what happens if no cameras are plugged to RPi?

More that this query wasn't available on early GPU firmware versions - 
it was added in 2016 when the IMX219 camera support was added.
If there are genuinely no cameras connected, then the camera component 
create at a later stage will fail and that it also handled.

>> +
>> +	if (vchiq_mmal_port_parameter_get(instance,
>> +					  &cam_info_component->control,
>> +					  MMAL_PARAMETER_CAMERA_INFO,
>> +					  &cam_info,
>> +					  &param_size)) {
>> +		pr_info("Failed to get camera info\n");
>> +	}
>> +	for (i = 0;
>> +	     i < (cam_info.num_cameras > num_resolutions ?
>> +			num_resolutions :
>> +			cam_info.num_cameras);
>> +	     i++) {
>> +		resolutions[i][0] = cam_info.cameras[i].max_width;
>> +		resolutions[i][1] = cam_info.cameras[i].max_height;
>> +	}
>> +
>> +	vchiq_mmal_component_finalise(instance,
>> +				      cam_info_component);
>> +
>> +	return cam_info.num_cameras;
>> +}
>> +
>> +static int set_camera_parameters(struct vchiq_mmal_instance *instance,
>> +				 struct vchiq_mmal_component *camera,
>> +				 struct bm2835_mmal_dev *dev)
>> +{
>> +	int ret;
>> +	struct mmal_parameter_camera_config cam_config = {
>> +		.max_stills_w = dev->max_width,
>> +		.max_stills_h = dev->max_height,
>> +		.stills_yuv422 = 1,
>> +		.one_shot_stills = 1,
>> +		.max_preview_video_w = (max_video_width > 1920) ?
>> +						max_video_width : 1920,
>> +		.max_preview_video_h = (max_video_height > 1088) ?
>> +						max_video_height : 1088,
>
> Hmm... why do you need to limit the max resolution to 1920x1088? Is it
> a limit of the MMAL/firmware?

Memory usage.
Video mode runs as an optimised pipeline so requires multiple frame buffers.
Stills mode typically has to stop the sensor, reprogram for full res 
mode, stream for one frame, and then stops the sensor again, therefore 
only one stills res buffer is required.
If you've specified video mode to run at more than 1080P, then the GPU 
needs to be told up front so that it can allocate the extra memory.

>> +		.num_preview_video_frames = 3,
>> +		.stills_capture_circular_buffer_height = 0,
>> +		.fast_preview_resume = 0,
>> +		.use_stc_timestamp = MMAL_PARAM_TIMESTAMP_MODE_RAW_STC
>> +	};
>> +
>> +	ret = vchiq_mmal_port_parameter_set(instance, &camera->control,
>> +					    MMAL_PARAMETER_CAMERA_CONFIG,
>> +					    &cam_config, sizeof(cam_config));
>> +	return ret;
>> +}
>> +
>> +#define MAX_SUPPORTED_ENCODINGS 20
>> +
>> +/* MMAL instance and component init */
>> +static int __init mmal_init(struct bm2835_mmal_dev *dev)
>> +{
>> +	int ret;
>> +	struct mmal_es_format *format;
>> +	u32 bool_true = 1;
>> +	u32 supported_encodings[MAX_SUPPORTED_ENCODINGS];
>> +	int param_size;
>> +	struct vchiq_mmal_component  *camera;
>> +
>> +	ret = vchiq_mmal_init(&dev->instance);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* get the camera component ready */
>> +	ret = vchiq_mmal_component_init(dev->instance, "ril.camera",
>> +					&dev->component[MMAL_COMPONENT_CAMERA]);
>> +	if (ret < 0)
>> +		goto unreg_mmal;
>> +
>> +	camera = dev->component[MMAL_COMPONENT_CAMERA];
>> +	if (camera->outputs <  MMAL_CAMERA_PORT_COUNT) {
>> +		ret = -EINVAL;
>> +		goto unreg_camera;
>> +	}
>> +
>> +	ret = set_camera_parameters(dev->instance,
>> +				    camera,
>> +				    dev);
>> +	if (ret < 0)
>> +		goto unreg_camera;
>> +
>> +	/* There was an error in the firmware that meant the camera component
>> +	 * produced BGR instead of RGB.
>> +	 * This is now fixed, but in order to support the old firmwares, we
>> +	 * have to check.
>> +	 */
>> +	dev->rgb_bgr_swapped = true;
>> +	param_size = sizeof(supported_encodings);
>> +	ret = vchiq_mmal_port_parameter_get(dev->instance,
>> +		&camera->output[MMAL_CAMERA_PORT_CAPTURE],
>> +		MMAL_PARAMETER_SUPPORTED_ENCODINGS,
>> +		&supported_encodings,
>> +		&param_size);
>> +	if (ret == 0) {
>> +		int i;
>> +
>> +		for (i = 0; i < param_size/sizeof(u32); i++) {
>> +			if (supported_encodings[i] == MMAL_ENCODING_BGR24) {
>> +				/* Found BGR24 first - old firmware. */
>> +				break;
>> +			}
>> +			if (supported_encodings[i] == MMAL_ENCODING_RGB24) {
>> +				/* Found RGB24 first
>> +				 * new firmware, so use RGB24.
>> +				 */
>> +				dev->rgb_bgr_swapped = false;
>> +			break;
>> +			}
>> +		}
>> +	}
>> +	format = &camera->output[MMAL_CAMERA_PORT_PREVIEW].format;
>> +
>> +	format->encoding = MMAL_ENCODING_OPAQUE;
>> +	format->encoding_variant = MMAL_ENCODING_I420;
>> +
>> +	format->es->video.width = 1024;
>> +	format->es->video.height = 768;
>
> Shouldn't this be checking if the hardware supports 1024x768?
> Same note for similar parameters below.

All the supported sensors can do 1024x768 JPEG. This is just setting up 
some defaults.

>> +	format->es->video.crop.x = 0;
>> +	format->es->video.crop.y = 0;
>> +	format->es->video.crop.width = 1024;
>> +	format->es->video.crop.height = 768;
>> +	format->es->video.frame_rate.num = 0; /* Rely on fps_range */
>> +	format->es->video.frame_rate.den = 1;
>> +
>> +	format = &camera->output[MMAL_CAMERA_PORT_VIDEO].format;
>> +
>> +	format->encoding = MMAL_ENCODING_OPAQUE;
>> +	format->encoding_variant = MMAL_ENCODING_I420;
>> +
>> +	format->es->video.width = 1024;
>> +	format->es->video.height = 768;
>> +	format->es->video.crop.x = 0;
>> +	format->es->video.crop.y = 0;
>> +	format->es->video.crop.width = 1024;
>> +	format->es->video.crop.height = 768;
>> +	format->es->video.frame_rate.num = 0; /* Rely on fps_range */
>> +	format->es->video.frame_rate.den = 1;
>> +
>> +	vchiq_mmal_port_parameter_set(dev->instance,
>> +		&camera->output[MMAL_CAMERA_PORT_VIDEO],
>> +		MMAL_PARAMETER_NO_IMAGE_PADDING,
>> +		&bool_true, sizeof(bool_true));
>> +
>> +	format = &camera->output[MMAL_CAMERA_PORT_CAPTURE].format;
>> +
>> +	format->encoding = MMAL_ENCODING_OPAQUE;
>> +
>> +	format->es->video.width = 2592;
>> +	format->es->video.height = 1944;
>
> Shouldn't this be checking if the hardware supports such resolution?
> Where this magic numbers came from? Why is it different than the previous
> resolution?

Video vs stills port.
TBH I'd actually want to double check whether this is necessary as I 
thought it went through the standard s_fmt path to set up the default 
mode, and that would do all this anyway.

>> +	format->es->video.crop.x = 0;
>> +	format->es->video.crop.y = 0;
>> +	format->es->video.crop.width = 2592;
>> +	format->es->video.crop.height = 1944;
>> +	format->es->video.frame_rate.num = 0; /* Rely on fps_range */
>> +	format->es->video.frame_rate.den = 1;
>> +
>> +	dev->capture.width = format->es->video.width;
>> +	dev->capture.height = format->es->video.height;
>> +	dev->capture.fmt = &formats[0];
>> +	dev->capture.encode_component = NULL;
>> +	dev->capture.timeperframe = tpf_default;
>> +	dev->capture.enc_profile = V4L2_MPEG_VIDEO_H264_PROFILE_HIGH;
>> +	dev->capture.enc_level = V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
>> +

<snip>

>> +int bm2835_mmal_set_all_camera_controls(struct bm2835_mmal_dev *dev)
>> +{
>> +	int c;
>> +	int ret = 0;
>> +
>> +	for (c = 0; c < V4L2_CTRL_COUNT; c++) {
>> +		if ((dev->ctrls[c]) && (v4l2_ctrls[c].setter)) {
>> +			ret = v4l2_ctrls[c].setter(dev, dev->ctrls[c],
>> +						   &v4l2_ctrls[c]);
>> +			if (!v4l2_ctrls[c].ignore_errors && ret) {
>> +				v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +					"Failed when setting default values for ctrl %d\n",
>> +					c);
>> +				break;
>> +			}
>> +		}
>> +	}
>
> There's something weird here... it is exposing all controls without
> checking if the hardware supports them. Does the VC4 firmware
> emulate the parameters on sensors that don't support? Otherwise,
> you'll need to query the hardware (or use DT) and only expose the controls that
> are provided by the given camera module.

You're at the end of the ISP. Everything except flips, exposure time and 
analogue gain are implemented in the ISP so therefore they are supported.
All sensors are expected to support flips, exposure time and analogue 
gain correctly (otherwise I complain to whoever wrote the camera driver!).

<snip>

>> +/* data in message, memcpy from packet into output buffer */
>> +static int inline_receive(struct vchiq_mmal_instance *instance,
>> +			  struct mmal_msg *msg,
>> +			  struct mmal_msg_context *msg_context)
>> +{
>> +	unsigned long flags = 0;
>> +
>> +	/* take buffer from queue */
>> +	spin_lock_irqsave(&msg_context->u.bulk.port->slock, flags);
>> +	if (list_empty(&msg_context->u.bulk.port->buffers)) {
>> +		spin_unlock_irqrestore(&msg_context->u.bulk.port->slock, flags);
>> +		pr_err("buffer list empty trying to receive inline\n");
>> +
>> +		/* todo: this is a serious error, we should never have
>> +		 * commited a buffer_to_host operation to the mmal
>> +		 * port without the buffer to back it up (with
>> +		 * underflow handling) and there is no obvious way to
>> +		 * deal with this. Less bad than the bulk case as we
>> +		 * can just drop this on the floor but...unhelpful
>> +		 */
>
> If the bug is serious enough to corrupt memory, better to call BUG(),
> as otherwise it could do insane things, including corrupting a dirty
> disk cache - with could result on filesystem corruption.

I'd need to check exactly what the situation is here. It's been a while 
since I've looked at the buffer handling code, but will review and make 
it a BUG_ON if appropriate.

>> +		return -EINVAL;
>> +	}
>> +

<snip>

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56893 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KEDW7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 22:22:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 2/6] v4l: omap4iss: Add support for OMAP4 camera interface - Video devices
Date: Tue, 05 Nov 2013 04:23:27 +0100
Message-ID: <4997789.9V1yQfL8T2@avalon>
In-Reply-To: <52775C29.2000808@xs4all.nl>
References: <1380758133-16866-1-git-send-email-laurent.pinchart@ideasonboard.com> <2872887.lHyANtjq1j@avalon> <52775C29.2000808@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 04 November 2013 09:34:49 Hans Verkuil wrote:
> On 11/04/2013 12:28 AM, Laurent Pinchart wrote:
> > On Thursday 03 October 2013 08:54:19 Hans Verkuil wrote:
> >> On 10/03/2013 01:55 AM, Laurent Pinchart wrote:
> >>> From: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> >>> 
> >>> This adds a very simplistic driver to utilize the CSI2A interface inside
> >>> the ISS subsystem in OMAP4, and dump the data to memory.
> >>> 
> >>> Check Documentation/video4linux/omap4_camera.txt for details.
> >>> 
> >>> This commit adds video devices support.
> >>> 
> >>> Signed-off-by: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> >>> 
> >>> [Port the driver to v3.12-rc3, including the following changes
> >>> - Don't include plat/ headers
> >>> - Don't use cpu_is_omap44xx() macro
> >>> - Don't depend on EXPERIMENTAL
> >>> - Fix s_crop operation prototype
> >>> - Update link_notify prototype
> >>> - Rename media_entity_remote_source to media_entity_remote_pad]
> >>> 
> >>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>> ---
> >>> 
> >>>  drivers/staging/media/omap4iss/iss_video.c | 1129
> >>>  +++++++++++++++++++++++
> >>>  drivers/staging/media/omap4iss/iss_video.h |  201 +++++
> >>>  2 files changed, 1330 insertions(+)
> >>>  create mode 100644 drivers/staging/media/omap4iss/iss_video.c
> >>>  create mode 100644 drivers/staging/media/omap4iss/iss_video.h
> >>> 
> >>> diff --git a/drivers/staging/media/omap4iss/iss_video.c
> >>> b/drivers/staging/media/omap4iss/iss_video.c new file mode 100644
> >>> index 0000000..31f1b88
> >>> --- /dev/null
> >>> +++ b/drivers/staging/media/omap4iss/iss_video.c
> >> 
> >> <snip>
> >> 
> >>> +/*
> >>> ---------------------------------------------------------------------
> >>> + * V4L2 ioctls
> >>> + */
> >>> +
> >>> +static int
> >>> +iss_video_querycap(struct file *file, void *fh, struct v4l2_capability
> >>> *cap) +{
> >>> +	struct iss_video *video = video_drvdata(file);
> >>> +
> >>> +	strlcpy(cap->driver, ISS_VIDEO_DRIVER_NAME, sizeof(cap->driver));
> >>> +	strlcpy(cap->card, video->video.name, sizeof(cap->card));
> >>> +	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
> >>> +
> >>> +	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >>> +		cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> >>> +	else
> >>> +		cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> >> 
> >> Set device_caps instead of capabilities and add:
> >> 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> > 
> > Actually cap->capabilities should be V4L2_CAP_DEVICE_CAPS |
> > V4L2_CAP_STREAMING> 
> > | V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT. I'll fix that.
> 
> You're right.
> 
> >>> +
> >>> +	return 0;
> >>> +}
> > 
> > [snip]
> > 
> >>> +static int
> >>> +iss_video_try_format(struct file *file, void *fh, struct v4l2_format
> >>> *format) +{
> >>> +	struct iss_video *video = video_drvdata(file);
> >>> +	struct v4l2_subdev_format fmt;
> >>> +	struct v4l2_subdev *subdev;
> >>> +	u32 pad;
> >>> +	int ret;
> >>> +
> >>> +	if (format->type != video->type)
> >>> +		return -EINVAL;
> >>> +
> >>> +	subdev = iss_video_remote_subdev(video, &pad);
> >>> +	if (subdev == NULL)
> >>> +		return -EINVAL;
> >>> +
> >>> +	iss_video_pix_to_mbus(&format->fmt.pix, &fmt.format);
> >>> +
> >>> +	fmt.pad = pad;
> >>> +	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> >>> +	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
> >>> +	if (ret)
> >>> +		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
> >> 
> >> Return ENOTTY instead of EINVAL. Even better, use v4l2_subdev_has_op() +
> >> v4l2_disable_ioctl() to just disable ioctls based on the available subdev
> >> ops in probe().
> > 
> > The remote subdev is required to implement the get_fmt() operation,
> > otherwise the ISS driver can't work at all. What about adding a
> > v4l2_subdev_has_op() check at probe time and removing the check here ?
> 
> That would be best, yes.

It's actually even simpler than that. The remote subdev is an internal OMAP4 
ISS subdevice that is guaranteed to implement get_fmt. There's no need to 
check for ENOIOCTLCMD here, and no need to verify that the subdev implements 
get_fmt at probe time.

> >>> +
> >>> +	iss_video_mbus_to_pix(video, &fmt.format, &format->fmt.pix);
> >>> +	return 0;
> >>> +}
> > 
> > [snip]
> > 
> >>> +static int
> >>> +iss_video_enum_input(struct file *file, void *fh, struct v4l2_input
> >>> *input)
> >>> +{
> >>> +	if (input->index > 0)
> >>> +		return -EINVAL;
> >>> +
> >>> +	strlcpy(input->name, "camera", sizeof(input->name));
> >>> +	input->type = V4L2_INPUT_TYPE_CAMERA;
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static int
> >>> +iss_video_g_input(struct file *file, void *fh, unsigned int *input)
> >>> +{
> >>> +	*input = 0;
> >>> +
> >>> +	return 0;
> >>> +}
> >> 
> >> Also add s_input.
> > 
> > Shouldn't I remove enum_input and g_input instead ?
> 
> No. G/S/ENUM_INPUT ioctls are compulsory for video capture devices.
> 
> One thing I would like to do at some point in time is to add a few helper
> functions for this. A lot of camera/TV drivers have just one input, so it
> would be trivial to add helpers for that. I just never got around to that.

I thought we agreed they were not for media controller-based devices that 
implement the stripped-down streaming profile (which we don't have yet :-)) 
only ?

-- 
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39058 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2KFWWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2012 17:22:19 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so370595eaa.19
        for <linux-media@vger.kernel.org>; Tue, 06 Nov 2012 14:22:18 -0800 (PST)
Message-ID: <50998D97.3030405@gmail.com>
Date: Tue, 06 Nov 2012 23:22:15 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC] Selections targets at V4L2 video mem-to-mem interface
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I'd like to clarify the meaning of selection targets on a mem-to-mem video
device, in order to document it and to make sure new m2m drivers get it
right, and also that the existing ones, using originally the crop ioctls,
are converted to the selection ioctls properly.

Until the selections API was introduced we used the CROP ioctls to 
configure
cropping on OUTPUT buffer queue and composition onto CAPTURE buffer.
Looking at Figure 1.2, [1] it seems obvious that there should be applied
following mapping of the CROP to SELECTION ioctls:

S_CROP(V4L2_BUF_TYPE_VIDEO_OUTPUT) -> 
S_SELECTION(V4L2_BUF_TYPE_VIDEO_OUTPUT,
						  V4L2_SEL_TGT_CROP)

S_CROP(V4L2_BUF_TYPE_VIDEO_CAPTURE) -> 
S_SELECTION(V4L2_BUF_TYPE_VIDEO_CAPTURE,
						   V4L2_SEL_TGT_COMPOSE)

And that's how selections are currently documented at video output and
capture interfaces:

--------------------------------------------------------------------------------
*Configuration of video output*

For output devices targets and ioctls are used similarly to the video 
capture
case. The composing rectangle refers to the insertion of an image into a 
video
signal. The cropping rectangles refer to a memory buffer."


*Configuration of video capture*
... The top left corner, width and height of the source rectangle, that 
is the
area actually sampled, is given by the V4L2_SEL_TGT_CROP target.
...
The composing targets refer to a memory buffer.
--------------------------------------------------------------------------------

If we apply this mapping, then current VIDIOC_S/G_CROP -> 
VIDIOC_S/G_SELECTION
ioctl fallback code wouldn't be valid, as we have there, e.g.

static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
				struct file *file, void *fh, void *arg)
{
	struct v4l2_crop *p = arg;
	struct v4l2_selection s = {
		.type = p->type,
		.r = p->c,
	};

	if (ops->vidioc_s_crop)
		return ops->vidioc_s_crop(file, fh, p);
	/* simulate capture crop using selection api */

	/* crop means compose for output devices */
	if (V4L2_TYPE_IS_OUTPUT(p->type))
		s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
	else
		s.target = V4L2_SEL_TGT_CROP_ACTIVE;

	return ops->vidioc_s_selection(file, fh, &s);
}

i.e. it does exactly opposite to what we would expect for M2M.

One possible solution would be to get hold of struct video_device and
do proper targets conversion after checking the vfl_dir field.

Does anyone have suggestions on this ?


BTW, we still have some V4L2_SEL_TGT*_ACTIVE symbols left, I'll write
a patch to clean this up.

[1] http://hverkuil.home.xs4all.nl/spec/media.html#idp9025504
[2] http://hverkuil.home.xs4all.nl/spec/media.html#idp9031840

--
Thanks,
Sylwester

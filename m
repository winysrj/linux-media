Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44116 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2K0QU5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 11:20:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shaik Ameer Basha <shaik.samsung@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC] Selections targets at V4L2 video mem-to-mem interface
Date: Tue, 27 Nov 2012 17:22 +0100
Message-ID: <1490478.6lyX5XUpfT@avalon>
In-Reply-To: <CAOD6ATruStrbH7iwTiWx55vBk19NiieLuxRJjhFJh1c3yZfaxg@mail.gmail.com>
References: <50998D97.3030405@gmail.com> <CAOD6ATruStrbH7iwTiWx55vBk19NiieLuxRJjhFJh1c3yZfaxg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 22 November 2012 14:25:18 Shaik Ameer Basha wrote:
> On Wed, Nov 7, 2012 at 3:52 AM, Sylwester Nawrocki wrote:
> > Hi All,
> > 
> > I'd like to clarify the meaning of selection targets on a mem-to-mem video
> > device, in order to document it and to make sure new m2m drivers get it
> > right, and also that the existing ones, using originally the crop ioctls,
> > are converted to the selection ioctls properly.
> > 
> > Until the selections API was introduced we used the CROP ioctls to
> > configure cropping on OUTPUT buffer queue and composition onto CAPTURE
> > buffer. Looking at Figure 1.2, [1] it seems obvious that there should be
> > applied following mapping of the CROP to SELECTION ioctls:
> > 
> > S_CROP(V4L2_BUF_TYPE_VIDEO_OUTPUT) ->
> > S_SELECTION(V4L2_BUF_TYPE_VIDEO_OUTPUT, V4L2_SEL_TGT_CROP)
> > 
> > S_CROP(V4L2_BUF_TYPE_VIDEO_CAPTURE) ->
> > S_SELECTION(V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_SEL_TGT_COMPOSE)
> > 
> > And that's how selections are currently documented at video output and
> > capture interfaces:
> > 
> > --------------------------------------------------------------------------
> > *Configuration of video output*
> > 
> > For output devices targets and ioctls are used similarly to the video
> > capture case. The composing rectangle refers to the insertion of an image
> > into avideo signal. The cropping rectangles refer to a memory buffer."
> > 
> > *Configuration of video capture*
> > ... The top left corner, width and height of the source rectangle, that is
> > the area actually sampled, is given by the V4L2_SEL_TGT_CROP target.
> > ...
> > The composing targets refer to a memory buffer.
> > --------------------------------------------------------------------------
> > 
> > If we apply this mapping, then current VIDIOC_S/G_CROP ->
> > VIDIOC_S/G_SELECTION
> > ioctl fallback code wouldn't be valid, as we have there, e.g.
> > 
> > static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
> >                                 struct file *file, void *fh, void *arg)
> > {
> >         struct v4l2_crop *p = arg;
> >         struct v4l2_selection s = {
> >                 .type = p->type,
> >                 .r = p->c,
> >         };
> >         
> >         if (ops->vidioc_s_crop)
> >                 return ops->vidioc_s_crop(file, fh, p);
> >         
> >         /* simulate capture crop using selection api */
> >         /* crop means compose for output devices */
> >         if (V4L2_TYPE_IS_OUTPUT(p->type))
> >                 s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
> >         else
> >                 s.target = V4L2_SEL_TGT_CROP_ACTIVE;
> >         
> >         return ops->vidioc_s_selection(file, fh, &s);
> > }
> > 
> > i.e. it does exactly opposite to what we would expect for M2M.
> 
> You are right. Instead of handling this confusion in driver, as you
> mentioned, we can use vfl_dir field to select the target before sending it
> to the driver.
> 
> apart from using this vfl_dir field, I can't able to see any other
> solution here.
>
> > One possible solution would be to get hold of struct video_device and
> > do proper targets conversion after checking the vfl_dir field.
> > 
> > Does anyone have suggestions on this ?

As the video_device can easily be retrieved with video_devdata(file) I think 
that's the easiest solution (and the only practical one I can see as well).

> > BTW, we still have some V4L2_SEL_TGT*_ACTIVE symbols left, I'll write
> > a patch to clean this up.
> > 
> > [1] http://hverkuil.home.xs4all.nl/spec/media.html#idp9025504
> > [2] http://hverkuil.home.xs4all.nl/spec/media.html#idp9031840

-- 
Regards,

Laurent Pinchart


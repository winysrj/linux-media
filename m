Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52814 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440Ab2KVUCi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 15:02:38 -0500
Received: by mail-vc0-f174.google.com with SMTP id m18so5003757vcm.19
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 12:02:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50998D97.3030405@gmail.com>
References: <50998D97.3030405@gmail.com>
Date: Thu, 22 Nov 2012 14:25:18 +0530
Message-ID: <CAOD6ATruStrbH7iwTiWx55vBk19NiieLuxRJjhFJh1c3yZfaxg@mail.gmail.com>
Subject: Re: [RFC] Selections targets at V4L2 video mem-to-mem interface
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wed, Nov 7, 2012 at 3:52 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi All,
>
> I'd like to clarify the meaning of selection targets on a mem-to-mem video
> device, in order to document it and to make sure new m2m drivers get it
> right, and also that the existing ones, using originally the crop ioctls,
> are converted to the selection ioctls properly.
>
> Until the selections API was introduced we used the CROP ioctls to configure
> cropping on OUTPUT buffer queue and composition onto CAPTURE buffer.
> Looking at Figure 1.2, [1] it seems obvious that there should be applied
> following mapping of the CROP to SELECTION ioctls:
>
> S_CROP(V4L2_BUF_TYPE_VIDEO_OUTPUT) ->
> S_SELECTION(V4L2_BUF_TYPE_VIDEO_OUTPUT,
>                                                   V4L2_SEL_TGT_CROP)
>
> S_CROP(V4L2_BUF_TYPE_VIDEO_CAPTURE) ->
> S_SELECTION(V4L2_BUF_TYPE_VIDEO_CAPTURE,
>                                                    V4L2_SEL_TGT_COMPOSE)
>
> And that's how selections are currently documented at video output and
> capture interfaces:
>
> --------------------------------------------------------------------------------
> *Configuration of video output*
>
> For output devices targets and ioctls are used similarly to the video
> capture
> case. The composing rectangle refers to the insertion of an image into a
> video
> signal. The cropping rectangles refer to a memory buffer."
>
>
> *Configuration of video capture*
> ... The top left corner, width and height of the source rectangle, that is
> the
> area actually sampled, is given by the V4L2_SEL_TGT_CROP target.
> ...
> The composing targets refer to a memory buffer.
> --------------------------------------------------------------------------------
>
> If we apply this mapping, then current VIDIOC_S/G_CROP ->
> VIDIOC_S/G_SELECTION
> ioctl fallback code wouldn't be valid, as we have there, e.g.
>
> static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
>                                 struct file *file, void *fh, void *arg)
> {
>         struct v4l2_crop *p = arg;
>         struct v4l2_selection s = {
>                 .type = p->type,
>                 .r = p->c,
>         };
>
>         if (ops->vidioc_s_crop)
>                 return ops->vidioc_s_crop(file, fh, p);
>         /* simulate capture crop using selection api */
>
>         /* crop means compose for output devices */
>         if (V4L2_TYPE_IS_OUTPUT(p->type))
>                 s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
>         else
>                 s.target = V4L2_SEL_TGT_CROP_ACTIVE;
>
>         return ops->vidioc_s_selection(file, fh, &s);
> }
>
> i.e. it does exactly opposite to what we would expect for M2M.

You are right. Instead of handling this confusion in driver, as you
mentioned, we can use
vfl_dir field to select the target before sending it to the driver.

apart from using this vfl_dir field, I can't able to see any other
solution here.

Regards,
Shaik Ameer Basha

>
> One possible solution would be to get hold of struct video_device and
> do proper targets conversion after checking the vfl_dir field.
>
> Does anyone have suggestions on this ?
>
>
> BTW, we still have some V4L2_SEL_TGT*_ACTIVE symbols left, I'll write
> a patch to clean this up.
>
> [1] http://hverkuil.home.xs4all.nl/spec/media.html#idp9025504
> [2] http://hverkuil.home.xs4all.nl/spec/media.html#idp9031840
>
> --
> Thanks,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51184 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2KQSYE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Nov 2012 13:24:04 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so440361eek.19
        for <linux-media@vger.kernel.org>; Sat, 17 Nov 2012 10:24:02 -0800 (PST)
Message-ID: <50A7D640.8000905@gmail.com>
Date: Sat, 17 Nov 2012 19:24:00 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, dron0gus@gmail.com,
	tomasz.figa@gmail.com, oselas@community.pengutronix.de
Subject: Re: [PATCH RFC v3 1/3] V4L: Add driver for S3C244X/S3C64XX SoC series
 camera interface
References: <1353017115-11492-1-git-send-email-sylvester.nawrocki@gmail.com> <1353017115-11492-2-git-send-email-sylvester.nawrocki@gmail.com> <201211161445.34285.hverkuil@xs4all.nl>
In-Reply-To: <201211161445.34285.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 11/16/2012 02:45 PM, Hans Verkuil wrote:
> Hi Sylwester,
>
> Just one comment, see below...
>
> On Thu November 15 2012 23:05:13 Sylwester Nawrocki wrote:
>> This patch adds V4L2 driver for Samsung S3C244X/S3C64XX SoC series
>> camera interface. The driver exposes a subdev device node for CAMIF
>> pixel resolution and crop control and two video capture nodes - for
>> the "codec" and "preview" data paths. It has been tested on Mini2440
>> (s3c2440) and Mini6410 (s3c6410) board with gstreamer and mplayer.
>>
>> Signed-off-by: Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
>> Signed-off-by: Tomasz Figa<tomasz.figa@gmail.com>
>> ---
...
>> +static int s3c_camif_streamon(struct file *file, void *priv,
>> +			      enum v4l2_buf_type type)
>> +{
>> +	struct camif_vp *vp = video_drvdata(file);
>> +	struct camif_dev *camif = vp->camif;
>> +	struct media_entity *sensor =&camif->sensor.sd->entity;
>> +	int ret;
>> +
>> +	pr_debug("[vp%d]\n", vp->id);
>> +
>> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +		return -EINVAL;
>> +
>> +	if (vp->owner&&  vp->owner != priv)
>> +		return -EBUSY;
>> +
>> +	if (s3c_vp_active(vp))
>> +		return 0;
>> +
>> +	ret = media_entity_pipeline_start(sensor, camif->m_pipeline);
>> +	if (ret<  0)
>> +		return ret;
>> +
>> +	ret = camif_pipeline_validate(camif);
>> +	if (ret<  0) {
>> +		media_entity_pipeline_stop(sensor);
>> +		return ret;
>> +	}
>> +
>> +	return vb2_streamon(&vp->vb_queue, type);
>> +}
>> +
>> +static int s3c_camif_streamoff(struct file *file, void *priv,
>> +			       enum v4l2_buf_type type)
>> +{
>> +	struct camif_vp *vp = video_drvdata(file);
>> +	struct camif_dev *camif = vp->camif;
>> +	int ret;
>> +
>> +	pr_debug("[vp%d]\n", vp->id);
>> +
>> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +		return -EINVAL;
>> +
>> +	if (vp->owner&&  vp->owner != priv)
>> +		return -EBUSY;
>> +
>> +	ret = vb2_streamoff(&vp->vb_queue, type);
>> +	if (ret == 0)
>> +		media_entity_pipeline_stop(&camif->sensor.sd->entity);
>> +	return ret;
>> +}
>> +
>> +static int s3c_camif_reqbufs(struct file *file, void *priv,
>> +			     struct v4l2_requestbuffers *rb)
>> +{
>> +	struct camif_vp *vp = video_drvdata(file);
>> +	int ret;
>> +
>> +	pr_debug("[vp%d] rb count: %d, owner: %p, priv: %p\n",
>> +		 vp->id, rb->count, vp->owner, priv);
>> +
>> +	if (vp->owner&&  vp->owner != priv)
>> +		return -EBUSY;
>> +
>> +	if (rb->count)
>> +		rb->count = max_t(u32, CAMIF_REQ_BUFS_MIN, rb->count);
>> +	else
>> +		vp->owner = NULL;
>> +
>> +	ret = vb2_reqbufs(&vp->vb_queue, rb);
>> +	if (!ret) {
>> +		vp->reqbufs_count = rb->count;
>> +		if (vp->owner == NULL&&  rb->count>  0)
>> +			vp->owner = priv;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int s3c_camif_querybuf(struct file *file, void *priv,
>> +			      struct v4l2_buffer *buf)
>> +{
>> +	struct camif_vp *vp = video_drvdata(file);
>> +	return vb2_querybuf(&vp->vb_queue, buf);
>> +}
>> +
>> +static int s3c_camif_qbuf(struct file *file, void *priv,
>> +			  struct v4l2_buffer *buf)
>> +{
>> +	struct camif_vp *vp = video_drvdata(file);
>> +
>> +	pr_debug("[vp%d]\n", vp->id);
>> +
>> +	if (vp->owner&&  vp->owner != priv)
>> +		return -EBUSY;
>> +
>> +	return vb2_qbuf(&vp->vb_queue, buf);
>> +}
>> +
>> +static int s3c_camif_dqbuf(struct file *file, void *priv,
>> +			   struct v4l2_buffer *buf)
>> +{
>> +	struct camif_vp *vp = video_drvdata(file);
>> +
>> +	pr_debug("[vp%d] sequence: %d\n", vp->id, vp->frame_sequence);
>> +
>> +	if (vp->owner&&  vp->owner != priv)
>> +		return -EBUSY;
>> +
>> +	return vb2_dqbuf(&vp->vb_queue, buf, file->f_flags&  O_NONBLOCK);
>> +}
>> +
>> +static int s3c_camif_create_bufs(struct file *file, void *priv,
>> +				 struct v4l2_create_buffers *create)
>> +{
>> +	struct camif_vp *vp = video_drvdata(file);
>> +	int ret;
>> +
>> +	if (vp->owner&&  vp->owner != priv)
>> +		return -EBUSY;
>> +
>> +	create->count = max_t(u32, 1, create->count);
>> +	ret = vb2_create_bufs(&vp->vb_queue, create);
>> +
>> +	if (!ret&&  vp->owner == NULL)
>> +		vp->owner = priv;
>> +
>> +	return ret;
>> +}
>> +
>> +static int s3c_camif_prepare_buf(struct file *file, void *priv,
>> +				 struct v4l2_buffer *b)
>> +{
>> +	struct camif_vp *vp = video_drvdata(file);
>> +	return vb2_prepare_buf(&vp->vb_queue, b);
>> +}
>> +
>
> Are you aware of the vb2 ioctl helper functions I've added? See videobuf2-core.h,
> at the end.

Yes, I just chose not to introduce these helpers now, to make any 
back-porting
of this driver to older kernels easier.

> They can probably replace some of these ioctls. It's something you can do later
> in a separate patch, so this isn't blocking as far as I am concerned. It's just
> a hint.

Thanks, I'll see which ones can be replaced. But I would prefer to make it
a separate patch for subsequent kernel release.

Looking at v4l2_ioctl_create_bufs(), v4l2_ioctl_prepare_buf(), is it he 
right
thing not to allow other process/thread than the current buffer queue owner
to create and prepare buffers ? This would prevent for example, having two
threads where one is currently streaming and the other creates buffers. 
The use
case is maybe not very common but I can't see why we need to disallow that.

--

Regards,
Sylwester

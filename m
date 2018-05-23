Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46718 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933791AbeEWVfB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 17:35:01 -0400
Message-ID: <2b323dafbe5cfbf85d51335418f8ba653ce5734d.camel@collabora.com>
Subject: Re: [PATCH 06/20] omap4iss: Add video_device and vb2_queue locks
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: kernel@collabora.com, Abylay Ospan <aospan@netup.ru>
Date: Wed, 23 May 2018 18:33:34 -0300
In-Reply-To: <e0ff4ccc-2725-43e9-fd38-91dab15297b7@xs4all.nl>
References: <20180518185208.17722-1-ezequiel@collabora.com>
         <20180518185208.17722-7-ezequiel@collabora.com>
         <e0ff4ccc-2725-43e9-fd38-91dab15297b7@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-05-22 at 11:09 +0200, Hans Verkuil wrote:
> On 18/05/18 20:51, Ezequiel Garcia wrote:
> > video_device and vb2_queue locks are now both
> > mandatory. Add them, remove driver ad-hoc locks,
> > and implement wait_{prepare, finish}.
> > 
> > To stay on the safe side, this commit uses a single mutex
> > for both locks. Better latency can be obtained by separating
> > these if needed.
> > 
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  drivers/staging/media/omap4iss/iss_video.c | 32 +++++++-----------------------
> >  drivers/staging/media/omap4iss/iss_video.h |  2 +-
> >  2 files changed, 8 insertions(+), 26 deletions(-)
> > 
> > diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> > index a3a83424a926..380cfd230262 100644
> > --- a/drivers/staging/media/omap4iss/iss_video.c
> > +++ b/drivers/staging/media/omap4iss/iss_video.c
> > @@ -260,10 +260,7 @@ __iss_video_get_format(struct iss_video *video,
> >  	fmt.pad = pad;
> >  	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> >  
> > -	mutex_lock(&video->mutex);
> >  	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
> > -	mutex_unlock(&video->mutex);
> > -
> >  	if (ret)
> >  		return ret;
> >  
> > @@ -411,6 +408,8 @@ static const struct vb2_ops iss_video_vb2ops = {
> >  	.buf_prepare	= iss_video_buf_prepare,
> >  	.buf_queue	= iss_video_buf_queue,
> >  	.buf_cleanup	= iss_video_buf_cleanup,
> > +	.wait_prepare	= vb2_ops_wait_prepare,
> > +	.wait_finish	= vb2_ops_wait_finish,
> >  };
> >  
> >  /*
> > @@ -592,9 +591,7 @@ iss_video_get_format(struct file *file, void *fh, struct v4l2_format *format)
> >  	if (format->type != video->type)
> >  		return -EINVAL;
> >  
> > -	mutex_lock(&video->mutex);
> >  	*format = vfh->format;
> > -	mutex_unlock(&video->mutex);
> >  
> >  	return 0;
> >  }
> > @@ -609,8 +606,6 @@ iss_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
> >  	if (format->type != video->type)
> >  		return -EINVAL;
> >  
> > -	mutex_lock(&video->mutex);
> > -
> >  	/*
> >  	 * Fill the bytesperline and sizeimage fields by converting to media bus
> >  	 * format and back to pixel format.
> > @@ -620,7 +615,6 @@ iss_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
> >  
> >  	vfh->format = *format;
> >  
> > -	mutex_unlock(&video->mutex);
> >  	return 0;
> >  }
> >  
> > @@ -741,9 +735,7 @@ iss_video_set_selection(struct file *file, void *fh, struct v4l2_selection *sel)
> >  		return -EINVAL;
> >  
> >  	sdsel.pad = pad;
> > -	mutex_lock(&video->mutex);
> >  	ret = v4l2_subdev_call(subdev, pad, set_selection, NULL, &sdsel);
> > -	mutex_unlock(&video->mutex);
> >  	if (!ret)
> >  		sel->r = sdsel.r;
> >  
> > @@ -873,8 +865,6 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
> >  	if (type != video->type)
> >  		return -EINVAL;
> >  
> > -	mutex_lock(&video->stream_lock);
> > -
> >  	/*
> >  	 * Start streaming on the pipeline. No link touching an entity in the
> >  	 * pipeline can be activated or deactivated once streaming is started.
> > @@ -978,8 +968,6 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
> >  
> >  	media_graph_walk_cleanup(&graph);
> >  
> > -	mutex_unlock(&video->stream_lock);
> > -
> >  	return 0;
> >  
> >  err_omap4iss_set_stream:
> > @@ -996,8 +984,6 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
> >  err_graph_walk_init:
> >  	media_entity_enum_cleanup(&pipe->ent_enum);
> >  
> > -	mutex_unlock(&video->stream_lock);
> > -
> >  	return ret;
> >  }
> >  
> > @@ -1013,10 +999,8 @@ iss_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
> >  	if (type != video->type)
> >  		return -EINVAL;
> >  
> > -	mutex_lock(&video->stream_lock);
> > -
> >  	if (!vb2_is_streaming(&vfh->queue))
> > -		goto done;
> > +		return 0;
> >  
> >  	/* Update the pipeline state. */
> >  	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > @@ -1041,8 +1025,6 @@ iss_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
> >  		video->iss->pdata->set_constraints(video->iss, false);
> >  	media_pipeline_stop(&video->video.entity);
> >  
> > -done:
> > -	mutex_unlock(&video->stream_lock);
> >  	return 0;
> >  }
> >  
> > @@ -1137,6 +1119,7 @@ static int iss_video_open(struct file *file)
> >  	q->buf_struct_size = sizeof(struct iss_buffer);
> >  	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> >  	q->dev = video->iss->dev;
> > +	q->lock = &video->v4l_lock;
> 
> I feel too much is changed in this driver (and also the omap3isp driver in the
> next patch). Why not just set q->lock to stream_lock (queue_lock for omap3isp)?
> 

OK. I'll set q->lock to stream_lock (queue_lock) and then of course,
drop all the mutex_lock/unlock that the driver is doing.

> There is no need to set video->video.lock at all, that's not compulsory.
> 

Yeah, perhaps it's a better idea, considering I'm only compile testing these.

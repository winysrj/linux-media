Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35736 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751038AbeDELQn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 07:16:43 -0400
Date: Thu, 5 Apr 2018 14:16:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Matt Ranostay <matt.ranostay@konsulko.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v6 2/2] media: video-i2c: add video-i2c driver
Message-ID: <20180405111641.qftsnhci6kr3bbyk@valkosipuli.retiisi.org.uk>
References: <20180401005926.18203-1-matt.ranostay@konsulko.com>
 <20180401005926.18203-3-matt.ranostay@konsulko.com>
 <20180405073948.4ujeavrfegln6orf@valkosipuli.retiisi.org.uk>
 <e81722cf-5b6e-7d2b-6f6e-9c5f634a2750@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e81722cf-5b6e-7d2b-6f6e-9c5f634a2750@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Apr 05, 2018 at 10:04:57AM +0200, Hans Verkuil wrote:
...
> >> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
> >> +{
> >> +	struct video_i2c_data *data = vb2_get_drv_priv(vq);
> >> +	struct video_i2c_buffer *buf, *tmp;
> >> +
> >> +	if (data->kthread_vid_cap)
> >> +		return 0;
> >> +
> >> +	data->sequence = 0;
> >> +	data->kthread_vid_cap = kthread_run(video_i2c_thread_vid_cap, data,
> >> +					    "%s-vid-cap", data->v4l2_dev.name);
> >> +	if (!IS_ERR(data->kthread_vid_cap))
> >> +		return 0;
> >> +
> >> +	spin_lock(&data->slock);
> >> +
> >> +	list_for_each_entry_safe(buf, tmp, &data->vid_cap_active, list) {
> >> +		list_del(&buf->list);
> >> +		vb2_buffer_done(&buf->vb.vb2_buf,
> >> +				VB2_BUF_STATE_QUEUED);
> > 
> > What's the purpose of this?
> 
> This is the error path (kthread_run failed), so all buffers need to be
> returned to vb2.

Ah, I missed that. Then, Matt, please ignore this comment and the one
below.

> 
> > 
> >> +	}
> >> +
> >> +	spin_unlock(&data->slock);
> >> +
> >> +	return PTR_ERR(data->kthread_vid_cap);
> > 
> > How about 0 instead?
> 
> This is the error path, so the error should be returned here. This code
> is correct.
> 
> > 
> >> +}
> >> +
> >> +static void stop_streaming(struct vb2_queue *vq)
> >> +{
> >> +	struct video_i2c_data *data = vb2_get_drv_priv(vq);
> >> +
> >> +	if (data->kthread_vid_cap == NULL)
> >> +		return;
> >> +
> >> +	kthread_stop(data->kthread_vid_cap);
> >> +
> >> +	spin_lock(&data->slock);
> >> +
> >> +	while (!list_empty(&data->vid_cap_active)) {
> >> +		struct video_i2c_buffer *buf;
> >> +
> >> +		buf = list_entry(data->vid_cap_active.next,
> > 
> > list_last_entry(&data->vid_cap_active, ...)?
> 
> Why? You're deleting the list, so whether you pick the first
> or last element really doesn't matter.

I rather wanted to suggest that there's no need to explicitly access the
linked list related structs, functions such as list_last_entry() (or
list_first_entry()) can be used instead.

It'd be also nice to align the loop construct with error handling path in
start_streaming() function above as they're doing the same things.

> > 
> >> +				 struct video_i2c_buffer, list);
> >> +		list_del(&buf->list);
> >> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> >> +	}
> >> +	spin_unlock(&data->slock);
> >> +
> >> +	data->kthread_vid_cap = NULL;

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi

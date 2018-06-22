Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51500 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934357AbeFVDvz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 23:51:55 -0400
Message-ID: <e72ea826754f5f1e52860cbe0a573218816cd3cc.camel@collabora.com>
Subject: Re: [PATCH v5 04/17] omap3isp: Add vb2_queue lock
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com
Date: Fri, 22 Jun 2018 00:51:46 -0300
In-Reply-To: <2f735410-5bb8-d70d-be07-549d09f12a5d@xs4all.nl>
References: <d0d27ee4-1a83-baa6-9982-ba18add79bc8@xs4all.nl>
         <20180620174255.20304-1-ezequiel@collabora.com>
         <2f735410-5bb8-d70d-be07-549d09f12a5d@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-06-21 at 10:18 +0200, Hans Verkuil wrote:
> On 06/20/18 19:42, Ezequiel Garcia wrote:
> > vb2_queue locks is now mandatory. Add it, remove driver ad-hoc
> > locks,
> > and implement wait_{prepare, finish}.
> > 
> > Also, remove stream_lock mutex. Sicen the ioctls operations
> 
> Sicen -> Since
> 
> > are protected by the queue mutex, the stream_lock mutex is
> 
> are protected -> are now protected
> 

Will fix.

[snip]
> > @@ -1363,10 +1323,9 @@ static int isp_video_release(struct file
> > *file)
> > 
> >  	struct v4l2_fh *vfh = file->private_data;
> >  	struct isp_video_fh *handle = to_isp_video_fh(vfh);
> >  
> > +	mutex_lock(&video->queue_lock);

See below.

> >  	/* Disable streaming and free the buffers queue resources.
> > */
> >  	isp_video_streamoff(file, vfh, video->type);
> > -
> > -	mutex_lock(&video->queue_lock);
> >  	vb2_queue_release(&handle->queue);
> >  	mutex_unlock(&video->queue_lock);
> 
> Hmm, this mutex_unlock is not removed, did you miss this one?
> 

The mutex_lock call is moved before the call to isp_video_streamoff,
because .streamoff is called with the queue lock held,
and so it seemed more consistent.

I will send a v6 with the amended commit log.

Let me know if you catch anything else, it's a long series
and the devil is always in the detail!

Thanks,
Eze

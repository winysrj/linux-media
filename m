Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:34019 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0DZLli (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 07:41:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH v3 2/3] v4l: videobuf: Add support for V4L2_BUF_FLAG_ERROR
Date: Mon, 26 Apr 2010 13:41:47 +0200
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, "'Hans Verkuil'" <hverkuil@xs4all.nl>
References: <1271849985-368-1-git-send-email-p.osciak@samsung.com> <201004221112.30988.laurent.pinchart@ideasonboard.com> <001601cae1ff$2955f650$7c01e2f0$%osciak@samsung.com>
In-Reply-To: <001601cae1ff$2955f650$7c01e2f0$%osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004261341.48308.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Thursday 22 April 2010 11:35:35 Pawel Osciak wrote:
> >Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >On Wednesday 21 April 2010 13:39:44 Pawel Osciak wrote:
> >> @@ -679,23 +682,20 @@ int videobuf_dqbuf(struct videobuf_queue *q,
> >> 
> >>  	switch (buf->state) {
> >>  	
> >>  	case VIDEOBUF_ERROR:
> >>  		dprintk(1, "dqbuf: state is error\n");
> >> 
> >> -		retval = -EIO;
> >> -		CALL(q, sync, q, buf);
> >> -		buf->state = VIDEOBUF_IDLE;
> >> 
> >>  		break;
> >>  	
> >>  	case VIDEOBUF_DONE:
> >>  		dprintk(1, "dqbuf: state is done\n");
> >> 
> >> -		CALL(q, sync, q, buf);
> >> -		buf->state = VIDEOBUF_IDLE;
> >> 
> >>  		break;
> >>  	
> >>  	default:
> >>  		dprintk(1, "dqbuf: state invalid\n");
> >>  		retval = -EINVAL;
> >>  		goto done;
> >>  	
> >>  	}
> >> 
> >> -	list_del(&buf->stream);
> >> -	memset(b, 0, sizeof(*b));
> >> +	CALL(q, sync, q, buf);
> >> 
> >>  	videobuf_status(q, b, buf, q->type);
> >> 
> >> +	list_del(&buf->stream);
> >> +	buf->state = VIDEOBUF_IDLE;
> >> +	b->flags &= ~V4L2_BUF_FLAG_DONE;
> >
> >We do you clear the done flag here ?
> 
> The DONE flag is supposed to be cleared when dequeuing, but should
> be set when querying:
> 
> "When this flag is set, the buffer is currently on the outgoing queue,
> ready to be dequeued from the driver. Drivers set or clear this flag
> when the VIDIOC_QUERYBUF  ioctl is called. After calling the VIDIOC_QBUF
> or VIDIOC_DQBUF it is always cleared."
> 
> videobuf_status() is used for both QUERYBUF and DQBUF and making both
> work properly is not very straightforward without losing
> VIDEOBUF_DONE/VIDEOBUF_ERROR distinction (it becomes more clear when you
> analyze both cases).
> 
> My previous patch was doing it the other way around, but Hans' version
> seemed shorter and cleaner.

Thanks for pointing this out.

I have no more objection then,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

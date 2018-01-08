Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49292 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932575AbeAHOiP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 09:38:15 -0500
Date: Mon, 8 Jan 2018 12:38:07 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Inki Dae <inki.dae@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Junghak Sung <jh1009.sung@samsung.com>,
        devendra sharma <devendra.sharma9091@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 02/11] media: videobuf2: Add new uAPI for DVB streaming
 I/O
Message-ID: <20180108123807.489c7b2a@vento.lan>
In-Reply-To: <10d07ce3-d035-90b9-eac0-6d9786ae72de@xs4all.nl>
References: <cover.1513872637.git.mchehab@s-opensource.com>
        <6cb582dc945457e9626561b584d98cd053782481.1513872637.git.mchehab@s-opensource.com>
        <f51752f2-a564-c828-7cce-5bd44222ea22@xs4all.nl>
        <10d07ce3-d035-90b9-eac0-6d9786ae72de@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 8 Jan 2018 15:26:50 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> A quick follow-up:
> 
> On 01/08/2018 02:54 PM, Hans Verkuil wrote:
> >> +/*
> >> + * Videobuf operations
> >> + */
> >> +int dvb_vb2_init(struct dvb_vb2_ctx *ctx, const char *name, int nonblocking)
> >> +{
> >> +	struct vb2_queue *q = &ctx->vb_q;
> >> +	int ret;
> >> +
> >> +	memset(ctx, 0, sizeof(struct dvb_vb2_ctx));
> >> +	q->type = DVB_BUF_TYPE_CAPTURE;  
> > 
> > We don't support DVB_BUF_TYPE_OUTPUT? Shouldn't this information come from the
> > driver?
> >   
> >> +	/**capture type*/  
> > 
> > Why /** ?
> >   
> >> +	q->is_output = 0;  
> > 
> > Can be dropped unless we support DVB_BUF_TYPE_OUTPUT.
> >   
> >> +	/**only mmap is supported currently*/  
> > 
> > /** ?
> >   
> >> +	q->io_modes = VB2_MMAP;
> >> +	q->drv_priv = ctx;
> >> +	q->buf_struct_size = sizeof(struct dvb_buffer);
> >> +	q->min_buffers_needed = 1;
> >> +	q->ops = &dvb_vb2_qops;
> >> +	q->mem_ops = &vb2_vmalloc_memops;
> >> +	q->buf_ops = &dvb_vb2_buf_ops;
> >> +	q->num_buffers = 0;  
> > 
> > Not needed, is zeroed in the memset above.
> > 
> > I'm also missing q->timestamp_flags: should be set to V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC.  
> 
> Ignore this, see my comments later on.
> 
> >   
> >> +	ret = vb2_core_queue_init(q);
> >> +	if (ret) {
> >> +		ctx->state = DVB_VB2_STATE_NONE;
> >> +		dprintk(1, "[%s] errno=%d\n", ctx->name, ret);
> >> +		return ret;
> >> +	}
> >> +
> >> +	mutex_init(&ctx->mutex);
> >> +	spin_lock_init(&ctx->slock);
> >> +	INIT_LIST_HEAD(&ctx->dvb_q);
> >> +
> >> +	strncpy(ctx->name, name, DVB_VB2_NAME_MAX);  
> > 
> > I believe strlcpy is recommended.
> >   
> >> +	ctx->nonblocking = nonblocking;
> >> +	ctx->state = DVB_VB2_STATE_INIT;
> >> +
> >> +	dprintk(3, "[%s]\n", ctx->name);
> >> +
> >> +	return 0;
> >> +}  
> 
> <snip>
> 
> >> diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
> >> index c10f1324b4ca..e212aa18ad78 100644
> >> --- a/include/uapi/linux/dvb/dmx.h
> >> +++ b/include/uapi/linux/dvb/dmx.h
> >> @@ -211,6 +211,64 @@ struct dmx_stc {
> >>  	__u64 stc;
> >>  };
> >>  
> >> +/**
> >> + * struct dmx_buffer - dmx buffer info
> >> + *
> >> + * @index:	id number of the buffer
> >> + * @bytesused:	number of bytes occupied by data in the buffer (payload);
> >> + * @offset:	for buffers with memory == DMX_MEMORY_MMAP;
> >> + *		offset from the start of the device memory for this plane,
> >> + *		(or a "cookie" that should be passed to mmap() as offset)  
> > 
> > Since we only support MMAP this is always a 'cookie' in practice. So I think this
> > should just be:
> > 
> > 	A "cookie" that should be passed to mmap() as offset.
> >   
> >> + * @length:	size in bytes of the buffer
> >> + *
> >> + * Contains data exchanged by application and driver using one of the streaming
> >> + * I/O methods.
> >> + */
> >> +struct dmx_buffer {
> >> +	__u32			index;
> >> +	__u32			bytesused;
> >> +	__u32			offset;  
> > 
> > I suggest making this a __u64: that way we can handle pointers as well in
> > the future if we need them (as we do for the USERPTR case for V4L2).
> > 
> > Should this also be wrapped in a union? Useful when adding dmabuf support in the
> > future.
> > 
> > Do you think there is any use-case for multiplanar formats in the future?
> > With perhaps meta data in a separate plane? Having to add support for this later
> > has proven to be very painful, so we need to be as certain as possible that
> > this isn't going to happen. Otherwise it's better to prepare for this right now.
> >   
> >> +	__u32			length;
> >> +	__u32			reserved[4];  
> > 
> > I do believe you need a memory field as well. It's only MMAP today, but in
> > the future DMABUF will most likely be supported as well and you need to be
> > able to tell what memory mode is being used.
> >   
> >> +};  
> 
> There is no 'flags' field here. But without that you cannot check the buffer
> states, esp. the ERROR state. Or can that never happen?

On DVB, there is a protocol stack there that allows checking errors,
either MPEG-TS (current standards) or IP/MMT - for the new, yet to be
implemented ATSC version 3 standard.

Even if we add an error state, userspace will just ignore, as it will
need to verify the packet CRC checks.

> Would a timestamp field be useful, if only for debugging?

I don't see how a timestamp will help here for debugging. Probably,
adding event trace points would work better, but we have those
already at vb2-core.

Anyway, as this is kAPI only, we can add it later as needed.

Thanks,
Mauro

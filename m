Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36806 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753181AbdGGBxv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 21:53:51 -0400
Received: by mail-qk0-f194.google.com with SMTP id v143so2685265qkb.3
        for <linux-media@vger.kernel.org>; Thu, 06 Jul 2017 18:53:50 -0700 (PDT)
Date: Thu, 6 Jul 2017 22:53:46 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 03/12] [media] vb2: add in-fence support to QBUF
Message-ID: <20170707015346.GD10284@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-4-gustavo@padovan.org>
 <396bc2f8-eea6-82d5-c3b5-b8c2514af853@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <396bc2f8-eea6-82d5-c3b5-b8c2514af853@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-07-06 Hans Verkuil <hverkuil@xs4all.nl>:

> On 06/16/17 09:39, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Receive in-fence from userspace and add support for waiting on them
> > before queueing the buffer to the driver. Buffers are only queued
> > to the driver once they are ready. A buffer is ready when its
> > in-fence signals.
> > 
> > v2:
> > 	- fix vb2_queue_or_prepare_buf() ret check
> > 	- remove check for VB2_MEMORY_DMABUF only (Javier)
> > 	- check num of ready buffers to start streaming
> > 	- when queueing, start from the first ready buffer
> > 	- handle queue cancel
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > ---
> >  drivers/media/Kconfig                    |  1 +
> >  drivers/media/v4l2-core/videobuf2-core.c | 97 +++++++++++++++++++++++++-------
> >  drivers/media/v4l2-core/videobuf2-v4l2.c | 15 ++++-
> >  include/media/videobuf2-core.h           |  7 ++-
> >  4 files changed, 99 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> > index 55d9c2b..3cd1d3d 100644
> > --- a/drivers/media/Kconfig
> > +++ b/drivers/media/Kconfig
> > @@ -11,6 +11,7 @@ config CEC_NOTIFIER
> >  menuconfig MEDIA_SUPPORT
> >  	tristate "Multimedia support"
> >  	depends on HAS_IOMEM
> > +	select SYNC_FILE
> 
> Is this the right place for this? Shouldn't this be selected in
> 'config VIDEOBUF2_CORE'?
> 
> Fences are specific to vb2 after all.

Definitely.

> 
> >  	help
> >  	  If you want to use Webcams, Video grabber devices and/or TV devices
> >  	  enable this option and other options below.
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> > index ea83126..29aa9d4 100644

> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -1279,6 +1279,22 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
> >  	return 0;
> >  }
> >  
> > +static int __get_num_ready_buffers(struct vb2_queue *q)
> > +{
> > +	struct vb2_buffer *vb;
> > +	int ready_count = 0;
> > +
> > +	/* count num of buffers ready in front of the queued_list */
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > +		if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> > +			break;
> 
> Obviously the break is wrong as Mauro mentioned.

I replied this in the other email to Mauro, if a fence is not signaled
it is not ready te be queued by the driver nor is all buffers following
it. Hence the break. They need all to be in order and in front of the
queue.

In any case I'll check this again as now there is two people saying I'm
wrong! :)

> 
> > +
> > +		ready_count++;
> > +	}
> > +
> > +	return ready_count;
> > +}
> > +
> >  int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
> >  {
> >  	struct vb2_buffer *vb;
> > @@ -1324,8 +1340,15 @@ static int vb2_start_streaming(struct vb2_queue *q)
> >  	 * If any buffers were queued before streamon,
> >  	 * we can now pass them to driver for processing.
> >  	 */
> > -	list_for_each_entry(vb, &q->queued_list, queued_entry)
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > +		if (vb->state != VB2_BUF_STATE_QUEUED)
> > +			continue;
> 
> I think this test is unnecessary.

It might be indeed. It is necessary in __vb2_core_qbuf() so I think I
just copied it here without thinking.

> 
> > +
> > +		if (vb->in_fence && !dma_fence_is_signaled(vb->in_fence))
> > +			break;
> > +
> >  		__enqueue_in_driver(vb);
> 
> I would move the above test (after fixing it as Mauro said) to __enqueue_in_driver.
> I.e. if this is waiting for a fence then __enqueue_in_driver does nothing.

Yes, having this check inside __enqueue_in_driver() makes it looks much
nicer.

> 
> > +	}
> >  
> >  	/* Tell the driver to start streaming */
> >  	q->start_streaming_called = 1;
> > @@ -1369,33 +1392,55 @@ static int vb2_start_streaming(struct vb2_queue *q)
> >  
> >  static int __vb2_core_qbuf(struct vb2_buffer *vb, struct vb2_queue *q)
> >  {
> > +	struct vb2_buffer *b;
> >  	int ret;
> >  
> >  	/*
> >  	 * If already streaming, give the buffer to driver for processing.
> >  	 * If not, the buffer will be given to driver on next streamon.
> >  	 */
> > -	if (q->start_streaming_called)
> > -		__enqueue_in_driver(vb);
> >  
> > -	/*
> > -	 * If streamon has been called, and we haven't yet called
> > -	 * start_streaming() since not enough buffers were queued, and
> > -	 * we now have reached the minimum number of queued buffers,
> > -	 * then we can finally call start_streaming().
> > -	 */
> > -	if (q->streaming && !q->start_streaming_called &&
> > -	    q->queued_count >= q->min_buffers_needed) {
> > -		ret = vb2_start_streaming(q);
> > -		if (ret)
> > -			return ret;
> > +	if (q->start_streaming_called) {
> > +		list_for_each_entry(b, &q->queued_list, queued_entry) {
> > +			if (b->state != VB2_BUF_STATE_QUEUED)
> > +				continue;
> > +
> > +			if (b->in_fence && !dma_fence_is_signaled(b->in_fence))
> > +				break;
> 
> Again, if this test is in __enqueue_in_driver, then you can keep the
> original code. Why would you need to loop over all buffers anyway?
> 
> If a fence is ready then the callback will call this function for that
> buffer. Everything works fine AFAICT without looping over buffers here.

That seems correct. I'll just remove this loop.

	Gustavo

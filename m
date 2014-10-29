Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3311 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbaJ2Hyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 03:54:35 -0400
Message-ID: <54509D2C.5080901@xs4all.nl>
Date: Wed, 29 Oct 2014 08:54:20 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 02/16] cx88: drop the bogus 'queue' list in dmaqueue.
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>	<1411216911-7950-3-git-send-email-hverkuil@xs4all.nl> <20141028165823.5b34cd2a@recife.lan>
In-Reply-To: <20141028165823.5b34cd2a@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/28/2014 07:58 PM, Mauro Carvalho Chehab wrote:
> Em Sat, 20 Sep 2014 14:41:37 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This list is used some buffers have a different format, but that can
>> never happen. Remove it and all associated code.

Urgh. Can you fix the commit log to:

"This list is only used if the width, height and/or format of a buffer has
changed, but that can never happen. Remove it and all associated code."

At least that's proper English :-)

>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/pci/cx88/cx88-mpeg.c  | 31 -----------------------------
>>  drivers/media/pci/cx88/cx88-video.c | 39 +++----------------------------------
>>  drivers/media/pci/cx88/cx88.h       |  1 -
>>  3 files changed, 3 insertions(+), 68 deletions(-)
>>
>> diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
>> index 2803b6f..5f59901 100644
>> --- a/drivers/media/pci/cx88/cx88-mpeg.c
>> +++ b/drivers/media/pci/cx88/cx88-mpeg.c
>> @@ -210,37 +210,7 @@ static int cx8802_restart_queue(struct cx8802_dev    *dev,
>>  
>>  	dprintk( 1, "cx8802_restart_queue\n" );
>>  	if (list_empty(&q->active))
>> -	{
>> -		struct cx88_buffer *prev;
>> -		prev = NULL;
>> -
>> -		dprintk(1, "cx8802_restart_queue: queue is empty\n" );
> 
> This is not bogus code. What happens here is that sometimes the DMA 
> engine stops on cx88 and it needs to be restarted under some temporary
> errors.
> 
> I don't remember the exact condition, as I don't touch on cx88 on
> several years, but I think it happens when the signal drops (for
> example, if the antenna cable gets removed, but not 100% sure).
> 
> So, removing this code will cause regressions.

No, it won't. Read carefully how the 'queued' list is used: the only time
that an element is added to that list is in buffer_queue() if the width, height
or format has changed while streaming. But that can never happen (at least,
not after REQBUFS) and that case was removed in patch 01/16. So after patch
01/16 nobody is ever adding buffers to the queued list anymore and it can be
removed.

This patch has nothing to do with restarting DMA. Patch 04/16 is the one that
removes the restarting of DMA.

I did a fair amount of regression and duration testing to see if I could
reproduce a stopped DMA without being able to. I'm fairly certain that included
switching frequency between valid/invalid channels, but I can retry that just to
be sure.

I am very skeptical that this really has to do with DMA issues: it looks much more
like a poorly written driver. As my commit log to patch 04 says the cx88 driver
allows userspace to drain all buffers and at that moment it has to halt the DMA
and restart when a new buffer is queued up. But it is much simpler and more
robust to just keep streaming by always keeping one buffer around, just as almost
all other non-usb drivers do.

I have not been able to find any reports that actually mention that the DMA can
stop. The same change was done to cx23885 and no reports of any DMA problems have
been reported for that either, and I expect that both devices use very similar
DMA IP.

Regards,

	Hans

> 
> Regards,
> Mauro
> 
>> -
>> -		for (;;) {
>> -			if (list_empty(&q->queued))
>> -				return 0;
>> -			buf = list_entry(q->queued.next, struct cx88_buffer, vb.queue);
>> -			if (NULL == prev) {
>> -				list_move_tail(&buf->vb.queue, &q->active);
>> -				cx8802_start_dma(dev, q, buf);
>> -				buf->vb.state = VIDEOBUF_ACTIVE;
>> -				buf->count    = q->count++;
>> -				mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
>> -				dprintk(1,"[%p/%d] restart_queue - first active\n",
>> -					buf,buf->vb.i);
>> -
>> -			} else {
>> -				list_move_tail(&buf->vb.queue, &q->active);
>> -				buf->vb.state = VIDEOBUF_ACTIVE;
>> -				buf->count    = q->count++;
>> -				prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
>> -				dprintk(1,"[%p/%d] restart_queue - move to active\n",
>> -					buf,buf->vb.i);
>> -			}
>> -			prev = buf;
>> -		}
>>  		return 0;
>> -	}
>>  
>>  	buf = list_entry(q->active.next, struct cx88_buffer, vb.queue);
>>  	dprintk(2,"restart_queue [%p/%d]: restart dma\n",
>> @@ -486,7 +456,6 @@ static int cx8802_init_common(struct cx8802_dev *dev)
>>  
>>  	/* init dma queue */
>>  	INIT_LIST_HEAD(&dev->mpegq.active);
>> -	INIT_LIST_HEAD(&dev->mpegq.queued);
>>  	dev->mpegq.timeout.function = cx8802_timeout;
>>  	dev->mpegq.timeout.data     = (unsigned long)dev;
>>  	init_timer(&dev->mpegq.timeout);
>> diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
>> index 3075179..10fea4d 100644
>> --- a/drivers/media/pci/cx88/cx88-video.c
>> +++ b/drivers/media/pci/cx88/cx88-video.c
>> @@ -470,7 +470,7 @@ static int restart_video_queue(struct cx8800_dev    *dev,
>>  			       struct cx88_dmaqueue *q)
>>  {
>>  	struct cx88_core *core = dev->core;
>> -	struct cx88_buffer *buf, *prev;
>> +	struct cx88_buffer *buf;
>>  
>>  	if (!list_empty(&q->active)) {
>>  		buf = list_entry(q->active.next, struct cx88_buffer, vb.queue);
>> @@ -480,33 +480,8 @@ static int restart_video_queue(struct cx8800_dev    *dev,
>>  		list_for_each_entry(buf, &q->active, vb.queue)
>>  			buf->count = q->count++;
>>  		mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
>> -		return 0;
>> -	}
>> -
>> -	prev = NULL;
>> -	for (;;) {
>> -		if (list_empty(&q->queued))
>> -			return 0;
>> -		buf = list_entry(q->queued.next, struct cx88_buffer, vb.queue);
>> -		if (NULL == prev) {
>> -			list_move_tail(&buf->vb.queue, &q->active);
>> -			start_video_dma(dev, q, buf);
>> -			buf->vb.state = VIDEOBUF_ACTIVE;
>> -			buf->count    = q->count++;
>> -			mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
>> -			dprintk(2,"[%p/%d] restart_queue - first active\n",
>> -				buf,buf->vb.i);
>> -
>> -		} else {
>> -			list_move_tail(&buf->vb.queue, &q->active);
>> -			buf->vb.state = VIDEOBUF_ACTIVE;
>> -			buf->count    = q->count++;
>> -			prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
>> -			dprintk(2,"[%p/%d] restart_queue - move to active\n",
>> -				buf,buf->vb.i);
>> -		}
>> -		prev = buf;
>>  	}
>> +	return 0;
>>  }
>>  
>>  /* ------------------------------------------------------------------ */
>> @@ -613,13 +588,7 @@ buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
>>  	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
>>  	buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
>>  
>> -	if (!list_empty(&q->queued)) {
>> -		list_add_tail(&buf->vb.queue,&q->queued);
>> -		buf->vb.state = VIDEOBUF_QUEUED;
>> -		dprintk(2,"[%p/%d] buffer_queue - append to queued\n",
>> -			buf, buf->vb.i);
>> -
>> -	} else if (list_empty(&q->active)) {
>> +	if (list_empty(&q->active)) {
>>  		list_add_tail(&buf->vb.queue,&q->active);
>>  		start_video_dma(dev, q, buf);
>>  		buf->vb.state = VIDEOBUF_ACTIVE;
>> @@ -1694,7 +1663,6 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
>>  
>>  	/* init video dma queues */
>>  	INIT_LIST_HEAD(&dev->vidq.active);
>> -	INIT_LIST_HEAD(&dev->vidq.queued);
>>  	dev->vidq.timeout.function = cx8800_vid_timeout;
>>  	dev->vidq.timeout.data     = (unsigned long)dev;
>>  	init_timer(&dev->vidq.timeout);
>> @@ -1703,7 +1671,6 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
>>  
>>  	/* init vbi dma queues */
>>  	INIT_LIST_HEAD(&dev->vbiq.active);
>> -	INIT_LIST_HEAD(&dev->vbiq.queued);
>>  	dev->vbiq.timeout.function = cx8800_vbi_timeout;
>>  	dev->vbiq.timeout.data     = (unsigned long)dev;
>>  	init_timer(&dev->vbiq.timeout);
>> diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
>> index ddc7991..77ec542 100644
>> --- a/drivers/media/pci/cx88/cx88.h
>> +++ b/drivers/media/pci/cx88/cx88.h
>> @@ -324,7 +324,6 @@ struct cx88_buffer {
>>  
>>  struct cx88_dmaqueue {
>>  	struct list_head       active;
>> -	struct list_head       queued;
>>  	struct timer_list      timeout;
>>  	struct btcx_riscmem    stopper;
>>  	u32                    count;


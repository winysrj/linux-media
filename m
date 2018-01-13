Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41974 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbeAMHdB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Jan 2018 02:33:01 -0500
Subject: Re: [RFT PATCH v3 6/6] uvcvideo: Move decode processing to process
 context
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
 <c857652f179fbc083a16029affefbde83a8932dc.1515748369.git-series.kieran.bingham@ideasonboard.com>
 <alpine.DEB.2.20.1801121025210.4338@axis700.grange>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <d88ac9c7-bc9d-b656-fd0f-9f8a445276f8@ideasonboard.com>
Date: Sat, 13 Jan 2018 07:32:57 +0000
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1801121025210.4338@axis700.grange>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for your review and time on this.
I certainly appreciate the extra eyes here!

On 12/01/18 09:37, Guennadi Liakhovetski wrote:
> Hi Kieran,
> 
> On Fri, 12 Jan 2018, Kieran Bingham wrote:
> 
>> Newer high definition cameras, and cameras with multiple lenses such as
>> the range of stereo-vision cameras now available have ever increasing
>> data rates.
>>
>> The inclusion of a variable length packet header in URB packets mean
>> that we must memcpy the frame data out to our destination 'manually'.
>> This can result in data rates of up to 2 gigabits per second being
>> processed.
>>
>> To improve efficiency, and maximise throughput, handle the URB decode
>> processing through a work queue to move it from interrupt context, and
>> allow multiple processors to work on URBs in parallel.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
>>
>> ---
>> v2:
>>  - Lock full critical section of usb_submit_urb()
>>
>> v3:
>>  - Fix race on submitting uvc_video_decode_data_work() to work queue.
>>  - Rename uvc_decode_op -> uvc_copy_op (Generic to encode/decode)
>>  - Rename decodes -> copy_operations
>>  - Don't queue work if there is no async task
>>  - obtain copy op structure directly in uvc_video_decode_data()
>>  - uvc_video_decode_data_work() -> uvc_video_copy_data_work()
>> ---
>>  drivers/media/usb/uvc/uvc_queue.c |  12 +++-
>>  drivers/media/usb/uvc/uvc_video.c | 116 +++++++++++++++++++++++++++----
>>  drivers/media/usb/uvc/uvcvideo.h  |  24 ++++++-
>>  3 files changed, 138 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
>> index 5a9987e547d3..598087eeb5c2 100644
>> --- a/drivers/media/usb/uvc/uvc_queue.c
>> +++ b/drivers/media/usb/uvc/uvc_queue.c
>> @@ -179,10 +179,22 @@ static void uvc_stop_streaming(struct vb2_queue *vq)
>>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
>>  	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
>>  
>> +	/* Prevent new buffers coming in. */
>> +	spin_lock_irq(&queue->irqlock);
>> +	queue->flags |= UVC_QUEUE_STOPPING;
>> +	spin_unlock_irq(&queue->irqlock);

Q_A: <label for below>

>> +
>> +	/*
>> +	 * All pending work should be completed before disabling the stream, as
>> +	 * all URBs will be free'd during uvc_video_enable(s, 0).
>> +	 */
>> +	flush_workqueue(stream->async_wq);
> 
> What if we manage to get one last URB here, then...


That will be fine. queue->flags = UVC_QUEUE_STOPPING, and thus no more items can
be added to the workqueue.

>> +
>>  	uvc_video_enable(stream, 0);
>>  

Q_B: <label for below>

>>  	spin_lock_irq(&queue->irqlock);
>>  	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
>> +	queue->flags &= ~UVC_QUEUE_STOPPING;
>>  	spin_unlock_irq(&queue->irqlock);
>>  }
>>  
>> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
>> index 3878bec3276e..fb6b5af17380 100644
>> --- a/drivers/media/usb/uvc/uvc_video.c
>> +++ b/drivers/media/usb/uvc/uvc_video.c
> 
> [snip]
> 
>> +	/*
>> +	 * When the stream is stopped, all URBs are freed as part of the call to
>> +	 * uvc_stop_streaming() and must not be handled asynchronously. In that
>> +	 * event we can safely complete the packet work directly in this
>> +	 * context, without resubmitting the URB.
>> +	 */
>> +	spin_lock_irqsave(&queue->irqlock, flags);
>> +	if (!(queue->flags & UVC_QUEUE_STOPPING)) {
>> +		INIT_WORK(&uvc_urb->work, uvc_video_copy_data_work);
>> +		queue_work(stream->async_wq, &uvc_urb->work);
>> +	} else {
>> +		uvc_video_copy_packets(uvc_urb);
> 
> Can it not happen, that if the stream is currently being stopped, the 
> queue has been flushed, possibly the previous URB or a couple of them 
> don't get decoded, but you do decode this one, creating a corrupted frame? 
> Wouldn't it be better to just drop this URB too?

I don't think so.

The only time that this uvc_video_copy_packets() can be called directly in this
context is if UVC_QUEUE_STOPPING is set, *AND* we have the lock...
Therefore we must be executing between points Q_A and Q_B above.

The flush_workqueue() will ensure that all queued work is completed.

By calling uvc_video_copy_packets() directly we are ensuring that this last
packet is also completed. The headers have already been processed at this stage
during the call to ->decode() - so all we are actually doing here is the async
memcpy work which has already been promised by the header processing, and
releasing the references on the vb2 buffers if applicable.

Any buffers not fully completed will be returned marked and returned by the call
to :

  	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);


which happens *after* label Q_B:

--
Regards

Kieran

> 
>>  	}
>> +	spin_unlock_irqrestore(&queue->irqlock, flags);
>>  }
>>  
>>  /*
> 
> Thanks
> Guennadi
> 

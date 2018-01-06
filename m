Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43478 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbeAFSh3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 6 Jan 2018 13:37:29 -0500
Subject: Re: [RFC/RFT PATCH 3/6] uvcvideo: Protect queue internals with helper
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        kieran.bingham@ideasonboard.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Baoyou Xie <baoyou.xie@linaro.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jim Lin <jilin@nvidia.com>,
        Daniel Patrick Johnson <teknotus@teknot.us>
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
 <fc4bbb70ea8937f7a09fc404520eec0f908e43d2.1515010476.git-series.kieran.bingham@ideasonboard.com>
 <alpine.DEB.2.20.1801041624460.13441@axis700.grange>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <e63de5f9-97e6-6671-f2ee-f387a8e4501c@ideasonboard.com>
Date: Sat, 6 Jan 2018 18:37:24 +0000
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1801041624460.13441@axis700.grange>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 04/01/18 18:25, Guennadi Liakhovetski wrote:
> Hi Kieran,
> 
> On Wed, 3 Jan 2018, Kieran Bingham wrote:
> 
>> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
>>
>> The URB completion operation obtains the current buffer by reading
>> directly into the queue internal interface.
>>
>> Protect this queue abstraction by providing a helper
>> uvc_queue_get_current_buffer() which can be used by both the decode
>> task, and the uvc_queue_next_buffer() functions.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> ---
>>  drivers/media/usb/uvc/uvc_queue.c | 34 +++++++++++++++++++++++++++-----
>>  drivers/media/usb/uvc/uvc_video.c |  7 +------
>>  drivers/media/usb/uvc/uvcvideo.h  |  2 ++-
>>  3 files changed, 32 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
>> index c8d78b2f3de4..0711e3d9ff76 100644
>> --- a/drivers/media/usb/uvc/uvc_queue.c
>> +++ b/drivers/media/usb/uvc/uvc_queue.c
>> @@ -399,6 +399,34 @@ void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
>>  	spin_unlock_irqrestore(&queue->irqlock, flags);
>>  }
>>  
>> +/*
>> + * uvc_queue_get_current_buffer: Obtain the current working output buffer
>> + *
>> + * Buffers may span multiple packets, and even URBs, therefore the active buffer
>> + * remains on the queue until the EOF marker.
>> + */
>> +static struct uvc_buffer *
>> +__uvc_queue_get_current_buffer(struct uvc_video_queue *queue)
>> +{
>> +	if (!list_empty(&queue->irqqueue))
>> +		return list_first_entry(&queue->irqqueue, struct uvc_buffer,
>> +					queue);
>> +	else
>> +		return NULL;
> 
> I think the preferred style is not to use "else" in such cases. It might 
> even be prettier to write
> 
> 	if (list_empty(...))
> 		return NULL;
> 
> 	return list_first_entry(...);

Ah yes, I believe you are correct.
Good spot!

Fixed, and looks much neater.

--
Kieran

> 
> Thanks
> Guennadi
> 

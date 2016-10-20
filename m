Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33224 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754410AbcJTIUM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Oct 2016 04:20:12 -0400
Subject: Re: [PATCH 1/2] [media] vb2: Store dma_dir in vb2_queue
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1476865457-506-1-git-send-email-thierry.escande@collabora.com>
 <1476865457-506-2-git-send-email-thierry.escande@collabora.com>
 <20161019212907.GT9460@valkosipuli.retiisi.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
From: Thierry Escande <thierry.escande@collabora.com>
Message-ID: <aefee886-3aed-b72f-b1c4-722b3f213399@collabora.com>
Date: Thu, 20 Oct 2016 10:20:05 +0200
MIME-Version: 1.0
In-Reply-To: <20161019212907.GT9460@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 19/10/2016 23:29, Sakari Ailus wrote:
> Hi Thierry,
>
> On Wed, Oct 19, 2016 at 10:24:16AM +0200, Thierry Escande wrote:
>> From: Pawel Osciak <posciak@chromium.org>
>>
>> Store dma_dir in struct vb2_queue and reuse it, instead of recalculating
>> it each time.
>>
>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>> Tested-by: Pawel Osciak <posciak@chromium.org>
>> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
>> Reviewed-by: Owen Lin <owenlin@chromium.org>
>> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c | 12 +++---------
>>  drivers/media/v4l2-core/videobuf2-v4l2.c |  2 ++
>>  include/media/videobuf2-core.h           |  2 ++
>>  3 files changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 21900202..f12103c 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -194,8 +194,6 @@ static void __enqueue_in_driver(struct vb2_buffer *vb);
>>  static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>>  {
>>  	struct vb2_queue *q = vb->vb2_queue;
>> -	enum dma_data_direction dma_dir =
>> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>>  	void *mem_priv;
>>  	int plane;
>>  	int ret = -ENOMEM;
>> @@ -209,7 +207,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>>
>>  		mem_priv = call_ptr_memop(vb, alloc,
>>  				q->alloc_devs[plane] ? : q->dev,
>> -				q->dma_attrs, size, dma_dir, q->gfp_flags);
>> +				q->dma_attrs, size, q->dma_dir, q->gfp_flags);
>
> My bad, I guess I expressed myself unclearly.
>
> Could you introduce the macro in this patch? You can then remove q->dma_dir
> altogether.
My bad. Sorry for the confusion...

The v3 is on its way.

Regards,
  Thierry


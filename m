Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57913
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbcHPN70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 09:59:26 -0400
Subject: Re: [PATCH] [media] vb2: move dma-buf unmap from __vb2_dqbuf() to
 vb2_buffer_done()
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
References: <1469038941-5257-1-git-send-email-javier@osg.samsung.com>
 <3b09885c-1bec-fcbe-6c6c-9c753502cb81@xs4all.nl>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Message-ID: <2c6196f7-d157-ce79-b81e-fa8c8e3ccb6e@osg.samsung.com>
Date: Tue, 16 Aug 2016 09:58:21 -0400
MIME-Version: 1.0
In-Reply-To: <3b09885c-1bec-fcbe-6c6c-9c753502cb81@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

Thanks a lot for your feedback.

On 08/13/2016 09:47 AM, Hans Verkuil wrote:
> On 07/20/2016 08:22 PM, Javier Martinez Canillas wrote:
>> Currently the dma-buf is unmapped when the buffer is dequeued by userspace
>> but it's not used anymore after the driver finished processing the buffer.
>>
>> So instead of doing the dma-buf unmapping in __vb2_dqbuf(), it can be made
>> in vb2_buffer_done() after the driver notified that buf processing is done.
>>
>> Decoupling the buffer dequeue from the dma-buf unmapping has also the side
>> effect of making possible to add dma-buf fence support in the future since
>> the buffer could be dequeued even before the driver has finished using it.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> ---
>> Hello,
>>
>> I've tested this patch doing DMA buffer sharing between a
>> vivid input and output device with both v4l2-ctl and gst:
>>
>> $ v4l2-ctl -d0 -e1 --stream-dmabuf --stream-out-mmap
>> $ v4l2-ctl -d0 -e1 --stream-mmap --stream-out-dmabuf
>> $ gst-launch-1.0 v4l2src device=/dev/video0 io-mode=dmabuf ! v4l2sink device=/dev/video1 io-mode=dmabuf-import
>>
>> And I didn't find any issues but more testing will be appreciated.
>>
>> Best regards,
>> Javier
>>
>>  drivers/media/v4l2-core/videobuf2-core.c | 34 +++++++++++++++++++++-----------
>>  1 file changed, 22 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 7128b09810be..973331efaf79 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -958,6 +958,22 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
>>  EXPORT_SYMBOL_GPL(vb2_plane_cookie);
>>  
>>  /**
>> + * __vb2_unmap_dmabuf() - unmap dma-buf attached to buffer planes
>> + */
>> +static void __vb2_unmap_dmabuf(struct vb2_buffer *vb)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < vb->num_planes; ++i) {
>> +		if (!vb->planes[i].dbuf_mapped)
>> +			continue;
>> +		call_void_memop(vb, unmap_dmabuf,
>> +				vb->planes[i].mem_priv);
> 
> Does unmap_dmabuf work in interrupt context? Since vb2_buffer_done can be called from
> an irq handler this is a concern.
>

Good point, I believe it shouldn't be called from atomic context since both
the dma_buf_vunmap() and dma_buf_unmap_attachment() functions can sleep.
 
> That said, vb2_buffer_done already calls call_void_memop(vb, finish, vb->planes[plane].mem_priv);
> to sync buffers, and that can take a long time as well. So it is not a good idea to
> have this in vb2_buffer_done.
>

I see.

> What I would like to see is to have vb2 handle this finish() call and the vb2_unmap_dmabuf
> in some workthread or equivalent.
> 
> It would complicate matters somewhat in vb2, but it would simplify drivers since these
> actions would not longer take place in interrupt context.
>
> I think this patch makes sense, but I would prefer that this is moved out of the interrupt
> context.
>

Ok, I can take a look to this and handle the finish() and unmap_dmabuf()
out of interrupt context as you suggested.

> Regards,
> 
> 	Hans
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America

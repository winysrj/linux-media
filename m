Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47126
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbcGTNjb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 09:39:31 -0400
Subject: Re: [PATCH] [media] vb2: include length in dmabuf qbuf debug message
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1468508975-6146-1-git-send-email-javier@osg.samsung.com>
 <20160720130356.GB7976@valkosipuli.retiisi.org.uk>
Cc: linux-kernel@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <dd3762b4-2e64-dc0c-81a2-b4be0e6d6ee4@osg.samsung.com>
Date: Wed, 20 Jul 2016 09:39:20 -0400
MIME-Version: 1.0
In-Reply-To: <20160720130356.GB7976@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

On 07/20/2016 09:03 AM, Sakari Ailus wrote:
> Hi Javier,
> 
> Thanks for the patch!
>

Thanks for your feedback.
 
> On Thu, Jul 14, 2016 at 11:09:34AM -0400, Javier Martinez Canillas wrote:
>> If the the VIDIOC_QBUF ioctl fails due a wrong dmabuf length,
>> it's useful to get the invalid length as a debug information.
>>
>> Before this patch:
>>
>> vb2-core: __qbuf_dmabuf: invalid dmabuf length for plane 1
>>
>> After this patch:
>>
>> vb2-core: __qbuf_dmabuf: invalid dmabuf length 221248 for plane 1
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> ---
>>
>>  drivers/media/v4l2-core/videobuf2-core.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index ca8ffeb56d72..97d1483e0f7a 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -1228,8 +1228,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
>>  			planes[plane].length = dbuf->size;
>>  
>>  		if (planes[plane].length < vb->planes[plane].min_length) {
>> -			dprintk(1, "invalid dmabuf length for plane %d\n",
>> -				plane);
>> +			dprintk(1, "invalid dmabuf length %d for plane %d\n",
> 
> %u, please. You might want to print the minimum length as well.
>

Right, it should be %u indeed. Ok, I'll add the min_length as well in v2.
 
>> +				planes[plane].length, plane);
>>  			dma_buf_put(dbuf);
>>  			ret = -EINVAL;
>>  			goto err;
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America

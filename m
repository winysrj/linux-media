Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34661
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbcHQRZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 13:25:46 -0400
Subject: Re: [RESEND PATCH] [media] vb2: Fix vb2_core_dqbuf() kernel-doc
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1471357216-23230-1-git-send-email-javier@osg.samsung.com>
 <20160817090144.GD3182@valkosipuli.retiisi.org.uk>
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <c5a6a373-4e7a-a2f3-5c61-84a9da787369@osg.samsung.com>
Date: Wed, 17 Aug 2016 13:25:34 -0400
MIME-Version: 1.0
In-Reply-To: <20160817090144.GD3182@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

On 08/17/2016 05:01 AM, Sakari Ailus wrote:
> Hi Javier,
> 
> On Tue, Aug 16, 2016 at 10:20:16AM -0400, Javier Martinez Canillas wrote:
>> The kernel-doc has the wrong function name and also the pindex
>> parameter is missing in the documentation.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> ---
>>
>> This patch was posted some weeks ago but I noticed that wasn't
>> picked by patchwork, so I'm resend it.
>>
>>  drivers/media/v4l2-core/videobuf2-core.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index ca8ffeb56d72..1dbd7beb71f0 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -1726,8 +1726,9 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
>>  }
>>  
>>  /**
>> - * vb2_dqbuf() - Dequeue a buffer to the userspace
>> + * vb2_core_dqbuf() - Dequeue a buffer to the userspace
>>   * @q:		videobuf2 queue
>> + * @pindex:	id number of the buffer
> 
> How about: "Pointer to the buffer index. May be NULL.".
>

Sure, I'll change it.
 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>

Thanks.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America

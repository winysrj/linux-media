Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46886
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbcGROP2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 10:15:28 -0400
Subject: Re: [PATCH] [media] vb2: map dmabuf for planes on driver queue
 instead of vidioc_qbuf
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
References: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
 <ee857812-cf05-b714-eb6e-b696767a0067@xs4all.nl>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	m.olbrich@pengutronix.de
Message-ID: <ee011ede-3a3a-a2ff-50e5-8814b977d4ae@osg.samsung.com>
Date: Mon, 18 Jul 2016 10:15:14 -0400
MIME-Version: 1.0
In-Reply-To: <ee857812-cf05-b714-eb6e-b696767a0067@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans, Michael and Marek,

Thanks a lot for your feedback.

On 07/18/2016 04:34 AM, Hans Verkuil wrote:
> On 07/15/2016 06:26 PM, Javier Martinez Canillas wrote:
>> The buffer planes' dma-buf are currently mapped when buffers are queued
>> from userspace but it's more appropriate to do the mapping when buffers
>> are queued in the driver since that's when the actual DMA operation are
>> going to happen.
> 
> Does this solve anything? Once the DMA has started the behavior is the same
> as before (QBUF maps the dmabuf), only while the DMA engine hasn't started
> yet are the QBUF calls just accepted and the mapping takes place when the
> DMA is kickstarted. This makes QBUF behave inconsistently.
> 
> You don't describe here WHY this change is needed.
>

Nicolas pointed me to the TODO and suggested me the patch for the reasons
he explained in his latest email. And yes, this should had been tagged as
a RFC and just to know what you think about it. Sorry for missing that.

> I'm not sure I agree with the TODO, and even if I did, I'm not sure I agree
> with this solution. Since queuing the buffer to the driver is not the same
> as 'just before the DMA', since there may be many buffers queued up in the
> driver and you don't know in vb2 when the buffer is at the 'just before the DMA'
> stage.
>

Right, I meant "as closer as possible to when the actual DMA is going to happen"
rather than "just before the DMA".

> Regards,
> 
> 	Hans
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America

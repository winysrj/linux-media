Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:21118 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1174057AbdDXUBG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 16:01:06 -0400
Subject: Re: [PATCH 1/2] [media] vb2: Fix an off by one error in
 'vb2_plane_vaddr'
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20170423213257.14773-1-christophe.jaillet@wanadoo.fr>
 <20170424141655.GQ7456@valkosipuli.retiisi.org.uk>
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <9aab41eb-5543-58d2-211f-95fb00f5176c@wanadoo.fr>
Date: Mon, 24 Apr 2017 22:00:24 +0200
MIME-Version: 1.0
In-Reply-To: <20170424141655.GQ7456@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 24/04/2017 à 16:16, Sakari Ailus a écrit :
> On Sun, Apr 23, 2017 at 11:32:57PM +0200, Christophe JAILLET wrote:
>> We should ensure that 'plane_no' is '< vb->num_planes' as done in
>> 'vb2_plane_cookie' just a few lines below.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/media/v4l2-core/videobuf2-core.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 94afbbf92807..c0175ea7e7ad 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -868,7 +868,7 @@ EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
>>   
>>   void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
>>   {
>> -	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
>> +	if (plane_no >= vb->num_planes || !vb->planes[plane_no].mem_priv)
>>   		return NULL;
>>   
>>   	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
> Oh my. How could this happen?
>
> This should go to stable as well.
Should I resubmit with "Cc: stable@vger.kernel.org" or will you add it 
yourself?

CJ

> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>

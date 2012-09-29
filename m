Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65462 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab2I2GYu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 02:24:50 -0400
Received: by obbuo13 with SMTP id uo13so3605045obb.19
        for <linux-media@vger.kernel.org>; Fri, 28 Sep 2012 23:24:50 -0700 (PDT)
Message-ID: <5066942B.7070207@linaro.org>
Date: Sat, 29 Sep 2012 11:54:43 +0530
From: Sumit Semwal <sumit.semwal@linaro.org>
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: Rob Clark <rob.clark@linaro.org>, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	patches@linaro.org, daniel.vetter@ffwll.ch, Rob Clark <rob@ti.com>
Subject: Re: [PATCH] dma-buf: might_sleep() in dma_buf_unmap_attachment()
References: <1348817383-30286-1-git-send-email-rob.clark@linaro.org> <50655414.2060400@canonical.com>
In-Reply-To: <50655414.2060400@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 28 September 2012 01:09 PM, Maarten Lankhorst wrote:
> Op 28-09-12 09:29, Rob Clark schreef:
>> From: Rob Clark <rob@ti.com>
>>
>> We never really clarified if unmap could be done in atomic context.
>> But since mapping might require sleeping, this implies mutex in use
>> to synchronize mapping/unmapping, so unmap could sleep as well.  Add
>> a might_sleep() to clarify this.
>>
>> Signed-off-by: Rob Clark <rob@ti.com>
>> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> ---
>>   drivers/base/dma-buf.c |    2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
>> index c30f3e1..877eacb 100644
>> --- a/drivers/base/dma-buf.c
>> +++ b/drivers/base/dma-buf.c
>> @@ -298,6 +298,8 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>>   				struct sg_table *sg_table,
>>   				enum dma_data_direction direction)
>>   {
>> +	might_sleep();
>> +
>>   	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
>>   		return;
>>
> Looks good to me!
>
> Reviewed-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Thanks Rob,

Applied to for-next.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


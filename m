Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46608
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbcGNNgr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 09:36:47 -0400
Subject: Re: [PATCH] media: s5p-mfc remove unnecessary error messages
To: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
	k.debski@samsung.com, jtp.park@samsung.com, mchehab@kernel.org
References: <1468370038-5364-1-git-send-email-shuahkh@osg.samsung.com>
 <c38dc1b5-e2f7-4486-a0fc-a8f690d28fe6@osg.samsung.com>
 <5787951B.2050401@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <f37d0d12-6ba8-58db-1ec9-31008d4f7ace@osg.samsung.com>
Date: Thu, 14 Jul 2016 09:36:36 -0400
MIME-Version: 1.0
In-Reply-To: <5787951B.2050401@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Shuah,

On 07/14/2016 09:35 AM, Shuah Khan wrote:
> On 07/14/2016 06:46 AM, Javier Martinez Canillas wrote:
>> Hello Shuah,
>>
>> On 07/12/2016 08:33 PM, Shuah Khan wrote:
>>> Removing unnecessary error messages as appropriate error code is returned.
>>>
>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>> ---
>>>  drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 --
>>>  1 file changed, 2 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>>> index b6fde20..906f80c 100644
>>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>>> @@ -759,7 +759,6 @@ static int s5p_mfc_open(struct file *file)
>>>  	/* Allocate memory for context */
>>>  	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>>>  	if (!ctx) {
>>> -		mfc_err("Not enough memory\n");
>>
>> I agree to remove this since in case of a OOM, the core already does a
>> stack dump and prints an error message so there's no need to it here.
>>
>>>  		ret = -ENOMEM;
>>>  		goto err_alloc;
>>>  	}
>>> @@ -776,7 +775,6 @@ static int s5p_mfc_open(struct file *file)
>>>  	while (dev->ctx[ctx->num]) {
>>>  		ctx->num++;
>>>  		if (ctx->num >= MFC_NUM_CONTEXTS) {
>>> -			mfc_err("Too many open contexts\n");
>>
>> But I think this error message shouldn't be removed since explains why
>> the open failed, even when an error code is returned.
> 
> This message isn't very informative and not sure if it is giving
> any more information than EBUSY. It is a good debug message perhaps,
> but not an error message. Would it be okay if I made it debug instead.
>

Making it a debug message sounds good to me.
 
> thanks,
> -- Shuah
>>
>>>  			ret = -EBUSY;
>>>  			goto err_no_ctx;
>>>  		}
>>>
>>
>> Best regards,
>>
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35110 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdFAVhQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Jun 2017 17:37:16 -0400
Subject: Re: [PATCH] media: platform: s3c-camif: fix function prototype
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <20170504214200.GA22855@embeddedgus>
 <ea039557-023c-736d-5bfb-928cd87cc3e3@xs4all.nl>
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Message-ID: <da5c5727-628d-1887-368c-970d5308ee72@gmail.com>
Date: Thu, 1 Jun 2017 23:37:11 +0200
MIME-Version: 1.0
In-Reply-To: <ea039557-023c-736d-5bfb-928cd87cc3e3@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/22/2017 11:02 AM, Hans Verkuil wrote:
>> --- a/drivers/media/platform/s3c-camif/camif-regs.c
>> +++ b/drivers/media/platform/s3c-camif/camif-regs.c
>> @@ -58,7 +58,7 @@ void camif_hw_set_test_pattern(struct camif_dev *camif, unsigned int pattern)
>>   }
>>   
>>   void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
>> -			unsigned int cr, unsigned int cb)
>> +			unsigned int cb, unsigned int cr)
>>   {
>>   	static const struct v4l2_control colorfx[] = {
>>   		{ V4L2_COLORFX_NONE,		CIIMGEFF_FIN_BYPASS },
>
> This will also affect this line:
> 
> cfg |= cr | (cb << 13);
> 
> cr and cb are now swapped so this will result in a different color.
> 
> Sylwester, who is wrong here: the prototype or how this function is called?
> 
> I suspect that Gustavo is right and that the prototype is wrong. But in that
> case this patch should also change the cfg assignment.

The function is currently called in a wrong way, it's clear from looking
at the prototype. CR should end up in bits 0:7 and CR in bits 20:13 of
the register. So yes, colour will change after applying the patch - to the
expected one, matching the user API documentation.

Unfortunately I can't test it because I have only the s3c2440 SoC based 
evaluation board where the image effect is not supported.

Probably a more straightforward fix would be to amend the callers (apologies
Gustavo for misleading suggestions).  But I'm inclined to apply the $subject 
patch as is to just close this bug report case.

--
Regards,
Sylwester

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:61130 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3JNE06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Oct 2013 00:26:58 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <525B7295.1070607@samsung.com>
Date: Mon, 14 Oct 2013 13:27:01 +0900
From: Seung-Woo Kim <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com, Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCH] s5p-jpeg: fix uninitialized use in hdr parse
References: <1381388791-1828-1-git-send-email-sw0312.kim@samsung.com>
 <525918C1.7090704@gmail.com>
In-reply-to: <525918C1.7090704@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for you comment.

On 2013년 10월 12일 18:39, Sylwester Nawrocki wrote:
> Hi Seung-Woo,
> 
> On 10/10/2013 09:06 AM, Seung-Woo Kim wrote:
>> For hdr parse error, it can return false without any assignments
>> which cause build warning.
>>
>> Signed-off-by: Seung-Woo Kim<sw0312.kim@samsung.com>
>> ---
>>   drivers/media/platform/s5p-jpeg/jpeg-core.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c
>> b/drivers/media/platform/s5p-jpeg/jpeg-core.c
>> index 15d2396..7db374e 100644
>> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
>> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
>> @@ -442,14 +442,14 @@ static bool s5p_jpeg_parse_hdr(struct
>> s5p_jpeg_q_data *result,
>>       while (notfound) {
>>           c = get_byte(&jpeg_buffer);
>>           if (c == -1)
>> -            break;
>> +            return false;
> 
> notfound is being assigned before entering the while loop, so I'm not sure
> what exactly is not correct here. Can you quote the original build
> warning ?

Here is the build warning.

drivers/media/platform/s5p-jpeg/jpeg-core.c: In function
's5p_jpeg_parse_hdr':
drivers/media/platform/s5p-jpeg/jpeg-core.c:432: warning: 'components'
may be used uninitialized in this function
drivers/media/platform/s5p-jpeg/jpeg-core.c:433: warning: 'height' may
be used uninitialized in this function
drivers/media/platform/s5p-jpeg/jpeg-core.c:433: warning: 'width' may be
used uninitialized in this function

> It's a good idea to always include compiler errors/warnings in the commit
> message.

Right, I'll repost with warning message.

> 
> BTW, name of the variable is a bit confusing, I think naming it 'found' and
> using negation of it would be easier to follow; that's not something we'd
> be changing now though.
> 
>>           if (c != 0xff)
>>               continue;
>>           do
>>               c = get_byte(&jpeg_buffer);
>>           while (c == 0xff);
>>           if (c == -1)
>> -            break;
>> +            return false;
>>           if (c == 0)
>>               continue;
>>           length = 0;
> 
> Thanks,
> Sylwester
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--


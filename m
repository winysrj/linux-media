Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54988 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758374AbaDII2k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 04:28:40 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3R00M0L8VH0Z60@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 Apr 2014 09:28:29 +0100 (BST)
Message-id: <534504B6.2020202@samsung.com>
Date: Wed, 09 Apr 2014 10:28:38 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 7/8] [media] s5p_jpeg: Prevent JPEG 4:2:0 > YUV 4:2:0
 decompression
References: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
 <1396876573-15811-7-git-send-email-j.anaszewski@samsung.com>
 <CAK9yfHxXRXagZVAZhGjqH+qVGTAdP-=PnFw4O7HEU09UNB5Tsg@mail.gmail.com>
 <5344F747.6080103@samsung.com>
 <CAK9yfHz+F=pfNN7nQn-HE5L=uux+cVhBRoHa4wMjRT1VZTRTyw@mail.gmail.com>
In-reply-to: <CAK9yfHz+F=pfNN7nQn-HE5L=uux+cVhBRoHa4wMjRT1VZTRTyw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/09/2014 09:56 AM, Sachin Kamat wrote:
> Hi Jacek,
>
> On 9 April 2014 13:01, Jacek Anaszewski <j.anaszewski@samsung.com> wrote:
>> On 04/08/2014 09:49 AM, Sachin Kamat wrote:
>>>
>
>> Hello Sachin,
>>
>> Thanks for the review. I put it into info message because this is
>> rather hard for the user to figure out why the adjustment occurred,
>> bearing in mind that JPEG with the same subsampling and even width
>> is decompressed properly. This is not a common adjustment like
>> alignment, and thus in my opinion it requires displaying the
>> information. Are there some rules that say what cases are relevant
>> for using the v4l2_info macro?
>
> Not really, but generally info messages are concise and detailed explanations
> provided as part of comments.
>

Thanks for the explanation, I will stick to it.

Regards,
Jacek Anaszewski

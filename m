Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3672 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbaIEJaV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Sep 2014 05:30:21 -0400
Message-ID: <54098295.8060600@xs4all.nl>
Date: Fri, 05 Sep 2014 11:29:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, stoth@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 17/20] cx23885: fix weird sizes.
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl> <1408010045-24016-18-git-send-email-hverkuil@xs4all.nl> <20140903084624.2cc523b8.m.chehab@samsung.com> <5407048C.1050601@xs4all.nl> <20140903091639.4ec7c996.m.chehab@samsung.com>
In-Reply-To: <20140903091639.4ec7c996.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2014 02:16 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 03 Sep 2014 14:07:40 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 09/03/14 13:46, Mauro Carvalho Chehab wrote:
>>> Em Thu, 14 Aug 2014 11:54:02 +0200
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> These values make no sense. All SDTV standards have the same width.
>>>> This seems to be copied from the cx88 driver. Just drop these weird
>>>> values.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>  drivers/media/pci/cx23885/cx23885.h | 6 +++---
>>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
>>>> index 99a5fe0..f542ced 100644
>>>> --- a/drivers/media/pci/cx23885/cx23885.h
>>>> +++ b/drivers/media/pci/cx23885/cx23885.h
>>>> @@ -610,15 +610,15 @@ extern int cx23885_risc_databuffer(struct pci_dev *pci,
>>>>  
>>>>  static inline unsigned int norm_maxw(v4l2_std_id norm)
>>>>  {
>>>> -	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 720 : 768;
>>>> +	return 720;
>>>
>>> Not sure if you checked cx23885 datasheet. I didn't, but I don't doubt
>>> that it uses about the same A/D logic as cx88.
>>>
>>> In the case of cx88, the sampling rate for a few standards is different,
>>> as recommended at the datasheet. This is done to provide the highest
>>> image quality, as there are some customized filters for some standards,
>>> but they require some specific sampling rates. That's why PAL-Nc and
>>> NTSC/PAL-M are handled on a different way.
>>
>> I will double-check what the datasheet has to say about this. And if there
>> is a good reason for this then I will add a comment at the very least.
> 
> OK.

I checked the cx23883 datasheet that I have and it does not mention anything
about PAL-Nc/NTSC/PAL-M. What it does mention is that for 50 Hz formats the
768x576 format will give you square pixels (just as 640x480 does for NTSC),
so in order to be able to get frames with square pixels it makes sense to
support 768 as the max width for 50 Hz formats. I see nothing about image
quality, as far as I can tell it is just about square vs non-square pixels.

So norm_maxw should read:

	/* 768 x 576 gives square pixels for 50 Hz formats */
	return (norm & V4L2_STD_525_60) ? 720 : 768;

That makes sense.

I don't have a cx88 datasheet, so can you verify if that datasheet says the
same thing?

Thanks,

	Hans

> 
>>
>>>
>>>>  }
>>>>  
>>>>  static inline unsigned int norm_maxh(v4l2_std_id norm)
>>>>  {
>>>> -	return (norm & V4L2_STD_625_50) ? 576 : 480;
>>>> +	return (norm & V4L2_STD_525_60) ? 480 : 576;
>>>
>>> This is obviously wrong.
>>
>> What is wrong? The original code or the new code? They are both right.
> 
> I think I expressed myself badly. I meant to say: the original code were
> obviously wrong.
> 
> Basically, I agreed with you there ;)
> 
> Regards,
> Mauro
> 


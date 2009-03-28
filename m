Return-path: <linux-media-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:61096 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbZC1CRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 22:17:34 -0400
Received: by wa-out-1112.google.com with SMTP id j5so845680wah.21
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2009 19:17:32 -0700 (PDT)
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"Kim, Heung Jun" <riverful@gmail.com>,
	Bill Dirks <bill@thedirks.org>, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, dongsoo45.kim@samsung.com
Message-Id: <9FB01D5C-4894-4513-8962-7294E0D85EBD@gmail.com>
From: Dongsoo Kim <dongsoo.kim@gmail.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
In-Reply-To: <200903271719.00404.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=EUC-KR; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: how about adding FOCUS mode?
Date: Sat, 28 Mar 2009 11:17:27 +0900
References: <b64afca20903262320g1bd35163lcce41724dd5db965@mail.gmail.com> <200903270824.28092.hverkuil@xs4all.nl> <200903271719.00404.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


2009. 03. 28, 오전 1:19, Laurent Pinchart 작성:

> Hi,
>
> On Friday 27 March 2009 08:24:27 Hans Verkuil wrote:
>> On Friday 27 March 2009 07:20:51 Kim, Heung Jun wrote:
>>> Hello, Hans & everyone.
>>>
>>> I'm trying to adapt the various FOCUS MODE int the NEC ISP driver.
>>> NEC ISP supports 4 focus mode, AUTO/MACRO/MANUAL/FULL or NORMAL.
>>> but, i think that it's a little insufficient to use V4L2 FOCUS  
>>> Feature.
>>>
>>> so, suggest that,
>>>
>>> - change V4L2_CID_FOCUS_AUTO's type from boolean to interger, and  
>>> add
>>> the following enumerations for CID values.
>>>
>>> enum v4l2_focus_mode {
>>>    V4L2_FOCUS_AUTO            = 0,
>>>    V4L2_FOCUS_MACRO        = 1,
>>>    V4L2_FOCUS_MANUAL        = 2,
>>>    V4L2_FOCUS_NORMAL        = 3,
>>>    V4L2_FOCUS_LASTP        = 3,
>>> };
>>>
>>> how about this usage? i wanna get some advice about FOCUS MODE.
>
> V4L2_CID_FOCUS_AUTO is meant to change the auto-focus mode. Can you  
> describe
> FOCUS_MACRO and FOCUS_NORMAL in more details ? Are they auto-focus  
> modes or
> just focus presets ?


As far as I know, they represent focus lens movement range.
If you set to AF macro, focus lens scans near range first, so that  
focusing movement could finish earlier.


>
>
>> This seems more logical to me:
>>
>> enum v4l2_focus_mode {
>>    V4L2_FOCUS_MANUAL = 0,
>>    V4L2_FOCUS_AUTO_NORMAL = 1,
>>    V4L2_FOCUS_AUTO_MACRO = 2,
>> };
>>
>> At least this maps the current boolean values correctly. I'm not  
>> sure from
>> your decription what the fourth auto focus mode is supposed to be.
>
> Does an auto-macro focus mode really exists ?


Sure, you can find in some digital camera or brand new high end camera  
phones.

By the way, sorry for answering instead of heungjun Kim. I work with  
him actually.
Is it OK?

Cheers,

Nate

>
>
>> But I think it might be better to have a separate control that  
>> allows you
>> to set the auto-focus mode. I can imagine that different devices  
>> might have
>> different auto-focus modes.
>>
>> I've CC-ed Laurent since this is more his field than mine.
>
> Regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


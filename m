Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46422C10F05
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 12:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BDC6213F2
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 12:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfCTMlq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 08:41:46 -0400
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:48029 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727222AbfCTMlq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 08:41:46 -0400
Received: from [IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e] ([IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 6aXOhd6fOeXb86aXPhCHaE; Wed, 20 Mar 2019 13:41:44 +0100
Subject: Re: [PATCH v5 02/23] videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org,
        helen.koike@collabora.com, Hans Verkuil <hverkuil-cisco@xs4all.nl>
References: <20190306211343.15302-1-dafna3@gmail.com>
 <20190306211343.15302-3-dafna3@gmail.com> <20190320071112.4ed71c54@coco.lan>
 <ca97c48b-3b7f-3c97-ec19-54469604fe79@xs4all.nl>
 <20190320084239.7e58aa05@coco.lan>
 <fe5b914b-1775-496a-20cc-c7fb01eb01d1@xs4all.nl>
 <20190320093754.5992c89e@coco.lan>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <10b33081-7b79-bae9-6325-1904d76f3717@xs4all.nl>
Date:   Wed, 20 Mar 2019 13:41:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190320093754.5992c89e@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEW4XCz39hceCuox4RntGsTHAVkoNGOdShNw+YtMfIbugw3WnNv7G9RewnuVq30lCvZ0b4IB9AWOXPuJPIbMbN2BoZjlWATfwUGXG6/pjnWZKRz/iXSp
 f3Yak8TQVDFm5F9gSN9/lu8xRYY9bJ0cJ5r8jIczOWgrwhVIg45jYNqU2nFapIDUQ8TF3xDwPy9+ab+nINk6Zu+I4CO34Si+rax/cFlCxQHtoPMQCxiCC6kS
 FXUJbVYW7wAyIrTFwLkAPAtBltY0H5w1WbuIrlSlTWOVEbLyvrD7xT9a3ViKng57Ii90KwGB9hX0DuZuEM/54YPtdeBq+n5HQy/qb7aiC7cdN6Dicoa/E+3K
 FihD/sCFnnDhC/IrXaUsnU2/06+b2KyCYErXlC8G8oznhIHHIGRBNXzOv8PI9zQzf3tEi/Qc
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/20/19 1:37 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 20 Mar 2019 13:20:07 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>>>> The only affected driver is the staging cedrus driver. And that will
>>>> actually crash if you try to use it without requests.
>>>>
>>>> If you look at patch 3 you'll see that it just sets the flag and doesn't
>>>> remove any code that was supposed to check for use-without-requests.
>>>> That's because there never was a check and the driver would just crash.
>>>>
>>>> So we're safe here.  
>>>
>>> Making it mandatory for the cedrus driver makes sense, but no other
>>> current driver should ever use it.   
>>
>> The only other drivers that implement the request API are vivid and vim2m.
>>
>> For both the request API is optional.
>>
>> And of course this patch series that adds the stateless decoder support to
>> vicodec, so vicodec is the only other driver besides the cedrus driver that
>> sets this flag.
> 
> The current vicodec implementation is only stateless?

vicodec before this series is only stateful. After this series a new video node
is added which is for the stateless decoder. And that device will require
requests.

> 
>>> The problem I see is that, as we advance on improving the requests API,
>>> non-stateless-codec drivers may end supporting the request API. 
>>> That's perfectly fine, but such other drivers should *never* be
>>> changed to use V4L2_BUF_CAP_REQUIRES_REQUESTS. This also applies to any
>>> new driver that it is not implementing a stateless codec.
>>>
>>> Btw, as this seems to be a requirement only for stateless codec drivers,
>>> perhaps we should (at least in Kernelspace) to use, instead, a
>>> V4L2_BUF_CAP_STATELESS_CODEC_ONLY flag, with the V4L2 core would
>>> translate it to V4L2_BUF_CAP_REQUIRES_REQUESTS before returning it to
>>> userspace, and have a special #ifdef at the userspace header, in order
>>> to prevent this flag to be set directly by a random driver.  
>>
>> I don't think this makes sense. Requiring requests is not something you
>> can miss since you have to code for it.
>>
>> However, there is something else that we need to think about and that is
>> that V4L2_BUF_CAP_REQUIRES_REQUESTS can be format specific. E.g. a stateless
>> codec driver can also support a JPEG codec, and for that format requests
>> are most likely not required at all. So this capability might actually be
>> format-specific.
> 
> Yes, on formats that don't have temporal compression, there's no sense
> to make request API mandatory.
> 
> For formats that have temporal compression, the codec driver can either 
> be stateless or stateful (or even support both modes).
> 
> It sounds to me that a flag like that should be returned by S_FMT and
> TRY_FMT or on a separate ioctl.
> 
> It also seems to make sense if userspace could select between stateless
> and stateful modes, if the driver supports both modes for the same
> fourcc.

That can't happen. The stateless formats have their own fourcc. It really
is a different format.

Regards,

	Hans

> 
>> I've decided to drop the patch adding this capability flag. The vb2
>> requires_requests flag remains, as does the EBADR error code + updated
>> documentation for that error code, since that is still needed. But signaling
>> to userspace that it is required is something we can add later when we have
>> a bit more time to think about it.
> 
> Ok.
> 
>>
>> I'll respin and repost the series.
>>
>> Regards,
>>
>> 	Hans
>>
>>>   
>>>>
>>>> I believe patches 1-3 make sense, but I also agree that the documentation
>>>> and commit logs can be improved.
>>>>
>>>> I can either respin with updated patches 1-3, or, if you still have concerns,
>>>> drop 1-3 and repost the remainder of the series. But then I'll need to add
>>>> checks against the use of the stateless vicodec decoder without requests in
>>>> patch 21/23.  
>>>
>>> Whatever you prefer. If the remaining patches don't require it, you could
>>> just tag the pull request as new and ping me on IRC. I'll review the remaining
>>> ones, skipping the V4L2_BUF_CAP_REQUIRES_REQUESTS specific patches.
>>>   
>>>>
>>>> But this really doesn't belong in a driver. These checks should be done in the
>>>> vb2 core.  
>>>
>>> Yeah, I agree.
>>>   
>>>>
>>>> Regards,
>>>>
>>>> 	Hans
>>>>  
>>>>>
>>>>>     
>>>>>>  
>>>>>>  Return Value
>>>>>>  ============
>>>>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>>>>> index 1db220da3bcc..97e6a6a968ba 100644
>>>>>> --- a/include/uapi/linux/videodev2.h
>>>>>> +++ b/include/uapi/linux/videodev2.h
>>>>>> @@ -895,6 +895,7 @@ struct v4l2_requestbuffers {
>>>>>>  #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
>>>>>>  #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
>>>>>>  #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
>>>>>> +#define V4L2_BUF_CAP_REQUIRES_REQUESTS	(1 << 5)
>>>>>>  
>>>>>>  /**
>>>>>>   * struct v4l2_plane - plane info for multi-planar buffers    
>>>>>
>>>>>
>>>>>
>>>>> Thanks,
>>>>> Mauro
>>>>>     
>>>>  
>>>
>>>
>>>
>>> Thanks,
>>> Mauro
>>>   
>>
> 
> 
> 
> Thanks,
> Mauro
> 


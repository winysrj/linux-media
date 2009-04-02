Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:16860 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZDBNPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 09:15:05 -0400
Received: by rv-out-0506.google.com with SMTP id f9so621342rvb.1
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 06:15:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49D4B12C.2050601@gmail.com>
References: <49D37485.7030805@gmail.com> <49D3788D.2070406@gmail.com>
	 <87zlf0cl7o.fsf@free.fr> <49D3AE13.9070201@gmail.com>
	 <87r60cmd94.fsf@free.fr>
	 <Pine.LNX.4.64.0904012359260.5389@axis700.grange>
	 <49D4B12C.2050601@gmail.com>
Date: Thu, 2 Apr 2009 21:15:03 +0800
Message-ID: <d82e647a0904020615x4a491fdk23c87559108f6d5f@mail.gmail.com>
Subject: Re: soc_camera_open() not called
From: Ming Lei <tom.leiming@gmail.com>
To: Darius Augulis <augulis.darius@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/4/2 Darius Augulis <augulis.darius@gmail.com>:
> Guennadi Liakhovetski wrote:
>>
>> On Wed, 1 Apr 2009, Robert Jarzmik wrote:
>>
>>> Darius Augulis <augulis.darius@gmail.com> writes:
>>>
>>>>>> Darius Augulis wrote:
>>>>>>
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> I'm trying to launch mx1_camera based on new v4l and soc-camera tree.
>>>>>>> After loading mx1_camera module, I see that .add callback is not
>>>>>>> called.
>>>>>>> In debug log I see that soc_camera_open() is not called too.
>>>>>>> What should call this function? Is this my driver problem?
>>>>>>> p.s. loading sensor driver does not change situation.
>>>>>>>
>>>>>
>>>>> Are you by any chance using last 2.6.29 kernel ?
>>>>> If so, would [1] be the answer to your question ?
>>>>>
>>>>> [1] http://lkml.org/lkml/2009/3/24/625
>>>>
>>>> thanks. it means we should expect soc-camera fix for this?
>>>> I'm using 2.6.29-git8, but seems it's not fixed yet.
>>>
>>> No, I don't think so.
>>
>> You're right.
>>
>>> The last time I checked there had to be an amendement to the patch which
>>> introduced the driver core regression, as it touches other areas as well
>>> (sound/soc and mtd from memory).
>>>
>>> I think Guennadi can confirm this, as he's the one who raised the issue
>>> in the
>>> first place.
>>
>> If Darius had followed the thread you referred to he would have come down
>> to this message
>>
>> http://lkml.org/lkml/2009/3/26/202
>>
>> which provides a reply as to "what should be fixed," and yes, Ming Lei has
>> already provided a patch to fix this, it should hit mainstream... some time
>> before -rc1.
>
> could you please send me this patch or show where is it available?

http://marc.info/?l=linux-kernel&m=123816184309698&w=2

Thanks!

>
>>
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>



-- 
Lei Ming

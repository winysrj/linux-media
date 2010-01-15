Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms01.sssup.it ([193.205.80.99]:47877 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752283Ab0AOIid (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 03:38:33 -0500
Message-ID: <4B502982.4050508@panicking.kicks-ass.org>
Date: Fri, 15 Jan 2010 09:38:26 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap34xxcam question?
References: <4B4F0762.4040007@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE894451538FFB@dlee02.ent.ti.com> <4B4F537B.7000708@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE894451539065@dlee02.ent.ti.com> <4B4F56C8.7060108@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE894451539623@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894451539623@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre, Sergio wrote:
> 
>> -----Original Message-----
>> From: Michael Trimarchi [mailto:michael@panicking.kicks-ass.org]
>> Sent: Thursday, January 14, 2010 11:39 AM
>> To: Aguirre, Sergio
>> Cc: linux-media@vger.kernel.org
>> Subject: Re: omap34xxcam question?
>>
>> Aguirre, Sergio wrote:
>>>> -----Original Message-----
>>>> From: Michael Trimarchi [mailto:michael@panicking.kicks-ass.org]
>>>> Sent: Thursday, January 14, 2010 11:25 AM
>>>> To: Aguirre, Sergio
>>>> Cc: linux-media@vger.kernel.org
>>>> Subject: Re: omap34xxcam question?
>>>>
>>>> Hi,
>>>>
>>>> Aguirre, Sergio wrote:
>>>>>> -----Original Message-----
>>>>>> From: Michael Trimarchi [mailto:michael@panicking.kicks-ass.org]
>>>>>> Sent: Thursday, January 14, 2010 6:01 AM
>>>>>> To: linux-media@vger.kernel.org
>>>>>> Cc: Aguirre, Sergio
>>>>>> Subject: omap34xxcam question?
>>>>>>
>>>>>> Hi
>>>>>>
>>>>>> Is ok that it try only the first format and size? why does it not
>>>> continue
>>>>>> and find a matching?
>>>>> Actually, that was the intention, but I guess it was badly
>> implemented.
>>>>> Thanks for the catch, and the contribution!
>>>>>
>>>>> Regards,
>>>>> Sergio
>>>>>> @@ -470,7 +471,7 @@ static int try_pix_parm(struct
>> omap34xxcam_videodev
>>>>>> *vdev,
>>>>>>                         pix_tmp_out = *wanted_pix_out;
>>>>>>                         rval = isp_try_fmt_cap(isp, &pix_tmp_in,
>>>>>> &pix_tmp_out);
>>>>>>                         if (rval)
>>>>>> -                               return rval;
>>>>>> +                               continue;
>>>>>>
>>>> Is the patch good? or you are going to provide a better fix
>>> Yes. Sorry if I wasn't clear enough.
>>>
>>> Looks good to me, and I don't have a better fix on top of my head for
>> the moment...
>>> I'm assuming you tested it in your environment, right?
>> Ok, my enviroment is not pretty stable but for sure this is required.
>> There is one problem:
>>
>> Suppose that the camera support this format:
>>
>> YUV and RAW10
>>
>> The video4linux enumeration is done in this order.
>> We know that if you want to use resizer and previewer we can't use the YUV
>> (go straight to memory)
>> but it is selected because is the first. So maybe the best thing is to
>> find the one that is suggest in the csi
>> configuration first. Hope that is clear.
> 
> Hmm.. I see.
> 
> So, if I got you right, you're saying that, there should be priorities for sensor baseformats, depending on the preference specified somewhere in the boardfile?

Yes, that is the idea. Try to provide a better patch later, I'm working hard on the sensor part :)

Michael

> 
> Regards,
> Sergio
>> Michael
>>
>>> If yes, then I'll take the patch in my queue for submission to Sakari's
>> tree.
>>> Thanks for your time.
>>>
>>> Regards,
>>> Sergio
>>>
>>>> Michael
>>>>
>>>>>> Michael
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


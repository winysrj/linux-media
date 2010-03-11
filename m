Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:43442 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173Ab0CKQpu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 11:45:50 -0500
Received: by fg-out-1718.google.com with SMTP id l26so2809363fgb.1
        for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 08:45:49 -0800 (PST)
Message-ID: <4B991E4B.1030209@gmail.com>
Date: Fri, 12 Mar 2010 02:46:03 +1000
From: Jed <jedi.theone@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hw capabilities of the HVR-2200
References: <4AAF568D.1070308@gmail.com> <4AB3B43A.2030103@gmail.com> <4AB3B947.1040202@kernellabs.com> <4AB3C17D.1030300@gmail.com> <4AB3C8E5.4010700@kernellabs.com> <4AB3CDC2.20505@gmail.com> <4B968267.3090808@gmail.com> <4B990E76.2010603@kernellabs.com>
In-Reply-To: <4B990E76.2010603@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

*woops*
Just saw your status update from 24/01, sigh, doesn't sound good :(
http://www.kernellabs.com/blog/?p=1339

>> 19/09/09 Jed wrote:
>>>>>>>> 2) Component input for the A/V-in
>>>>>>
>>>>>> Yes, this exists on the HVR2250 product only.
>>>>>
>>>>> Ah shite, are you sure?
>>>>> If you look at the specs for the reference card it was there, did they
>>>>> take it out at the last minute?
>>>>
>>>> It's not feature Hauppauge supports on the HVR2200 today. I have a
>>>> suspicion this may change but I'm neither confirming, denying or
>>>> announcing anything. It would make sense to officially support
>>>> component cables on the HVR2200 since the silicon supports it.
>>>> If/when it does I'm sure it will be mentioned in the forums or on the
>>>> HVR2200 product packaging.
>>
>> Hi Steve, when you said this is not a feature Hauppauge supports.
>> Did you mean it's not fully enabled physically in the PCB...
>> Or is it just something they need to add support for in the driver?
>> If the latter do you know if their policy has changed or is about to?
> 
> No idea, I have no answer.

Considering that in the specs for the reference card it was highlighted
as part of the silicon... Wouldn't it be safe to assume that it's
something that'd be unlocked by drivers?

But if that were true, what is their motivation in not wanting to enable
it? (assuming they still haven't)

>>>>>>>> 3) Hw encode bypass for A/V-in
>>>>>>
>>>>>> No idea. Regardless of whether it does or does not I wouldn't plan to
>>>>>> add basic raw TV support to the driver, without going through the
>>>>>> encoder.
>>>>>
>>>>> Why do you rule it out unequivocally, is it just because I've annoyed
>>>>> you? :-(
>>>>
>>>> Raw analog TV isn't a high priority feature on my mental check-list.
>>>> Analog TV via the encoder is much more interesting and applicable to
>>>> many people.
>>
>> Assuming that progress has been made on analogue to
>> h.263/mpeg4/VC-1/DivX/Xvid via the A/V-in encoder.
>> Is this still considered a low priority?
> 
> Raw analog is still very low down any list I have for the HVR22xx driver.
> 
>>
>> Has progress been made on hw encode via A/V-in?
>> I'm "finally" putting my entire system together soon, can't wait!
>> Looking forward to seeing how everything has progressed.
>> I'll be sure to do some donations once I'm up & running!
> 
> The current driver supports DTV only. I have no ETA for analog on the 
> HVR22xx driver. If you need analog support then the HVR22xx isn't the 
> right product for you.
> 
> Regards,

I don't need analogue for tuning purposes but for A/V-in it'd be mighty
handy.
If you've got anything that's very rough I'm happy to be your lab-rat?

Do you know of any dual hybrid DVB-T tuner cards that do have
functioning A/V-in, or should I forget such devices for that purpose?

Thank-you.



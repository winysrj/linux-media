Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:37771 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbZIGSOZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 14:14:25 -0400
Received: by yxe5 with SMTP id 5so5092389yxe.33
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 11:14:27 -0700 (PDT)
Message-ID: <4AA54D9F.7060301@gmail.com>
Date: Tue, 08 Sep 2009 04:14:55 +1000
From: Jed <jedi.theone@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: PCI/e with dual DVB-T + AV-in?
References: <4A9F5B73.8060004@gmail.com> <4A9FFD29.7090607@gmail.com> <37219a840909031126w2cbde9e2ld3cbffe8dfa64353@mail.gmail.com> <4AA0A317.6030605@gmail.com>
In-Reply-To: <4AA0A317.6030605@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>>> Hi Ya'll,
>>>>
>>>> Going on response levels thus far I'm not expecting much :-D but I was
>>>> wondering if someone could possibly help me out here.
>>>>
>>>> Is there anything with half-decent driver support that is PCI/e, 
>>>> and has
>>>> dual DVB-T + A/V-in?*
>>>> As a bonus it would be dual Hybrid and have hardware encode, but I
>>>> wouldn't expect either to work at this stage.
>>>>
>>>> I'm still trawling through mail-lists & wiki's etc, so I may yet 
>>>> find the
>>>> best solution, but I was hoping some might already know.
>>>> Any advice or even just a response to chastise me is greatly 
>>>> appreciated!
>>>>  :-D
>>>>
>>>> Cheers,
>>>> Jed
>>>> *Is HVR-2200 the only option?
>>>>  I wish there was something with better AV-in but it might end-up 
>>>> being my
>>>> final choice.
>>>>
>>>>
>>>>       
>>> Jed wrote:
>>> I've stopped looking for an alternative card, going to have a crack at
>>> getting my 7162-based device working.
>>> Still, any suggestions in the meantime are most welcome! I've also 
>>> decided
>>> AV-in isn't that important...
>>> So just a known, nicely working PCI/e + dual DVB-T card, having the 
>>> other
>>> features is nice but they needn't be working yet.
>>>
>>> Wish me luck!   :-D
>>>
>>>     
>>
>> HVR2200 is in well supported now for digital-only.  It is a dual tuner
>> board using a PCI-E interface.  It has A/V capabilities that are not
>> *yet* supported in Linux.  Don't know when A/V will be supported, but
>> it will probably happen, eventually.
>>
>> It is a dual hybrid, and it does do hardware encode.  (although not
>> yet in Linux)  This probably is the device for you.
>>
>> To follow the development more closely, see the blog on kernellabs.com
>> I hope this helps.
>>
>> Regards,
>> Mike

Hi saa7164 devs, once(if) the software support is in place for A/V-in...
Do you know if it'd be possible to bypass hw encode and dump 
uncompressed HD/SD with this card?
Or is it limited hardware-wise to even do this?

Cheers,
Jed


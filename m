Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:44979 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbZIKQ0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 12:26:31 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KPT00ELTF03DGD0@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Fri, 11 Sep 2009 12:26:28 -0400 (EDT)
Date: Fri, 11 Sep 2009 12:26:27 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: PCI/e with dual DVB-T + AV-in (HVR-2200?)
In-reply-to: <4AAA76CB.8080802@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4AAA7A33.3070903@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4A9F5B73.8060004@gmail.com> <4A9FFD29.7090607@gmail.com>
 <37219a840909031126w2cbde9e2ld3cbffe8dfa64353@mail.gmail.com>
 <4AA0A317.6030605@gmail.com> <4AA54D9F.7060301@gmail.com>
 <4AA6B8E0.9070009@gmail.com> <4AA6B989.8070605@kernellabs.com>
 <4AA6BC70.4040007@gmail.com> <4AA741BF.7030407@gmail.com>
 <4AA7CFB2.2050701@gmail.com> <4AA92DE5.8040207@gmail.com>
 <4AAA713B.3040104@gmail.com> <4AAA76CB.8080802@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/11/09 12:11 PM, Jed wrote:
>>
>>>>> Yeah I realised after seeing your 2nd email that Hauppauge only
>>>>> says mpeg2 because that's all the Windows dvr does! :-D
>>>>>
>>>>> I also noticed on the website that it only talks about hw encode
>>>>> being for the analog rf tuners, is there no hw encode for av-in?!
>>>>> It seems to be other way round for most other cards....
>>>>>
>>>>> Having the *option* to bypass hw encode whether it be on the analog
>>>>> rf-in or av-in would be a very handy feature!
>>>>> Because one could instead use CPU/GPGPU resources (if suited) and
>>>>> more flexible software, or even dedicated encoder/transcoder addon
>>>>> devices.
>>>>> Or in the case of video editing leave it raw for easier editing,
>>>>> and then transocde it as required...
>>>> Hi, I came across these two pdf's which seem to suggest that the
>>>> references cards that the hvr-2200/2250 are based-on can do
>>>> component in!
>>>> Could it be that (like the limitation with hw encode in Windows to
>>>> mpeg2) component in is also not advertised, simply because it's not
>>>> supported in Windows?
>>>> Assuming the cards are based-on the reference cards, then the
>>>> hardware support seems to be there!
>>>>
>>>> Can someone please address my earlier points above too if you have
>>>> an answer/opinion? Thanks heaps!
>>>>
>>>> Jed
>> Hi Kernellabs or anyone involved with driver development of the HVR-2200,
>>
>> I know this is long waaaay down the priority list of features to be
>> added, if ever!
>> But I'm wanting to know if the *possibility* is there 'hardware-wise'
>> for the following:
>>
>> 1) h.263/mpeg4/VC-1/DivX/Xvid hardware encode of A/V-in
>> 2) Component input for the A/V-in
>> 3) Hw encode bypass for A/V-in
>> 4) Is Hw encode purely for A/V-in? (hauppauge's site seems to suggest
>> otherwise but it may be a typo)
>> 5) If not then questions 1) & 3) also apply to RF-in!
>>
>> I've attached the reference cards spec. sheets again for your perusal.
>> I would be proactive in providing as much feed-back as needed for the
>> dev. of such features.
>>
>> Most Sincerely,
>> Jed
> For some inexplicable reason my last two posts have not appeared on the
> ML, it seems I've been scrubbed!
> Hence I'm forwarding straight to you to answer or forward to colleagues
> to answer when possible.

Oh, I saw your posting to the list. It's in my inbox, along with many other 
emails I'd like to respond to over the next few weeks. Nothing personal, I'm 
just too busy right now to deal with your ongoing daily list of questions.

Please post all your questions to the ML and people will respond when they can, 
if they can.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com

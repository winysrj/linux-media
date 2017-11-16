Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.micronovasrl.com ([212.103.203.10]:47946 "EHLO
        mail.micronovasrl.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964823AbdKPNRL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 08:17:11 -0500
Received: from mail.micronovasrl.com (mail.micronovasrl.com [127.0.0.1])
        by mail.micronovasrl.com (Postfix) with ESMTP id 1A885B01604
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 14:17:09 +0100 (CET)
Received: from mail.micronovasrl.com ([127.0.0.1])
        by mail.micronovasrl.com (mail.micronovasrl.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id nlOThAiME3Ai for <linux-media@vger.kernel.org>;
        Thu, 16 Nov 2017 14:17:08 +0100 (CET)
Subject: Re: [linux-sunxi] Cedrus driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        thomas@vitsch.nl, linux-media@vger.kernel.org
References: <1510059543-7064-1-git-send-email-giulio.benetti@micronovasrl.com>
 <1b12fa21-bfe6-9ba7-ae1d-8131ac6f4668@micronovasrl.com>
 <6fcdc0d9-d0f8-785a-bb00-b1b41c684e59@imkreisrum.de>
 <693e8786-af83-9d77-0fd4-50fa1f6a135f@micronovasrl.com>
 <20171116110204.poakahqjz4sj7pmu@flea>
 <5fcf64db-c654-37d0-5863-20379c04f99c@micronovasrl.com>
 <20171116125310.yavjs7352nw2sm7r@flea>
 <e03cfdb5-57b3-fefd-75c3-6b97348682ff@micronovasrl.com>
 <6f94505d-69bb-6688-4b13-6a0ed2af8dd4@xs4all.nl>
From: Giulio Benetti <giulio.benetti@micronovasrl.com>
Message-ID: <d0b7f6e5-8758-ac92-e6a2-9ed4ff3cbc63@micronovasrl.com>
Date: Thu, 16 Nov 2017 14:17:08 +0100
MIME-Version: 1.0
In-Reply-To: <6f94505d-69bb-6688-4b13-6a0ed2af8dd4@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: it
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Il 16/11/2017 14:12, Hans Verkuil ha scritto:
> On 16/11/17 13:57, Giulio Benetti wrote:
>> Il 16/11/2017 13:53, Maxime Ripard ha scritto:
>>> On Thu, Nov 16, 2017 at 01:30:52PM +0100, Giulio Benetti wrote:
>>>>> On Thu, Nov 16, 2017 at 11:37:30AM +0100, Giulio Benetti wrote:
>>>>>> Il 16/11/2017 11:31, Andreas Baierl ha scritto:
>>>>>>> Am 16.11.2017 um 11:13 schrieb Giulio Benetti:
>>>>>>>> Hello,
>>>>>>>>
>>>>>>> Hello,
>>>>>>>> I'm wondering why cedrus
>>>>>>>> https://github.com/FlorentRevest/linux-sunxi-cedrus has never been
>>>>>>>> merged with linux-sunxi sunxi-next.
>>>>>>>>
>>>>>>> Because it is not ready to be merged. It depends on the v4l2 request
>>>>>>> API, which was not merged and which is re-worked atm.
>>>>>>> Also, sunxi-cedrus itself is not in a finished state and is not as
>>>>>>> feature-complete to be merged. Anyway it might be something for
>>>>>>> staging... Has there been a [RFC] on the mailing list at all?
>>>>>>
>>>>>> Where can I find a list of TODOs to get it ready to be merged?
>>>>>
>>>>> Assuming that the request API is in, we'd need to:
>>>>>      - Finish the MPEG4 support
>>>>>      - Work on more useful codecs (H264 comes to my mind)
>>>>>      - Implement the DRM planes support for the custom frame format
>>>>>      - Implement the DRM planes support for scaling
>>>>>      - Test it on more SoCs
>>>>>
>>>>> Or something along those lines.
>>>>
>>>> Lot of work to do
>>>
>>> Well... If it was fast and easy it would have been done already :)
>>
>> :))
>>
>>>
>>>>>>>> I see it seems to be dead, no commit in 1 year.
>>>>>>>
>>>>>>> Yes, because the author did this during an internship, which ended ...
>>>>>>> Afaik nobody picked up his work yet.
>>>>>
>>>>> That's not entirely true. Some work has been done by Thomas (in CC),
>>>>> especially on the display engine side, but last time we talked his
>>>>> work was not really upstreamable.
>>>>>
>>>>> We will also resume that effort starting next march.
>>>>
>>>> Is it possible a preview on a separate Reporitory to start working on now?
>>>> Expecially to start porting everything done by FlorentRevest to mainline,
>>>> admitted you've not already done.
>>>
>>> I'm not sure what you're asking for. Florent's work *was* on mainline.
>>
>> and then they took it off because it was unmantained?
>> You've spoken about Thomas(in CC) not ready,
>> maybe I could help on that if it's public to accelerate.
>> If I'm able to of course, this is my primary concern.
>>
>> Otherwise, in which way can I help improving it to make it accept to linux-sunxi?
>> Starting from Florent's work and porting it to sunxi-next to begin?
>> And after that adding all features you've listed?
>> Tell me what I can do(I repeat, if I'm able to).
> 
> The bottleneck is that the Request API is not mainlined. We restarted work
> on it after a meeting a few weeks back where we all agreed on the roadmap
> so hopefully it will go into mainline Q1 or Q2 next year.
> 
> That said, you can use Florent's patch series for further development.
> It should be relatively easy to convert it to the final version of the
> Request API. Just note that the public API of the final Request API will
> be somewhat different from the old version Florent's patch series is using.

So I'm going to try soon to :
1) adapt that patchset to sunxi-next
2) add A20 support
3) add A33 support
4) after mainlined APIs, merge

Alright?

Regards

> 
> Regards,
> 
> 	Hans
> 
>>
>>>
>>> Maxime
>>>
>>
>> Thank you
>>
> 


-- 
Giulio Benetti
R&D Manager &
Advanced Research

MICRONOVA SRL
Sede: Via A. Niedda 3 - 35010 Vigonza (PD)
Tel. 049/8931563 - Fax 049/8931346
Cod.Fiscale - P.IVA 02663420285
Capitale Sociale � 26.000 i.v.
Iscritta al Reg. Imprese di Padova N. 02663420285
Numero R.E.A. 258642

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.micronovasrl.com ([212.103.203.10]:53056 "EHLO
        mail.micronovasrl.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754183AbdK1L0f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 06:26:35 -0500
Received: from mail.micronovasrl.com (mail.micronovasrl.com [127.0.0.1])
        by mail.micronovasrl.com (Postfix) with ESMTP id 8277BB00A55
        for <linux-media@vger.kernel.org>; Tue, 28 Nov 2017 12:26:33 +0100 (CET)
Received: from mail.micronovasrl.com ([127.0.0.1])
        by mail.micronovasrl.com (mail.micronovasrl.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id v8xPKOtV6der for <linux-media@vger.kernel.org>;
        Tue, 28 Nov 2017 12:26:32 +0100 (CET)
Subject: Re: [linux-sunxi] Cedrus driver
To: Thomas van Kleef <thomas@vitsch.nl>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1511868059-2055094631.224aeb721c@prakkezator.vehosting.nl>
 <5d1cad5b-7d36-71fd-2e23-3bfe05f6e56f@vitsch.nl>
From: Giulio Benetti <giulio.benetti@micronovasrl.com>
Message-ID: <866ca479-dfbd-01a9-9ab6-0e52bd72ac28@micronovasrl.com>
Date: Tue, 28 Nov 2017 12:26:32 +0100
MIME-Version: 1.0
In-Reply-To: <5d1cad5b-7d36-71fd-2e23-3bfe05f6e56f@vitsch.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: it
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

Il 28/11/2017 12:20, Thomas van Kleef ha scritto:
> On 28-11-17 10:50, Giulio Benetti wrote:
>> Hi Maxime,
>>
>> Il 28/11/2017 09:35, Maxime Ripard ha scritto:
>>> On Tue, Nov 28, 2017 at 01:03:59AM +0100, Giulio Benetti wrote:
>>>> Hi Maxime,
>>>>
>>>> Il 16/11/2017 14:42, Giulio Benetti ha scritto:
>>>>> Hi,
>>>>>
>>>>> Il 16/11/2017 14:39, Maxime Ripard ha scritto:
>>>>>> On Thu, Nov 16, 2017 at 02:17:08PM +0100, Giulio Benetti wrote:
>>>>>>> Hi Hans,
>>>>>>>
>>>>>>> Il 16/11/2017 14:12, Hans Verkuil ha scritto:
>>>>>>>> On 16/11/17 13:57, Giulio Benetti wrote:
>>>>>>>>> Il 16/11/2017 13:53, Maxime Ripard ha scritto:
>>>>>>>>>> On Thu, Nov 16, 2017 at 01:30:52PM +0100, Giulio Benetti wrote:
>>>>>>>>>>>> On Thu, Nov 16, 2017 at 11:37:30AM +0100, Giulio Benetti wrote:
>>>>>>>>>>>>> Il 16/11/2017 11:31, Andreas Baierl ha scritto:
>>>>>>>>>>>>>> Am 16.11.2017 um 11:13 schrieb Giulio Benetti:
>>>>>>>>>>>>>>> Hello,
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Hello,
>>>>>>>>>>>>>>> I'm wondering why cedrus
>>>>>>>>>>>>>>> https://github.com/FlorentRevest/linux-sunxi-cedrus
>>>>>>>>>>>>>>> has never been
>>>>>>>>>>>>>>> merged with linux-sunxi sunxi-next.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Because it is not ready to be
>>>>>>>>>>>>>> merged. It depends on the v4l2
>>>>>>>>>>>>>> request
>>>>>>>>>>>>>> API, which was not merged and which is re-worked atm.
>>>>>>>>>>>>>> Also, sunxi-cedrus itself is not in
>>>>>>>>>>>>>> a finished state and is not as
>>>>>>>>>>>>>> feature-complete to be merged. Anyway it might be something for
>>>>>>>>>>>>>> staging... Has there been a [RFC] on the mailing list at all?
>>>>>>>>>>>>>
>>>>>>>>>>>>> Where can I find a list of TODOs to get it ready to be merged?
>>>>>>>>>>>>
>>>>>>>>>>>> Assuming that the request API is in, we'd need to:
>>>>>>>>>>>>         - Finish the MPEG4 support
>>>>>>>>>>>>         - Work on more useful codecs (H264 comes to my mind)
>>>>>>>>>>>>         - Implement the DRM planes support for
>>>>>>>>>>>> the custom frame format
>>>>>>>>>>>>         - Implement the DRM planes support for scaling
>>>>>>>>>>>>         - Test it on more SoCs
>>>>>>>>>>>>
>>>>>>>>>>>> Or something along those lines.
>>>>>>>>>>>
>>>>>>>>>>> Lot of work to do
>>>>>>>>>>
>>>>>>>>>> Well... If it was fast and easy it would have been done already :)
>>>>>>>>>
>>>>>>>>> :))
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>>>>> I see it seems to be dead, no commit in 1 year.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Yes, because the author did this
>>>>>>>>>>>>>> during an internship, which ended
>>>>>>>>>>>>>> ...
>>>>>>>>>>>>>> Afaik nobody picked up his work yet.
>>>>>>>>>>>>
>>>>>>>>>>>> That's not entirely true. Some work has been
>>>>>>>>>>>> done by Thomas (in CC),
>>>>>>>>>>>> especially on the display engine side, but last time we talked his
>>>>>>>>>>>> work was not really upstreamable.
>>>>>>>>>>>>
>>>>>>>>>>>> We will also resume that effort starting next march.
>>>>>>>>>>>
>>>>>>>>>>> Is it possible a preview on a separate
>>>>>>>>>>> Reporitory to start working on now?
>>>>>>>>>>> Expecially to start porting everything done by
>>>>>>>>>>> FlorentRevest to mainline,
>>>>>>>>>>> admitted you've not already done.
>>>>>>>>>>
>>>>>>>>>> I'm not sure what you're asking for. Florent's work
>>>>>>>>>> *was* on mainline.
>>>>>>>>>
>>>>>>>>> and then they took it off because it was unmantained?
>>>>>>>>> You've spoken about Thomas(in CC) not ready,
>>>>>>>>> maybe I could help on that if it's public to accelerate.
>>>>>>>>> If I'm able to of course, this is my primary concern.
>>>>>>>>>
>>>>>>>>> Otherwise, in which way can I help improving it to make
>>>>>>>>> it accept to linux-sunxi?
>>>>>>>>> Starting from Florent's work and porting it to sunxi-next to begin?
>>>>>>>>> And after that adding all features you've listed?
>>>>>>>>> Tell me what I can do(I repeat, if I'm able to).
>>>>>>>>
>>>>>>>> The bottleneck is that the Request API is not mainlined. We
>>>>>>>> restarted work
>>>>>>>> on it after a meeting a few weeks back where we all agreed
>>>>>>>> on the roadmap
>>>>>>>> so hopefully it will go into mainline Q1 or Q2 next year.
>>>>>>>>
>>>>>>>> That said, you can use Florent's patch series for further development.
>>>>>>>> It should be relatively easy to convert it to the final version of the
>>>>>>>> Request API. Just note that the public API of the final
>>>>>>>> Request API will
>>>>>>>> be somewhat different from the old version Florent's patch
>>>>>>>> series is using.
>>>>>>>
>>>>>>> So I'm going to try soon to :
>>>>>>> 1) adapt that patchset to sunxi-next
>>>>>>> 2) add A20 support
>>>>>>> 3) add A33 support
>>>>>>> 4) after mainlined APIs, merge
>>>>>>
>>>>>> That sounds good. Thomas already has the support for the A20, and as I
>>>>>> was saying, there is someone that is going to work full time on this
>>>>>> in a couple monthes on our side.
>>>>>>
>>>>>> I'll set up a git repo on github so that we can collaborate until the
>>>>>> request API is ready.
>>>>
>>>> Any news about git repo?
>>>> When do you plan to do it more or less?
>>>
>>> I started to do it yesterday.
>>>
>>> https://github.com/free-electrons/linux-cedrus
>>> https://github.com/free-electrons/libva-cedrus
>>
>> Great, I'm cloning.
>> 1st: have it working with A20 with kernel as is and libva as buildroot package
>> 2nd: porting to sunxi-next branch of linux-sunxi and check libva if can work as is
>>
>> Thank you
>> So, I have been rebasing to 4.14.0 and have the cedrus driver working.
> I have pulled linux-mainline 4.14.0. Then pulled the requests2 branch from Hans
> Verkuil's media_tree. I have a patch available of the merge between these 2
> branches.
> After this I pulled the sunxi-cedrus repository from Florent Revests github. I
> believe this one is the same as the ones you are cloning right now.
> I have merged this and have a patch available for this as well.
> 
> So to summarize:
>   o pulled linux 4.14 from:
>      https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>   o pulled requests2 from:
>      https://git.linuxtv.org/hverkuil/media_tree.git?h=requests2
>      will be replaced with the work, when it is done, in:
>       https://git.linuxtv.org/hverkuil/media_tree.git?h=ctrl-req-v2
>   o pulled linux-sunxi-cedrus from:
>      https://github.com/FlorentRevest/linux-sunxi-cedrus
> 
>   o merged and made patch between linux4.14 and requests2
>   o merged and made patch with linux-sunxi-cedrus
>   o Verified that the video-engine is decofing mpeg-2 on the Allwinner A20.
> 
> So maybe if someone is interested in this, I could place the patches somewhere?
> Just let me know.

Sure it's interesting!
You could setup your github repo with all you patches applied as 
commits, but I think you should work against linux-sunxi sunxi-next branch.

> 
> It would be nice to be able to play a file, so I would have to prepare our
> custom player and make a patch between the current sunxi-cedrus-drv-video and
> the one on https://github.com/FlorentRevest/sunxi-cedrus-drv-video.
> So I will start with this if there is any interest.

I am interested for sure.

> 
> Should I be working in sunxi-next I wonder?

Yes, this is the best way, cedrus is very specific to sunxi.
So before working on mainline, I think the best is to work un sunxi-next 
branch.

Is it right Maxime?

>>>
>>> Maxime
>>>
>>
>>


-- 
Giulio Benetti
R&D Manager &
Advanced Research

MICRONOVA SRL
Sede: Via A. Niedda 3 - 35010 Vigonza (PD)
Tel. 049/8931563 - Fax 049/8931346
Cod.Fiscale - P.IVA 02663420285
Capitale Sociale € 26.000 i.v.
Iscritta al Reg. Imprese di Padova N. 02663420285
Numero R.E.A. 258642

Return-path: <linux-media-owner@vger.kernel.org>
Received: from PrakOutbound.VEHosting.nl ([85.17.51.155]:49943 "EHLO
        Prakkezator.VEHosting.nl" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753311AbdK1Mbr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 07:31:47 -0500
Subject: Re: [linux-sunxi] Cedrus driver
To: Giulio Benetti <giulio.benetti@micronovasrl.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1511872294-8815388530.8afa83b685@prakkezator.vehosting.nl>
From: Thomas van Kleef <thomas@vitsch.nl>
Message-ID: <08284cc0-477f-a08c-e645-6e3ddde679c4@vitsch.nl>
Date: Tue, 28 Nov 2017 13:31:34 +0100
MIME-Version: 1.0
In-Reply-To: <f8cc0633-8c29-e3b0-0216-f8f5c69ebb34@micronovasrl.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Giulio

On 28-11-17 12:54, Giulio Benetti wrote:
> Hi Thomas,
> 
> Il 28/11/2017 12:29, Thomas van Kleef ha scritto:
>> Hi,
>>
>> On 28-11-17 12:26, Giulio Benetti wrote:
>>> Hi Thomas,
>>>
>>> Il 28/11/2017 12:20, Thomas van Kleef ha scritto:
>>>> On 28-11-17 10:50, Giulio Benetti wrote:
>>>>> Hi Maxime,
>>>>>
>>>>> Il 28/11/2017 09:35, Maxime Ripard ha scritto:
>>>>>> On Tue, Nov 28, 2017 at 01:03:59AM +0100, Giulio Benetti wrote:
>>>>>>> Hi Maxime,
>>>>>>>
>>>>>>> Il 16/11/2017 14:42, Giulio Benetti ha scritto:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> Il 16/11/2017 14:39, Maxime Ripard ha scritto:
>>>>>>>>> On Thu, Nov 16, 2017 at 02:17:08PM +0100, Giulio Benetti wrote:
>>>>>>>>>> Hi Hans,
>>>>>>>>>>
>>>>>>>>>> Il 16/11/2017 14:12, Hans Verkuil ha scritto:
>>>>>>>>>>> On 16/11/17 13:57, Giulio Benetti wrote:
>>>>>>>>>>>> Il 16/11/2017 13:53, Maxime Ripard ha scritto:
>>>>>>>>>>>>> On Thu, Nov 16, 2017 at 01:30:52PM +0100, Giulio Benetti wrote:
>>>>>>>>>>>>>>> On Thu, Nov 16, 2017 at 11:37:30AM +0100, Giulio Benetti wrote:
>>>>>>>>>>>>>>>> Il 16/11/2017 11:31, Andreas Baierl ha scritto:
>>>>>>>>>>>>>>>>> Am 16.11.2017 um 11:13 schrieb Giulio Benetti:
>>>>>>>>>>>>>>>>>> Hello,
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Hello,
>>>>>>>>>>>>>>>>>> I'm wondering why cedrus
>>>>>>>>>>>>>>>>>> https://github.com/FlorentRevest/linux-sunxi-cedrus
>>>>>>>>>>>>>>>>>> has never been
>>>>>>>>>>>>>>>>>> merged with linux-sunxi sunxi-next.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Because it is not ready to be
>>>>>>>>>>>>>>>>> merged. It depends on the v4l2
>>>>>>>>>>>>>>>>> request
>>>>>>>>>>>>>>>>> API, which was not merged and which is re-worked atm.
>>>>>>>>>>>>>>>>> Also, sunxi-cedrus itself is not in
>>>>>>>>>>>>>>>>> a finished state and is not as
>>>>>>>>>>>>>>>>> feature-complete to be merged. Anyway it might be something for
>>>>>>>>>>>>>>>>> staging... Has there been a [RFC] on the mailing list at all?
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Where can I find a list of TODOs to get it ready to be merged?
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Assuming that the request API is in, we'd need to:
>>>>>>>>>>>>>>>          - Finish the MPEG4 support
>>>>>>>>>>>>>>>          - Work on more useful codecs (H264 comes to my mind)
>>>>>>>>>>>>>>>          - Implement the DRM planes support for
>>>>>>>>>>>>>>> the custom frame format
>>>>>>>>>>>>>>>          - Implement the DRM planes support for scaling
>>>>>>>>>>>>>>>          - Test it on more SoCs
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Or something along those lines.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Lot of work to do
>>>>>>>>>>>>>
>>>>>>>>>>>>> Well... If it was fast and easy it would have been done already :)
>>>>>>>>>>>>
>>>>>>>>>>>> :))
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> I see it seems to be dead, no commit in 1 year.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Yes, because the author did this
>>>>>>>>>>>>>>>>> during an internship, which ended
>>>>>>>>>>>>>>>>> ...
>>>>>>>>>>>>>>>>> Afaik nobody picked up his work yet.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> That's not entirely true. Some work has been
>>>>>>>>>>>>>>> done by Thomas (in CC),
>>>>>>>>>>>>>>> especially on the display engine side, but last time we talked his
>>>>>>>>>>>>>>> work was not really upstreamable.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> We will also resume that effort starting next march.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Is it possible a preview on a separate
>>>>>>>>>>>>>> Reporitory to start working on now?
>>>>>>>>>>>>>> Expecially to start porting everything done by
>>>>>>>>>>>>>> FlorentRevest to mainline,
>>>>>>>>>>>>>> admitted you've not already done.
>>>>>>>>>>>>>
>>>>>>>>>>>>> I'm not sure what you're asking for. Florent's work
>>>>>>>>>>>>> *was* on mainline.
>>>>>>>>>>>>
>>>>>>>>>>>> and then they took it off because it was unmantained?
>>>>>>>>>>>> You've spoken about Thomas(in CC) not ready,
>>>>>>>>>>>> maybe I could help on that if it's public to accelerate.
>>>>>>>>>>>> If I'm able to of course, this is my primary concern.
>>>>>>>>>>>>
>>>>>>>>>>>> Otherwise, in which way can I help improving it to make
>>>>>>>>>>>> it accept to linux-sunxi?
>>>>>>>>>>>> Starting from Florent's work and porting it to sunxi-next to begin?
>>>>>>>>>>>> And after that adding all features you've listed?
>>>>>>>>>>>> Tell me what I can do(I repeat, if I'm able to).
>>>>>>>>>>>
>>>>>>>>>>> The bottleneck is that the Request API is not mainlined. We
>>>>>>>>>>> restarted work
>>>>>>>>>>> on it after a meeting a few weeks back where we all agreed
>>>>>>>>>>> on the roadmap
>>>>>>>>>>> so hopefully it will go into mainline Q1 or Q2 next year.
>>>>>>>>>>>
>>>>>>>>>>> That said, you can use Florent's patch series for further development.
>>>>>>>>>>> It should be relatively easy to convert it to the final version of the
>>>>>>>>>>> Request API. Just note that the public API of the final
>>>>>>>>>>> Request API will
>>>>>>>>>>> be somewhat different from the old version Florent's patch
>>>>>>>>>>> series is using.
>>>>>>>>>>
>>>>>>>>>> So I'm going to try soon to :
>>>>>>>>>> 1) adapt that patchset to sunxi-next
>>>>>>>>>> 2) add A20 support
>>>>>>>>>> 3) add A33 support
>>>>>>>>>> 4) after mainlined APIs, merge
>>>>>>>>>
>>>>>>>>> That sounds good. Thomas already has the support for the A20, and as I
>>>>>>>>> was saying, there is someone that is going to work full time on this
>>>>>>>>> in a couple monthes on our side.
>>>>>>>>>
>>>>>>>>> I'll set up a git repo on github so that we can collaborate until the
>>>>>>>>> request API is ready.
>>>>>>>
>>>>>>> Any news about git repo?
>>>>>>> When do you plan to do it more or less?
>>>>>>
>>>>>> I started to do it yesterday.
>>>>>>
>>>>>> https://github.com/free-electrons/linux-cedrus
>>>>>> https://github.com/free-electrons/libva-cedrus
>>>>>
>>>>> Great, I'm cloning.
>>>>> 1st: have it working with A20 with kernel as is and libva as buildroot package
>>>>> 2nd: porting to sunxi-next branch of linux-sunxi and check libva if can work as is
>>>>>
>>>>> Thank you
>>>>> So, I have been rebasing to 4.14.0 and have the cedrus driver working.
>>>> I have pulled linux-mainline 4.14.0. Then pulled the requests2 branch from Hans
>>>> Verkuil's media_tree. I have a patch available of the merge between these 2
>>>> branches.
>>>> After this I pulled the sunxi-cedrus repository from Florent Revests github. I
>>>> believe this one is the same as the ones you are cloning right now.
>>>> I have merged this and have a patch available for this as well.
>>>>
>>>> So to summarize:
>>>>    o pulled linux 4.14 from:
>>>>       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>>>    o pulled requests2 from:
>>>>       https://git.linuxtv.org/hverkuil/media_tree.git?h=requests2
>>>>       will be replaced with the work, when it is done, in:
>>>>        https://git.linuxtv.org/hverkuil/media_tree.git?h=ctrl-req-v2
>>>>    o pulled linux-sunxi-cedrus from:
>>>>       https://github.com/FlorentRevest/linux-sunxi-cedrus
>>>>
>>>>    o merged and made patch between linux4.14 and requests2
>>>>    o merged and made patch with linux-sunxi-cedrus
>>>>    o Verified that the video-engine is decofing mpeg-2 on the Allwinner A20.
>>>>
>>>> So maybe if someone is interested in this, I could place the patches somewhere?
>>>> Just let me know.
>>>
>>> Sure it's interesting!
>>> You could setup your github repo with all you patches applied as commits, but I think you should work against linux-sunxi sunxi-next branch.
>>>
Hope this helps.
https://github.com/thomas-vitsch/linux-a20-cedrus
>>>>
>>>> It would be nice to be able to play a file, so I would have to prepare our
>>>> custom player and make a patch between the current sunxi-cedrus-drv-video and
>>>> the one on https://github.com/FlorentRevest/sunxi-cedrus-drv-video.
>>>> So I will start with this if there is any interest.
>>>
>>> I am interested for sure.
>>>
>>>>
>>>> Should I be working in sunxi-next I wonder?
>>>
>>> Yes, this is the best way, cedrus is very specific to sunxi.
>>> So before working on mainline, I think the best is to work un sunxi-next branch.
>> Is the requests2 api in sunxi-next?
> 
> It should be there,
> take a look at latest commit of yesterday:
> https://github.com/linux-sunxi/linux-sunxi/commit/df7cacd062cd84c551d7e72f15b1af6d71abc198
> 
Thank you for the info. I will start working in the sunxi-next branch soon then.
>>>
>>> Is it right Maxime?
>>>
>>>>>>
>>>>>> Maxime
>>>>>>
>>>>>
>>>>>
>>>
>>>
>> Thomas
>>
> 
> 

Thomas van Kleef
Vitsch Electronics
http://Vitsch.nl/
http://VitschVPN.nl/
tel: +31-(0)40-7113051
KvK nr: 17174380
BTW nr: NL142748201B01
-- 
Machines en netwerken op afstand beheren? Vitsch VPN oplossing!
Kijk voor meer informatie op: http://www.VitschVPN.nl/

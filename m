Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:56121 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965634AbdGTVQx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 17:16:53 -0400
Subject: Re: [PATCH 00/14] ddbridge: bump to ddbridge-0.9.29
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Ralph Metzler <rjkm@metzlerbros.de>, linux-media@vger.kernel.org,
        mchehab@kernel.org, d_spingler@gmx.de
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
 <22883.13973.46880.749847@morden.metzler>
 <20170710173124.653286e7@audiostation.wuest.de>
 <22884.38463.374508.270284@morden.metzler>
 <20170711173013.25741b86@audiostation.wuest.de>
 <20170720122412.0aaefcfe@vento.lan>
 <20170720202549.6d77b8d2@audiostation.wuest.de>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <b8470340-82a3-7109-3414-5f5ccefa4749@anw.at>
Date: Thu, 20 Jul 2017 23:16:36 +0200
MIME-Version: 1.0
In-Reply-To: <20170720202549.6d77b8d2@audiostation.wuest.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Daniel lined out already what the technical differences are.
In fact nothing what the normal user of this very good DVB cards needs.
The Octopus NET has its own distribution provided by DD. So there is no need
to support this in the mainline Kernel at this time.

Also the modulator is something which might be used in central stations at
hotels, but not by the arbitrary user in the public. I guess this stations are
also equipped with the drivers from DD or even provided as a whole system by
this company. I also see no reason to support the modulator card *now*, when we
are in a stage where we need to put in nearly 7 years of improvements of the
DD driver into the Kernel. Yes, we are talking about nearly 7 years!

And there is another thing. The very old driver V 0.5.0 currently existing in
mainline, does not support the DD CI cards, which are an essential addon for
all users in Austria, Switzerland, ... . Without this CI cards it is
*impossible* to see the official TV program! This countries scramble the TS
stream to restrict the access to citizens.
Without bumping the ddbridge to V 0.9.29, we all living in this countries can't
use the Kernel driver, but only the DD version! Sticking to the DD version
means, we can't use other cards in parallel, because the DD version simply
doesn't support to use any other driver together with the DD cards, due to the
API changes and the currently used old DVB core.

In my opinion nearly nobody is using the current mainline driver, due to it's
limitations and the fact, that the DD version provides all the features we
need. So merging the new version will not harm anyone, but help to prevent
using self compiled incompatible drivers.

In my opinion it should have been DD's task to keep the DD version in sync
with mainline. Moreover they should have needed to upstream their changes
in the past in little steps. Instead they changed the API and made it more or
less impossible to merge it without a lot of effort!

As Daniel already mentioned, he spent 1,5 years to understand the driver, to
make it compatible to the Mainline DVB core, to provide patches, to test the
result, to get other people involved to test the new drivers, ... .
When this is not merged *now*, I guess we will lose *the* person who made it
happen! There were other people who tried it, but didn't have the endurance
and energy to meet the target.
Daniel will definitely continue working on this subject to keep the DD
version in sync with the mainline version, even if there are some things still
different.

We are very close to the target and making it now a stopper for the mentioned
little things is the worst thing we can do!

Beside all this organisational issue, I had the chance to use this driver for
a couple of days on my test system:
  DD Cine V 6.5 with a
  DD Duoflex CI (single) and a
  DD Duoflex S2 V4 tuner card
  VDR 2.3.8, ddci2 Plugin 1.5.0

And the productive system:
  DD Octopus CI (dual) with a
  DD Duoflex S2 tuner card
  VDR 2.2.0, ddci2 Plugin 1.5.0

I had no issues, beside small problems with my CAM on the productive system,
which I also had with the upstream DD driver. I am already debugging them, but
need support from Ralph concerning FPGA registers and maybe more. This problem
has nothing to do with the new drivers, so it is no stopper for merging it into
mainline.

With this eMail I add my
  Tested-by: Jasmin Jessich <jasmin@anw.at>
for this whole series.

Finally I want to thank Daniel for his effort and I adjure Mauro to merge
this now!

BR,
   Jasmin

*************************************************************************

On 07/20/2017 08:25 PM, Daniel Scheller wrote:
> Hi Mauro,
> 
> Am Thu, 20 Jul 2017 12:24:12 -0300
> schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
>> Em Tue, 11 Jul 2017 17:30:13 +0200
>> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
>>
>>> Am Tue, 11 Jul 2017 11:11:27 +0200
>>> schrieb Ralph Metzler <rjkm@metzlerbros.de>:
>>>   
>>>> Daniel Scheller writes:    
>>>>  > 
>>>>  > IIRC this was -main.c, and basically the code split, but no
>>>>  > specific file. However, each of the additionals (hw, io, irq)
>>>>  > were done with a reason (please also see their commit messages
>>>>  > at patches 4-6):
>>>>  > [...]    
>>>>
>>>> As I wrote before, changes like this will break other things like
>>>> the OctopusNet build tree. So, I cannot use them like this or
>>>> without changes at other places. And even if I wanted to, I
>>>> cannot pull anything into the public dddvb repository.    
>>>
>>> Ok, you probably have seen the PRs I created against dddvb, as they
>>> apply basically the same as is contained in this patchset, and even
>>> fixes a few minors. Thus, lets not declare this as merge-blocker for
>>> this patches, please.  
>>
>> I would prefer if we could spend more time trying to find a way where
>> we can proceed without increasing the discrepancies between upstream
>> and DD tree, but, instead to reduce. 
>>
>> I mean, if we know that some change won't be accepted at DD tree,
>> better to change our approach to another one that it is acceptable
>> on both upstream and DD trees.
> 
> (hopefully not too much language barrier coming up...)
> 
> First and foremost (to everyone involved) - I appeal at you all, in
> the name of all DD hardware owners, for like six approaches to get the
> patches in shape and over 1.5 years of spare time spent, to not make
> this a reason to block the patches. And yes, Mauro, I understand
> what you're up to.
> 
> Rather, this closes the gap between the current dddvb drivers and what
> we have in mainline by at least 24 (!!) (plus some minor revisions and
> other intermediate versions I couldn't get tar archives for) software
> releases. Plus, the only real difference we have after these patches is
> support for the DVB-C modulator cards and the OctoNET box support (with
> that, support for the aforementioned GTL links, which I even already
> have a patch for to add that back), and both are features that are
> removed *for now* only due to the API changes involved, which simply is
> a tad too much for me right now to add them in and provide reasoning
> why they're needed and what exactly they do. Speaking of the modulator
> card support, things are even quite simple, see [1] and [2] what I
> gathered from the package to have all things API in place. In
> addition, the parts in ddbridge can be added back quite easily (some
> output-dma things, PCI IDs plus ddbridge-mod[ulator].c). If these two
> simple things are acceptable in DVB core, I can even prepare patches
> for getting the modulator support back in.
> 
> As Ralph mentioned the three additional files -irq, -io and -hw, I do
> not insist on them, but rather thought it'd be a good way to further
> make things cleaner, by separating things more.
> 
> So, again, please do not make this a blocker, but lets rather make this
> a start to get things closer to each other, and continue in doing so by
> finding agreements in parallel. And: I _WILL_ care about keeping the
> mainline version in sync with upstream and NOT diverge further; this is
> what the MAINTAINERS entry is meant for at last!
> 
> [1]
> https://github.com/herrnst/dddvb-linux-kernel/commit/c586db283ef51f43ecb1d1c9e49230184ea02714
> [2]
> https://github.com/herrnst/dddvb-linux-kernel/commit/f448a8485a24acec7b44ac418ef57b59eb8369cd
> 
> All the best,
> Daniel Scheller
> 

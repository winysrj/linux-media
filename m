Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35864 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbbJKLHL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2015 07:07:11 -0400
Received: by oihr205 with SMTP id r205so3559215oih.3
        for <linux-media@vger.kernel.org>; Sun, 11 Oct 2015 04:07:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOS+5GHHPgyXnGncmcLSEXYy7R1CgyODOnFDSetzQ0khrWG+0A@mail.gmail.com>
References: <CAOS+5GGaHQvO30fhgG6PYGc2POHFiFwHvDozZ6k6f_1MEy9_eA@mail.gmail.com>
	<CAGoCfiyuG0q-pCsPsSkMPFa8V+qo97ewY7ngyu4Mhmu_45RDYw@mail.gmail.com>
	<CAOS+5GGC8-Pbx9eoA0eNYU0sH5bEzqUKsuowog2BQ214djUmjA@mail.gmail.com>
	<CAGoCfixkrKSAcY_mmW51OQX7es4tL3_dyWMtbQ6a5oVXjE-5mQ@mail.gmail.com>
	<CAOS+5GGbS+RswFTWVxiPsbZ46OD693qqVHuEdYYmd7JeOUi4Bg@mail.gmail.com>
	<CAOS+5GHHPgyXnGncmcLSEXYy7R1CgyODOnFDSetzQ0khrWG+0A@mail.gmail.com>
Date: Sun, 11 Oct 2015 12:07:10 +0100
Message-ID: <CAOS+5GF43UgzTYAoV88dD=VXOOX0kDstFtG6vZ=w9zOQKz8QEw@mail.gmail.com>
Subject: Re: Elgato Eye TV Deluxe V2 supported?
From: Another Sillyname <anothersname@googlemail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I realise this is from over a year ago but I ended up putting it to
one side till the kernel 'caught up' as it were.

Looking at github/torvalds/linux/tree/master/drivers/media/dvb-frontends
it looks like the as102 support is now in mainline and indeed looking
at staging there's no reference at all to any as102 devices.

I've just installed FC22 Kernel 4-1-10-200 x86_64 onto a box and
installed the required firmware files into /lib/firmware in the hope
the device would now work....unfortunately plugging it in gives me
exactly the same as early last year.....no firmware load even though
dmesg sees the device installed.

Am I still stuck with potentially having to compile a custom kernel to
support this device under Fedora (which isn't an option due to SELinux
issues it would present elsewhere).

Thanks in advance.

On 2 May 2014 at 14:52, Another Sillyname <anothersname@googlemail.com> wrote:
> OK, I realise I should be able to work this out....but I'm stuck and
> no matter how much I read I've developed a mental block (think of it
> as the computing version of writers block).
>
> I use Fedora as my primary OS, currently Fedora 20 latest kernel 3.13
>
> I need to keep using this kernel as I use SELinux for a couple of
> things on my server and compiling a vanilla kernel and patching
> SELinux in is just way too messy........
>
> As the V4L-DVB Media_Tree is NOT included in the kernel-devel version
> of the Fedora kernel it requires a complete kernel compile to download
> the required media tree, however I can't then get the V4L-DVB media
> tree from git to patch against the Fedora (uncompiled) kernel prior to
> compilation, I've installed all the tools required (I have built a few
> kernels before when I needed to) but I've just hit a mental wall......
>
> Help!!
>
>
>
> On 25 April 2014 20:06, Another Sillyname <anothersname@googlemail.com> wrote:
>> OK, I'm not a coder these days but I'll look and see if I can work it out.
>>
>> Regards and have a good weekend.
>>
>> Tony
>>
>> On 25 April 2014 19:54, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
>>>> Is the as102 tree ever likely to go mainline?
>>>
>>> The only reason it's in staging is because it doesn't meet the coding
>>> standards (i.e. whitespace, variable naming, etc).  Somebody needs to
>>> come along and expend the energy to satisfy the whitespace gods.
>>>
>>> Seems like a fantastically stupid reason to keep a working driver out
>>> of the mainline, but that's just my opinion.
>>>
>>> Devin
>>>
>>> --
>>> Devin J. Heitmueller - Kernel Labs
>>> http://www.kernellabs.com

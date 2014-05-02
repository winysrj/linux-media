Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:37790 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaEBNws (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 May 2014 09:52:48 -0400
Received: by mail-oa0-f52.google.com with SMTP id l6so5211741oag.11
        for <linux-media@vger.kernel.org>; Fri, 02 May 2014 06:52:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOS+5GGbS+RswFTWVxiPsbZ46OD693qqVHuEdYYmd7JeOUi4Bg@mail.gmail.com>
References: <CAOS+5GGaHQvO30fhgG6PYGc2POHFiFwHvDozZ6k6f_1MEy9_eA@mail.gmail.com>
	<CAGoCfiyuG0q-pCsPsSkMPFa8V+qo97ewY7ngyu4Mhmu_45RDYw@mail.gmail.com>
	<CAOS+5GGC8-Pbx9eoA0eNYU0sH5bEzqUKsuowog2BQ214djUmjA@mail.gmail.com>
	<CAGoCfixkrKSAcY_mmW51OQX7es4tL3_dyWMtbQ6a5oVXjE-5mQ@mail.gmail.com>
	<CAOS+5GGbS+RswFTWVxiPsbZ46OD693qqVHuEdYYmd7JeOUi4Bg@mail.gmail.com>
Date: Fri, 2 May 2014 14:52:47 +0100
Message-ID: <CAOS+5GHHPgyXnGncmcLSEXYy7R1CgyODOnFDSetzQ0khrWG+0A@mail.gmail.com>
Subject: Re: Elgato Eye TV Deluxe V2 supported?
From: Another Sillyname <anothersname@googlemail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, I realise I should be able to work this out....but I'm stuck and
no matter how much I read I've developed a mental block (think of it
as the computing version of writers block).

I use Fedora as my primary OS, currently Fedora 20 latest kernel 3.13

I need to keep using this kernel as I use SELinux for a couple of
things on my server and compiling a vanilla kernel and patching
SELinux in is just way too messy........

As the V4L-DVB Media_Tree is NOT included in the kernel-devel version
of the Fedora kernel it requires a complete kernel compile to download
the required media tree, however I can't then get the V4L-DVB media
tree from git to patch against the Fedora (uncompiled) kernel prior to
compilation, I've installed all the tools required (I have built a few
kernels before when I needed to) but I've just hit a mental wall......

Help!!



On 25 April 2014 20:06, Another Sillyname <anothersname@googlemail.com> wrote:
> OK, I'm not a coder these days but I'll look and see if I can work it out.
>
> Regards and have a good weekend.
>
> Tony
>
> On 25 April 2014 19:54, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
>>> Is the as102 tree ever likely to go mainline?
>>
>> The only reason it's in staging is because it doesn't meet the coding
>> standards (i.e. whitespace, variable naming, etc).  Somebody needs to
>> come along and expend the energy to satisfy the whitespace gods.
>>
>> Seems like a fantastically stupid reason to keep a working driver out
>> of the mainline, but that's just my opinion.
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com

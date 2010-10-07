Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:35951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab0JGXJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Oct 2010 19:09:30 -0400
Message-ID: <4CAE5324.1050601@redhat.com>
Date: Thu, 07 Oct 2010 20:09:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: [PATCH 01/10] V4L/DVB: cx231xx: remove a printk warning at -avcore
 and at -417
References: <cover.1285699057.git.mchehab@redhat.com>	<20100928154653.785c1f3f@pedra>	<4CAE4020.4000209@redhat.com> <AANLkTimVNUo1UkZQabHnQYZ+=LQGHUhGbaU9Fcot65EE@mail.gmail.com>
In-Reply-To: <AANLkTimVNUo1UkZQabHnQYZ+=LQGHUhGbaU9Fcot65EE@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-10-2010 19:04, Devin Heitmueller escreveu:
> On Thu, Oct 7, 2010 at 5:48 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 28-09-2010 15:46, Mauro Carvalho Chehab escreveu:
>>> drivers/media/video/cx231xx/cx231xx-avcore.c:1608: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘long unsigned int’
>>> drivers/media/video/cx231xx/cx231xx-417.c:1047: warning: format ‘%d’ expects type ‘int’, but argument 3 has type ‘size_t’
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> OK, I just updated my tree with the patches that Mkrufky acked.
>> It basically contains the same patches from my previous post, plus
>> the patches that Palash sent, and Devin/Mkrufky patches from polaris4
>> tree, rebased over the top of kernel v2.6.36-rc7 (this makes easier
>> for me to test and to merge).
>>
>> The patches are at:
>>        http://git.linuxtv.org/mchehab/cx231xx.git
>>
>> Sri already sent his ack for the first series of the patches.
>>
>> The tree contains two extra patches:
>>
>> 1) a cx231xx large CodingStyle fix patch:
>>        http://git.linuxtv.org/mchehab/cx231xx.git?a=commit;h=eacd1a7749ae45d1f2f5782c013b863ff480746d
>>
>> It basically solves the issues that checkpatch.pl complained on this series of patches;
>>
>> 2) a cx231xx-417 gcc warning fix:
>>        http://git.linuxtv.org/mchehab/cx231xx.git?a=commit;h=ca3a6a8c2a4819702e93b9612c4a6d90474ea9b5
>>
>> Devin,
>>
>> Would it be ok for you if I merge them on my main tree? They're needed for one
>> board I'm working with (a Pixelview SBTVD Hybrid - that supports both analog
>> and full-seg ISDB-T).
> 
> Yeah, I've got additional fixes which aren't on that tree yet, but I
> don't see any reason why what's there cannot be merged.

Ok, thanks!

> It would be helpful if you could get Douglas to merge both sets of
> patches (mine and yours) to the hg backport tree as well, so I can
> continue development without requiring the bleeding edge kernel (all
> the work going on is for an embedded target which is running a
> relatively old kernel).

I'm c/c Douglas on this email. Douglas had an ugent issue that required him
to travel abroad. He just returned yesterday night. Let's hope he'll find some
time to sync -hg with -git and backport those patches.

> I've got another couple dozen patches and I'm willing to continue
> pushing this stuff upstream, but you need to meet me halfway here by
> not making the bleeding edge kernel a requirement for this work.

Ok.

Cheers,
Mauro

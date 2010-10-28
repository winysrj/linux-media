Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:36713 "EHLO
	his08.hoogenraad.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755840Ab0J1SCS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 14:02:18 -0400
Message-ID: <4CC9BA90.2080805@hoogenraad.net>
Date: Thu, 28 Oct 2010 20:01:52 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.26 and up: ERRORS
References: <201010271905.o9RJ504u021145@smtp-vbr1.xs4all.nl> <4CC94D5A.3090504@redhat.com>
In-Reply-To: <4CC94D5A.3090504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Douglas:

First of all thank you for the support you have done so far.

Hans:

Is it possible to build the tar from
http://git.linuxtv.org/mchehab/new_build.git
automatically each night, just like the way the hg archive was built ?
I don't have sufficient processing power to run that.

Mauro:

I'm willing to give the mercurial conversion a shot.
I do not know a lot about v4l, but tend to be able to resolve this kind 
of release-type issues.

The way it seems to me is that first new_build.git should compile for 
all releases that the hg archive supported.

Then I'd like some support from you as to transfer all current HG 
branches to the git line. In principle, that should be fixed by the 
maintainers. If the new_build.git complies well, that should be 
relatively straightforward.

For me, it would be great if Mauro could transfer these branches 
automatically at that time to git.




Mauro Carvalho Chehab wrote:
> Hi Hans,
>
> Provided that we're without a maintainer for Mercurial tree, I doubt that anyone would
> fix the problems there. So, I think you should disable the mercurial build reports,
> while we don't have any backport tree maintainer.
>
> Cheers,
> Mauro
>
> Em 27-10-2010 17:05, Hans Verkuil escreveu:
>> This message is generated daily by a cron job that builds v4l-dvb for
>> the kernels and architectures in the list below.
>>
>> Results of the daily build of v4l-dvb:
>>
>> date:        Wed Oct 27 19:00:19 CEST 2010
>> path:        http://www.linuxtv.org/hg/v4l-dvb
>> changeset:   15167:abd3aac6644e
>> git master:       3e6dce76d99b328716b43929b9195adfee1de00c
>> git media-master: a348e9110ddb5d494e060d989b35dd1f35359d58
>> gcc version:      i686-linux-gcc (GCC) 4.5.1
>> host hardware:    x86_64
>> host os:          2.6.32.5
>>
>> linux-git-armv5: WARNINGS
>> linux-git-armv5-davinci: WARNINGS
>> linux-git-armv5-ixp: WARNINGS
>> linux-git-armv5-omap2: WARNINGS
>> linux-git-i686: WARNINGS
>> linux-git-m32r: WARNINGS
>> linux-git-mips: WARNINGS
>> linux-git-powerpc64: WARNINGS
>> linux-git-x86_64: WARNINGS
>> linux-2.6.32.6-armv5: WARNINGS
>> linux-2.6.33-armv5: WARNINGS
>> linux-2.6.34-armv5: WARNINGS
>> linux-2.6.35.3-armv5: WARNINGS
>> linux-2.6.32.6-armv5-davinci: ERRORS
>> linux-2.6.33-armv5-davinci: ERRORS
>> linux-2.6.34-armv5-davinci: ERRORS
>> linux-2.6.35.3-armv5-davinci: ERRORS
>> linux-2.6.32.6-armv5-ixp: ERRORS
>> linux-2.6.33-armv5-ixp: ERRORS
>> linux-2.6.34-armv5-ixp: ERRORS
>> linux-2.6.35.3-armv5-ixp: ERRORS
>> linux-2.6.32.6-armv5-omap2: ERRORS
>> linux-2.6.33-armv5-omap2: ERRORS
>> linux-2.6.34-armv5-omap2: ERRORS
>> linux-2.6.35.3-armv5-omap2: ERRORS
>> linux-2.6.26.8-i686: WARNINGS
>> linux-2.6.27.44-i686: WARNINGS
>> linux-2.6.28.10-i686: WARNINGS
>> linux-2.6.29.1-i686: WARNINGS
>> linux-2.6.30.10-i686: WARNINGS
>> linux-2.6.31.12-i686: WARNINGS
>> linux-2.6.32.6-i686: WARNINGS
>> linux-2.6.33-i686: WARNINGS
>> linux-2.6.34-i686: WARNINGS
>> linux-2.6.35.3-i686: WARNINGS
>> linux-2.6.32.6-m32r: WARNINGS
>> linux-2.6.33-m32r: WARNINGS
>> linux-2.6.34-m32r: WARNINGS
>> linux-2.6.35.3-m32r: WARNINGS
>> linux-2.6.32.6-mips: WARNINGS
>> linux-2.6.33-mips: WARNINGS
>> linux-2.6.34-mips: WARNINGS
>> linux-2.6.35.3-mips: WARNINGS
>> linux-2.6.32.6-powerpc64: WARNINGS
>> linux-2.6.33-powerpc64: WARNINGS
>> linux-2.6.34-powerpc64: WARNINGS
>> linux-2.6.35.3-powerpc64: WARNINGS
>> linux-2.6.26.8-x86_64: WARNINGS
>> linux-2.6.27.44-x86_64: WARNINGS
>> linux-2.6.28.10-x86_64: WARNINGS
>> linux-2.6.29.1-x86_64: WARNINGS
>> linux-2.6.30.10-x86_64: WARNINGS
>> linux-2.6.31.12-x86_64: WARNINGS
>> linux-2.6.32.6-x86_64: WARNINGS
>> linux-2.6.33-x86_64: WARNINGS
>> linux-2.6.34-x86_64: WARNINGS
>> linux-2.6.35.3-x86_64: WARNINGS
>> spec-git: OK
>> sparse: ERRORS
>>
>> Detailed results are available here:
>>
>> http://www.xs4all.nl/~hverkuil/logs/Wednesday.log
>>
>> Full logs are available here:
>>
>> http://www.xs4all.nl/~hverkuil/logs/Wednesday.tar.bz2
>>
>> The V4L-DVB specification from this daily build is here:
>>
>> http://www.xs4all.nl/~hverkuil/spec/media.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht

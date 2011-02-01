Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab1BAWmD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Feb 2011 17:42:03 -0500
Message-ID: <4D488C17.7040706@redhat.com>
Date: Tue, 01 Feb 2011 20:41:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Dmitry Butskoy <buc@odusz.so-cdu.ru>
Subject: Re: Call for testers: V4L1 support dropped from xawtv - Was: Re:
 Call for testers: V4L1 support dropped from tvtime
References: <AANLkTim5xNN3rS7QuuhOjpRL=XN8Kuy-qoaABMe7dCZE@mail.gmail.com> <4D483044.4030303@redhat.com>
In-Reply-To: <4D483044.4030303@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-02-2011 14:09, Mauro Carvalho Chehab escreveu:
> Em 01-02-2011 12:51, Devin Heitmueller escreveu:
>> I know this is the linux-media mailing list and not the tvtime mailing
>> list, but it seems relevant given the overlap in the user base and the
>> fact that these changes are specifically in response to recent events
>> with v4l-dvb.
>>
>> I have modified the KernelLabs build of tvtime to no longer depend on V4L1.
>>
>> The tree can be found here:
>>
>> http://www.kernellabs.com/hg/~dheitmueller/tvtime
>>
>> More info including build instructions can be found here:
>>
>> http://www.kernellabs.com/blog
> 
> Let me take a ride at Devin's call for tests ;)
> 
> I've also dropped V4L1 support from xawtv3 a few days ago. It would be
> wonderful if people could test it. The upstream git tree is at:
> 	http://git.linuxtv.org/xawtv3.git
> 
> A tarball for the latest version is at:
> 	http://linuxtv.org/downloads/xawtv/xawtv-3.99.rc1.tar.bz2
> 
> For those that use Fedora, there are some rpm available For FC14/FC15 at:
> 	http://kojipkgs.fedoraproject.org/packages/xawtv/3.99.rc1/
> 
> There's just one know caveat that affects mostly webcam usage. Xawtv now has two 
> V4L2 plugins, one with libv4l and another with just v4l2. Currently, there's no 
> way to select between them. I need some time to do a research about it and write
> a patch to address this issue.

Ok, I've added a patch fixing the libv4l issue, and released a -rc2 version of it.

All patches that were found in Fedora for F14 are now upstream. There's just one
patch at F15 that it is not upstream yet (a compilation breakage).

The new tarball is available at:
	http://linuxtv.org/downloads/xawtv/

And the Fedora packages are at:
	http://kojipkgs.fedoraproject.org/packages/xawtv/

Dmitry is looking some patches at Debian to apply upstream. After having them applied,
and getting some feedback, I'll release xawtv version 3.100.

Cheers,
Mauro.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-d01.mx.aol.com ([205.188.252.208]:42310 "EHLO
	omr-d01.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab3GQODI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 10:03:08 -0400
Message-ID: <51E6A20B.8020507@netscape.net>
Date: Wed, 17 Jul 2013 10:54:19 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: mb86a20s and cx23885
References: <51054759.7050202@netscape.net> <20130127141633.5f751e5d@redhat.com> <5105A0C9.6070007@netscape.net> <20130128082354.607fae64@redhat.com> <5106E3EA.70307@netscape.net> <511264CF.3010002@netscape.net> <51336331.10205@netscape.net> <20130303134051.6dc038aa@redhat.com> <20130304164234.18df36a7@redhat.com> <51353591.4040709@netscape.net> <20130304233028.7bc3c86c@redhat.com> <513A6968.4070803@netscape.net> <515A0D03.7040802@netscape.net> <51E44DCA.8060702@netscape.net> <20130716053030.3fda034e.mchehab@infradead.org>
In-Reply-To: <20130716053030.3fda034e.mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

El 15/07/13 17:30, Mauro Carvalho Chehab escribió:
> Em Mon, 15 Jul 2013 16:30:18 -0300
> Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:
>
>> Hi all
>>
>> After some time trying to see what the problem is, I have found it is
>> not come the RF signal.
>>
>> I've gone back using a 3.2 kernel, after doing a couple of tests, the
>> board works :-)
>> When I try to apply these changes to a 3.4 or later kernel does not tune
>> plate.
>>
>> Between 3.2 and 3.4 kernel there are several changes to the drivers:
>> CX23885, xc5000 and mb86a20s. I tried to cancel several of them on a 3.4
>> kernel, but I can not make the card tune.
> If you know already that the breakage happened between 3.2 and 3.4, the better
> is to use git bisect to discover what patch broke it.

Mauro Thanks for the suggestion.
This weekend I have some time and I'll study how to implement it.

I guess it's do something similar to:

~ $ git clone git://linuxtv.org/media_build.git
~ $ cd media_build
~/media_build $./build --main-git
~/media_build $ cd media
~/media $ gedit drivers/media/video/foo.c
~/media $ make -C ../v4l
~/media $ make -C ../ install
~/media $ make -C .. rmmod
~/media $ modprobe foo


>
> You can do (using Linus git tree):
>
> 	git checkout v3.4
> 	git bisect bad
> 	git checkout good v3.2

Where is the git tree of Linus in <git://git.kernel.org/> or 
<git://linuxtv.org/>?

Thanks again,

Alfredo


>
> git bisect will then do a binary search between those two kernels. All you
> have to do is to recompile the Kernel and test it. Then you'll tag the
> changeset as "bad" or "good", until the end of the search. In general, you'll
> discover the changeset responsible for the breakage after a few (8-10)
> interactions.
>
> For more reference, you can take a look, for example, at:
> 	http://git-scm.com/book/en/Git-Tools-Debugging-with-Git
>
> Regards,
> Mauro
>
> PS.: Someone should fix our wiki, as it is still pointing to hg bisect,
> instead of pointing to git bisect.
>
>> The changes I have applied to kernel 3.2 are:
>


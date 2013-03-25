Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:46336 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3CYStc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 14:49:32 -0400
Received: by mail-ee0-f53.google.com with SMTP id c13so662607eek.40
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 11:49:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOS+5GE9iqKhLdR29T+gVUxs6ALo1e=Wu47bqR2ehYKnAxk-zQ@mail.gmail.com>
References: <CAJQRBiXa2uhbfuGaf51RheKLzLeXbz67UgKeftuBw9hSKS8wVA@mail.gmail.com>
	<201303251538.19558.hverkuil@xs4all.nl>
	<CAOS+5GHamA6NCoXRcpesGcCSWat037=LTrDZO3feuuivHg-1bg@mail.gmail.com>
	<201303251617.33672.hverkuil@xs4all.nl>
	<CAOS+5GE9iqKhLdR29T+gVUxs6ALo1e=Wu47bqR2ehYKnAxk-zQ@mail.gmail.com>
Date: Mon, 25 Mar 2013 18:49:30 +0000
Message-ID: <CAOS+5GFoO1miRU31tXtU6WNTsQM3YH7QVf3-FUiFQ7dVuQUODw@mail.gmail.com>
Subject: Re: media_build build is broken
From: Another Sillyname <anothersname@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry feeling a bit thick now.......

Never done a rollback using git and thought it would be
straightforward as subversion, however I hadn't realised that the
build is actually pulling the latest head version as part of the build
itself.

Had a play around trying to use git reset --hard xxxxxxx to get to a
previous version on 8th March however my command of git is somewhat
limited and although I've googled I can't see how to achieve this
easily.

If someone on the list could let me know a quick way of going back to
99fa97227ee3f4728d16c0db214637e2b61fa128 on the 8th March I'd be
grateful.

Regards

On 25 March 2013 18:47, Another Sillyname <anothersname@googlemail.com> wrote:
> Sorry feeling a bit thick now.......
>
> Never done a rollback using git and thought it would be
> straightforward as subversion, however I hadn't realised that the
> build is actually pulling the latest head version as part of the build
> itself.
>
> Had a play around trying to use git reset --hard xxxxxxx to get to a
> previous version on 8th March however my command of git is somewhat
> limited and although I've googled I can't see how to achieve this
> easily.
>
> If someone on the list could let me know a quick way of going back to
> 99fa97227ee3f4728d16c0db214637e2b61fa128 on the 8th March I'd be
> grateful.
>
> Regards
>
>
>
> On 25 March 2013 15:17, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On Mon March 25 2013 16:14:26 Another Sillyname wrote:
>>> Cripes that's hilarious.....
>>>
>>> I was just about to post this as well, Fed 18 x86_64 blah blah blah.....
>>>
>>> Hans, how far back do I need to go on git to get a good build version
>>> please, I'm building a new box today and only have a few days to test
>>> before buggering off for a few weeks.
>>
>> It was working a week ago.
>>
>> Regards,
>>
>>         Hans
>>
>>>
>>> Thanks
>>>
>>> On 25 March 2013 14:38, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> > On Mon March 25 2013 15:33:08 Anthony Horton wrote:
>>> >> Apologies is this is already known about but I couldn't find anything
>>> >> when I searched.
>>> >>
>>> >> The media_build tree appears to be currently broken, at least for my
>>> >> build environment (Fedora 18, gcc 4.7.2, 3.8.4-202.fc18.x86_64
>>> >> kernel).
>>> >
>>> > Lots of code has been merged in the past few days, and this is still
>>> > ongoing. Once things have settled a bit I'll work on fixing media_build.
>>> > It should be fixed this week, likely sooner rather than later.
>>> >
>>> > Regards,
>>> >
>>> >         Hans
>>> >
>>> >>
>>> >> $ git clone git://linuxtv.org/media_build.git
>>> >> $ cd media_build/
>>> >> $./build
>>> >> Checking if the needed tools for Fedora release 18 (Spherical Cow) are available
>>> >> Needed package dependencies are met.
>>> >> ...
>>> >> <lots of output>
>>> >> ...
>>> >>   CC [M]  /home/username/build/v4l/media_build/v4l/mem2mem_testdev.o
>>> >>   CC [M]  /home/username/build/v4l/media_build/v4l/sh_veu.o
>>> >> /home/username/build/v4l/media_build/v4l/sh_veu.c: In function 'sh_veu_probe':
>>> >> /home/username/build/v4l/media_build/v4l/sh_veu.c:1168:2: error:
>>> >> implicit declaration of function 'devm_ioremap_resource'
>>> >> [-Werror=implicit-function-declaration]
>>> >> /home/username/build/v4l/media_build/v4l/sh_veu.c:1168:12: warning:
>>> >> assignment makes pointer from integer without a cast [enabled by
>>> >> default]
>>> >> /home/username/build/v4l/media_build/v4l/sh_veu.c: At top level:
>>> >> /home/username/build/v4l/media_build/v4l/sh_veu.c:1252:1: warning:
>>> >> data definition has no type or storage class [enabled by default]
>>> >> /home/username/build/v4l/media_build/v4l/sh_veu.c:1252:1: warning:
>>> >> type defaults to 'int' in declaration of
>>> >> 'module_platform_driver_probe' [-Wimplicit-int]
>>> >> /home/username/build/v4l/media_build/v4l/sh_veu.c:1252:1: warning:
>>> >> parameter names (without types) in function declaration [enabled by
>>> >> default]
>>> >> /home/username/build/v4l/media_build/v4l/sh_veu.c:1147:12: warning:
>>> >> 'sh_veu_probe' defined but not used [-Wunused-function]
>>> >> /home/username/build/v4l/media_build/v4l/sh_veu.c:1244:41: warning:
>>> >> 'sh_veu_pdrv' defined but not used [-Wunused-variable]
>>> >> cc1: some warnings being treated as errors
>>> >> make[3]: *** [/home/username/build/v4l/media_build/v4l/sh_veu.o] Error 1
>>> >> make[2]: *** [_module_/home/username/build/v4l/media_build/v4l] Error 2
>>> >> make[2]: Leaving directory `/usr/src/kernels/3.8.4-202.fc18.x86_64'
>>> >> make[1]: *** [default] Error 2
>>> >> make[1]: Leaving directory `/home/username/build/v4l/media_build/v4l'
>>> >> make: *** [all] Error 2
>>> >> build failed at ./build line 452.
>>> >>
>>> >> This seems to be a recent regression, I successfully built from
>>> >> media_build on another Fedora 18 machine just a couple of weeks ago.
>>> >> --
>>> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> >> the body of a message to majordomo@vger.kernel.org
>>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> >>
>>> > --
>>> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> > the body of a message to majordomo@vger.kernel.org
>>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>

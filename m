Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57312 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbbASOKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 09:10:05 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so1879313wgh.6
        for <linux-media@vger.kernel.org>; Mon, 19 Jan 2015 06:10:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150119123212.GA33475@shambles.windy>
References: <20150119123212.GA33475@shambles.windy>
Date: Mon, 19 Jan 2015 15:10:03 +0100
Message-ID: <CAPx3zdQnvc7g1Z=bORWoCodV0E_-fUdvAwPsvvLne1Fj=z9N8g@mail.gmail.com>
Subject: Re: build failure on ubuntu 14.04.1 LTS
From: Francesco Other <francesco.other@gmail.com>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vincent,

you may use this workaround, I have the same problem:
https://github.com/ljalves/linux_media/issues/68

Reagrds

Francesco


2015-01-19 13:32 GMT+01:00 Vincent McIntyre <vincent.mcintyre@gmail.com>:
> Hi
>
> I am seeing build failures since 11 January.
> A build I did on 22 December worked fine.
> My build procedure and the error are shown below.
>
> $ cat /etc/lsb-release
> DISTRIB_ID=Ubuntu
> DISTRIB_RELEASE=14.04
> DISTRIB_CODENAME=trusty
> DISTRIB_DESCRIPTION="Ubuntu 14.04.1 LTS"
> $ uname -a
> Linux ubuntu 3.13.0-37-generic #64-Ubuntu SMP Mon Sep 22 21:30:01 UTC 2014 i686 i686 i686 GNU/Linux
> $ make distclean
> $ rm v4l/.config
> $ git pull
> $ git log |head
> commit de98549b53c938b44f578833fe8440b92f4a8c64
> Author: Hans Verkuil <hans.verkuil@cisco.com>
> Date:   Mon Jan 12 10:53:27 2015 +0100
>
>     Update v3.11_dev_groups.patch
>
>     Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> commit 3886d538f89948d49b652465e0d52e6e9a7329ab
> Author: Hans Verkuil <hans.verkuil@cisco.com>
>
> $ ./build --main-git
> ...
>   CC [M]  /home/me/git/clones/media_build/v4l/smiapp-core.o
> /home/me/git/clones/media_build/v4l/smiapp-core.c: In function 'smiapp_get_pdata':
> /home/me/git/clones/media_build/v4l/smiapp-core.c:3061:3: error: implicit declaration of function 'of_read_number' [-Werror=implicit-function-declaration]
>    pdata->op_sys_clock[i] = of_read_number(val + i * 2, 2);
>    ^
> cc1: some warnings being treated as errors
> make[3]: *** [/home/me/git/clones/media_build/v4l/smiapp-core.o] Error 1
> make[2]: *** [_module_/home/me/git/clones/media_build/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-3.13.0-37-generic'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/me/git/clones/media_build/v4l'
> make: *** [all] Error 2
> build failed at ./build line 491, <IN> line 4.
>
> $ grep -ilr "implicit-function-declaration" . |grep -v o.cmd
> ./media/tools/thermal/tmon/Makefile
> ./media/arch/parisc/math-emu/Makefile
> ./media/Makefile
>
> It's not clear to me whether this a problem with the media_tree code
> or the media_build code.
>
> media/Makefile contains this definition
>
> KBUILD_CFLAGS := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
>                  -fno-strict-aliasing -fno-common \
>                  -Werror-implicit-function-declaration \
>                  -Wno-format-security \
>                  -std=gnu89
>
> Regards
> Vince
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

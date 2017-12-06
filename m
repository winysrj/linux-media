Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:43514 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754942AbdLFLOK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Dec 2017 06:14:10 -0500
Subject: Re: build failure on ubuntu 16.04 LTS
To: Vincent McIntyre <vincent.mcintyre@gmail.com>,
        linux-media@vger.kernel.org
References: <20171206104324.GA7941@ubuntu.windy>
Cc: "Jasmin J." <jasmin@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <678e6f04-187b-48bf-52a1-c431c6df94bf@xs4all.nl>
Date: Wed, 6 Dec 2017 12:14:05 +0100
MIME-Version: 1.0
In-Reply-To: <20171206104324.GA7941@ubuntu.windy>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/17 11:43, Vincent McIntyre wrote:
> Hi,
> 
> the build has been broken for over a week for me.
> Possibly my checkout is out of date??

No, it really is broken. I don't quite understand why it is failing or
how to fix it, and I lack time to dig into this. Hopefully I can find
some time next week for this.

Jasmin, you've done some work on this in the past. Let me know if you
have time to look at this, I would really appreciate that.

Regards,

	Hans

> I am using the normal build --main-git method.
> 
> Setup details:
> 
> + date
> Wednesday 6 December  21:25:28 AEDT 2017
> + uname -a
> Linux ubuntu 4.4.0-101-generic #124-Ubuntu SMP Fri Nov 10 18:29:59 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> + cat /proc/version_signature
> Ubuntu 4.4.0-101.124-generic 4.4.95
> 
> + git --no-pager log -1
> commit 320b9b80ebbf318a67a9479c18a0e4be244c8409
> Author: Hans Verkuil <hans.verkuil@cisco.com>
> Date:   Tue Nov 28 08:48:04 2017 +0100
> 
>     Update backports/pr_fmt.patch
> 
>     Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> + cd media
> + git --no-pager log -1
> commit 781b045baefdabf7e0bc9f33672ca830d3db9f27
> Author: Sakari Ailus <sakari.ailus@linux.intel.com>
> Date:   Wed Nov 1 05:40:58 2017 -0400
> 
>     media: imx274: Fix error handling, add MAINTAINERS entry
> 
>     Add the missing MAINTAINERS entry for imx274, fix error handling in driver
>     probe and unregister the correct control handler in driver remove.
> 
>     Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> 
> This is the build failure
> ...
> 
> Created default (all yes) .config file
> ./scripts/fix_kconfig.pl
> make[1]: Leaving directory '/home/me/git/clones/media_build/v4l'
> $ make
> make -C /home/me/git/clones/media_build/v4l
> make[1]: Entering directory '/home/me/git/clones/media_build/v4l'
> scripts/make_makefile.pl
> ./scripts/make_myconfig.pl
> perl scripts/make_config_compat.pl /lib/modules/4.4.0-101-generic/build ./.myconfig ./config-compat.h
> creating symbolic links...
> Kernel build directory is /lib/modules/4.4.0-101-generic/build
> make -C ../linux apply_patches
> make[2]: Entering directory '/home/me/git/clones/media_build/linux'
> Syncing with dir ../media/
> Patches for 4.4.0-101-generic already applied.
> make[2]: Leaving directory '/home/me/git/clones/media_build/linux'
> make -C /lib/modules/4.4.0-101-generic/build SUBDIRS=/home/me/git/clones/media_build/v4l  modules
> make[2]: Entering directory '/usr/src/linux-headers-4.4.0-101-generic'
>   CC [M]  /home/me/git/clones/media_build/v4l/msp3400-driver.o
> In file included from include/linux/compiler.h:56:0,
>                  from include/asm-generic/bug.h:4,
>                  from ./arch/x86/include/asm/bug.h:35,
>                  from include/linux/bug.h:4,
>                  from include/linux/mmdebug.h:4,
>                  from /home/me/git/clones/media_build/v4l/config-compat.h:12,
>                  from /home/me/git/clones/media_build/v4l/compat.h:10,
>                  from <command-line>:0:
> /home/me/git/clones/media_build/v4l/../linux/include/linux/compiler-gcc.h:3:2: error: #error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
>  #error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
>   ^
> scripts/Makefile.build:258: recipe for target '/home/me/git/clones/media_build/v4l/msp3400-driver.o' failed
> make[3]: *** [/home/me/git/clones/media_build/v4l/msp3400-driver.o] Error 1
> Makefile:1423: recipe for target '_module_/home/me/git/clones/media_build/v4l' failed
> make[2]: *** [_module_/home/me/git/clones/media_build/v4l] Error 2
> make[2]: Leaving directory '/usr/src/linux-headers-4.4.0-101-generic'
> Makefile:51: recipe for target 'default' failed
> make[1]: *** [default] Error 2
> make[1]: Leaving directory '/home/me/git/clones/media_build/v4l'
> Makefile:26: recipe for target 'all' failed
> make: *** [all] Error 2
> build failed at ./build line 526
> + status=29
> 
> I'm struggling to follow the depedency chain here so I thought I'd better ask.
> 
> ubuntu(master)$ grep -r compiler-gcc.h|grep -F '#include'
> 
> media/include/linux/compiler_types.h:#include <linux/compiler-gcc.h>
> media/tools/include/linux/compiler.h:#include <linux/compiler-gcc.h>
> 
> Cheers
> Vince
> 
> 

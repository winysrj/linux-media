Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59259 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751033AbdFSTUj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 15:20:39 -0400
Subject: Re: [media-build] Can't compile for Kernel 3.13 after recent changes
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <e7955c6a-06d4-1cf4-f776-f0db0bd61f18@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2d7876e4-5c56-4b48-cdaf-5810f355ba7b@xs4all.nl>
Date: Mon, 19 Jun 2017 21:20:29 +0200
MIME-Version: 1.0
In-Reply-To: <e7955c6a-06d4-1cf4-f776-f0db0bd61f18@anw.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/19/2017 08:43 PM, Jasmin J. wrote:
> Hi!
> 
> After the recent changes, I can no longer compile for Kernel 3.13

I know. I haven't had time to look at this and fix it. It probably won't be until
early next week due to some travel.

Regards,

	Hans

> 
> BR,
>     Jasmin
> 
> Here the build Log:
> 
> Kernel build directory is /lib/modules/3.13.0-117-generic/build
> make -C ../linux apply_patches
> make[2]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
> Patches for 3.13.0-117-generic already applied.
> make[2]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/linux'
> make -C /lib/modules/3.13.0-117-generic/build SUBDIRS=/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l  modules
> make[2]: Entering directory '/mnt/home_hdd/jasmin/vdr/dd_driver/linux-headers-3.13.0-117-generic'
>    CC [M]  /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-lpt.o
>    CC [M]  /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-jtag.o
>    CC [M]  /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-comp.o
> In file included from <command-line>:0:0:
> /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/compat.h: In function 'dev_fwnode':
> /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/compat.h:2017:12: error: 'struct device' has no member named 'fwnode'
>    return dev->fwnode;
>              ^
> /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-lpt.c: At top level:
> cc1: warning: unrecognized command line option '-Wno-implicit-fallthrough'
> cc1: warning: unrecognized command line option '-Wno-unused-const-variable'
> scripts/Makefile.build:308: recipe for target '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-lpt.o' failed
> make[3]: *** [/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-lpt.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> In file included from <command-line>:0:0:
> /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/compat.h: In function 'dev_fwnode':
> /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/compat.h:2017:12: error: 'struct device' has no member named 'fwnode'
>    return dev->fwnode;
>              ^
> /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-comp.c: At top level:
> cc1: warning: unrecognized command line option '-Wno-implicit-fallthrough'
> cc1: warning: unrecognized command line option '-Wno-unused-const-variable'
> scripts/Makefile.build:308: recipe for target '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-comp.o' failed
> make[3]: *** [/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-comp.o] Error 1
> In file included from <command-line>:0:0:
> /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/compat.h: In function 'dev_fwnode':
> /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/compat.h:2017:12: error: 'struct device' has no member named 'fwnode'
>    return dev->fwnode;
>              ^
> /mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-jtag.c: At top level:
> cc1: warning: unrecognized command line option '-Wno-implicit-fallthrough'
> cc1: warning: unrecognized command line option '-Wno-unused-const-variable'
> scripts/Makefile.build:308: recipe for target '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-jtag.o' failed
> make[3]: *** [/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l/altera-jtag.o] Error 1
> Makefile:1279: recipe for target '_module_/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l' failed
> make[2]: *** [_module_/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l] Error 2
> make[2]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/linux-headers-3.13.0-117-generic'
> Makefile:51: recipe for target 'default' failed
> make[1]: *** [default] Error 2
> make[1]: Leaving directory '/mnt/home_hdd/jasmin/vdr/dd_driver/git/media_build/v4l'
> Makefile:26: recipe for target 'all' failed
> 

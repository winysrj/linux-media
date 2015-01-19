Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59798 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbbASMc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2015 07:32:26 -0500
Received: by mail-pd0-f178.google.com with SMTP id r10so36309849pdi.9
        for <linux-media@vger.kernel.org>; Mon, 19 Jan 2015 04:32:26 -0800 (PST)
Date: Mon, 19 Jan 2015 23:32:14 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: build failure on ubuntu 14.04.1 LTS
Message-ID: <20150119123212.GA33475@shambles.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I am seeing build failures since 11 January.
A build I did on 22 December worked fine.
My build procedure and the error are shown below.

$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=14.04
DISTRIB_CODENAME=trusty
DISTRIB_DESCRIPTION="Ubuntu 14.04.1 LTS"
$ uname -a
Linux ubuntu 3.13.0-37-generic #64-Ubuntu SMP Mon Sep 22 21:30:01 UTC 2014 i686 i686 i686 GNU/Linux
$ make distclean
$ rm v4l/.config
$ git pull
$ git log |head
commit de98549b53c938b44f578833fe8440b92f4a8c64
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Mon Jan 12 10:53:27 2015 +0100

    Update v3.11_dev_groups.patch
    
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

commit 3886d538f89948d49b652465e0d52e6e9a7329ab
Author: Hans Verkuil <hans.verkuil@cisco.com>

$ ./build --main-git
...
  CC [M]  /home/me/git/clones/media_build/v4l/smiapp-core.o
/home/me/git/clones/media_build/v4l/smiapp-core.c: In function 'smiapp_get_pdata':
/home/me/git/clones/media_build/v4l/smiapp-core.c:3061:3: error: implicit declaration of function 'of_read_number' [-Werror=implicit-function-declaration]
   pdata->op_sys_clock[i] = of_read_number(val + i * 2, 2);
   ^
cc1: some warnings being treated as errors
make[3]: *** [/home/me/git/clones/media_build/v4l/smiapp-core.o] Error 1
make[2]: *** [_module_/home/me/git/clones/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-3.13.0-37-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/me/git/clones/media_build/v4l'
make: *** [all] Error 2
build failed at ./build line 491, <IN> line 4.

$ grep -ilr "implicit-function-declaration" . |grep -v o.cmd
./media/tools/thermal/tmon/Makefile
./media/arch/parisc/math-emu/Makefile
./media/Makefile

It's not clear to me whether this a problem with the media_tree code
or the media_build code.

media/Makefile contains this definition

KBUILD_CFLAGS := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
                 -fno-strict-aliasing -fno-common \
                 -Werror-implicit-function-declaration \
                 -Wno-format-security \
                 -std=gnu89

Regards
Vince

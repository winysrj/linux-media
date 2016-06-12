Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33639 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbcFLPBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2016 11:01:00 -0400
Received: by mail-oi0-f44.google.com with SMTP id u201so48889522oie.0
        for <linux-media@vger.kernel.org>; Sun, 12 Jun 2016 08:01:00 -0700 (PDT)
MIME-Version: 1.0
From: Kenny Ho <y2kenny@gmail.com>
Date: Sun, 12 Jun 2016 11:00:58 -0400
Message-ID: <CAOWid-cb+sAat6Y9WT3K+p5P8BmyWoXO37+xGY=9+zQVKdPGNA@mail.gmail.com>
Subject: Build failure on Ubuntu 16.04
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

make -C /home/kho/git/media_build/v4l allyesconfig
make[1]: Entering directory '/home/kho/git/media_build/v4l'
No version yet, using 4.4.0-24-generic
make[2]: Entering directory '/home/kho/git/media_build/linux'
Applying patches for kernel 4.4.0-24-generic
patch -s -f -N -p1 -i ../backports/api_version.patch
patch -s -f -N -p1 -i ../backports/pr_fmt.patch
patch -s -f -N -p1 -i ../backports/debug.patch
patch -s -f -N -p1 -i ../backports/drx39xxj.patch
patch -s -f -N -p1 -i ../backports/v4.6_i2c_mux.patch
2 out of 23 hunks FAILED
Makefile:137: recipe for target 'apply_patches' failed
make[2]: *** [apply_patches] Error 1
make[2]: Leaving directory '/home/kho/git/media_build/linux'
Makefile:369: recipe for target 'allyesconfig' failed
make[1]: *** [allyesconfig] Error 2
make[1]: Leaving directory '/home/kho/git/media_build/v4l'
Makefile:26: recipe for target 'allyesconfig' failed
make: *** [allyesconfig] Error 2
can't select all drivers at ./build line 490.

$ lsb_release -a
No LSB modules are available.
Distributor ID:    Ubuntu
Description:    Ubuntu 16.04 LTS
Release:    16.04
Codename:    xenial

$ uname -a
Linux stationx 4.4.0-24-generic #43-Ubuntu SMP Wed Jun 8 19:27:37 UTC
2016 x86_64 x86_64 x86_64 GNU/Linux

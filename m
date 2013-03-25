Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63551 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758500Ab3CYOdc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 10:33:32 -0400
Received: by mail-wi0-f175.google.com with SMTP id c10so4880448wiw.2
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 07:33:31 -0700 (PDT)
MIME-Version: 1.0
From: Anthony Horton <anthony.horton@drhotdog.net>
Date: Tue, 26 Mar 2013 01:33:08 +1100
Message-ID: <CAJQRBiXa2uhbfuGaf51RheKLzLeXbz67UgKeftuBw9hSKS8wVA@mail.gmail.com>
Subject: media_build build is broken
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Apologies is this is already known about but I couldn't find anything
when I searched.

The media_build tree appears to be currently broken, at least for my
build environment (Fedora 18, gcc 4.7.2, 3.8.4-202.fc18.x86_64
kernel).

$ git clone git://linuxtv.org/media_build.git
$ cd media_build/
$./build
Checking if the needed tools for Fedora release 18 (Spherical Cow) are available
Needed package dependencies are met.
...
<lots of output>
...
  CC [M]  /home/username/build/v4l/media_build/v4l/mem2mem_testdev.o
  CC [M]  /home/username/build/v4l/media_build/v4l/sh_veu.o
/home/username/build/v4l/media_build/v4l/sh_veu.c: In function 'sh_veu_probe':
/home/username/build/v4l/media_build/v4l/sh_veu.c:1168:2: error:
implicit declaration of function 'devm_ioremap_resource'
[-Werror=implicit-function-declaration]
/home/username/build/v4l/media_build/v4l/sh_veu.c:1168:12: warning:
assignment makes pointer from integer without a cast [enabled by
default]
/home/username/build/v4l/media_build/v4l/sh_veu.c: At top level:
/home/username/build/v4l/media_build/v4l/sh_veu.c:1252:1: warning:
data definition has no type or storage class [enabled by default]
/home/username/build/v4l/media_build/v4l/sh_veu.c:1252:1: warning:
type defaults to 'int' in declaration of
'module_platform_driver_probe' [-Wimplicit-int]
/home/username/build/v4l/media_build/v4l/sh_veu.c:1252:1: warning:
parameter names (without types) in function declaration [enabled by
default]
/home/username/build/v4l/media_build/v4l/sh_veu.c:1147:12: warning:
'sh_veu_probe' defined but not used [-Wunused-function]
/home/username/build/v4l/media_build/v4l/sh_veu.c:1244:41: warning:
'sh_veu_pdrv' defined but not used [-Wunused-variable]
cc1: some warnings being treated as errors
make[3]: *** [/home/username/build/v4l/media_build/v4l/sh_veu.o] Error 1
make[2]: *** [_module_/home/username/build/v4l/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/3.8.4-202.fc18.x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/username/build/v4l/media_build/v4l'
make: *** [all] Error 2
build failed at ./build line 452.

This seems to be a recent regression, I successfully built from
media_build on another Fedora 18 machine just a couple of weeks ago.

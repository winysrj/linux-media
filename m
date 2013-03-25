Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2002 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3CYOi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 10:38:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Anthony Horton <anthony.horton@drhotdog.net>
Subject: Re: media_build build is broken
Date: Mon, 25 Mar 2013 15:38:19 +0100
Cc: linux-media@vger.kernel.org
References: <CAJQRBiXa2uhbfuGaf51RheKLzLeXbz67UgKeftuBw9hSKS8wVA@mail.gmail.com>
In-Reply-To: <CAJQRBiXa2uhbfuGaf51RheKLzLeXbz67UgKeftuBw9hSKS8wVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251538.19558.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon March 25 2013 15:33:08 Anthony Horton wrote:
> Apologies is this is already known about but I couldn't find anything
> when I searched.
> 
> The media_build tree appears to be currently broken, at least for my
> build environment (Fedora 18, gcc 4.7.2, 3.8.4-202.fc18.x86_64
> kernel).

Lots of code has been merged in the past few days, and this is still
ongoing. Once things have settled a bit I'll work on fixing media_build.
It should be fixed this week, likely sooner rather than later.

Regards,

	Hans

> 
> $ git clone git://linuxtv.org/media_build.git
> $ cd media_build/
> $./build
> Checking if the needed tools for Fedora release 18 (Spherical Cow) are available
> Needed package dependencies are met.
> ...
> <lots of output>
> ...
>   CC [M]  /home/username/build/v4l/media_build/v4l/mem2mem_testdev.o
>   CC [M]  /home/username/build/v4l/media_build/v4l/sh_veu.o
> /home/username/build/v4l/media_build/v4l/sh_veu.c: In function 'sh_veu_probe':
> /home/username/build/v4l/media_build/v4l/sh_veu.c:1168:2: error:
> implicit declaration of function 'devm_ioremap_resource'
> [-Werror=implicit-function-declaration]
> /home/username/build/v4l/media_build/v4l/sh_veu.c:1168:12: warning:
> assignment makes pointer from integer without a cast [enabled by
> default]
> /home/username/build/v4l/media_build/v4l/sh_veu.c: At top level:
> /home/username/build/v4l/media_build/v4l/sh_veu.c:1252:1: warning:
> data definition has no type or storage class [enabled by default]
> /home/username/build/v4l/media_build/v4l/sh_veu.c:1252:1: warning:
> type defaults to 'int' in declaration of
> 'module_platform_driver_probe' [-Wimplicit-int]
> /home/username/build/v4l/media_build/v4l/sh_veu.c:1252:1: warning:
> parameter names (without types) in function declaration [enabled by
> default]
> /home/username/build/v4l/media_build/v4l/sh_veu.c:1147:12: warning:
> 'sh_veu_probe' defined but not used [-Wunused-function]
> /home/username/build/v4l/media_build/v4l/sh_veu.c:1244:41: warning:
> 'sh_veu_pdrv' defined but not used [-Wunused-variable]
> cc1: some warnings being treated as errors
> make[3]: *** [/home/username/build/v4l/media_build/v4l/sh_veu.o] Error 1
> make[2]: *** [_module_/home/username/build/v4l/media_build/v4l] Error 2
> make[2]: Leaving directory `/usr/src/kernels/3.8.4-202.fc18.x86_64'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/username/build/v4l/media_build/v4l'
> make: *** [all] Error 2
> build failed at ./build line 452.
> 
> This seems to be a recent regression, I successfully built from
> media_build on another Fedora 18 machine just a couple of weeks ago.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63917 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab0I0Wn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 18:43:57 -0400
Received: by yxp4 with SMTP id 4so1707874yxp.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 15:43:56 -0700 (PDT)
Message-ID: <4CA11E25.5030206@gmail.com>
Date: Mon, 27 Sep 2010 19:43:49 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Ole W. Saastad" <olewsaa@online.no>, linux-media@vger.kernel.org
Subject: Re: updated make_kconfig.pl for Ubuntu
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net> <4C93364C.3040606@hoogenraad.net> <4C934806.7050503@gmail.com> <4C934C10.2060801@hoogenraad.net> <4C93800B.8070902@gmail.com> <4C9F7267.7000707@hoogenraad.net> <4CA018C4.9000507@gmail.com> <4CA0E554.40406@hoogenraad.net> <4CA0ECA9.30208@gmail.com> <4CA10262.6060206@hoogenraad.net>
In-Reply-To: <4CA10262.6060206@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 27-09-2010 17:45, Jan Hoogenraad escreveu:
> Mauro:
> 
> On my system, the call to make_kconfig reads:
> ./scripts/make_kconfig.pl /lib/modules/2.6.28-19-generic/build /lib/modules/2.6.28-19-generic/build 1
> 
> Using $kernelsrc yields the following error:
> Global symbol "$kernelsrc" requires explicit package name at ./scripts/make_kconfig.pl line 694.
> 
> Using
> $dmahplace="$kernsrc/include/config/ieee1394/dma.h";
> yields the following INCORRECT expansion:
> /lib/modules/2.6.28-19-generic/build/include/config/ieee1394/dma.h
> this is the place where I am building into, which is different from the place where Ubuntu places the include files from the package
> 
> Thus I built an expression to get:
> /usr/src/linux-headers-2.6.28-19-generic/include/config/ieee1394/dma.h
> as I described in the mail of yesterday.


Huh? Are you sure that Ubuntu doesn't have a symbolic link at /lib/modules/2.6.28-19-generic/build pointing
to /usr/src/linux-headers-2.6.28-19-generic/?

If it doesn't have, then all compat checks done by make_config_compat.pl would fail.

> Now, I realize that the header files could ALSO be present in the build directory, so there should be a check on that as well, as otherwise the FIREDTV is incorrectly disabled on other distros, or source builds.
> 
> Yes, and I know all of this is ugly ....

It is not just ugly. It will break compilation on Ubuntu with:
	$ make release DIR=<some dir>

Cheers,
Mauro

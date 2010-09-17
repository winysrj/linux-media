Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60255 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0IQOty (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 10:49:54 -0400
Received: by gyd8 with SMTP id 8so746683gyd.19
        for <linux-media@vger.kernel.org>; Fri, 17 Sep 2010 07:49:54 -0700 (PDT)
Message-ID: <4C93800B.8070902@gmail.com>
Date: Fri, 17 Sep 2010 11:49:47 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: "Ole W. Saastad" <olewsaa@online.no>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Trouble building v4l-dvb
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net> <4C93364C.3040606@hoogenraad.net> <4C934806.7050503@gmail.com> <4C934C10.2060801@hoogenraad.net>
In-Reply-To: <4C934C10.2060801@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 17-09-2010 08:08, Jan Hoogenraad escreveu:
> Thanks !
> 
> Indeed, the hack so that
> make allyesmod
> not select firedtv would be very helpful.
> 
> that way, it is also clear that firedtv will not work on debian-like distros.
> 
> Is there a way I cen help with that ?
> I have no experience with Kconfig, so it would be a learning experience for me.

You don't need to look at Kconfig. there are some scripts under v4l/scripts
that will deal with Kconfig dependencies. They are meant to identify kernel versions
and features. Those scripts are, mainly:

	v4l/scripts/make_config_compat.pl - Checks for "backported" features, enabling workarounds at v4l/compat.h
	v4l/scripts/make_kconfig.pl - Generates a .config file that will compile with an older kernel
	v4l/scripts/make_makefile.pl - Generates a Makefile that will build/install/remove the kernel modules

Basically, you need to add some intelligence to one of the above scripts (likely make_kconfig)
to identify that the kernel has broken firewire headers, and disable its compilation, printing
a warning message to the user.

You'll find a logic at make_makefile.pl to detect an Ubuntu broken kernel that stores the in-kernel
drivers at the wrong install place. I'm not sure if all Ubuntu kernels/versions do the same
thing, nor if this is broken for all distro-variants.

Perhaps you may use this logic at make_kconfig.pl. The logic assumes that broken distros
are the ones that store V4L/DVB files at /lib/modules/\$(KERNELRELEASE)/ubuntu/media. 
This is probably not true for all broken distros (as Ubuntu clones - and maybe Debian - could
have the same problem, but storing the media files on a different place), so you may
need to generalize that logic, in order to cover any other distros that don't compile
firewire.

While you're there, the better is to also disable CONFIG_ALSA on Ubuntu, as the drivers
won't work anyway.

As we don't want to have complains from users about "why driver foo is not compiling for me",
IMO, it should be printing a warning message saying that compilation of ALSA/FIREWIRE drivers with
that specific kernel version is not possible, due to the back packaging of kernel headers,
recommending to the user to get a vanilla upstream kernel, if he needs one of the disabled
drivers.

Cheers,
Mauro

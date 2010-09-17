Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56320 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab0IQKuz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 06:50:55 -0400
Received: by yxp4 with SMTP id 4so682341yxp.19
        for <linux-media@vger.kernel.org>; Fri, 17 Sep 2010 03:50:54 -0700 (PDT)
Message-ID: <4C934806.7050503@gmail.com>
Date: Fri, 17 Sep 2010 07:50:46 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: "Ole W. Saastad" <olewsaa@online.no>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Trouble building v4l-dvb
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net> <4C93364C.3040606@hoogenraad.net>
In-Reply-To: <4C93364C.3040606@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 17-09-2010 06:35, Jan Hoogenraad escreveu:
> I see that the build now succeeded.
> 
> Ole: this is something that should have been fixed a long time ago, but isn't.
> make allyesmod
> should set only those divers that do actually compile.
> Unfortunately, the FIREDTV driver has bugs for as long as I remember.

The problem are not related to bugs at firedtv driver, but, instead, due to the fact
that the provided firewire drivers and fw-core don't match the drivers that are shipped
with the distro kernel. In order words, at Ubuntu (and some other deb-based distros),
they're shipping the wrong include files at /lib/modules/`uname -r`/build/. So, there's
no way to build and run any module based on that wrong broken headers.

Up to a certain amount, the same happens with -alsa files on Ubuntu: although they
will compile [1], as the provided headers at /lib/modules/`uname -r`/build/ are from a different
version than the alsa modules provided with Ubuntu, the drivers that depend on -alsa will 
generally compile, but they generally won't load (and, if they load, they'll can cause
an OOPS and some other random troubles), as the symbol dependency will not match.

While a hack might be added at v4l-dvb -hg tree to make firedtv to compile against a broken
header, the firedtv driver will not work anyway.

The only real solution for it is to fix this issue at the distro.

Cheers,
Mauro

[1] The v4l-dvb is smart enough to adapt to -alsa API changes that are backported into
an older kernel, since it checks for the API symbols that changed, instead of just looking
for the kernel version. This works fine with all distros (like Fedora, RHEL, SUSE, OpenSUSE,
Mandriva, ...) where the include files for alsa are at the right place:
/lib/modules/`uname -r`/build/).

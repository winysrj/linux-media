Return-path: <mchehab@pedra>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60786 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0KMWIX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 17:08:23 -0500
Received: by gwj17 with SMTP id 17so495652gwj.19
        for <linux-media@vger.kernel.org>; Sat, 13 Nov 2010 14:08:22 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 14 Nov 2010 09:08:20 +1100
Message-ID: <AANLkTimOyNpAatcZb775PPK3uEOXDKXW6-J0kMGis41f@mail.gmail.com>
Subject: new_build on ubuntu (dvbdev.c)
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
I'm trying to build on 2.6.32 (ubuntu lucid i386).

I followed the instructions for building from git[1]
but I get an error I don't understand.

make -C /lib/modules/2.6.32-25-3dbc39-generic/build
SUBDIRS=/home/me/git/clones/linuxtv.org/new_build/v4l  modules
make[3]: Entering directory `/usr/src/linux-headers-2.6.32-25-3dbc39-generic'
  CC [M]  /home/me/git/clones/linuxtv.org/new_build/v4l/tuner-xc2028.o
  CC [M]  /home/me/git/clones/linuxtv.org/new_build/v4l/tuner-simple.o
  CC [M]  /home/me/git/clones/linuxtv.org/new_build/v4l/tuner-types.o
  CC [M]  /home/me/git/clones/linuxtv.org/new_build/v4l/mt20xx.o
...all ok so far...
  CC [M]  /home/me/git/clones/linuxtv.org/new_build/v4l/flexcop-dma.o
/home/me/git/clones/linuxtv.org/new_build/v4l/dvbdev.c:108: error:
'noop_llseek' undeclared here (not in a function)
make[4]: *** [/home/me/git/clones/linuxtv.org/new_build/v4l/dvbdev.o] Error 1
make[3]: *** [_module_/home/me/git/clones/linuxtv.org/new_build/v4l] Error 2
make[3]: Leaving directory `/usr/src/linux-headers-2.6.32-25-3dbc39-generic'
make[2]: *** [default] Error 2
make[2]: Leaving directory `/home/me/git/clones/linuxtv.org/new_build/v4l'
make[1]: *** [all] Error 2
make[1]: Leaving directory `/home/me/git/clones/linuxtv.org/new_build'
make: *** [default] Error 2

Is it that an additional backport patch may be needed here?

The kernel I am running here is Ubuntu 2.6.32-25.43-generic (2.6.32.21+drm33.7)
with one tiny patch, reverting a bad change to drivers/usb/serial/ftdi_sio.c.

Any advice appreciated.

[1] http://git.linuxtv.org/media_tree.git

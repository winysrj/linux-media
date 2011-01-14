Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45260 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab1ANMPP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 07:15:15 -0500
Received: by gxk9 with SMTP id 9so1088013gxk.19
        for <linux-media@vger.kernel.org>; Fri, 14 Jan 2011 04:15:14 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 14 Jan 2011 23:15:13 +1100
Message-ID: <AANLkTimsWDEEAnhNw=RM1DOyt-29hLRdsx1Z6ekJoyay@mail.gmail.com>
Subject: media_build: build against 2.6.32 fails on rc-technisat-usb2.c
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

$ cat /proc/version_signature
Ubuntu 2.6.32-26.47-generic 2.6.32.24+drm33.11

Building from git:
$ cd ~/git/clones/v4l-dvb
$ git log -1
commit aeb13b434d0953050306435cd3134d65547dbcf4
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Wed Jan 5 13:31:15 2011 -0200

    cx25821: Fix compilation breakage due to BKL dependency
...

$ cd ~/git/clones/new_build
$ git log -1
commit 6da048c31318ddeb9b19d899403a91f4c10e34dc
Author: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date:   Thu Jan 13 10:41:14 2011 -0200

    Update it to cover hdpvr-i2c.c

    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Building via make tar DIR=... ; make untar; etc fails at this point:

  CC [M]  /home/vjm/git/clones/linuxtv.org/new_build/v4l/rc-streamzap.o
  CC [M]  /home/vjm/git/clones/linuxtv.org/new_build/v4l/rc-tbs-nec.o
make[4]: *** No rule to make target
`/home/vjm/git/clones/linuxtv.org/new_build/v4l/rc-technisat-usb2.c',
needed by `/home/vjm/git/clones/linuxtv.org/new_build/v4l/rc-technisat-usb2.o'.
 Stop.

I'll take a look but thought I should report this.

Cheers
Vince

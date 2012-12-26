Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:38894 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab2LZP5j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 10:57:39 -0500
Received: by mail-la0-f52.google.com with SMTP id l5so10686971lah.25
        for <linux-media@vger.kernel.org>; Wed, 26 Dec 2012 07:57:37 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 26 Dec 2012 10:57:37 -0500
Message-ID: <CAOcJUbz3_4=kjHCOa8RKP+eE2a8GyEdt0KOzHc4aG+e12i+Gzg@mail.gmail.com>
Subject: [PULL] dvb: push down ioctl lock in dvb_usercopy / fix ioctls failing
 if frontend open/closed too fast
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Nikolaus Schulz <schulz@macnetix.de>,
	Juergen Lock <nox@jelal.kn-bremen.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

The following two patches have been on the mailing lists for a while
with no complaints.  I have been testing them for the past few days
and all seems well.  I haven't been able to test the AV7110 driver
myself, but the patch is sane and should not cause any regressions.  I
believe these are fine for the 3.9 branch - let's merge this into our
devel branch asap to get some wider testing.

Please apply the following to update status in patchwork along with
the following merge request...

pwclient update -s 'accepted' 12989
pwclient update -s 'superseded' 14665


The following changes since commit 8b2aea7878f64814544d0527c659011949d52358:

  [media] em28xx: prefer bulk mode on webcams (2012-12-23 17:24:30 -0200)

are available in the git repository at:

  git://git.linuxtv.org/mkrufky/dvb core

for you to fetch changes up to 93851d93d1b2eb8d678cc46a3e29c4945001a761:

  dvb: push down ioctl lock in dvb_usercopy (2012-12-23 17:21:01 -0500)

----------------------------------------------------------------
Juergen Lock (1):
      dvb_frontend: fix ioctls failing if frontend open/closed too fast

Nikolaus Schulz (1):
      dvb: push down ioctl lock in dvb_usercopy

 drivers/media/dvb-core/dvb_ca_en50221.c |    9 +++++++++
 drivers/media/dvb-core/dvb_frontend.c   |   19 ++++++++++++++-----
 drivers/media/dvb-core/dvb_net.c        |   71
++++++++++++++++++++++++++++++++++++++++++++++++-----------------------
 drivers/media/dvb-core/dvb_net.h        |    1 +
 drivers/media/dvb-core/dvbdev.c         |    2 --
 drivers/media/pci/ttpci/av7110.c        |    2 ++
 drivers/media/pci/ttpci/av7110.h        |    2 ++
 drivers/media/pci/ttpci/av7110_av.c     |    8 ++++++++
 drivers/media/pci/ttpci/av7110_ca.c     |   24 +++++++++++++++++-------
 9 files changed, 101 insertions(+), 37 deletions(-)

Cheers,

Mike

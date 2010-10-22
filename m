Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab0JVUAa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 16:00:30 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9MK0UTJ002154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 16:00:30 -0400
Date: Fri, 22 Oct 2010 16:00:29 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL REQUEST] more IR enhancements for 2.6.37-rc1
Message-ID: <20101022200029.GB30199@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As you already know, we've been making a number of improvements to the
mceusb driver's raw buffer parsing routines, both to enhance functionality
for existing devices, and to enable proper support for the cx231xx/Polaris
integrated IR receiver. These changes to the mceusb driver are all
included here, along with a number of fixups for some of the lirc device
drivers, and a handful of improvements to the lirc base device driver,
lirc_dev, among which is included a fix for an oops when a device using
the lirc_dev interface is removed while its chardev is open (i.e., a
client, such as irw, is attached to lircd and in turn, lircd is looking
at /dev/lirc0 for data).

The following changes since commit 780e312175f688ab5ab6124c91d46fa2b9afe2d2:

  [media] gspca: Fix coding style issues (2010-10-21 14:50:06 -0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-lirc.git staging

Jarod Wilson (13):
      lirc_dev: sanitize function and struct names a bit
      lirc_dev: fix pointer to owner
      lirc_dev: get irctl from irctls by inode again
      lirc_dev: more error-checking improvements
      lirc_dev: call cdev_del *after* irctl cleanup
      lirc_dev: rework storage for cdev data
      lirc_parallel: build on smp and kill dead code
      lirc_igorplugusb: assorted fixups
      lirc_igorplugusb: handle hw buffer overruns better
      lirc_igorplugusb: add Fit PC2 device ID
      lirc_it87: add another pnp id
      mceusb: add symbolic names for commands
      mceusb: hook debug print spew directly into parser routine

Mauro Carvalho Chehab (4):
      mceusb: improve ir data buffer parser
      mceusb: add a per-model structure
      mceusb: allow a per-model RC map
      mceusb: Allow a per-model device name

 drivers/media/IR/lirc_dev.c             |   97 +++++--
 drivers/media/IR/mceusb.c               |  470 ++++++++++++++++++++-----------
 drivers/staging/lirc/Kconfig            |    2 +-
 drivers/staging/lirc/lirc_igorplugusb.c |  188 +++++++------
 drivers/staging/lirc/lirc_it87.c        |    3 +-
 drivers/staging/lirc/lirc_parallel.c    |   26 --
 6 files changed, 478 insertions(+), 308 deletions(-)


-- 
Jarod Wilson
jarod@redhat.com


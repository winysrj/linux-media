Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:21498 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753599Ab1APTVy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 14:21:54 -0500
Subject: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Jarod Wilson <jarod@redhat.com>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 14:20:49 -0500
Message-ID: <1295205650.2400.27.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

Please pull the one ir-kbd-i2c change and multiple lirc_zilog changes
for 2.6.38.

The one ir-kbd-i2c change is to put back a case to have ir-kbd-i2c set
defaults for I2C client address 0x71.  I know I was the one who
recommend that ir-kbd-i2c not do this, but I discovered pvrusb2 and bttv
rely on it for the moment - Mea culpa.

The lirc_zilog changes are tested to work with both Tx and Rx with an
HVR-1600.  I don't want to continue much further on lirc_zilog changes,
unitl a few things happen:

1. I have developed, and have had tested, a patch for the pvrusb2 driver
to allow the in kernel lirc_zilog to bind to a Z8 on a pvrusb2 supported
device.

2. Jarrod finishes his changes related to the Z8 chip for hdpvr and they
are pulled into media_tree.git branch.

3. I hear from Jean, or whomever really cares about ir-kbd-i2c, if
adding some new fields for struct IR_i2c_init_data is acceptable.
Specifically, I'd like to add a transceiver_lock mutex, a transceiver
reset callback, and a data pointer for that reset callback.
(Only lirc_zilog would use the reset callback and data pointer.)

4. I find spare time ever again.

Anyway, here's the patchset reference...


The following changes since commit 0a97a683049d83deaf636d18316358065417d87b:

  [media] cpia2: convert .ioctl to .unlocked_ioctl (2011-01-06 11:34:41 -0200)

are available in the git repository at:
  ssh://linuxtv.org/git/awalls/media_tree.git z8

Andy Walls (11):
      lirc_zilog: Reword debug message in ir_probe()
      lirc_zilog: Remove disable_tx module parameter
      lirc_zilog: Split struct IR into structs IR, IR_tx, and IR_rx
      lirc_zilog: Don't make private copies of i2c clients
      lirc_zilog: Extensive rework of ir_probe()/ir_remove()
      lirc_zilog: Update IR Rx polling kthread start/stop and some printks
      lirc_zilog: Remove unneeded tests for existence of the IR Tx function
      lirc_zilog: Remove useless struct i2c_driver.command function
      lirc_zilog: Add Andy Walls to copyright notice and authors list
      lirc_zilog: Update TODO.lirc_zilog
      ir-kbd-i2c: Add back defaults setting for Zilog Z8's at addr 0x71

 drivers/media/video/ir-kbd-i2c.c     |    6 +
 drivers/staging/lirc/TODO.lirc_zilog |   36 ++-
 drivers/staging/lirc/lirc_zilog.c    |  650 ++++++++++++++++++----------------
 3 files changed, 389 insertions(+), 303 deletions(-)


Regards,
Andy


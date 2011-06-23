Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933235Ab1FWSQN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 14:16:13 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5NIGCIr018339
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 23 Jun 2011 14:16:13 -0400
Date: Thu, 23 Jun 2011 14:16:12 -0400
From: Jarod Wilson <jarod@redhat.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL] IR Fixups for 3.0
Message-ID: <20110623181612.GA5295@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

There are quite a few patches here, but they're all fairly small targeted
fixes, all worth pushing into 3.0 if we can. The last patch in the series
is the most critical one, it fixes a fairly significant problem with key
repeats, introduced by a core input layer change (evdev won't allow
reading data until there's an EV_SYN).

Nb: I sent a prior pull req on June 4 that had the first 11 patches in
this stack, not sure if that was already pulled, but I think I recall you
saying your scripts would handle things just fine if there were changes
included that you'd already pulled...

Thanks much,

The following changes since commit 56299378726d5f2ba8d3c8cbbd13cb280ba45e4f:

  Linux 3.0-rc4 (2011-06-20 20:25:46 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-ir.git/ for-3.0

Jarod Wilson (20):
      [media] mceusb: add and use mce_dbg printk macro
      [media] mceusb: support I-O Data GV-MC7/RCKIT
      [media] mceusb: mce_sync_in is brain-dead
      [staging] lirc_imon: fix unused-but-set warnings
      [staging] lirc_sir: fix unused-but-set warnings
      [media] lirc_dev: store cdev in irctl, up maxdevs
      [media] fintek-cir: make suspend with active IR more reliable
      [media] nuvoton-cir: in_use isn't actually in use, remove it
      [media] mceusb: plug memory leak on data transmit
      [media] imon: support for 0x46 0xffdc imon vfd
      [media] imon: fix initial panel key repeat suppression
      [media] ite-cir: 8709 needs to use pnp resource 2
      [media] keymaps: fix table for pinnacle pctv hd devices
      [media] lirc_zilog: fix spinning rx thread
      [staging] lirc_serial: allocate irq at init time
      [media] rc: fix ghost keypresses with certain hw
      [media] saa7134: fix raw IR timeout value
      [media] imon: auto-config ffdc 7e device
      [media] imon: allow either proto on unknown 0xffdc
      [media] rc: call input_sync after scancode reports

 drivers/media/rc/fintek-cir.c                  |    5 ++
 drivers/media/rc/imon.c                        |   19 +++++-
 drivers/media/rc/ir-raw.c                      |    4 +-
 drivers/media/rc/ite-cir.c                     |   12 +++-
 drivers/media/rc/ite-cir.h                     |    3 +
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c |   58 ++++++++---------
 drivers/media/rc/lirc_dev.c                    |   37 ++++++++---
 drivers/media/rc/mceusb.c                      |   80 +++++++++++------------
 drivers/media/rc/nuvoton-cir.c                 |    2 -
 drivers/media/rc/nuvoton-cir.h                 |    1 -
 drivers/media/rc/rc-main.c                     |    2 +
 drivers/media/video/saa7134/saa7134-input.c    |    2 +-
 drivers/staging/lirc/lirc_imon.c               |   10 +---
 drivers/staging/lirc/lirc_serial.c             |   44 ++++++-------
 drivers/staging/lirc/lirc_sir.c                |   11 +---
 drivers/staging/lirc/lirc_zilog.c              |    4 +-
 include/media/lirc_dev.h                       |    2 +-
 17 files changed, 159 insertions(+), 137 deletions(-)

-- 
Jarod Wilson
jarod@redhat.com


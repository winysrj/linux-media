Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:44682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab1CVUzo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 16:55:44 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2MKthRH027732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 22 Mar 2011 16:55:43 -0400
Date: Tue, 22 Mar 2011 16:55:42 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Subject: [GIT PULL] IR Updates for 2.6.39
Message-ID: <20110322205540.GE19325@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This heaping helping of patches goes a long way to improve the lirc_zilog
driver (courtesy of Andy Walls) to the point where it no longer crashes
and burns if you unplug a device while its loaded and cleans up a fair
bit of inconsistent key mappings, as well as making the
Hauppauge-specific keymaps much cleaner, with ir-kbd-i2c properly passing
entire rc5 scancodes, making use of non-Hauppauge RC5 remotes with
Hauppauge i2c-based receivers work much better (all courtesy of Mauro
Carvalho Chehab).

I fixed a few little things here and there too, and tested out the
zilog and ir-kbd-i2c changes. This series does include a rewritten i2c
master for the hdpvr, based heavily on the pvrusb2 driver's i2c master,
which in theory, was going to make it behave better, but has had no
noticeable impact yet. However, it may also be necessary for some more
forthcoming lirc_zilog changes based on Devin Heitmueller's work for
the Hauppauge Broadway device. There's also a small change to the NEC
IR decoder, which will make it try passing along full 32-bit scancodes
if/when the command/not_command checksum test fails. Should be of no
consequence for existing keymaps, and allow the creation of full 32-bit
ones for the likes of the Apple and TiVo remotes I've got. (Patches
adding those forthcoming).

The following changes since commit 97ad124749a060d8c4f5461111911474db3b555f:

  ite-cir: Fix a breakage caused by my cleanup patch (2011-03-22 17:20:34 -0300)

are available in the git repository at:
  git+ssh://jarod@master.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-ir.git/ staging

Andy Walls (13):
      lirc_zilog: Restore checks for existence of the IR_tx object
      lirc_zilog: Remove broken, ineffective reference counting
      lirc_zilog: Convert ir_device instance array to a linked list
      lirc_zilog: Convert the instance open count to an atomic_t
      lirc_zilog: Use kernel standard methods for marking device non-seekable
      lirc_zilog: Don't acquire the rx->buf_lock in the poll() function
      lirc_zilog: Remove unneeded rx->buf_lock
      lirc_zilog: Always allocate a Rx lirc_buffer object
      lirc_zilog: Move constants from ir_probe() into the lirc_driver template
      lirc_zilog: Add ref counting of struct IR, IR_tx, and IR_rx
      lirc_zilog: Add locking of the i2c_clients when in use
      lirc_zilog: Fix somewhat confusing information messages in ir_probe()
      lirc_zilog: Update TODO list based on work completed and revised plans

Jarod Wilson (9):
      docs: fix typo in lirc_device_interface.xml
      imon: add more panel scancode mappings
      hdpvr: i2c master enhancements
      ir-kbd-i2c: pass device code w/key in hauppauge case
      hdpvr: use same polling interval as other OS
      lirc: silence some compile warnings
      lirc_zilog: error out if buffer read bytes != chunk size
      mceusb: topseed 0x0011 needs gen3 init for tx to work
      rc: interim support for 32-bit NEC-ish scancodes

Mauro Carvalho Chehab (14):
      rc/keymaps: use KEY_CAMERA for snapshots
      rc/keymaps: Use KEY_VIDEO for Video Source
      rc/keymaps: Fix most KEY_PROG[n] keycodes
      rc/keymaps: Use KEY_LEFTMETA were pertinent
      dw2102: Use multimedia keys instead of an app-specific mapping
      opera1: Use multimedia keys instead of an app-specific mapping
      a800: Fix a few wrong IR key assignments
      rc-winfast: Fix the keycode tables
      rc-rc5-hauppauge-new: Add the old control to the table
      rc-rc5-hauppauge-new: Add support for the old Black RC
      rc-rc5-hauppauge-new: Fix Hauppauge Grey mapping
      rc/keymaps: Rename Hauppauge table as rc-hauppauge
      remove the old RC_MAP_HAUPPAUGE_NEW RC map
      [media] rc/keymaps: Remove the obsolete rc-rc5-tv keymap

 .../DocBook/v4l/lirc_device_interface.xml          |    2 +-
 drivers/media/dvb/dvb-usb/a800.c                   |    8 +-
 drivers/media/dvb/dvb-usb/digitv.c                 |    2 +-
 drivers/media/dvb/dvb-usb/dw2102.c                 |   40 +-
 drivers/media/dvb/dvb-usb/opera1.c                 |   33 +-
 drivers/media/dvb/siano/sms-cards.c                |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c                |   15 +-
 drivers/media/rc/imon.c                            |   11 +-
 drivers/media/rc/ir-nec-decoder.c                  |   10 +-
 drivers/media/rc/keymaps/Makefile                  |    4 +-
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |    6 +-
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |    4 +-
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |    2 +-
 .../media/rc/keymaps/rc-avermedia-m733a-rm-k6.c    |    2 +-
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c      |    2 +-
 drivers/media/rc/keymaps/rc-behold-columbus.c      |    2 +-
 drivers/media/rc/keymaps/rc-behold.c               |    2 +-
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |    3 +-
 drivers/media/rc/keymaps/rc-cinergy.c              |    2 +-
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |    2 +-
 drivers/media/rc/keymaps/rc-encore-enltv.c         |    4 +-
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |    2 +-
 drivers/media/rc/keymaps/rc-flydvb.c               |    4 +-
 drivers/media/rc/keymaps/rc-hauppauge-new.c        |  100 ---
 drivers/media/rc/keymaps/rc-hauppauge.c            |  241 ++++++
 drivers/media/rc/keymaps/rc-imon-mce.c             |    2 +-
 drivers/media/rc/keymaps/rc-imon-pad.c             |    2 +-
 drivers/media/rc/keymaps/rc-kworld-315u.c          |    2 +-
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |    2 +-
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |    2 +-
 drivers/media/rc/keymaps/rc-nebula.c               |    2 +-
 drivers/media/rc/keymaps/rc-norwood.c              |    2 +-
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |    2 +-
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |    2 +-
 drivers/media/rc/keymaps/rc-pixelview-new.c        |    2 +-
 drivers/media/rc/keymaps/rc-pixelview.c            |    2 +-
 drivers/media/rc/keymaps/rc-pv951.c                |    4 +-
 drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c    |  141 ----
 drivers/media/rc/keymaps/rc-rc5-tv.c               |   81 --
 drivers/media/rc/keymaps/rc-rc6-mce.c              |    2 +-
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |    2 +-
 drivers/media/rc/keymaps/rc-winfast.c              |   22 +-
 drivers/media/rc/mceusb.c                          |    4 +-
 drivers/media/video/cx18/cx18-i2c.c                |    2 +-
 drivers/media/video/cx23885/cx23885-input.c        |    2 +-
 drivers/media/video/cx88/cx88-input.c              |    4 +-
 drivers/media/video/em28xx/em28xx-cards.c          |   10 +-
 drivers/media/video/hdpvr/hdpvr-i2c.c              |   72 ++-
 drivers/media/video/ir-kbd-i2c.c                   |   18 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    5 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |    4 +-
 drivers/media/video/saa7134/saa7134-input.c        |    2 +-
 drivers/staging/lirc/TODO.lirc_zilog               |   51 +-
 drivers/staging/lirc/lirc_imon.c                   |    2 +-
 drivers/staging/lirc/lirc_sasem.c                  |    2 +-
 drivers/staging/lirc/lirc_zilog.c                  |  814 ++++++++++++--------
 include/media/rc-map.h                             |    4 +-
 57 files changed, 967 insertions(+), 808 deletions(-)
 delete mode 100644 drivers/media/rc/keymaps/rc-hauppauge-new.c
 create mode 100644 drivers/media/rc/keymaps/rc-hauppauge.c
 delete mode 100644 drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
 delete mode 100644 drivers/media/rc/keymaps/rc-rc5-tv.c

-- 
Jarod Wilson
jarod@redhat.com


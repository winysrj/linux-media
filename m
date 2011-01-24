Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab1AXPWQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:22:16 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFMGGT011665
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:22:16 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJARo027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:22:15 -0500
Date: Mon, 24 Jan 2011 13:18:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 00/13] Lots of fixes for RC keymap tables
Message-ID: <20110124131848.6717f8ff@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This series of patches fixes several issues found at the RC
keycode tables. 

I'm working on a set of patches for Xorg to enable remote
controllers to work there as a separate key mapping, but
this will only work if we can standardize the way remotes
will output their codes.

Mauro Carvalho Chehab (13):
  [media] rc/keymaps: use KEY_CAMERA for snapshots
  [media] rc/keymaps: Use KEY_VIDEO for Video Source
  [media] rc/keymaps: Fix most KEY_PROG[n] keycodes
  [media] rc/keymaps: Use KEY_LEFTMETA were pertinent
  [media] dw2102: Use multimedia keys instead of an app-specific
    mapping
  [media] opera1: Use multimedia keys instead of an app-specific
    mapping
  [media] a800: Fix a few wrong IR key assignments
  [media] rc-winfast: Fix the keycode tables
  [media] rc-rc5-hauppauge-new: Add the old control to the table
  [media] rc-rc5-hauppauge-new: Add support for the old Black RC
  [media] rc-rc5-hauppauge-new: Fix Hauppauge Grey mapping
  [media] rc/keymaps: Rename Hauppauge table as rc-hauppauge
  [media] remove the old RC_MAP_HAUPPAUGE_NEW RC map

 drivers/media/dvb/dvb-usb/a800.c                   |    8 +-
 drivers/media/dvb/dvb-usb/digitv.c                 |    2 +-
 drivers/media/dvb/dvb-usb/dw2102.c                 |   40 ++--
 drivers/media/dvb/dvb-usb/opera1.c                 |   33 ++--
 drivers/media/dvb/siano/sms-cards.c                |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c                |   15 +-
 drivers/media/rc/keymaps/Makefile                  |    3 +-
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
 drivers/media/rc/keymaps/rc-hauppauge-new.c        |  100 --------
 drivers/media/rc/keymaps/rc-hauppauge.c            |  241 ++++++++++++++++++++
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
 drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c    |  141 ------------
 drivers/media/rc/keymaps/rc-rc6-mce.c              |    2 +-
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |    2 +-
 drivers/media/rc/keymaps/rc-winfast.c              |   22 +-
 drivers/media/rc/mceusb.c                          |    2 +-
 drivers/media/video/cx18/cx18-i2c.c                |    2 +-
 drivers/media/video/cx23885/cx23885-input.c        |    2 +-
 drivers/media/video/cx88/cx88-input.c              |    4 +-
 drivers/media/video/em28xx/em28xx-cards.c          |   10 +-
 drivers/media/video/hdpvr/hdpvr-i2c.c              |    2 +-
 drivers/media/video/ir-kbd-i2c.c                   |    4 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |    4 +-
 drivers/media/video/saa7134/saa7134-input.c        |    2 +-
 include/media/rc-map.h                             |    2 +-
 49 files changed, 359 insertions(+), 351 deletions(-)
 delete mode 100644 drivers/media/rc/keymaps/rc-hauppauge-new.c
 create mode 100644 drivers/media/rc/keymaps/rc-hauppauge.c
 delete mode 100644 drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c


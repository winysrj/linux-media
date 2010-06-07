Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51226 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab0FGTcR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 15:32:17 -0400
Subject: [PATCH 0/8] rc-core cleanups
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Date: Mon, 07 Jun 2010 21:32:13 +0200
Message-ID: <20100607192830.21236.69701.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following series is my current patch queue.

The first five patches remove some of the ir-functions.c legacy from hardware
drivers (sadly I don't have the hardware so I can only compile test the
resulting code).

The next two patches are the same sysfs centralization patches I've sent before
(see discussion in that thread).

The last patch merges the two main rc-core (ir-core) headers, which helps
readability for me at least...

Net result - 900 lines less code.

---

David Härdeman (8):
      ir-core: convert mantis to not use ir-functions.c
      ir-core: convert em28xx to not use ir-functions.c
      ir-core: partially convert cx88 to not use ir-functions.c
      ir-core: partially convert ir-kbd-i2c.c to not use ir-functions.c
      ir-core: partially convert bt8xx to not use ir-functions.c
      ir-core: centralize sysfs raw decoder enabling/disabling
      ir-core: move decoding state to ir_raw_event_ctrl
      ir-core: merge rc-map.h into ir-core.h


 drivers/media/IR/ir-core-priv.h                    |   40 +++
 drivers/media/IR/ir-functions.c                    |   89 -------
 drivers/media/IR/ir-jvc-decoder.c                  |  152 +-----------
 drivers/media/IR/ir-nec-decoder.c                  |  151 +-----------
 drivers/media/IR/ir-raw-event.c                    |  136 +++++------
 drivers/media/IR/ir-rc5-decoder.c                  |  165 +------------
 drivers/media/IR/ir-rc6-decoder.c                  |  154 +-----------
 drivers/media/IR/ir-sony-decoder.c                 |  155 +-----------
 drivers/media/IR/ir-sysfs.c                        |  252 ++++++++++++--------
 drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c    |    2 
 drivers/media/IR/keymaps/rc-apac-viewcomp.c        |    2 
 drivers/media/IR/keymaps/rc-asus-pc39.c            |    2 
 drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c |    2 
 drivers/media/IR/keymaps/rc-avermedia-a16d.c       |    2 
 drivers/media/IR/keymaps/rc-avermedia-cardbus.c    |    2 
 drivers/media/IR/keymaps/rc-avermedia-dvbt.c       |    2 
 .../media/IR/keymaps/rc-avermedia-m135a-rm-jx.c    |    2 
 drivers/media/IR/keymaps/rc-avermedia.c            |    2 
 drivers/media/IR/keymaps/rc-avertv-303.c           |    2 
 drivers/media/IR/keymaps/rc-behold-columbus.c      |    2 
 drivers/media/IR/keymaps/rc-behold.c               |    2 
 drivers/media/IR/keymaps/rc-budget-ci-old.c        |    2 
 drivers/media/IR/keymaps/rc-cinergy-1400.c         |    2 
 drivers/media/IR/keymaps/rc-cinergy.c              |    2 
 drivers/media/IR/keymaps/rc-dm1105-nec.c           |    2 
 drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c      |    2 
 drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c   |    2 
 drivers/media/IR/keymaps/rc-em-terratec.c          |    2 
 drivers/media/IR/keymaps/rc-empty.c                |    2 
 drivers/media/IR/keymaps/rc-encore-enltv-fm53.c    |    2 
 drivers/media/IR/keymaps/rc-encore-enltv.c         |    2 
 drivers/media/IR/keymaps/rc-encore-enltv2.c        |    2 
 drivers/media/IR/keymaps/rc-evga-indtube.c         |    2 
 drivers/media/IR/keymaps/rc-eztv.c                 |    2 
 drivers/media/IR/keymaps/rc-flydvb.c               |    2 
 drivers/media/IR/keymaps/rc-flyvideo.c             |    2 
 drivers/media/IR/keymaps/rc-fusionhdtv-mce.c       |    2 
 drivers/media/IR/keymaps/rc-gadmei-rm008z.c        |    2 
 drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c   |    2 
 drivers/media/IR/keymaps/rc-gotview7135.c          |    2 
 drivers/media/IR/keymaps/rc-hauppauge-new.c        |    2 
 drivers/media/IR/keymaps/rc-imon-mce.c             |    2 
 drivers/media/IR/keymaps/rc-imon-pad.c             |    2 
 drivers/media/IR/keymaps/rc-iodata-bctv7e.c        |    2 
 drivers/media/IR/keymaps/rc-kaiomy.c               |    2 
 drivers/media/IR/keymaps/rc-kworld-315u.c          |    2 
 .../media/IR/keymaps/rc-kworld-plus-tv-analog.c    |    2 
 drivers/media/IR/keymaps/rc-manli.c                |    2 
 drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c  |    2 
 drivers/media/IR/keymaps/rc-msi-tvanywhere.c       |    2 
 drivers/media/IR/keymaps/rc-nebula.c               |    2 
 .../media/IR/keymaps/rc-nec-terratec-cinergy-xs.c  |    2 
 drivers/media/IR/keymaps/rc-norwood.c              |    2 
 drivers/media/IR/keymaps/rc-npgtech.c              |    2 
 drivers/media/IR/keymaps/rc-pctv-sedna.c           |    2 
 drivers/media/IR/keymaps/rc-pinnacle-color.c       |    2 
 drivers/media/IR/keymaps/rc-pinnacle-grey.c        |    2 
 drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c     |    2 
 drivers/media/IR/keymaps/rc-pixelview-mk12.c       |    2 
 drivers/media/IR/keymaps/rc-pixelview-new.c        |    2 
 drivers/media/IR/keymaps/rc-pixelview.c            |    2 
 .../media/IR/keymaps/rc-powercolor-real-angel.c    |    2 
 drivers/media/IR/keymaps/rc-proteus-2309.c         |    2 
 drivers/media/IR/keymaps/rc-purpletv.c             |    2 
 drivers/media/IR/keymaps/rc-pv951.c                |    2 
 drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c    |    2 
 drivers/media/IR/keymaps/rc-rc5-tv.c               |    2 
 .../media/IR/keymaps/rc-real-audio-220-32-keys.c   |    2 
 drivers/media/IR/keymaps/rc-tbs-nec.c              |    2 
 drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c  |    2 
 drivers/media/IR/keymaps/rc-tevii-nec.c            |    2 
 drivers/media/IR/keymaps/rc-tt-1500.c              |    2 
 drivers/media/IR/keymaps/rc-videomate-s350.c       |    2 
 drivers/media/IR/keymaps/rc-videomate-tv-pvr.c     |    2 
 drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c |    2 
 drivers/media/IR/keymaps/rc-winfast.c              |    2 
 drivers/media/dvb/mantis/mantis_input.c            |    5 
 drivers/media/video/bt8xx/bttv-input.c             |   35 +--
 drivers/media/video/bt8xx/bttv.h                   |    1 
 drivers/media/video/bt8xx/bttvp.h                  |   11 -
 drivers/media/video/cx23885/cx23885-input.c        |   51 ----
 drivers/media/video/cx88/cx88-input.c              |   46 +---
 drivers/media/video/em28xx/em28xx-input.c          |   65 +----
 drivers/media/video/em28xx/em28xx.h                |    1 
 drivers/media/video/ir-kbd-i2c.c                   |   14 -
 drivers/media/video/saa7134/saa7134-input.c        |   61 +----
 include/media/ir-common.h                          |   22 --
 include/media/ir-core.h                            |  112 +++++++++
 include/media/ir-kbd-i2c.h                         |    3 
 include/media/rc-map.h                             |  121 ----------
 90 files changed, 545 insertions(+), 1431 deletions(-)
 delete mode 100644 include/media/rc-map.h

-- 
David Härdeman

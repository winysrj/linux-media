Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463Ab0DFSSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 14:18:40 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIecV013608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:40 -0400
Date: Tue, 6 Apr 2010 15:18:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 00/26] IR core improvements
Message-ID: <20100406151804.52d18112@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the new set of ir-core changes, with several new improvements.

The most remarkable one is that the IR keymaps were removed from 
ir-common module. Now, they are mapped as separate kernel modules, that
can be disabled or enabled as a hole. A future patch may be add a 
specific CONFIG_foo var for each one, but I think that the better is to
first rework on them, removing duplicated keymaps and fixing some key
bindings. With the current model, all that a driver needs to know 
about a table map is its name. As the same model name is passed via sysfs 
to userspace, it is easy to fully implement the tables on userspace.

Also, several devices are provided with more than one IR model. So, it 
makes sense to group some of the entries into families.

This series also adds a working decoder for RC-5 protocol, and 
re-implements the scancode to keycode conversion using a binary search
algorithm that costs log2(n), thanks to David patches.

David Härdeman (3):
  V4L/DVB: drivers/media/IR - improve keytable code
  V4L/DVB: ir-core: improve keyup/keydown logic
  V4L/DVB: Convert drivers/media/dvb/ttpci/budget-ci.c to use ir-core

Mauro Carvalho Chehab (23):
  V4L/DVB: ir-common: Use a function to declare an IR table
  V4L/DVB: ir-common: re-order keytables by name and remove duplicates
  V4L/DVB: IR: use IR_KEYTABLE where an IR table is needed
  V4L/DVB: rename all *_rc_keys to ir_codes_*_nec_table
  V4L/DVB: ir-common: Use macros to define the keytables
  V4L/DVB: ir-common: move IR tables from ir-keymaps.c to a separate file
  V4L/DVB: ir-core: Add support for RC map code register
  V4L/DVB: Break Remote Controller keymaps into modules
  V4L/DVB: ir: prepare IR code for a parameter change at register function
  V4L/DVB: ir-core: Make use of the new IR keymap modules
  V4L/DVB: ir-common: remove keymap tables from the module
  V4L/DVB: saa7134: Fix IRQ2 bit names for the register map
  V4L/DVB: saa7134: Add support for both positive and negative edge IRQ
  V4L/DVB: ir-core: re-add some debug functions for keytable changes
  V4L/DVB: ir-nec-decoder: Reimplement the entire decoder
  ir-nec-decoder: Cleanups
  V4L-DVB: ir-rc5-decoder: Add a decoder for RC-5 IR protocol
  V4L/DVB: cx88: don't handle IR on Pixelview too fast
  V4L-DVB: ir-core: remove the ancillary buffer
  V4L/DVB: ir-core: move rc map code to rc-map.h
  V4L/DVB: ir-core: Add support for badly-implemented hardware decoders
  V4L/DVB: re-add enable/disable check to the IR decoders
  V4L/DVB: ir-rc5-decoder: fix state machine

 drivers/media/IR/Kconfig                           |   11 +
 drivers/media/IR/Makefile                          |    7 +-
 drivers/media/IR/ir-keymaps.c                      | 3203 --------------------
 drivers/media/IR/ir-keytable.c                     |  709 ++---
 drivers/media/IR/ir-nec-decoder.c                  |  323 +-
 drivers/media/IR/ir-raw-event.c                    |   35 +-
 drivers/media/IR/ir-rc5-decoder.c                  |  291 ++
 drivers/media/IR/ir-sysfs.c                        |    4 +-
 drivers/media/IR/keymaps/Kconfig                   |   15 +
 drivers/media/IR/keymaps/Makefile                  |   65 +
 drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c    |   89 +
 drivers/media/IR/keymaps/rc-apac-viewcomp.c        |   80 +
 drivers/media/IR/keymaps/rc-asus-pc39.c            |   91 +
 drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c |   69 +
 drivers/media/IR/keymaps/rc-avermedia-a16d.c       |   75 +
 drivers/media/IR/keymaps/rc-avermedia-cardbus.c    |   97 +
 drivers/media/IR/keymaps/rc-avermedia-dvbt.c       |   78 +
 .../media/IR/keymaps/rc-avermedia-m135a-rm-jx.c    |   90 +
 drivers/media/IR/keymaps/rc-avermedia.c            |   86 +
 drivers/media/IR/keymaps/rc-avertv-303.c           |   85 +
 drivers/media/IR/keymaps/rc-behold-columbus.c      |  108 +
 drivers/media/IR/keymaps/rc-behold.c               |  141 +
 drivers/media/IR/keymaps/rc-budget-ci-old.c        |   92 +
 drivers/media/IR/keymaps/rc-cinergy-1400.c         |   84 +
 drivers/media/IR/keymaps/rc-cinergy.c              |   78 +
 drivers/media/IR/keymaps/rc-dm1105-nec.c           |   76 +
 drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c      |   78 +
 drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c   |   97 +
 drivers/media/IR/keymaps/rc-em-terratec.c          |   69 +
 drivers/media/IR/keymaps/rc-empty.c                |   44 +
 drivers/media/IR/keymaps/rc-encore-enltv-fm53.c    |   81 +
 drivers/media/IR/keymaps/rc-encore-enltv.c         |  112 +
 drivers/media/IR/keymaps/rc-encore-enltv2.c        |   90 +
 drivers/media/IR/keymaps/rc-evga-indtube.c         |   61 +
 drivers/media/IR/keymaps/rc-eztv.c                 |   96 +
 drivers/media/IR/keymaps/rc-flydvb.c               |   77 +
 drivers/media/IR/keymaps/rc-flyvideo.c             |   70 +
 drivers/media/IR/keymaps/rc-fusionhdtv-mce.c       |   98 +
 drivers/media/IR/keymaps/rc-gadmei-rm008z.c        |   81 +
 drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c   |   84 +
 drivers/media/IR/keymaps/rc-gotview7135.c          |   79 +
 drivers/media/IR/keymaps/rc-hauppauge-new.c        |  100 +
 drivers/media/IR/keymaps/rc-iodata-bctv7e.c        |   88 +
 drivers/media/IR/keymaps/rc-kaiomy.c               |   87 +
 drivers/media/IR/keymaps/rc-kworld-315u.c          |   83 +
 .../media/IR/keymaps/rc-kworld-plus-tv-analog.c    |   99 +
 drivers/media/IR/keymaps/rc-manli.c                |  135 +
 drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c  |  123 +
 drivers/media/IR/keymaps/rc-msi-tvanywhere.c       |   69 +
 drivers/media/IR/keymaps/rc-nebula.c               |   96 +
 .../media/IR/keymaps/rc-nec-terratec-cinergy-xs.c  |  105 +
 drivers/media/IR/keymaps/rc-norwood.c              |   85 +
 drivers/media/IR/keymaps/rc-npgtech.c              |   80 +
 drivers/media/IR/keymaps/rc-pctv-sedna.c           |   80 +
 drivers/media/IR/keymaps/rc-pinnacle-color.c       |   94 +
 drivers/media/IR/keymaps/rc-pinnacle-grey.c        |   89 +
 drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c     |   73 +
 drivers/media/IR/keymaps/rc-pixelview-mk12.c       |   83 +
 drivers/media/IR/keymaps/rc-pixelview-new.c        |   83 +
 drivers/media/IR/keymaps/rc-pixelview.c            |   82 +
 .../media/IR/keymaps/rc-powercolor-real-angel.c    |   81 +
 drivers/media/IR/keymaps/rc-proteus-2309.c         |   69 +
 drivers/media/IR/keymaps/rc-purpletv.c             |   81 +
 drivers/media/IR/keymaps/rc-pv951.c                |   78 +
 drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c    |  103 +
 drivers/media/IR/keymaps/rc-rc5-tv.c               |   81 +
 .../media/IR/keymaps/rc-real-audio-220-32-keys.c   |   78 +
 drivers/media/IR/keymaps/rc-tbs-nec.c              |   73 +
 drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c  |   92 +
 drivers/media/IR/keymaps/rc-tevii-nec.c            |   88 +
 drivers/media/IR/keymaps/rc-tt-1500.c              |   82 +
 drivers/media/IR/keymaps/rc-videomate-s350.c       |   85 +
 drivers/media/IR/keymaps/rc-videomate-tv-pvr.c     |   87 +
 drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c |   82 +
 drivers/media/IR/keymaps/rc-winfast.c              |  102 +
 drivers/media/IR/rc-map.c                          |   90 +
 drivers/media/dvb/dm1105/dm1105.c                  |    2 +-
 drivers/media/dvb/dvb-usb/a800.c                   |    6 +-
 drivers/media/dvb/dvb-usb/af9005-remote.c          |   16 +-
 drivers/media/dvb/dvb-usb/af9005.c                 |    8 +-
 drivers/media/dvb/dvb-usb/af9005.h                 |    4 +-
 drivers/media/dvb/dvb-usb/af9015.c                 |   30 +-
 drivers/media/dvb/dvb-usb/af9015.h                 |   18 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |    6 +-
 drivers/media/dvb/dvb-usb/az6027.c                 |    6 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c         |    6 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |   46 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |   54 +-
 drivers/media/dvb/dvb-usb/dibusb-common.c          |    4 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c              |    8 +-
 drivers/media/dvb/dvb-usb/dibusb-mc.c              |    2 +-
 drivers/media/dvb/dvb-usb/dibusb.h                 |    2 +-
 drivers/media/dvb/dvb-usb/digitv.c                 |    6 +-
 drivers/media/dvb/dvb-usb/dtt200u.c                |   18 +-
 drivers/media/dvb/dvb-usb/dw2102.c                 |   44 +-
 drivers/media/dvb/dvb-usb/m920x.c                  |   18 +-
 drivers/media/dvb/dvb-usb/nova-t-usb2.c            |   18 +-
 drivers/media/dvb/dvb-usb/opera1.c                 |   16 +-
 drivers/media/dvb/dvb-usb/vp702x.c                 |   12 +-
 drivers/media/dvb/dvb-usb/vp7045.c                 |   12 +-
 drivers/media/dvb/mantis/mantis_input.c            |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c                |   46 +-
 drivers/media/video/bt8xx/bttv-input.c             |   26 +-
 drivers/media/video/cx18/cx18-i2c.c                |    2 +-
 drivers/media/video/cx231xx/cx231xx-input.c        |    2 +-
 drivers/media/video/cx23885/cx23885-input.c        |    4 +-
 drivers/media/video/cx88/cx88-input.c              |   70 +-
 drivers/media/video/em28xx/em28xx-cards.c          |   34 +-
 drivers/media/video/em28xx/em28xx-input.c          |    4 -
 drivers/media/video/em28xx/em28xx.h                |    2 +-
 drivers/media/video/ir-kbd-i2c.c                   |   20 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    6 +-
 drivers/media/video/saa7134/saa7134-core.c         |   20 +-
 drivers/media/video/saa7134/saa7134-input.c        |   92 +-
 drivers/media/video/saa7134/saa7134-reg.h          |   24 +-
 include/media/ir-common.h                          |   67 -
 include/media/ir-core.h                            |  101 +-
 include/media/ir-kbd-i2c.h                         |    4 +-
 include/media/rc-map.h                             |  117 +
 119 files changed, 7168 insertions(+), 4222 deletions(-)
 delete mode 100644 drivers/media/IR/ir-keymaps.c
 create mode 100644 drivers/media/IR/ir-rc5-decoder.c
 create mode 100644 drivers/media/IR/keymaps/Kconfig
 create mode 100644 drivers/media/IR/keymaps/Makefile
 create mode 100644 drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c
 create mode 100644 drivers/media/IR/keymaps/rc-apac-viewcomp.c
 create mode 100644 drivers/media/IR/keymaps/rc-asus-pc39.c
 create mode 100644 drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-a16d.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-cardbus.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-dvbt.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia.c
 create mode 100644 drivers/media/IR/keymaps/rc-avertv-303.c
 create mode 100644 drivers/media/IR/keymaps/rc-behold-columbus.c
 create mode 100644 drivers/media/IR/keymaps/rc-behold.c
 create mode 100644 drivers/media/IR/keymaps/rc-budget-ci-old.c
 create mode 100644 drivers/media/IR/keymaps/rc-cinergy-1400.c
 create mode 100644 drivers/media/IR/keymaps/rc-cinergy.c
 create mode 100644 drivers/media/IR/keymaps/rc-dm1105-nec.c
 create mode 100644 drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c
 create mode 100644 drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c
 create mode 100644 drivers/media/IR/keymaps/rc-em-terratec.c
 create mode 100644 drivers/media/IR/keymaps/rc-empty.c
 create mode 100644 drivers/media/IR/keymaps/rc-encore-enltv-fm53.c
 create mode 100644 drivers/media/IR/keymaps/rc-encore-enltv.c
 create mode 100644 drivers/media/IR/keymaps/rc-encore-enltv2.c
 create mode 100644 drivers/media/IR/keymaps/rc-evga-indtube.c
 create mode 100644 drivers/media/IR/keymaps/rc-eztv.c
 create mode 100644 drivers/media/IR/keymaps/rc-flydvb.c
 create mode 100644 drivers/media/IR/keymaps/rc-flyvideo.c
 create mode 100644 drivers/media/IR/keymaps/rc-fusionhdtv-mce.c
 create mode 100644 drivers/media/IR/keymaps/rc-gadmei-rm008z.c
 create mode 100644 drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c
 create mode 100644 drivers/media/IR/keymaps/rc-gotview7135.c
 create mode 100644 drivers/media/IR/keymaps/rc-hauppauge-new.c
 create mode 100644 drivers/media/IR/keymaps/rc-iodata-bctv7e.c
 create mode 100644 drivers/media/IR/keymaps/rc-kaiomy.c
 create mode 100644 drivers/media/IR/keymaps/rc-kworld-315u.c
 create mode 100644 drivers/media/IR/keymaps/rc-kworld-plus-tv-analog.c
 create mode 100644 drivers/media/IR/keymaps/rc-manli.c
 create mode 100644 drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c
 create mode 100644 drivers/media/IR/keymaps/rc-msi-tvanywhere.c
 create mode 100644 drivers/media/IR/keymaps/rc-nebula.c
 create mode 100644 drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c
 create mode 100644 drivers/media/IR/keymaps/rc-norwood.c
 create mode 100644 drivers/media/IR/keymaps/rc-npgtech.c
 create mode 100644 drivers/media/IR/keymaps/rc-pctv-sedna.c
 create mode 100644 drivers/media/IR/keymaps/rc-pinnacle-color.c
 create mode 100644 drivers/media/IR/keymaps/rc-pinnacle-grey.c
 create mode 100644 drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c
 create mode 100644 drivers/media/IR/keymaps/rc-pixelview-mk12.c
 create mode 100644 drivers/media/IR/keymaps/rc-pixelview-new.c
 create mode 100644 drivers/media/IR/keymaps/rc-pixelview.c
 create mode 100644 drivers/media/IR/keymaps/rc-powercolor-real-angel.c
 create mode 100644 drivers/media/IR/keymaps/rc-proteus-2309.c
 create mode 100644 drivers/media/IR/keymaps/rc-purpletv.c
 create mode 100644 drivers/media/IR/keymaps/rc-pv951.c
 create mode 100644 drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c
 create mode 100644 drivers/media/IR/keymaps/rc-rc5-tv.c
 create mode 100644 drivers/media/IR/keymaps/rc-real-audio-220-32-keys.c
 create mode 100644 drivers/media/IR/keymaps/rc-tbs-nec.c
 create mode 100644 drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c
 create mode 100644 drivers/media/IR/keymaps/rc-tevii-nec.c
 create mode 100644 drivers/media/IR/keymaps/rc-tt-1500.c
 create mode 100644 drivers/media/IR/keymaps/rc-videomate-s350.c
 create mode 100644 drivers/media/IR/keymaps/rc-videomate-tv-pvr.c
 create mode 100644 drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c
 create mode 100644 drivers/media/IR/keymaps/rc-winfast.c
 create mode 100644 drivers/media/IR/rc-map.c
 create mode 100644 include/media/rc-map.h


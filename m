Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934970Ab0KQTVC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 14:21:02 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJL2vR015565
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:21:02 -0500
Received: from pedra (vpn-230-120.phx2.redhat.com [10.3.230.120])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJC5xO007699
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:20:30 -0500
Date: Wed, 17 Nov 2010 17:08:33 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 00/10] rc: rc cleanup/renaming patches
Message-ID: <20101117170833.33ae3516@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The patch that removed ir-common.h were broken. After fixing it, I noticed
that some cleanups were required. I ended by doing a large renaming stuff
to compliment the changes made so far.

The logic I used for the renaming logic at RC subsystem is:

	- All non-IR specific stuff is called rc_*;
	- All IR-specific stuff (e. g. IR raw decoding) uses ir_*;
	- All keycode/scancode map stuff is called rc_map_*;

I didn't went that far, but it could be a good idea to split ir_raw into
a different module and to create a ir_raw.h with the IR raw stuff.

Mauro Carvalho Chehab (10):
  [media] rc: remove ir-common module
  [media] rc: Remove ir-common.h
  [media] rc: rename the remaining things to rc_core
  [media] Rename all public generic RC functions from ir_ to rc_
  [media] cx231xx: Properly name rc_map name
  [media] rc: Rename remote controller type to rc_type instead of
    ir_type
  [media] rc: Properly name the rc_map struct
  [media] rc: Name RC keymap tables as rc_map_table
  [media] rc: use rc_map_ prefix for all rc map tables
  [media] rc: Rename IR raw interface to ir-raw.c

 drivers/media/dvb/dm1105/Kconfig                   |    2 +-
 drivers/media/dvb/dm1105/dm1105.c                  |    4 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |    2 +-
 drivers/media/dvb/dvb-usb/a800.c                   |    6 +-
 drivers/media/dvb/dvb-usb/af9005-remote.c          |   16 +-
 drivers/media/dvb/dvb-usb/af9005.c                 |   16 +-
 drivers/media/dvb/dvb-usb/af9005.h                 |    4 +-
 drivers/media/dvb/dvb-usb/af9015.c                 |   16 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |    4 +-
 drivers/media/dvb/dvb-usb/az6027.c                 |    6 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c         |    6 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |   62 ++--
 drivers/media/dvb/dvb-usb/dib0700.h                |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_core.c           |   14 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |   90 +++---
 drivers/media/dvb/dvb-usb/dibusb-common.c          |    4 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c              |   16 +-
 drivers/media/dvb/dvb-usb/dibusb-mc.c              |    4 +-
 drivers/media/dvb/dvb-usb/dibusb.h                 |    2 +-
 drivers/media/dvb/dvb-usb/digitv.c                 |   14 +-
 drivers/media/dvb/dvb-usb/dtt200u.c                |   18 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c         |   26 +-
 drivers/media/dvb/dvb-usb/dvb-usb.h                |   18 +-
 drivers/media/dvb/dvb-usb/dw2102.c                 |   54 ++--
 drivers/media/dvb/dvb-usb/lmedm04.c                |    4 +-
 drivers/media/dvb/dvb-usb/m920x.c                  |   24 +-
 drivers/media/dvb/dvb-usb/nova-t-usb2.c            |   18 +-
 drivers/media/dvb/dvb-usb/opera1.c                 |   16 +-
 drivers/media/dvb/dvb-usb/vp702x.c                 |   12 +-
 drivers/media/dvb/dvb-usb/vp7045.c                 |   12 +-
 drivers/media/dvb/mantis/Kconfig                   |    2 +-
 drivers/media/dvb/mantis/mantis_input.c            |   14 +-
 drivers/media/dvb/siano/Kconfig                    |    2 +-
 drivers/media/dvb/siano/smsir.c                    |    2 +-
 drivers/media/dvb/siano/smsir.h                    |    2 +-
 drivers/media/dvb/ttpci/Kconfig                    |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c                |    4 +-
 drivers/media/rc/Kconfig                           |   40 +--
 drivers/media/rc/Makefile                          |    6 +-
 drivers/media/rc/ene_ir.c                          |    4 +-
 drivers/media/rc/imon.c                            |   50 ++--
 drivers/media/rc/ir-functions.c                    |  120 -------
 drivers/media/rc/ir-jvc-decoder.c                  |    8 +-
 drivers/media/rc/ir-lirc-codec.c                   |    6 +-
 drivers/media/rc/ir-nec-decoder.c                  |   10 +-
 drivers/media/rc/ir-raw.c                          |  371 ++++++++++++++++++++
 drivers/media/rc/ir-rc5-decoder.c                  |    6 +-
 drivers/media/rc/ir-rc5-sz-decoder.c               |    6 +-
 drivers/media/rc/ir-rc6-decoder.c                  |    6 +-
 drivers/media/rc/ir-sony-decoder.c                 |    6 +-
 drivers/media/rc/keymaps/Kconfig                   |    2 +-
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |   10 +-
 drivers/media/rc/keymaps/rc-alink-dtu-m.c          |   10 +-
 drivers/media/rc/keymaps/rc-anysee.c               |   10 +-
 drivers/media/rc/keymaps/rc-apac-viewcomp.c        |   10 +-
 drivers/media/rc/keymaps/rc-asus-pc39.c            |   10 +-
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c |   10 +-
 drivers/media/rc/keymaps/rc-avermedia-a16d.c       |   10 +-
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |   10 +-
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |   10 +-
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |   10 +-
 .../media/rc/keymaps/rc-avermedia-m733a-rm-k6.c    |   10 +-
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c      |   10 +-
 drivers/media/rc/keymaps/rc-avermedia.c            |   10 +-
 drivers/media/rc/keymaps/rc-avertv-303.c           |   10 +-
 drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c   |   10 +-
 drivers/media/rc/keymaps/rc-behold-columbus.c      |   10 +-
 drivers/media/rc/keymaps/rc-behold.c               |   10 +-
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |   10 +-
 drivers/media/rc/keymaps/rc-cinergy-1400.c         |   10 +-
 drivers/media/rc/keymaps/rc-cinergy.c              |   10 +-
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |   10 +-
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          |   10 +-
 drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c  |   10 +-
 drivers/media/rc/keymaps/rc-digittrade.c           |   10 +-
 drivers/media/rc/keymaps/rc-dm1105-nec.c           |   10 +-
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |   10 +-
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c   |   10 +-
 drivers/media/rc/keymaps/rc-em-terratec.c          |   10 +-
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c    |   10 +-
 drivers/media/rc/keymaps/rc-encore-enltv.c         |   10 +-
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |   10 +-
 drivers/media/rc/keymaps/rc-evga-indtube.c         |   10 +-
 drivers/media/rc/keymaps/rc-eztv.c                 |   10 +-
 drivers/media/rc/keymaps/rc-flydvb.c               |   10 +-
 drivers/media/rc/keymaps/rc-flyvideo.c             |   10 +-
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c       |   10 +-
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c        |   10 +-
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c   |   10 +-
 drivers/media/rc/keymaps/rc-gotview7135.c          |   10 +-
 drivers/media/rc/keymaps/rc-hauppauge-new.c        |   10 +-
 drivers/media/rc/keymaps/rc-imon-mce.c             |   10 +-
 drivers/media/rc/keymaps/rc-imon-pad.c             |   10 +-
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c        |   10 +-
 drivers/media/rc/keymaps/rc-kaiomy.c               |   10 +-
 drivers/media/rc/keymaps/rc-kworld-315u.c          |   10 +-
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |   10 +-
 drivers/media/rc/keymaps/rc-leadtek-y04g0051.c     |   10 +-
 drivers/media/rc/keymaps/rc-lirc.c                 |   12 +-
 drivers/media/rc/keymaps/rc-lme2510.c              |   10 +-
 drivers/media/rc/keymaps/rc-manli.c                |   10 +-
 drivers/media/rc/keymaps/rc-msi-digivox-ii.c       |   10 +-
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c      |   10 +-
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |   10 +-
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c       |   10 +-
 drivers/media/rc/keymaps/rc-nebula.c               |   10 +-
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |   10 +-
 drivers/media/rc/keymaps/rc-norwood.c              |   10 +-
 drivers/media/rc/keymaps/rc-npgtech.c              |   10 +-
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |   10 +-
 drivers/media/rc/keymaps/rc-pinnacle-color.c       |   10 +-
 drivers/media/rc/keymaps/rc-pinnacle-grey.c        |   10 +-
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     |   10 +-
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |   10 +-
 drivers/media/rc/keymaps/rc-pixelview-new.c        |   10 +-
 drivers/media/rc/keymaps/rc-pixelview.c            |   10 +-
 .../media/rc/keymaps/rc-powercolor-real-angel.c    |   10 +-
 drivers/media/rc/keymaps/rc-proteus-2309.c         |   10 +-
 drivers/media/rc/keymaps/rc-purpletv.c             |   10 +-
 drivers/media/rc/keymaps/rc-pv951.c                |   10 +-
 drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c    |   10 +-
 drivers/media/rc/keymaps/rc-rc5-tv.c               |   10 +-
 drivers/media/rc/keymaps/rc-rc6-mce.c              |   10 +-
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |   10 +-
 drivers/media/rc/keymaps/rc-streamzap.c            |   10 +-
 drivers/media/rc/keymaps/rc-tbs-nec.c              |   10 +-
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c  |   10 +-
 drivers/media/rc/keymaps/rc-terratec-slim.c        |   10 +-
 drivers/media/rc/keymaps/rc-tevii-nec.c            |   10 +-
 drivers/media/rc/keymaps/rc-total-media-in-hand.c  |   10 +-
 drivers/media/rc/keymaps/rc-trekstor.c             |   10 +-
 drivers/media/rc/keymaps/rc-tt-1500.c              |   10 +-
 drivers/media/rc/keymaps/rc-twinhan1027.c          |   10 +-
 drivers/media/rc/keymaps/rc-videomate-s350.c       |   10 +-
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c     |   10 +-
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c |   10 +-
 drivers/media/rc/keymaps/rc-winfast.c              |   10 +-
 drivers/media/rc/mceusb.c                          |    4 +-
 drivers/media/rc/nuvoton-cir.c                     |    4 +-
 drivers/media/rc/rc-core-priv.h                    |    2 +-
 drivers/media/rc/rc-main.c                         |  318 +++++++++---------
 drivers/media/rc/rc-raw.c                          |  371 --------------------
 drivers/media/rc/streamzap.c                       |    4 +-
 drivers/media/rc/winbond-cir.c                     |    2 +-
 drivers/media/video/Kconfig                        |    2 +-
 drivers/media/video/bt8xx/Kconfig                  |    2 +-
 drivers/media/video/bt8xx/bttv-input.c             |  124 ++++++-
 drivers/media/video/bt8xx/bttv.h                   |    1 -
 drivers/media/video/bt8xx/bttvp.h                  |   43 +++-
 drivers/media/video/cx18/Kconfig                   |    2 +-
 drivers/media/video/cx18/cx18-i2c.c                |    2 +-
 drivers/media/video/cx231xx/Kconfig                |    4 +-
 drivers/media/video/cx231xx/cx231xx-cards.c        |    2 +-
 drivers/media/video/cx231xx/cx231xx-input.c        |    6 +-
 drivers/media/video/cx231xx/cx231xx.h              |    6 +-
 drivers/media/video/cx23885/Kconfig                |    2 +-
 drivers/media/video/cx23885/cx23885-input.c        |    6 +-
 drivers/media/video/cx23885/cx23885.h              |    2 +-
 drivers/media/video/cx23885/cx23888-ir.c           |    2 +-
 drivers/media/video/cx25840/cx25840-ir.c           |    2 +-
 drivers/media/video/cx88/Kconfig                   |    2 +-
 drivers/media/video/cx88/cx88-input.c              |   24 +-
 drivers/media/video/em28xx/Kconfig                 |    2 +-
 drivers/media/video/em28xx/em28xx-input.c          |   16 +-
 drivers/media/video/em28xx/em28xx.h                |    2 +-
 drivers/media/video/ir-kbd-i2c.c                   |   22 +-
 drivers/media/video/ivtv/Kconfig                   |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    6 +-
 drivers/media/video/saa7134/Kconfig                |    2 +-
 drivers/media/video/saa7134/saa7134-input.c        |  270 ++-------------
 drivers/media/video/saa7134/saa7134.h              |   25 ++-
 drivers/media/video/tlg2300/Kconfig                |    2 +-
 drivers/staging/cx25821/Kconfig                    |    2 +-
 drivers/staging/go7007/Kconfig                     |    2 +-
 drivers/staging/tm6000/Kconfig                     |    2 +-
 drivers/staging/tm6000/tm6000-input.c              |   16 +-
 include/media/ir-common.h                          |   77 ----
 include/media/ir-core.h                            |  211 -----------
 include/media/ir-kbd-i2c.h                         |    4 +-
 include/media/rc-core.h                            |  220 ++++++++++++
 include/media/rc-map.h                             |   42 ++--
 181 files changed, 1819 insertions(+), 2068 deletions(-)
 delete mode 100644 drivers/media/rc/ir-functions.c
 create mode 100644 drivers/media/rc/ir-raw.c
 delete mode 100644 drivers/media/rc/rc-raw.c
 delete mode 100644 include/media/ir-common.h
 delete mode 100644 include/media/ir-core.h
 create mode 100644 include/media/rc-core.h


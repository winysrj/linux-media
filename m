Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53383 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752610AbdHKN7n (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 09:59:43 -0400
Date: Fri, 11 Aug 2017 14:59:41 +0100
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.14] RC changes (part #2)
Message-ID: <20170811135941.3jnmwkx7xbivxkxt@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please apply for-v4.14a before this pull request. This pull request includes
a cec fix from Hans, to prevent merge conflicts.

The last patch is fairly large, and its purpose is get rid of the ugly
RC_TYPE_ and RC_BIT_ names. I realise this is both invasive and
controversial, so I've re-ordered the patches so this patch can be droppped
easily.

As always I'm open to suggestions.

Thanks,

Sean

The following changes since commit 7af1952a935c062490dd697cd2cf7c65ee75dc19:

  [media] winbond-cir: buffer overrun during transmit (2017-08-04 15:59:50 +0100)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.14b

for you to fetch changes up to d4ee680ebd231bfe791975194073c62081cb217e:

  [media] rc: rename RC_TYPE_* to RC_PROTO_* and RC_BIT_* to RC_PROTO_BIT_* (2017-08-11 13:55:20 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      [media] cec: fix remote control passthrough

Sean Young (7):
      [media] rc-core: improve ir_raw_store_edge() handling
      [media] rc: saa7134: add trailing space for timely decoding
      [media] rc: simplify ir_raw_event_store_edge()
      [media] rc: ensure we do not read out of bounds
      [media] rc: saa7134: raw decoder can support any protocol
      [media] rc: per-protocol repeat period
      [media] rc: rename RC_TYPE_* to RC_PROTO_* and RC_BIT_* to RC_PROTO_BIT_*

 drivers/hid/hid-picolcd_cir.c                      |   2 +-
 drivers/media/cec/cec-adap.c                       |  56 ++++-
 drivers/media/cec/cec-core.c                       |  15 +-
 drivers/media/common/siano/smsir.c                 |   2 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |  57 ++---
 drivers/media/pci/bt8xx/bttv-input.c               |  16 +-
 drivers/media/pci/cx18/cx18-i2c.c                  |   4 +-
 drivers/media/pci/cx23885/cx23885-input.c          |  14 +-
 drivers/media/pci/cx88/cx88-input.c                |  28 +--
 drivers/media/pci/dm1105/dm1105.c                  |   2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |  14 +-
 drivers/media/pci/mantis/mantis_input.c            |   2 +-
 drivers/media/pci/saa7134/saa7134-input.c          |  79 +++----
 drivers/media/pci/smipcie/smipcie-ir.c             |   2 +-
 drivers/media/pci/ttpci/budget-ci.c                |   5 +-
 drivers/media/rc/ati_remote.c                      |   5 +-
 drivers/media/rc/ene_ir.c                          |   2 +-
 drivers/media/rc/fintek-cir.c                      |   2 +-
 drivers/media/rc/gpio-ir-recv.c                    |  29 +--
 drivers/media/rc/igorplugusb.c                     |   9 +-
 drivers/media/rc/iguanair.c                        |   2 +-
 drivers/media/rc/img-ir/img-ir-hw.c                |   4 +-
 drivers/media/rc/img-ir/img-ir-hw.h                |   4 +-
 drivers/media/rc/img-ir/img-ir-jvc.c               |   4 +-
 drivers/media/rc/img-ir/img-ir-nec.c               |  20 +-
 drivers/media/rc/img-ir/img-ir-raw.c               |   4 +-
 drivers/media/rc/img-ir/img-ir-rc5.c               |   4 +-
 drivers/media/rc/img-ir/img-ir-rc6.c               |   4 +-
 drivers/media/rc/img-ir/img-ir-sanyo.c             |   4 +-
 drivers/media/rc/img-ir/img-ir-sharp.c             |   4 +-
 drivers/media/rc/img-ir/img-ir-sony.c              |  27 +--
 drivers/media/rc/imon.c                            |  49 +++--
 drivers/media/rc/ir-hix5hd2.c                      |   2 +-
 drivers/media/rc/ir-jvc-decoder.c                  |   6 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |   6 +-
 drivers/media/rc/ir-nec-decoder.c                  |  17 +-
 drivers/media/rc/ir-rc5-decoder.c                  |  25 ++-
 drivers/media/rc/ir-rc6-decoder.c                  |  30 +--
 drivers/media/rc/ir-sanyo-decoder.c                |   6 +-
 drivers/media/rc/ir-sharp-decoder.c                |   6 +-
 drivers/media/rc/ir-sony-decoder.c                 |  23 +-
 drivers/media/rc/ir-xmp-decoder.c                  |   4 +-
 drivers/media/rc/ite-cir.c                         |   2 +-
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |   8 +-
 drivers/media/rc/keymaps/rc-alink-dtu-m.c          |   8 +-
 drivers/media/rc/keymaps/rc-anysee.c               |   8 +-
 drivers/media/rc/keymaps/rc-apac-viewcomp.c        |   8 +-
 drivers/media/rc/keymaps/rc-asus-pc39.c            |   8 +-
 drivers/media/rc/keymaps/rc-asus-ps3-100.c         |   8 +-
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c |   8 +-
 drivers/media/rc/keymaps/rc-ati-x10.c              |   8 +-
 drivers/media/rc/keymaps/rc-avermedia-a16d.c       |   8 +-
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |   8 +-
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |   8 +-
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |   8 +-
 .../media/rc/keymaps/rc-avermedia-m733a-rm-k6.c    |   8 +-
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c      |   8 +-
 drivers/media/rc/keymaps/rc-avermedia.c            |   8 +-
 drivers/media/rc/keymaps/rc-avertv-303.c           |   8 +-
 drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c   |   8 +-
 drivers/media/rc/keymaps/rc-behold-columbus.c      |   8 +-
 drivers/media/rc/keymaps/rc-behold.c               |   8 +-
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |   8 +-
 drivers/media/rc/keymaps/rc-cec.c                  |   2 +-
 drivers/media/rc/keymaps/rc-cinergy-1400.c         |   8 +-
 drivers/media/rc/keymaps/rc-cinergy.c              |   8 +-
 drivers/media/rc/keymaps/rc-d680-dmb.c             |   8 +-
 drivers/media/rc/keymaps/rc-delock-61959.c         |   8 +-
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |   8 +-
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          |   8 +-
 drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c  |   8 +-
 drivers/media/rc/keymaps/rc-digittrade.c           |   8 +-
 drivers/media/rc/keymaps/rc-dm1105-nec.c           |   8 +-
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |   8 +-
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c   |   8 +-
 drivers/media/rc/keymaps/rc-dtt200u.c              |   8 +-
 drivers/media/rc/keymaps/rc-dvbsky.c               |   8 +-
 drivers/media/rc/keymaps/rc-dvico-mce.c            |   8 +-
 drivers/media/rc/keymaps/rc-dvico-portable.c       |   8 +-
 drivers/media/rc/keymaps/rc-em-terratec.c          |   8 +-
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c    |   8 +-
 drivers/media/rc/keymaps/rc-encore-enltv.c         |   8 +-
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |   8 +-
 drivers/media/rc/keymaps/rc-evga-indtube.c         |   8 +-
 drivers/media/rc/keymaps/rc-eztv.c                 |   8 +-
 drivers/media/rc/keymaps/rc-flydvb.c               |   8 +-
 drivers/media/rc/keymaps/rc-flyvideo.c             |   8 +-
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c       |   8 +-
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c        |   8 +-
 drivers/media/rc/keymaps/rc-geekbox.c              |   8 +-
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c   |   8 +-
 drivers/media/rc/keymaps/rc-gotview7135.c          |   8 +-
 drivers/media/rc/keymaps/rc-hauppauge.c            |   8 +-
 drivers/media/rc/keymaps/rc-imon-mce.c             |   8 +-
 drivers/media/rc/keymaps/rc-imon-pad.c             |   8 +-
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c        |   8 +-
 drivers/media/rc/keymaps/rc-it913x-v1.c            |   8 +-
 drivers/media/rc/keymaps/rc-it913x-v2.c            |   8 +-
 drivers/media/rc/keymaps/rc-kaiomy.c               |   8 +-
 drivers/media/rc/keymaps/rc-kworld-315u.c          |   8 +-
 drivers/media/rc/keymaps/rc-kworld-pc150u.c        |   8 +-
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |   8 +-
 drivers/media/rc/keymaps/rc-leadtek-y04g0051.c     |   8 +-
 drivers/media/rc/keymaps/rc-lme2510.c              |   8 +-
 drivers/media/rc/keymaps/rc-manli.c                |   8 +-
 .../media/rc/keymaps/rc-medion-x10-digitainer.c    |   8 +-
 drivers/media/rc/keymaps/rc-medion-x10-or2x.c      |   8 +-
 drivers/media/rc/keymaps/rc-medion-x10.c           |   8 +-
 drivers/media/rc/keymaps/rc-msi-digivox-ii.c       |   8 +-
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c      |   8 +-
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |   8 +-
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c       |   8 +-
 drivers/media/rc/keymaps/rc-nebula.c               |   8 +-
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |   8 +-
 drivers/media/rc/keymaps/rc-norwood.c              |   8 +-
 drivers/media/rc/keymaps/rc-npgtech.c              |   8 +-
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |   8 +-
 drivers/media/rc/keymaps/rc-pinnacle-color.c       |   8 +-
 drivers/media/rc/keymaps/rc-pinnacle-grey.c        |   8 +-
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     |   8 +-
 drivers/media/rc/keymaps/rc-pixelview-002t.c       |   8 +-
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |   8 +-
 drivers/media/rc/keymaps/rc-pixelview-new.c        |   8 +-
 drivers/media/rc/keymaps/rc-pixelview.c            |   8 +-
 .../media/rc/keymaps/rc-powercolor-real-angel.c    |   8 +-
 drivers/media/rc/keymaps/rc-proteus-2309.c         |   8 +-
 drivers/media/rc/keymaps/rc-purpletv.c             |   8 +-
 drivers/media/rc/keymaps/rc-pv951.c                |   8 +-
 drivers/media/rc/keymaps/rc-rc6-mce.c              |   8 +-
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |   8 +-
 drivers/media/rc/keymaps/rc-reddo.c                |   8 +-
 drivers/media/rc/keymaps/rc-snapstream-firefly.c   |   8 +-
 drivers/media/rc/keymaps/rc-streamzap.c            |   8 +-
 drivers/media/rc/keymaps/rc-su3000.c               |   8 +-
 drivers/media/rc/keymaps/rc-tbs-nec.c              |   8 +-
 drivers/media/rc/keymaps/rc-technisat-ts35.c       |   8 +-
 drivers/media/rc/keymaps/rc-technisat-usb2.c       |   8 +-
 .../media/rc/keymaps/rc-terratec-cinergy-c-pci.c   |   8 +-
 .../media/rc/keymaps/rc-terratec-cinergy-s2-hd.c   |   8 +-
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c  |   8 +-
 drivers/media/rc/keymaps/rc-terratec-slim-2.c      |   8 +-
 drivers/media/rc/keymaps/rc-terratec-slim.c        |   8 +-
 drivers/media/rc/keymaps/rc-tevii-nec.c            |   8 +-
 drivers/media/rc/keymaps/rc-tivo.c                 |   8 +-
 .../media/rc/keymaps/rc-total-media-in-hand-02.c   |   8 +-
 drivers/media/rc/keymaps/rc-total-media-in-hand.c  |   8 +-
 drivers/media/rc/keymaps/rc-trekstor.c             |   8 +-
 drivers/media/rc/keymaps/rc-tt-1500.c              |   8 +-
 drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c   |   8 +-
 drivers/media/rc/keymaps/rc-twinhan1027.c          |   8 +-
 drivers/media/rc/keymaps/rc-videomate-m1f.c        |   8 +-
 drivers/media/rc/keymaps/rc-videomate-s350.c       |   8 +-
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c     |   8 +-
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c |   8 +-
 drivers/media/rc/keymaps/rc-winfast.c              |   8 +-
 drivers/media/rc/keymaps/rc-zx-irdec.c             |   2 +-
 drivers/media/rc/mceusb.c                          |   2 +-
 drivers/media/rc/meson-ir.c                        |   2 +-
 drivers/media/rc/mtk-cir.c                         |   2 +-
 drivers/media/rc/nuvoton-cir.c                     |   4 +-
 drivers/media/rc/rc-core-priv.h                    |   5 +-
 drivers/media/rc/rc-ir-raw.c                       |  67 +++---
 drivers/media/rc/rc-loopback.c                     |   4 +-
 drivers/media/rc/rc-main.c                         | 245 ++++++++++-----------
 drivers/media/rc/redrat3.c                         |   2 +-
 drivers/media/rc/serial_ir.c                       |   2 +-
 drivers/media/rc/sir_ir.c                          |   2 +-
 drivers/media/rc/st_rc.c                           |   2 +-
 drivers/media/rc/streamzap.c                       |   2 +-
 drivers/media/rc/sunxi-cir.c                       |   2 +-
 drivers/media/rc/ttusbir.c                         |   2 +-
 drivers/media/rc/winbond-cir.c                     |  33 +--
 drivers/media/rc/zx-irdec.c                        |   9 +-
 drivers/media/usb/au0828/au0828-input.c            |   4 +-
 drivers/media/usb/cx231xx/cx231xx-input.c          |   6 +-
 drivers/media/usb/dvb-usb-v2/af9015.c              |  11 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |  14 +-
 drivers/media/usb/dvb-usb-v2/anysee.c              |   4 +-
 drivers/media/usb/dvb-usb-v2/az6007.c              |  11 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |   2 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |   4 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |   6 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |  13 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |  30 +--
 drivers/media/usb/dvb-usb/dib0700.h                |   2 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |  28 +--
 drivers/media/usb/dvb-usb/dib0700_devices.c        | 152 ++++++-------
 drivers/media/usb/dvb-usb/dtt200u.c                |  12 +-
 drivers/media/usb/dvb-usb/dvb-usb.h                |   2 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |  21 +-
 drivers/media/usb/dvb-usb/m920x.c                  |   4 +-
 drivers/media/usb/dvb-usb/pctv452e.c               |   6 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |   2 +-
 drivers/media/usb/dvb-usb/ttusb2.c                 |   4 +-
 drivers/media/usb/em28xx/em28xx-input.c            | 124 ++++++-----
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |   3 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |  10 +-
 drivers/media/usb/tm6000/tm6000-input.c            |  38 ++--
 include/media/cec.h                                |   5 +
 include/media/i2c/ir-kbd-i2c.h                     |   8 +-
 include/media/rc-core.h                            |  43 ++--
 include/media/rc-map.h                             | 215 +++++++++---------
 202 files changed, 1365 insertions(+), 1300 deletions(-)

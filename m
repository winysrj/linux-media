Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:50017 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab1D1POE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 11:14:04 -0400
Subject: [PATCH 00/10] rc-core: my current patchqueue
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@redhat.com
Date: Thu, 28 Apr 2011 17:13:11 +0200
Message-ID: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following series is what's in my current patch queue for rc-core.

It only been lightly tested so far and it's based on the "for_v2.6.39" branch,
but I still wanted to send it to the list so that I can get some feedback while
I refresh the patches to "for_v2.6.40" and do more testing.

The most interesting change is that the scancode that is passed to/from
the EVIOC[GS]KEYCODE_V2 ioctl has been extended so that this struct:

        struct input_keymap_entry {
                __u8  flags;
                __u8  len;
                __u16 index;
                __u32 keycode;
                __u8  scancode[32];
        };

Is parsed like this:

        struct rc_scancode {
                __u16 protocol;
                __u16 reserved[3];
                __u64 scancode;
        }
    
        struct rc_keymap_entry {
                __u8  flags;
                __u8  len;
                __u16 index;
                __u32 keycode;
                union {
                        struct rc_scancode rc;
                        __u8 raw[32];
                };
        };

Which allows the protocol to be specified along with the scancode.

Some heuristics are in place to guess the correct protocol when it is
missing (i.e. when the legacy ioctl's are used or when the new ioctl's
are used but with a shorter len).

The advantage is that rc-core doesn't throw away its knowledge of
the protocol used to generate a given scancode. This also means that 
e.g. merging the rc5 and streamzap decoders is made easier (see one
of the last patches in this series). In addition, it makes it possible
to have mixed-protocol keytables, should anyone wish to do that.

This unfortunately means that every keymap had to be changed as well which
is the reason for the large number of lines changed in the combined diffstat
(the number of lines changed would probably be in the hundreds rather than
thousands if keymaps were excluded).

Comments?

---

David Härdeman (10):
      rc-core: int to bool conversion for winbond-cir
      rc-core: add TX support to the winbond-cir driver
      rc-core: use ir_raw_event_store_with_filter in winbond-cir
      rc-core: add trailing silence in rc-loopback tx
      rc-core: add separate defines for protocol bitmaps and numbers
      rc-core: don't throw away protocol information
      rc-core: use the full 32 bits for NEC scancodes
      rc-core: merge rc5 and streamzap decoders
      rc-core: lirc use unsigned int
      rc-core: move timeout and checks to lirc


 drivers/media/dvb/dm1105/dm1105.c                  |    3 
 drivers/media/dvb/dvb-usb/af9015.c                 |   34 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |    4 
 drivers/media/dvb/dvb-usb/dib0700_core.c           |   10 
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |  126 +++---
 drivers/media/dvb/dvb-usb/dvb-usb.h                |    2 
 drivers/media/dvb/dvb-usb/lmedm04.c                |    2 
 drivers/media/dvb/dvb-usb/technisat-usb2.c         |    2 
 drivers/media/dvb/dvb-usb/ttusb2.c                 |    4 
 drivers/media/dvb/mantis/mantis_input.c            |  117 +++--
 drivers/media/dvb/siano/smsir.c                    |    2 
 drivers/media/dvb/ttpci/budget-ci.c                |    7 
 drivers/media/rc/Kconfig                           |   12 -
 drivers/media/rc/Makefile                          |    1 
 drivers/media/rc/ene_ir.c                          |    6 
 drivers/media/rc/ene_ir.h                          |    2 
 drivers/media/rc/imon.c                            |   35 +-
 drivers/media/rc/ir-jvc-decoder.c                  |    6 
 drivers/media/rc/ir-lirc-codec.c                   |   46 ++
 drivers/media/rc/ir-nec-decoder.c                  |   32 -
 drivers/media/rc/ir-raw.c                          |    2 
 drivers/media/rc/ir-rc5-decoder.c                  |   62 ++-
 drivers/media/rc/ir-rc5-sz-decoder.c               |  153 -------
 drivers/media/rc/ir-rc6-decoder.c                  |    6 
 drivers/media/rc/ir-sony-decoder.c                 |   17 +
 drivers/media/rc/ite-cir.c                         |    7 
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |   89 ++--
 drivers/media/rc/keymaps/rc-alink-dtu-m.c          |   37 +-
 drivers/media/rc/keymaps/rc-anysee.c               |   89 ++--
 drivers/media/rc/keymaps/rc-apac-viewcomp.c        |   65 +--
 drivers/media/rc/keymaps/rc-asus-pc39.c            |   79 ++--
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c |   49 +-
 drivers/media/rc/keymaps/rc-avermedia-a16d.c       |   69 ++-
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |  109 ++---
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |   69 ++-
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |  187 ++++----
 .../media/rc/keymaps/rc-avermedia-m733a-rm-k6.c    |   89 ++--
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c      |   55 +-
 drivers/media/rc/keymaps/rc-avermedia.c            |   73 ++-
 drivers/media/rc/keymaps/rc-avertv-303.c           |   73 ++-
 drivers/media/rc/keymaps/rc-azurewave-ad-tu700.c   |  107 ++---
 drivers/media/rc/keymaps/rc-behold-columbus.c      |   73 ++-
 drivers/media/rc/keymaps/rc-behold.c               |   69 ++-
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |   91 ++--
 drivers/media/rc/keymaps/rc-cinergy-1400.c         |   75 ++-
 drivers/media/rc/keymaps/rc-cinergy.c              |   73 ++-
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |  141 +++---
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          |  361 ++++++++--------
 drivers/media/rc/keymaps/rc-digitalnow-tinytwin.c  |   99 ++--
 drivers/media/rc/keymaps/rc-digittrade.c           |   57 +--
 drivers/media/rc/keymaps/rc-dm1105-nec.c           |   63 +--
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |   65 +--
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c   |  107 ++---
 drivers/media/rc/keymaps/rc-em-terratec.c          |   57 +--
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c    |   59 +--
 drivers/media/rc/keymaps/rc-encore-enltv.c         |  131 +++---
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |   79 ++--
 drivers/media/rc/keymaps/rc-evga-indtube.c         |   33 +
 drivers/media/rc/keymaps/rc-eztv.c                 |   89 ++--
 drivers/media/rc/keymaps/rc-flydvb.c               |   65 +--
 drivers/media/rc/keymaps/rc-flyvideo.c             |   53 +-
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c       |  105 ++---
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c        |   63 +--
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c   |   65 +--
 drivers/media/rc/keymaps/rc-gotview7135.c          |   69 ++-
 drivers/media/rc/keymaps/rc-hauppauge.c            |  287 ++++++-------
 drivers/media/rc/keymaps/rc-imon-mce.c             |  173 ++++----
 drivers/media/rc/keymaps/rc-imon-pad.c             |  215 +++++-----
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c        |   87 ++--
 drivers/media/rc/keymaps/rc-kaiomy.c               |   65 +--
 drivers/media/rc/keymaps/rc-kworld-315u.c          |   65 +--
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |   71 ++-
 drivers/media/rc/keymaps/rc-leadtek-y04g0051.c     |  101 ++---
 drivers/media/rc/keymaps/rc-lirc.c                 |    1 
 drivers/media/rc/keymaps/rc-lme2510.c              |  133 +++---
 drivers/media/rc/keymaps/rc-manli.c                |   97 ++--
 drivers/media/rc/keymaps/rc-msi-digivox-ii.c       |   37 +-
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c      |   65 +--
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |   89 ++--
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c       |   49 +-
 drivers/media/rc/keymaps/rc-nebula.c               |  111 ++---
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |  121 +++--
 drivers/media/rc/keymaps/rc-norwood.c              |   69 +--
 drivers/media/rc/keymaps/rc-npgtech.c              |   71 ++-
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |   65 +--
 drivers/media/rc/keymaps/rc-pinnacle-color.c       |  107 ++---
 drivers/media/rc/keymaps/rc-pinnacle-grey.c        |   83 ++--
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     |   51 +-
 drivers/media/rc/keymaps/rc-pixelview-002t.c       |   53 +-
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |   63 +--
 drivers/media/rc/keymaps/rc-pixelview-new.c        |   63 +--
 drivers/media/rc/keymaps/rc-pixelview.c            |   77 ++-
 .../media/rc/keymaps/rc-powercolor-real-angel.c    |   71 ++-
 drivers/media/rc/keymaps/rc-proteus-2309.c         |   49 +-
 drivers/media/rc/keymaps/rc-purpletv.c             |   71 ++-
 drivers/media/rc/keymaps/rc-pv951.c                |   63 +--
 drivers/media/rc/keymaps/rc-rc6-mce.c              |  151 +++----
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |   57 +--
 drivers/media/rc/keymaps/rc-streamzap.c            |   75 ++-
 drivers/media/rc/keymaps/rc-tbs-nec.c              |   69 ++-
 drivers/media/rc/keymaps/rc-technisat-usb2.c       |   67 +--
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c  |   95 ++--
 drivers/media/rc/keymaps/rc-terratec-slim-2.c      |   37 +-
 drivers/media/rc/keymaps/rc-terratec-slim.c        |   57 +--
 drivers/media/rc/keymaps/rc-tevii-nec.c            |   95 ++--
 drivers/media/rc/keymaps/rc-total-media-in-hand.c  |   71 ++-
 drivers/media/rc/keymaps/rc-trekstor.c             |   57 +--
 drivers/media/rc/keymaps/rc-tt-1500.c              |   79 ++--
 drivers/media/rc/keymaps/rc-twinhan1027.c          |  107 ++---
 drivers/media/rc/keymaps/rc-videomate-m1f.c        |  103 ++---
 drivers/media/rc/keymaps/rc-videomate-s350.c       |   89 ++--
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c     |   93 ++--
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c |   57 +--
 drivers/media/rc/keymaps/rc-winfast.c              |  113 +++--
 drivers/media/rc/mceusb.c                          |   30 -
 drivers/media/rc/nuvoton-cir.c                     |   14 -
 drivers/media/rc/rc-core-priv.h                    |    9 
 drivers/media/rc/rc-loopback.c                     |   33 -
 drivers/media/rc/rc-main.c                         |  248 ++++++++---
 drivers/media/rc/streamzap.c                       |   12 -
 drivers/media/rc/winbond-cir.c                     |  442 ++++++++++++++++----
 drivers/media/video/bt8xx/bttv-input.c             |   10 
 drivers/media/video/cx18/cx18-i2c.c                |    2 
 drivers/media/video/cx231xx/cx231xx-input.c        |    2 
 drivers/media/video/cx23885/cx23885-input.c        |    4 
 drivers/media/video/cx88/cx88-input.c              |   18 -
 drivers/media/video/em28xx/em28xx-cards.c          |   17 +
 drivers/media/video/em28xx/em28xx-input.c          |   38 +-
 drivers/media/video/em28xx/em28xx.h                |    1 
 drivers/media/video/hdpvr/hdpvr-i2c.c              |    2 
 drivers/media/video/ir-kbd-i2c.c                   |   26 +
 drivers/media/video/ivtv/ivtv-i2c.c                |    8 
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c     |    4 
 drivers/media/video/saa7134/saa7134-input.c        |    8 
 drivers/staging/tm6000/tm6000-cards.c              |    2 
 drivers/staging/tm6000/tm6000-input.c              |   46 +-
 include/media/rc-core.h                            |   30 +
 include/media/rc-map.h                             |   62 ++-
 138 files changed, 4735 insertions(+), 4609 deletions(-)
 delete mode 100644 drivers/media/rc/ir-rc5-sz-decoder.c

-- 
David Härdeman


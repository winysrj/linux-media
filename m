Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab0KJDRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 22:17:31 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAA3HVj7003512
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 9 Nov 2010 22:17:31 -0500
Received: from pedra (vpn-229-171.phx2.redhat.com [10.3.229.171])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oAA3DKla031781
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 9 Nov 2010 22:17:30 -0500
Date: Wed, 10 Nov 2010 01:13:12 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] Rename rc-core files
Message-ID: <20101110011312.5ee979a9@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series basically rename rc-core files.

I took David Härdeman's idea to merge rc-sysfs, rc-map and rc-keycode
into one file, and to rename ir-raw-event as rc-raw, in order to make
easier to merge his two remaining patches.

Yet, patch 5/6 from his series breaks, due to the upstream changes
made on ir-keytable.c.

I didn't made a cleanup at include/media/ir-core.h yet, but there are some
functions now that can be static, and the file, itself, should also be
renamed to rc-core.h.

PS.: The files were generated with git option -M, in order to be easier
for review, as the diff file will just show the actual differences after
the renames.

Mauro Carvalho Chehab (4):
  [media] rename drivers/media/IR to drives/media/rc
  [media] Rename rc-core files from ir- to rc-
  [media] rc-core: Merge rc-sysfs.c into rc-main.c
  [media] rc-core: merge rc-map.c into rc-main.c

 drivers/media/IR/ir-keytable.c                     |  633 ------------
 drivers/media/IR/ir-sysfs.c                        |  362 -------
 drivers/media/IR/rc-map.c                          |  107 --
 drivers/media/Kconfig                              |    2 +-
 drivers/media/Makefile                             |    2 +-
 drivers/media/{IR => rc}/Kconfig                   |    2 +-
 drivers/media/{IR => rc}/Makefile                  |    4 +-
 drivers/media/{IR => rc}/ene_ir.c                  |    0
 drivers/media/{IR => rc}/ene_ir.h                  |    0
 drivers/media/{IR => rc}/imon.c                    |    0
 drivers/media/{IR => rc}/ir-functions.c            |    2 +-
 drivers/media/{IR => rc}/ir-jvc-decoder.c          |    2 +-
 drivers/media/{IR => rc}/ir-lirc-codec.c           |    2 +-
 drivers/media/{IR => rc}/ir-nec-decoder.c          |    2 +-
 drivers/media/{IR => rc}/ir-rc5-decoder.c          |    2 +-
 drivers/media/{IR => rc}/ir-rc5-sz-decoder.c       |    2 +-
 drivers/media/{IR => rc}/ir-rc6-decoder.c          |    2 +-
 drivers/media/{IR => rc}/ir-sony-decoder.c         |    2 +-
 drivers/media/{IR => rc}/keymaps/Kconfig           |    0
 drivers/media/{IR => rc}/keymaps/Makefile          |    0
 .../{IR => rc}/keymaps/rc-adstech-dvb-t-pci.c      |    0
 drivers/media/{IR => rc}/keymaps/rc-alink-dtu-m.c  |    0
 drivers/media/{IR => rc}/keymaps/rc-anysee.c       |    0
 .../media/{IR => rc}/keymaps/rc-apac-viewcomp.c    |    0
 drivers/media/{IR => rc}/keymaps/rc-asus-pc39.c    |    0
 .../{IR => rc}/keymaps/rc-ati-tv-wonder-hd-600.c   |    0
 .../media/{IR => rc}/keymaps/rc-avermedia-a16d.c   |    0
 .../{IR => rc}/keymaps/rc-avermedia-cardbus.c      |    0
 .../media/{IR => rc}/keymaps/rc-avermedia-dvbt.c   |    0
 .../media/{IR => rc}/keymaps/rc-avermedia-m135a.c  |    0
 .../{IR => rc}/keymaps/rc-avermedia-m733a-rm-k6.c  |    0
 .../media/{IR => rc}/keymaps/rc-avermedia-rm-ks.c  |    0
 drivers/media/{IR => rc}/keymaps/rc-avermedia.c    |    0
 drivers/media/{IR => rc}/keymaps/rc-avertv-303.c   |    0
 .../{IR => rc}/keymaps/rc-azurewave-ad-tu700.c     |    0
 .../media/{IR => rc}/keymaps/rc-behold-columbus.c  |    0
 drivers/media/{IR => rc}/keymaps/rc-behold.c       |    0
 .../media/{IR => rc}/keymaps/rc-budget-ci-old.c    |    0
 drivers/media/{IR => rc}/keymaps/rc-cinergy-1400.c |    0
 drivers/media/{IR => rc}/keymaps/rc-cinergy.c      |    0
 drivers/media/{IR => rc}/keymaps/rc-dib0700-nec.c  |    0
 drivers/media/{IR => rc}/keymaps/rc-dib0700-rc5.c  |    0
 .../{IR => rc}/keymaps/rc-digitalnow-tinytwin.c    |    0
 drivers/media/{IR => rc}/keymaps/rc-digittrade.c   |    0
 drivers/media/{IR => rc}/keymaps/rc-dm1105-nec.c   |    0
 .../media/{IR => rc}/keymaps/rc-dntv-live-dvb-t.c  |    0
 .../{IR => rc}/keymaps/rc-dntv-live-dvbt-pro.c     |    0
 drivers/media/{IR => rc}/keymaps/rc-em-terratec.c  |    0
 .../{IR => rc}/keymaps/rc-encore-enltv-fm53.c      |    0
 drivers/media/{IR => rc}/keymaps/rc-encore-enltv.c |    0
 .../media/{IR => rc}/keymaps/rc-encore-enltv2.c    |    0
 drivers/media/{IR => rc}/keymaps/rc-evga-indtube.c |    0
 drivers/media/{IR => rc}/keymaps/rc-eztv.c         |    0
 drivers/media/{IR => rc}/keymaps/rc-flydvb.c       |    0
 drivers/media/{IR => rc}/keymaps/rc-flyvideo.c     |    0
 .../media/{IR => rc}/keymaps/rc-fusionhdtv-mce.c   |    0
 .../media/{IR => rc}/keymaps/rc-gadmei-rm008z.c    |    0
 .../{IR => rc}/keymaps/rc-genius-tvgo-a11mce.c     |    0
 drivers/media/{IR => rc}/keymaps/rc-gotview7135.c  |    0
 .../media/{IR => rc}/keymaps/rc-hauppauge-new.c    |    0
 drivers/media/{IR => rc}/keymaps/rc-imon-mce.c     |    0
 drivers/media/{IR => rc}/keymaps/rc-imon-pad.c     |    0
 .../media/{IR => rc}/keymaps/rc-iodata-bctv7e.c    |    0
 drivers/media/{IR => rc}/keymaps/rc-kaiomy.c       |    0
 drivers/media/{IR => rc}/keymaps/rc-kworld-315u.c  |    0
 .../{IR => rc}/keymaps/rc-kworld-plus-tv-analog.c  |    0
 .../media/{IR => rc}/keymaps/rc-leadtek-y04g0051.c |    0
 drivers/media/{IR => rc}/keymaps/rc-lirc.c         |    0
 drivers/media/{IR => rc}/keymaps/rc-lme2510.c      |    0
 drivers/media/{IR => rc}/keymaps/rc-manli.c        |    0
 .../media/{IR => rc}/keymaps/rc-msi-digivox-ii.c   |    0
 .../media/{IR => rc}/keymaps/rc-msi-digivox-iii.c  |    0
 .../{IR => rc}/keymaps/rc-msi-tvanywhere-plus.c    |    0
 .../media/{IR => rc}/keymaps/rc-msi-tvanywhere.c   |    0
 drivers/media/{IR => rc}/keymaps/rc-nebula.c       |    0
 .../keymaps/rc-nec-terratec-cinergy-xs.c           |    0
 drivers/media/{IR => rc}/keymaps/rc-norwood.c      |    0
 drivers/media/{IR => rc}/keymaps/rc-npgtech.c      |    0
 drivers/media/{IR => rc}/keymaps/rc-pctv-sedna.c   |    0
 .../media/{IR => rc}/keymaps/rc-pinnacle-color.c   |    0
 .../media/{IR => rc}/keymaps/rc-pinnacle-grey.c    |    0
 .../media/{IR => rc}/keymaps/rc-pinnacle-pctv-hd.c |    0
 .../media/{IR => rc}/keymaps/rc-pixelview-mk12.c   |    0
 .../media/{IR => rc}/keymaps/rc-pixelview-new.c    |    0
 drivers/media/{IR => rc}/keymaps/rc-pixelview.c    |    0
 .../{IR => rc}/keymaps/rc-powercolor-real-angel.c  |    0
 drivers/media/{IR => rc}/keymaps/rc-proteus-2309.c |    0
 drivers/media/{IR => rc}/keymaps/rc-purpletv.c     |    0
 drivers/media/{IR => rc}/keymaps/rc-pv951.c        |    0
 .../{IR => rc}/keymaps/rc-rc5-hauppauge-new.c      |    0
 drivers/media/{IR => rc}/keymaps/rc-rc5-tv.c       |    0
 drivers/media/{IR => rc}/keymaps/rc-rc6-mce.c      |    0
 .../{IR => rc}/keymaps/rc-real-audio-220-32-keys.c |    0
 drivers/media/{IR => rc}/keymaps/rc-streamzap.c    |    0
 drivers/media/{IR => rc}/keymaps/rc-tbs-nec.c      |    0
 .../{IR => rc}/keymaps/rc-terratec-cinergy-xs.c    |    0
 .../media/{IR => rc}/keymaps/rc-terratec-slim.c    |    0
 drivers/media/{IR => rc}/keymaps/rc-tevii-nec.c    |    0
 .../{IR => rc}/keymaps/rc-total-media-in-hand.c    |    0
 drivers/media/{IR => rc}/keymaps/rc-trekstor.c     |    0
 drivers/media/{IR => rc}/keymaps/rc-tt-1500.c      |    0
 drivers/media/{IR => rc}/keymaps/rc-twinhan1027.c  |    0
 .../media/{IR => rc}/keymaps/rc-videomate-s350.c   |    0
 .../media/{IR => rc}/keymaps/rc-videomate-tv-pvr.c |    0
 .../{IR => rc}/keymaps/rc-winfast-usbii-deluxe.c   |    0
 drivers/media/{IR => rc}/keymaps/rc-winfast.c      |    0
 drivers/media/{IR => rc}/lirc_dev.c                |    0
 drivers/media/{IR => rc}/mceusb.c                  |    0
 drivers/media/{IR => rc}/nuvoton-cir.c             |    0
 drivers/media/{IR => rc}/nuvoton-cir.h             |    0
 .../media/{IR/ir-core-priv.h => rc/rc-core-priv.h} |    0
 drivers/media/rc/rc-main.c                         | 1070 ++++++++++++++++++++
 drivers/media/{IR/ir-raw-event.c => rc/rc-raw.c}   |    2 +-
 drivers/media/{IR => rc}/streamzap.c               |    0
 114 files changed, 1084 insertions(+), 1116 deletions(-)
 delete mode 100644 drivers/media/IR/ir-keytable.c
 delete mode 100644 drivers/media/IR/ir-sysfs.c
 delete mode 100644 drivers/media/IR/rc-map.c
 rename drivers/media/{IR => rc}/Kconfig (99%)
 rename drivers/media/{IR => rc}/Makefile (87%)
 rename drivers/media/{IR => rc}/ene_ir.c (100%)
 rename drivers/media/{IR => rc}/ene_ir.h (100%)
 rename drivers/media/{IR => rc}/imon.c (100%)
 rename drivers/media/{IR => rc}/ir-functions.c (99%)
 rename drivers/media/{IR => rc}/ir-jvc-decoder.c (99%)
 rename drivers/media/{IR => rc}/ir-lirc-codec.c (99%)
 rename drivers/media/{IR => rc}/ir-nec-decoder.c (99%)
 rename drivers/media/{IR => rc}/ir-rc5-decoder.c (99%)
 rename drivers/media/{IR => rc}/ir-rc5-sz-decoder.c (99%)
 rename drivers/media/{IR => rc}/ir-rc6-decoder.c (99%)
 rename drivers/media/{IR => rc}/ir-sony-decoder.c (99%)
 rename drivers/media/{IR => rc}/keymaps/Kconfig (100%)
 rename drivers/media/{IR => rc}/keymaps/Makefile (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-adstech-dvb-t-pci.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-alink-dtu-m.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-anysee.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-apac-viewcomp.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-asus-pc39.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-ati-tv-wonder-hd-600.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-a16d.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-cardbus.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-dvbt.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-m135a.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-m733a-rm-k6.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia-rm-ks.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avermedia.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-avertv-303.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-azurewave-ad-tu700.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-behold-columbus.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-behold.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-budget-ci-old.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-cinergy-1400.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-cinergy.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-dib0700-nec.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-dib0700-rc5.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-digitalnow-tinytwin.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-digittrade.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-dm1105-nec.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-dntv-live-dvb-t.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-dntv-live-dvbt-pro.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-em-terratec.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-encore-enltv-fm53.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-encore-enltv.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-encore-enltv2.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-evga-indtube.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-eztv.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-flydvb.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-flyvideo.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-fusionhdtv-mce.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-gadmei-rm008z.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-genius-tvgo-a11mce.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-gotview7135.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-hauppauge-new.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-imon-mce.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-imon-pad.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-iodata-bctv7e.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-kaiomy.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-kworld-315u.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-kworld-plus-tv-analog.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-leadtek-y04g0051.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-lirc.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-lme2510.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-manli.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-msi-digivox-ii.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-msi-digivox-iii.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-msi-tvanywhere-plus.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-msi-tvanywhere.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-nebula.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-nec-terratec-cinergy-xs.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-norwood.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-npgtech.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pctv-sedna.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pinnacle-color.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pinnacle-grey.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pinnacle-pctv-hd.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pixelview-mk12.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pixelview-new.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pixelview.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-powercolor-real-angel.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-proteus-2309.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-purpletv.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-pv951.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-rc5-hauppauge-new.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-rc5-tv.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-rc6-mce.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-real-audio-220-32-keys.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-streamzap.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-tbs-nec.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-terratec-cinergy-xs.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-terratec-slim.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-tevii-nec.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-total-media-in-hand.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-trekstor.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-tt-1500.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-twinhan1027.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-videomate-s350.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-videomate-tv-pvr.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-winfast-usbii-deluxe.c (100%)
 rename drivers/media/{IR => rc}/keymaps/rc-winfast.c (100%)
 rename drivers/media/{IR => rc}/lirc_dev.c (100%)
 rename drivers/media/{IR => rc}/mceusb.c (100%)
 rename drivers/media/{IR => rc}/nuvoton-cir.c (100%)
 rename drivers/media/{IR => rc}/nuvoton-cir.h (100%)
 rename drivers/media/{IR/ir-core-priv.h => rc/rc-core-priv.h} (100%)
 create mode 100644 drivers/media/rc/rc-main.c
 rename drivers/media/{IR/ir-raw-event.c => rc/rc-raw.c} (99%)
 rename drivers/media/{IR => rc}/streamzap.c (100%)


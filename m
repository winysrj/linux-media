Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab2FNUix (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 16:38:53 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5EKcrZV026668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 16:38:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 00/10] media file tree reorg - part 1
Date: Thu, 14 Jun 2012 17:35:51 -0300
Message-Id: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed a while ago, breaking media drivers by V4L or DVB
is confusing, as:
	- hybrid devices are at V4L drivers;
	- DVB-only devices for chips that support analog are at
	  V4L drivers;
	- Analog support addition on a DVB driver would require it
	  to move to V4L drivers.

Instead, move all drivers into a per-bus directory, and common drivers
used by more than one driver into /common.

This is the part 1 of this idea: it moves the core drivers to
/drivers/media/foo-core, and re-arranges the DVB files.

After this patch series, the directory structure will be:

drivers/media/
|-- common
|   `-- <common drivers>
|-- dvb-core
|-- dvb-frontends
|-- firewire
|-- mmc
|   `-- <mmc/sdio drivers>
|-- pci
|   `-- <pci/pcie drivers>
|-- radio
|   `-- <radio drivers>
|-- rc
|   `-- keymaps
|-- tuners
|-- usb
|   `-- <usb drivers>
|-- v4l2-core
`-- video

PS.: The "video" directory is currently unchanged. It currently
     contains subdevs, common V4L drivers, and V4L bridges.

On this series, I avoided mixing the file tree reorganization with
menu improvements. Those will happen together with the second part,
when the devices under video will be moved to /common, /usb, /pci...
dirs.

Mauro Carvalho Chehab (10):
  [media] v4l: move v4l2 core into a separate directory
  [media] dvb: move the dvb core one level up
  [media] move the dvb/frontends to drivers/media/dvb-frontends
  [media] firewire: move it one level up
  [media] dvb-usb: move it to drivers/media/usb/dvb-usb
  [media] Rename media/dvb as media/pci
  [media] b2c2: break it into common/pci/usb directories
  [media] common: move media/common/tuners to media/tuners
  [media] saa7146: Move it to its own directory
  [media] break siano into mmc and usb directories

 Documentation/DocBook/media/dvb/kdapi.xml          |    2 +-
 Documentation/dvb/README.dvb-usb                   |    2 +-
 MAINTAINERS                                        |    4 +-
 drivers/media/Kconfig                              |   20 ++++-
 drivers/media/Makefile                             |    5 +-
 drivers/media/common/Kconfig                       |   12 +--
 drivers/media/common/Makefile                      |    7 +-
 drivers/media/{dvb => common}/b2c2/Kconfig         |   20 +----
 drivers/media/common/b2c2/Makefile                 |    7 ++
 .../media/{dvb => common}/b2c2/flexcop-common.h    |    0
 .../media/{dvb => common}/b2c2/flexcop-eeprom.c    |    0
 .../media/{dvb => common}/b2c2/flexcop-fe-tuner.c  |    0
 .../media/{dvb => common}/b2c2/flexcop-hw-filter.c |    0
 drivers/media/{dvb => common}/b2c2/flexcop-i2c.c   |    0
 drivers/media/{dvb => common}/b2c2/flexcop-misc.c  |    0
 drivers/media/{dvb => common}/b2c2/flexcop-reg.h   |    0
 drivers/media/{dvb => common}/b2c2/flexcop-sram.c  |    0
 drivers/media/{dvb => common}/b2c2/flexcop.c       |    0
 drivers/media/{dvb => common}/b2c2/flexcop.h       |    0
 .../{dvb => common}/b2c2/flexcop_ibi_value_be.h    |    0
 .../{dvb => common}/b2c2/flexcop_ibi_value_le.h    |    0
 drivers/media/common/saa7146/Kconfig               |    9 ++
 drivers/media/common/saa7146/Makefile              |    5 ++
 drivers/media/common/{ => saa7146}/saa7146_core.c  |    0
 drivers/media/common/{ => saa7146}/saa7146_fops.c  |    0
 drivers/media/common/{ => saa7146}/saa7146_hlp.c   |    0
 drivers/media/common/{ => saa7146}/saa7146_i2c.c   |    0
 drivers/media/common/{ => saa7146}/saa7146_vbi.c   |    0
 drivers/media/common/{ => saa7146}/saa7146_video.c |    0
 drivers/media/common/siano/Kconfig                 |   17 ++++
 drivers/media/{dvb => common}/siano/Makefile       |    6 +-
 drivers/media/{dvb => common}/siano/sms-cards.c    |    0
 drivers/media/{dvb => common}/siano/sms-cards.h    |    0
 drivers/media/{dvb => common}/siano/smscoreapi.c   |    0
 drivers/media/{dvb => common}/siano/smscoreapi.h   |    0
 drivers/media/{dvb => common}/siano/smsdvb.c       |    0
 drivers/media/{dvb => common}/siano/smsendian.c    |    0
 drivers/media/{dvb => common}/siano/smsendian.h    |    0
 drivers/media/{dvb => common}/siano/smsir.c        |    0
 drivers/media/{dvb => common}/siano/smsir.h        |    0
 drivers/media/dvb-core/Kconfig                     |   29 +++++++
 drivers/media/{dvb => }/dvb-core/Makefile          |    0
 drivers/media/{dvb => }/dvb-core/demux.h           |    0
 drivers/media/{dvb => }/dvb-core/dmxdev.c          |    0
 drivers/media/{dvb => }/dvb-core/dmxdev.h          |    0
 drivers/media/{dvb => }/dvb-core/dvb_ca_en50221.c  |    0
 drivers/media/{dvb => }/dvb-core/dvb_ca_en50221.h  |    0
 drivers/media/{dvb => }/dvb-core/dvb_demux.c       |    0
 drivers/media/{dvb => }/dvb-core/dvb_demux.h       |    0
 drivers/media/{dvb => }/dvb-core/dvb_filter.c      |    0
 drivers/media/{dvb => }/dvb-core/dvb_filter.h      |    0
 drivers/media/{dvb => }/dvb-core/dvb_frontend.c    |    0
 drivers/media/{dvb => }/dvb-core/dvb_frontend.h    |    0
 drivers/media/{dvb => }/dvb-core/dvb_math.c        |    0
 drivers/media/{dvb => }/dvb-core/dvb_math.h        |    0
 drivers/media/{dvb => }/dvb-core/dvb_net.c         |    0
 drivers/media/{dvb => }/dvb-core/dvb_net.h         |    0
 drivers/media/{dvb => }/dvb-core/dvb_ringbuffer.c  |    0
 drivers/media/{dvb => }/dvb-core/dvb_ringbuffer.h  |    0
 drivers/media/{dvb => }/dvb-core/dvbdev.c          |    0
 drivers/media/{dvb => }/dvb-core/dvbdev.h          |    0
 .../media/{dvb/frontends => dvb-frontends}/Kconfig |    0
 .../{dvb/frontends => dvb-frontends}/Makefile      |    4 +-
 .../media/{dvb/frontends => dvb-frontends}/a8293.c |    0
 .../media/{dvb/frontends => dvb-frontends}/a8293.h |    0
 .../{dvb/frontends => dvb-frontends}/af9013.c      |    0
 .../{dvb/frontends => dvb-frontends}/af9013.h      |    0
 .../{dvb/frontends => dvb-frontends}/af9013_priv.h |    0
 .../{dvb/frontends => dvb-frontends}/af9033.c      |    0
 .../{dvb/frontends => dvb-frontends}/af9033.h      |    0
 .../{dvb/frontends => dvb-frontends}/af9033_priv.h |    0
 .../{dvb/frontends => dvb-frontends}/atbm8830.c    |    0
 .../{dvb/frontends => dvb-frontends}/atbm8830.h    |    0
 .../frontends => dvb-frontends}/atbm8830_priv.h    |    0
 .../{dvb/frontends => dvb-frontends}/au8522.h      |    0
 .../frontends => dvb-frontends}/au8522_common.c    |    0
 .../frontends => dvb-frontends}/au8522_decoder.c   |    0
 .../{dvb/frontends => dvb-frontends}/au8522_dig.c  |    0
 .../{dvb/frontends => dvb-frontends}/au8522_priv.h |    0
 .../{dvb/frontends => dvb-frontends}/bcm3510.c     |    0
 .../{dvb/frontends => dvb-frontends}/bcm3510.h     |    0
 .../frontends => dvb-frontends}/bcm3510_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/bsbe1-d01a.h  |    0
 .../media/{dvb/frontends => dvb-frontends}/bsbe1.h |    0
 .../media/{dvb/frontends => dvb-frontends}/bsru6.h |    0
 .../{dvb/frontends => dvb-frontends}/cx22700.c     |    0
 .../{dvb/frontends => dvb-frontends}/cx22700.h     |    0
 .../{dvb/frontends => dvb-frontends}/cx22702.c     |    0
 .../{dvb/frontends => dvb-frontends}/cx22702.h     |    0
 .../{dvb/frontends => dvb-frontends}/cx24110.c     |    0
 .../{dvb/frontends => dvb-frontends}/cx24110.h     |    0
 .../{dvb/frontends => dvb-frontends}/cx24113.c     |    0
 .../{dvb/frontends => dvb-frontends}/cx24113.h     |    0
 .../{dvb/frontends => dvb-frontends}/cx24116.c     |    0
 .../{dvb/frontends => dvb-frontends}/cx24116.h     |    0
 .../{dvb/frontends => dvb-frontends}/cx24123.c     |    0
 .../{dvb/frontends => dvb-frontends}/cx24123.h     |    0
 .../{dvb/frontends => dvb-frontends}/cxd2820r.h    |    0
 .../{dvb/frontends => dvb-frontends}/cxd2820r_c.c  |    0
 .../frontends => dvb-frontends}/cxd2820r_core.c    |    0
 .../frontends => dvb-frontends}/cxd2820r_priv.h    |    0
 .../{dvb/frontends => dvb-frontends}/cxd2820r_t.c  |    0
 .../{dvb/frontends => dvb-frontends}/cxd2820r_t2.c |    0
 .../{dvb/frontends => dvb-frontends}/dib0070.c     |    0
 .../{dvb/frontends => dvb-frontends}/dib0070.h     |    0
 .../{dvb/frontends => dvb-frontends}/dib0090.c     |    0
 .../{dvb/frontends => dvb-frontends}/dib0090.h     |    0
 .../{dvb/frontends => dvb-frontends}/dib3000.h     |    0
 .../{dvb/frontends => dvb-frontends}/dib3000mb.c   |    0
 .../frontends => dvb-frontends}/dib3000mb_priv.h   |    0
 .../{dvb/frontends => dvb-frontends}/dib3000mc.c   |    0
 .../{dvb/frontends => dvb-frontends}/dib3000mc.h   |    0
 .../{dvb/frontends => dvb-frontends}/dib7000m.c    |    0
 .../{dvb/frontends => dvb-frontends}/dib7000m.h    |    0
 .../{dvb/frontends => dvb-frontends}/dib7000p.c    |    0
 .../{dvb/frontends => dvb-frontends}/dib7000p.h    |    0
 .../{dvb/frontends => dvb-frontends}/dib8000.c     |    0
 .../{dvb/frontends => dvb-frontends}/dib8000.h     |    0
 .../{dvb/frontends => dvb-frontends}/dib9000.c     |    0
 .../{dvb/frontends => dvb-frontends}/dib9000.h     |    0
 .../frontends => dvb-frontends}/dibx000_common.c   |    0
 .../frontends => dvb-frontends}/dibx000_common.h   |    0
 .../media/{dvb/frontends => dvb-frontends}/drxd.h  |    0
 .../{dvb/frontends => dvb-frontends}/drxd_firm.c   |    0
 .../{dvb/frontends => dvb-frontends}/drxd_firm.h   |    0
 .../{dvb/frontends => dvb-frontends}/drxd_hard.c   |    0
 .../frontends => dvb-frontends}/drxd_map_firm.h    |    0
 .../media/{dvb/frontends => dvb-frontends}/drxk.h  |    0
 .../{dvb/frontends => dvb-frontends}/drxk_hard.c   |    0
 .../{dvb/frontends => dvb-frontends}/drxk_hard.h   |    0
 .../{dvb/frontends => dvb-frontends}/drxk_map.h    |    0
 .../{dvb/frontends => dvb-frontends}/ds3000.c      |    0
 .../{dvb/frontends => dvb-frontends}/ds3000.h      |    0
 .../{dvb/frontends => dvb-frontends}/dvb-pll.c     |    0
 .../{dvb/frontends => dvb-frontends}/dvb-pll.h     |    0
 .../frontends => dvb-frontends}/dvb_dummy_fe.c     |    0
 .../frontends => dvb-frontends}/dvb_dummy_fe.h     |    0
 .../media/{dvb/frontends => dvb-frontends}/ec100.c |    0
 .../media/{dvb/frontends => dvb-frontends}/ec100.h |    0
 .../{dvb/frontends => dvb-frontends}/ec100_priv.h  |    0
 .../{dvb/frontends => dvb-frontends}/eds1547.h     |    0
 .../{dvb/frontends => dvb-frontends}/hd29l2.c      |    0
 .../{dvb/frontends => dvb-frontends}/hd29l2.h      |    0
 .../{dvb/frontends => dvb-frontends}/hd29l2_priv.h |    0
 .../{dvb/frontends => dvb-frontends}/isl6405.c     |    0
 .../{dvb/frontends => dvb-frontends}/isl6405.h     |    0
 .../{dvb/frontends => dvb-frontends}/isl6421.c     |    0
 .../{dvb/frontends => dvb-frontends}/isl6421.h     |    0
 .../{dvb/frontends => dvb-frontends}/isl6423.c     |    0
 .../{dvb/frontends => dvb-frontends}/isl6423.h     |    0
 .../frontends => dvb-frontends}/it913x-fe-priv.h   |    0
 .../{dvb/frontends => dvb-frontends}/it913x-fe.c   |    0
 .../{dvb/frontends => dvb-frontends}/it913x-fe.h   |    0
 .../{dvb/frontends => dvb-frontends}/itd1000.c     |    0
 .../{dvb/frontends => dvb-frontends}/itd1000.h     |    0
 .../frontends => dvb-frontends}/itd1000_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/ix2505v.c     |    0
 .../{dvb/frontends => dvb-frontends}/ix2505v.h     |    0
 .../{dvb/frontends => dvb-frontends}/l64781.c      |    0
 .../{dvb/frontends => dvb-frontends}/l64781.h      |    0
 .../{dvb/frontends => dvb-frontends}/lg2160.c      |    0
 .../{dvb/frontends => dvb-frontends}/lg2160.h      |    0
 .../{dvb/frontends => dvb-frontends}/lgdt3305.c    |    0
 .../{dvb/frontends => dvb-frontends}/lgdt3305.h    |    0
 .../{dvb/frontends => dvb-frontends}/lgdt330x.c    |    0
 .../{dvb/frontends => dvb-frontends}/lgdt330x.h    |    0
 .../frontends => dvb-frontends}/lgdt330x_priv.h    |    0
 .../{dvb/frontends => dvb-frontends}/lgs8gl5.c     |    0
 .../{dvb/frontends => dvb-frontends}/lgs8gl5.h     |    0
 .../{dvb/frontends => dvb-frontends}/lgs8gxx.c     |    0
 .../{dvb/frontends => dvb-frontends}/lgs8gxx.h     |    0
 .../frontends => dvb-frontends}/lgs8gxx_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/lnbh24.h      |    0
 .../{dvb/frontends => dvb-frontends}/lnbp21.c      |    0
 .../{dvb/frontends => dvb-frontends}/lnbp21.h      |    0
 .../{dvb/frontends => dvb-frontends}/lnbp22.c      |    0
 .../{dvb/frontends => dvb-frontends}/lnbp22.h      |    0
 .../{dvb/frontends => dvb-frontends}/m88rs2000.c   |    0
 .../{dvb/frontends => dvb-frontends}/m88rs2000.h   |    0
 .../{dvb/frontends => dvb-frontends}/mb86a16.c     |    0
 .../{dvb/frontends => dvb-frontends}/mb86a16.h     |    0
 .../frontends => dvb-frontends}/mb86a16_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/mb86a20s.c    |    0
 .../{dvb/frontends => dvb-frontends}/mb86a20s.h    |    0
 .../media/{dvb/frontends => dvb-frontends}/mt312.c |    0
 .../media/{dvb/frontends => dvb-frontends}/mt312.h |    0
 .../{dvb/frontends => dvb-frontends}/mt312_priv.h  |    0
 .../media/{dvb/frontends => dvb-frontends}/mt352.c |    0
 .../media/{dvb/frontends => dvb-frontends}/mt352.h |    0
 .../{dvb/frontends => dvb-frontends}/mt352_priv.h  |    0
 .../{dvb/frontends => dvb-frontends}/nxt200x.c     |    0
 .../{dvb/frontends => dvb-frontends}/nxt200x.h     |    0
 .../{dvb/frontends => dvb-frontends}/nxt6000.c     |    0
 .../{dvb/frontends => dvb-frontends}/nxt6000.h     |    0
 .../frontends => dvb-frontends}/nxt6000_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/or51132.c     |    0
 .../{dvb/frontends => dvb-frontends}/or51132.h     |    0
 .../{dvb/frontends => dvb-frontends}/or51211.c     |    0
 .../{dvb/frontends => dvb-frontends}/or51211.h     |    0
 .../{dvb/frontends => dvb-frontends}/rtl2830.c     |    0
 .../{dvb/frontends => dvb-frontends}/rtl2830.h     |    0
 .../frontends => dvb-frontends}/rtl2830_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1409.c     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1409.h     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1411.c     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1411.h     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1420.c     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1420.h     |    0
 .../frontends => dvb-frontends}/s5h1420_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1432.c     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1432.h     |    0
 .../media/{dvb/frontends => dvb-frontends}/s921.c  |    0
 .../media/{dvb/frontends => dvb-frontends}/s921.h  |    0
 .../{dvb/frontends => dvb-frontends}/si21xx.c      |    0
 .../{dvb/frontends => dvb-frontends}/si21xx.h      |    0
 .../{dvb/frontends => dvb-frontends}/sp8870.c      |    0
 .../{dvb/frontends => dvb-frontends}/sp8870.h      |    0
 .../{dvb/frontends => dvb-frontends}/sp887x.c      |    0
 .../{dvb/frontends => dvb-frontends}/sp887x.h      |    0
 .../frontends => dvb-frontends}/stb0899_algo.c     |    0
 .../{dvb/frontends => dvb-frontends}/stb0899_cfg.h |    0
 .../{dvb/frontends => dvb-frontends}/stb0899_drv.c |    0
 .../{dvb/frontends => dvb-frontends}/stb0899_drv.h |    0
 .../frontends => dvb-frontends}/stb0899_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/stb0899_reg.h |    0
 .../{dvb/frontends => dvb-frontends}/stb6000.c     |    0
 .../{dvb/frontends => dvb-frontends}/stb6000.h     |    0
 .../{dvb/frontends => dvb-frontends}/stb6100.c     |    0
 .../{dvb/frontends => dvb-frontends}/stb6100.h     |    0
 .../{dvb/frontends => dvb-frontends}/stb6100_cfg.h |    0
 .../frontends => dvb-frontends}/stb6100_proc.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv0288.c     |    0
 .../{dvb/frontends => dvb-frontends}/stv0288.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv0297.c     |    0
 .../{dvb/frontends => dvb-frontends}/stv0297.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv0299.c     |    0
 .../{dvb/frontends => dvb-frontends}/stv0299.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv0367.c     |    0
 .../{dvb/frontends => dvb-frontends}/stv0367.h     |    0
 .../frontends => dvb-frontends}/stv0367_priv.h     |    0
 .../frontends => dvb-frontends}/stv0367_regs.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv0900.h     |    0
 .../frontends => dvb-frontends}/stv0900_core.c     |    0
 .../frontends => dvb-frontends}/stv0900_init.h     |    0
 .../frontends => dvb-frontends}/stv0900_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv0900_reg.h |    0
 .../{dvb/frontends => dvb-frontends}/stv0900_sw.c  |    0
 .../{dvb/frontends => dvb-frontends}/stv090x.c     |    0
 .../{dvb/frontends => dvb-frontends}/stv090x.h     |    0
 .../frontends => dvb-frontends}/stv090x_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv090x_reg.h |    0
 .../{dvb/frontends => dvb-frontends}/stv6110.c     |    0
 .../{dvb/frontends => dvb-frontends}/stv6110.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv6110x.c    |    0
 .../{dvb/frontends => dvb-frontends}/stv6110x.h    |    0
 .../frontends => dvb-frontends}/stv6110x_priv.h    |    0
 .../frontends => dvb-frontends}/stv6110x_reg.h     |    0
 .../{dvb/frontends => dvb-frontends}/tda10021.c    |    0
 .../{dvb/frontends => dvb-frontends}/tda10023.c    |    0
 .../{dvb/frontends => dvb-frontends}/tda1002x.h    |    0
 .../{dvb/frontends => dvb-frontends}/tda10048.c    |    0
 .../{dvb/frontends => dvb-frontends}/tda10048.h    |    0
 .../{dvb/frontends => dvb-frontends}/tda1004x.c    |    0
 .../{dvb/frontends => dvb-frontends}/tda1004x.h    |    0
 .../{dvb/frontends => dvb-frontends}/tda10071.c    |    0
 .../{dvb/frontends => dvb-frontends}/tda10071.h    |    0
 .../frontends => dvb-frontends}/tda10071_priv.h    |    0
 .../{dvb/frontends => dvb-frontends}/tda10086.c    |    0
 .../{dvb/frontends => dvb-frontends}/tda10086.h    |    0
 .../frontends => dvb-frontends}/tda18271c2dd.c     |    0
 .../frontends => dvb-frontends}/tda18271c2dd.h     |    0
 .../tda18271c2dd_maps.h                            |    0
 .../{dvb/frontends => dvb-frontends}/tda665x.c     |    0
 .../{dvb/frontends => dvb-frontends}/tda665x.h     |    0
 .../{dvb/frontends => dvb-frontends}/tda8083.c     |    0
 .../{dvb/frontends => dvb-frontends}/tda8083.h     |    0
 .../{dvb/frontends => dvb-frontends}/tda8261.c     |    0
 .../{dvb/frontends => dvb-frontends}/tda8261.h     |    0
 .../{dvb/frontends => dvb-frontends}/tda8261_cfg.h |    0
 .../{dvb/frontends => dvb-frontends}/tda826x.c     |    0
 .../{dvb/frontends => dvb-frontends}/tda826x.h     |    0
 .../media/{dvb/frontends => dvb-frontends}/tdhd1.h |    0
 .../{dvb/frontends => dvb-frontends}/tua6100.c     |    0
 .../{dvb/frontends => dvb-frontends}/tua6100.h     |    0
 .../{dvb/frontends => dvb-frontends}/ves1820.c     |    0
 .../{dvb/frontends => dvb-frontends}/ves1820.h     |    0
 .../{dvb/frontends => dvb-frontends}/ves1x93.c     |    0
 .../{dvb/frontends => dvb-frontends}/ves1x93.h     |    0
 .../{dvb/frontends => dvb-frontends}/z0194a.h      |    0
 .../{dvb/frontends => dvb-frontends}/zl10036.c     |    0
 .../{dvb/frontends => dvb-frontends}/zl10036.h     |    0
 .../{dvb/frontends => dvb-frontends}/zl10039.c     |    0
 .../{dvb/frontends => dvb-frontends}/zl10039.h     |    0
 .../{dvb/frontends => dvb-frontends}/zl10353.c     |    0
 .../{dvb/frontends => dvb-frontends}/zl10353.h     |    0
 .../frontends => dvb-frontends}/zl10353_priv.h     |    0
 drivers/media/dvb/Kconfig                          |   91 --------------------
 drivers/media/dvb/Makefile                         |   21 -----
 drivers/media/dvb/b2c2/Makefile                    |   16 ----
 drivers/media/dvb/bt8xx/Makefile                   |    6 --
 drivers/media/dvb/dm1105/Makefile                  |    3 -
 drivers/media/dvb/pluto2/Makefile                  |    3 -
 drivers/media/dvb/siano/Kconfig                    |   34 --------
 drivers/media/dvb/ttusb-budget/Makefile            |    3 -
 drivers/media/{dvb => }/firewire/Kconfig           |    0
 drivers/media/{dvb => }/firewire/Makefile          |    2 +-
 drivers/media/{dvb => }/firewire/firedtv-avc.c     |    0
 drivers/media/{dvb => }/firewire/firedtv-ci.c      |    0
 drivers/media/{dvb => }/firewire/firedtv-dvb.c     |    0
 drivers/media/{dvb => }/firewire/firedtv-fe.c      |    0
 drivers/media/{dvb => }/firewire/firedtv-fw.c      |    0
 drivers/media/{dvb => }/firewire/firedtv-rc.c      |    0
 drivers/media/{dvb => }/firewire/firedtv.h         |    0
 drivers/media/mmc/Kconfig                          |    1 +
 drivers/media/mmc/Makefile                         |    1 +
 drivers/media/mmc/siano/Kconfig                    |   10 +++
 drivers/media/mmc/siano/Makefile                   |    6 ++
 drivers/media/{dvb => mmc}/siano/smssdio.c         |    0
 drivers/media/pci/Kconfig                          |   41 +++++++++
 drivers/media/pci/Makefile                         |   14 +++
 drivers/media/pci/b2c2/Kconfig                     |    6 ++
 drivers/media/pci/b2c2/Makefile                    |   11 +++
 drivers/media/{dvb => pci}/b2c2/flexcop-dma.c      |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-pci.c      |    0
 drivers/media/{dvb => pci}/bt8xx/Kconfig           |    0
 drivers/media/pci/bt8xx/Makefile                   |    6 ++
 drivers/media/{dvb => pci}/bt8xx/bt878.c           |    0
 drivers/media/{dvb => pci}/bt8xx/bt878.h           |    0
 drivers/media/{dvb => pci}/bt8xx/dst.c             |    0
 drivers/media/{dvb => pci}/bt8xx/dst_ca.c          |    0
 drivers/media/{dvb => pci}/bt8xx/dst_ca.h          |    0
 drivers/media/{dvb => pci}/bt8xx/dst_common.h      |    0
 drivers/media/{dvb => pci}/bt8xx/dst_priv.h        |    0
 drivers/media/{dvb => pci}/bt8xx/dvb-bt8xx.c       |    0
 drivers/media/{dvb => pci}/bt8xx/dvb-bt8xx.h       |    0
 drivers/media/{dvb => pci}/ddbridge/Kconfig        |    0
 drivers/media/{dvb => pci}/ddbridge/Makefile       |    6 +-
 .../media/{dvb => pci}/ddbridge/ddbridge-core.c    |    0
 .../media/{dvb => pci}/ddbridge/ddbridge-regs.h    |    0
 drivers/media/{dvb => pci}/ddbridge/ddbridge.h     |    0
 drivers/media/{dvb => pci}/dm1105/Kconfig          |    0
 drivers/media/pci/dm1105/Makefile                  |    3 +
 drivers/media/{dvb => pci}/dm1105/dm1105.c         |    0
 drivers/media/{dvb => pci}/mantis/Kconfig          |    0
 drivers/media/{dvb => pci}/mantis/Makefile         |    2 +-
 drivers/media/{dvb => pci}/mantis/hopper_cards.c   |    0
 drivers/media/{dvb => pci}/mantis/hopper_vp3028.c  |    0
 drivers/media/{dvb => pci}/mantis/hopper_vp3028.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_ca.c      |    0
 drivers/media/{dvb => pci}/mantis/mantis_ca.h      |    0
 drivers/media/{dvb => pci}/mantis/mantis_cards.c   |    0
 drivers/media/{dvb => pci}/mantis/mantis_common.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_core.c    |    0
 drivers/media/{dvb => pci}/mantis/mantis_core.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_dma.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_dma.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_dvb.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_dvb.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_evm.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_hif.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_hif.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_i2c.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_i2c.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_input.c   |    0
 drivers/media/{dvb => pci}/mantis/mantis_ioc.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_ioc.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_link.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_pci.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_pci.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_pcmcia.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_reg.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_uart.c    |    0
 drivers/media/{dvb => pci}/mantis/mantis_uart.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1033.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1033.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1034.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1034.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1041.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1041.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp2033.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp2033.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp2040.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp2040.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp3028.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp3028.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp3030.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp3030.h  |    0
 drivers/media/{dvb => pci}/ngene/Kconfig           |    0
 drivers/media/{dvb => pci}/ngene/Makefile          |    6 +-
 drivers/media/{dvb => pci}/ngene/ngene-cards.c     |    0
 drivers/media/{dvb => pci}/ngene/ngene-core.c      |    0
 drivers/media/{dvb => pci}/ngene/ngene-dvb.c       |    0
 drivers/media/{dvb => pci}/ngene/ngene-i2c.c       |    0
 drivers/media/{dvb => pci}/ngene/ngene.h           |    0
 drivers/media/{dvb => pci}/pluto2/Kconfig          |    0
 drivers/media/pci/pluto2/Makefile                  |    3 +
 drivers/media/{dvb => pci}/pluto2/pluto2.c         |    0
 drivers/media/{dvb => pci}/pt1/Kconfig             |    0
 drivers/media/{dvb => pci}/pt1/Makefile            |    2 +-
 drivers/media/{dvb => pci}/pt1/pt1.c               |    0
 drivers/media/{dvb => pci}/pt1/va1j5jf8007s.c      |    0
 drivers/media/{dvb => pci}/pt1/va1j5jf8007s.h      |    0
 drivers/media/{dvb => pci}/pt1/va1j5jf8007t.c      |    0
 drivers/media/{dvb => pci}/pt1/va1j5jf8007t.h      |    0
 drivers/media/{dvb => pci}/ttpci/Kconfig           |    0
 drivers/media/{dvb => pci}/ttpci/Makefile          |    4 +-
 drivers/media/{dvb => pci}/ttpci/av7110.c          |    0
 drivers/media/{dvb => pci}/ttpci/av7110.h          |    0
 drivers/media/{dvb => pci}/ttpci/av7110_av.c       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_av.h       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ca.c       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ca.h       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_hw.c       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_hw.h       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ipack.c    |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ipack.h    |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ir.c       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_v4l.c      |    0
 drivers/media/{dvb => pci}/ttpci/budget-av.c       |    0
 drivers/media/{dvb => pci}/ttpci/budget-ci.c       |    0
 drivers/media/{dvb => pci}/ttpci/budget-core.c     |    0
 drivers/media/{dvb => pci}/ttpci/budget-patch.c    |    0
 drivers/media/{dvb => pci}/ttpci/budget.c          |    0
 drivers/media/{dvb => pci}/ttpci/budget.h          |    0
 drivers/media/{dvb => pci}/ttpci/ttpci-eeprom.c    |    0
 drivers/media/{dvb => pci}/ttpci/ttpci-eeprom.h    |    0
 drivers/media/{common => }/tuners/Kconfig          |    0
 drivers/media/{common => }/tuners/Makefile         |    4 +-
 drivers/media/{common => }/tuners/fc0011.c         |    0
 drivers/media/{common => }/tuners/fc0011.h         |    0
 drivers/media/{common => }/tuners/fc0012-priv.h    |    0
 drivers/media/{common => }/tuners/fc0012.c         |    0
 drivers/media/{common => }/tuners/fc0012.h         |    0
 drivers/media/{common => }/tuners/fc0013-priv.h    |    0
 drivers/media/{common => }/tuners/fc0013.c         |    0
 drivers/media/{common => }/tuners/fc0013.h         |    0
 drivers/media/{common => }/tuners/fc001x-common.h  |    0
 drivers/media/{common => }/tuners/max2165.c        |    0
 drivers/media/{common => }/tuners/max2165.h        |    0
 drivers/media/{common => }/tuners/max2165_priv.h   |    0
 drivers/media/{common => }/tuners/mc44s803.c       |    0
 drivers/media/{common => }/tuners/mc44s803.h       |    0
 drivers/media/{common => }/tuners/mc44s803_priv.h  |    0
 drivers/media/{common => }/tuners/mt2060.c         |    0
 drivers/media/{common => }/tuners/mt2060.h         |    0
 drivers/media/{common => }/tuners/mt2060_priv.h    |    0
 drivers/media/{common => }/tuners/mt2063.c         |    0
 drivers/media/{common => }/tuners/mt2063.h         |    0
 drivers/media/{common => }/tuners/mt20xx.c         |    0
 drivers/media/{common => }/tuners/mt20xx.h         |    0
 drivers/media/{common => }/tuners/mt2131.c         |    0
 drivers/media/{common => }/tuners/mt2131.h         |    0
 drivers/media/{common => }/tuners/mt2131_priv.h    |    0
 drivers/media/{common => }/tuners/mt2266.c         |    0
 drivers/media/{common => }/tuners/mt2266.h         |    0
 drivers/media/{common => }/tuners/mxl5005s.c       |    0
 drivers/media/{common => }/tuners/mxl5005s.h       |    0
 drivers/media/{common => }/tuners/mxl5007t.c       |    0
 drivers/media/{common => }/tuners/mxl5007t.h       |    0
 drivers/media/{common => }/tuners/qt1010.c         |    0
 drivers/media/{common => }/tuners/qt1010.h         |    0
 drivers/media/{common => }/tuners/qt1010_priv.h    |    0
 drivers/media/{common => }/tuners/tda18212.c       |    0
 drivers/media/{common => }/tuners/tda18212.h       |    0
 drivers/media/{common => }/tuners/tda18218.c       |    0
 drivers/media/{common => }/tuners/tda18218.h       |    0
 drivers/media/{common => }/tuners/tda18218_priv.h  |    0
 .../media/{common => }/tuners/tda18271-common.c    |    0
 drivers/media/{common => }/tuners/tda18271-fe.c    |    0
 drivers/media/{common => }/tuners/tda18271-maps.c  |    0
 drivers/media/{common => }/tuners/tda18271-priv.h  |    0
 drivers/media/{common => }/tuners/tda18271.h       |    0
 drivers/media/{common => }/tuners/tda827x.c        |    0
 drivers/media/{common => }/tuners/tda827x.h        |    0
 drivers/media/{common => }/tuners/tda8290.c        |    0
 drivers/media/{common => }/tuners/tda8290.h        |    0
 drivers/media/{common => }/tuners/tda9887.c        |    0
 drivers/media/{common => }/tuners/tda9887.h        |    0
 drivers/media/{common => }/tuners/tea5761.c        |    0
 drivers/media/{common => }/tuners/tea5761.h        |    0
 drivers/media/{common => }/tuners/tea5767.c        |    0
 drivers/media/{common => }/tuners/tea5767.h        |    0
 drivers/media/{common => }/tuners/tua9001.c        |    0
 drivers/media/{common => }/tuners/tua9001.h        |    0
 drivers/media/{common => }/tuners/tua9001_priv.h   |    0
 drivers/media/{common => }/tuners/tuner-i2c.h      |    0
 drivers/media/{common => }/tuners/tuner-simple.c   |    0
 drivers/media/{common => }/tuners/tuner-simple.h   |    0
 drivers/media/{common => }/tuners/tuner-types.c    |    0
 .../media/{common => }/tuners/tuner-xc2028-types.h |    0
 drivers/media/{common => }/tuners/tuner-xc2028.c   |    0
 drivers/media/{common => }/tuners/tuner-xc2028.h   |    0
 drivers/media/{common => }/tuners/xc4000.c         |    0
 drivers/media/{common => }/tuners/xc4000.h         |    0
 drivers/media/{common => }/tuners/xc5000.c         |    0
 drivers/media/{common => }/tuners/xc5000.h         |    0
 drivers/media/usb/Kconfig                          |   18 ++++
 drivers/media/usb/Makefile                         |    6 ++
 drivers/media/usb/b2c2/Kconfig                     |    6 ++
 drivers/media/usb/b2c2/Makefile                    |    7 ++
 drivers/media/{dvb => usb}/b2c2/flexcop-usb.c      |    0
 drivers/media/{dvb => usb}/b2c2/flexcop-usb.h      |    0
 drivers/media/{dvb => usb}/dvb-usb/Kconfig         |    0
 drivers/media/{dvb => usb}/dvb-usb/Makefile        |    8 +-
 drivers/media/{dvb => usb}/dvb-usb/a800.c          |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005-fe.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005-remote.c |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005-script.h |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/af9015.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/af9015.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/af9035.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/af9035.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/anysee.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/anysee.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/au6610.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/au6610.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/az6007.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/az6027.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/az6027.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/ce6230.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/ce6230.h        |    0
 .../media/{dvb => usb}/dvb-usb/cinergyT2-core.c    |    0
 drivers/media/{dvb => usb}/dvb-usb/cinergyT2-fe.c  |    0
 drivers/media/{dvb => usb}/dvb-usb/cinergyT2.h     |    0
 drivers/media/{dvb => usb}/dvb-usb/cxusb.c         |    0
 drivers/media/{dvb => usb}/dvb-usb/cxusb.h         |    0
 drivers/media/{dvb => usb}/dvb-usb/dib0700.h       |    0
 drivers/media/{dvb => usb}/dvb-usb/dib0700_core.c  |    0
 .../media/{dvb => usb}/dvb-usb/dib0700_devices.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/dib07x0.h       |    0
 drivers/media/{dvb => usb}/dvb-usb/dibusb-common.c |    0
 drivers/media/{dvb => usb}/dvb-usb/dibusb-mb.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/dibusb-mc.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/dibusb.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/digitv.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/digitv.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/dtt200u-fe.c    |    0
 drivers/media/{dvb => usb}/dvb-usb/dtt200u.c       |    0
 drivers/media/{dvb => usb}/dvb-usb/dtt200u.h       |    0
 drivers/media/{dvb => usb}/dvb-usb/dtv5100.c       |    0
 drivers/media/{dvb => usb}/dvb-usb/dtv5100.h       |    0
 .../media/{dvb => usb}/dvb-usb/dvb-usb-common.h    |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-dvb.c   |    0
 .../media/{dvb => usb}/dvb-usb/dvb-usb-firmware.c  |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-i2c.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-ids.h   |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-init.c  |    0
 .../media/{dvb => usb}/dvb-usb/dvb-usb-remote.c    |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-urb.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb.h       |    0
 drivers/media/{dvb => usb}/dvb-usb/dw2102.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/dw2102.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/ec168.c         |    0
 drivers/media/{dvb => usb}/dvb-usb/ec168.h         |    0
 drivers/media/{dvb => usb}/dvb-usb/friio-fe.c      |    0
 drivers/media/{dvb => usb}/dvb-usb/friio.c         |    0
 drivers/media/{dvb => usb}/dvb-usb/friio.h         |    0
 drivers/media/{dvb => usb}/dvb-usb/gl861.c         |    0
 drivers/media/{dvb => usb}/dvb-usb/gl861.h         |    0
 drivers/media/{dvb => usb}/dvb-usb/gp8psk-fe.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/gp8psk.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/gp8psk.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/it913x.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/lmedm04.c       |    0
 drivers/media/{dvb => usb}/dvb-usb/lmedm04.h       |    0
 drivers/media/{dvb => usb}/dvb-usb/m920x.c         |    0
 drivers/media/{dvb => usb}/dvb-usb/m920x.h         |    0
 .../media/{dvb => usb}/dvb-usb/mxl111sf-demod.c    |    0
 .../media/{dvb => usb}/dvb-usb/mxl111sf-demod.h    |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-gpio.c |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-gpio.h |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-i2c.c  |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-i2c.h  |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-phy.c  |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-phy.h  |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-reg.h  |    0
 .../media/{dvb => usb}/dvb-usb/mxl111sf-tuner.c    |    0
 .../media/{dvb => usb}/dvb-usb/mxl111sf-tuner.h    |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf.c      |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf.h      |    0
 drivers/media/{dvb => usb}/dvb-usb/nova-t-usb2.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/opera1.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/pctv452e.c      |    0
 drivers/media/{dvb => usb}/dvb-usb/rtl28xxu.c      |    0
 drivers/media/{dvb => usb}/dvb-usb/rtl28xxu.h      |    0
 .../media/{dvb => usb}/dvb-usb/technisat-usb2.c    |    0
 drivers/media/{dvb => usb}/dvb-usb/ttusb2.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/ttusb2.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/umt-010.c       |    0
 drivers/media/{dvb => usb}/dvb-usb/usb-urb.c       |    0
 drivers/media/{dvb => usb}/dvb-usb/vp702x-fe.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/vp702x.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/vp702x.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/vp7045-fe.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/vp7045.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/vp7045.h        |    0
 drivers/media/usb/siano/Kconfig                    |   10 +++
 drivers/media/usb/siano/Makefile                   |    6 ++
 drivers/media/{dvb => usb}/siano/smsusb.c          |    0
 drivers/media/{dvb => usb}/ttusb-budget/Kconfig    |    0
 drivers/media/usb/ttusb-budget/Makefile            |    3 +
 .../{dvb => usb}/ttusb-budget/dvb-ttusb-budget.c   |    0
 drivers/media/{dvb => usb}/ttusb-dec/Kconfig       |    0
 drivers/media/{dvb => usb}/ttusb-dec/Makefile      |    2 +-
 drivers/media/{dvb => usb}/ttusb-dec/ttusb_dec.c   |    0
 drivers/media/{dvb => usb}/ttusb-dec/ttusbdecfe.c  |    0
 drivers/media/{dvb => usb}/ttusb-dec/ttusbdecfe.h  |    0
 drivers/media/v4l2-core/Kconfig                    |   60 +++++++++++++
 drivers/media/v4l2-core/Makefile                   |   35 ++++++++
 drivers/media/{video => v4l2-core}/tuner-core.c    |    0
 drivers/media/{video => v4l2-core}/v4l2-common.c   |    0
 .../{video => v4l2-core}/v4l2-compat-ioctl32.c     |    0
 drivers/media/{video => v4l2-core}/v4l2-ctrls.c    |    0
 drivers/media/{video => v4l2-core}/v4l2-dev.c      |    0
 drivers/media/{video => v4l2-core}/v4l2-device.c   |    0
 drivers/media/{video => v4l2-core}/v4l2-event.c    |    0
 drivers/media/{video => v4l2-core}/v4l2-fh.c       |    0
 .../media/{video => v4l2-core}/v4l2-int-device.c   |    0
 drivers/media/{video => v4l2-core}/v4l2-ioctl.c    |    0
 drivers/media/{video => v4l2-core}/v4l2-mem2mem.c  |    0
 drivers/media/{video => v4l2-core}/v4l2-subdev.c   |    0
 drivers/media/{video => v4l2-core}/videobuf-core.c |    0
 .../{video => v4l2-core}/videobuf-dma-contig.c     |    0
 .../media/{video => v4l2-core}/videobuf-dma-sg.c   |    0
 drivers/media/{video => v4l2-core}/videobuf-dvb.c  |    0
 .../media/{video => v4l2-core}/videobuf-vmalloc.c  |    0
 .../media/{video => v4l2-core}/videobuf2-core.c    |    0
 .../{video => v4l2-core}/videobuf2-dma-contig.c    |    0
 .../media/{video => v4l2-core}/videobuf2-dma-sg.c  |    0
 .../media/{video => v4l2-core}/videobuf2-memops.c  |    0
 .../media/{video => v4l2-core}/videobuf2-vmalloc.c |    0
 drivers/media/video/Kconfig                        |   56 ------------
 drivers/media/video/Makefile                       |   33 +------
 drivers/media/video/au0828/Makefile                |    6 +-
 drivers/media/video/bt8xx/Makefile                 |    4 +-
 drivers/media/video/cx18/Makefile                  |    6 +-
 drivers/media/video/cx231xx/Makefile               |    8 +-
 drivers/media/video/cx23885/Makefile               |    6 +-
 drivers/media/video/cx25821/Makefile               |    6 +-
 drivers/media/video/cx88/Makefile                  |    6 +-
 drivers/media/video/em28xx/Makefile                |    6 +-
 drivers/media/video/ivtv/Makefile                  |    6 +-
 drivers/media/video/pvrusb2/Makefile               |    6 +-
 drivers/media/video/saa7134/Makefile               |    6 +-
 drivers/media/video/saa7164/Makefile               |    6 +-
 drivers/media/video/tlg2300/Makefile               |    6 +-
 drivers/media/video/tm6000/Makefile                |    6 +-
 drivers/media/video/usbvision/Makefile             |    2 +-
 drivers/staging/media/as102/Makefile               |    2 +-
 drivers/staging/media/cxd2099/Makefile             |    6 +-
 drivers/staging/media/go7007/Makefile              |    6 +-
 653 files changed, 425 insertions(+), 379 deletions(-)
 rename drivers/media/{dvb => common}/b2c2/Kconfig (64%)
 create mode 100644 drivers/media/common/b2c2/Makefile
 rename drivers/media/{dvb => common}/b2c2/flexcop-common.h (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-eeprom.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-fe-tuner.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-hw-filter.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-i2c.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-misc.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-reg.h (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-sram.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop.h (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop_ibi_value_be.h (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop_ibi_value_le.h (100%)
 create mode 100644 drivers/media/common/saa7146/Kconfig
 create mode 100644 drivers/media/common/saa7146/Makefile
 rename drivers/media/common/{ => saa7146}/saa7146_core.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_fops.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_hlp.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_i2c.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_vbi.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_video.c (100%)
 create mode 100644 drivers/media/common/siano/Kconfig
 rename drivers/media/{dvb => common}/siano/Makefile (57%)
 rename drivers/media/{dvb => common}/siano/sms-cards.c (100%)
 rename drivers/media/{dvb => common}/siano/sms-cards.h (100%)
 rename drivers/media/{dvb => common}/siano/smscoreapi.c (100%)
 rename drivers/media/{dvb => common}/siano/smscoreapi.h (100%)
 rename drivers/media/{dvb => common}/siano/smsdvb.c (100%)
 rename drivers/media/{dvb => common}/siano/smsendian.c (100%)
 rename drivers/media/{dvb => common}/siano/smsendian.h (100%)
 rename drivers/media/{dvb => common}/siano/smsir.c (100%)
 rename drivers/media/{dvb => common}/siano/smsir.h (100%)
 create mode 100644 drivers/media/dvb-core/Kconfig
 rename drivers/media/{dvb => }/dvb-core/Makefile (100%)
 rename drivers/media/{dvb => }/dvb-core/demux.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dmxdev.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dmxdev.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_ca_en50221.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_ca_en50221.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_demux.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_demux.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_filter.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_filter.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_frontend.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_frontend.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_math.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_math.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_net.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_net.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_ringbuffer.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_ringbuffer.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvbdev.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvbdev.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/Kconfig (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/Makefile (97%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/a8293.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/a8293.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/af9013.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/af9013.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/af9013_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/af9033.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/af9033.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/af9033_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/atbm8830.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/atbm8830.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/atbm8830_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/au8522.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/au8522_common.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/au8522_decoder.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/au8522_dig.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/au8522_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/bcm3510.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/bcm3510.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/bcm3510_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/bsbe1-d01a.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/bsbe1.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/bsru6.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx22700.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx22700.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx22702.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx22702.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24110.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24110.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24113.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24113.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24116.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24116.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24123.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24123.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_c.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_core.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_t.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_t2.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib0070.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib0070.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib0090.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib0090.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib3000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib3000mb.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib3000mb_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib3000mc.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib3000mc.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib7000m.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib7000m.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib7000p.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib7000p.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib8000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib8000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib9000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib9000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dibx000_common.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dibx000_common.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxd.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxd_firm.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxd_firm.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxd_hard.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxd_map_firm.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxk.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxk_hard.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxk_hard.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxk_map.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ds3000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ds3000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dvb-pll.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dvb-pll.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dvb_dummy_fe.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dvb_dummy_fe.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ec100.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ec100.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ec100_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/eds1547.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/hd29l2.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/hd29l2.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/hd29l2_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/isl6405.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/isl6405.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/isl6421.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/isl6421.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/isl6423.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/isl6423.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/it913x-fe-priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/it913x-fe.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/it913x-fe.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/itd1000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/itd1000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/itd1000_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ix2505v.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ix2505v.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/l64781.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/l64781.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lg2160.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lg2160.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgdt3305.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgdt3305.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgdt330x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgdt330x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgdt330x_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgs8gl5.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgs8gl5.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgs8gxx.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgs8gxx.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgs8gxx_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lnbh24.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lnbp21.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lnbp21.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lnbp22.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lnbp22.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/m88rs2000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/m88rs2000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mb86a16.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mb86a16.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mb86a16_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mb86a20s.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mb86a20s.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mt312.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mt312.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mt312_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mt352.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mt352.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mt352_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/nxt200x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/nxt200x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/nxt6000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/nxt6000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/nxt6000_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/or51132.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/or51132.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/or51211.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/or51211.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/rtl2830.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/rtl2830.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/rtl2830_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1409.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1409.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1411.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1411.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1420.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1420.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1420_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1432.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1432.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s921.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s921.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/si21xx.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/si21xx.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/sp8870.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/sp8870.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/sp887x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/sp887x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb0899_algo.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb0899_cfg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb0899_drv.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb0899_drv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb0899_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb0899_reg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb6000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb6000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb6100.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb6100.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb6100_cfg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb6100_proc.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0288.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0288.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0297.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0297.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0299.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0299.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0367.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0367.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0367_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0367_regs.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0900.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0900_core.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0900_init.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0900_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0900_reg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0900_sw.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv090x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv090x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv090x_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv090x_reg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv6110.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv6110.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv6110x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv6110x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv6110x_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv6110x_reg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10021.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10023.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda1002x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10048.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10048.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda1004x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda1004x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10071.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10071.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10071_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10086.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10086.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda18271c2dd.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda18271c2dd.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda18271c2dd_maps.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda665x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda665x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda8083.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda8083.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda8261.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda8261.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda8261_cfg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda826x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda826x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tdhd1.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tua6100.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tua6100.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ves1820.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ves1820.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ves1x93.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ves1x93.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/z0194a.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10036.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10036.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10039.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10039.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10353.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10353.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10353_priv.h (100%)
 delete mode 100644 drivers/media/dvb/Kconfig
 delete mode 100644 drivers/media/dvb/Makefile
 delete mode 100644 drivers/media/dvb/b2c2/Makefile
 delete mode 100644 drivers/media/dvb/bt8xx/Makefile
 delete mode 100644 drivers/media/dvb/dm1105/Makefile
 delete mode 100644 drivers/media/dvb/pluto2/Makefile
 delete mode 100644 drivers/media/dvb/siano/Kconfig
 delete mode 100644 drivers/media/dvb/ttusb-budget/Makefile
 rename drivers/media/{dvb => }/firewire/Kconfig (100%)
 rename drivers/media/{dvb => }/firewire/Makefile (80%)
 rename drivers/media/{dvb => }/firewire/firedtv-avc.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-ci.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-dvb.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-fe.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-fw.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-rc.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv.h (100%)
 create mode 100644 drivers/media/mmc/Kconfig
 create mode 100644 drivers/media/mmc/Makefile
 create mode 100644 drivers/media/mmc/siano/Kconfig
 create mode 100644 drivers/media/mmc/siano/Makefile
 rename drivers/media/{dvb => mmc}/siano/smssdio.c (100%)
 create mode 100644 drivers/media/pci/Kconfig
 create mode 100644 drivers/media/pci/Makefile
 create mode 100644 drivers/media/pci/b2c2/Kconfig
 create mode 100644 drivers/media/pci/b2c2/Makefile
 rename drivers/media/{dvb => pci}/b2c2/flexcop-dma.c (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-pci.c (100%)
 rename drivers/media/{dvb => pci}/bt8xx/Kconfig (100%)
 create mode 100644 drivers/media/pci/bt8xx/Makefile
 rename drivers/media/{dvb => pci}/bt8xx/bt878.c (100%)
 rename drivers/media/{dvb => pci}/bt8xx/bt878.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst.c (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst_ca.c (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst_ca.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst_common.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst_priv.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dvb-bt8xx.c (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dvb-bt8xx.h (100%)
 rename drivers/media/{dvb => pci}/ddbridge/Kconfig (100%)
 rename drivers/media/{dvb => pci}/ddbridge/Makefile (61%)
 rename drivers/media/{dvb => pci}/ddbridge/ddbridge-core.c (100%)
 rename drivers/media/{dvb => pci}/ddbridge/ddbridge-regs.h (100%)
 rename drivers/media/{dvb => pci}/ddbridge/ddbridge.h (100%)
 rename drivers/media/{dvb => pci}/dm1105/Kconfig (100%)
 create mode 100644 drivers/media/pci/dm1105/Makefile
 rename drivers/media/{dvb => pci}/dm1105/dm1105.c (100%)
 rename drivers/media/{dvb => pci}/mantis/Kconfig (100%)
 rename drivers/media/{dvb => pci}/mantis/Makefile (88%)
 rename drivers/media/{dvb => pci}/mantis/hopper_cards.c (100%)
 rename drivers/media/{dvb => pci}/mantis/hopper_vp3028.c (100%)
 rename drivers/media/{dvb => pci}/mantis/hopper_vp3028.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_ca.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_ca.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_cards.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_common.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_core.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_core.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_dma.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_dma.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_dvb.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_dvb.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_evm.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_hif.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_hif.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_i2c.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_i2c.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_input.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_ioc.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_ioc.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_link.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_pci.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_pci.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_pcmcia.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_reg.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_uart.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_uart.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1033.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1033.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1034.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1034.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1041.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1041.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp2033.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp2033.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp2040.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp2040.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp3028.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp3028.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp3030.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp3030.h (100%)
 rename drivers/media/{dvb => pci}/ngene/Kconfig (100%)
 rename drivers/media/{dvb => pci}/ngene/Makefile (63%)
 rename drivers/media/{dvb => pci}/ngene/ngene-cards.c (100%)
 rename drivers/media/{dvb => pci}/ngene/ngene-core.c (100%)
 rename drivers/media/{dvb => pci}/ngene/ngene-dvb.c (100%)
 rename drivers/media/{dvb => pci}/ngene/ngene-i2c.c (100%)
 rename drivers/media/{dvb => pci}/ngene/ngene.h (100%)
 rename drivers/media/{dvb => pci}/pluto2/Kconfig (100%)
 create mode 100644 drivers/media/pci/pluto2/Makefile
 rename drivers/media/{dvb => pci}/pluto2/pluto2.c (100%)
 rename drivers/media/{dvb => pci}/pt1/Kconfig (100%)
 rename drivers/media/{dvb => pci}/pt1/Makefile (56%)
 rename drivers/media/{dvb => pci}/pt1/pt1.c (100%)
 rename drivers/media/{dvb => pci}/pt1/va1j5jf8007s.c (100%)
 rename drivers/media/{dvb => pci}/pt1/va1j5jf8007s.h (100%)
 rename drivers/media/{dvb => pci}/pt1/va1j5jf8007t.c (100%)
 rename drivers/media/{dvb => pci}/pt1/va1j5jf8007t.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/Kconfig (100%)
 rename drivers/media/{dvb => pci}/ttpci/Makefile (82%)
 rename drivers/media/{dvb => pci}/ttpci/av7110.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_av.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_av.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ca.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ca.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_hw.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_hw.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ipack.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ipack.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ir.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_v4l.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget-av.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget-ci.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget-core.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget-patch.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/ttpci-eeprom.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/ttpci-eeprom.h (100%)
 rename drivers/media/{common => }/tuners/Kconfig (100%)
 rename drivers/media/{common => }/tuners/Makefile (93%)
 rename drivers/media/{common => }/tuners/fc0011.c (100%)
 rename drivers/media/{common => }/tuners/fc0011.h (100%)
 rename drivers/media/{common => }/tuners/fc0012-priv.h (100%)
 rename drivers/media/{common => }/tuners/fc0012.c (100%)
 rename drivers/media/{common => }/tuners/fc0012.h (100%)
 rename drivers/media/{common => }/tuners/fc0013-priv.h (100%)
 rename drivers/media/{common => }/tuners/fc0013.c (100%)
 rename drivers/media/{common => }/tuners/fc0013.h (100%)
 rename drivers/media/{common => }/tuners/fc001x-common.h (100%)
 rename drivers/media/{common => }/tuners/max2165.c (100%)
 rename drivers/media/{common => }/tuners/max2165.h (100%)
 rename drivers/media/{common => }/tuners/max2165_priv.h (100%)
 rename drivers/media/{common => }/tuners/mc44s803.c (100%)
 rename drivers/media/{common => }/tuners/mc44s803.h (100%)
 rename drivers/media/{common => }/tuners/mc44s803_priv.h (100%)
 rename drivers/media/{common => }/tuners/mt2060.c (100%)
 rename drivers/media/{common => }/tuners/mt2060.h (100%)
 rename drivers/media/{common => }/tuners/mt2060_priv.h (100%)
 rename drivers/media/{common => }/tuners/mt2063.c (100%)
 rename drivers/media/{common => }/tuners/mt2063.h (100%)
 rename drivers/media/{common => }/tuners/mt20xx.c (100%)
 rename drivers/media/{common => }/tuners/mt20xx.h (100%)
 rename drivers/media/{common => }/tuners/mt2131.c (100%)
 rename drivers/media/{common => }/tuners/mt2131.h (100%)
 rename drivers/media/{common => }/tuners/mt2131_priv.h (100%)
 rename drivers/media/{common => }/tuners/mt2266.c (100%)
 rename drivers/media/{common => }/tuners/mt2266.h (100%)
 rename drivers/media/{common => }/tuners/mxl5005s.c (100%)
 rename drivers/media/{common => }/tuners/mxl5005s.h (100%)
 rename drivers/media/{common => }/tuners/mxl5007t.c (100%)
 rename drivers/media/{common => }/tuners/mxl5007t.h (100%)
 rename drivers/media/{common => }/tuners/qt1010.c (100%)
 rename drivers/media/{common => }/tuners/qt1010.h (100%)
 rename drivers/media/{common => }/tuners/qt1010_priv.h (100%)
 rename drivers/media/{common => }/tuners/tda18212.c (100%)
 rename drivers/media/{common => }/tuners/tda18212.h (100%)
 rename drivers/media/{common => }/tuners/tda18218.c (100%)
 rename drivers/media/{common => }/tuners/tda18218.h (100%)
 rename drivers/media/{common => }/tuners/tda18218_priv.h (100%)
 rename drivers/media/{common => }/tuners/tda18271-common.c (100%)
 rename drivers/media/{common => }/tuners/tda18271-fe.c (100%)
 rename drivers/media/{common => }/tuners/tda18271-maps.c (100%)
 rename drivers/media/{common => }/tuners/tda18271-priv.h (100%)
 rename drivers/media/{common => }/tuners/tda18271.h (100%)
 rename drivers/media/{common => }/tuners/tda827x.c (100%)
 rename drivers/media/{common => }/tuners/tda827x.h (100%)
 rename drivers/media/{common => }/tuners/tda8290.c (100%)
 rename drivers/media/{common => }/tuners/tda8290.h (100%)
 rename drivers/media/{common => }/tuners/tda9887.c (100%)
 rename drivers/media/{common => }/tuners/tda9887.h (100%)
 rename drivers/media/{common => }/tuners/tea5761.c (100%)
 rename drivers/media/{common => }/tuners/tea5761.h (100%)
 rename drivers/media/{common => }/tuners/tea5767.c (100%)
 rename drivers/media/{common => }/tuners/tea5767.h (100%)
 rename drivers/media/{common => }/tuners/tua9001.c (100%)
 rename drivers/media/{common => }/tuners/tua9001.h (100%)
 rename drivers/media/{common => }/tuners/tua9001_priv.h (100%)
 rename drivers/media/{common => }/tuners/tuner-i2c.h (100%)
 rename drivers/media/{common => }/tuners/tuner-simple.c (100%)
 rename drivers/media/{common => }/tuners/tuner-simple.h (100%)
 rename drivers/media/{common => }/tuners/tuner-types.c (100%)
 rename drivers/media/{common => }/tuners/tuner-xc2028-types.h (100%)
 rename drivers/media/{common => }/tuners/tuner-xc2028.c (100%)
 rename drivers/media/{common => }/tuners/tuner-xc2028.h (100%)
 rename drivers/media/{common => }/tuners/xc4000.c (100%)
 rename drivers/media/{common => }/tuners/xc4000.h (100%)
 rename drivers/media/{common => }/tuners/xc5000.c (100%)
 rename drivers/media/{common => }/tuners/xc5000.h (100%)
 create mode 100644 drivers/media/usb/Kconfig
 create mode 100644 drivers/media/usb/Makefile
 create mode 100644 drivers/media/usb/b2c2/Kconfig
 create mode 100644 drivers/media/usb/b2c2/Makefile
 rename drivers/media/{dvb => usb}/b2c2/flexcop-usb.c (100%)
 rename drivers/media/{dvb => usb}/b2c2/flexcop-usb.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/Kconfig (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/Makefile (94%)
 rename drivers/media/{dvb => usb}/dvb-usb/a800.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9005-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9005-remote.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9005-script.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9005.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9005.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9015.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9015.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9035.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9035.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/anysee.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/anysee.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/au6610.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/au6610.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/az6007.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/az6027.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/az6027.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/ce6230.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/ce6230.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/cinergyT2-core.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/cinergyT2-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/cinergyT2.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/cxusb.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/cxusb.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dib0700.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dib0700_core.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dib0700_devices.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dib07x0.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dibusb-common.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dibusb-mb.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dibusb-mc.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dibusb.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/digitv.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/digitv.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dtt200u-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dtt200u.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dtt200u.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dtv5100.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dtv5100.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-common.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-dvb.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-firmware.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-i2c.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-ids.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-init.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-remote.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-urb.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dw2102.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dw2102.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/ec168.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/ec168.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/friio-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/friio.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/friio.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/gl861.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/gl861.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/gp8psk-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/gp8psk.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/gp8psk.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/it913x.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/lmedm04.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/lmedm04.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/m920x.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/m920x.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf-demod.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf-demod.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf-gpio.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf-gpio.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf-i2c.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf-i2c.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf-phy.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf-phy.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf-reg.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf-tuner.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf-tuner.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/mxl111sf.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/nova-t-usb2.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/opera1.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/pctv452e.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/rtl28xxu.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/rtl28xxu.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/technisat-usb2.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/ttusb2.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/ttusb2.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/umt-010.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/usb-urb.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/vp702x-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/vp702x.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/vp702x.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/vp7045-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/vp7045.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/vp7045.h (100%)
 create mode 100644 drivers/media/usb/siano/Kconfig
 create mode 100644 drivers/media/usb/siano/Makefile
 rename drivers/media/{dvb => usb}/siano/smsusb.c (100%)
 rename drivers/media/{dvb => usb}/ttusb-budget/Kconfig (100%)
 create mode 100644 drivers/media/usb/ttusb-budget/Makefile
 rename drivers/media/{dvb => usb}/ttusb-budget/dvb-ttusb-budget.c (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/Kconfig (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/Makefile (57%)
 rename drivers/media/{dvb => usb}/ttusb-dec/ttusb_dec.c (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/ttusbdecfe.c (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/ttusbdecfe.h (100%)
 create mode 100644 drivers/media/v4l2-core/Kconfig
 create mode 100644 drivers/media/v4l2-core/Makefile
 rename drivers/media/{video => v4l2-core}/tuner-core.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-common.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-compat-ioctl32.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-ctrls.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-dev.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-device.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-event.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-fh.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-int-device.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-ioctl.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-mem2mem.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-subdev.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-core.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-dma-contig.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-dma-sg.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-dvb.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-vmalloc.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-core.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-dma-contig.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-dma-sg.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-memops.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-vmalloc.c (100%)

-- 
1.7.10.2


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab2FNUix (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 16:38:53 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5EKcr88029403
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 16:38:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 03/10] [media] move the dvb/frontends to drivers/media/dvb-frontends
Date: Thu, 14 Jun 2012 17:35:54 -0300
Message-Id: <1339706161-22713-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
References: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Raise the DVB frontends one level up, as the intention is to remove
the drivers/media/dvb directory.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig                                              |    4 ++++
 drivers/media/Makefile                                             |    2 +-
 drivers/media/common/tuners/Makefile                               |    2 +-
 drivers/media/{dvb/frontends => dvb-frontends}/Kconfig             |    0
 drivers/media/{dvb/frontends => dvb-frontends}/Makefile            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/a8293.c             |    0
 drivers/media/{dvb/frontends => dvb-frontends}/a8293.h             |    0
 drivers/media/{dvb/frontends => dvb-frontends}/af9013.c            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/af9013.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/af9013_priv.h       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/af9033.c            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/af9033.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/af9033_priv.h       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/atbm8830.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/atbm8830.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/atbm8830_priv.h     |    0
 drivers/media/{dvb/frontends => dvb-frontends}/au8522.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/au8522_common.c     |    0
 drivers/media/{dvb/frontends => dvb-frontends}/au8522_decoder.c    |    0
 drivers/media/{dvb/frontends => dvb-frontends}/au8522_dig.c        |    0
 drivers/media/{dvb/frontends => dvb-frontends}/au8522_priv.h       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/bcm3510.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/bcm3510.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/bcm3510_priv.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/bsbe1-d01a.h        |    0
 drivers/media/{dvb/frontends => dvb-frontends}/bsbe1.h             |    0
 drivers/media/{dvb/frontends => dvb-frontends}/bsru6.h             |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cx22700.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cx22700.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cx22702.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cx22702.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cx24110.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cx24110.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cx24113.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cx24113.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cx24116.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cx24116.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cx24123.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cx24123.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_c.c        |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_core.c     |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_priv.h     |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_t.c        |    0
 drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_t2.c       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib0070.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib0070.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib0090.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib0090.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib3000.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib3000mb.c         |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib3000mb_priv.h    |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib3000mc.c         |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib3000mc.h         |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib7000m.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib7000m.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib7000p.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib7000p.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib8000.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib8000.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib9000.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dib9000.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dibx000_common.c    |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dibx000_common.h    |    0
 drivers/media/{dvb/frontends => dvb-frontends}/drxd.h              |    0
 drivers/media/{dvb/frontends => dvb-frontends}/drxd_firm.c         |    0
 drivers/media/{dvb/frontends => dvb-frontends}/drxd_firm.h         |    0
 drivers/media/{dvb/frontends => dvb-frontends}/drxd_hard.c         |    0
 drivers/media/{dvb/frontends => dvb-frontends}/drxd_map_firm.h     |    0
 drivers/media/{dvb/frontends => dvb-frontends}/drxk.h              |    0
 drivers/media/{dvb/frontends => dvb-frontends}/drxk_hard.c         |    0
 drivers/media/{dvb/frontends => dvb-frontends}/drxk_hard.h         |    0
 drivers/media/{dvb/frontends => dvb-frontends}/drxk_map.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/ds3000.c            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/ds3000.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dvb-pll.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dvb-pll.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dvb_dummy_fe.c      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/dvb_dummy_fe.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/ec100.c             |    0
 drivers/media/{dvb/frontends => dvb-frontends}/ec100.h             |    0
 drivers/media/{dvb/frontends => dvb-frontends}/ec100_priv.h        |    0
 drivers/media/{dvb/frontends => dvb-frontends}/eds1547.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/hd29l2.c            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/hd29l2.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/hd29l2_priv.h       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/isl6405.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/isl6405.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/isl6421.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/isl6421.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/isl6423.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/isl6423.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/it913x-fe-priv.h    |    0
 drivers/media/{dvb/frontends => dvb-frontends}/it913x-fe.c         |    0
 drivers/media/{dvb/frontends => dvb-frontends}/it913x-fe.h         |    0
 drivers/media/{dvb/frontends => dvb-frontends}/itd1000.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/itd1000.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/itd1000_priv.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/ix2505v.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/ix2505v.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/l64781.c            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/l64781.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lg2160.c            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lg2160.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lgdt3305.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lgdt3305.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lgdt330x.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lgdt330x.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lgdt330x_priv.h     |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lgs8gl5.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lgs8gl5.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lgs8gxx.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lgs8gxx.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lgs8gxx_priv.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lnbh24.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lnbp21.c            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lnbp21.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lnbp22.c            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/lnbp22.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/m88rs2000.c         |    0
 drivers/media/{dvb/frontends => dvb-frontends}/m88rs2000.h         |    0
 drivers/media/{dvb/frontends => dvb-frontends}/mb86a16.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/mb86a16.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/mb86a16_priv.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/mb86a20s.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/mb86a20s.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/mt312.c             |    0
 drivers/media/{dvb/frontends => dvb-frontends}/mt312.h             |    0
 drivers/media/{dvb/frontends => dvb-frontends}/mt312_priv.h        |    0
 drivers/media/{dvb/frontends => dvb-frontends}/mt352.c             |    0
 drivers/media/{dvb/frontends => dvb-frontends}/mt352.h             |    0
 drivers/media/{dvb/frontends => dvb-frontends}/mt352_priv.h        |    0
 drivers/media/{dvb/frontends => dvb-frontends}/nxt200x.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/nxt200x.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/nxt6000.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/nxt6000.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/nxt6000_priv.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/or51132.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/or51132.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/or51211.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/or51211.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/rtl2830.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/rtl2830.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/rtl2830_priv.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/s5h1409.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/s5h1409.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/s5h1411.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/s5h1411.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/s5h1420.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/s5h1420.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/s5h1420_priv.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/s5h1432.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/s5h1432.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/s921.c              |    0
 drivers/media/{dvb/frontends => dvb-frontends}/s921.h              |    0
 drivers/media/{dvb/frontends => dvb-frontends}/si21xx.c            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/si21xx.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/sp8870.c            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/sp8870.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/sp887x.c            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/sp887x.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stb0899_algo.c      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stb0899_cfg.h       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stb0899_drv.c       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stb0899_drv.h       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stb0899_priv.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stb0899_reg.h       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stb6000.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stb6000.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stb6100.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stb6100.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stb6100_cfg.h       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stb6100_proc.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0288.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0288.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0297.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0297.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0299.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0299.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0367.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0367.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0367_priv.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0367_regs.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0900.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0900_core.c      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0900_init.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0900_priv.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0900_reg.h       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv0900_sw.c        |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv090x.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv090x.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv090x_priv.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv090x_reg.h       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv6110.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv6110.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv6110x.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv6110x.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv6110x_priv.h     |    0
 drivers/media/{dvb/frontends => dvb-frontends}/stv6110x_reg.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda10021.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda10023.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda1002x.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda10048.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda10048.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda1004x.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda1004x.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda10071.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda10071.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda10071_priv.h     |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda10086.c          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda10086.h          |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda18271c2dd.c      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda18271c2dd.h      |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda18271c2dd_maps.h |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda665x.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda665x.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda8083.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda8083.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda8261.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda8261.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda8261_cfg.h       |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda826x.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tda826x.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tdhd1.h             |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tua6100.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/tua6100.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/ves1820.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/ves1820.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/ves1x93.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/ves1x93.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/z0194a.h            |    0
 drivers/media/{dvb/frontends => dvb-frontends}/zl10036.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/zl10036.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/zl10039.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/zl10039.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/zl10353.c           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/zl10353.h           |    0
 drivers/media/{dvb/frontends => dvb-frontends}/zl10353_priv.h      |    0
 drivers/media/dvb/Kconfig                                          |    4 ----
 drivers/media/dvb/Makefile                                         |    3 +--
 drivers/media/dvb/b2c2/Makefile                                    |    2 +-
 drivers/media/dvb/bt8xx/Makefile                                   |    2 +-
 drivers/media/dvb/ddbridge/Makefile                                |    2 +-
 drivers/media/dvb/dm1105/Makefile                                  |    2 +-
 drivers/media/dvb/dvb-usb/Makefile                                 |    2 +-
 drivers/media/dvb/mantis/Makefile                                  |    2 +-
 drivers/media/dvb/ngene/Makefile                                   |    2 +-
 drivers/media/dvb/pluto2/Makefile                                  |    2 +-
 drivers/media/dvb/pt1/Makefile                                     |    2 +-
 drivers/media/dvb/ttpci/Makefile                                   |    2 +-
 drivers/media/dvb/ttusb-budget/Makefile                            |    2 +-
 drivers/media/v4l2-core/Makefile                                   |    2 +-
 drivers/media/video/Makefile                                       |    2 +-
 drivers/media/video/au0828/Makefile                                |    2 +-
 drivers/media/video/cx18/Makefile                                  |    2 +-
 drivers/media/video/cx231xx/Makefile                               |    2 +-
 drivers/media/video/cx23885/Makefile                               |    2 +-
 drivers/media/video/cx25821/Makefile                               |    2 +-
 drivers/media/video/cx88/Makefile                                  |    2 +-
 drivers/media/video/em28xx/Makefile                                |    2 +-
 drivers/media/video/ivtv/Makefile                                  |    2 +-
 drivers/media/video/pvrusb2/Makefile                               |    2 +-
 drivers/media/video/saa7134/Makefile                               |    2 +-
 drivers/media/video/saa7164/Makefile                               |    2 +-
 drivers/media/video/tlg2300/Makefile                               |    2 +-
 drivers/media/video/tm6000/Makefile                                |    2 +-
 drivers/staging/media/cxd2099/Makefile                             |    2 +-
 drivers/staging/media/go7007/Makefile                              |    2 +-
 268 files changed, 35 insertions(+), 36 deletions(-)
 rename drivers/media/{dvb/frontends => dvb-frontends}/Kconfig (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/Makefile (100%)
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

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index e9159de..318c2bf 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -166,4 +166,8 @@ source "drivers/media/radio/Kconfig"
 source "drivers/media/dvb-core/Kconfig"
 source "drivers/media/dvb/Kconfig"
 
+comment "Supported DVB Frontends"
+        depends on DVB_CORE
+source "drivers/media/dvb-frontends/Kconfig"
+
 endif # MEDIA_SUPPORT
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 7f9f99a..f95b9e3 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -11,4 +11,4 @@ endif
 obj-y += v4l2-core/ common/ rc/ video/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/
-obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb/
+obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb/ dvb-frontends/
diff --git a/drivers/media/common/tuners/Makefile b/drivers/media/common/tuners/Makefile
index 2ddbb2c..112aeee 100644
--- a/drivers/media/common/tuners/Makefile
+++ b/drivers/media/common/tuners/Makefile
@@ -34,4 +34,4 @@ obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
 obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
-ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
+ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
similarity index 100%
rename from drivers/media/dvb/frontends/Kconfig
rename to drivers/media/dvb-frontends/Kconfig
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb-frontends/Makefile
similarity index 100%
rename from drivers/media/dvb/frontends/Makefile
rename to drivers/media/dvb-frontends/Makefile
diff --git a/drivers/media/dvb/frontends/a8293.c b/drivers/media/dvb-frontends/a8293.c
similarity index 100%
rename from drivers/media/dvb/frontends/a8293.c
rename to drivers/media/dvb-frontends/a8293.c
diff --git a/drivers/media/dvb/frontends/a8293.h b/drivers/media/dvb-frontends/a8293.h
similarity index 100%
rename from drivers/media/dvb/frontends/a8293.h
rename to drivers/media/dvb-frontends/a8293.h
diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
similarity index 100%
rename from drivers/media/dvb/frontends/af9013.c
rename to drivers/media/dvb-frontends/af9013.c
diff --git a/drivers/media/dvb/frontends/af9013.h b/drivers/media/dvb-frontends/af9013.h
similarity index 100%
rename from drivers/media/dvb/frontends/af9013.h
rename to drivers/media/dvb-frontends/af9013.h
diff --git a/drivers/media/dvb/frontends/af9013_priv.h b/drivers/media/dvb-frontends/af9013_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/af9013_priv.h
rename to drivers/media/dvb-frontends/af9013_priv.h
diff --git a/drivers/media/dvb/frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
similarity index 100%
rename from drivers/media/dvb/frontends/af9033.c
rename to drivers/media/dvb-frontends/af9033.c
diff --git a/drivers/media/dvb/frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
similarity index 100%
rename from drivers/media/dvb/frontends/af9033.h
rename to drivers/media/dvb-frontends/af9033.h
diff --git a/drivers/media/dvb/frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/af9033_priv.h
rename to drivers/media/dvb-frontends/af9033_priv.h
diff --git a/drivers/media/dvb/frontends/atbm8830.c b/drivers/media/dvb-frontends/atbm8830.c
similarity index 100%
rename from drivers/media/dvb/frontends/atbm8830.c
rename to drivers/media/dvb-frontends/atbm8830.c
diff --git a/drivers/media/dvb/frontends/atbm8830.h b/drivers/media/dvb-frontends/atbm8830.h
similarity index 100%
rename from drivers/media/dvb/frontends/atbm8830.h
rename to drivers/media/dvb-frontends/atbm8830.h
diff --git a/drivers/media/dvb/frontends/atbm8830_priv.h b/drivers/media/dvb-frontends/atbm8830_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/atbm8830_priv.h
rename to drivers/media/dvb-frontends/atbm8830_priv.h
diff --git a/drivers/media/dvb/frontends/au8522.h b/drivers/media/dvb-frontends/au8522.h
similarity index 100%
rename from drivers/media/dvb/frontends/au8522.h
rename to drivers/media/dvb-frontends/au8522.h
diff --git a/drivers/media/dvb/frontends/au8522_common.c b/drivers/media/dvb-frontends/au8522_common.c
similarity index 100%
rename from drivers/media/dvb/frontends/au8522_common.c
rename to drivers/media/dvb-frontends/au8522_common.c
diff --git a/drivers/media/dvb/frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
similarity index 100%
rename from drivers/media/dvb/frontends/au8522_decoder.c
rename to drivers/media/dvb-frontends/au8522_decoder.c
diff --git a/drivers/media/dvb/frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
similarity index 100%
rename from drivers/media/dvb/frontends/au8522_dig.c
rename to drivers/media/dvb-frontends/au8522_dig.c
diff --git a/drivers/media/dvb/frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/au8522_priv.h
rename to drivers/media/dvb-frontends/au8522_priv.h
diff --git a/drivers/media/dvb/frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
similarity index 100%
rename from drivers/media/dvb/frontends/bcm3510.c
rename to drivers/media/dvb-frontends/bcm3510.c
diff --git a/drivers/media/dvb/frontends/bcm3510.h b/drivers/media/dvb-frontends/bcm3510.h
similarity index 100%
rename from drivers/media/dvb/frontends/bcm3510.h
rename to drivers/media/dvb-frontends/bcm3510.h
diff --git a/drivers/media/dvb/frontends/bcm3510_priv.h b/drivers/media/dvb-frontends/bcm3510_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/bcm3510_priv.h
rename to drivers/media/dvb-frontends/bcm3510_priv.h
diff --git a/drivers/media/dvb/frontends/bsbe1-d01a.h b/drivers/media/dvb-frontends/bsbe1-d01a.h
similarity index 100%
rename from drivers/media/dvb/frontends/bsbe1-d01a.h
rename to drivers/media/dvb-frontends/bsbe1-d01a.h
diff --git a/drivers/media/dvb/frontends/bsbe1.h b/drivers/media/dvb-frontends/bsbe1.h
similarity index 100%
rename from drivers/media/dvb/frontends/bsbe1.h
rename to drivers/media/dvb-frontends/bsbe1.h
diff --git a/drivers/media/dvb/frontends/bsru6.h b/drivers/media/dvb-frontends/bsru6.h
similarity index 100%
rename from drivers/media/dvb/frontends/bsru6.h
rename to drivers/media/dvb-frontends/bsru6.h
diff --git a/drivers/media/dvb/frontends/cx22700.c b/drivers/media/dvb-frontends/cx22700.c
similarity index 100%
rename from drivers/media/dvb/frontends/cx22700.c
rename to drivers/media/dvb-frontends/cx22700.c
diff --git a/drivers/media/dvb/frontends/cx22700.h b/drivers/media/dvb-frontends/cx22700.h
similarity index 100%
rename from drivers/media/dvb/frontends/cx22700.h
rename to drivers/media/dvb-frontends/cx22700.h
diff --git a/drivers/media/dvb/frontends/cx22702.c b/drivers/media/dvb-frontends/cx22702.c
similarity index 100%
rename from drivers/media/dvb/frontends/cx22702.c
rename to drivers/media/dvb-frontends/cx22702.c
diff --git a/drivers/media/dvb/frontends/cx22702.h b/drivers/media/dvb-frontends/cx22702.h
similarity index 100%
rename from drivers/media/dvb/frontends/cx22702.h
rename to drivers/media/dvb-frontends/cx22702.h
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
similarity index 100%
rename from drivers/media/dvb/frontends/cx24110.c
rename to drivers/media/dvb-frontends/cx24110.c
diff --git a/drivers/media/dvb/frontends/cx24110.h b/drivers/media/dvb-frontends/cx24110.h
similarity index 100%
rename from drivers/media/dvb/frontends/cx24110.h
rename to drivers/media/dvb-frontends/cx24110.h
diff --git a/drivers/media/dvb/frontends/cx24113.c b/drivers/media/dvb-frontends/cx24113.c
similarity index 100%
rename from drivers/media/dvb/frontends/cx24113.c
rename to drivers/media/dvb-frontends/cx24113.c
diff --git a/drivers/media/dvb/frontends/cx24113.h b/drivers/media/dvb-frontends/cx24113.h
similarity index 100%
rename from drivers/media/dvb/frontends/cx24113.h
rename to drivers/media/dvb-frontends/cx24113.h
diff --git a/drivers/media/dvb/frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
similarity index 100%
rename from drivers/media/dvb/frontends/cx24116.c
rename to drivers/media/dvb-frontends/cx24116.c
diff --git a/drivers/media/dvb/frontends/cx24116.h b/drivers/media/dvb-frontends/cx24116.h
similarity index 100%
rename from drivers/media/dvb/frontends/cx24116.h
rename to drivers/media/dvb-frontends/cx24116.h
diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
similarity index 100%
rename from drivers/media/dvb/frontends/cx24123.c
rename to drivers/media/dvb-frontends/cx24123.c
diff --git a/drivers/media/dvb/frontends/cx24123.h b/drivers/media/dvb-frontends/cx24123.h
similarity index 100%
rename from drivers/media/dvb/frontends/cx24123.h
rename to drivers/media/dvb-frontends/cx24123.h
diff --git a/drivers/media/dvb/frontends/cxd2820r.h b/drivers/media/dvb-frontends/cxd2820r.h
similarity index 100%
rename from drivers/media/dvb/frontends/cxd2820r.h
rename to drivers/media/dvb-frontends/cxd2820r.h
diff --git a/drivers/media/dvb/frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
similarity index 100%
rename from drivers/media/dvb/frontends/cxd2820r_c.c
rename to drivers/media/dvb-frontends/cxd2820r_c.c
diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
similarity index 100%
rename from drivers/media/dvb/frontends/cxd2820r_core.c
rename to drivers/media/dvb-frontends/cxd2820r_core.c
diff --git a/drivers/media/dvb/frontends/cxd2820r_priv.h b/drivers/media/dvb-frontends/cxd2820r_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/cxd2820r_priv.h
rename to drivers/media/dvb-frontends/cxd2820r_priv.h
diff --git a/drivers/media/dvb/frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
similarity index 100%
rename from drivers/media/dvb/frontends/cxd2820r_t.c
rename to drivers/media/dvb-frontends/cxd2820r_t.c
diff --git a/drivers/media/dvb/frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
similarity index 100%
rename from drivers/media/dvb/frontends/cxd2820r_t2.c
rename to drivers/media/dvb-frontends/cxd2820r_t2.c
diff --git a/drivers/media/dvb/frontends/dib0070.c b/drivers/media/dvb-frontends/dib0070.c
similarity index 100%
rename from drivers/media/dvb/frontends/dib0070.c
rename to drivers/media/dvb-frontends/dib0070.c
diff --git a/drivers/media/dvb/frontends/dib0070.h b/drivers/media/dvb-frontends/dib0070.h
similarity index 100%
rename from drivers/media/dvb/frontends/dib0070.h
rename to drivers/media/dvb-frontends/dib0070.h
diff --git a/drivers/media/dvb/frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
similarity index 100%
rename from drivers/media/dvb/frontends/dib0090.c
rename to drivers/media/dvb-frontends/dib0090.c
diff --git a/drivers/media/dvb/frontends/dib0090.h b/drivers/media/dvb-frontends/dib0090.h
similarity index 100%
rename from drivers/media/dvb/frontends/dib0090.h
rename to drivers/media/dvb-frontends/dib0090.h
diff --git a/drivers/media/dvb/frontends/dib3000.h b/drivers/media/dvb-frontends/dib3000.h
similarity index 100%
rename from drivers/media/dvb/frontends/dib3000.h
rename to drivers/media/dvb-frontends/dib3000.h
diff --git a/drivers/media/dvb/frontends/dib3000mb.c b/drivers/media/dvb-frontends/dib3000mb.c
similarity index 100%
rename from drivers/media/dvb/frontends/dib3000mb.c
rename to drivers/media/dvb-frontends/dib3000mb.c
diff --git a/drivers/media/dvb/frontends/dib3000mb_priv.h b/drivers/media/dvb-frontends/dib3000mb_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/dib3000mb_priv.h
rename to drivers/media/dvb-frontends/dib3000mb_priv.h
diff --git a/drivers/media/dvb/frontends/dib3000mc.c b/drivers/media/dvb-frontends/dib3000mc.c
similarity index 100%
rename from drivers/media/dvb/frontends/dib3000mc.c
rename to drivers/media/dvb-frontends/dib3000mc.c
diff --git a/drivers/media/dvb/frontends/dib3000mc.h b/drivers/media/dvb-frontends/dib3000mc.h
similarity index 100%
rename from drivers/media/dvb/frontends/dib3000mc.h
rename to drivers/media/dvb-frontends/dib3000mc.h
diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb-frontends/dib7000m.c
similarity index 100%
rename from drivers/media/dvb/frontends/dib7000m.c
rename to drivers/media/dvb-frontends/dib7000m.c
diff --git a/drivers/media/dvb/frontends/dib7000m.h b/drivers/media/dvb-frontends/dib7000m.h
similarity index 100%
rename from drivers/media/dvb/frontends/dib7000m.h
rename to drivers/media/dvb-frontends/dib7000m.h
diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
similarity index 100%
rename from drivers/media/dvb/frontends/dib7000p.c
rename to drivers/media/dvb-frontends/dib7000p.c
diff --git a/drivers/media/dvb/frontends/dib7000p.h b/drivers/media/dvb-frontends/dib7000p.h
similarity index 100%
rename from drivers/media/dvb/frontends/dib7000p.h
rename to drivers/media/dvb-frontends/dib7000p.h
diff --git a/drivers/media/dvb/frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
similarity index 100%
rename from drivers/media/dvb/frontends/dib8000.c
rename to drivers/media/dvb-frontends/dib8000.c
diff --git a/drivers/media/dvb/frontends/dib8000.h b/drivers/media/dvb-frontends/dib8000.h
similarity index 100%
rename from drivers/media/dvb/frontends/dib8000.h
rename to drivers/media/dvb-frontends/dib8000.h
diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
similarity index 100%
rename from drivers/media/dvb/frontends/dib9000.c
rename to drivers/media/dvb-frontends/dib9000.c
diff --git a/drivers/media/dvb/frontends/dib9000.h b/drivers/media/dvb-frontends/dib9000.h
similarity index 100%
rename from drivers/media/dvb/frontends/dib9000.h
rename to drivers/media/dvb-frontends/dib9000.h
diff --git a/drivers/media/dvb/frontends/dibx000_common.c b/drivers/media/dvb-frontends/dibx000_common.c
similarity index 100%
rename from drivers/media/dvb/frontends/dibx000_common.c
rename to drivers/media/dvb-frontends/dibx000_common.c
diff --git a/drivers/media/dvb/frontends/dibx000_common.h b/drivers/media/dvb-frontends/dibx000_common.h
similarity index 100%
rename from drivers/media/dvb/frontends/dibx000_common.h
rename to drivers/media/dvb-frontends/dibx000_common.h
diff --git a/drivers/media/dvb/frontends/drxd.h b/drivers/media/dvb-frontends/drxd.h
similarity index 100%
rename from drivers/media/dvb/frontends/drxd.h
rename to drivers/media/dvb-frontends/drxd.h
diff --git a/drivers/media/dvb/frontends/drxd_firm.c b/drivers/media/dvb-frontends/drxd_firm.c
similarity index 100%
rename from drivers/media/dvb/frontends/drxd_firm.c
rename to drivers/media/dvb-frontends/drxd_firm.c
diff --git a/drivers/media/dvb/frontends/drxd_firm.h b/drivers/media/dvb-frontends/drxd_firm.h
similarity index 100%
rename from drivers/media/dvb/frontends/drxd_firm.h
rename to drivers/media/dvb-frontends/drxd_firm.h
diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
similarity index 100%
rename from drivers/media/dvb/frontends/drxd_hard.c
rename to drivers/media/dvb-frontends/drxd_hard.c
diff --git a/drivers/media/dvb/frontends/drxd_map_firm.h b/drivers/media/dvb-frontends/drxd_map_firm.h
similarity index 100%
rename from drivers/media/dvb/frontends/drxd_map_firm.h
rename to drivers/media/dvb-frontends/drxd_map_firm.h
diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
similarity index 100%
rename from drivers/media/dvb/frontends/drxk.h
rename to drivers/media/dvb-frontends/drxk.h
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
similarity index 100%
rename from drivers/media/dvb/frontends/drxk_hard.c
rename to drivers/media/dvb-frontends/drxk_hard.c
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb-frontends/drxk_hard.h
similarity index 100%
rename from drivers/media/dvb/frontends/drxk_hard.h
rename to drivers/media/dvb-frontends/drxk_hard.h
diff --git a/drivers/media/dvb/frontends/drxk_map.h b/drivers/media/dvb-frontends/drxk_map.h
similarity index 100%
rename from drivers/media/dvb/frontends/drxk_map.h
rename to drivers/media/dvb-frontends/drxk_map.h
diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
similarity index 100%
rename from drivers/media/dvb/frontends/ds3000.c
rename to drivers/media/dvb-frontends/ds3000.c
diff --git a/drivers/media/dvb/frontends/ds3000.h b/drivers/media/dvb-frontends/ds3000.h
similarity index 100%
rename from drivers/media/dvb/frontends/ds3000.h
rename to drivers/media/dvb-frontends/ds3000.h
diff --git a/drivers/media/dvb/frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
similarity index 100%
rename from drivers/media/dvb/frontends/dvb-pll.c
rename to drivers/media/dvb-frontends/dvb-pll.c
diff --git a/drivers/media/dvb/frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
similarity index 100%
rename from drivers/media/dvb/frontends/dvb-pll.h
rename to drivers/media/dvb-frontends/dvb-pll.h
diff --git a/drivers/media/dvb/frontends/dvb_dummy_fe.c b/drivers/media/dvb-frontends/dvb_dummy_fe.c
similarity index 100%
rename from drivers/media/dvb/frontends/dvb_dummy_fe.c
rename to drivers/media/dvb-frontends/dvb_dummy_fe.c
diff --git a/drivers/media/dvb/frontends/dvb_dummy_fe.h b/drivers/media/dvb-frontends/dvb_dummy_fe.h
similarity index 100%
rename from drivers/media/dvb/frontends/dvb_dummy_fe.h
rename to drivers/media/dvb-frontends/dvb_dummy_fe.h
diff --git a/drivers/media/dvb/frontends/ec100.c b/drivers/media/dvb-frontends/ec100.c
similarity index 100%
rename from drivers/media/dvb/frontends/ec100.c
rename to drivers/media/dvb-frontends/ec100.c
diff --git a/drivers/media/dvb/frontends/ec100.h b/drivers/media/dvb-frontends/ec100.h
similarity index 100%
rename from drivers/media/dvb/frontends/ec100.h
rename to drivers/media/dvb-frontends/ec100.h
diff --git a/drivers/media/dvb/frontends/ec100_priv.h b/drivers/media/dvb-frontends/ec100_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/ec100_priv.h
rename to drivers/media/dvb-frontends/ec100_priv.h
diff --git a/drivers/media/dvb/frontends/eds1547.h b/drivers/media/dvb-frontends/eds1547.h
similarity index 100%
rename from drivers/media/dvb/frontends/eds1547.h
rename to drivers/media/dvb-frontends/eds1547.h
diff --git a/drivers/media/dvb/frontends/hd29l2.c b/drivers/media/dvb-frontends/hd29l2.c
similarity index 100%
rename from drivers/media/dvb/frontends/hd29l2.c
rename to drivers/media/dvb-frontends/hd29l2.c
diff --git a/drivers/media/dvb/frontends/hd29l2.h b/drivers/media/dvb-frontends/hd29l2.h
similarity index 100%
rename from drivers/media/dvb/frontends/hd29l2.h
rename to drivers/media/dvb-frontends/hd29l2.h
diff --git a/drivers/media/dvb/frontends/hd29l2_priv.h b/drivers/media/dvb-frontends/hd29l2_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/hd29l2_priv.h
rename to drivers/media/dvb-frontends/hd29l2_priv.h
diff --git a/drivers/media/dvb/frontends/isl6405.c b/drivers/media/dvb-frontends/isl6405.c
similarity index 100%
rename from drivers/media/dvb/frontends/isl6405.c
rename to drivers/media/dvb-frontends/isl6405.c
diff --git a/drivers/media/dvb/frontends/isl6405.h b/drivers/media/dvb-frontends/isl6405.h
similarity index 100%
rename from drivers/media/dvb/frontends/isl6405.h
rename to drivers/media/dvb-frontends/isl6405.h
diff --git a/drivers/media/dvb/frontends/isl6421.c b/drivers/media/dvb-frontends/isl6421.c
similarity index 100%
rename from drivers/media/dvb/frontends/isl6421.c
rename to drivers/media/dvb-frontends/isl6421.c
diff --git a/drivers/media/dvb/frontends/isl6421.h b/drivers/media/dvb-frontends/isl6421.h
similarity index 100%
rename from drivers/media/dvb/frontends/isl6421.h
rename to drivers/media/dvb-frontends/isl6421.h
diff --git a/drivers/media/dvb/frontends/isl6423.c b/drivers/media/dvb-frontends/isl6423.c
similarity index 100%
rename from drivers/media/dvb/frontends/isl6423.c
rename to drivers/media/dvb-frontends/isl6423.c
diff --git a/drivers/media/dvb/frontends/isl6423.h b/drivers/media/dvb-frontends/isl6423.h
similarity index 100%
rename from drivers/media/dvb/frontends/isl6423.h
rename to drivers/media/dvb-frontends/isl6423.h
diff --git a/drivers/media/dvb/frontends/it913x-fe-priv.h b/drivers/media/dvb-frontends/it913x-fe-priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/it913x-fe-priv.h
rename to drivers/media/dvb-frontends/it913x-fe-priv.h
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb-frontends/it913x-fe.c
similarity index 100%
rename from drivers/media/dvb/frontends/it913x-fe.c
rename to drivers/media/dvb-frontends/it913x-fe.c
diff --git a/drivers/media/dvb/frontends/it913x-fe.h b/drivers/media/dvb-frontends/it913x-fe.h
similarity index 100%
rename from drivers/media/dvb/frontends/it913x-fe.h
rename to drivers/media/dvb-frontends/it913x-fe.h
diff --git a/drivers/media/dvb/frontends/itd1000.c b/drivers/media/dvb-frontends/itd1000.c
similarity index 100%
rename from drivers/media/dvb/frontends/itd1000.c
rename to drivers/media/dvb-frontends/itd1000.c
diff --git a/drivers/media/dvb/frontends/itd1000.h b/drivers/media/dvb-frontends/itd1000.h
similarity index 100%
rename from drivers/media/dvb/frontends/itd1000.h
rename to drivers/media/dvb-frontends/itd1000.h
diff --git a/drivers/media/dvb/frontends/itd1000_priv.h b/drivers/media/dvb-frontends/itd1000_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/itd1000_priv.h
rename to drivers/media/dvb-frontends/itd1000_priv.h
diff --git a/drivers/media/dvb/frontends/ix2505v.c b/drivers/media/dvb-frontends/ix2505v.c
similarity index 100%
rename from drivers/media/dvb/frontends/ix2505v.c
rename to drivers/media/dvb-frontends/ix2505v.c
diff --git a/drivers/media/dvb/frontends/ix2505v.h b/drivers/media/dvb-frontends/ix2505v.h
similarity index 100%
rename from drivers/media/dvb/frontends/ix2505v.h
rename to drivers/media/dvb-frontends/ix2505v.h
diff --git a/drivers/media/dvb/frontends/l64781.c b/drivers/media/dvb-frontends/l64781.c
similarity index 100%
rename from drivers/media/dvb/frontends/l64781.c
rename to drivers/media/dvb-frontends/l64781.c
diff --git a/drivers/media/dvb/frontends/l64781.h b/drivers/media/dvb-frontends/l64781.h
similarity index 100%
rename from drivers/media/dvb/frontends/l64781.h
rename to drivers/media/dvb-frontends/l64781.h
diff --git a/drivers/media/dvb/frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
similarity index 100%
rename from drivers/media/dvb/frontends/lg2160.c
rename to drivers/media/dvb-frontends/lg2160.c
diff --git a/drivers/media/dvb/frontends/lg2160.h b/drivers/media/dvb-frontends/lg2160.h
similarity index 100%
rename from drivers/media/dvb/frontends/lg2160.h
rename to drivers/media/dvb-frontends/lg2160.h
diff --git a/drivers/media/dvb/frontends/lgdt3305.c b/drivers/media/dvb-frontends/lgdt3305.c
similarity index 100%
rename from drivers/media/dvb/frontends/lgdt3305.c
rename to drivers/media/dvb-frontends/lgdt3305.c
diff --git a/drivers/media/dvb/frontends/lgdt3305.h b/drivers/media/dvb-frontends/lgdt3305.h
similarity index 100%
rename from drivers/media/dvb/frontends/lgdt3305.h
rename to drivers/media/dvb-frontends/lgdt3305.h
diff --git a/drivers/media/dvb/frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
similarity index 100%
rename from drivers/media/dvb/frontends/lgdt330x.c
rename to drivers/media/dvb-frontends/lgdt330x.c
diff --git a/drivers/media/dvb/frontends/lgdt330x.h b/drivers/media/dvb-frontends/lgdt330x.h
similarity index 100%
rename from drivers/media/dvb/frontends/lgdt330x.h
rename to drivers/media/dvb-frontends/lgdt330x.h
diff --git a/drivers/media/dvb/frontends/lgdt330x_priv.h b/drivers/media/dvb-frontends/lgdt330x_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/lgdt330x_priv.h
rename to drivers/media/dvb-frontends/lgdt330x_priv.h
diff --git a/drivers/media/dvb/frontends/lgs8gl5.c b/drivers/media/dvb-frontends/lgs8gl5.c
similarity index 100%
rename from drivers/media/dvb/frontends/lgs8gl5.c
rename to drivers/media/dvb-frontends/lgs8gl5.c
diff --git a/drivers/media/dvb/frontends/lgs8gl5.h b/drivers/media/dvb-frontends/lgs8gl5.h
similarity index 100%
rename from drivers/media/dvb/frontends/lgs8gl5.h
rename to drivers/media/dvb-frontends/lgs8gl5.h
diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb-frontends/lgs8gxx.c
similarity index 100%
rename from drivers/media/dvb/frontends/lgs8gxx.c
rename to drivers/media/dvb-frontends/lgs8gxx.c
diff --git a/drivers/media/dvb/frontends/lgs8gxx.h b/drivers/media/dvb-frontends/lgs8gxx.h
similarity index 100%
rename from drivers/media/dvb/frontends/lgs8gxx.h
rename to drivers/media/dvb-frontends/lgs8gxx.h
diff --git a/drivers/media/dvb/frontends/lgs8gxx_priv.h b/drivers/media/dvb-frontends/lgs8gxx_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/lgs8gxx_priv.h
rename to drivers/media/dvb-frontends/lgs8gxx_priv.h
diff --git a/drivers/media/dvb/frontends/lnbh24.h b/drivers/media/dvb-frontends/lnbh24.h
similarity index 100%
rename from drivers/media/dvb/frontends/lnbh24.h
rename to drivers/media/dvb-frontends/lnbh24.h
diff --git a/drivers/media/dvb/frontends/lnbp21.c b/drivers/media/dvb-frontends/lnbp21.c
similarity index 100%
rename from drivers/media/dvb/frontends/lnbp21.c
rename to drivers/media/dvb-frontends/lnbp21.c
diff --git a/drivers/media/dvb/frontends/lnbp21.h b/drivers/media/dvb-frontends/lnbp21.h
similarity index 100%
rename from drivers/media/dvb/frontends/lnbp21.h
rename to drivers/media/dvb-frontends/lnbp21.h
diff --git a/drivers/media/dvb/frontends/lnbp22.c b/drivers/media/dvb-frontends/lnbp22.c
similarity index 100%
rename from drivers/media/dvb/frontends/lnbp22.c
rename to drivers/media/dvb-frontends/lnbp22.c
diff --git a/drivers/media/dvb/frontends/lnbp22.h b/drivers/media/dvb-frontends/lnbp22.h
similarity index 100%
rename from drivers/media/dvb/frontends/lnbp22.h
rename to drivers/media/dvb-frontends/lnbp22.h
diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
similarity index 100%
rename from drivers/media/dvb/frontends/m88rs2000.c
rename to drivers/media/dvb-frontends/m88rs2000.c
diff --git a/drivers/media/dvb/frontends/m88rs2000.h b/drivers/media/dvb-frontends/m88rs2000.h
similarity index 100%
rename from drivers/media/dvb/frontends/m88rs2000.h
rename to drivers/media/dvb-frontends/m88rs2000.h
diff --git a/drivers/media/dvb/frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
similarity index 100%
rename from drivers/media/dvb/frontends/mb86a16.c
rename to drivers/media/dvb-frontends/mb86a16.c
diff --git a/drivers/media/dvb/frontends/mb86a16.h b/drivers/media/dvb-frontends/mb86a16.h
similarity index 100%
rename from drivers/media/dvb/frontends/mb86a16.h
rename to drivers/media/dvb-frontends/mb86a16.h
diff --git a/drivers/media/dvb/frontends/mb86a16_priv.h b/drivers/media/dvb-frontends/mb86a16_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/mb86a16_priv.h
rename to drivers/media/dvb-frontends/mb86a16_priv.h
diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
similarity index 100%
rename from drivers/media/dvb/frontends/mb86a20s.c
rename to drivers/media/dvb-frontends/mb86a20s.c
diff --git a/drivers/media/dvb/frontends/mb86a20s.h b/drivers/media/dvb-frontends/mb86a20s.h
similarity index 100%
rename from drivers/media/dvb/frontends/mb86a20s.h
rename to drivers/media/dvb-frontends/mb86a20s.h
diff --git a/drivers/media/dvb/frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
similarity index 100%
rename from drivers/media/dvb/frontends/mt312.c
rename to drivers/media/dvb-frontends/mt312.c
diff --git a/drivers/media/dvb/frontends/mt312.h b/drivers/media/dvb-frontends/mt312.h
similarity index 100%
rename from drivers/media/dvb/frontends/mt312.h
rename to drivers/media/dvb-frontends/mt312.h
diff --git a/drivers/media/dvb/frontends/mt312_priv.h b/drivers/media/dvb-frontends/mt312_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/mt312_priv.h
rename to drivers/media/dvb-frontends/mt312_priv.h
diff --git a/drivers/media/dvb/frontends/mt352.c b/drivers/media/dvb-frontends/mt352.c
similarity index 100%
rename from drivers/media/dvb/frontends/mt352.c
rename to drivers/media/dvb-frontends/mt352.c
diff --git a/drivers/media/dvb/frontends/mt352.h b/drivers/media/dvb-frontends/mt352.h
similarity index 100%
rename from drivers/media/dvb/frontends/mt352.h
rename to drivers/media/dvb-frontends/mt352.h
diff --git a/drivers/media/dvb/frontends/mt352_priv.h b/drivers/media/dvb-frontends/mt352_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/mt352_priv.h
rename to drivers/media/dvb-frontends/mt352_priv.h
diff --git a/drivers/media/dvb/frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
similarity index 100%
rename from drivers/media/dvb/frontends/nxt200x.c
rename to drivers/media/dvb-frontends/nxt200x.c
diff --git a/drivers/media/dvb/frontends/nxt200x.h b/drivers/media/dvb-frontends/nxt200x.h
similarity index 100%
rename from drivers/media/dvb/frontends/nxt200x.h
rename to drivers/media/dvb-frontends/nxt200x.h
diff --git a/drivers/media/dvb/frontends/nxt6000.c b/drivers/media/dvb-frontends/nxt6000.c
similarity index 100%
rename from drivers/media/dvb/frontends/nxt6000.c
rename to drivers/media/dvb-frontends/nxt6000.c
diff --git a/drivers/media/dvb/frontends/nxt6000.h b/drivers/media/dvb-frontends/nxt6000.h
similarity index 100%
rename from drivers/media/dvb/frontends/nxt6000.h
rename to drivers/media/dvb-frontends/nxt6000.h
diff --git a/drivers/media/dvb/frontends/nxt6000_priv.h b/drivers/media/dvb-frontends/nxt6000_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/nxt6000_priv.h
rename to drivers/media/dvb-frontends/nxt6000_priv.h
diff --git a/drivers/media/dvb/frontends/or51132.c b/drivers/media/dvb-frontends/or51132.c
similarity index 100%
rename from drivers/media/dvb/frontends/or51132.c
rename to drivers/media/dvb-frontends/or51132.c
diff --git a/drivers/media/dvb/frontends/or51132.h b/drivers/media/dvb-frontends/or51132.h
similarity index 100%
rename from drivers/media/dvb/frontends/or51132.h
rename to drivers/media/dvb-frontends/or51132.h
diff --git a/drivers/media/dvb/frontends/or51211.c b/drivers/media/dvb-frontends/or51211.c
similarity index 100%
rename from drivers/media/dvb/frontends/or51211.c
rename to drivers/media/dvb-frontends/or51211.c
diff --git a/drivers/media/dvb/frontends/or51211.h b/drivers/media/dvb-frontends/or51211.h
similarity index 100%
rename from drivers/media/dvb/frontends/or51211.h
rename to drivers/media/dvb-frontends/or51211.h
diff --git a/drivers/media/dvb/frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
similarity index 100%
rename from drivers/media/dvb/frontends/rtl2830.c
rename to drivers/media/dvb-frontends/rtl2830.c
diff --git a/drivers/media/dvb/frontends/rtl2830.h b/drivers/media/dvb-frontends/rtl2830.h
similarity index 100%
rename from drivers/media/dvb/frontends/rtl2830.h
rename to drivers/media/dvb-frontends/rtl2830.h
diff --git a/drivers/media/dvb/frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/rtl2830_priv.h
rename to drivers/media/dvb-frontends/rtl2830_priv.h
diff --git a/drivers/media/dvb/frontends/s5h1409.c b/drivers/media/dvb-frontends/s5h1409.c
similarity index 100%
rename from drivers/media/dvb/frontends/s5h1409.c
rename to drivers/media/dvb-frontends/s5h1409.c
diff --git a/drivers/media/dvb/frontends/s5h1409.h b/drivers/media/dvb-frontends/s5h1409.h
similarity index 100%
rename from drivers/media/dvb/frontends/s5h1409.h
rename to drivers/media/dvb-frontends/s5h1409.h
diff --git a/drivers/media/dvb/frontends/s5h1411.c b/drivers/media/dvb-frontends/s5h1411.c
similarity index 100%
rename from drivers/media/dvb/frontends/s5h1411.c
rename to drivers/media/dvb-frontends/s5h1411.c
diff --git a/drivers/media/dvb/frontends/s5h1411.h b/drivers/media/dvb-frontends/s5h1411.h
similarity index 100%
rename from drivers/media/dvb/frontends/s5h1411.h
rename to drivers/media/dvb-frontends/s5h1411.h
diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
similarity index 100%
rename from drivers/media/dvb/frontends/s5h1420.c
rename to drivers/media/dvb-frontends/s5h1420.c
diff --git a/drivers/media/dvb/frontends/s5h1420.h b/drivers/media/dvb-frontends/s5h1420.h
similarity index 100%
rename from drivers/media/dvb/frontends/s5h1420.h
rename to drivers/media/dvb-frontends/s5h1420.h
diff --git a/drivers/media/dvb/frontends/s5h1420_priv.h b/drivers/media/dvb-frontends/s5h1420_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/s5h1420_priv.h
rename to drivers/media/dvb-frontends/s5h1420_priv.h
diff --git a/drivers/media/dvb/frontends/s5h1432.c b/drivers/media/dvb-frontends/s5h1432.c
similarity index 100%
rename from drivers/media/dvb/frontends/s5h1432.c
rename to drivers/media/dvb-frontends/s5h1432.c
diff --git a/drivers/media/dvb/frontends/s5h1432.h b/drivers/media/dvb-frontends/s5h1432.h
similarity index 100%
rename from drivers/media/dvb/frontends/s5h1432.h
rename to drivers/media/dvb-frontends/s5h1432.h
diff --git a/drivers/media/dvb/frontends/s921.c b/drivers/media/dvb-frontends/s921.c
similarity index 100%
rename from drivers/media/dvb/frontends/s921.c
rename to drivers/media/dvb-frontends/s921.c
diff --git a/drivers/media/dvb/frontends/s921.h b/drivers/media/dvb-frontends/s921.h
similarity index 100%
rename from drivers/media/dvb/frontends/s921.h
rename to drivers/media/dvb-frontends/s921.h
diff --git a/drivers/media/dvb/frontends/si21xx.c b/drivers/media/dvb-frontends/si21xx.c
similarity index 100%
rename from drivers/media/dvb/frontends/si21xx.c
rename to drivers/media/dvb-frontends/si21xx.c
diff --git a/drivers/media/dvb/frontends/si21xx.h b/drivers/media/dvb-frontends/si21xx.h
similarity index 100%
rename from drivers/media/dvb/frontends/si21xx.h
rename to drivers/media/dvb-frontends/si21xx.h
diff --git a/drivers/media/dvb/frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
similarity index 100%
rename from drivers/media/dvb/frontends/sp8870.c
rename to drivers/media/dvb-frontends/sp8870.c
diff --git a/drivers/media/dvb/frontends/sp8870.h b/drivers/media/dvb-frontends/sp8870.h
similarity index 100%
rename from drivers/media/dvb/frontends/sp8870.h
rename to drivers/media/dvb-frontends/sp8870.h
diff --git a/drivers/media/dvb/frontends/sp887x.c b/drivers/media/dvb-frontends/sp887x.c
similarity index 100%
rename from drivers/media/dvb/frontends/sp887x.c
rename to drivers/media/dvb-frontends/sp887x.c
diff --git a/drivers/media/dvb/frontends/sp887x.h b/drivers/media/dvb-frontends/sp887x.h
similarity index 100%
rename from drivers/media/dvb/frontends/sp887x.h
rename to drivers/media/dvb-frontends/sp887x.h
diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb-frontends/stb0899_algo.c
similarity index 100%
rename from drivers/media/dvb/frontends/stb0899_algo.c
rename to drivers/media/dvb-frontends/stb0899_algo.c
diff --git a/drivers/media/dvb/frontends/stb0899_cfg.h b/drivers/media/dvb-frontends/stb0899_cfg.h
similarity index 100%
rename from drivers/media/dvb/frontends/stb0899_cfg.h
rename to drivers/media/dvb-frontends/stb0899_cfg.h
diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
similarity index 100%
rename from drivers/media/dvb/frontends/stb0899_drv.c
rename to drivers/media/dvb-frontends/stb0899_drv.c
diff --git a/drivers/media/dvb/frontends/stb0899_drv.h b/drivers/media/dvb-frontends/stb0899_drv.h
similarity index 100%
rename from drivers/media/dvb/frontends/stb0899_drv.h
rename to drivers/media/dvb-frontends/stb0899_drv.h
diff --git a/drivers/media/dvb/frontends/stb0899_priv.h b/drivers/media/dvb-frontends/stb0899_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/stb0899_priv.h
rename to drivers/media/dvb-frontends/stb0899_priv.h
diff --git a/drivers/media/dvb/frontends/stb0899_reg.h b/drivers/media/dvb-frontends/stb0899_reg.h
similarity index 100%
rename from drivers/media/dvb/frontends/stb0899_reg.h
rename to drivers/media/dvb-frontends/stb0899_reg.h
diff --git a/drivers/media/dvb/frontends/stb6000.c b/drivers/media/dvb-frontends/stb6000.c
similarity index 100%
rename from drivers/media/dvb/frontends/stb6000.c
rename to drivers/media/dvb-frontends/stb6000.c
diff --git a/drivers/media/dvb/frontends/stb6000.h b/drivers/media/dvb-frontends/stb6000.h
similarity index 100%
rename from drivers/media/dvb/frontends/stb6000.h
rename to drivers/media/dvb-frontends/stb6000.h
diff --git a/drivers/media/dvb/frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
similarity index 100%
rename from drivers/media/dvb/frontends/stb6100.c
rename to drivers/media/dvb-frontends/stb6100.c
diff --git a/drivers/media/dvb/frontends/stb6100.h b/drivers/media/dvb-frontends/stb6100.h
similarity index 100%
rename from drivers/media/dvb/frontends/stb6100.h
rename to drivers/media/dvb-frontends/stb6100.h
diff --git a/drivers/media/dvb/frontends/stb6100_cfg.h b/drivers/media/dvb-frontends/stb6100_cfg.h
similarity index 100%
rename from drivers/media/dvb/frontends/stb6100_cfg.h
rename to drivers/media/dvb-frontends/stb6100_cfg.h
diff --git a/drivers/media/dvb/frontends/stb6100_proc.h b/drivers/media/dvb-frontends/stb6100_proc.h
similarity index 100%
rename from drivers/media/dvb/frontends/stb6100_proc.h
rename to drivers/media/dvb-frontends/stb6100_proc.h
diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
similarity index 100%
rename from drivers/media/dvb/frontends/stv0288.c
rename to drivers/media/dvb-frontends/stv0288.c
diff --git a/drivers/media/dvb/frontends/stv0288.h b/drivers/media/dvb-frontends/stv0288.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv0288.h
rename to drivers/media/dvb-frontends/stv0288.h
diff --git a/drivers/media/dvb/frontends/stv0297.c b/drivers/media/dvb-frontends/stv0297.c
similarity index 100%
rename from drivers/media/dvb/frontends/stv0297.c
rename to drivers/media/dvb-frontends/stv0297.c
diff --git a/drivers/media/dvb/frontends/stv0297.h b/drivers/media/dvb-frontends/stv0297.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv0297.h
rename to drivers/media/dvb-frontends/stv0297.h
diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
similarity index 100%
rename from drivers/media/dvb/frontends/stv0299.c
rename to drivers/media/dvb-frontends/stv0299.c
diff --git a/drivers/media/dvb/frontends/stv0299.h b/drivers/media/dvb-frontends/stv0299.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv0299.h
rename to drivers/media/dvb-frontends/stv0299.h
diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
similarity index 100%
rename from drivers/media/dvb/frontends/stv0367.c
rename to drivers/media/dvb-frontends/stv0367.c
diff --git a/drivers/media/dvb/frontends/stv0367.h b/drivers/media/dvb-frontends/stv0367.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv0367.h
rename to drivers/media/dvb-frontends/stv0367.h
diff --git a/drivers/media/dvb/frontends/stv0367_priv.h b/drivers/media/dvb-frontends/stv0367_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv0367_priv.h
rename to drivers/media/dvb-frontends/stv0367_priv.h
diff --git a/drivers/media/dvb/frontends/stv0367_regs.h b/drivers/media/dvb-frontends/stv0367_regs.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv0367_regs.h
rename to drivers/media/dvb-frontends/stv0367_regs.h
diff --git a/drivers/media/dvb/frontends/stv0900.h b/drivers/media/dvb-frontends/stv0900.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv0900.h
rename to drivers/media/dvb-frontends/stv0900.h
diff --git a/drivers/media/dvb/frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
similarity index 100%
rename from drivers/media/dvb/frontends/stv0900_core.c
rename to drivers/media/dvb-frontends/stv0900_core.c
diff --git a/drivers/media/dvb/frontends/stv0900_init.h b/drivers/media/dvb-frontends/stv0900_init.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv0900_init.h
rename to drivers/media/dvb-frontends/stv0900_init.h
diff --git a/drivers/media/dvb/frontends/stv0900_priv.h b/drivers/media/dvb-frontends/stv0900_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv0900_priv.h
rename to drivers/media/dvb-frontends/stv0900_priv.h
diff --git a/drivers/media/dvb/frontends/stv0900_reg.h b/drivers/media/dvb-frontends/stv0900_reg.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv0900_reg.h
rename to drivers/media/dvb-frontends/stv0900_reg.h
diff --git a/drivers/media/dvb/frontends/stv0900_sw.c b/drivers/media/dvb-frontends/stv0900_sw.c
similarity index 100%
rename from drivers/media/dvb/frontends/stv0900_sw.c
rename to drivers/media/dvb-frontends/stv0900_sw.c
diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
similarity index 100%
rename from drivers/media/dvb/frontends/stv090x.c
rename to drivers/media/dvb-frontends/stv090x.c
diff --git a/drivers/media/dvb/frontends/stv090x.h b/drivers/media/dvb-frontends/stv090x.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv090x.h
rename to drivers/media/dvb-frontends/stv090x.h
diff --git a/drivers/media/dvb/frontends/stv090x_priv.h b/drivers/media/dvb-frontends/stv090x_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv090x_priv.h
rename to drivers/media/dvb-frontends/stv090x_priv.h
diff --git a/drivers/media/dvb/frontends/stv090x_reg.h b/drivers/media/dvb-frontends/stv090x_reg.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv090x_reg.h
rename to drivers/media/dvb-frontends/stv090x_reg.h
diff --git a/drivers/media/dvb/frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
similarity index 100%
rename from drivers/media/dvb/frontends/stv6110.c
rename to drivers/media/dvb-frontends/stv6110.c
diff --git a/drivers/media/dvb/frontends/stv6110.h b/drivers/media/dvb-frontends/stv6110.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv6110.h
rename to drivers/media/dvb-frontends/stv6110.h
diff --git a/drivers/media/dvb/frontends/stv6110x.c b/drivers/media/dvb-frontends/stv6110x.c
similarity index 100%
rename from drivers/media/dvb/frontends/stv6110x.c
rename to drivers/media/dvb-frontends/stv6110x.c
diff --git a/drivers/media/dvb/frontends/stv6110x.h b/drivers/media/dvb-frontends/stv6110x.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv6110x.h
rename to drivers/media/dvb-frontends/stv6110x.h
diff --git a/drivers/media/dvb/frontends/stv6110x_priv.h b/drivers/media/dvb-frontends/stv6110x_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv6110x_priv.h
rename to drivers/media/dvb-frontends/stv6110x_priv.h
diff --git a/drivers/media/dvb/frontends/stv6110x_reg.h b/drivers/media/dvb-frontends/stv6110x_reg.h
similarity index 100%
rename from drivers/media/dvb/frontends/stv6110x_reg.h
rename to drivers/media/dvb-frontends/stv6110x_reg.h
diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb-frontends/tda10021.c
similarity index 100%
rename from drivers/media/dvb/frontends/tda10021.c
rename to drivers/media/dvb-frontends/tda10021.c
diff --git a/drivers/media/dvb/frontends/tda10023.c b/drivers/media/dvb-frontends/tda10023.c
similarity index 100%
rename from drivers/media/dvb/frontends/tda10023.c
rename to drivers/media/dvb-frontends/tda10023.c
diff --git a/drivers/media/dvb/frontends/tda1002x.h b/drivers/media/dvb-frontends/tda1002x.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda1002x.h
rename to drivers/media/dvb-frontends/tda1002x.h
diff --git a/drivers/media/dvb/frontends/tda10048.c b/drivers/media/dvb-frontends/tda10048.c
similarity index 100%
rename from drivers/media/dvb/frontends/tda10048.c
rename to drivers/media/dvb-frontends/tda10048.c
diff --git a/drivers/media/dvb/frontends/tda10048.h b/drivers/media/dvb-frontends/tda10048.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda10048.h
rename to drivers/media/dvb-frontends/tda10048.h
diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb-frontends/tda1004x.c
similarity index 100%
rename from drivers/media/dvb/frontends/tda1004x.c
rename to drivers/media/dvb-frontends/tda1004x.c
diff --git a/drivers/media/dvb/frontends/tda1004x.h b/drivers/media/dvb-frontends/tda1004x.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda1004x.h
rename to drivers/media/dvb-frontends/tda1004x.h
diff --git a/drivers/media/dvb/frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
similarity index 100%
rename from drivers/media/dvb/frontends/tda10071.c
rename to drivers/media/dvb-frontends/tda10071.c
diff --git a/drivers/media/dvb/frontends/tda10071.h b/drivers/media/dvb-frontends/tda10071.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda10071.h
rename to drivers/media/dvb-frontends/tda10071.h
diff --git a/drivers/media/dvb/frontends/tda10071_priv.h b/drivers/media/dvb-frontends/tda10071_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda10071_priv.h
rename to drivers/media/dvb-frontends/tda10071_priv.h
diff --git a/drivers/media/dvb/frontends/tda10086.c b/drivers/media/dvb-frontends/tda10086.c
similarity index 100%
rename from drivers/media/dvb/frontends/tda10086.c
rename to drivers/media/dvb-frontends/tda10086.c
diff --git a/drivers/media/dvb/frontends/tda10086.h b/drivers/media/dvb-frontends/tda10086.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda10086.h
rename to drivers/media/dvb-frontends/tda10086.h
diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
similarity index 100%
rename from drivers/media/dvb/frontends/tda18271c2dd.c
rename to drivers/media/dvb-frontends/tda18271c2dd.c
diff --git a/drivers/media/dvb/frontends/tda18271c2dd.h b/drivers/media/dvb-frontends/tda18271c2dd.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda18271c2dd.h
rename to drivers/media/dvb-frontends/tda18271c2dd.h
diff --git a/drivers/media/dvb/frontends/tda18271c2dd_maps.h b/drivers/media/dvb-frontends/tda18271c2dd_maps.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda18271c2dd_maps.h
rename to drivers/media/dvb-frontends/tda18271c2dd_maps.h
diff --git a/drivers/media/dvb/frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
similarity index 100%
rename from drivers/media/dvb/frontends/tda665x.c
rename to drivers/media/dvb-frontends/tda665x.c
diff --git a/drivers/media/dvb/frontends/tda665x.h b/drivers/media/dvb-frontends/tda665x.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda665x.h
rename to drivers/media/dvb-frontends/tda665x.h
diff --git a/drivers/media/dvb/frontends/tda8083.c b/drivers/media/dvb-frontends/tda8083.c
similarity index 100%
rename from drivers/media/dvb/frontends/tda8083.c
rename to drivers/media/dvb-frontends/tda8083.c
diff --git a/drivers/media/dvb/frontends/tda8083.h b/drivers/media/dvb-frontends/tda8083.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda8083.h
rename to drivers/media/dvb-frontends/tda8083.h
diff --git a/drivers/media/dvb/frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
similarity index 100%
rename from drivers/media/dvb/frontends/tda8261.c
rename to drivers/media/dvb-frontends/tda8261.c
diff --git a/drivers/media/dvb/frontends/tda8261.h b/drivers/media/dvb-frontends/tda8261.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda8261.h
rename to drivers/media/dvb-frontends/tda8261.h
diff --git a/drivers/media/dvb/frontends/tda8261_cfg.h b/drivers/media/dvb-frontends/tda8261_cfg.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda8261_cfg.h
rename to drivers/media/dvb-frontends/tda8261_cfg.h
diff --git a/drivers/media/dvb/frontends/tda826x.c b/drivers/media/dvb-frontends/tda826x.c
similarity index 100%
rename from drivers/media/dvb/frontends/tda826x.c
rename to drivers/media/dvb-frontends/tda826x.c
diff --git a/drivers/media/dvb/frontends/tda826x.h b/drivers/media/dvb-frontends/tda826x.h
similarity index 100%
rename from drivers/media/dvb/frontends/tda826x.h
rename to drivers/media/dvb-frontends/tda826x.h
diff --git a/drivers/media/dvb/frontends/tdhd1.h b/drivers/media/dvb-frontends/tdhd1.h
similarity index 100%
rename from drivers/media/dvb/frontends/tdhd1.h
rename to drivers/media/dvb-frontends/tdhd1.h
diff --git a/drivers/media/dvb/frontends/tua6100.c b/drivers/media/dvb-frontends/tua6100.c
similarity index 100%
rename from drivers/media/dvb/frontends/tua6100.c
rename to drivers/media/dvb-frontends/tua6100.c
diff --git a/drivers/media/dvb/frontends/tua6100.h b/drivers/media/dvb-frontends/tua6100.h
similarity index 100%
rename from drivers/media/dvb/frontends/tua6100.h
rename to drivers/media/dvb-frontends/tua6100.h
diff --git a/drivers/media/dvb/frontends/ves1820.c b/drivers/media/dvb-frontends/ves1820.c
similarity index 100%
rename from drivers/media/dvb/frontends/ves1820.c
rename to drivers/media/dvb-frontends/ves1820.c
diff --git a/drivers/media/dvb/frontends/ves1820.h b/drivers/media/dvb-frontends/ves1820.h
similarity index 100%
rename from drivers/media/dvb/frontends/ves1820.h
rename to drivers/media/dvb-frontends/ves1820.h
diff --git a/drivers/media/dvb/frontends/ves1x93.c b/drivers/media/dvb-frontends/ves1x93.c
similarity index 100%
rename from drivers/media/dvb/frontends/ves1x93.c
rename to drivers/media/dvb-frontends/ves1x93.c
diff --git a/drivers/media/dvb/frontends/ves1x93.h b/drivers/media/dvb-frontends/ves1x93.h
similarity index 100%
rename from drivers/media/dvb/frontends/ves1x93.h
rename to drivers/media/dvb-frontends/ves1x93.h
diff --git a/drivers/media/dvb/frontends/z0194a.h b/drivers/media/dvb-frontends/z0194a.h
similarity index 100%
rename from drivers/media/dvb/frontends/z0194a.h
rename to drivers/media/dvb-frontends/z0194a.h
diff --git a/drivers/media/dvb/frontends/zl10036.c b/drivers/media/dvb-frontends/zl10036.c
similarity index 100%
rename from drivers/media/dvb/frontends/zl10036.c
rename to drivers/media/dvb-frontends/zl10036.c
diff --git a/drivers/media/dvb/frontends/zl10036.h b/drivers/media/dvb-frontends/zl10036.h
similarity index 100%
rename from drivers/media/dvb/frontends/zl10036.h
rename to drivers/media/dvb-frontends/zl10036.h
diff --git a/drivers/media/dvb/frontends/zl10039.c b/drivers/media/dvb-frontends/zl10039.c
similarity index 100%
rename from drivers/media/dvb/frontends/zl10039.c
rename to drivers/media/dvb-frontends/zl10039.c
diff --git a/drivers/media/dvb/frontends/zl10039.h b/drivers/media/dvb-frontends/zl10039.h
similarity index 100%
rename from drivers/media/dvb/frontends/zl10039.h
rename to drivers/media/dvb-frontends/zl10039.h
diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb-frontends/zl10353.c
similarity index 100%
rename from drivers/media/dvb/frontends/zl10353.c
rename to drivers/media/dvb-frontends/zl10353.c
diff --git a/drivers/media/dvb/frontends/zl10353.h b/drivers/media/dvb-frontends/zl10353.h
similarity index 100%
rename from drivers/media/dvb/frontends/zl10353.h
rename to drivers/media/dvb-frontends/zl10353.h
diff --git a/drivers/media/dvb/frontends/zl10353_priv.h b/drivers/media/dvb-frontends/zl10353_priv.h
similarity index 100%
rename from drivers/media/dvb/frontends/zl10353_priv.h
rename to drivers/media/dvb-frontends/zl10353_priv.h
diff --git a/drivers/media/dvb/Kconfig b/drivers/media/dvb/Kconfig
index 1b2ac47..874ff53 100644
--- a/drivers/media/dvb/Kconfig
+++ b/drivers/media/dvb/Kconfig
@@ -58,8 +58,4 @@ comment "Supported ddbridge ('Octopus') Adapters"
 	depends on DVB_CORE && PCI && I2C
 	source "drivers/media/dvb/ddbridge/Kconfig"
 
-comment "Supported DVB Frontends"
-	depends on DVB_CORE
-source "drivers/media/dvb/frontends/Kconfig"
-
 endif # DVB_CAPTURE_DRIVERS
diff --git a/drivers/media/dvb/Makefile b/drivers/media/dvb/Makefile
index 4ac62b7..352adaa 100644
--- a/drivers/media/dvb/Makefile
+++ b/drivers/media/dvb/Makefile
@@ -2,8 +2,7 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
-obj-y        :=	frontends/	\
-		ttpci/		\
+obj-y        :=	ttpci/		\
 		ttusb-dec/	\
 		ttusb-budget/	\
 		b2c2/		\
diff --git a/drivers/media/dvb/b2c2/Makefile b/drivers/media/dvb/b2c2/Makefile
index e4291e4..7a1f5ce 100644
--- a/drivers/media/dvb/b2c2/Makefile
+++ b/drivers/media/dvb/b2c2/Makefile
@@ -12,5 +12,5 @@ obj-$(CONFIG_DVB_B2C2_FLEXCOP_PCI) += b2c2-flexcop-pci.o
 b2c2-flexcop-usb-objs = flexcop-usb.o
 obj-$(CONFIG_DVB_B2C2_FLEXCOP_USB) += b2c2-flexcop-usb.o
 
-ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends/
 ccflags-y += -Idrivers/media/common/tuners/
diff --git a/drivers/media/dvb/bt8xx/Makefile b/drivers/media/dvb/bt8xx/Makefile
index 7c2dd04..36591ae 100644
--- a/drivers/media/dvb/bt8xx/Makefile
+++ b/drivers/media/dvb/bt8xx/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
 
 ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-frontends
 ccflags-y += -Idrivers/media/video/bt8xx
 ccflags-y += -Idrivers/media/common/tuners
diff --git a/drivers/media/dvb/ddbridge/Makefile b/drivers/media/dvb/ddbridge/Makefile
index 9eca27d..9d083c9 100644
--- a/drivers/media/dvb/ddbridge/Makefile
+++ b/drivers/media/dvb/ddbridge/Makefile
@@ -7,7 +7,7 @@ ddbridge-objs := ddbridge-core.o
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
 ccflags-y += -Idrivers/media/dvb-core/
-ccflags-y += -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb-frontends/
 ccflags-y += -Idrivers/media/common/tuners/
 
 # For the staging CI driver cxd2099
diff --git a/drivers/media/dvb/dm1105/Makefile b/drivers/media/dvb/dm1105/Makefile
index 0dc5963..3275851 100644
--- a/drivers/media/dvb/dm1105/Makefile
+++ b/drivers/media/dvb/dm1105/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_DVB_DM1105) += dm1105.o
 
-ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index 90deca2..23de51d 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -114,7 +114,7 @@ dvb-usb-af9035-objs = af9035.o
 obj-$(CONFIG_DVB_USB_AF9035) += dvb-usb-af9035.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
-ccflags-y += -I$(srctree)/drivers/media/dvb/frontends/
+ccflags-y += -I$(srctree)/drivers/media/dvb-frontends/
 # due to tuner-xc3028
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb/ttpci
diff --git a/drivers/media/dvb/mantis/Makefile b/drivers/media/dvb/mantis/Makefile
index 3384119..f715051 100644
--- a/drivers/media/dvb/mantis/Makefile
+++ b/drivers/media/dvb/mantis/Makefile
@@ -25,4 +25,4 @@ obj-$(CONFIG_MANTIS_CORE)	+= mantis_core.o
 obj-$(CONFIG_DVB_MANTIS)	+= mantis.o
 obj-$(CONFIG_DVB_HOPPER)	+= hopper.o
 
-ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends/
diff --git a/drivers/media/dvb/ngene/Makefile b/drivers/media/dvb/ngene/Makefile
index dae7659..6399708 100644
--- a/drivers/media/dvb/ngene/Makefile
+++ b/drivers/media/dvb/ngene/Makefile
@@ -7,7 +7,7 @@ ngene-objs := ngene-core.o ngene-i2c.o ngene-cards.o ngene-dvb.o
 obj-$(CONFIG_DVB_NGENE) += ngene.o
 
 ccflags-y += -Idrivers/media/dvb-core/
-ccflags-y += -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb-frontends/
 ccflags-y += -Idrivers/media/common/tuners/
 
 # For the staging CI driver cxd2099
diff --git a/drivers/media/dvb/pluto2/Makefile b/drivers/media/dvb/pluto2/Makefile
index 14fa578..524bf84 100644
--- a/drivers/media/dvb/pluto2/Makefile
+++ b/drivers/media/dvb/pluto2/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_DVB_PLUTO2) += pluto2.o
 
-ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends/
diff --git a/drivers/media/dvb/pt1/Makefile b/drivers/media/dvb/pt1/Makefile
index c80492a..98e3912 100644
--- a/drivers/media/dvb/pt1/Makefile
+++ b/drivers/media/dvb/pt1/Makefile
@@ -2,4 +2,4 @@ earth-pt1-objs := pt1.o va1j5jf8007s.o va1j5jf8007t.o
 
 obj-$(CONFIG_DVB_PT1) += earth-pt1.o
 
-ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb-frontends
diff --git a/drivers/media/dvb/ttpci/Makefile b/drivers/media/dvb/ttpci/Makefile
index b0ddb45..22a235f 100644
--- a/drivers/media/dvb/ttpci/Makefile
+++ b/drivers/media/dvb/ttpci/Makefile
@@ -17,5 +17,5 @@ obj-$(CONFIG_DVB_BUDGET_CI) += budget-ci.o
 obj-$(CONFIG_DVB_BUDGET_PATCH) += budget-patch.o
 obj-$(CONFIG_DVB_AV7110) += dvb-ttpci.o
 
-ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends/
 ccflags-y += -Idrivers/media/common/tuners
diff --git a/drivers/media/dvb/ttusb-budget/Makefile b/drivers/media/dvb/ttusb-budget/Makefile
index c5abe78..f47bbf6 100644
--- a/drivers/media/dvb/ttusb-budget/Makefile
+++ b/drivers/media/dvb/ttusb-budget/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_DVB_TTUSB_BUDGET) += dvb-ttusb-budget.o
 
-ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index f5036d1..74b65ea 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -30,6 +30,6 @@ obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG) += videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG) += videobuf2-dma-sg.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
-ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
+ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
 
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index d8ffba9..17d729d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -186,5 +186,5 @@ obj-y	+= davinci/
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
-ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
+ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
diff --git a/drivers/media/video/au0828/Makefile b/drivers/media/video/au0828/Makefile
index 59d15b3..61b69e6 100644
--- a/drivers/media/video/au0828/Makefile
+++ b/drivers/media/video/au0828/Makefile
@@ -4,6 +4,6 @@ obj-$(CONFIG_VIDEO_AU0828) += au0828.o
 
 ccflags-y += -Idrivers/media/common/tuners
 ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-frontends
 
 ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/cx18/Makefile b/drivers/media/video/cx18/Makefile
index e0701e9..db5ab12 100644
--- a/drivers/media/video/cx18/Makefile
+++ b/drivers/media/video/cx18/Makefile
@@ -9,5 +9,5 @@ obj-$(CONFIG_VIDEO_CX18) += cx18.o
 obj-$(CONFIG_VIDEO_CX18_ALSA) += cx18-alsa.o
 
 ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-frontends
 ccflags-y += -Idrivers/media/common/tuners
diff --git a/drivers/media/video/cx231xx/Makefile b/drivers/media/video/cx231xx/Makefile
index fc72cad..2697325 100644
--- a/drivers/media/video/cx231xx/Makefile
+++ b/drivers/media/video/cx231xx/Makefile
@@ -11,6 +11,6 @@ obj-$(CONFIG_VIDEO_CX231XX_DVB) += cx231xx-dvb.o
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
 ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-frontends
 ccflags-y += -Idrivers/media/dvb/dvb-usb
 
diff --git a/drivers/media/video/cx23885/Makefile b/drivers/media/video/cx23885/Makefile
index 3608f32..8f82e01 100644
--- a/drivers/media/video/cx23885/Makefile
+++ b/drivers/media/video/cx23885/Makefile
@@ -10,6 +10,6 @@ obj-$(CONFIG_MEDIA_ALTERA_CI) += altera-ci.o
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
 ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-frontends
 
 ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/cx25821/Makefile b/drivers/media/video/cx25821/Makefile
index 1628aa3..af23e0c 100644
--- a/drivers/media/video/cx25821/Makefile
+++ b/drivers/media/video/cx25821/Makefile
@@ -10,4 +10,4 @@ obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
 ccflags-y := -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
 ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/video/cx88/Makefile b/drivers/media/video/cx88/Makefile
index 1902366..5c4d306 100644
--- a/drivers/media/video/cx88/Makefile
+++ b/drivers/media/video/cx88/Makefile
@@ -13,4 +13,4 @@ obj-$(CONFIG_VIDEO_CX88_VP3054) += cx88-vp3054-i2c.o
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
 ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/video/em28xx/Makefile b/drivers/media/video/em28xx/Makefile
index b00298a..f4118d2 100644
--- a/drivers/media/video/em28xx/Makefile
+++ b/drivers/media/video/em28xx/Makefile
@@ -12,4 +12,4 @@ obj-$(CONFIG_VIDEO_EM28XX_RC) += em28xx-rc.o
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
 ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/video/ivtv/Makefile b/drivers/media/video/ivtv/Makefile
index c54cfe1..0015bd4 100644
--- a/drivers/media/video/ivtv/Makefile
+++ b/drivers/media/video/ivtv/Makefile
@@ -10,5 +10,5 @@ obj-$(CONFIG_VIDEO_FB_IVTV) += ivtvfb.o
 ccflags-y += -I$(srctree)/drivers/media/video
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
-ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
+ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 
diff --git a/drivers/media/video/pvrusb2/Makefile b/drivers/media/video/pvrusb2/Makefile
index 298a930..1458797 100644
--- a/drivers/media/video/pvrusb2/Makefile
+++ b/drivers/media/video/pvrusb2/Makefile
@@ -19,4 +19,4 @@ obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2.o
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
 ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/video/saa7134/Makefile b/drivers/media/video/saa7134/Makefile
index 364891f..7af78a8 100644
--- a/drivers/media/video/saa7134/Makefile
+++ b/drivers/media/video/saa7134/Makefile
@@ -13,4 +13,4 @@ obj-$(CONFIG_VIDEO_SAA7134_DVB) += saa7134-dvb.o
 ccflags-y += -I$(srctree)/drivers/media/video
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
-ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
+ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/video/saa7164/Makefile b/drivers/media/video/saa7164/Makefile
index 50e19f9..d8ed33d 100644
--- a/drivers/media/video/saa7164/Makefile
+++ b/drivers/media/video/saa7164/Makefile
@@ -7,6 +7,6 @@ obj-$(CONFIG_VIDEO_SAA7164) += saa7164.o
 ccflags-y += -I$(srctree)/drivers/media/video
 ccflags-y += -I$(srctree)/drivers/media/common/tuners
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
-ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
+ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 
 ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
diff --git a/drivers/media/video/tlg2300/Makefile b/drivers/media/video/tlg2300/Makefile
index f0f4f6a..268d825 100644
--- a/drivers/media/video/tlg2300/Makefile
+++ b/drivers/media/video/tlg2300/Makefile
@@ -5,5 +5,5 @@ obj-$(CONFIG_VIDEO_TLG2300) += poseidon.o
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
 ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-frontends
 
diff --git a/drivers/media/video/tm6000/Makefile b/drivers/media/video/tm6000/Makefile
index b797a8a..56cbcba 100644
--- a/drivers/media/video/tm6000/Makefile
+++ b/drivers/media/video/tm6000/Makefile
@@ -12,4 +12,4 @@ obj-$(CONFIG_VIDEO_TM6000_DVB) += tm6000-dvb.o
 ccflags-y := -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
 ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/staging/media/cxd2099/Makefile b/drivers/staging/media/cxd2099/Makefile
index b0833fa..eb6bc59 100644
--- a/drivers/staging/media/cxd2099/Makefile
+++ b/drivers/staging/media/cxd2099/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_DVB_CXD2099) += cxd2099.o
 
 ccflags-y += -Idrivers/media/dvb-core/
-ccflags-y += -Idrivers/media/dvb/frontends/
+ccflags-y += -Idrivers/media/dvb-frontends/
 ccflags-y += -Idrivers/media/common/tuners/
diff --git a/drivers/staging/media/go7007/Makefile b/drivers/staging/media/go7007/Makefile
index eea1e72..f654ddc 100644
--- a/drivers/staging/media/go7007/Makefile
+++ b/drivers/staging/media/go7007/Makefile
@@ -26,5 +26,5 @@ s2250-y := s2250-board.o
 # S2250 needs cypress ezusb loader from dvb-usb
 ccflags-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD:m=y) += -Idrivers/media/dvb/dvb-usb
 
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb-frontends
 ccflags-y += -Idrivers/media/dvb-core
-- 
1.7.10.2


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:58834 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750929AbdL2JnQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 04:43:16 -0500
Date: Fri, 29 Dec 2017 11:43:09 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux1394-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] media: move dvb kAPI headers to include/media
Message-ID: <20171229094308.rj2ar2euzgls3yui@kekkonen.localdomain>
References: <fada1935590f66dc6784981e0d557ca09013c847.1514488526.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fada1935590f66dc6784981e0d557ca09013c847.1514488526.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Dropping non-list recipients, this didn't make it to e.g. linux-media.

On Thu, Dec 28, 2017 at 02:21:48PM -0500, Mauro Carvalho Chehab wrote:
> Except for DVB, all media kAPI headers are at include/media.
> 
> Move the headers to it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

I didn't look at all the details but for the change on high level:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> ---
>  Documentation/media/kapi/dtv-ca.rst                        |  2 +-
>  Documentation/media/kapi/dtv-common.rst                    |  6 +++---
>  Documentation/media/kapi/dtv-demux.rst                     |  8 ++++----
>  Documentation/media/kapi/dtv-frontend.rst                  |  8 ++++----
>  Documentation/media/kapi/dtv-net.rst                       |  2 +-
>  drivers/media/common/b2c2/Makefile                         |  1 -
>  drivers/media/common/b2c2/flexcop-common.h                 |  8 ++++----
>  drivers/media/common/siano/Makefile                        |  4 ----
>  drivers/media/common/siano/smsdvb-debugfs.c                |  8 ++++----
>  drivers/media/common/siano/smsdvb-main.c                   |  8 ++++----
>  drivers/media/dvb-core/dmxdev.c                            |  4 ++--
>  drivers/media/dvb-core/dvb_ca_en50221.c                    |  4 ++--
>  drivers/media/dvb-core/dvb_demux.c                         |  2 +-
>  drivers/media/dvb-core/dvb_frontend.c                      |  4 ++--
>  drivers/media/dvb-core/dvb_math.c                          |  2 +-
>  drivers/media/dvb-core/dvb_net.c                           |  4 ++--
>  drivers/media/dvb-core/dvb_ringbuffer.c                    |  2 +-
>  drivers/media/dvb-core/dvb_vb2.c                           |  4 ++--
>  drivers/media/dvb-core/dvbdev.c                            |  2 +-
>  drivers/media/dvb-frontends/Makefile                       |  1 -
>  drivers/media/dvb-frontends/a8293.h                        |  2 +-
>  drivers/media/dvb-frontends/af9013_priv.h                  |  2 +-
>  drivers/media/dvb-frontends/af9033_priv.h                  |  4 ++--
>  drivers/media/dvb-frontends/as102_fe.c                     |  2 +-
>  drivers/media/dvb-frontends/ascot2e.c                      |  2 +-
>  drivers/media/dvb-frontends/atbm8830.c                     |  2 +-
>  drivers/media/dvb-frontends/au8522_common.c                |  2 +-
>  drivers/media/dvb-frontends/au8522_dig.c                   |  2 +-
>  drivers/media/dvb-frontends/au8522_priv.h                  |  2 +-
>  drivers/media/dvb-frontends/bcm3510.c                      |  2 +-
>  drivers/media/dvb-frontends/cx22700.c                      |  2 +-
>  drivers/media/dvb-frontends/cx22702.c                      |  2 +-
>  drivers/media/dvb-frontends/cx24110.c                      |  2 +-
>  drivers/media/dvb-frontends/cx24113.c                      |  2 +-
>  drivers/media/dvb-frontends/cx24116.c                      |  2 +-
>  drivers/media/dvb-frontends/cx24117.c                      |  2 +-
>  drivers/media/dvb-frontends/cx24120.c                      |  2 +-
>  drivers/media/dvb-frontends/cx24123.c                      |  2 +-
>  drivers/media/dvb-frontends/cxd2820r_priv.h                |  4 ++--
>  drivers/media/dvb-frontends/cxd2841er.c                    |  4 ++--
>  drivers/media/dvb-frontends/dib0070.c                      |  2 +-
>  drivers/media/dvb-frontends/dib0090.c                      |  2 +-
>  drivers/media/dvb-frontends/dib3000mb.c                    |  2 +-
>  drivers/media/dvb-frontends/dib3000mc.c                    |  2 +-
>  drivers/media/dvb-frontends/dib7000m.c                     |  2 +-
>  drivers/media/dvb-frontends/dib7000p.c                     |  4 ++--
>  drivers/media/dvb-frontends/dib8000.c                      |  4 ++--
>  drivers/media/dvb-frontends/dib9000.c                      |  4 ++--
>  drivers/media/dvb-frontends/drx39xyj/Makefile              |  1 -
>  drivers/media/dvb-frontends/drx39xyj/drx39xxj.h            |  2 +-
>  drivers/media/dvb-frontends/drx39xyj/drxj.c                |  2 +-
>  drivers/media/dvb-frontends/drxd_hard.c                    |  2 +-
>  drivers/media/dvb-frontends/drxk_hard.c                    |  4 ++--
>  drivers/media/dvb-frontends/ds3000.c                       |  2 +-
>  drivers/media/dvb-frontends/dvb-pll.h                      |  2 +-
>  drivers/media/dvb-frontends/dvb_dummy_fe.c                 |  2 +-
>  drivers/media/dvb-frontends/dvb_dummy_fe.h                 |  2 +-
>  drivers/media/dvb-frontends/ec100.c                        |  2 +-
>  drivers/media/dvb-frontends/gp8psk-fe.c                    |  2 +-
>  drivers/media/dvb-frontends/helene.c                       |  2 +-
>  drivers/media/dvb-frontends/horus3a.c                      |  2 +-
>  drivers/media/dvb-frontends/isl6405.c                      |  2 +-
>  drivers/media/dvb-frontends/isl6421.c                      |  2 +-
>  drivers/media/dvb-frontends/isl6423.c                      |  2 +-
>  drivers/media/dvb-frontends/itd1000.c                      |  2 +-
>  drivers/media/dvb-frontends/ix2505v.h                      |  2 +-
>  drivers/media/dvb-frontends/l64781.c                       |  2 +-
>  drivers/media/dvb-frontends/lg2160.h                       |  2 +-
>  drivers/media/dvb-frontends/lgdt3305.c                     |  2 +-
>  drivers/media/dvb-frontends/lgdt3305.h                     |  2 +-
>  drivers/media/dvb-frontends/lgdt3306a.c                    |  2 +-
>  drivers/media/dvb-frontends/lgdt3306a.h                    |  2 +-
>  drivers/media/dvb-frontends/lgdt330x.c                     |  4 ++--
>  drivers/media/dvb-frontends/lgs8gl5.c                      |  2 +-
>  drivers/media/dvb-frontends/lgs8gxx.c                      |  2 +-
>  drivers/media/dvb-frontends/lnbh25.c                       |  2 +-
>  drivers/media/dvb-frontends/lnbp21.c                       |  2 +-
>  drivers/media/dvb-frontends/lnbp22.c                       |  2 +-
>  drivers/media/dvb-frontends/m88ds3103_priv.h               |  4 ++--
>  drivers/media/dvb-frontends/m88rs2000.c                    |  2 +-
>  drivers/media/dvb-frontends/m88rs2000.h                    |  2 +-
>  drivers/media/dvb-frontends/mb86a16.c                      |  2 +-
>  drivers/media/dvb-frontends/mb86a16.h                      |  2 +-
>  drivers/media/dvb-frontends/mb86a20s.c                     |  2 +-
>  drivers/media/dvb-frontends/mn88472_priv.h                 |  4 ++--
>  drivers/media/dvb-frontends/mn88473_priv.h                 |  4 ++--
>  drivers/media/dvb-frontends/mt312.c                        |  2 +-
>  drivers/media/dvb-frontends/mt352.c                        |  2 +-
>  drivers/media/dvb-frontends/mxl5xx.c                       |  2 +-
>  drivers/media/dvb-frontends/mxl5xx.h                       |  2 +-
>  drivers/media/dvb-frontends/nxt200x.c                      |  2 +-
>  drivers/media/dvb-frontends/nxt6000.c                      |  2 +-
>  drivers/media/dvb-frontends/or51132.c                      |  4 ++--
>  drivers/media/dvb-frontends/or51211.c                      |  4 ++--
>  drivers/media/dvb-frontends/rtl2830_priv.h                 |  4 ++--
>  drivers/media/dvb-frontends/rtl2832_priv.h                 |  4 ++--
>  drivers/media/dvb-frontends/rtl2832_sdr.h                  |  2 +-
>  drivers/media/dvb-frontends/s5h1409.c                      |  2 +-
>  drivers/media/dvb-frontends/s5h1411.c                      |  2 +-
>  drivers/media/dvb-frontends/s5h1420.c                      |  2 +-
>  drivers/media/dvb-frontends/s5h1432.c                      |  2 +-
>  drivers/media/dvb-frontends/s921.c                         |  2 +-
>  drivers/media/dvb-frontends/si2165.c                       |  4 ++--
>  drivers/media/dvb-frontends/si2168_priv.h                  |  2 +-
>  drivers/media/dvb-frontends/si21xx.c                       |  2 +-
>  drivers/media/dvb-frontends/si21xx.h                       |  2 +-
>  drivers/media/dvb-frontends/sp2.h                          |  2 +-
>  drivers/media/dvb-frontends/sp2_priv.h                     |  2 +-
>  drivers/media/dvb-frontends/sp8870.c                       |  2 +-
>  drivers/media/dvb-frontends/sp887x.c                       |  2 +-
>  drivers/media/dvb-frontends/stb0899_drv.c                  |  2 +-
>  drivers/media/dvb-frontends/stb0899_drv.h                  |  2 +-
>  drivers/media/dvb-frontends/stb0899_priv.h                 |  2 +-
>  drivers/media/dvb-frontends/stb6000.h                      |  2 +-
>  drivers/media/dvb-frontends/stb6100.c                      |  2 +-
>  drivers/media/dvb-frontends/stb6100.h                      |  2 +-
>  drivers/media/dvb-frontends/stb6100_cfg.h                  |  2 +-
>  drivers/media/dvb-frontends/stb6100_proc.h                 |  2 +-
>  drivers/media/dvb-frontends/stv0288.c                      |  2 +-
>  drivers/media/dvb-frontends/stv0288.h                      |  2 +-
>  drivers/media/dvb-frontends/stv0297.c                      |  2 +-
>  drivers/media/dvb-frontends/stv0297.h                      |  2 +-
>  drivers/media/dvb-frontends/stv0299.c                      |  2 +-
>  drivers/media/dvb-frontends/stv0299.h                      |  2 +-
>  drivers/media/dvb-frontends/stv0367.c                      |  2 +-
>  drivers/media/dvb-frontends/stv0367.h                      |  2 +-
>  drivers/media/dvb-frontends/stv0900.h                      |  2 +-
>  drivers/media/dvb-frontends/stv090x.c                      |  2 +-
>  drivers/media/dvb-frontends/stv090x_priv.h                 |  2 +-
>  drivers/media/dvb-frontends/stv0910.c                      |  2 +-
>  drivers/media/dvb-frontends/stv6110.h                      |  2 +-
>  drivers/media/dvb-frontends/stv6110x.c                     |  2 +-
>  drivers/media/dvb-frontends/stv6111.c                      |  2 +-
>  drivers/media/dvb-frontends/tc90522.c                      |  2 +-
>  drivers/media/dvb-frontends/tc90522.h                      |  2 +-
>  drivers/media/dvb-frontends/tda10021.c                     |  2 +-
>  drivers/media/dvb-frontends/tda10023.c                     |  2 +-
>  drivers/media/dvb-frontends/tda10048.c                     |  4 ++--
>  drivers/media/dvb-frontends/tda1004x.c                     |  2 +-
>  drivers/media/dvb-frontends/tda10071_priv.h                |  2 +-
>  drivers/media/dvb-frontends/tda10086.c                     |  2 +-
>  drivers/media/dvb-frontends/tda18271c2dd.c                 |  2 +-
>  drivers/media/dvb-frontends/tda665x.c                      |  2 +-
>  drivers/media/dvb-frontends/tda8083.c                      |  2 +-
>  drivers/media/dvb-frontends/tda8261.c                      |  2 +-
>  drivers/media/dvb-frontends/tda826x.h                      |  2 +-
>  drivers/media/dvb-frontends/ts2020.c                       |  2 +-
>  drivers/media/dvb-frontends/tua6100.h                      |  2 +-
>  drivers/media/dvb-frontends/ves1820.c                      |  2 +-
>  drivers/media/dvb-frontends/ves1x93.c                      |  2 +-
>  drivers/media/dvb-frontends/zd1301_demod.h                 |  2 +-
>  drivers/media/dvb-frontends/zl10036.h                      |  2 +-
>  drivers/media/dvb-frontends/zl10039.c                      |  2 +-
>  drivers/media/dvb-frontends/zl10353.c                      |  2 +-
>  drivers/media/firewire/Makefile                            |  2 --
>  drivers/media/firewire/firedtv-avc.c                       |  2 +-
>  drivers/media/firewire/firedtv-ci.c                        |  2 +-
>  drivers/media/firewire/firedtv-dvb.c                       |  8 ++++----
>  drivers/media/firewire/firedtv-fe.c                        |  2 +-
>  drivers/media/firewire/firedtv-fw.c                        |  2 +-
>  drivers/media/firewire/firedtv.h                           | 12 ++++++------
>  drivers/media/mmc/siano/Makefile                           |  2 --
>  drivers/media/pci/b2c2/Makefile                            |  1 -
>  drivers/media/pci/bt8xx/Makefile                           |  1 -
>  drivers/media/pci/bt8xx/bt878.c                            |  4 ++--
>  drivers/media/pci/bt8xx/dst.c                              |  2 +-
>  drivers/media/pci/bt8xx/dst_ca.c                           |  4 ++--
>  drivers/media/pci/bt8xx/dvb-bt8xx.c                        |  8 ++++----
>  drivers/media/pci/bt8xx/dvb-bt8xx.h                        |  4 ++--
>  drivers/media/pci/cx18/Makefile                            |  1 -
>  drivers/media/pci/cx18/cx18-driver.h                       | 12 ++++++------
>  drivers/media/pci/cx23885/Makefile                         |  1 -
>  drivers/media/pci/cx23885/altera-ci.c                      |  6 +++---
>  drivers/media/pci/cx23885/cimax2.c                         |  2 +-
>  drivers/media/pci/cx23885/cimax2.h                         |  2 +-
>  drivers/media/pci/cx23885/cx23885-dvb.c                    |  2 +-
>  drivers/media/pci/cx88/Makefile                            |  1 -
>  drivers/media/pci/ddbridge/Makefile                        |  1 -
>  drivers/media/pci/ddbridge/ddbridge.h                      | 14 +++++++-------
>  drivers/media/pci/dm1105/Makefile                          |  2 +-
>  drivers/media/pci/dm1105/dm1105.c                          | 12 ++++++------
>  drivers/media/pci/ivtv/Makefile                            |  1 -
>  drivers/media/pci/mantis/Makefile                          |  2 +-
>  drivers/media/pci/mantis/hopper_cards.c                    | 10 +++++-----
>  drivers/media/pci/mantis/hopper_vp3028.c                   | 10 +++++-----
>  drivers/media/pci/mantis/mantis_ca.c                       | 10 +++++-----
>  drivers/media/pci/mantis/mantis_cards.c                    | 10 +++++-----
>  drivers/media/pci/mantis/mantis_dma.c                      | 10 +++++-----
>  drivers/media/pci/mantis/mantis_dvb.c                      | 10 +++++-----
>  drivers/media/pci/mantis/mantis_evm.c                      | 10 +++++-----
>  drivers/media/pci/mantis/mantis_hif.c                      | 10 +++++-----
>  drivers/media/pci/mantis/mantis_i2c.c                      | 10 +++++-----
>  drivers/media/pci/mantis/mantis_input.c                    | 10 +++++-----
>  drivers/media/pci/mantis/mantis_ioc.c                      | 10 +++++-----
>  drivers/media/pci/mantis/mantis_link.h                     |  2 +-
>  drivers/media/pci/mantis/mantis_pci.c                      | 10 +++++-----
>  drivers/media/pci/mantis/mantis_pcmcia.c                   | 10 +++++-----
>  drivers/media/pci/mantis/mantis_uart.c                     | 10 +++++-----
>  drivers/media/pci/mantis/mantis_vp1033.c                   | 10 +++++-----
>  drivers/media/pci/mantis/mantis_vp1034.c                   | 10 +++++-----
>  drivers/media/pci/mantis/mantis_vp1034.h                   |  2 +-
>  drivers/media/pci/mantis/mantis_vp1041.c                   | 10 +++++-----
>  drivers/media/pci/mantis/mantis_vp2033.c                   | 10 +++++-----
>  drivers/media/pci/mantis/mantis_vp2040.c                   | 10 +++++-----
>  drivers/media/pci/mantis/mantis_vp3028.h                   |  2 +-
>  drivers/media/pci/mantis/mantis_vp3030.c                   | 10 +++++-----
>  drivers/media/pci/netup_unidvb/Makefile                    |  1 -
>  drivers/media/pci/netup_unidvb/netup_unidvb.h              |  2 +-
>  drivers/media/pci/ngene/Makefile                           |  1 -
>  drivers/media/pci/ngene/ngene.h                            | 14 +++++++-------
>  drivers/media/pci/pluto2/Makefile                          |  2 +-
>  drivers/media/pci/pluto2/pluto2.c                          | 12 ++++++------
>  drivers/media/pci/pt1/Makefile                             |  2 +-
>  drivers/media/pci/pt1/pt1.c                                | 10 +++++-----
>  drivers/media/pci/pt1/va1j5jf8007s.c                       |  2 +-
>  drivers/media/pci/pt1/va1j5jf8007t.c                       |  4 ++--
>  drivers/media/pci/pt3/Makefile                             |  1 -
>  drivers/media/pci/pt3/pt3.c                                |  8 ++++----
>  drivers/media/pci/pt3/pt3.h                                |  6 +++---
>  drivers/media/pci/saa7134/Makefile                         |  1 -
>  drivers/media/pci/saa7134/saa7134-dvb.c                    |  2 +-
>  drivers/media/pci/saa7164/Makefile                         |  1 -
>  drivers/media/pci/saa7164/saa7164.h                        | 10 +++++-----
>  drivers/media/pci/smipcie/Makefile                         |  1 -
>  drivers/media/pci/smipcie/smipcie.h                        | 12 ++++++------
>  drivers/media/pci/ttpci/Makefile                           |  2 +-
>  drivers/media/pci/ttpci/av7110.c                           |  2 +-
>  drivers/media/pci/ttpci/av7110.h                           | 14 +++++++-------
>  drivers/media/pci/ttpci/budget-av.c                        |  2 +-
>  drivers/media/pci/ttpci/budget-ci.c                        |  2 +-
>  drivers/media/pci/ttpci/budget.h                           | 12 ++++++------
>  drivers/media/pci/ttpci/dvb_filter.h                       |  2 +-
>  drivers/media/platform/sti/c8sectpfe/Makefile              |  4 ++--
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c    | 10 +++++-----
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h    |  8 ++++----
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c      |  8 ++++----
>  drivers/media/tuners/Makefile                              |  1 -
>  drivers/media/tuners/e4000.h                               |  2 +-
>  drivers/media/tuners/fc0011.h                              |  2 +-
>  drivers/media/tuners/fc0012.h                              |  2 +-
>  drivers/media/tuners/fc0013.h                              |  2 +-
>  drivers/media/tuners/fc2580.h                              |  2 +-
>  drivers/media/tuners/it913x.h                              |  2 +-
>  drivers/media/tuners/m88rs6000t.h                          |  2 +-
>  drivers/media/tuners/max2165.c                             |  2 +-
>  drivers/media/tuners/mc44s803.c                            |  2 +-
>  drivers/media/tuners/mt2060.c                              |  2 +-
>  drivers/media/tuners/mt2063.h                              |  2 +-
>  drivers/media/tuners/mt20xx.h                              |  2 +-
>  drivers/media/tuners/mt2131.c                              |  2 +-
>  drivers/media/tuners/mt2266.c                              |  2 +-
>  drivers/media/tuners/mxl301rf.h                            |  2 +-
>  drivers/media/tuners/mxl5005s.c                            |  2 +-
>  drivers/media/tuners/mxl5005s.h                            |  2 +-
>  drivers/media/tuners/mxl5007t.h                            |  2 +-
>  drivers/media/tuners/qm1d1c0042.h                          |  2 +-
>  drivers/media/tuners/qt1010.h                              |  2 +-
>  drivers/media/tuners/r820t.h                               |  2 +-
>  drivers/media/tuners/si2157.h                              |  2 +-
>  drivers/media/tuners/tda18212.h                            |  2 +-
>  drivers/media/tuners/tda18218.h                            |  2 +-
>  drivers/media/tuners/tda18250.h                            |  2 +-
>  drivers/media/tuners/tda18271.h                            |  2 +-
>  drivers/media/tuners/tda827x.h                             |  2 +-
>  drivers/media/tuners/tda8290.h                             |  2 +-
>  drivers/media/tuners/tda9887.h                             |  2 +-
>  drivers/media/tuners/tea5761.h                             |  2 +-
>  drivers/media/tuners/tea5767.h                             |  2 +-
>  drivers/media/tuners/tua9001.h                             |  2 +-
>  drivers/media/tuners/tuner-simple.h                        |  2 +-
>  drivers/media/tuners/tuner-xc2028.c                        |  2 +-
>  drivers/media/tuners/tuner-xc2028.h                        |  2 +-
>  drivers/media/tuners/xc4000.c                              |  2 +-
>  drivers/media/tuners/xc5000.c                              |  2 +-
>  drivers/media/usb/as102/Makefile                           |  1 -
>  drivers/media/usb/as102/as102_drv.c                        |  2 +-
>  drivers/media/usb/as102/as102_drv.h                        |  6 +++---
>  drivers/media/usb/au0828/Makefile                          |  1 -
>  drivers/media/usb/au0828/au0828.h                          | 12 ++++++------
>  drivers/media/usb/b2c2/Makefile                            |  1 -
>  drivers/media/usb/cx231xx/Makefile                         |  1 -
>  drivers/media/usb/cx231xx/cx231xx-cards.c                  |  2 +-
>  drivers/media/usb/cx231xx/cx231xx-video.c                  |  2 +-
>  drivers/media/usb/dvb-usb-v2/Makefile                      |  1 -
>  drivers/media/usb/dvb-usb-v2/anysee.h                      |  2 +-
>  drivers/media/usb/dvb-usb-v2/az6007.c                      |  2 +-
>  drivers/media/usb/dvb-usb-v2/dvb_usb.h                     | 10 +++++-----
>  drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h              |  2 +-
>  drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h              |  2 +-
>  drivers/media/usb/dvb-usb/Makefile                         |  1 -
>  drivers/media/usb/dvb-usb/az6027.c                         |  2 +-
>  drivers/media/usb/dvb-usb/dvb-usb.h                        | 10 +++++-----
>  drivers/media/usb/dvb-usb/dw2102.c                         |  2 +-
>  drivers/media/usb/dvb-usb/pctv452e.c                       |  2 +-
>  drivers/media/usb/dvb-usb/ttusb2.c                         |  2 +-
>  drivers/media/usb/em28xx/Makefile                          |  1 -
>  drivers/media/usb/em28xx/em28xx-dvb.c                      |  6 +++---
>  drivers/media/usb/pvrusb2/Makefile                         |  1 -
>  drivers/media/usb/pvrusb2/pvrusb2-dvb.c                    |  2 +-
>  drivers/media/usb/pvrusb2/pvrusb2-dvb.h                    |  8 ++++----
>  drivers/media/usb/siano/Makefile                           |  1 -
>  drivers/media/usb/tm6000/Makefile                          |  1 -
>  drivers/media/usb/tm6000/tm6000.h                          |  6 +++---
>  drivers/media/usb/ttusb-budget/Makefile                    |  2 +-
>  drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c          |  8 ++++----
>  drivers/media/usb/ttusb-dec/Makefile                       |  2 --
>  drivers/media/usb/ttusb-dec/ttusb_dec.c                    |  8 ++++----
>  drivers/media/usb/ttusb-dec/ttusbdecfe.c                   |  2 +-
>  drivers/media/v4l2-core/Makefile                           |  1 -
>  drivers/staging/media/cxd2099/Makefile                     |  1 -
>  drivers/staging/media/cxd2099/cxd2099.h                    |  2 +-
>  {drivers/media/dvb-core => include/media}/demux.h          |  0
>  {drivers/media/dvb-core => include/media}/dmxdev.h         |  8 ++++----
>  {drivers/media/dvb-core => include/media}/dvb-usb-ids.h    |  0
>  {drivers/media/dvb-core => include/media}/dvb_ca_en50221.h |  2 +-
>  {drivers/media/dvb-core => include/media}/dvb_demux.h      |  2 +-
>  {drivers/media/dvb-core => include/media}/dvb_frontend.h   |  2 +-
>  {drivers/media/dvb-core => include/media}/dvb_math.h       |  0
>  {drivers/media/dvb-core => include/media}/dvb_net.h        |  2 +-
>  {drivers/media/dvb-core => include/media}/dvb_ringbuffer.h |  0
>  {drivers/media/dvb-core => include/media}/dvb_vb2.h        |  0
>  {drivers/media/dvb-core => include/media}/dvbdev.h         |  0
>  include/media/videobuf-dvb.h                               | 10 +++++-----
>  include/media/videobuf2-dvb.h                              | 11 +++++------
>  324 files changed, 527 insertions(+), 567 deletions(-)
>  rename {drivers/media/dvb-core => include/media}/demux.h (100%)
>  rename {drivers/media/dvb-core => include/media}/dmxdev.h (98%)
>  rename {drivers/media/dvb-core => include/media}/dvb-usb-ids.h (100%)
>  rename {drivers/media/dvb-core => include/media}/dvb_ca_en50221.h (99%)
>  rename {drivers/media/dvb-core => include/media}/dvb_demux.h (99%)
>  rename {drivers/media/dvb-core => include/media}/dvb_frontend.h (99%)
>  rename {drivers/media/dvb-core => include/media}/dvb_math.h (100%)
>  rename {drivers/media/dvb-core => include/media}/dvb_net.h (98%)
>  rename {drivers/media/dvb-core => include/media}/dvb_ringbuffer.h (100%)
>  rename {drivers/media/dvb-core => include/media}/dvb_vb2.h (100%)
>  rename {drivers/media/dvb-core => include/media}/dvbdev.h (100%)
> 
> diff --git a/Documentation/media/kapi/dtv-ca.rst b/Documentation/media/kapi/dtv-ca.rst
> index a4dd700189b0..fded096b937c 100644
> --- a/Documentation/media/kapi/dtv-ca.rst
> +++ b/Documentation/media/kapi/dtv-ca.rst
> @@ -1,4 +1,4 @@
>  Digital TV Conditional Access kABI
>  ----------------------------------
>  
> -.. kernel-doc:: drivers/media/dvb-core/dvb_ca_en50221.h
> +.. kernel-doc:: include/media/dvb_ca_en50221.h
> diff --git a/Documentation/media/kapi/dtv-common.rst b/Documentation/media/kapi/dtv-common.rst
> index 40cf1033b5e1..c47843b6c81d 100644
> --- a/Documentation/media/kapi/dtv-common.rst
> +++ b/Documentation/media/kapi/dtv-common.rst
> @@ -7,7 +7,7 @@ Math functions
>  Provide some commonly-used math functions, usually required in order to
>  estimate signal strength and signal to noise measurements in dB.
>  
> -.. kernel-doc:: drivers/media/dvb-core/dvb_math.h
> +.. kernel-doc:: include/media/dvb_math.h
>  
>  
>  DVB devices
> @@ -15,7 +15,7 @@ DVB devices
>  
>  Those functions are responsible for handling the DVB device nodes.
>  
> -.. kernel-doc:: drivers/media/dvb-core/dvbdev.h
> +.. kernel-doc:: include/media/dvbdev.h
>  
>  Digital TV Ring buffer
>  ~~~~~~~~~~~~~~~~~~~~~~
> @@ -52,4 +52,4 @@ copy it from/to userspace.
>       Resetting the buffer counts as a read and write operation.
>       Two or more writers must be locked against each other.
>  
> -.. kernel-doc:: drivers/media/dvb-core/dvb_ringbuffer.h
> +.. kernel-doc:: include/media/dvb_ringbuffer.h
> diff --git a/Documentation/media/kapi/dtv-demux.rst b/Documentation/media/kapi/dtv-demux.rst
> index 7aa865a2b43f..24857133e4e8 100644
> --- a/Documentation/media/kapi/dtv-demux.rst
> +++ b/Documentation/media/kapi/dtv-demux.rst
> @@ -8,7 +8,7 @@ The Kernel Digital TV Demux kABI defines a driver-internal interface for
>  registering low-level, hardware specific driver to a hardware independent
>  demux layer. It is only of interest for Digital TV device driver writers.
>  The header file for this kABI is named ``demux.h`` and located in
> -``drivers/media/dvb-core``.
> +``include/media``.
>  
>  The demux kABI should be implemented for each demux in the system. It is
>  used to select the TS source of a demux and to manage the demux resources.
> @@ -69,14 +69,14 @@ callbacks.
>  Digital TV Demux device registration functions and data structures
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  
> -.. kernel-doc:: drivers/media/dvb-core/dmxdev.h
> +.. kernel-doc:: include/media/dmxdev.h
>  
>  High-level Digital TV demux interface
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  
> -.. kernel-doc:: drivers/media/dvb-core/dvb_demux.h
> +.. kernel-doc:: include/media/dvb_demux.h
>  
>  Driver-internal low-level hardware specific driver demux interface
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  
> -.. kernel-doc:: drivers/media/dvb-core/demux.h
> +.. kernel-doc:: include/media/demux.h
> diff --git a/Documentation/media/kapi/dtv-frontend.rst b/Documentation/media/kapi/dtv-frontend.rst
> index f1a2fdaab5ba..472650cdb100 100644
> --- a/Documentation/media/kapi/dtv-frontend.rst
> +++ b/Documentation/media/kapi/dtv-frontend.rst
> @@ -8,7 +8,7 @@ The Digital TV Frontend kABI defines a driver-internal interface for
>  registering low-level, hardware specific driver to a hardware independent
>  frontend layer. It is only of interest for Digital TV device driver writers.
>  The header file for this API is named ``dvb_frontend.h`` and located in
> -``drivers/media/dvb-core``.
> +``include/media/``.
>  
>  Demodulator driver
>  ^^^^^^^^^^^^^^^^^^
> @@ -17,7 +17,7 @@ The demodulator driver is responsible to talk with the decoding part of the
>  hardware. Such driver should implement :c:type:`dvb_frontend_ops`, with
>  tells what type of digital TV standards are supported, and points to a
>  series of functions that allow the DVB core to command the hardware via
> -the code under ``drivers/media/dvb-core/dvb_frontend.c``.
> +the code under ``include/media/dvb_frontend.c``.
>  
>  A typical example of such struct in a driver ``foo`` is::
>  
> @@ -118,7 +118,7 @@ Satellite TV reception is::
>  
>  .. |delta|   unicode:: U+00394
>  
> -The ``drivers/media/dvb-core/dvb_frontend.c`` has a kernel thread with is
> +The ``include/media/dvb_frontend.c`` has a kernel thread with is
>  responsible for tuning the device. It supports multiple algorithms to
>  detect a channel, as defined at enum :c:func:`dvbfe_algo`.
>  
> @@ -440,4 +440,4 @@ monotonic stats at the right time.
>  Digital TV Frontend functions and types
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  
> -.. kernel-doc:: drivers/media/dvb-core/dvb_frontend.h
> +.. kernel-doc:: include/media/dvb_frontend.h
> diff --git a/Documentation/media/kapi/dtv-net.rst b/Documentation/media/kapi/dtv-net.rst
> index ced991b73d69..158c7cbd7600 100644
> --- a/Documentation/media/kapi/dtv-net.rst
> +++ b/Documentation/media/kapi/dtv-net.rst
> @@ -1,4 +1,4 @@
>  Digital TV Network kABI
>  -----------------------
>  
> -.. kernel-doc:: drivers/media/dvb-core/dvb_net.h
> +.. kernel-doc:: include/media/dvb_net.h
> diff --git a/drivers/media/common/b2c2/Makefile b/drivers/media/common/b2c2/Makefile
> index 73df4a334eda..aa2dc2434ee5 100644
> --- a/drivers/media/common/b2c2/Makefile
> +++ b/drivers/media/common/b2c2/Makefile
> @@ -4,6 +4,5 @@ b2c2-flexcop-objs += flexcop-sram.o flexcop-eeprom.o flexcop-misc.o
>  b2c2-flexcop-objs += flexcop-hw-filter.o
>  obj-$(CONFIG_DVB_B2C2_FLEXCOP) += b2c2-flexcop.o
>  
> -ccflags-y += -Idrivers/media/dvb-core/
>  ccflags-y += -Idrivers/media/dvb-frontends/
>  ccflags-y += -Idrivers/media/tuners/
> diff --git a/drivers/media/common/b2c2/flexcop-common.h b/drivers/media/common/b2c2/flexcop-common.h
> index b7e5e4c17acb..f944c59cf495 100644
> --- a/drivers/media/common/b2c2/flexcop-common.h
> +++ b/drivers/media/common/b2c2/flexcop-common.h
> @@ -13,10 +13,10 @@
>  
>  #include "flexcop-reg.h"
>  
> -#include "dmxdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_net.h"
> -#include "dvb_frontend.h"
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_net.h>
> +#include <media/dvb_frontend.h>
>  
>  #define FC_MAX_FEED 256
>  
> diff --git a/drivers/media/common/siano/Makefile b/drivers/media/common/siano/Makefile
> index 88e2b7ffc537..b33022e0be56 100644
> --- a/drivers/media/common/siano/Makefile
> +++ b/drivers/media/common/siano/Makefile
> @@ -11,7 +11,3 @@ endif
>  ifeq ($(CONFIG_SMS_SIANO_DEBUGFS),y)
>    smsdvb-objs += smsdvb-debugfs.o
>  endif
> -
> -ccflags-y += -Idrivers/media/dvb-core
> -ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
> -
> diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
> index e06aec0ed18e..aa0e5b7a7154 100644
> --- a/drivers/media/common/siano/smsdvb-debugfs.c
> +++ b/drivers/media/common/siano/smsdvb-debugfs.c
> @@ -11,10 +11,10 @@
>  #include <linux/spinlock.h>
>  #include <linux/usb.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
>  
>  #include "smsdvb.h"
>  
> diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
> index 166428cbd3c8..c0faad1ba428 100644
> --- a/drivers/media/common/siano/smsdvb-main.c
> +++ b/drivers/media/common/siano/smsdvb-main.c
> @@ -26,10 +26,10 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
>  #include <linux/init.h>
>  #include <asm/div64.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
>  
>  #include "sms-cards.h"
>  
> diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
> index 1308c11f0e5b..5eada88414d1 100644
> --- a/drivers/media/dvb-core/dmxdev.c
> +++ b/drivers/media/dvb-core/dmxdev.c
> @@ -27,8 +27,8 @@
>  #include <linux/ioctl.h>
>  #include <linux/wait.h>
>  #include <linux/uaccess.h>
> -#include "dmxdev.h"
> -#include "dvb_vb2.h"
> +#include <media/dmxdev.h>
> +#include <media/dvb_vb2.h>
>  
>  static int debug;
>  
> diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
> index a3b2754e7124..77858046d347 100644
> --- a/drivers/media/dvb-core/dvb_ca_en50221.c
> +++ b/drivers/media/dvb-core/dvb_ca_en50221.c
> @@ -37,8 +37,8 @@
>  #include <linux/sched/signal.h>
>  #include <linux/kthread.h>
>  
> -#include "dvb_ca_en50221.h"
> -#include "dvb_ringbuffer.h"
> +#include <media/dvb_ca_en50221.h>
> +#include <media/dvb_ringbuffer.h>
>  
>  static int dvb_ca_en50221_debug;
>  
> diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
> index acade7543b82..5047a1f87050 100644
> --- a/drivers/media/dvb-core/dvb_demux.c
> +++ b/drivers/media/dvb-core/dvb_demux.c
> @@ -30,7 +30,7 @@
>  #include <linux/uaccess.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_demux.h"
> +#include <media/dvb_demux.h>
>  
>  static int dvb_demux_tscheck;
>  module_param(dvb_demux_tscheck, int, 0644);
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 5547b9830bbc..722b86a43497 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -43,8 +43,8 @@
>  #include <linux/compat.h>
>  #include <asm/processor.h>
>  
> -#include "dvb_frontend.h"
> -#include "dvbdev.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvbdev.h>
>  #include <linux/dvb/version.h>
>  
>  static int dvb_frontend_debug;
> diff --git a/drivers/media/dvb-core/dvb_math.c b/drivers/media/dvb-core/dvb_math.c
> index a2e1810dd83a..dc90564d7f34 100644
> --- a/drivers/media/dvb-core/dvb_math.c
> +++ b/drivers/media/dvb-core/dvb_math.c
> @@ -19,7 +19,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <asm/bug.h>
> -#include "dvb_math.h"
> +#include <media/dvb_math.h>
>  
>  static const unsigned short logtable[256] = {
>  	0x0000, 0x0171, 0x02e0, 0x044e, 0x05ba, 0x0725, 0x088e, 0x09f7,
> diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
> index fc0834f20eab..b6c7eec863b9 100644
> --- a/drivers/media/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb-core/dvb_net.c
> @@ -64,8 +64,8 @@
>  #include <linux/mutex.h>
>  #include <linux/sched.h>
>  
> -#include "dvb_demux.h"
> -#include "dvb_net.h"
> +#include <media/dvb_demux.h>
> +#include <media/dvb_net.h>
>  
>  static inline __u32 iov_crc32( __u32 c, struct kvec *iov, unsigned int cnt )
>  {
> diff --git a/drivers/media/dvb-core/dvb_ringbuffer.c b/drivers/media/dvb-core/dvb_ringbuffer.c
> index 53011629c9ad..4330b6fa4af2 100644
> --- a/drivers/media/dvb-core/dvb_ringbuffer.c
> +++ b/drivers/media/dvb-core/dvb_ringbuffer.c
> @@ -29,7 +29,7 @@
>  #include <linux/string.h>
>  #include <linux/uaccess.h>
>  
> -#include "dvb_ringbuffer.h"
> +#include <media/dvb_ringbuffer.h>
>  
>  #define PKT_READY 0
>  #define PKT_DISPOSED 1
> diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
> index 68c59a497925..61c6ca4e87d5 100644
> --- a/drivers/media/dvb-core/dvb_vb2.c
> +++ b/drivers/media/dvb-core/dvb_vb2.c
> @@ -16,8 +16,8 @@
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  
> -#include "dvbdev.h"
> -#include "dvb_vb2.h"
> +#include <media/dvbdev.h>
> +#include <media/dvb_vb2.h>
>  
>  #define DVB_V2_MAX_SIZE		(4096 * 188)
>  
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index 060c60ddfcc3..60e9c2ba26be 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -30,7 +30,7 @@
>  #include <linux/fs.h>
>  #include <linux/cdev.h>
>  #include <linux/mutex.h>
> -#include "dvbdev.h"
> +#include <media/dvbdev.h>
>  
>  /* Due to enum tuner_pad_index */
>  #include <media/tuner.h>
> diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
> index d025eb373842..4be59fed4536 100644
> --- a/drivers/media/dvb-frontends/Makefile
> +++ b/drivers/media/dvb-frontends/Makefile
> @@ -3,7 +3,6 @@
>  # Makefile for the kernel DVB frontend device drivers.
>  #
>  
> -ccflags-y += -I$(srctree)/drivers/media/dvb-core/
>  ccflags-y += -I$(srctree)/drivers/media/tuners/
>  
>  # FIXME: RTL2832 SDR driver uses power management directly from USB IF driver
> diff --git a/drivers/media/dvb-frontends/a8293.h b/drivers/media/dvb-frontends/a8293.h
> index 7b90a03fcd0a..bc6f74f10f32 100644
> --- a/drivers/media/dvb-frontends/a8293.h
> +++ b/drivers/media/dvb-frontends/a8293.h
> @@ -17,7 +17,7 @@
>  #ifndef A8293_H
>  #define A8293_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /*
>   * I2C address
> diff --git a/drivers/media/dvb-frontends/af9013_priv.h b/drivers/media/dvb-frontends/af9013_priv.h
> index 35ca5c9bcacd..688fc3472cf6 100644
> --- a/drivers/media/dvb-frontends/af9013_priv.h
> +++ b/drivers/media/dvb-frontends/af9013_priv.h
> @@ -21,7 +21,7 @@
>  #ifndef AF9013_PRIV_H
>  #define AF9013_PRIV_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "af9013.h"
>  #include <linux/firmware.h>
>  #include <linux/math64.h>
> diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
> index 8799cda1ae14..f269abf609f0 100644
> --- a/drivers/media/dvb-frontends/af9033_priv.h
> +++ b/drivers/media/dvb-frontends/af9033_priv.h
> @@ -18,12 +18,12 @@
>  #ifndef AF9033_PRIV_H
>  #define AF9033_PRIV_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "af9033.h"
>  #include <linux/math64.h>
>  #include <linux/regmap.h>
>  #include <linux/kernel.h>
> -#include "dvb_math.h"
> +#include <media/dvb_math.h>
>  
>  struct reg_val {
>  	u32 reg;
> diff --git a/drivers/media/dvb-frontends/as102_fe.c b/drivers/media/dvb-frontends/as102_fe.c
> index b1c84ee914f0..9b2f2da1d989 100644
> --- a/drivers/media/dvb-frontends/as102_fe.c
> +++ b/drivers/media/dvb-frontends/as102_fe.c
> @@ -14,7 +14,7 @@
>   * GNU General Public License for more details.
>   */
>  
> -#include <dvb_frontend.h>
> +#include <media/dvb_frontend.h>
>  
>  #include "as102_fe.h"
>  
> diff --git a/drivers/media/dvb-frontends/ascot2e.c b/drivers/media/dvb-frontends/ascot2e.c
> index 79d5d89bc95e..9746c6dd7fb8 100644
> --- a/drivers/media/dvb-frontends/ascot2e.c
> +++ b/drivers/media/dvb-frontends/ascot2e.c
> @@ -24,7 +24,7 @@
>  #include <linux/dvb/frontend.h>
>  #include <linux/types.h>
>  #include "ascot2e.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #define MAX_WRITE_REGSIZE 10
>  
> diff --git a/drivers/media/dvb-frontends/atbm8830.c b/drivers/media/dvb-frontends/atbm8830.c
> index 05850b32d6c6..7b0f3239dbba 100644
> --- a/drivers/media/dvb-frontends/atbm8830.c
> +++ b/drivers/media/dvb-frontends/atbm8830.c
> @@ -16,7 +16,7 @@
>   */
>  
>  #include <asm/div64.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "atbm8830.h"
>  #include "atbm8830_priv.h"
> diff --git a/drivers/media/dvb-frontends/au8522_common.c b/drivers/media/dvb-frontends/au8522_common.c
> index 6722838c3707..56605de9923b 100644
> --- a/drivers/media/dvb-frontends/au8522_common.c
> +++ b/drivers/media/dvb-frontends/au8522_common.c
> @@ -23,7 +23,7 @@
>  */
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "au8522_priv.h"
>  
>  static int debug;
> diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
> index 3f3635f5a06a..8f659bd1c79e 100644
> --- a/drivers/media/dvb-frontends/au8522_dig.c
> +++ b/drivers/media/dvb-frontends/au8522_dig.c
> @@ -24,7 +24,7 @@
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <linux/delay.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "au8522.h"
>  #include "au8522_priv.h"
>  
> diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
> index f5a9438f6ce5..f02dac958db6 100644
> --- a/drivers/media/dvb-frontends/au8522_priv.h
> +++ b/drivers/media/dvb-frontends/au8522_priv.h
> @@ -32,7 +32,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-mc.h>
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "au8522.h"
>  #include "tuner-i2c.h"
>  
> diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
> index ba63ad170d3c..05df133dc5be 100644
> --- a/drivers/media/dvb-frontends/bcm3510.c
> +++ b/drivers/media/dvb-frontends/bcm3510.c
> @@ -40,7 +40,7 @@
>  #include <linux/slab.h>
>  #include <linux/mutex.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "bcm3510.h"
>  #include "bcm3510_priv.h"
>  
> diff --git a/drivers/media/dvb-frontends/cx22700.c b/drivers/media/dvb-frontends/cx22700.c
> index 2b629e23ceeb..9ffd2c7ac74a 100644
> --- a/drivers/media/dvb-frontends/cx22700.c
> +++ b/drivers/media/dvb-frontends/cx22700.c
> @@ -25,7 +25,7 @@
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "cx22700.h"
>  
>  
> diff --git a/drivers/media/dvb-frontends/cx22702.c b/drivers/media/dvb-frontends/cx22702.c
> index c0e54c59cccf..e8b1e6b7e7e5 100644
> --- a/drivers/media/dvb-frontends/cx22702.c
> +++ b/drivers/media/dvb-frontends/cx22702.c
> @@ -31,7 +31,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "cx22702.h"
>  
>  struct cx22702_state {
> diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
> index cf1bc99d1f32..2f3a1c237489 100644
> --- a/drivers/media/dvb-frontends/cx24110.c
> +++ b/drivers/media/dvb-frontends/cx24110.c
> @@ -27,7 +27,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "cx24110.h"
>  
>  
> diff --git a/drivers/media/dvb-frontends/cx24113.c b/drivers/media/dvb-frontends/cx24113.c
> index ee1f704f81f2..037db3e9d2dd 100644
> --- a/drivers/media/dvb-frontends/cx24113.c
> +++ b/drivers/media/dvb-frontends/cx24113.c
> @@ -22,7 +22,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "cx24113.h"
>  
>  static int debug;
> diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
> index 8fb3f095e21c..0ef5f8614b58 100644
> --- a/drivers/media/dvb-frontends/cx24116.c
> +++ b/drivers/media/dvb-frontends/cx24116.c
> @@ -41,7 +41,7 @@
>  #include <linux/init.h>
>  #include <linux/firmware.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "cx24116.h"
>  
>  static int debug;
> diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
> index d37cb7762bd6..8935114b75f3 100644
> --- a/drivers/media/dvb-frontends/cx24117.c
> +++ b/drivers/media/dvb-frontends/cx24117.c
> @@ -32,7 +32,7 @@
>  #include <linux/firmware.h>
>  
>  #include "tuner-i2c.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "cx24117.h"
>  
>  
> diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
> index 7f11dcc94d85..810f68acd69b 100644
> --- a/drivers/media/dvb-frontends/cx24120.c
> +++ b/drivers/media/dvb-frontends/cx24120.c
> @@ -29,7 +29,7 @@
>  #include <linux/moduleparam.h>
>  #include <linux/init.h>
>  #include <linux/firmware.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "cx24120.h"
>  
>  #define CX24120_SEARCH_RANGE_KHZ 5000
> diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
> index 1d59d1d3bd82..228ba1f4bf63 100644
> --- a/drivers/media/dvb-frontends/cx24123.c
> +++ b/drivers/media/dvb-frontends/cx24123.c
> @@ -24,7 +24,7 @@
>  #include <linux/init.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "cx24123.h"
>  
>  #define XTAL 10111000
> diff --git a/drivers/media/dvb-frontends/cxd2820r_priv.h b/drivers/media/dvb-frontends/cxd2820r_priv.h
> index 0d096206ac66..61adde4b4b2f 100644
> --- a/drivers/media/dvb-frontends/cxd2820r_priv.h
> +++ b/drivers/media/dvb-frontends/cxd2820r_priv.h
> @@ -23,8 +23,8 @@
>  #define CXD2820R_PRIV_H
>  
>  #include <linux/dvb/version.h>
> -#include "dvb_frontend.h"
> -#include "dvb_math.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_math.h>
>  #include "cxd2820r.h"
>  #include <linux/gpio.h>
>  #include <linux/math64.h>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 16763903d4ad..85905d3503ff 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -31,8 +31,8 @@
>  #include <linux/dynamic_debug.h>
>  #include <linux/kernel.h>
>  
> -#include "dvb_math.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_math.h>
> +#include <media/dvb_frontend.h>
>  #include "cxd2841er.h"
>  #include "cxd2841er_priv.h"
>  
> diff --git a/drivers/media/dvb-frontends/dib0070.c b/drivers/media/dvb-frontends/dib0070.c
> index d7614b8b8782..932d235118e2 100644
> --- a/drivers/media/dvb-frontends/dib0070.c
> +++ b/drivers/media/dvb-frontends/dib0070.c
> @@ -27,7 +27,7 @@
>  #include <linux/i2c.h>
>  #include <linux/mutex.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "dib0070.h"
>  #include "dibx000_common.h"
> diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
> index d9d730dfe0b1..64f49c8eb1fb 100644
> --- a/drivers/media/dvb-frontends/dib0090.c
> +++ b/drivers/media/dvb-frontends/dib0090.c
> @@ -27,7 +27,7 @@
>  #include <linux/i2c.h>
>  #include <linux/mutex.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "dib0090.h"
>  #include "dibx000_common.h"
> diff --git a/drivers/media/dvb-frontends/dib3000mb.c b/drivers/media/dvb-frontends/dib3000mb.c
> index 068bec104e29..de3ce2786c72 100644
> --- a/drivers/media/dvb-frontends/dib3000mb.c
> +++ b/drivers/media/dvb-frontends/dib3000mb.c
> @@ -30,7 +30,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "dib3000.h"
>  #include "dib3000mb_priv.h"
> diff --git a/drivers/media/dvb-frontends/dib3000mc.c b/drivers/media/dvb-frontends/dib3000mc.c
> index 4d086a7248e9..7e5d474806a5 100644
> --- a/drivers/media/dvb-frontends/dib3000mc.c
> +++ b/drivers/media/dvb-frontends/dib3000mc.c
> @@ -17,7 +17,7 @@
>  #include <linux/slab.h>
>  #include <linux/i2c.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "dib3000mc.h"
>  
> diff --git a/drivers/media/dvb-frontends/dib7000m.c b/drivers/media/dvb-frontends/dib7000m.c
> index 5ce9f93a65c3..6a1d357d0c7c 100644
> --- a/drivers/media/dvb-frontends/dib7000m.c
> +++ b/drivers/media/dvb-frontends/dib7000m.c
> @@ -16,7 +16,7 @@
>  #include <linux/i2c.h>
>  #include <linux/mutex.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "dib7000m.h"
>  
> diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
> index 0fbaabe43682..90ace707a80d 100644
> --- a/drivers/media/dvb-frontends/dib7000p.c
> +++ b/drivers/media/dvb-frontends/dib7000p.c
> @@ -16,8 +16,8 @@
>  #include <linux/mutex.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_math.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_math.h>
> +#include <media/dvb_frontend.h>
>  
>  #include "dib7000p.h"
>  
> diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
> index 5d9381509b07..e64014f338fb 100644
> --- a/drivers/media/dvb-frontends/dib8000.c
> +++ b/drivers/media/dvb-frontends/dib8000.c
> @@ -16,9 +16,9 @@
>  #include <linux/mutex.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_math.h"
> +#include <media/dvb_math.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "dib8000.h"
>  
> diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
> index 1b7a4331af05..f9289f488de7 100644
> --- a/drivers/media/dvb-frontends/dib9000.c
> +++ b/drivers/media/dvb-frontends/dib9000.c
> @@ -14,8 +14,8 @@
>  #include <linux/i2c.h>
>  #include <linux/mutex.h>
>  
> -#include "dvb_math.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_math.h>
> +#include <media/dvb_frontend.h>
>  
>  #include "dib9000.h"
>  #include "dibx000_common.h"
> diff --git a/drivers/media/dvb-frontends/drx39xyj/Makefile b/drivers/media/dvb-frontends/drx39xyj/Makefile
> index 672e07774955..87f6eddcf657 100644
> --- a/drivers/media/dvb-frontends/drx39xyj/Makefile
> +++ b/drivers/media/dvb-frontends/drx39xyj/Makefile
> @@ -2,5 +2,4 @@ drx39xyj-objs := drxj.o
>  
>  obj-$(CONFIG_DVB_DRX39XYJ) += drx39xyj.o
>  
> -ccflags-y += -I$(srctree)/drivers/media/dvb-core/
>  ccflags-y += -I$(srctree)/drivers/media/tuners/
> diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
> index 11e1ddeeef0a..c0c66ed65b6e 100644
> --- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
> +++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
> @@ -19,7 +19,7 @@
>  #define DRX39XXJ_H
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "drx_driver.h"
>  
>  struct drx39xxj_state {
> diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
> index 2f928c4dac94..1cc7c03cd032 100644
> --- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
> +++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
> @@ -61,7 +61,7 @@ INCLUDE FILES
>  #include <linux/slab.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "drx39xxj.h"
>  
>  #include "drxj.h"
> diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
> index 087350ec8712..3b7d31a22d82 100644
> --- a/drivers/media/dvb-frontends/drxd_hard.c
> +++ b/drivers/media/dvb-frontends/drxd_hard.c
> @@ -26,7 +26,7 @@
>  #include <linux/i2c.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "drxd.h"
>  #include "drxd_firm.h"
>  
> diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
> index 19cc84c69b3b..5a26ad93be10 100644
> --- a/drivers/media/dvb-frontends/drxk_hard.c
> +++ b/drivers/media/dvb-frontends/drxk_hard.c
> @@ -29,10 +29,10 @@
>  #include <linux/hardirq.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "drxk.h"
>  #include "drxk_hard.h"
> -#include "dvb_math.h"
> +#include <media/dvb_math.h>
>  
>  static int power_down_dvbt(struct drxk_state *state, bool set_power_mode);
>  static int power_down_qam(struct drxk_state *state);
> diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
> index bd4f8278c906..2ff90e5eabce 100644
> --- a/drivers/media/dvb-frontends/ds3000.c
> +++ b/drivers/media/dvb-frontends/ds3000.c
> @@ -26,7 +26,7 @@
>  #include <linux/init.h>
>  #include <linux/firmware.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "ts2020.h"
>  #include "ds3000.h"
>  
> diff --git a/drivers/media/dvb-frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
> index 212e0730f154..ca885e71d2f0 100644
> --- a/drivers/media/dvb-frontends/dvb-pll.h
> +++ b/drivers/media/dvb-frontends/dvb-pll.h
> @@ -7,7 +7,7 @@
>  #define __DVB_PLL_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #define DVB_PLL_UNDEFINED               0
>  #define DVB_PLL_THOMSON_DTT7579         1
> diff --git a/drivers/media/dvb-frontends/dvb_dummy_fe.c b/drivers/media/dvb-frontends/dvb_dummy_fe.c
> index 50b2b666ef6c..6650d4f61ef2 100644
> --- a/drivers/media/dvb-frontends/dvb_dummy_fe.c
> +++ b/drivers/media/dvb-frontends/dvb_dummy_fe.c
> @@ -20,7 +20,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "dvb_dummy_fe.h"
>  
>  
> diff --git a/drivers/media/dvb-frontends/dvb_dummy_fe.h b/drivers/media/dvb-frontends/dvb_dummy_fe.h
> index 86dd7b9d1e57..7aacef4b7c80 100644
> --- a/drivers/media/dvb-frontends/dvb_dummy_fe.h
> +++ b/drivers/media/dvb-frontends/dvb_dummy_fe.h
> @@ -19,7 +19,7 @@
>  #define DVB_DUMMY_FE_H
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #if IS_REACHABLE(CONFIG_DVB_DUMMY_FE)
>  extern struct dvb_frontend* dvb_dummy_fe_ofdm_attach(void);
> diff --git a/drivers/media/dvb-frontends/ec100.c b/drivers/media/dvb-frontends/ec100.c
> index fa2a96d5f94e..c2575fdcc811 100644
> --- a/drivers/media/dvb-frontends/ec100.c
> +++ b/drivers/media/dvb-frontends/ec100.c
> @@ -15,7 +15,7 @@
>   *
>   */
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "ec100.h"
>  
>  struct ec100_state {
> diff --git a/drivers/media/dvb-frontends/gp8psk-fe.c b/drivers/media/dvb-frontends/gp8psk-fe.c
> index efe015df7f1d..a772ef8bfe1c 100644
> --- a/drivers/media/dvb-frontends/gp8psk-fe.c
> +++ b/drivers/media/dvb-frontends/gp8psk-fe.c
> @@ -16,7 +16,7 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include "gp8psk-fe.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  static int debug;
>  module_param(debug, int, 0644);
> diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
> index 2ab8d83e5576..a0d0b53c91d7 100644
> --- a/drivers/media/dvb-frontends/helene.c
> +++ b/drivers/media/dvb-frontends/helene.c
> @@ -23,7 +23,7 @@
>  #include <linux/dvb/frontend.h>
>  #include <linux/types.h>
>  #include "helene.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #define MAX_WRITE_REGSIZE 20
>  
> diff --git a/drivers/media/dvb-frontends/horus3a.c b/drivers/media/dvb-frontends/horus3a.c
> index 5c8b405f2ddc..5e7e265a52e6 100644
> --- a/drivers/media/dvb-frontends/horus3a.c
> +++ b/drivers/media/dvb-frontends/horus3a.c
> @@ -24,7 +24,7 @@
>  #include <linux/dvb/frontend.h>
>  #include <linux/types.h>
>  #include "horus3a.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #define MAX_WRITE_REGSIZE      5
>  
> diff --git a/drivers/media/dvb-frontends/isl6405.c b/drivers/media/dvb-frontends/isl6405.c
> index 2fc8d3c72c11..3bc78f8ffc00 100644
> --- a/drivers/media/dvb-frontends/isl6405.c
> +++ b/drivers/media/dvb-frontends/isl6405.c
> @@ -29,7 +29,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "isl6405.h"
>  
>  struct isl6405 {
> diff --git a/drivers/media/dvb-frontends/isl6421.c b/drivers/media/dvb-frontends/isl6421.c
> index 3f3487887672..ae8ec59b665c 100644
> --- a/drivers/media/dvb-frontends/isl6421.c
> +++ b/drivers/media/dvb-frontends/isl6421.c
> @@ -29,7 +29,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "isl6421.h"
>  
>  struct isl6421 {
> diff --git a/drivers/media/dvb-frontends/isl6423.c b/drivers/media/dvb-frontends/isl6423.c
> index dca5bebfeeb5..3dd2465d17cf 100644
> --- a/drivers/media/dvb-frontends/isl6423.c
> +++ b/drivers/media/dvb-frontends/isl6423.c
> @@ -26,7 +26,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "isl6423.h"
>  
>  static unsigned int verbose;
> diff --git a/drivers/media/dvb-frontends/itd1000.c b/drivers/media/dvb-frontends/itd1000.c
> index ce7c443d3eac..04f7f6854f73 100644
> --- a/drivers/media/dvb-frontends/itd1000.c
> +++ b/drivers/media/dvb-frontends/itd1000.c
> @@ -22,7 +22,7 @@
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "itd1000.h"
>  #include "itd1000_priv.h"
> diff --git a/drivers/media/dvb-frontends/ix2505v.h b/drivers/media/dvb-frontends/ix2505v.h
> index 49ed93e754ed..20b1eb3dda1a 100644
> --- a/drivers/media/dvb-frontends/ix2505v.h
> +++ b/drivers/media/dvb-frontends/ix2505v.h
> @@ -17,7 +17,7 @@
>  #define DVB_IX2505V_H
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /**
>   * struct ix2505v_config - ix2505 attachment configuration
> diff --git a/drivers/media/dvb-frontends/l64781.c b/drivers/media/dvb-frontends/l64781.c
> index e5a6c1766664..e056f36e6f0c 100644
> --- a/drivers/media/dvb-frontends/l64781.c
> +++ b/drivers/media/dvb-frontends/l64781.c
> @@ -25,7 +25,7 @@
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "l64781.h"
>  
>  
> diff --git a/drivers/media/dvb-frontends/lg2160.h b/drivers/media/dvb-frontends/lg2160.h
> index ba99125deac0..df817aec29e2 100644
> --- a/drivers/media/dvb-frontends/lg2160.h
> +++ b/drivers/media/dvb-frontends/lg2160.h
> @@ -19,7 +19,7 @@
>  #define _LG2160_H_
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  enum lg_chip_type {
>  	LG2160 = 0,
> diff --git a/drivers/media/dvb-frontends/lgdt3305.c b/drivers/media/dvb-frontends/lgdt3305.c
> index 0af4d9104761..735d73060265 100644
> --- a/drivers/media/dvb-frontends/lgdt3305.c
> +++ b/drivers/media/dvb-frontends/lgdt3305.c
> @@ -20,7 +20,7 @@
>  #include <asm/div64.h>
>  #include <linux/dvb/frontend.h>
>  #include <linux/slab.h>
> -#include "dvb_math.h"
> +#include <media/dvb_math.h>
>  #include "lgdt3305.h"
>  
>  static int debug;
> diff --git a/drivers/media/dvb-frontends/lgdt3305.h b/drivers/media/dvb-frontends/lgdt3305.h
> index 2fb60d91f7b4..a54daaee823a 100644
> --- a/drivers/media/dvb-frontends/lgdt3305.h
> +++ b/drivers/media/dvb-frontends/lgdt3305.h
> @@ -19,7 +19,7 @@
>  #define _LGDT3305_H_
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  
>  enum lgdt3305_mpeg_mode {
> diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
> index 724e9aac0f11..6356815cf3e1 100644
> --- a/drivers/media/dvb-frontends/lgdt3306a.c
> +++ b/drivers/media/dvb-frontends/lgdt3306a.c
> @@ -21,7 +21,7 @@
>  #include <asm/div64.h>
>  #include <linux/kernel.h>
>  #include <linux/dvb/frontend.h>
> -#include "dvb_math.h"
> +#include <media/dvb_math.h>
>  #include "lgdt3306a.h"
>  #include <linux/i2c-mux.h>
>  
> diff --git a/drivers/media/dvb-frontends/lgdt3306a.h b/drivers/media/dvb-frontends/lgdt3306a.h
> index 6ce337ec5272..8b53044f5bdb 100644
> --- a/drivers/media/dvb-frontends/lgdt3306a.h
> +++ b/drivers/media/dvb-frontends/lgdt3306a.h
> @@ -19,7 +19,7 @@
>  #define _LGDT3306A_H_
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  
>  enum lgdt3306a_mpeg_mode {
> diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
> index 06f47dc8cd3d..8ad03bd81af5 100644
> --- a/drivers/media/dvb-frontends/lgdt330x.c
> +++ b/drivers/media/dvb-frontends/lgdt330x.c
> @@ -37,8 +37,8 @@
>  #include <linux/slab.h>
>  #include <asm/byteorder.h>
>  
> -#include "dvb_frontend.h"
> -#include "dvb_math.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_math.h>
>  #include "lgdt330x_priv.h"
>  #include "lgdt330x.h"
>  
> diff --git a/drivers/media/dvb-frontends/lgs8gl5.c b/drivers/media/dvb-frontends/lgs8gl5.c
> index 970e42fdbc1b..f47e5a1af16d 100644
> --- a/drivers/media/dvb-frontends/lgs8gl5.c
> +++ b/drivers/media/dvb-frontends/lgs8gl5.c
> @@ -25,7 +25,7 @@
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "lgs8gl5.h"
>  
>  
> diff --git a/drivers/media/dvb-frontends/lgs8gxx.c b/drivers/media/dvb-frontends/lgs8gxx.c
> index e6bf60e1138c..84af8a12f26a 100644
> --- a/drivers/media/dvb-frontends/lgs8gxx.c
> +++ b/drivers/media/dvb-frontends/lgs8gxx.c
> @@ -22,7 +22,7 @@
>  #include <asm/div64.h>
>  #include <linux/firmware.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "lgs8gxx.h"
>  #include "lgs8gxx_priv.h"
> diff --git a/drivers/media/dvb-frontends/lnbh25.c b/drivers/media/dvb-frontends/lnbh25.c
> index cb486e879fdd..0b388502c298 100644
> --- a/drivers/media/dvb-frontends/lnbh25.c
> +++ b/drivers/media/dvb-frontends/lnbh25.c
> @@ -23,7 +23,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "lnbh25.h"
>  
>  /**
> diff --git a/drivers/media/dvb-frontends/lnbp21.c b/drivers/media/dvb-frontends/lnbp21.c
> index 392d7be93774..d9966a338a72 100644
> --- a/drivers/media/dvb-frontends/lnbp21.c
> +++ b/drivers/media/dvb-frontends/lnbp21.c
> @@ -29,7 +29,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "lnbp21.h"
>  #include "lnbh24.h"
>  
> diff --git a/drivers/media/dvb-frontends/lnbp22.c b/drivers/media/dvb-frontends/lnbp22.c
> index 39326a2ebab2..a62e82bf46f5 100644
> --- a/drivers/media/dvb-frontends/lnbp22.c
> +++ b/drivers/media/dvb-frontends/lnbp22.c
> @@ -30,7 +30,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "lnbp22.h"
>  
>  static int debug;
> diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
> index 07f20c269c67..1ba0b79df311 100644
> --- a/drivers/media/dvb-frontends/m88ds3103_priv.h
> +++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
> @@ -17,9 +17,9 @@
>  #ifndef M88DS3103_PRIV_H
>  #define M88DS3103_PRIV_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "m88ds3103.h"
> -#include "dvb_math.h"
> +#include <media/dvb_math.h>
>  #include <linux/firmware.h>
>  #include <linux/i2c-mux.h>
>  #include <linux/regmap.h>
> diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
> index e34dab41d104..496ce27fa63a 100644
> --- a/drivers/media/dvb-frontends/m88rs2000.c
> +++ b/drivers/media/dvb-frontends/m88rs2000.c
> @@ -31,7 +31,7 @@
>  #include <linux/types.h>
>  
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "m88rs2000.h"
>  
>  struct m88rs2000_state {
> diff --git a/drivers/media/dvb-frontends/m88rs2000.h b/drivers/media/dvb-frontends/m88rs2000.h
> index 1a313b0f5875..b015872c4ff4 100644
> --- a/drivers/media/dvb-frontends/m88rs2000.h
> +++ b/drivers/media/dvb-frontends/m88rs2000.h
> @@ -21,7 +21,7 @@
>  #define M88RS2000_H
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct m88rs2000_config {
>  	/* Demodulator i2c address */
> diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
> index 5d2bb76bc07a..2969ba6ed9e1 100644
> --- a/drivers/media/dvb-frontends/mb86a16.c
> +++ b/drivers/media/dvb-frontends/mb86a16.c
> @@ -24,7 +24,7 @@
>  #include <linux/moduleparam.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "mb86a16.h"
>  #include "mb86a16_priv.h"
>  
> diff --git a/drivers/media/dvb-frontends/mb86a16.h b/drivers/media/dvb-frontends/mb86a16.h
> index dbd5f43fa128..f13820bc7a21 100644
> --- a/drivers/media/dvb-frontends/mb86a16.h
> +++ b/drivers/media/dvb-frontends/mb86a16.h
> @@ -22,7 +22,7 @@
>  #define __MB86A16_H
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  
>  struct mb86a16_config {
> diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
> index bdaf9d235fed..6ce1b8f46a39 100644
> --- a/drivers/media/dvb-frontends/mb86a20s.c
> +++ b/drivers/media/dvb-frontends/mb86a20s.c
> @@ -17,7 +17,7 @@
>  #include <linux/kernel.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "mb86a20s.h"
>  
>  #define NUM_LAYERS 3
> diff --git a/drivers/media/dvb-frontends/mn88472_priv.h b/drivers/media/dvb-frontends/mn88472_priv.h
> index fb50f56ba30b..2ec126a42527 100644
> --- a/drivers/media/dvb-frontends/mn88472_priv.h
> +++ b/drivers/media/dvb-frontends/mn88472_priv.h
> @@ -17,8 +17,8 @@
>  #ifndef MN88472_PRIV_H
>  #define MN88472_PRIV_H
>  
> -#include "dvb_frontend.h"
> -#include "dvb_math.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_math.h>
>  #include "mn88472.h"
>  #include <linux/firmware.h>
>  #include <linux/regmap.h>
> diff --git a/drivers/media/dvb-frontends/mn88473_priv.h b/drivers/media/dvb-frontends/mn88473_priv.h
> index 5fc463d147c8..d89a86320263 100644
> --- a/drivers/media/dvb-frontends/mn88473_priv.h
> +++ b/drivers/media/dvb-frontends/mn88473_priv.h
> @@ -17,8 +17,8 @@
>  #ifndef MN88473_PRIV_H
>  #define MN88473_PRIV_H
>  
> -#include "dvb_frontend.h"
> -#include "dvb_math.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_math.h>
>  #include "mn88473.h"
>  #include <linux/math64.h>
>  #include <linux/firmware.h>
> diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
> index 0b23cbc021b8..e2a3fc521620 100644
> --- a/drivers/media/dvb-frontends/mt312.c
> +++ b/drivers/media/dvb-frontends/mt312.c
> @@ -32,7 +32,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "mt312_priv.h"
>  #include "mt312.h"
>  
> diff --git a/drivers/media/dvb-frontends/mt352.c b/drivers/media/dvb-frontends/mt352.c
> index d5fa96f0a6cd..a440b76444d3 100644
> --- a/drivers/media/dvb-frontends/mt352.c
> +++ b/drivers/media/dvb-frontends/mt352.c
> @@ -33,7 +33,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "mt352_priv.h"
>  #include "mt352.h"
>  
> diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
> index 1ebc3830579f..e899821018a0 100644
> --- a/drivers/media/dvb-frontends/mxl5xx.c
> +++ b/drivers/media/dvb-frontends/mxl5xx.c
> @@ -33,7 +33,7 @@
>  #include <asm/div64.h>
>  #include <asm/unaligned.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "mxl5xx.h"
>  #include "mxl5xx_regs.h"
>  #include "mxl5xx_defs.h"
> diff --git a/drivers/media/dvb-frontends/mxl5xx.h b/drivers/media/dvb-frontends/mxl5xx.h
> index 532e08111537..ad4c21846800 100644
> --- a/drivers/media/dvb-frontends/mxl5xx.h
> +++ b/drivers/media/dvb-frontends/mxl5xx.h
> @@ -4,7 +4,7 @@
>  #include <linux/types.h>
>  #include <linux/i2c.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct mxl5xx_cfg {
>  	u8   adr;
> diff --git a/drivers/media/dvb-frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
> index bf6e5cd572c5..7aa74403648e 100644
> --- a/drivers/media/dvb-frontends/nxt200x.c
> +++ b/drivers/media/dvb-frontends/nxt200x.c
> @@ -48,7 +48,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "nxt200x.h"
>  
>  struct nxt200x_state {
> diff --git a/drivers/media/dvb-frontends/nxt6000.c b/drivers/media/dvb-frontends/nxt6000.c
> index 1ce5ea28489b..109a635d166a 100644
> --- a/drivers/media/dvb-frontends/nxt6000.c
> +++ b/drivers/media/dvb-frontends/nxt6000.c
> @@ -27,7 +27,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "nxt6000_priv.h"
>  #include "nxt6000.h"
>  
> diff --git a/drivers/media/dvb-frontends/or51132.c b/drivers/media/dvb-frontends/or51132.c
> index 5f2549c48eb0..b4c9aadcb552 100644
> --- a/drivers/media/dvb-frontends/or51132.c
> +++ b/drivers/media/dvb-frontends/or51132.c
> @@ -38,8 +38,8 @@
>  #include <linux/slab.h>
>  #include <asm/byteorder.h>
>  
> -#include "dvb_math.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_math.h>
> +#include <media/dvb_frontend.h>
>  #include "or51132.h"
>  
>  static int debug;
> diff --git a/drivers/media/dvb-frontends/or51211.c b/drivers/media/dvb-frontends/or51211.c
> index d14fa9736ae5..a1b7c301828f 100644
> --- a/drivers/media/dvb-frontends/or51211.c
> +++ b/drivers/media/dvb-frontends/or51211.c
> @@ -36,8 +36,8 @@
>  #include <linux/slab.h>
>  #include <asm/byteorder.h>
>  
> -#include "dvb_math.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_math.h>
> +#include <media/dvb_frontend.h>
>  #include "or51211.h"
>  
>  static int debug;
> diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
> index 8ec4721d79ac..72d3f3546ff2 100644
> --- a/drivers/media/dvb-frontends/rtl2830_priv.h
> +++ b/drivers/media/dvb-frontends/rtl2830_priv.h
> @@ -18,8 +18,8 @@
>  #ifndef RTL2830_PRIV_H
>  #define RTL2830_PRIV_H
>  
> -#include "dvb_frontend.h"
> -#include "dvb_math.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_math.h>
>  #include "rtl2830.h"
>  #include <linux/i2c-mux.h>
>  #include <linux/math64.h>
> diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
> index 9a6d01a9c690..bd13d9ad9ab7 100644
> --- a/drivers/media/dvb-frontends/rtl2832_priv.h
> +++ b/drivers/media/dvb-frontends/rtl2832_priv.h
> @@ -26,8 +26,8 @@
>  #include <linux/math64.h>
>  #include <linux/bitops.h>
>  
> -#include "dvb_frontend.h"
> -#include "dvb_math.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_math.h>
>  #include "rtl2832.h"
>  
>  struct rtl2832_dev {
> diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.h b/drivers/media/dvb-frontends/rtl2832_sdr.h
> index 8f88c2fb8627..d28735c1cb0c 100644
> --- a/drivers/media/dvb-frontends/rtl2832_sdr.h
> +++ b/drivers/media/dvb-frontends/rtl2832_sdr.h
> @@ -27,7 +27,7 @@
>  
>  #include <linux/i2c.h>
>  #include <media/v4l2-subdev.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /**
>   * struct rtl2832_sdr_platform_data - Platform data for the rtl2832_sdr driver
> diff --git a/drivers/media/dvb-frontends/s5h1409.c b/drivers/media/dvb-frontends/s5h1409.c
> index f370c6df0a8b..aced6a956ec5 100644
> --- a/drivers/media/dvb-frontends/s5h1409.c
> +++ b/drivers/media/dvb-frontends/s5h1409.c
> @@ -25,7 +25,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "s5h1409.h"
>  
>  struct s5h1409_state {
> diff --git a/drivers/media/dvb-frontends/s5h1411.c b/drivers/media/dvb-frontends/s5h1411.c
> index dd09336a135b..c4b1e9725f3e 100644
> --- a/drivers/media/dvb-frontends/s5h1411.c
> +++ b/drivers/media/dvb-frontends/s5h1411.c
> @@ -25,7 +25,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "s5h1411.h"
>  
>  struct s5h1411_state {
> diff --git a/drivers/media/dvb-frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
> index fd427a29c001..8b2222530227 100644
> --- a/drivers/media/dvb-frontends/s5h1420.c
> +++ b/drivers/media/dvb-frontends/s5h1420.c
> @@ -30,7 +30,7 @@
>  #include <linux/i2c.h>
>  
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "s5h1420.h"
>  #include "s5h1420_priv.h"
>  
> diff --git a/drivers/media/dvb-frontends/s5h1432.c b/drivers/media/dvb-frontends/s5h1432.c
> index 4de50fe0c638..740a60df0455 100644
> --- a/drivers/media/dvb-frontends/s5h1432.c
> +++ b/drivers/media/dvb-frontends/s5h1432.c
> @@ -20,7 +20,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "s5h1432.h"
>  
>  struct s5h1432_state {
> diff --git a/drivers/media/dvb-frontends/s921.c b/drivers/media/dvb-frontends/s921.c
> index 274544a3ae0e..2d75ede77aca 100644
> --- a/drivers/media/dvb-frontends/s921.c
> +++ b/drivers/media/dvb-frontends/s921.c
> @@ -25,7 +25,7 @@
>  #include <linux/kernel.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "s921.h"
>  
>  static int debug = 1;
> diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
> index 2ad6409dd6b1..2dd336f95cbf 100644
> --- a/drivers/media/dvb-frontends/si2165.c
> +++ b/drivers/media/dvb-frontends/si2165.c
> @@ -27,8 +27,8 @@
>  #include <linux/firmware.h>
>  #include <linux/regmap.h>
>  
> -#include "dvb_frontend.h"
> -#include "dvb_math.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_math.h>
>  #include "si2165_priv.h"
>  #include "si2165.h"
>  
> diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
> index 737cf416fbb2..3c8746a20038 100644
> --- a/drivers/media/dvb-frontends/si2168_priv.h
> +++ b/drivers/media/dvb-frontends/si2168_priv.h
> @@ -18,7 +18,7 @@
>  #define SI2168_PRIV_H
>  
>  #include "si2168.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include <linux/firmware.h>
>  #include <linux/i2c-mux.h>
>  #include <linux/kernel.h>
> diff --git a/drivers/media/dvb-frontends/si21xx.c b/drivers/media/dvb-frontends/si21xx.c
> index 4e8c3ac4303f..9b32a1b3205e 100644
> --- a/drivers/media/dvb-frontends/si21xx.c
> +++ b/drivers/media/dvb-frontends/si21xx.c
> @@ -16,7 +16,7 @@
>  #include <linux/jiffies.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "si21xx.h"
>  
>  #define	REVISION_REG			0x00
> diff --git a/drivers/media/dvb-frontends/si21xx.h b/drivers/media/dvb-frontends/si21xx.h
> index 43d480bb6ea2..12fa1d579820 100644
> --- a/drivers/media/dvb-frontends/si21xx.h
> +++ b/drivers/media/dvb-frontends/si21xx.h
> @@ -3,7 +3,7 @@
>  #define SI21XX_H
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct si21xx_config {
>  	/* the demodulator's i2c address */
> diff --git a/drivers/media/dvb-frontends/sp2.h b/drivers/media/dvb-frontends/sp2.h
> index 3901cd74b3f7..1bf60b80566f 100644
> --- a/drivers/media/dvb-frontends/sp2.h
> +++ b/drivers/media/dvb-frontends/sp2.h
> @@ -17,7 +17,7 @@
>  #ifndef SP2_H
>  #define SP2_H
>  
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  
>  /*
>   * I2C address
> diff --git a/drivers/media/dvb-frontends/sp2_priv.h b/drivers/media/dvb-frontends/sp2_priv.h
> index 37fef7bcd63f..c9ee53073ec0 100644
> --- a/drivers/media/dvb-frontends/sp2_priv.h
> +++ b/drivers/media/dvb-frontends/sp2_priv.h
> @@ -18,7 +18,7 @@
>  #define SP2_PRIV_H
>  
>  #include "sp2.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /* state struct */
>  struct sp2 {
> diff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
> index 04454cb78467..9a726f3a4896 100644
> --- a/drivers/media/dvb-frontends/sp8870.c
> +++ b/drivers/media/dvb-frontends/sp8870.c
> @@ -35,7 +35,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "sp8870.h"
>  
>  
> diff --git a/drivers/media/dvb-frontends/sp887x.c b/drivers/media/dvb-frontends/sp887x.c
> index d2c402b52c6e..572a297811fe 100644
> --- a/drivers/media/dvb-frontends/sp887x.c
> +++ b/drivers/media/dvb-frontends/sp887x.c
> @@ -17,7 +17,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "sp887x.h"
>  
>  
> diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
> index db5dde3215f0..2c5427c77db7 100644
> --- a/drivers/media/dvb-frontends/stb0899_drv.c
> +++ b/drivers/media/dvb-frontends/stb0899_drv.c
> @@ -27,7 +27,7 @@
>  #include <linux/string.h>
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "stb0899_drv.h"
>  #include "stb0899_priv.h"
> diff --git a/drivers/media/dvb-frontends/stb0899_drv.h b/drivers/media/dvb-frontends/stb0899_drv.h
> index 0a72131a57db..6c285aee7edf 100644
> --- a/drivers/media/dvb-frontends/stb0899_drv.h
> +++ b/drivers/media/dvb-frontends/stb0899_drv.h
> @@ -25,7 +25,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #define STB0899_TSMODE_SERIAL		1
>  #define STB0899_CLKPOL_FALLING		2
> diff --git a/drivers/media/dvb-frontends/stb0899_priv.h b/drivers/media/dvb-frontends/stb0899_priv.h
> index 82395b912815..86d140e4c5ed 100644
> --- a/drivers/media/dvb-frontends/stb0899_priv.h
> +++ b/drivers/media/dvb-frontends/stb0899_priv.h
> @@ -22,7 +22,7 @@
>  #ifndef __STB0899_PRIV_H
>  #define __STB0899_PRIV_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "stb0899_drv.h"
>  
>  #define FE_ERROR				0
> diff --git a/drivers/media/dvb-frontends/stb6000.h b/drivers/media/dvb-frontends/stb6000.h
> index e94a3d5facf6..1adda72379ff 100644
> --- a/drivers/media/dvb-frontends/stb6000.h
> +++ b/drivers/media/dvb-frontends/stb6000.h
> @@ -24,7 +24,7 @@
>  #define __DVB_STB6000_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #if IS_REACHABLE(CONFIG_DVB_STB6000)
>  /**
> diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
> index 75509bec66e4..3a851f524b16 100644
> --- a/drivers/media/dvb-frontends/stb6100.c
> +++ b/drivers/media/dvb-frontends/stb6100.c
> @@ -25,7 +25,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "stb6100.h"
>  
>  static unsigned int verbose;
> diff --git a/drivers/media/dvb-frontends/stb6100.h b/drivers/media/dvb-frontends/stb6100.h
> index f7b468b6dc26..6cdae688a23e 100644
> --- a/drivers/media/dvb-frontends/stb6100.h
> +++ b/drivers/media/dvb-frontends/stb6100.h
> @@ -23,7 +23,7 @@
>  #define __STB_6100_REG_H
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #define STB6100_LD			0x00
>  #define STB6100_LD_LOCK			(1 << 0)
> diff --git a/drivers/media/dvb-frontends/stb6100_cfg.h b/drivers/media/dvb-frontends/stb6100_cfg.h
> index 2ef67aa768b9..203f9b36c0eb 100644
> --- a/drivers/media/dvb-frontends/stb6100_cfg.h
> +++ b/drivers/media/dvb-frontends/stb6100_cfg.h
> @@ -20,7 +20,7 @@
>  */
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  static int stb6100_get_frequency(struct dvb_frontend *fe, u32 *frequency)
>  {
> diff --git a/drivers/media/dvb-frontends/stb6100_proc.h b/drivers/media/dvb-frontends/stb6100_proc.h
> index 50ffa21e3871..fad877b2fc7d 100644
> --- a/drivers/media/dvb-frontends/stb6100_proc.h
> +++ b/drivers/media/dvb-frontends/stb6100_proc.h
> @@ -18,7 +18,7 @@
>  */
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  static int stb6100_get_freq(struct dvb_frontend *fe, u32 *frequency)
>  {
> diff --git a/drivers/media/dvb-frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
> index 67f91814b9f7..f947ed947aae 100644
> --- a/drivers/media/dvb-frontends/stv0288.c
> +++ b/drivers/media/dvb-frontends/stv0288.c
> @@ -33,7 +33,7 @@
>  #include <linux/jiffies.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "stv0288.h"
>  
>  struct stv0288_state {
> diff --git a/drivers/media/dvb-frontends/stv0288.h b/drivers/media/dvb-frontends/stv0288.h
> index 803acb917282..c10227aaa62c 100644
> --- a/drivers/media/dvb-frontends/stv0288.h
> +++ b/drivers/media/dvb-frontends/stv0288.h
> @@ -28,7 +28,7 @@
>  #define STV0288_H
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct stv0288_config {
>  	/* the demodulator's i2c address */
> diff --git a/drivers/media/dvb-frontends/stv0297.c b/drivers/media/dvb-frontends/stv0297.c
> index db94d4d109f9..b823c04e24d3 100644
> --- a/drivers/media/dvb-frontends/stv0297.c
> +++ b/drivers/media/dvb-frontends/stv0297.c
> @@ -27,7 +27,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "stv0297.h"
>  
>  struct stv0297_state {
> diff --git a/drivers/media/dvb-frontends/stv0297.h b/drivers/media/dvb-frontends/stv0297.h
> index b30632a67333..8fa5ac700fc3 100644
> --- a/drivers/media/dvb-frontends/stv0297.h
> +++ b/drivers/media/dvb-frontends/stv0297.h
> @@ -22,7 +22,7 @@
>  #define STV0297_H
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct stv0297_config
>  {
> diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
> index b1f3d675d316..633b90e6fe86 100644
> --- a/drivers/media/dvb-frontends/stv0299.c
> +++ b/drivers/media/dvb-frontends/stv0299.c
> @@ -51,7 +51,7 @@
>  #include <linux/jiffies.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "stv0299.h"
>  
>  struct stv0299_state {
> diff --git a/drivers/media/dvb-frontends/stv0299.h b/drivers/media/dvb-frontends/stv0299.h
> index 0aca30a8ec25..700c124a1699 100644
> --- a/drivers/media/dvb-frontends/stv0299.h
> +++ b/drivers/media/dvb-frontends/stv0299.h
> @@ -46,7 +46,7 @@
>  #define STV0299_H
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #define STV0299_LOCKOUTPUT_0  0
>  #define STV0299_LOCKOUTPUT_1  1
> diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
> index 4fa119d83bc5..5435c908e298 100644
> --- a/drivers/media/dvb-frontends/stv0367.c
> +++ b/drivers/media/dvb-frontends/stv0367.c
> @@ -25,7 +25,7 @@
>  #include <linux/slab.h>
>  #include <linux/i2c.h>
>  
> -#include "dvb_math.h"
> +#include <media/dvb_math.h>
>  
>  #include "stv0367.h"
>  #include "stv0367_defs.h"
> diff --git a/drivers/media/dvb-frontends/stv0367.h b/drivers/media/dvb-frontends/stv0367.h
> index 8f7a31481744..14a50ecef6dd 100644
> --- a/drivers/media/dvb-frontends/stv0367.h
> +++ b/drivers/media/dvb-frontends/stv0367.h
> @@ -23,7 +23,7 @@
>  #define STV0367_H
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #define STV0367_ICSPEED_53125	53125000
>  #define STV0367_ICSPEED_58000	58000000
> diff --git a/drivers/media/dvb-frontends/stv0900.h b/drivers/media/dvb-frontends/stv0900.h
> index 1571a465e05c..5dbe1e550fe5 100644
> --- a/drivers/media/dvb-frontends/stv0900.h
> +++ b/drivers/media/dvb-frontends/stv0900.h
> @@ -23,7 +23,7 @@
>  #define STV0900_H
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct stv0900_reg {
>  	u16 addr;
> diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
> index e33fb656b7a5..20641bd2f977 100644
> --- a/drivers/media/dvb-frontends/stv090x.c
> +++ b/drivers/media/dvb-frontends/stv090x.c
> @@ -27,7 +27,7 @@
>  #include <linux/mutex.h>
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "stv6110x.h" /* for demodulator internal modes */
>  
> diff --git a/drivers/media/dvb-frontends/stv090x_priv.h b/drivers/media/dvb-frontends/stv090x_priv.h
> index 5b780c80d496..37c9f93a8a6a 100644
> --- a/drivers/media/dvb-frontends/stv090x_priv.h
> +++ b/drivers/media/dvb-frontends/stv090x_priv.h
> @@ -22,7 +22,7 @@
>  #ifndef __STV090x_PRIV_H
>  #define __STV090x_PRIV_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #define FE_ERROR				0
>  #define FE_NOTICE				1
> diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
> index a8c99f41478b..946e55c74afa 100644
> --- a/drivers/media/dvb-frontends/stv0910.c
> +++ b/drivers/media/dvb-frontends/stv0910.c
> @@ -24,7 +24,7 @@
>  #include <linux/i2c.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "stv0910.h"
>  #include "stv0910_regs.h"
>  
> diff --git a/drivers/media/dvb-frontends/stv6110.h b/drivers/media/dvb-frontends/stv6110.h
> index ab73124c0dec..ecfc1faba15c 100644
> --- a/drivers/media/dvb-frontends/stv6110.h
> +++ b/drivers/media/dvb-frontends/stv6110.h
> @@ -22,7 +22,7 @@
>  #define __DVB_STV6110_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /* registers */
>  #define RSTV6110_CTRL1		0
> diff --git a/drivers/media/dvb-frontends/stv6110x.c b/drivers/media/dvb-frontends/stv6110x.c
> index 7e8e01389c55..d4ac29ac9b4f 100644
> --- a/drivers/media/dvb-frontends/stv6110x.c
> +++ b/drivers/media/dvb-frontends/stv6110x.c
> @@ -26,7 +26,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "stv6110x_reg.h"
>  #include "stv6110x.h"
> diff --git a/drivers/media/dvb-frontends/stv6111.c b/drivers/media/dvb-frontends/stv6111.c
> index 789f7b61e628..9b715b6fe152 100644
> --- a/drivers/media/dvb-frontends/stv6111.c
> +++ b/drivers/media/dvb-frontends/stv6111.c
> @@ -25,7 +25,7 @@
>  
>  #include "stv6111.h"
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct stv {
>  	struct i2c_adapter *i2c;
> diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
> index 4687e1546af2..5572b39614d5 100644
> --- a/drivers/media/dvb-frontends/tc90522.c
> +++ b/drivers/media/dvb-frontends/tc90522.c
> @@ -30,7 +30,7 @@
>  #include <linux/kernel.h>
>  #include <linux/math64.h>
>  #include <linux/dvb/frontend.h>
> -#include "dvb_math.h"
> +#include <media/dvb_math.h>
>  #include "tc90522.h"
>  
>  #define TC90522_I2C_THRU_REG 0xfe
> diff --git a/drivers/media/dvb-frontends/tc90522.h b/drivers/media/dvb-frontends/tc90522.h
> index b1cbddfa6ee6..10e585f32499 100644
> --- a/drivers/media/dvb-frontends/tc90522.h
> +++ b/drivers/media/dvb-frontends/tc90522.h
> @@ -25,7 +25,7 @@
>  #define TC90522_H
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /* I2C device types */
>  #define TC90522_I2C_DEV_SAT "tc90522sat"
> diff --git a/drivers/media/dvb-frontends/tda10021.c b/drivers/media/dvb-frontends/tda10021.c
> index 32ba8401e743..4f588ebde39d 100644
> --- a/drivers/media/dvb-frontends/tda10021.c
> +++ b/drivers/media/dvb-frontends/tda10021.c
> @@ -29,7 +29,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "tda1002x.h"
>  
>  
> diff --git a/drivers/media/dvb-frontends/tda10023.c b/drivers/media/dvb-frontends/tda10023.c
> index 8028007c68eb..abe27029fe93 100644
> --- a/drivers/media/dvb-frontends/tda10023.c
> +++ b/drivers/media/dvb-frontends/tda10023.c
> @@ -35,7 +35,7 @@
>  
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "tda1002x.h"
>  
>  #define REG0_INIT_VAL 0x23
> diff --git a/drivers/media/dvb-frontends/tda10048.c b/drivers/media/dvb-frontends/tda10048.c
> index 143b39b5f6c9..de82a2558e15 100644
> --- a/drivers/media/dvb-frontends/tda10048.c
> +++ b/drivers/media/dvb-frontends/tda10048.c
> @@ -27,8 +27,8 @@
>  #include <linux/delay.h>
>  #include <linux/math64.h>
>  #include <asm/div64.h>
> -#include "dvb_frontend.h"
> -#include "dvb_math.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_math.h>
>  #include "tda10048.h"
>  
>  #define TDA10048_DEFAULT_FIRMWARE "dvb-fe-tda10048-1.0.fw"
> diff --git a/drivers/media/dvb-frontends/tda1004x.c b/drivers/media/dvb-frontends/tda1004x.c
> index e674508c349c..58e3beff5adc 100644
> --- a/drivers/media/dvb-frontends/tda1004x.c
> +++ b/drivers/media/dvb-frontends/tda1004x.c
> @@ -36,7 +36,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "tda1004x.h"
>  
>  static int debug;
> diff --git a/drivers/media/dvb-frontends/tda10071_priv.h b/drivers/media/dvb-frontends/tda10071_priv.h
> index b9c3601802ba..67c46e8a7201 100644
> --- a/drivers/media/dvb-frontends/tda10071_priv.h
> +++ b/drivers/media/dvb-frontends/tda10071_priv.h
> @@ -21,7 +21,7 @@
>  #ifndef TDA10071_PRIV
>  #define TDA10071_PRIV
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "tda10071.h"
>  #include <linux/firmware.h>
>  #include <linux/regmap.h>
> diff --git a/drivers/media/dvb-frontends/tda10086.c b/drivers/media/dvb-frontends/tda10086.c
> index b6d16c05904d..1a95c521e97f 100644
> --- a/drivers/media/dvb-frontends/tda10086.c
> +++ b/drivers/media/dvb-frontends/tda10086.c
> @@ -27,7 +27,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "tda10086.h"
>  
>  #define SACLK 96000000
> diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
> index 45cd5ba0cf8a..2e1d36ae943b 100644
> --- a/drivers/media/dvb-frontends/tda18271c2dd.c
> +++ b/drivers/media/dvb-frontends/tda18271c2dd.c
> @@ -27,7 +27,7 @@
>  #include <linux/i2c.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "tda18271c2dd.h"
>  
>  /* Max transfer size done by I2C transfer functions */
> diff --git a/drivers/media/dvb-frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
> index a63dec44295b..3ef7140ed7f3 100644
> --- a/drivers/media/dvb-frontends/tda665x.c
> +++ b/drivers/media/dvb-frontends/tda665x.c
> @@ -22,7 +22,7 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "tda665x.h"
>  
>  struct tda665x_state {
> diff --git a/drivers/media/dvb-frontends/tda8083.c b/drivers/media/dvb-frontends/tda8083.c
> index aa3200d3c352..29b4f64c030c 100644
> --- a/drivers/media/dvb-frontends/tda8083.c
> +++ b/drivers/media/dvb-frontends/tda8083.c
> @@ -30,7 +30,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  #include <linux/jiffies.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "tda8083.h"
>  
>  
> diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
> index 4eb294f330bc..f72a54e7eb23 100644
> --- a/drivers/media/dvb-frontends/tda8261.c
> +++ b/drivers/media/dvb-frontends/tda8261.c
> @@ -23,7 +23,7 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "tda8261.h"
>  
>  struct tda8261_state {
> diff --git a/drivers/media/dvb-frontends/tda826x.h b/drivers/media/dvb-frontends/tda826x.h
> index 6a7bed12e741..0ef35ff3807f 100644
> --- a/drivers/media/dvb-frontends/tda826x.h
> +++ b/drivers/media/dvb-frontends/tda826x.h
> @@ -24,7 +24,7 @@
>  #define __DVB_TDA826X_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /**
>   * Attach a tda826x tuner to the supplied frontend structure.
> diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
> index 931e5c98da8a..07f1726a5774 100644
> --- a/drivers/media/dvb-frontends/ts2020.c
> +++ b/drivers/media/dvb-frontends/ts2020.c
> @@ -19,7 +19,7 @@
>      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "ts2020.h"
>  #include <linux/regmap.h>
>  #include <linux/math64.h>
> diff --git a/drivers/media/dvb-frontends/tua6100.h b/drivers/media/dvb-frontends/tua6100.h
> index 6c098a894ea6..a342bd9c7fbf 100644
> --- a/drivers/media/dvb-frontends/tua6100.h
> +++ b/drivers/media/dvb-frontends/tua6100.h
> @@ -28,7 +28,7 @@
>  #define __DVB_TUA6100_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #if IS_REACHABLE(CONFIG_DVB_TUA6100)
>  extern struct dvb_frontend *tua6100_attach(struct dvb_frontend *fe, int addr, struct i2c_adapter *i2c);
> diff --git a/drivers/media/dvb-frontends/ves1820.c b/drivers/media/dvb-frontends/ves1820.c
> index 178363704bd4..1d8979289915 100644
> --- a/drivers/media/dvb-frontends/ves1820.c
> +++ b/drivers/media/dvb-frontends/ves1820.c
> @@ -27,7 +27,7 @@
>  #include <linux/slab.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "ves1820.h"
>  
>  
> diff --git a/drivers/media/dvb-frontends/ves1x93.c b/drivers/media/dvb-frontends/ves1x93.c
> index d0ee52f66a8e..0c7b3286b04d 100644
> --- a/drivers/media/dvb-frontends/ves1x93.c
> +++ b/drivers/media/dvb-frontends/ves1x93.c
> @@ -30,7 +30,7 @@
>  #include <linux/slab.h>
>  #include <linux/delay.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "ves1x93.h"
>  
>  
> diff --git a/drivers/media/dvb-frontends/zd1301_demod.h b/drivers/media/dvb-frontends/zd1301_demod.h
> index 6cd8f6f9c415..63c13fa4a54b 100644
> --- a/drivers/media/dvb-frontends/zd1301_demod.h
> +++ b/drivers/media/dvb-frontends/zd1301_demod.h
> @@ -19,7 +19,7 @@
>  
>  #include <linux/platform_device.h>
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /**
>   * struct zd1301_demod_platform_data - Platform data for the zd1301_demod driver
> diff --git a/drivers/media/dvb-frontends/zl10036.h b/drivers/media/dvb-frontends/zl10036.h
> index ec90ca927739..a1129ab74296 100644
> --- a/drivers/media/dvb-frontends/zl10036.h
> +++ b/drivers/media/dvb-frontends/zl10036.h
> @@ -18,7 +18,7 @@
>  #define DVB_ZL10036_H
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct zl10036_config {
>  	u8 tuner_address;
> diff --git a/drivers/media/dvb-frontends/zl10039.c b/drivers/media/dvb-frontends/zl10039.c
> index 3208b866d1cb..6293bd920fa6 100644
> --- a/drivers/media/dvb-frontends/zl10039.c
> +++ b/drivers/media/dvb-frontends/zl10039.c
> @@ -21,7 +21,7 @@
>  #include <linux/slab.h>
>  #include <linux/dvb/frontend.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "zl10039.h"
>  
>  static int debug;
> diff --git a/drivers/media/dvb-frontends/zl10353.c b/drivers/media/dvb-frontends/zl10353.c
> index 1c689f7f4ab8..c9901f45deb7 100644
> --- a/drivers/media/dvb-frontends/zl10353.c
> +++ b/drivers/media/dvb-frontends/zl10353.c
> @@ -23,7 +23,7 @@
>  #include <linux/slab.h>
>  #include <asm/div64.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "zl10353_priv.h"
>  #include "zl10353.h"
>  
> diff --git a/drivers/media/firewire/Makefile b/drivers/media/firewire/Makefile
> index 239481344d7c..f96049f5fa90 100644
> --- a/drivers/media/firewire/Makefile
> +++ b/drivers/media/firewire/Makefile
> @@ -2,5 +2,3 @@ obj-$(CONFIG_DVB_FIREDTV) += firedtv.o
>  
>  firedtv-y += firedtv-avc.o firedtv-ci.o firedtv-dvb.o firedtv-fe.o firedtv-fw.o
>  firedtv-$(CONFIG_DVB_FIREDTV_INPUT)    += firedtv-rc.o
> -
> -ccflags-y += -Idrivers/media/dvb-core
> diff --git a/drivers/media/firewire/firedtv-avc.c b/drivers/media/firewire/firedtv-avc.c
> index 5bde6c209cd7..37db04f8104d 100644
> --- a/drivers/media/firewire/firedtv-avc.c
> +++ b/drivers/media/firewire/firedtv-avc.c
> @@ -24,7 +24,7 @@
>  #include <linux/wait.h>
>  #include <linux/workqueue.h>
>  
> -#include <dvb_frontend.h>
> +#include <media/dvb_frontend.h>
>  
>  #include "firedtv.h"
>  
> diff --git a/drivers/media/firewire/firedtv-ci.c b/drivers/media/firewire/firedtv-ci.c
> index edbb30fdd9d9..342c5c853dde 100644
> --- a/drivers/media/firewire/firedtv-ci.c
> +++ b/drivers/media/firewire/firedtv-ci.c
> @@ -15,7 +15,7 @@
>  #include <linux/fs.h>
>  #include <linux/module.h>
>  
> -#include <dvbdev.h>
> +#include <media/dvbdev.h>
>  
>  #include "firedtv.h"
>  
> diff --git a/drivers/media/firewire/firedtv-dvb.c b/drivers/media/firewire/firedtv-dvb.c
> index f710e17953e3..2f7ac79215cc 100644
> --- a/drivers/media/firewire/firedtv-dvb.c
> +++ b/drivers/media/firewire/firedtv-dvb.c
> @@ -18,10 +18,10 @@
>  #include <linux/mutex.h>
>  #include <linux/types.h>
>  
> -#include <dmxdev.h>
> -#include <dvb_demux.h>
> -#include <dvbdev.h>
> -#include <dvb_frontend.h>
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_frontend.h>
>  
>  #include "firedtv.h"
>  
> diff --git a/drivers/media/firewire/firedtv-fe.c b/drivers/media/firewire/firedtv-fe.c
> index 17acda6bcb6e..86efeb10d2f2 100644
> --- a/drivers/media/firewire/firedtv-fe.c
> +++ b/drivers/media/firewire/firedtv-fe.c
> @@ -16,7 +16,7 @@
>  #include <linux/string.h>
>  #include <linux/types.h>
>  
> -#include <dvb_frontend.h>
> +#include <media/dvb_frontend.h>
>  
>  #include "firedtv.h"
>  
> diff --git a/drivers/media/firewire/firedtv-fw.c b/drivers/media/firewire/firedtv-fw.c
> index 247f0e7cb5f7..92f4112d2e37 100644
> --- a/drivers/media/firewire/firedtv-fw.c
> +++ b/drivers/media/firewire/firedtv-fw.c
> @@ -21,7 +21,7 @@
>  
>  #include <asm/page.h>
>  
> -#include <dvb_demux.h>
> +#include <media/dvb_demux.h>
>  
>  #include "firedtv.h"
>  
> diff --git a/drivers/media/firewire/firedtv.h b/drivers/media/firewire/firedtv.h
> index 345d1eda8c05..876cdec8329b 100644
> --- a/drivers/media/firewire/firedtv.h
> +++ b/drivers/media/firewire/firedtv.h
> @@ -24,12 +24,12 @@
>  #include <linux/wait.h>
>  #include <linux/workqueue.h>
>  
> -#include <demux.h>
> -#include <dmxdev.h>
> -#include <dvb_demux.h>
> -#include <dvb_frontend.h>
> -#include <dvb_net.h>
> -#include <dvbdev.h>
> +#include <media/demux.h>
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
> +#include <media/dvbdev.h>
>  
>  struct firedtv_tuner_status {
>  	unsigned active_system:8;
> diff --git a/drivers/media/mmc/siano/Makefile b/drivers/media/mmc/siano/Makefile
> index 0e01f973db6b..5fc345645a80 100644
> --- a/drivers/media/mmc/siano/Makefile
> +++ b/drivers/media/mmc/siano/Makefile
> @@ -1,6 +1,4 @@
>  obj-$(CONFIG_SMS_SDIO_DRV) += smssdio.o
>  
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/common/siano
> -ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
>  
> diff --git a/drivers/media/pci/b2c2/Makefile b/drivers/media/pci/b2c2/Makefile
> index 35d6835ae43e..b43b9167db5a 100644
> --- a/drivers/media/pci/b2c2/Makefile
> +++ b/drivers/media/pci/b2c2/Makefile
> @@ -6,5 +6,4 @@ endif
>  b2c2-flexcop-pci-objs += flexcop-pci.o
>  obj-$(CONFIG_DVB_B2C2_FLEXCOP_PCI) += b2c2-flexcop-pci.o
>  
> -ccflags-y += -Idrivers/media/dvb-core/
>  ccflags-y += -Idrivers/media/common/b2c2/
> diff --git a/drivers/media/pci/bt8xx/Makefile b/drivers/media/pci/bt8xx/Makefile
> index 009f1dc1521f..ab0ea64d3910 100644
> --- a/drivers/media/pci/bt8xx/Makefile
> +++ b/drivers/media/pci/bt8xx/Makefile
> @@ -6,7 +6,6 @@ bttv-objs      :=      bttv-driver.o bttv-cards.o bttv-if.o \
>  obj-$(CONFIG_VIDEO_BT848) += bttv.o
>  obj-$(CONFIG_DVB_BT8XX) += bt878.o dvb-bt8xx.o dst.o dst_ca.o
>  
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
>  ccflags-y += -Idrivers/media/i2c
>  ccflags-y += -Idrivers/media/common
> diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
> index d4bc78b4fcb5..f5f87e03f94b 100644
> --- a/drivers/media/pci/bt8xx/bt878.c
> +++ b/drivers/media/pci/bt8xx/bt878.c
> @@ -40,8 +40,8 @@
>  #include <linux/vmalloc.h>
>  #include <linux/init.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
>  #include "bt878.h"
>  #include "dst_priv.h"
>  
> diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
> index 7166d2279465..4f0bba9e4c48 100644
> --- a/drivers/media/pci/bt8xx/dst.c
> +++ b/drivers/media/pci/bt8xx/dst.c
> @@ -28,7 +28,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/delay.h>
>  #include <asm/div64.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "dst_priv.h"
>  #include "dst_common.h"
>  
> diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
> index 530b3e9764ce..0a7623c0fc8e 100644
> --- a/drivers/media/pci/bt8xx/dst_ca.c
> +++ b/drivers/media/pci/bt8xx/dst_ca.c
> @@ -25,8 +25,8 @@
>  #include <linux/mutex.h>
>  #include <linux/string.h>
>  #include <linux/dvb/ca.h>
> -#include "dvbdev.h"
> -#include "dvb_frontend.h"
> +#include <media/dvbdev.h>
> +#include <media/dvb_frontend.h>
>  #include "dst_ca.h"
>  #include "dst_common.h"
>  
> diff --git a/drivers/media/pci/bt8xx/dvb-bt8xx.c b/drivers/media/pci/bt8xx/dvb-bt8xx.c
> index ad617871ce9b..f60d69ac515b 100644
> --- a/drivers/media/pci/bt8xx/dvb-bt8xx.c
> +++ b/drivers/media/pci/bt8xx/dvb-bt8xx.c
> @@ -26,10 +26,10 @@
>  #include <linux/slab.h>
>  #include <linux/i2c.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
>  #include "dvb-bt8xx.h"
>  #include "bt878.h"
>  
> diff --git a/drivers/media/pci/bt8xx/dvb-bt8xx.h b/drivers/media/pci/bt8xx/dvb-bt8xx.h
> index 0ec538e23b4e..3184b3f3a85e 100644
> --- a/drivers/media/pci/bt8xx/dvb-bt8xx.h
> +++ b/drivers/media/pci/bt8xx/dvb-bt8xx.h
> @@ -23,8 +23,8 @@
>  
>  #include <linux/i2c.h>
>  #include <linux/mutex.h>
> -#include "dvbdev.h"
> -#include "dvb_net.h"
> +#include <media/dvbdev.h>
> +#include <media/dvb_net.h>
>  #include "bttv.h"
>  #include "mt352.h"
>  #include "sp887x.h"
> diff --git a/drivers/media/pci/cx18/Makefile b/drivers/media/pci/cx18/Makefile
> index 98914a40f6ac..9c82c2df05e1 100644
> --- a/drivers/media/pci/cx18/Makefile
> +++ b/drivers/media/pci/cx18/Makefile
> @@ -9,6 +9,5 @@ cx18-alsa-objs := cx18-alsa-main.o cx18-alsa-pcm.o
>  obj-$(CONFIG_VIDEO_CX18) += cx18.o
>  obj-$(CONFIG_VIDEO_CX18_ALSA) += cx18-alsa.o
>  
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
>  ccflags-y += -Idrivers/media/tuners
> diff --git a/drivers/media/pci/cx18/cx18-driver.h b/drivers/media/pci/cx18/cx18-driver.h
> index 7be2088c45fe..3492023a8675 100644
> --- a/drivers/media/pci/cx18/cx18-driver.h
> +++ b/drivers/media/pci/cx18/cx18-driver.h
> @@ -50,12 +50,12 @@
>  #include "cx23418.h"
>  
>  /* DVB */
> -#include "demux.h"
> -#include "dmxdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> -#include "dvbdev.h"
> +#include <media/demux.h>
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
> +#include <media/dvbdev.h>
>  
>  /* Videobuf / YUV support */
>  #include <media/videobuf-core.h>
> diff --git a/drivers/media/pci/cx23885/Makefile b/drivers/media/pci/cx23885/Makefile
> index b8bf7806124b..3f37dcadbaaf 100644
> --- a/drivers/media/pci/cx23885/Makefile
> +++ b/drivers/media/pci/cx23885/Makefile
> @@ -10,7 +10,6 @@ obj-$(CONFIG_MEDIA_ALTERA_CI) += altera-ci.o
>  
>  ccflags-y += -Idrivers/media/i2c
>  ccflags-y += -Idrivers/media/tuners
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
>  
>  ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
> diff --git a/drivers/media/pci/cx23885/altera-ci.c b/drivers/media/pci/cx23885/altera-ci.c
> index 5c94e312cba3..70aec9bb7e95 100644
> --- a/drivers/media/pci/cx23885/altera-ci.c
> +++ b/drivers/media/pci/cx23885/altera-ci.c
> @@ -51,10 +51,10 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> -#include <dvb_demux.h>
> -#include <dvb_frontend.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
>  #include "altera-ci.h"
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  
>  /* FPGA regs */
>  #define NETUP_CI_INT_CTRL	0x00
> diff --git a/drivers/media/pci/cx23885/cimax2.c b/drivers/media/pci/cx23885/cimax2.c
> index 5e8e134d81c2..96f75f658b1b 100644
> --- a/drivers/media/pci/cx23885/cimax2.c
> +++ b/drivers/media/pci/cx23885/cimax2.c
> @@ -21,7 +21,7 @@
>  
>  #include "cx23885.h"
>  #include "cimax2.h"
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  
>  /* Max transfer size done by I2C transfer functions */
>  #define MAX_XFER_SIZE  64
> diff --git a/drivers/media/pci/cx23885/cimax2.h b/drivers/media/pci/cx23885/cimax2.h
> index 565e958f6f8d..167ffe205b5d 100644
> --- a/drivers/media/pci/cx23885/cimax2.h
> +++ b/drivers/media/pci/cx23885/cimax2.h
> @@ -21,7 +21,7 @@
>  
>  #ifndef CIMAX2_H
>  #define CIMAX2_H
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  
>  extern int netup_ci_read_attribute_mem(struct dvb_ca_en50221 *en50221,
>  						int slot, int addr);
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index 67ad04138183..700422b538c0 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -27,7 +27,7 @@
>  
>  #include <media/v4l2-common.h>
>  
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  #include "s5h1409.h"
>  #include "s5h1411.h"
>  #include "mt2131.h"
> diff --git a/drivers/media/pci/cx88/Makefile b/drivers/media/pci/cx88/Makefile
> index 86646eee4e6b..dea0e7ac32e8 100644
> --- a/drivers/media/pci/cx88/Makefile
> +++ b/drivers/media/pci/cx88/Makefile
> @@ -13,5 +13,4 @@ obj-$(CONFIG_VIDEO_CX88_VP3054) += cx88-vp3054-i2c.o
>  
>  ccflags-y += -Idrivers/media/i2c
>  ccflags-y += -Idrivers/media/tuners
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
> diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
> index ec5238870fdb..f58fdec50eab 100644
> --- a/drivers/media/pci/ddbridge/Makefile
> +++ b/drivers/media/pci/ddbridge/Makefile
> @@ -8,7 +8,6 @@ ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-ci.o \
>  
>  obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
>  
> -ccflags-y += -Idrivers/media/dvb-core/
>  ccflags-y += -Idrivers/media/dvb-frontends/
>  ccflags-y += -Idrivers/media/tuners/
>  
> diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
> index 70ac9e576c74..095457737bc1 100644
> --- a/drivers/media/pci/ddbridge/ddbridge.h
> +++ b/drivers/media/pci/ddbridge/ddbridge.h
> @@ -55,13 +55,13 @@
>  #include <linux/device.h>
>  #include <linux/io.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_ringbuffer.h"
> -#include "dvb_ca_en50221.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_ringbuffer.h>
> +#include <media/dvb_ca_en50221.h>
> +#include <media/dvb_net.h>
>  
>  #define DDBRIDGE_VERSION "0.9.32-integrated"
>  
> diff --git a/drivers/media/pci/dm1105/Makefile b/drivers/media/pci/dm1105/Makefile
> index 327585143c83..d22c2547ee86 100644
> --- a/drivers/media/pci/dm1105/Makefile
> +++ b/drivers/media/pci/dm1105/Makefile
> @@ -1,3 +1,3 @@
>  obj-$(CONFIG_DVB_DM1105) += dm1105.o
>  
> -ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends
> +ccflags-y += -Idrivers/media/dvb-frontends
> diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
> index 7c3900dec368..c9db108751a7 100644
> --- a/drivers/media/pci/dm1105/dm1105.c
> +++ b/drivers/media/pci/dm1105/dm1105.c
> @@ -27,12 +27,12 @@
>  #include <linux/slab.h>
>  #include <media/rc-core.h>
>  
> -#include "demux.h"
> -#include "dmxdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> -#include "dvbdev.h"
> +#include <media/demux.h>
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
> +#include <media/dvbdev.h>
>  #include "dvb-pll.h"
>  
>  #include "stv0299.h"
> diff --git a/drivers/media/pci/ivtv/Makefile b/drivers/media/pci/ivtv/Makefile
> index 48f8a23f9a0f..08987a5d55fc 100644
> --- a/drivers/media/pci/ivtv/Makefile
> +++ b/drivers/media/pci/ivtv/Makefile
> @@ -12,6 +12,5 @@ obj-$(CONFIG_VIDEO_FB_IVTV) += ivtvfb.o
>  
>  ccflags-y += -I$(srctree)/drivers/media/i2c
>  ccflags-y += -I$(srctree)/drivers/media/tuners
> -ccflags-y += -I$(srctree)/drivers/media/dvb-core
>  ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
>  
> diff --git a/drivers/media/pci/mantis/Makefile b/drivers/media/pci/mantis/Makefile
> index a684dc2ec79e..b5ef39692cb0 100644
> --- a/drivers/media/pci/mantis/Makefile
> +++ b/drivers/media/pci/mantis/Makefile
> @@ -26,4 +26,4 @@ obj-$(CONFIG_MANTIS_CORE)	+= mantis_core.o
>  obj-$(CONFIG_DVB_MANTIS)	+= mantis.o
>  obj-$(CONFIG_DVB_HOPPER)	+= hopper.o
>  
> -ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends/
> +ccflags-y += -Idrivers/media/dvb-frontends/
> diff --git a/drivers/media/pci/mantis/hopper_cards.c b/drivers/media/pci/mantis/hopper_cards.c
> index ed855e3df558..89759cb80ecb 100644
> --- a/drivers/media/pci/mantis/hopper_cards.c
> +++ b/drivers/media/pci/mantis/hopper_cards.c
> @@ -26,11 +26,11 @@
>  #include <asm/irq.h>
>  #include <linux/interrupt.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  #include "hopper_vp3028.h"
> diff --git a/drivers/media/pci/mantis/hopper_vp3028.c b/drivers/media/pci/mantis/hopper_vp3028.c
> index 1032db6bb789..d58ae0097fea 100644
> --- a/drivers/media/pci/mantis/hopper_vp3028.c
> +++ b/drivers/media/pci/mantis/hopper_vp3028.c
> @@ -22,11 +22,11 @@
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "zl10353.h"
>  #include "mantis_common.h"
> diff --git a/drivers/media/pci/mantis/mantis_ca.c b/drivers/media/pci/mantis/mantis_ca.c
> index 60c6c2f24066..4f0ba457c7e5 100644
> --- a/drivers/media/pci/mantis/mantis_ca.c
> +++ b/drivers/media/pci/mantis/mantis_ca.c
> @@ -24,11 +24,11 @@
>  #include <linux/interrupt.h>
>  #include <asm/io.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  #include "mantis_link.h"
> diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
> index 4ce8a90d69dc..7eb75cb7d75a 100644
> --- a/drivers/media/pci/mantis/mantis_cards.c
> +++ b/drivers/media/pci/mantis/mantis_cards.c
> @@ -27,11 +27,11 @@
>  #include <linux/interrupt.h>
>  #include <media/rc-map.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  
> diff --git a/drivers/media/pci/mantis/mantis_dma.c b/drivers/media/pci/mantis/mantis_dma.c
> index 2ce310b0a022..84406a428330 100644
> --- a/drivers/media/pci/mantis/mantis_dma.c
> +++ b/drivers/media/pci/mantis/mantis_dma.c
> @@ -28,11 +28,11 @@
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  #include "mantis_reg.h"
> diff --git a/drivers/media/pci/mantis/mantis_dvb.c b/drivers/media/pci/mantis/mantis_dvb.c
> index 0db4de3a2285..54dbaa700fa3 100644
> --- a/drivers/media/pci/mantis/mantis_dvb.c
> +++ b/drivers/media/pci/mantis/mantis_dvb.c
> @@ -26,11 +26,11 @@
>  #include <linux/pci.h>
>  #include <linux/i2c.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  #include "mantis_dma.h"
> diff --git a/drivers/media/pci/mantis/mantis_evm.c b/drivers/media/pci/mantis/mantis_evm.c
> index 909ff54868a3..443ac5ab4902 100644
> --- a/drivers/media/pci/mantis/mantis_evm.c
> +++ b/drivers/media/pci/mantis/mantis_evm.c
> @@ -25,11 +25,11 @@
>  #include <linux/interrupt.h>
>  #include <asm/io.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  #include "mantis_link.h"
> diff --git a/drivers/media/pci/mantis/mantis_hif.c b/drivers/media/pci/mantis/mantis_hif.c
> index 10c68df7e16f..bf61f8c5a59f 100644
> --- a/drivers/media/pci/mantis/mantis_hif.c
> +++ b/drivers/media/pci/mantis/mantis_hif.c
> @@ -25,11 +25,11 @@
>  #include <linux/interrupt.h>
>  #include <asm/io.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  
> diff --git a/drivers/media/pci/mantis/mantis_i2c.c b/drivers/media/pci/mantis/mantis_i2c.c
> index 496c10dfc4df..6528a2180119 100644
> --- a/drivers/media/pci/mantis/mantis_i2c.c
> +++ b/drivers/media/pci/mantis/mantis_i2c.c
> @@ -23,11 +23,11 @@
>  #include <linux/pci.h>
>  #include <linux/i2c.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  #include "mantis_reg.h"
> diff --git a/drivers/media/pci/mantis/mantis_input.c b/drivers/media/pci/mantis/mantis_input.c
> index 7519dcc934dd..5b472e9b9542 100644
> --- a/drivers/media/pci/mantis/mantis_input.c
> +++ b/drivers/media/pci/mantis/mantis_input.c
> @@ -17,11 +17,11 @@
>  #include <media/rc-core.h>
>  #include <linux/pci.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  #include "mantis_input.h"
> diff --git a/drivers/media/pci/mantis/mantis_ioc.c b/drivers/media/pci/mantis/mantis_ioc.c
> index 24fcdc63d6d5..f45c2340a493 100644
> --- a/drivers/media/pci/mantis/mantis_ioc.c
> +++ b/drivers/media/pci/mantis/mantis_ioc.c
> @@ -26,11 +26,11 @@
>  #include <linux/interrupt.h>
>  #include <asm/io.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  #include "mantis_reg.h"
> diff --git a/drivers/media/pci/mantis/mantis_link.h b/drivers/media/pci/mantis/mantis_link.h
> index 2a814774a001..c6698976fc2f 100644
> --- a/drivers/media/pci/mantis/mantis_link.h
> +++ b/drivers/media/pci/mantis/mantis_link.h
> @@ -23,7 +23,7 @@
>  
>  #include <linux/mutex.h>
>  #include <linux/workqueue.h>
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  
>  enum mantis_sbuf_status {
>  	MANTIS_SBUF_DATA_AVAIL		= 1,
> diff --git a/drivers/media/pci/mantis/mantis_pci.c b/drivers/media/pci/mantis/mantis_pci.c
> index 9e89e045213a..d590524b4171 100644
> --- a/drivers/media/pci/mantis/mantis_pci.c
> +++ b/drivers/media/pci/mantis/mantis_pci.c
> @@ -34,11 +34,11 @@
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  #include "mantis_reg.h"
> diff --git a/drivers/media/pci/mantis/mantis_pcmcia.c b/drivers/media/pci/mantis/mantis_pcmcia.c
> index b2dbc7b2e0f6..2a316b988c07 100644
> --- a/drivers/media/pci/mantis/mantis_pcmcia.c
> +++ b/drivers/media/pci/mantis/mantis_pcmcia.c
> @@ -25,11 +25,11 @@
>  #include <linux/interrupt.h>
>  #include <asm/io.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  #include "mantis_link.h" /* temporary due to physical layer stuff */
> diff --git a/drivers/media/pci/mantis/mantis_uart.c b/drivers/media/pci/mantis/mantis_uart.c
> index f1c96aec8c7b..18f81c135996 100644
> --- a/drivers/media/pci/mantis/mantis_uart.c
> +++ b/drivers/media/pci/mantis/mantis_uart.c
> @@ -27,11 +27,11 @@
>  #include <linux/interrupt.h>
>  #include <linux/pci.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  #include "mantis_reg.h"
> diff --git a/drivers/media/pci/mantis/mantis_vp1033.c b/drivers/media/pci/mantis/mantis_vp1033.c
> index 12a6adb2bd7e..54d2ab409cc5 100644
> --- a/drivers/media/pci/mantis/mantis_vp1033.c
> +++ b/drivers/media/pci/mantis/mantis_vp1033.c
> @@ -22,11 +22,11 @@
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "stv0299.h"
>  #include "mantis_common.h"
> diff --git a/drivers/media/pci/mantis/mantis_vp1034.c b/drivers/media/pci/mantis/mantis_vp1034.c
> index e4972ff823c2..26672a49b86f 100644
> --- a/drivers/media/pci/mantis/mantis_vp1034.c
> +++ b/drivers/media/pci/mantis/mantis_vp1034.c
> @@ -23,11 +23,11 @@
>  #include <linux/interrupt.h>
>  #include <asm/io.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mb86a16.h"
>  #include "mantis_common.h"
> diff --git a/drivers/media/pci/mantis/mantis_vp1034.h b/drivers/media/pci/mantis/mantis_vp1034.h
> index 764b1c66ea1b..35af4e5dcc8c 100644
> --- a/drivers/media/pci/mantis/mantis_vp1034.h
> +++ b/drivers/media/pci/mantis/mantis_vp1034.h
> @@ -21,7 +21,7 @@
>  #ifndef __MANTIS_VP1034_H
>  #define __MANTIS_VP1034_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "mantis_common.h"
>  
>  
> diff --git a/drivers/media/pci/mantis/mantis_vp1041.c b/drivers/media/pci/mantis/mantis_vp1041.c
> index 7082fcbc94a1..47e0c48c3abc 100644
> --- a/drivers/media/pci/mantis/mantis_vp1041.c
> +++ b/drivers/media/pci/mantis/mantis_vp1041.c
> @@ -22,11 +22,11 @@
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "mantis_common.h"
>  #include "mantis_ioc.h"
> diff --git a/drivers/media/pci/mantis/mantis_vp2033.c b/drivers/media/pci/mantis/mantis_vp2033.c
> index 8d48b5abe04a..d98e0a3edaab 100644
> --- a/drivers/media/pci/mantis/mantis_vp2033.c
> +++ b/drivers/media/pci/mantis/mantis_vp2033.c
> @@ -22,11 +22,11 @@
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "tda1002x.h"
>  #include "mantis_common.h"
> diff --git a/drivers/media/pci/mantis/mantis_vp2040.c b/drivers/media/pci/mantis/mantis_vp2040.c
> index 8dd17d7c0881..2c52f3d4e2bc 100644
> --- a/drivers/media/pci/mantis/mantis_vp2040.c
> +++ b/drivers/media/pci/mantis/mantis_vp2040.c
> @@ -22,11 +22,11 @@
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "tda1002x.h"
>  #include "mantis_common.h"
> diff --git a/drivers/media/pci/mantis/mantis_vp3028.h b/drivers/media/pci/mantis/mantis_vp3028.h
> index b07be6adc522..34130d29e0aa 100644
> --- a/drivers/media/pci/mantis/mantis_vp3028.h
> +++ b/drivers/media/pci/mantis/mantis_vp3028.h
> @@ -21,7 +21,7 @@
>  #ifndef __MANTIS_VP3028_H
>  #define __MANTIS_VP3028_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "mantis_common.h"
>  #include "zl10353.h"
>  
> diff --git a/drivers/media/pci/mantis/mantis_vp3030.c b/drivers/media/pci/mantis/mantis_vp3030.c
> index 5c1dd925bdd5..14f6e153000c 100644
> --- a/drivers/media/pci/mantis/mantis_vp3030.c
> +++ b/drivers/media/pci/mantis/mantis_vp3030.c
> @@ -22,11 +22,11 @@
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "zl10353.h"
>  #include "tda665x.h"
> diff --git a/drivers/media/pci/netup_unidvb/Makefile b/drivers/media/pci/netup_unidvb/Makefile
> index 07d3f1eb728b..944c3e164157 100644
> --- a/drivers/media/pci/netup_unidvb/Makefile
> +++ b/drivers/media/pci/netup_unidvb/Makefile
> @@ -6,5 +6,4 @@ netup-unidvb-objs += netup_unidvb_spi.o
>  
>  obj-$(CONFIG_DVB_NETUP_UNIDVB) += netup-unidvb.o
>  
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
> diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb.h b/drivers/media/pci/netup_unidvb/netup_unidvb.h
> index 39b08ecda1fc..3253ac324841 100644
> --- a/drivers/media/pci/netup_unidvb/netup_unidvb.h
> +++ b/drivers/media/pci/netup_unidvb/netup_unidvb.h
> @@ -24,7 +24,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-device.h>
>  #include <media/videobuf2-dvb.h>
> -#include <dvb_ca_en50221.h>
> +#include <media/dvb_ca_en50221.h>
>  
>  #define NETUP_UNIDVB_NAME	"netup_unidvb"
>  #define NETUP_UNIDVB_VERSION	"0.0.1"
> diff --git a/drivers/media/pci/ngene/Makefile b/drivers/media/pci/ngene/Makefile
> index dbdf284970f8..e4208f5ed215 100644
> --- a/drivers/media/pci/ngene/Makefile
> +++ b/drivers/media/pci/ngene/Makefile
> @@ -7,7 +7,6 @@ ngene-objs := ngene-core.o ngene-i2c.o ngene-cards.o ngene-dvb.o
>  
>  obj-$(CONFIG_DVB_NGENE) += ngene.o
>  
> -ccflags-y += -Idrivers/media/dvb-core/
>  ccflags-y += -Idrivers/media/dvb-frontends/
>  ccflags-y += -Idrivers/media/tuners/
>  
> diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
> index 7c7cd217333d..02dbd18f92d0 100644
> --- a/drivers/media/pci/ngene/ngene.h
> +++ b/drivers/media/pci/ngene/ngene.h
> @@ -29,13 +29,13 @@
>  
>  #include <linux/dvb/frontend.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_ca_en50221.h"
> -#include "dvb_frontend.h"
> -#include "dvb_ringbuffer.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_ca_en50221.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_ringbuffer.h>
> +#include <media/dvb_net.h>
>  #include "cxd2099.h"
>  
>  #define DEVICE_NAME "ngene"
> diff --git a/drivers/media/pci/pluto2/Makefile b/drivers/media/pci/pluto2/Makefile
> index 524bf841f42b..3c2aea1ac752 100644
> --- a/drivers/media/pci/pluto2/Makefile
> +++ b/drivers/media/pci/pluto2/Makefile
> @@ -1,3 +1,3 @@
>  obj-$(CONFIG_DVB_PLUTO2) += pluto2.o
>  
> -ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends/
> +ccflags-y += -Idrivers/media/dvb-frontends/
> diff --git a/drivers/media/pci/pluto2/pluto2.c b/drivers/media/pci/pluto2/pluto2.c
> index 39dcba2b620c..ecdca0ba3e66 100644
> --- a/drivers/media/pci/pluto2/pluto2.c
> +++ b/drivers/media/pci/pluto2/pluto2.c
> @@ -29,12 +29,12 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>
>  
> -#include "demux.h"
> -#include "dmxdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> -#include "dvbdev.h"
> +#include <media/demux.h>
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
> +#include <media/dvbdev.h>
>  #include "tda1004x.h"
>  
>  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
> diff --git a/drivers/media/pci/pt1/Makefile b/drivers/media/pci/pt1/Makefile
> index 98e391295afe..ab873ae088a0 100644
> --- a/drivers/media/pci/pt1/Makefile
> +++ b/drivers/media/pci/pt1/Makefile
> @@ -2,4 +2,4 @@ earth-pt1-objs := pt1.o va1j5jf8007s.o va1j5jf8007t.o
>  
>  obj-$(CONFIG_DVB_PT1) += earth-pt1.o
>  
> -ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb-frontends
> +ccflags-y += -Idrivers/media/dvb-frontends
> diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
> index acc3afeb6224..ac16cf3b065b 100644
> --- a/drivers/media/pci/pt1/pt1.c
> +++ b/drivers/media/pci/pt1/pt1.c
> @@ -27,11 +27,11 @@
>  #include <linux/freezer.h>
>  #include <linux/ratelimit.h>
>  
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dmxdev.h"
> -#include "dvb_net.h"
> -#include "dvb_frontend.h"
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dmxdev.h>
> +#include <media/dvb_net.h>
> +#include <media/dvb_frontend.h>
>  
>  #include "va1j5jf8007t.h"
>  #include "va1j5jf8007s.h"
> diff --git a/drivers/media/pci/pt1/va1j5jf8007s.c b/drivers/media/pci/pt1/va1j5jf8007s.c
> index f75f69556be7..2cf776531dc6 100644
> --- a/drivers/media/pci/pt1/va1j5jf8007s.c
> +++ b/drivers/media/pci/pt1/va1j5jf8007s.c
> @@ -21,7 +21,7 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "va1j5jf8007s.h"
>  
>  enum va1j5jf8007s_tune_state {
> diff --git a/drivers/media/pci/pt1/va1j5jf8007t.c b/drivers/media/pci/pt1/va1j5jf8007t.c
> index 63fda79a75c0..d9788d153bb6 100644
> --- a/drivers/media/pci/pt1/va1j5jf8007t.c
> +++ b/drivers/media/pci/pt1/va1j5jf8007t.c
> @@ -21,8 +21,8 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> -#include "dvb_math.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_math.h>
>  #include "va1j5jf8007t.h"
>  
>  enum va1j5jf8007t_tune_state {
> diff --git a/drivers/media/pci/pt3/Makefile b/drivers/media/pci/pt3/Makefile
> index aded8752ac2b..8698d5dfaf52 100644
> --- a/drivers/media/pci/pt3/Makefile
> +++ b/drivers/media/pci/pt3/Makefile
> @@ -4,6 +4,5 @@ earth-pt3-objs += pt3.o pt3_i2c.o pt3_dma.o
>  
>  obj-$(CONFIG_DVB_PT3) += earth-pt3.o
>  
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
>  ccflags-y += -Idrivers/media/tuners
> diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
> index 34044a45fecc..da74828805bc 100644
> --- a/drivers/media/pci/pt3/pt3.c
> +++ b/drivers/media/pci/pt3/pt3.c
> @@ -23,10 +23,10 @@
>  #include <linux/string.h>
>  #include <linux/sched/signal.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
>  
>  #include "pt3.h"
>  
> diff --git a/drivers/media/pci/pt3/pt3.h b/drivers/media/pci/pt3/pt3.h
> index 1b3f2ad25db3..fbe8d9b847b0 100644
> --- a/drivers/media/pci/pt3/pt3.h
> +++ b/drivers/media/pci/pt3/pt3.h
> @@ -20,9 +20,9 @@
>  #include <linux/atomic.h>
>  #include <linux/types.h>
>  
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dmxdev.h"
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dmxdev.h>
>  
>  #include "tc90522.h"
>  #include "mxl301rf.h"
> diff --git a/drivers/media/pci/saa7134/Makefile b/drivers/media/pci/saa7134/Makefile
> index dbaadddf4320..959f2766b093 100644
> --- a/drivers/media/pci/saa7134/Makefile
> +++ b/drivers/media/pci/saa7134/Makefile
> @@ -14,6 +14,5 @@ obj-$(CONFIG_VIDEO_SAA7134_DVB) += saa7134-dvb.o
>  
>  ccflags-y += -I$(srctree)/drivers/media/i2c
>  ccflags-y += -I$(srctree)/drivers/media/tuners
> -ccflags-y += -I$(srctree)/drivers/media/dvb-core
>  ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
>  ccflags-y += -I$(srctree)/drivers/media/usb/go7007
> diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
> index 731dee0a66e7..b55f9a1d9a63 100644
> --- a/drivers/media/pci/saa7134/saa7134-dvb.c
> +++ b/drivers/media/pci/saa7134/saa7134-dvb.c
> @@ -29,7 +29,7 @@
>  
>  #include <media/v4l2-common.h>
>  #include "dvb-pll.h"
> -#include <dvb_frontend.h>
> +#include <media/dvb_frontend.h>
>  
>  #include "mt352.h"
>  #include "mt352_priv.h" /* FIXME */
> diff --git a/drivers/media/pci/saa7164/Makefile b/drivers/media/pci/saa7164/Makefile
> index 3896bcdb99d2..54840d659a5d 100644
> --- a/drivers/media/pci/saa7164/Makefile
> +++ b/drivers/media/pci/saa7164/Makefile
> @@ -7,7 +7,6 @@ obj-$(CONFIG_VIDEO_SAA7164) += saa7164.o
>  
>  ccflags-y += -I$(srctree)/drivers/media/i2c
>  ccflags-y += -I$(srctree)/drivers/media/tuners
> -ccflags-y += -I$(srctree)/drivers/media/dvb-core
>  ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
>  
>  ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
> diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
> index 81b3f0e19993..f3358f43195f 100644
> --- a/drivers/media/pci/saa7164/saa7164.h
> +++ b/drivers/media/pci/saa7164/saa7164.h
> @@ -50,11 +50,11 @@
>  
>  #include <media/tuner.h>
>  #include <media/tveeprom.h>
> -#include <dvb_demux.h>
> -#include <dvb_frontend.h>
> -#include <dvb_net.h>
> -#include <dvbdev.h>
> -#include <dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
> +#include <media/dvbdev.h>
> +#include <media/dmxdev.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-device.h>
> diff --git a/drivers/media/pci/smipcie/Makefile b/drivers/media/pci/smipcie/Makefile
> index 6006aac3c41f..214ebfe12cf7 100644
> --- a/drivers/media/pci/smipcie/Makefile
> +++ b/drivers/media/pci/smipcie/Makefile
> @@ -5,6 +5,5 @@ smipcie-objs	:= smipcie-main.o smipcie-ir.o
>  obj-$(CONFIG_DVB_SMIPCIE) += smipcie.o
>  
>  ccflags-y += -Idrivers/media/tuners
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
>  
> diff --git a/drivers/media/pci/smipcie/smipcie.h b/drivers/media/pci/smipcie/smipcie.h
> index c8368c78ddd5..a6c5b1bd7edb 100644
> --- a/drivers/media/pci/smipcie/smipcie.h
> +++ b/drivers/media/pci/smipcie/smipcie.h
> @@ -29,12 +29,12 @@
>  #include <linux/slab.h>
>  #include <media/rc-core.h>
>  
> -#include "demux.h"
> -#include "dmxdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> -#include "dvbdev.h"
> +#include <media/demux.h>
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
> +#include <media/dvbdev.h>
>  
>  /* -------- Register Base -------- */
>  #define    MSI_CONTROL_REG_BASE                 0x0800
> diff --git a/drivers/media/pci/ttpci/Makefile b/drivers/media/pci/ttpci/Makefile
> index 0b805339c123..58ca12732aad 100644
> --- a/drivers/media/pci/ttpci/Makefile
> +++ b/drivers/media/pci/ttpci/Makefile
> @@ -18,5 +18,5 @@ obj-$(CONFIG_DVB_BUDGET_CI) += budget-ci.o
>  obj-$(CONFIG_DVB_BUDGET_PATCH) += budget-patch.o
>  obj-$(CONFIG_DVB_AV7110) += dvb-ttpci.o
>  
> -ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends/
> +ccflags-y += -Idrivers/media/dvb-frontends/
>  ccflags-y += -Idrivers/media/tuners
> diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
> index 6d415bdeef18..dc8e577b2f74 100644
> --- a/drivers/media/pci/ttpci/av7110.c
> +++ b/drivers/media/pci/ttpci/av7110.c
> @@ -53,7 +53,7 @@
>  
>  #include <linux/dvb/frontend.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "ttpci-eeprom.h"
>  #include "av7110.h"
> diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
> index cbb150d6cbb1..9bfbb1471717 100644
> --- a/drivers/media/pci/ttpci/av7110.h
> +++ b/drivers/media/pci/ttpci/av7110.h
> @@ -17,14 +17,14 @@
>  #include <linux/dvb/net.h>
>  #include <linux/mutex.h>
>  
> -#include "dvbdev.h"
> -#include "demux.h"
> -#include "dvb_demux.h"
> -#include "dmxdev.h"
> +#include <media/dvbdev.h>
> +#include <media/demux.h>
> +#include <media/dvb_demux.h>
> +#include <media/dmxdev.h>
>  #include "dvb_filter.h"
> -#include "dvb_net.h"
> -#include "dvb_ringbuffer.h"
> -#include "dvb_frontend.h"
> +#include <media/dvb_net.h>
> +#include <media/dvb_ringbuffer.h>
> +#include <media/dvb_frontend.h>
>  #include "ves1820.h"
>  #include "ves1x93.h"
>  #include "stv0299.h"
> diff --git a/drivers/media/pci/ttpci/budget-av.c b/drivers/media/pci/ttpci/budget-av.c
> index ac83fff9fe0b..6b0e09ca01dc 100644
> --- a/drivers/media/pci/ttpci/budget-av.c
> +++ b/drivers/media/pci/ttpci/budget-av.c
> @@ -51,7 +51,7 @@
>  #include <linux/input.h>
>  #include <linux/spinlock.h>
>  
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  
>  #define DEBICICAM		0x02420000
>  
> diff --git a/drivers/media/pci/ttpci/budget-ci.c b/drivers/media/pci/ttpci/budget-ci.c
> index 57af11804fd6..f67ed118f273 100644
> --- a/drivers/media/pci/ttpci/budget-ci.c
> +++ b/drivers/media/pci/ttpci/budget-ci.c
> @@ -35,7 +35,7 @@
>  
>  #include "budget.h"
>  
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  #include "stv0299.h"
>  #include "stv0297.h"
>  #include "tda1004x.h"
> diff --git a/drivers/media/pci/ttpci/budget.h b/drivers/media/pci/ttpci/budget.h
> index fae83866b199..a7463daf39f1 100644
> --- a/drivers/media/pci/ttpci/budget.h
> +++ b/drivers/media/pci/ttpci/budget.h
> @@ -3,13 +3,13 @@
>  #ifndef __BUDGET_DVB__
>  #define __BUDGET_DVB__
>  
> -#include "dvb_frontend.h"
> -#include "dvbdev.h"
> -#include "demux.h"
> -#include "dvb_demux.h"
> -#include "dmxdev.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvbdev.h>
> +#include <media/demux.h>
> +#include <media/dvb_demux.h>
> +#include <media/dmxdev.h>
>  #include "dvb_filter.h"
> -#include "dvb_net.h"
> +#include <media/dvb_net.h>
>  
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> diff --git a/drivers/media/pci/ttpci/dvb_filter.h b/drivers/media/pci/ttpci/dvb_filter.h
> index 3d410d02a987..67a3c6333bca 100644
> --- a/drivers/media/pci/ttpci/dvb_filter.h
> +++ b/drivers/media/pci/ttpci/dvb_filter.h
> @@ -19,7 +19,7 @@
>  
>  #include <linux/slab.h>
>  
> -#include "demux.h"
> +#include <media/demux.h>
>  
>  typedef int (dvb_filter_pes2ts_cb_t) (void *, unsigned char *);
>  
> diff --git a/drivers/media/platform/sti/c8sectpfe/Makefile b/drivers/media/platform/sti/c8sectpfe/Makefile
> index b642b4fd5045..927dd930c943 100644
> --- a/drivers/media/platform/sti/c8sectpfe/Makefile
> +++ b/drivers/media/platform/sti/c8sectpfe/Makefile
> @@ -6,5 +6,5 @@ obj-$(CONFIG_DVB_C8SECTPFE) += c8sectpfe.o
>  
>  ccflags-y += -Idrivers/media/i2c
>  ccflags-y += -Idrivers/media/common
> -ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends/ \
> -		-Idrivers/media/tuners/
> +ccflags-y += -Idrivers/media/dvb-frontends/
> +ccflags-y += -Idrivers/media/tuners/
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c
> index c64909e5ab64..5df67da25525 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c
> @@ -21,11 +21,11 @@
>  #include <linux/time.h>
>  #include <linux/wait.h>
>  
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvbdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #include "c8sectpfe-common.h"
>  #include "c8sectpfe-core.h"
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h
> index 694f63832d3f..5ab7ca448cf9 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h
> @@ -15,10 +15,10 @@
>  #include <linux/gpio.h>
>  #include <linux/version.h>
>  
> -#include "dmxdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  /* Maximum number of channels */
>  #define C8SECTPFE_MAXADAPTER (4)
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
> index 34a9cca6b707..3c05b3dc49ec 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
> @@ -35,10 +35,10 @@
>  #include "c8sectpfe-core.h"
>  #include "c8sectpfe-common.h"
>  #include "c8sectpfe-debugfs.h"
> -#include "dmxdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  
>  #define FIRMWARE_MEMDMA "pti_memdma_h407.elf"
>  MODULE_FIRMWARE(FIRMWARE_MEMDMA);
> diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
> index cb5f71b3bd78..0ff21f1c7eed 100644
> --- a/drivers/media/tuners/Makefile
> +++ b/drivers/media/tuners/Makefile
> @@ -44,5 +44,4 @@ obj-$(CONFIG_MEDIA_TUNER_QM1D1C0042) += qm1d1c0042.o
>  obj-$(CONFIG_MEDIA_TUNER_M88RS6000T) += m88rs6000t.o
>  obj-$(CONFIG_MEDIA_TUNER_TDA18250) += tda18250.o
>  
> -ccflags-y += -I$(srctree)/drivers/media/dvb-core
>  ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
> diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
> index aa9340c05b43..9a65208c5bc3 100644
> --- a/drivers/media/tuners/e4000.h
> +++ b/drivers/media/tuners/e4000.h
> @@ -21,7 +21,7 @@
>  #ifndef E4000_H
>  #define E4000_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /*
>   * I2C address
> diff --git a/drivers/media/tuners/fc0011.h b/drivers/media/tuners/fc0011.h
> index a36871c44c8c..ebae37cc6f5f 100644
> --- a/drivers/media/tuners/fc0011.h
> +++ b/drivers/media/tuners/fc0011.h
> @@ -2,7 +2,7 @@
>  #ifndef LINUX_FC0011_H_
>  #define LINUX_FC0011_H_
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  
>  /** struct fc0011_config - fc0011 hardware config
> diff --git a/drivers/media/tuners/fc0012.h b/drivers/media/tuners/fc0012.h
> index 64d07a2adb2e..29e84c434de1 100644
> --- a/drivers/media/tuners/fc0012.h
> +++ b/drivers/media/tuners/fc0012.h
> @@ -17,7 +17,7 @@
>  #ifndef _FC0012_H_
>  #define _FC0012_H_
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "fc001x-common.h"
>  
>  struct fc0012_config {
> diff --git a/drivers/media/tuners/fc0013.h b/drivers/media/tuners/fc0013.h
> index 4431e7ceb43d..2d039250c783 100644
> --- a/drivers/media/tuners/fc0013.h
> +++ b/drivers/media/tuners/fc0013.h
> @@ -18,7 +18,7 @@
>  #ifndef _FC0013_H_
>  #define _FC0013_H_
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "fc001x-common.h"
>  
>  #if IS_REACHABLE(CONFIG_MEDIA_TUNER_FC0013)
> diff --git a/drivers/media/tuners/fc2580.h b/drivers/media/tuners/fc2580.h
> index 862ea46995d7..a04fba6b0b8a 100644
> --- a/drivers/media/tuners/fc2580.h
> +++ b/drivers/media/tuners/fc2580.h
> @@ -21,7 +21,7 @@
>  #ifndef FC2580_H
>  #define FC2580_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include <media/v4l2-subdev.h>
>  #include <linux/i2c.h>
>  
> diff --git a/drivers/media/tuners/it913x.h b/drivers/media/tuners/it913x.h
> index 226f657228fb..3cb219a4a645 100644
> --- a/drivers/media/tuners/it913x.h
> +++ b/drivers/media/tuners/it913x.h
> @@ -19,7 +19,7 @@
>  #ifndef IT913X_H
>  #define IT913X_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /**
>   * struct it913x_platform_data - Platform data for the it913x driver
> diff --git a/drivers/media/tuners/m88rs6000t.h b/drivers/media/tuners/m88rs6000t.h
> index 264c13e2cd39..318b48c8f843 100644
> --- a/drivers/media/tuners/m88rs6000t.h
> +++ b/drivers/media/tuners/m88rs6000t.h
> @@ -17,7 +17,7 @@
>  #ifndef _M88RS6000T_H_
>  #define _M88RS6000T_H_
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct m88rs6000t_config {
>  	/*
> diff --git a/drivers/media/tuners/max2165.c b/drivers/media/tuners/max2165.c
> index a86c08114915..20ceb72e530b 100644
> --- a/drivers/media/tuners/max2165.c
> +++ b/drivers/media/tuners/max2165.c
> @@ -23,7 +23,7 @@
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "max2165.h"
>  #include "max2165_priv.h"
> diff --git a/drivers/media/tuners/mc44s803.c b/drivers/media/tuners/mc44s803.c
> index 12f545ef1243..403c6b2aa53b 100644
> --- a/drivers/media/tuners/mc44s803.c
> +++ b/drivers/media/tuners/mc44s803.c
> @@ -21,7 +21,7 @@
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "mc44s803.h"
>  #include "mc44s803_priv.h"
> diff --git a/drivers/media/tuners/mt2060.c b/drivers/media/tuners/mt2060.c
> index 4983eeb39f36..3d3c6815b6a7 100644
> --- a/drivers/media/tuners/mt2060.c
> +++ b/drivers/media/tuners/mt2060.c
> @@ -23,7 +23,7 @@
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "mt2060.h"
>  #include "mt2060_priv.h"
> diff --git a/drivers/media/tuners/mt2063.h b/drivers/media/tuners/mt2063.h
> index 0e3e3b0525bb..30d03cd76061 100644
> --- a/drivers/media/tuners/mt2063.h
> +++ b/drivers/media/tuners/mt2063.h
> @@ -2,7 +2,7 @@
>  #ifndef __MT2063_H__
>  #define __MT2063_H__
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct mt2063_config {
>  	u8 tuner_address;
> diff --git a/drivers/media/tuners/mt20xx.h b/drivers/media/tuners/mt20xx.h
> index 9912362b415e..3cc41a57dca9 100644
> --- a/drivers/media/tuners/mt20xx.h
> +++ b/drivers/media/tuners/mt20xx.h
> @@ -18,7 +18,7 @@
>  #define __MT20XX_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #if IS_REACHABLE(CONFIG_MEDIA_TUNER_MT20XX)
>  extern struct dvb_frontend *microtune_attach(struct dvb_frontend *fe,
> diff --git a/drivers/media/tuners/mt2131.c b/drivers/media/tuners/mt2131.c
> index dd85d58fa8d0..659bf19dc434 100644
> --- a/drivers/media/tuners/mt2131.c
> +++ b/drivers/media/tuners/mt2131.c
> @@ -21,7 +21,7 @@
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "mt2131.h"
>  #include "mt2131_priv.h"
> diff --git a/drivers/media/tuners/mt2266.c b/drivers/media/tuners/mt2266.c
> index 88edcc031e3c..f4545b7f5da2 100644
> --- a/drivers/media/tuners/mt2266.c
> +++ b/drivers/media/tuners/mt2266.c
> @@ -20,7 +20,7 @@
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "mt2266.h"
>  
>  #define I2C_ADDRESS 0x60
> diff --git a/drivers/media/tuners/mxl301rf.h b/drivers/media/tuners/mxl301rf.h
> index 19e68405f00d..d32d4e8dc448 100644
> --- a/drivers/media/tuners/mxl301rf.h
> +++ b/drivers/media/tuners/mxl301rf.h
> @@ -17,7 +17,7 @@
>  #ifndef MXL301RF_H
>  #define MXL301RF_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct mxl301rf_config {
>  	struct dvb_frontend *fe;
> diff --git a/drivers/media/tuners/mxl5005s.c b/drivers/media/tuners/mxl5005s.c
> index 77a0fa1d1a2f..57c6d9061072 100644
> --- a/drivers/media/tuners/mxl5005s.c
> +++ b/drivers/media/tuners/mxl5005s.c
> @@ -63,7 +63,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "mxl5005s.h"
>  
>  static int debug;
> diff --git a/drivers/media/tuners/mxl5005s.h b/drivers/media/tuners/mxl5005s.h
> index d842734f2dcd..9ac0811a162e 100644
> --- a/drivers/media/tuners/mxl5005s.h
> +++ b/drivers/media/tuners/mxl5005s.h
> @@ -24,7 +24,7 @@
>  #define __MXL5005S_H
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct mxl5005s_config {
>  
> diff --git a/drivers/media/tuners/mxl5007t.h b/drivers/media/tuners/mxl5007t.h
> index 273f61aeb8be..f7f16b86fcae 100644
> --- a/drivers/media/tuners/mxl5007t.h
> +++ b/drivers/media/tuners/mxl5007t.h
> @@ -17,7 +17,7 @@
>  #ifndef __MXL5007T_H__
>  #define __MXL5007T_H__
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /* ------------------------------------------------------------------------- */
>  
> diff --git a/drivers/media/tuners/qm1d1c0042.h b/drivers/media/tuners/qm1d1c0042.h
> index 4f5c18816c44..8331f8baa094 100644
> --- a/drivers/media/tuners/qm1d1c0042.h
> +++ b/drivers/media/tuners/qm1d1c0042.h
> @@ -17,7 +17,7 @@
>  #ifndef QM1D1C0042_H
>  #define QM1D1C0042_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  
>  struct qm1d1c0042_config {
> diff --git a/drivers/media/tuners/qt1010.h b/drivers/media/tuners/qt1010.h
> index 276e59e85032..24216c2a8154 100644
> --- a/drivers/media/tuners/qt1010.h
> +++ b/drivers/media/tuners/qt1010.h
> @@ -18,7 +18,7 @@
>  #ifndef QT1010_H
>  #define QT1010_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct qt1010_config {
>  	u8 i2c_address;
> diff --git a/drivers/media/tuners/r820t.h b/drivers/media/tuners/r820t.h
> index fdcab91405de..4f91dbb29c3a 100644
> --- a/drivers/media/tuners/r820t.h
> +++ b/drivers/media/tuners/r820t.h
> @@ -21,7 +21,7 @@
>  #ifndef R820T_H
>  #define R820T_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  enum r820t_chip {
>  	CHIP_R820T,
> diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
> index 76807f5b3cf8..de597fa47db6 100644
> --- a/drivers/media/tuners/si2157.h
> +++ b/drivers/media/tuners/si2157.h
> @@ -18,7 +18,7 @@
>  #define SI2157_H
>  
>  #include <media/media-device.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /*
>   * I2C address
> diff --git a/drivers/media/tuners/tda18212.h b/drivers/media/tuners/tda18212.h
> index 6391dafd0c9d..9ed4367c21fc 100644
> --- a/drivers/media/tuners/tda18212.h
> +++ b/drivers/media/tuners/tda18212.h
> @@ -21,7 +21,7 @@
>  #ifndef TDA18212_H
>  #define TDA18212_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct tda18212_config {
>  	u16 if_dvbt_6;
> diff --git a/drivers/media/tuners/tda18218.h b/drivers/media/tuners/tda18218.h
> index 9c0e3fd7ed7f..0427c6f34c40 100644
> --- a/drivers/media/tuners/tda18218.h
> +++ b/drivers/media/tuners/tda18218.h
> @@ -17,7 +17,7 @@
>  #ifndef TDA18218_H
>  #define TDA18218_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct tda18218_config {
>  	u8 i2c_address;
> diff --git a/drivers/media/tuners/tda18250.h b/drivers/media/tuners/tda18250.h
> index fb569060876f..961806a81f9f 100644
> --- a/drivers/media/tuners/tda18250.h
> +++ b/drivers/media/tuners/tda18250.h
> @@ -19,7 +19,7 @@
>  
>  #include <linux/kconfig.h>
>  #include <media/media-device.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #define TDA18250_XTAL_FREQ_16MHZ 0
>  #define TDA18250_XTAL_FREQ_24MHZ 1
> diff --git a/drivers/media/tuners/tda18271.h b/drivers/media/tuners/tda18271.h
> index 0a846333ce57..7e07966c5ace 100644
> --- a/drivers/media/tuners/tda18271.h
> +++ b/drivers/media/tuners/tda18271.h
> @@ -22,7 +22,7 @@
>  #define __TDA18271_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  struct tda18271_std_map_item {
>  	u16 if_freq;
> diff --git a/drivers/media/tuners/tda827x.h b/drivers/media/tuners/tda827x.h
> index abf2e2fe5350..264e80bd7e24 100644
> --- a/drivers/media/tuners/tda827x.h
> +++ b/drivers/media/tuners/tda827x.h
> @@ -25,7 +25,7 @@
>  #define __DVB_TDA827X_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "tda8290.h"
>  
>  struct tda827x_config
> diff --git a/drivers/media/tuners/tda8290.h b/drivers/media/tuners/tda8290.h
> index 901b8cac7105..5db79f16ad7d 100644
> --- a/drivers/media/tuners/tda8290.h
> +++ b/drivers/media/tuners/tda8290.h
> @@ -18,7 +18,7 @@
>  #define __TDA8290_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "tda18271.h"
>  
>  enum tda8290_lna {
> diff --git a/drivers/media/tuners/tda9887.h b/drivers/media/tuners/tda9887.h
> index 95070eca02ca..2a143f8c6477 100644
> --- a/drivers/media/tuners/tda9887.h
> +++ b/drivers/media/tuners/tda9887.h
> @@ -18,7 +18,7 @@
>  #define __TDA9887_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /* ------------------------------------------------------------------------ */
>  #if IS_REACHABLE(CONFIG_MEDIA_TUNER_TDA9887)
> diff --git a/drivers/media/tuners/tea5761.h b/drivers/media/tuners/tea5761.h
> index 2d624d9919e3..4bcf835fc613 100644
> --- a/drivers/media/tuners/tea5761.h
> +++ b/drivers/media/tuners/tea5761.h
> @@ -18,7 +18,7 @@
>  #define __TEA5761_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #if IS_REACHABLE(CONFIG_MEDIA_TUNER_TEA5761)
>  extern int tea5761_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr);
> diff --git a/drivers/media/tuners/tea5767.h b/drivers/media/tuners/tea5767.h
> index 4f6f6c92db78..216a3192a35f 100644
> --- a/drivers/media/tuners/tea5767.h
> +++ b/drivers/media/tuners/tea5767.h
> @@ -18,7 +18,7 @@
>  #define __TEA5767_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  enum tea5767_xtal {
>  	TEA5767_LOW_LO_32768    = 0,
> diff --git a/drivers/media/tuners/tua9001.h b/drivers/media/tuners/tua9001.h
> index 7b0548181cdc..4df2c16592fb 100644
> --- a/drivers/media/tuners/tua9001.h
> +++ b/drivers/media/tuners/tua9001.h
> @@ -17,7 +17,7 @@
>  #ifndef TUA9001_H
>  #define TUA9001_H
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /*
>   * I2C address
> diff --git a/drivers/media/tuners/tuner-simple.h b/drivers/media/tuners/tuner-simple.h
> index 6399b45b0590..fd71b3490dc8 100644
> --- a/drivers/media/tuners/tuner-simple.h
> +++ b/drivers/media/tuners/tuner-simple.h
> @@ -18,7 +18,7 @@
>  #define __TUNER_SIMPLE_H__
>  
>  #include <linux/i2c.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #if IS_REACHABLE(CONFIG_MEDIA_TUNER_SIMPLE)
>  extern struct dvb_frontend *simple_tuner_attach(struct dvb_frontend *fe,
> diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
> index ae739f842c2d..8cda36a0b20b 100644
> --- a/drivers/media/tuners/tuner-xc2028.c
> +++ b/drivers/media/tuners/tuner-xc2028.c
> @@ -20,7 +20,7 @@
>  #include "tuner-xc2028-types.h"
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  /* Max transfer size done by I2C transfer functions */
>  #define MAX_XFER_SIZE  80
> diff --git a/drivers/media/tuners/tuner-xc2028.h b/drivers/media/tuners/tuner-xc2028.h
> index d8378f9960a5..cd96288aff54 100644
> --- a/drivers/media/tuners/tuner-xc2028.h
> +++ b/drivers/media/tuners/tuner-xc2028.h
> @@ -8,7 +8,7 @@
>  #ifndef __TUNER_XC2028_H__
>  #define __TUNER_XC2028_H__
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #define XC2028_DEFAULT_FIRMWARE "xc3028-v27.fw"
>  #define XC3028L_DEFAULT_FIRMWARE "xc3028L-v36.fw"
> diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
> index 2113ce594f75..f0fa8da08afa 100644
> --- a/drivers/media/tuners/xc4000.c
> +++ b/drivers/media/tuners/xc4000.c
> @@ -27,7 +27,7 @@
>  #include <linux/mutex.h>
>  #include <asm/unaligned.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "xc4000.h"
>  #include "tuner-i2c.h"
> diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
> index 98ba177dbc29..f7a8d05d1758 100644
> --- a/drivers/media/tuners/xc5000.c
> +++ b/drivers/media/tuners/xc5000.c
> @@ -25,7 +25,7 @@
>  #include <linux/dvb/frontend.h>
>  #include <linux/i2c.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "xc5000.h"
>  #include "tuner-i2c.h"
> diff --git a/drivers/media/usb/as102/Makefile b/drivers/media/usb/as102/Makefile
> index 56bd2d00b920..b0b319622edb 100644
> --- a/drivers/media/usb/as102/Makefile
> +++ b/drivers/media/usb/as102/Makefile
> @@ -4,5 +4,4 @@ dvb-as102-objs := as102_drv.o as102_fw.o as10x_cmd.o as10x_cmd_stream.o \
>  
>  obj-$(CONFIG_DVB_AS102) += dvb-as102.o
>  
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
> diff --git a/drivers/media/usb/as102/as102_drv.c b/drivers/media/usb/as102/as102_drv.c
> index 9dd7c7cb06b1..48b0c4e4dac1 100644
> --- a/drivers/media/usb/as102/as102_drv.c
> +++ b/drivers/media/usb/as102/as102_drv.c
> @@ -27,7 +27,7 @@
>  #include "as10x_cmd.h"
>  #include "as102_fe.h"
>  #include "as102_fw.h"
> -#include "dvbdev.h"
> +#include <media/dvbdev.h>
>  
>  int dual_tuner;
>  module_param_named(dual_tuner, dual_tuner, int, 0644);
> diff --git a/drivers/media/usb/as102/as102_drv.h b/drivers/media/usb/as102/as102_drv.h
> index 8def19d9ab92..c92a1e4f6a20 100644
> --- a/drivers/media/usb/as102/as102_drv.h
> +++ b/drivers/media/usb/as102/as102_drv.h
> @@ -16,9 +16,9 @@
>  #ifndef _AS102_DRV_H
>  #define _AS102_DRV_H
>  #include <linux/usb.h>
> -#include <dvb_demux.h>
> -#include <dvb_frontend.h>
> -#include <dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dmxdev.h>
>  #include "as10x_handle.h"
>  #include "as10x_cmd.h"
>  #include "as102_usb_drv.h"
> diff --git a/drivers/media/usb/au0828/Makefile b/drivers/media/usb/au0828/Makefile
> index c06ef6601f2d..5691881c56c0 100644
> --- a/drivers/media/usb/au0828/Makefile
> +++ b/drivers/media/usb/au0828/Makefile
> @@ -12,7 +12,6 @@ endif
>  obj-$(CONFIG_VIDEO_AU0828) += au0828.o
>  
>  ccflags-y += -Idrivers/media/tuners
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
>  
>  ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
> index f6f37e8ef51d..9e3c1237a274 100644
> --- a/drivers/media/usb/au0828/au0828.h
> +++ b/drivers/media/usb/au0828/au0828.h
> @@ -33,12 +33,12 @@
>  #include <media/media-device.h>
>  
>  /* DVB */
> -#include "demux.h"
> -#include "dmxdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> -#include "dvbdev.h"
> +#include <media/demux.h>
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
> +#include <media/dvbdev.h>
>  
>  #include "au0828-reg.h"
>  #include "au0828-cards.h"
> diff --git a/drivers/media/usb/b2c2/Makefile b/drivers/media/usb/b2c2/Makefile
> index 2778c19a45eb..f3cef05f37b6 100644
> --- a/drivers/media/usb/b2c2/Makefile
> +++ b/drivers/media/usb/b2c2/Makefile
> @@ -1,5 +1,4 @@
>  b2c2-flexcop-usb-objs := flexcop-usb.o
>  obj-$(CONFIG_DVB_B2C2_FLEXCOP_USB) += b2c2-flexcop-usb.o
>  
> -ccflags-y += -Idrivers/media/dvb-core/
>  ccflags-y += -Idrivers/media/common/b2c2/
> diff --git a/drivers/media/usb/cx231xx/Makefile b/drivers/media/usb/cx231xx/Makefile
> index 19e8c35d6a77..79cf46eb151a 100644
> --- a/drivers/media/usb/cx231xx/Makefile
> +++ b/drivers/media/usb/cx231xx/Makefile
> @@ -11,6 +11,5 @@ obj-$(CONFIG_VIDEO_CX231XX_DVB) += cx231xx-dvb.o
>  
>  ccflags-y += -Idrivers/media/i2c
>  ccflags-y += -Idrivers/media/tuners
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
>  ccflags-y += -Idrivers/media/usb/dvb-usb
> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
> index 99c8b1a47a0c..f9ec7fedcd5b 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> @@ -31,7 +31,7 @@
>  #include <media/v4l2-common.h>
>  
>  #include <media/drv-intf/cx25840.h>
> -#include "dvb-usb-ids.h"
> +#include <media/dvb-usb-ids.h>
>  #include "xc5000.h"
>  #include "tda18271.h"
>  
> diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
> index 936542cb059a..0b6ac509fdb1 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-video.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-video.c
> @@ -39,7 +39,7 @@
>  #include <media/drv-intf/msp3400.h>
>  #include <media/tuner.h>
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  
>  #include "cx231xx-vbi.h"
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/Makefile b/drivers/media/usb/dvb-usb-v2/Makefile
> index bed44601f324..58c0140e19de 100644
> --- a/drivers/media/usb/dvb-usb-v2/Makefile
> +++ b/drivers/media/usb/dvb-usb-v2/Makefile
> @@ -44,7 +44,6 @@ obj-$(CONFIG_DVB_USB_DVBSKY) += dvb-usb-dvbsky.o
>  dvb-usb-zd1301-objs := zd1301.o
>  obj-$(CONFIG_DVB_USB_ZD1301) += zd1301.o
>  
> -ccflags-y += -I$(srctree)/drivers/media/dvb-core
>  ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
>  ccflags-y += -I$(srctree)/drivers/media/tuners
>  ccflags-y += -I$(srctree)/drivers/media/common
> diff --git a/drivers/media/usb/dvb-usb-v2/anysee.h b/drivers/media/usb/dvb-usb-v2/anysee.h
> index 393e2fce2aed..2312c55619ca 100644
> --- a/drivers/media/usb/dvb-usb-v2/anysee.h
> +++ b/drivers/media/usb/dvb-usb-v2/anysee.h
> @@ -32,7 +32,7 @@
>  
>  #define DVB_USB_LOG_PREFIX "anysee"
>  #include "dvb_usb.h"
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  
>  enum cmd {
>  	CMD_I2C_READ            = 0x33,
> diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
> index 1414d59e85ba..746926364535 100644
> --- a/drivers/media/usb/dvb-usb-v2/az6007.c
> +++ b/drivers/media/usb/dvb-usb-v2/az6007.c
> @@ -23,7 +23,7 @@
>  
>  #include "drxk.h"
>  #include "mt2063.h"
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  #include "dvb_usb.h"
>  #include "cypress_firmware.h"
>  
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> index 0005bdb2207d..d2e80537b2f7 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> @@ -27,11 +27,11 @@
>  #include <media/rc-core.h>
>  #include <media/media-device.h>
>  
> -#include "dvb_frontend.h"
> -#include "dvb_demux.h"
> -#include "dvb_net.h"
> -#include "dmxdev.h"
> -#include "dvb-usb-ids.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_net.h>
> +#include <media/dmxdev.h>
> +#include <media/dvb-usb-ids.h>
>  
>  /*
>   * device file: /dev/dvb/adapter[0-1]/frontend[0-2]
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
> index 9cb4972ce7a3..95888b8885c4 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
> @@ -17,7 +17,7 @@
>  #ifndef __MXL111SF_DEMOD_H__
>  #define __MXL111SF_DEMOD_H__
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "mxl111sf.h"
>  
>  struct mxl111sf_demod_config {
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
> index 11ea07a73271..87c1b1642115 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
> @@ -17,7 +17,7 @@
>  #ifndef __MXL111SF_TUNER_H__
>  #define __MXL111SF_TUNER_H__
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "mxl111sf.h"
>  
>  enum mxl_if_freq {
> diff --git a/drivers/media/usb/dvb-usb/Makefile b/drivers/media/usb/dvb-usb/Makefile
> index 16de1e4f36a4..9ad2618408ef 100644
> --- a/drivers/media/usb/dvb-usb/Makefile
> +++ b/drivers/media/usb/dvb-usb/Makefile
> @@ -80,7 +80,6 @@ obj-$(CONFIG_DVB_USB_AZ6027) += dvb-usb-az6027.o
>  dvb-usb-technisat-usb2-objs := technisat-usb2.o
>  obj-$(CONFIG_DVB_USB_TECHNISAT_USB2) += dvb-usb-technisat-usb2.o
>  
> -ccflags-y += -I$(srctree)/drivers/media/dvb-core
>  ccflags-y += -I$(srctree)/drivers/media/dvb-frontends/
>  # due to tuner-xc3028
>  ccflags-y += -I$(srctree)/drivers/media/tuners
> diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
> index 2e711362847e..96bbb53a4a91 100644
> --- a/drivers/media/usb/dvb-usb/az6027.c
> +++ b/drivers/media/usb/dvb-usb/az6027.c
> @@ -17,7 +17,7 @@
>  
>  #include "stb6100.h"
>  #include "stb6100_cfg.h"
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  
>  int dvb_usb_az6027_debug;
>  module_param_named(debug, dvb_usb_az6027_debug, int, 0644);
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
> index e71fc86b4fb2..317ed6a82d19 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb.h
> +++ b/drivers/media/usb/dvb-usb/dvb-usb.h
> @@ -17,14 +17,14 @@
>  #include <linux/mutex.h>
>  #include <media/rc-core.h>
>  
> -#include "dvb_frontend.h"
> -#include "dvb_demux.h"
> -#include "dvb_net.h"
> -#include "dmxdev.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_net.h>
> +#include <media/dmxdev.h>
>  
>  #include "dvb-pll.h"
>  
> -#include "dvb-usb-ids.h"
> +#include <media/dvb-usb-ids.h>
>  
>  /* debug */
>  #ifdef CONFIG_DVB_USB_DEBUG
> diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
> index b421329b21fa..346946f35b1a 100644
> --- a/drivers/media/usb/dvb-usb/dw2102.c
> +++ b/drivers/media/usb/dvb-usb/dw2102.c
> @@ -13,7 +13,7 @@
>   *
>   * see Documentation/dvb/README.dvb-usb for more information
>   */
> -#include "dvb-usb-ids.h"
> +#include <media/dvb-usb-ids.h>
>  #include "dw2102.h"
>  #include "si21xx.h"
>  #include "stv0299.h"
> diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
> index 3b7f8298b24d..0af74383083d 100644
> --- a/drivers/media/usb/dvb-usb/pctv452e.c
> +++ b/drivers/media/usb/dvb-usb/pctv452e.c
> @@ -26,7 +26,7 @@
>  /* FE Power */
>  #include "lnbp22.h"
>  
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  #include "ttpci-eeprom.h"
>  
>  static int debug;
> diff --git a/drivers/media/usb/dvb-usb/ttusb2.c b/drivers/media/usb/dvb-usb/ttusb2.c
> index e7020f245f53..12de89665d60 100644
> --- a/drivers/media/usb/dvb-usb/ttusb2.c
> +++ b/drivers/media/usb/dvb-usb/ttusb2.c
> @@ -34,7 +34,7 @@
>  #include "tda827x.h"
>  #include "lnbp21.h"
>  /* CA */
> -#include "dvb_ca_en50221.h"
> +#include <media/dvb_ca_en50221.h>
>  
>  /* debug */
>  static int dvb_usb_ttusb2_debug;
> diff --git a/drivers/media/usb/em28xx/Makefile b/drivers/media/usb/em28xx/Makefile
> index 86bfc35e2ed4..c3d3570584e1 100644
> --- a/drivers/media/usb/em28xx/Makefile
> +++ b/drivers/media/usb/em28xx/Makefile
> @@ -13,5 +13,4 @@ obj-$(CONFIG_VIDEO_EM28XX_RC) += em28xx-rc.o
>  
>  ccflags-y += -Idrivers/media/i2c
>  ccflags-y += -Idrivers/media/tuners
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index c4abf516c4ff..8a81c94a8a27 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -28,9 +28,9 @@
>  #include <linux/usb.h>
>  
>  #include <media/v4l2-common.h>
> -#include <dvb_demux.h>
> -#include <dvb_net.h>
> -#include <dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_net.h>
> +#include <media/dmxdev.h>
>  #include <media/tuner.h>
>  #include "tuner-simple.h"
>  #include <linux/gpio.h>
> diff --git a/drivers/media/usb/pvrusb2/Makefile b/drivers/media/usb/pvrusb2/Makefile
> index 0d84064036b2..552e4f12c496 100644
> --- a/drivers/media/usb/pvrusb2/Makefile
> +++ b/drivers/media/usb/pvrusb2/Makefile
> @@ -19,5 +19,4 @@ obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2.o
>  
>  ccflags-y += -Idrivers/media/i2c
>  ccflags-y += -Idrivers/media/tuners
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-dvb.c b/drivers/media/usb/pvrusb2/pvrusb2-dvb.c
> index 56c750535ee7..4b32b2141169 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-dvb.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-dvb.c
> @@ -18,7 +18,7 @@
>  #include <linux/freezer.h>
>  #include <linux/slab.h>
>  #include <linux/mm.h>
> -#include "dvbdev.h"
> +#include <media/dvbdev.h>
>  #include "pvrusb2-debug.h"
>  #include "pvrusb2-hdw-internal.h"
>  #include "pvrusb2-hdw.h"
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-dvb.h b/drivers/media/usb/pvrusb2/pvrusb2-dvb.h
> index b500c86d4178..e7f71fb94a6e 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-dvb.h
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-dvb.h
> @@ -2,10 +2,10 @@
>  #ifndef __PVRUSB2_DVB_H__
>  #define __PVRUSB2_DVB_H__
>  
> -#include "dvb_frontend.h"
> -#include "dvb_demux.h"
> -#include "dvb_net.h"
> -#include "dmxdev.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_net.h>
> +#include <media/dmxdev.h>
>  #include "pvrusb2-context.h"
>  
>  #define PVR2_DVB_BUFFER_COUNT 32
> diff --git a/drivers/media/usb/siano/Makefile b/drivers/media/usb/siano/Makefile
> index 758b6a090c59..7d48864e2782 100644
> --- a/drivers/media/usb/siano/Makefile
> +++ b/drivers/media/usb/siano/Makefile
> @@ -1,6 +1,5 @@
>  obj-$(CONFIG_SMS_USB_DRV) += smsusb.o
>  
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/common/siano
>  ccflags-y += $(extra-cflags-y) $(extra-cflags-m)
>  
> diff --git a/drivers/media/usb/tm6000/Makefile b/drivers/media/usb/tm6000/Makefile
> index 05322a72e862..62f8528daef2 100644
> --- a/drivers/media/usb/tm6000/Makefile
> +++ b/drivers/media/usb/tm6000/Makefile
> @@ -12,5 +12,4 @@ obj-$(CONFIG_VIDEO_TM6000_DVB) += tm6000-dvb.o
>  
>  ccflags-y += -Idrivers/media/i2c
>  ccflags-y += -Idrivers/media/tuners
> -ccflags-y += -Idrivers/media/dvb-core
>  ccflags-y += -Idrivers/media/dvb-frontends
> diff --git a/drivers/media/usb/tm6000/tm6000.h b/drivers/media/usb/tm6000/tm6000.h
> index 16d3c81e4eb9..23a0ceb4bfea 100644
> --- a/drivers/media/usb/tm6000/tm6000.h
> +++ b/drivers/media/usb/tm6000/tm6000.h
> @@ -19,9 +19,9 @@
>  #include <media/v4l2-fh.h>
>  
>  #include <linux/dvb/frontend.h>
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dmxdev.h"
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dmxdev.h>
>  
>  /* Inputs */
>  enum tm6000_itype {
> diff --git a/drivers/media/usb/ttusb-budget/Makefile b/drivers/media/usb/ttusb-budget/Makefile
> index f47bbf62dcde..fe4372dddd0e 100644
> --- a/drivers/media/usb/ttusb-budget/Makefile
> +++ b/drivers/media/usb/ttusb-budget/Makefile
> @@ -1,3 +1,3 @@
>  obj-$(CONFIG_DVB_TTUSB_BUDGET) += dvb-ttusb-budget.o
>  
> -ccflags-y += -Idrivers/media/dvb-core/ -Idrivers/media/dvb-frontends
> +ccflags-y += -Idrivers/media/dvb-frontends
> diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
> index a142b9dc0feb..6cef56d0ecc9 100644
> --- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
> +++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
> @@ -22,10 +22,10 @@
>  #include <linux/mutex.h>
>  #include <linux/firmware.h>
>  
> -#include "dvb_frontend.h"
> -#include "dmxdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_net.h"
> +#include <media/dvb_frontend.h>
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_net.h>
>  #include "ves1820.h"
>  #include "cx22700.h"
>  #include "tda1004x.h"
> diff --git a/drivers/media/usb/ttusb-dec/Makefile b/drivers/media/usb/ttusb-dec/Makefile
> index 5352740d2353..dde9168b5e5f 100644
> --- a/drivers/media/usb/ttusb-dec/Makefile
> +++ b/drivers/media/usb/ttusb-dec/Makefile
> @@ -1,3 +1 @@
>  obj-$(CONFIG_DVB_TTUSB_DEC) += ttusb_dec.o ttusbdecfe.o
> -
> -ccflags-y += -Idrivers/media/dvb-core/
> diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
> index cdefb5dfbbdc..3d176883168d 100644
> --- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
> +++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
> @@ -30,10 +30,10 @@
>  
>  #include <linux/mutex.h>
>  
> -#include "dmxdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dvb_net.h"
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_frontend.h>
> +#include <media/dvb_net.h>
>  #include "ttusbdecfe.h"
>  
>  static int debug;
> diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.c b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
> index 09693caa15e2..6ea05d909024 100644
> --- a/drivers/media/usb/ttusb-dec/ttusbdecfe.c
> +++ b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
> @@ -15,7 +15,7 @@
>   *
>   */
>  
> -#include "dvb_frontend.h"
> +#include <media/dvb_frontend.h>
>  #include "ttusbdecfe.h"
>  
>  
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index 1618ce984674..80de2cb9c476 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -33,7 +33,6 @@ obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
>  obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
>  obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
>  
> -ccflags-y += -I$(srctree)/drivers/media/dvb-core
>  ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
>  ccflags-y += -I$(srctree)/drivers/media/tuners
>  
> diff --git a/drivers/staging/media/cxd2099/Makefile b/drivers/staging/media/cxd2099/Makefile
> index b2905e65057c..30432c9aabc4 100644
> --- a/drivers/staging/media/cxd2099/Makefile
> +++ b/drivers/staging/media/cxd2099/Makefile
> @@ -1,5 +1,4 @@
>  obj-$(CONFIG_DVB_CXD2099) += cxd2099.o
>  
> -ccflags-y += -Idrivers/media/dvb-core/
>  ccflags-y += -Idrivers/media/dvb-frontends/
>  ccflags-y += -Idrivers/media/tuners/
> diff --git a/drivers/staging/media/cxd2099/cxd2099.h b/drivers/staging/media/cxd2099/cxd2099.h
> index aba803268e94..253e3155a6df 100644
> --- a/drivers/staging/media/cxd2099/cxd2099.h
> +++ b/drivers/staging/media/cxd2099/cxd2099.h
> @@ -16,7 +16,7 @@
>  #ifndef _CXD2099_H_
>  #define _CXD2099_H_
>  
> -#include <dvb_ca_en50221.h>
> +#include <media/dvb_ca_en50221.h>
>  
>  struct cxd2099_cfg {
>  	u32 bitrate;
> diff --git a/drivers/media/dvb-core/demux.h b/include/media/demux.h
> similarity index 100%
> rename from drivers/media/dvb-core/demux.h
> rename to include/media/demux.h
> diff --git a/drivers/media/dvb-core/dmxdev.h b/include/media/dmxdev.h
> similarity index 98%
> rename from drivers/media/dvb-core/dmxdev.h
> rename to include/media/dmxdev.h
> index a77064d6e2c4..d5bef0da2e6e 100644
> --- a/drivers/media/dvb-core/dmxdev.h
> +++ b/include/media/dmxdev.h
> @@ -32,10 +32,10 @@
>  
>  #include <linux/dvb/dmx.h>
>  
> -#include "dvbdev.h"
> -#include "demux.h"
> -#include "dvb_ringbuffer.h"
> -#include "dvb_vb2.h"
> +#include <media/dvbdev.h>
> +#include <media/demux.h>
> +#include <media/dvb_ringbuffer.h>
> +#include <media/dvb_vb2.h>
>  
>  /**
>   * enum dmxdev_type - type of demux filter type.
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/include/media/dvb-usb-ids.h
> similarity index 100%
> rename from drivers/media/dvb-core/dvb-usb-ids.h
> rename to include/media/dvb-usb-ids.h
> diff --git a/drivers/media/dvb-core/dvb_ca_en50221.h b/include/media/dvb_ca_en50221.h
> similarity index 99%
> rename from drivers/media/dvb-core/dvb_ca_en50221.h
> rename to include/media/dvb_ca_en50221.h
> index 367687d2b41a..a1c014b0a837 100644
> --- a/drivers/media/dvb-core/dvb_ca_en50221.h
> +++ b/include/media/dvb_ca_en50221.h
> @@ -20,7 +20,7 @@
>  #include <linux/list.h>
>  #include <linux/dvb/ca.h>
>  
> -#include "dvbdev.h"
> +#include <media/dvbdev.h>
>  
>  #define DVB_CA_EN50221_POLL_CAM_PRESENT	1
>  #define DVB_CA_EN50221_POLL_CAM_CHANGED	2
> diff --git a/drivers/media/dvb-core/dvb_demux.h b/include/media/dvb_demux.h
> similarity index 99%
> rename from drivers/media/dvb-core/dvb_demux.h
> rename to include/media/dvb_demux.h
> index c3bcdeed06c4..b07092038f4b 100644
> --- a/drivers/media/dvb-core/dvb_demux.h
> +++ b/include/media/dvb_demux.h
> @@ -24,7 +24,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/mutex.h>
>  
> -#include "demux.h"
> +#include <media/demux.h>
>  
>  /**
>   * enum dvb_dmx_filter_type - type of demux feed.
> diff --git a/drivers/media/dvb-core/dvb_frontend.h b/include/media/dvb_frontend.h
> similarity index 99%
> rename from drivers/media/dvb-core/dvb_frontend.h
> rename to include/media/dvb_frontend.h
> index 2bc25f1e425b..0b40886fd7d3 100644
> --- a/drivers/media/dvb-core/dvb_frontend.h
> +++ b/include/media/dvb_frontend.h
> @@ -44,7 +44,7 @@
>  
>  #include <linux/dvb/frontend.h>
>  
> -#include "dvbdev.h"
> +#include <media/dvbdev.h>
>  
>  /*
>   * Maximum number of Delivery systems per frontend. It
> diff --git a/drivers/media/dvb-core/dvb_math.h b/include/media/dvb_math.h
> similarity index 100%
> rename from drivers/media/dvb-core/dvb_math.h
> rename to include/media/dvb_math.h
> diff --git a/drivers/media/dvb-core/dvb_net.h b/include/media/dvb_net.h
> similarity index 98%
> rename from drivers/media/dvb-core/dvb_net.h
> rename to include/media/dvb_net.h
> index 1eae8bad7cc1..5e31d37f25fa 100644
> --- a/drivers/media/dvb-core/dvb_net.h
> +++ b/include/media/dvb_net.h
> @@ -24,7 +24,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/skbuff.h>
>  
> -#include "dvbdev.h"
> +#include <media/dvbdev.h>
>  
>  #define DVB_NET_DEVICES_MAX 10
>  
> diff --git a/drivers/media/dvb-core/dvb_ringbuffer.h b/include/media/dvb_ringbuffer.h
> similarity index 100%
> rename from drivers/media/dvb-core/dvb_ringbuffer.h
> rename to include/media/dvb_ringbuffer.h
> diff --git a/drivers/media/dvb-core/dvb_vb2.h b/include/media/dvb_vb2.h
> similarity index 100%
> rename from drivers/media/dvb-core/dvb_vb2.h
> rename to include/media/dvb_vb2.h
> diff --git a/drivers/media/dvb-core/dvbdev.h b/include/media/dvbdev.h
> similarity index 100%
> rename from drivers/media/dvb-core/dvbdev.h
> rename to include/media/dvbdev.h
> diff --git a/include/media/videobuf-dvb.h b/include/media/videobuf-dvb.h
> index a14ac7711c92..c9c81990a56c 100644
> --- a/include/media/videobuf-dvb.h
> +++ b/include/media/videobuf-dvb.h
> @@ -1,9 +1,9 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> -#include <dvbdev.h>
> -#include <dmxdev.h>
> -#include <dvb_demux.h>
> -#include <dvb_net.h>
> -#include <dvb_frontend.h>
> +#include <media/dvbdev.h>
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_net.h>
> +#include <media/dvb_frontend.h>
>  
>  #ifndef _VIDEOBUF_DVB_H_
>  #define	_VIDEOBUF_DVB_H_
> diff --git a/include/media/videobuf2-dvb.h b/include/media/videobuf2-dvb.h
> index 5a31faa24f1a..8605366ec87c 100644
> --- a/include/media/videobuf2-dvb.h
> +++ b/include/media/videobuf2-dvb.h
> @@ -2,12 +2,11 @@
>  #ifndef _VIDEOBUF2_DVB_H_
>  #define	_VIDEOBUF2_DVB_H_
>  
> -#include <dvbdev.h>
> -#include <dmxdev.h>
> -#include <dvb_demux.h>
> -#include <dvb_net.h>
> -#include <dvb_frontend.h>
> -
> +#include <media/dvbdev.h>
> +#include <media/dmxdev.h>
> +#include <media/dvb_demux.h>
> +#include <media/dvb_net.h>
> +#include <media/dvb_frontend.h>
>  #include <media/videobuf2-v4l2.h>
>  
>  /* We don't actually need to include media-device.h here */
> -- 
> 2.14.3
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com

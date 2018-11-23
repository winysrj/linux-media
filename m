Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58608 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437212AbeKXFYQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 00:24:16 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Walls <awalls@md.metrocast.net>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Mike Isely <isely@pobox.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Antoine Jacquet <royale@zerezo.com>, linux-usb@vger.kernel.org
Subject: [PATCH 5/6] media: docs: brainless mass add SPDX headers to all media files
Date: Fri, 23 Nov 2018 16:38:38 -0200
Message-Id: <20a8a06335b2fe383270c7250b82105768ea3390.1542997584.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1542997584.git.mchehab+samsung@kernel.org>
References: <cover.1542997584.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All Documentation files outside the uAPI are all licensed with,
at least, GPL 2.0. So, mark them as such.

The ondes at media/uapi are at least GFDL 1.1+.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/.gitignore                            | 2 ++
 Documentation/media/Makefile                              | 2 ++
 Documentation/media/audio.h.rst.exceptions                | 2 ++
 Documentation/media/ca.h.rst.exceptions                   | 2 ++
 Documentation/media/cec-drivers/index.rst                 | 2 ++
 Documentation/media/cec-drivers/pulse8-cec.rst            | 2 ++
 Documentation/media/cec.h.rst.exceptions                  | 2 ++
 Documentation/media/conf.py                               | 2 ++
 Documentation/media/conf_nitpick.py                       | 2 ++
 Documentation/media/dmx.h.rst.exceptions                  | 2 ++
 Documentation/media/dvb-drivers/avermedia.rst             | 2 ++
 Documentation/media/dvb-drivers/bt8xx.rst                 | 2 ++
 Documentation/media/dvb-drivers/cards.rst                 | 2 ++
 Documentation/media/dvb-drivers/ci.rst                    | 2 ++
 Documentation/media/dvb-drivers/contributors.rst          | 2 ++
 Documentation/media/dvb-drivers/dvb-usb.rst               | 2 ++
 Documentation/media/dvb-drivers/faq.rst                   | 2 ++
 Documentation/media/dvb-drivers/frontends.rst             | 2 ++
 Documentation/media/dvb-drivers/index.rst                 | 2 ++
 Documentation/media/dvb-drivers/intro.rst                 | 2 ++
 Documentation/media/dvb-drivers/lmedm04.rst               | 2 ++
 Documentation/media/dvb-drivers/opera-firmware.rst        | 2 ++
 Documentation/media/dvb-drivers/technisat.rst             | 2 ++
 Documentation/media/dvb-drivers/ttusb-dec.rst             | 2 ++
 Documentation/media/dvb-drivers/udev.rst                  | 2 ++
 Documentation/media/frontend.h.rst.exceptions             | 2 ++
 Documentation/media/index.rst                             | 2 ++
 Documentation/media/intro.rst                             | 2 ++
 Documentation/media/kapi/cec-core.rst                     | 2 ++
 Documentation/media/kapi/csi2.rst                         | 2 ++
 Documentation/media/kapi/dtv-ca.rst                       | 2 ++
 Documentation/media/kapi/dtv-common.rst                   | 2 ++
 Documentation/media/kapi/dtv-core.rst                     | 2 ++
 Documentation/media/kapi/dtv-demux.rst                    | 2 ++
 Documentation/media/kapi/dtv-frontend.rst                 | 2 ++
 Documentation/media/kapi/dtv-net.rst                      | 2 ++
 Documentation/media/kapi/mc-core.rst                      | 2 ++
 Documentation/media/kapi/rc-core.rst                      | 2 ++
 Documentation/media/kapi/v4l2-async.rst                   | 2 ++
 Documentation/media/kapi/v4l2-clocks.rst                  | 2 ++
 Documentation/media/kapi/v4l2-common.rst                  | 2 ++
 Documentation/media/kapi/v4l2-controls.rst                | 2 ++
 Documentation/media/kapi/v4l2-core.rst                    | 2 ++
 Documentation/media/kapi/v4l2-dev.rst                     | 2 ++
 Documentation/media/kapi/v4l2-device.rst                  | 2 ++
 Documentation/media/kapi/v4l2-dv-timings.rst              | 2 ++
 Documentation/media/kapi/v4l2-event.rst                   | 2 ++
 Documentation/media/kapi/v4l2-fh.rst                      | 2 ++
 Documentation/media/kapi/v4l2-flash-led-class.rst         | 2 ++
 Documentation/media/kapi/v4l2-fwnode.rst                  | 2 ++
 Documentation/media/kapi/v4l2-intro.rst                   | 2 ++
 Documentation/media/kapi/v4l2-mc.rst                      | 2 ++
 Documentation/media/kapi/v4l2-mediabus.rst                | 2 ++
 Documentation/media/kapi/v4l2-mem2mem.rst                 | 2 ++
 Documentation/media/kapi/v4l2-rect.rst                    | 2 ++
 Documentation/media/kapi/v4l2-subdev.rst                  | 2 ++
 Documentation/media/kapi/v4l2-tuner.rst                   | 2 ++
 Documentation/media/kapi/v4l2-tveeprom.rst                | 2 ++
 Documentation/media/kapi/v4l2-videobuf.rst                | 2 ++
 Documentation/media/kapi/v4l2-videobuf2.rst               | 2 ++
 Documentation/media/lirc.h.rst.exceptions                 | 2 ++
 Documentation/media/media.h.rst.exceptions                | 2 ++
 Documentation/media/media_kapi.rst                        | 2 ++
 Documentation/media/media_uapi.rst                        | 2 ++
 Documentation/media/net.h.rst.exceptions                  | 2 ++
 Documentation/media/uapi/v4l/pipeline.dot                 | 2 ++
 Documentation/media/v4l-drivers/au0828-cardlist.rst       | 2 ++
 Documentation/media/v4l-drivers/bttv-cardlist.rst         | 2 ++
 Documentation/media/v4l-drivers/bttv.rst                  | 2 ++
 Documentation/media/v4l-drivers/cafe_ccic.rst             | 2 ++
 Documentation/media/v4l-drivers/cardlist.rst              | 2 ++
 Documentation/media/v4l-drivers/cpia2.rst                 | 2 ++
 Documentation/media/v4l-drivers/cx18.rst                  | 2 ++
 Documentation/media/v4l-drivers/cx2341x.rst               | 2 ++
 Documentation/media/v4l-drivers/cx23885-cardlist.rst      | 2 ++
 Documentation/media/v4l-drivers/cx88-cardlist.rst         | 2 ++
 Documentation/media/v4l-drivers/cx88.rst                  | 2 ++
 Documentation/media/v4l-drivers/davinci-vpbe.rst          | 2 ++
 Documentation/media/v4l-drivers/em28xx-cardlist.rst       | 2 ++
 Documentation/media/v4l-drivers/fimc.rst                  | 2 ++
 Documentation/media/v4l-drivers/fourcc.rst                | 2 ++
 Documentation/media/v4l-drivers/gspca-cardlist.rst        | 2 ++
 Documentation/media/v4l-drivers/imx.rst                   | 2 ++
 Documentation/media/v4l-drivers/index.rst                 | 2 ++
 Documentation/media/v4l-drivers/ivtv-cardlist.rst         | 2 ++
 Documentation/media/v4l-drivers/ivtv.rst                  | 2 ++
 Documentation/media/v4l-drivers/max2175.rst               | 2 ++
 Documentation/media/v4l-drivers/meye.rst                  | 2 ++
 Documentation/media/v4l-drivers/omap3isp.rst              | 2 ++
 Documentation/media/v4l-drivers/omap4_camera.rst          | 2 ++
 Documentation/media/v4l-drivers/philips.rst               | 2 ++
 Documentation/media/v4l-drivers/pvrusb2.rst               | 2 ++
 Documentation/media/v4l-drivers/pxa_camera.rst            | 2 ++
 Documentation/media/v4l-drivers/qcom_camss.rst            | 2 ++
 Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot | 2 ++
 Documentation/media/v4l-drivers/qcom_camss_graph.dot      | 2 ++
 Documentation/media/v4l-drivers/radiotrack.rst            | 2 ++
 Documentation/media/v4l-drivers/rcar-fdp1.rst             | 2 ++
 Documentation/media/v4l-drivers/saa7134-cardlist.rst      | 2 ++
 Documentation/media/v4l-drivers/saa7134.rst               | 2 ++
 Documentation/media/v4l-drivers/saa7164-cardlist.rst      | 2 ++
 Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst  | 2 ++
 Documentation/media/v4l-drivers/si470x.rst                | 2 ++
 Documentation/media/v4l-drivers/si4713.rst                | 2 ++
 Documentation/media/v4l-drivers/si476x.rst                | 2 ++
 Documentation/media/v4l-drivers/soc-camera.rst            | 2 ++
 Documentation/media/v4l-drivers/tm6000-cardlist.rst       | 2 ++
 Documentation/media/v4l-drivers/tuner-cardlist.rst        | 2 ++
 Documentation/media/v4l-drivers/tuners.rst                | 2 ++
 Documentation/media/v4l-drivers/usbvision-cardlist.rst    | 2 ++
 Documentation/media/v4l-drivers/uvcvideo.rst              | 2 ++
 Documentation/media/v4l-drivers/v4l-with-ir.rst           | 2 ++
 Documentation/media/v4l-drivers/vivid.rst                 | 2 ++
 Documentation/media/v4l-drivers/zoran.rst                 | 2 ++
 Documentation/media/v4l-drivers/zr364xx.rst               | 2 ++
 Documentation/media/video.h.rst.exceptions                | 2 ++
 Documentation/media/videodev2.h.rst.exceptions            | 2 ++
 117 files changed, 234 insertions(+)

diff --git a/Documentation/media/.gitignore b/Documentation/media/.gitignore
index 08b21de3ef94..53adc029061f 100644
--- a/Documentation/media/.gitignore
+++ b/Documentation/media/.gitignore
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 *.pdf
 # Files generated from *.dot
 uapi/v4l/pipeline.svg
diff --git a/Documentation/media/Makefile b/Documentation/media/Makefile
index 36166952d555..d75d70f191bc 100644
--- a/Documentation/media/Makefile
+++ b/Documentation/media/Makefile
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 # Rules to convert a .h file to inline RST documentation
 
 SRC_DIR=$(srctree)/Documentation/media
diff --git a/Documentation/media/audio.h.rst.exceptions b/Documentation/media/audio.h.rst.exceptions
index 940458774cf6..cf6620477f73 100644
--- a/Documentation/media/audio.h.rst.exceptions
+++ b/Documentation/media/audio.h.rst.exceptions
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 # Ignore header name
 ignore define _DVBAUDIO_H_
 
diff --git a/Documentation/media/ca.h.rst.exceptions b/Documentation/media/ca.h.rst.exceptions
index 553559cc6ad7..f6828238eb48 100644
--- a/Documentation/media/ca.h.rst.exceptions
+++ b/Documentation/media/ca.h.rst.exceptions
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 # Ignore header name
 ignore define _DVBCA_H_
 
diff --git a/Documentation/media/cec-drivers/index.rst b/Documentation/media/cec-drivers/index.rst
index 463e5210b686..2b7fcaa4311b 100644
--- a/Documentation/media/cec-drivers/index.rst
+++ b/Documentation/media/cec-drivers/index.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 .. _cec-drivers:
diff --git a/Documentation/media/cec-drivers/pulse8-cec.rst b/Documentation/media/cec-drivers/pulse8-cec.rst
index 99551c6a9bc5..356d08b519f3 100644
--- a/Documentation/media/cec-drivers/pulse8-cec.rst
+++ b/Documentation/media/cec-drivers/pulse8-cec.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Pulse-Eight CEC Adapter driver
 ==============================
 
diff --git a/Documentation/media/cec.h.rst.exceptions b/Documentation/media/cec.h.rst.exceptions
index d9fd092de6f8..014816d04b9e 100644
--- a/Documentation/media/cec.h.rst.exceptions
+++ b/Documentation/media/cec.h.rst.exceptions
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 # Ignore header name
 ignore define _CEC_UAPI_H
 
diff --git a/Documentation/media/conf.py b/Documentation/media/conf.py
index bef927bc4659..1f194fcd2cae 100644
--- a/Documentation/media/conf.py
+++ b/Documentation/media/conf.py
@@ -1,5 +1,7 @@
 # -*- coding: utf-8; mode: python -*-
 
+# SPDX-License-Identifier: GPL-2.0
+
 project = 'Linux Media Subsystem Documentation'
 
 tags.add("subproject")
diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
index 480d548af670..d0c50d75f518 100644
--- a/Documentation/media/conf_nitpick.py
+++ b/Documentation/media/conf_nitpick.py
@@ -1,5 +1,7 @@
 # -*- coding: utf-8; mode: python -*-
 
+# SPDX-License-Identifier: GPL-2.0
+
 project = 'Linux Media Subsystem Documentation'
 
 # It is possible to run Sphinx in nickpick mode with:
diff --git a/Documentation/media/dmx.h.rst.exceptions b/Documentation/media/dmx.h.rst.exceptions
index a8c4239ed95b..afc14d384b83 100644
--- a/Documentation/media/dmx.h.rst.exceptions
+++ b/Documentation/media/dmx.h.rst.exceptions
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 # Ignore header name
 ignore define _UAPI_DVBDMX_H_
 
diff --git a/Documentation/media/dvb-drivers/avermedia.rst b/Documentation/media/dvb-drivers/avermedia.rst
index 49cd9c935307..14f437ca38d3 100644
--- a/Documentation/media/dvb-drivers/avermedia.rst
+++ b/Documentation/media/dvb-drivers/avermedia.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 HOWTO: Get An Avermedia DVB-T working under Linux
 -------------------------------------------------
 
diff --git a/Documentation/media/dvb-drivers/bt8xx.rst b/Documentation/media/dvb-drivers/bt8xx.rst
index e3e387bdf498..7936cd96fc8f 100644
--- a/Documentation/media/dvb-drivers/bt8xx.rst
+++ b/Documentation/media/dvb-drivers/bt8xx.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 How to get the bt8xx cards working
 ==================================
 
diff --git a/Documentation/media/dvb-drivers/cards.rst b/Documentation/media/dvb-drivers/cards.rst
index 177cbeb2b561..e2e30a56b450 100644
--- a/Documentation/media/dvb-drivers/cards.rst
+++ b/Documentation/media/dvb-drivers/cards.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Hardware supported by the linuxtv.org DVB drivers
 =================================================
 
diff --git a/Documentation/media/dvb-drivers/ci.rst b/Documentation/media/dvb-drivers/ci.rst
index 87f3748c49b9..35f33f1f9e2a 100644
--- a/Documentation/media/dvb-drivers/ci.rst
+++ b/Documentation/media/dvb-drivers/ci.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Digital TV Conditional Access Interface (CI API)
 ================================================
 
diff --git a/Documentation/media/dvb-drivers/contributors.rst b/Documentation/media/dvb-drivers/contributors.rst
index 5949753008ae..f23b6e6faf46 100644
--- a/Documentation/media/dvb-drivers/contributors.rst
+++ b/Documentation/media/dvb-drivers/contributors.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Contributors
 ============
 
diff --git a/Documentation/media/dvb-drivers/dvb-usb.rst b/Documentation/media/dvb-drivers/dvb-usb.rst
index eec99cd07a30..6679191819aa 100644
--- a/Documentation/media/dvb-drivers/dvb-usb.rst
+++ b/Documentation/media/dvb-drivers/dvb-usb.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Idea behind the dvb-usb-framework
 =================================
 
diff --git a/Documentation/media/dvb-drivers/faq.rst b/Documentation/media/dvb-drivers/faq.rst
index a8593d3792fa..52f153d18278 100644
--- a/Documentation/media/dvb-drivers/faq.rst
+++ b/Documentation/media/dvb-drivers/faq.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 FAQ
 ===
 
diff --git a/Documentation/media/dvb-drivers/frontends.rst b/Documentation/media/dvb-drivers/frontends.rst
index 1f5f57989196..7b8336ece681 100644
--- a/Documentation/media/dvb-drivers/frontends.rst
+++ b/Documentation/media/dvb-drivers/frontends.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 ****************
 Frontend drivers
 ****************
diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index 7c2795bf1587..9d3fce544f85 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 ##############################################
diff --git a/Documentation/media/dvb-drivers/intro.rst b/Documentation/media/dvb-drivers/intro.rst
index d6eeb2708b9b..4e361bcc3ad4 100644
--- a/Documentation/media/dvb-drivers/intro.rst
+++ b/Documentation/media/dvb-drivers/intro.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Introduction
 ============
 
diff --git a/Documentation/media/dvb-drivers/lmedm04.rst b/Documentation/media/dvb-drivers/lmedm04.rst
index e8913d4481a0..a6ee33413748 100644
--- a/Documentation/media/dvb-drivers/lmedm04.rst
+++ b/Documentation/media/dvb-drivers/lmedm04.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Firmware files for lmedm04 cards
 ================================
 
diff --git a/Documentation/media/dvb-drivers/opera-firmware.rst b/Documentation/media/dvb-drivers/opera-firmware.rst
index 41236b43c124..fab3581551de 100644
--- a/Documentation/media/dvb-drivers/opera-firmware.rst
+++ b/Documentation/media/dvb-drivers/opera-firmware.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Opera firmware
 ==============
 
diff --git a/Documentation/media/dvb-drivers/technisat.rst b/Documentation/media/dvb-drivers/technisat.rst
index f80f4ecc1560..9eaa12366bbf 100644
--- a/Documentation/media/dvb-drivers/technisat.rst
+++ b/Documentation/media/dvb-drivers/technisat.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 How to set up the Technisat/B2C2 Flexcop devices
 ================================================
 
diff --git a/Documentation/media/dvb-drivers/ttusb-dec.rst b/Documentation/media/dvb-drivers/ttusb-dec.rst
index 84fc2199dc29..516bbab8a872 100644
--- a/Documentation/media/dvb-drivers/ttusb-dec.rst
+++ b/Documentation/media/dvb-drivers/ttusb-dec.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 TechnoTrend/Hauppauge DEC USB Driver
 ====================================
 
diff --git a/Documentation/media/dvb-drivers/udev.rst b/Documentation/media/dvb-drivers/udev.rst
index 7d7d5d82108a..ca6c9c226902 100644
--- a/Documentation/media/dvb-drivers/udev.rst
+++ b/Documentation/media/dvb-drivers/udev.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 UDEV rules for DVB
 ==================
 
diff --git a/Documentation/media/frontend.h.rst.exceptions b/Documentation/media/frontend.h.rst.exceptions
index f7c4df620a52..6283702c08c8 100644
--- a/Documentation/media/frontend.h.rst.exceptions
+++ b/Documentation/media/frontend.h.rst.exceptions
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 # Ignore header name
 ignore define _DVBFRONTEND_H_
 
diff --git a/Documentation/media/index.rst b/Documentation/media/index.rst
index 1cf5316c8ff8..0a222fc1d7ca 100644
--- a/Documentation/media/index.rst
+++ b/Documentation/media/index.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Linux Media Subsystem Documentation
 ===================================
 
diff --git a/Documentation/media/intro.rst b/Documentation/media/intro.rst
index f8960214741f..4a6bd665b884 100644
--- a/Documentation/media/intro.rst
+++ b/Documentation/media/intro.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 ============
 Introduction
 ============
diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index bca1d9d1d223..3ce26b7c2b2b 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 CEC Kernel Support
 ==================
 
diff --git a/Documentation/media/kapi/csi2.rst b/Documentation/media/kapi/csi2.rst
index 0560100efca2..a7e75e2eba85 100644
--- a/Documentation/media/kapi/csi2.rst
+++ b/Documentation/media/kapi/csi2.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 MIPI CSI-2
 ==========
 
diff --git a/Documentation/media/kapi/dtv-ca.rst b/Documentation/media/kapi/dtv-ca.rst
index fded096b937c..8a09862b428b 100644
--- a/Documentation/media/kapi/dtv-ca.rst
+++ b/Documentation/media/kapi/dtv-ca.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Digital TV Conditional Access kABI
 ----------------------------------
 
diff --git a/Documentation/media/kapi/dtv-common.rst b/Documentation/media/kapi/dtv-common.rst
index 7a9574f03190..f8b2c4dc8170 100644
--- a/Documentation/media/kapi/dtv-common.rst
+++ b/Documentation/media/kapi/dtv-common.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Digital TV Common functions
 ---------------------------
 
diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index bca743dc6b43..17454a2cf6b0 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Digital TV (DVB) devices
 ------------------------
 
diff --git a/Documentation/media/kapi/dtv-demux.rst b/Documentation/media/kapi/dtv-demux.rst
index 24857133e4e8..c0ae5dec5328 100644
--- a/Documentation/media/kapi/dtv-demux.rst
+++ b/Documentation/media/kapi/dtv-demux.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Digital TV Demux kABI
 ---------------------
 
diff --git a/Documentation/media/kapi/dtv-frontend.rst b/Documentation/media/kapi/dtv-frontend.rst
index 472650cdb100..8ea64742c7ba 100644
--- a/Documentation/media/kapi/dtv-frontend.rst
+++ b/Documentation/media/kapi/dtv-frontend.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Digital TV Frontend kABI
 ------------------------
 
diff --git a/Documentation/media/kapi/dtv-net.rst b/Documentation/media/kapi/dtv-net.rst
index 158c7cbd7600..deb6bffe96bb 100644
--- a/Documentation/media/kapi/dtv-net.rst
+++ b/Documentation/media/kapi/dtv-net.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Digital TV Network kABI
 -----------------------
 
diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index 69362b3135c2..0bcfeadbc52d 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Media Controller devices
 ------------------------
 
diff --git a/Documentation/media/kapi/rc-core.rst b/Documentation/media/kapi/rc-core.rst
index 4759f020d6b2..53f5e643b6e9 100644
--- a/Documentation/media/kapi/rc-core.rst
+++ b/Documentation/media/kapi/rc-core.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Remote Controller devices
 -------------------------
 
diff --git a/Documentation/media/kapi/v4l2-async.rst b/Documentation/media/kapi/v4l2-async.rst
index 523ff9eb09a0..3422330b3b1f 100644
--- a/Documentation/media/kapi/v4l2-async.rst
+++ b/Documentation/media/kapi/v4l2-async.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 async kAPI
 ^^^^^^^^^^^^^^^
 .. kernel-doc:: include/media/v4l2-async.h
diff --git a/Documentation/media/kapi/v4l2-clocks.rst b/Documentation/media/kapi/v4l2-clocks.rst
index b8a895860a8a..5c22eecab7ba 100644
--- a/Documentation/media/kapi/v4l2-clocks.rst
+++ b/Documentation/media/kapi/v4l2-clocks.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 clocks
 -----------
 
diff --git a/Documentation/media/kapi/v4l2-common.rst b/Documentation/media/kapi/v4l2-common.rst
index 525d804871ff..b1e70eb56aa4 100644
--- a/Documentation/media/kapi/v4l2-common.rst
+++ b/Documentation/media/kapi/v4l2-common.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 common functions and data structures
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
diff --git a/Documentation/media/kapi/v4l2-controls.rst b/Documentation/media/kapi/v4l2-controls.rst
index 07a179eeb2fb..64ab99abf0b6 100644
--- a/Documentation/media/kapi/v4l2-controls.rst
+++ b/Documentation/media/kapi/v4l2-controls.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 Controls
 =============
 
diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index 5cf292037a48..0dcad7a23141 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Video4Linux devices
 -------------------
 
diff --git a/Documentation/media/kapi/v4l2-dev.rst b/Documentation/media/kapi/v4l2-dev.rst
index eb03ccc41c41..b359f1804bbe 100644
--- a/Documentation/media/kapi/v4l2-dev.rst
+++ b/Documentation/media/kapi/v4l2-dev.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Video device' s internal representation
 =======================================
 
diff --git a/Documentation/media/kapi/v4l2-device.rst b/Documentation/media/kapi/v4l2-device.rst
index 6c58bbbaa66f..c4311f0421be 100644
--- a/Documentation/media/kapi/v4l2-device.rst
+++ b/Documentation/media/kapi/v4l2-device.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 device instance
 --------------------
 
diff --git a/Documentation/media/kapi/v4l2-dv-timings.rst b/Documentation/media/kapi/v4l2-dv-timings.rst
index 55274329d229..b178f931518b 100644
--- a/Documentation/media/kapi/v4l2-dv-timings.rst
+++ b/Documentation/media/kapi/v4l2-dv-timings.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 DV Timings functions
 ^^^^^^^^^^^^^^^^^^^^^^^^^
 
diff --git a/Documentation/media/kapi/v4l2-event.rst b/Documentation/media/kapi/v4l2-event.rst
index b22ccbccdbd1..a4b7ae2b94d8 100644
--- a/Documentation/media/kapi/v4l2-event.rst
+++ b/Documentation/media/kapi/v4l2-event.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 events
 -----------
 
diff --git a/Documentation/media/kapi/v4l2-fh.rst b/Documentation/media/kapi/v4l2-fh.rst
index 3ee64adf4635..4c62b19af744 100644
--- a/Documentation/media/kapi/v4l2-fh.rst
+++ b/Documentation/media/kapi/v4l2-fh.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 File handlers
 ------------------
 
diff --git a/Documentation/media/kapi/v4l2-flash-led-class.rst b/Documentation/media/kapi/v4l2-flash-led-class.rst
index 20798bdac387..2aa6bed9b8db 100644
--- a/Documentation/media/kapi/v4l2-flash-led-class.rst
+++ b/Documentation/media/kapi/v4l2-flash-led-class.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 flash functions and data structures
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
diff --git a/Documentation/media/kapi/v4l2-fwnode.rst b/Documentation/media/kapi/v4l2-fwnode.rst
index 6c8bccdfeb25..e313b6cddcd0 100644
--- a/Documentation/media/kapi/v4l2-fwnode.rst
+++ b/Documentation/media/kapi/v4l2-fwnode.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 fwnode kAPI
 ^^^^^^^^^^^^^^^^
 .. kernel-doc:: include/media/v4l2-fwnode.h
diff --git a/Documentation/media/kapi/v4l2-intro.rst b/Documentation/media/kapi/v4l2-intro.rst
index e614d8d4ca1c..cea3e263e48b 100644
--- a/Documentation/media/kapi/v4l2-intro.rst
+++ b/Documentation/media/kapi/v4l2-intro.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Introduction
 ------------
 
diff --git a/Documentation/media/kapi/v4l2-mc.rst b/Documentation/media/kapi/v4l2-mc.rst
index 8af347013490..0c352ac588b2 100644
--- a/Documentation/media/kapi/v4l2-mc.rst
+++ b/Documentation/media/kapi/v4l2-mc.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 Media Controller functions and data structures
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
diff --git a/Documentation/media/kapi/v4l2-mediabus.rst b/Documentation/media/kapi/v4l2-mediabus.rst
index e64131906d11..1f2254cba92d 100644
--- a/Documentation/media/kapi/v4l2-mediabus.rst
+++ b/Documentation/media/kapi/v4l2-mediabus.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 Media Bus functions and data structures
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
diff --git a/Documentation/media/kapi/v4l2-mem2mem.rst b/Documentation/media/kapi/v4l2-mem2mem.rst
index 5536b4a71e51..a43b31cc8261 100644
--- a/Documentation/media/kapi/v4l2-mem2mem.rst
+++ b/Documentation/media/kapi/v4l2-mem2mem.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 Memory to Memory functions and data structures
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
diff --git a/Documentation/media/kapi/v4l2-rect.rst b/Documentation/media/kapi/v4l2-rect.rst
index 8df5067ad57d..fc315cd84156 100644
--- a/Documentation/media/kapi/v4l2-rect.rst
+++ b/Documentation/media/kapi/v4l2-rect.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 rect helper functions
 ^^^^^^^^^^^^^^^^^^^^^^^^^^
 
diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index 1280e05b662b..be4970909f40 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 V4L2 sub-devices
 ----------------
 
diff --git a/Documentation/media/kapi/v4l2-tuner.rst b/Documentation/media/kapi/v4l2-tuner.rst
index 86e894639651..e6caa3321566 100644
--- a/Documentation/media/kapi/v4l2-tuner.rst
+++ b/Documentation/media/kapi/v4l2-tuner.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Tuner functions and data structures
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
diff --git a/Documentation/media/kapi/v4l2-tveeprom.rst b/Documentation/media/kapi/v4l2-tveeprom.rst
index 33422cb26aa7..43fb391edaba 100644
--- a/Documentation/media/kapi/v4l2-tveeprom.rst
+++ b/Documentation/media/kapi/v4l2-tveeprom.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Hauppauge TV EEPROM functions and data structures
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
diff --git a/Documentation/media/kapi/v4l2-videobuf.rst b/Documentation/media/kapi/v4l2-videobuf.rst
index 54adfd772d28..1a7756397b1a 100644
--- a/Documentation/media/kapi/v4l2-videobuf.rst
+++ b/Documentation/media/kapi/v4l2-videobuf.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. _vb_framework:
 
 Videobuf Framework
diff --git a/Documentation/media/kapi/v4l2-videobuf2.rst b/Documentation/media/kapi/v4l2-videobuf2.rst
index 3c4cb1e7e05f..1044f64ff168 100644
--- a/Documentation/media/kapi/v4l2-videobuf2.rst
+++ b/Documentation/media/kapi/v4l2-videobuf2.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. _vb2_framework:
 
 V4L2 videobuf2 functions and data structures
diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
index 984b61dc3f2e..379b9e7df5d0 100644
--- a/Documentation/media/lirc.h.rst.exceptions
+++ b/Documentation/media/lirc.h.rst.exceptions
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 # Ignore header name
 ignore define _LINUX_LIRC_H
 
diff --git a/Documentation/media/media.h.rst.exceptions b/Documentation/media/media.h.rst.exceptions
index 684fe9c86dee..9b4c26502d95 100644
--- a/Documentation/media/media.h.rst.exceptions
+++ b/Documentation/media/media.h.rst.exceptions
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 # Ignore header name
 ignore define __LINUX_MEDIA_H
 
diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
index 5e28289ee79e..1389998c90f7 100644
--- a/Documentation/media/media_kapi.rst
+++ b/Documentation/media/media_kapi.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 ===================================
diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index bff90d20d3f8..0753005c7bb4 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 ########################################
diff --git a/Documentation/media/net.h.rst.exceptions b/Documentation/media/net.h.rst.exceptions
index afe6bef91567..5159aa4bbbb9 100644
--- a/Documentation/media/net.h.rst.exceptions
+++ b/Documentation/media/net.h.rst.exceptions
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 # Ignore header name
 ignore define _DVBNET_H_
 
diff --git a/Documentation/media/uapi/v4l/pipeline.dot b/Documentation/media/uapi/v4l/pipeline.dot
index 02d7fcf12b26..8c53ce719a14 100644
--- a/Documentation/media/uapi/v4l/pipeline.dot
+++ b/Documentation/media/uapi/v4l/pipeline.dot
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 digraph board {
 	rankdir=TB
 	colorscheme=x11
diff --git a/Documentation/media/v4l-drivers/au0828-cardlist.rst b/Documentation/media/v4l-drivers/au0828-cardlist.rst
index bb87b7b36a83..aaaadc934e7a 100644
--- a/Documentation/media/v4l-drivers/au0828-cardlist.rst
+++ b/Documentation/media/v4l-drivers/au0828-cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 AU0828 cards list
 =================
 
diff --git a/Documentation/media/v4l-drivers/bttv-cardlist.rst b/Documentation/media/v4l-drivers/bttv-cardlist.rst
index 8da27b924e01..f5806856b5a1 100644
--- a/Documentation/media/v4l-drivers/bttv-cardlist.rst
+++ b/Documentation/media/v4l-drivers/bttv-cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 BTTV cards list
 ===============
 
diff --git a/Documentation/media/v4l-drivers/bttv.rst b/Documentation/media/v4l-drivers/bttv.rst
index 5f35e2fb5afa..d72a0f8fd267 100644
--- a/Documentation/media/v4l-drivers/bttv.rst
+++ b/Documentation/media/v4l-drivers/bttv.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The bttv driver
 ===============
 
diff --git a/Documentation/media/v4l-drivers/cafe_ccic.rst b/Documentation/media/v4l-drivers/cafe_ccic.rst
index 94f0f58ebe37..ff7fbce1342a 100644
--- a/Documentation/media/v4l-drivers/cafe_ccic.rst
+++ b/Documentation/media/v4l-drivers/cafe_ccic.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The cafe_ccic driver
 ====================
 
diff --git a/Documentation/media/v4l-drivers/cardlist.rst b/Documentation/media/v4l-drivers/cardlist.rst
index 8a0728d20684..14249f47fbc2 100644
--- a/Documentation/media/v4l-drivers/cardlist.rst
+++ b/Documentation/media/v4l-drivers/cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Cards List
 ==========
 
diff --git a/Documentation/media/v4l-drivers/cpia2.rst b/Documentation/media/v4l-drivers/cpia2.rst
index b5125016cfcb..a86baa1c83f1 100644
--- a/Documentation/media/v4l-drivers/cpia2.rst
+++ b/Documentation/media/v4l-drivers/cpia2.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The cpia2 driver
 ================
 
diff --git a/Documentation/media/v4l-drivers/cx18.rst b/Documentation/media/v4l-drivers/cx18.rst
index afa03f65b01c..16895a734bae 100644
--- a/Documentation/media/v4l-drivers/cx18.rst
+++ b/Documentation/media/v4l-drivers/cx18.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The cx18 driver
 ===============
 
diff --git a/Documentation/media/v4l-drivers/cx2341x.rst b/Documentation/media/v4l-drivers/cx2341x.rst
index e06d07ebdecd..8ca37deb56b6 100644
--- a/Documentation/media/v4l-drivers/cx2341x.rst
+++ b/Documentation/media/v4l-drivers/cx2341x.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The cx2341x driver
 ==================
 
diff --git a/Documentation/media/v4l-drivers/cx23885-cardlist.rst b/Documentation/media/v4l-drivers/cx23885-cardlist.rst
index 8c24df8e0423..ddff8da98eeb 100644
--- a/Documentation/media/v4l-drivers/cx23885-cardlist.rst
+++ b/Documentation/media/v4l-drivers/cx23885-cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 cx23885 cards list
 ==================
 
diff --git a/Documentation/media/v4l-drivers/cx88-cardlist.rst b/Documentation/media/v4l-drivers/cx88-cardlist.rst
index 21648b8c2e83..56ee08028106 100644
--- a/Documentation/media/v4l-drivers/cx88-cardlist.rst
+++ b/Documentation/media/v4l-drivers/cx88-cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 CX88 cards list
 ===============
 
diff --git a/Documentation/media/v4l-drivers/cx88.rst b/Documentation/media/v4l-drivers/cx88.rst
index d8f3a014726a..698c73ea2e36 100644
--- a/Documentation/media/v4l-drivers/cx88.rst
+++ b/Documentation/media/v4l-drivers/cx88.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The cx88 driver
 ===============
 
diff --git a/Documentation/media/v4l-drivers/davinci-vpbe.rst b/Documentation/media/v4l-drivers/davinci-vpbe.rst
index b545fe001919..0fde433e5c71 100644
--- a/Documentation/media/v4l-drivers/davinci-vpbe.rst
+++ b/Documentation/media/v4l-drivers/davinci-vpbe.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The VPBE V4L2 driver design
 ===========================
 
diff --git a/Documentation/media/v4l-drivers/em28xx-cardlist.rst b/Documentation/media/v4l-drivers/em28xx-cardlist.rst
index dfe882ca945f..148c65e1d323 100644
--- a/Documentation/media/v4l-drivers/em28xx-cardlist.rst
+++ b/Documentation/media/v4l-drivers/em28xx-cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 EM28xx cards list
 =================
 
diff --git a/Documentation/media/v4l-drivers/fimc.rst b/Documentation/media/v4l-drivers/fimc.rst
index 3adc19bcf039..74585ba48b7f 100644
--- a/Documentation/media/v4l-drivers/fimc.rst
+++ b/Documentation/media/v4l-drivers/fimc.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 The Samsung S5P/EXYNOS4 FIMC driver
diff --git a/Documentation/media/v4l-drivers/fourcc.rst b/Documentation/media/v4l-drivers/fourcc.rst
index 9c82106e8a26..d3482c40da62 100644
--- a/Documentation/media/v4l-drivers/fourcc.rst
+++ b/Documentation/media/v4l-drivers/fourcc.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Guidelines for Video4Linux pixel format 4CCs
 ============================================
 
diff --git a/Documentation/media/v4l-drivers/gspca-cardlist.rst b/Documentation/media/v4l-drivers/gspca-cardlist.rst
index e18d87e80d78..adda933616f1 100644
--- a/Documentation/media/v4l-drivers/gspca-cardlist.rst
+++ b/Documentation/media/v4l-drivers/gspca-cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The gspca cards list
 ====================
 
diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
index 65d3d15eb159..6922dde4a82b 100644
--- a/Documentation/media/v4l-drivers/imx.rst
+++ b/Documentation/media/v4l-drivers/imx.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 i.MX Video Capture Driver
 =========================
 
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index a816cab8f2cb..6cdd3bc98202 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 .. _v4l-drivers:
diff --git a/Documentation/media/v4l-drivers/ivtv-cardlist.rst b/Documentation/media/v4l-drivers/ivtv-cardlist.rst
index 022dca80c2c8..c34a9ebc9ac2 100644
--- a/Documentation/media/v4l-drivers/ivtv-cardlist.rst
+++ b/Documentation/media/v4l-drivers/ivtv-cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 IVTV cards list
 ===============
 
diff --git a/Documentation/media/v4l-drivers/ivtv.rst b/Documentation/media/v4l-drivers/ivtv.rst
index 24fb3c5f0b66..7b8775d20214 100644
--- a/Documentation/media/v4l-drivers/ivtv.rst
+++ b/Documentation/media/v4l-drivers/ivtv.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The ivtv driver
 ===============
 
diff --git a/Documentation/media/v4l-drivers/max2175.rst b/Documentation/media/v4l-drivers/max2175.rst
index b1a4c89fd869..a5e35059d98d 100644
--- a/Documentation/media/v4l-drivers/max2175.rst
+++ b/Documentation/media/v4l-drivers/max2175.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Maxim Integrated MAX2175 RF to bits tuner driver
 ================================================
 
diff --git a/Documentation/media/v4l-drivers/meye.rst b/Documentation/media/v4l-drivers/meye.rst
index cfaba6021850..a572996cdbf6 100644
--- a/Documentation/media/v4l-drivers/meye.rst
+++ b/Documentation/media/v4l-drivers/meye.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 Vaio Picturebook Motion Eye Camera Driver
diff --git a/Documentation/media/v4l-drivers/omap3isp.rst b/Documentation/media/v4l-drivers/omap3isp.rst
index 336e58feaee2..8974c444e3a1 100644
--- a/Documentation/media/v4l-drivers/omap3isp.rst
+++ b/Documentation/media/v4l-drivers/omap3isp.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 OMAP 3 Image Signal Processor (ISP) driver
diff --git a/Documentation/media/v4l-drivers/omap4_camera.rst b/Documentation/media/v4l-drivers/omap4_camera.rst
index 54b427b28e5f..24db4222d36d 100644
--- a/Documentation/media/v4l-drivers/omap4_camera.rst
+++ b/Documentation/media/v4l-drivers/omap4_camera.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 OMAP4 ISS Driver
 ================
 
diff --git a/Documentation/media/v4l-drivers/philips.rst b/Documentation/media/v4l-drivers/philips.rst
index 4f68947e6a13..e2840be10d08 100644
--- a/Documentation/media/v4l-drivers/philips.rst
+++ b/Documentation/media/v4l-drivers/philips.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Philips webcams (pwc driver)
 ============================
 
diff --git a/Documentation/media/v4l-drivers/pvrusb2.rst b/Documentation/media/v4l-drivers/pvrusb2.rst
index dc0e72d94b1a..83bfaa531ea8 100644
--- a/Documentation/media/v4l-drivers/pvrusb2.rst
+++ b/Documentation/media/v4l-drivers/pvrusb2.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The pvrusb2 driver
 ==================
 
diff --git a/Documentation/media/v4l-drivers/pxa_camera.rst b/Documentation/media/v4l-drivers/pxa_camera.rst
index 554f91b04e70..e4fbca755e1a 100644
--- a/Documentation/media/v4l-drivers/pxa_camera.rst
+++ b/Documentation/media/v4l-drivers/pxa_camera.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 PXA-Camera Host Driver
 ======================
 
diff --git a/Documentation/media/v4l-drivers/qcom_camss.rst b/Documentation/media/v4l-drivers/qcom_camss.rst
index f27c8df20b2b..6b15385b12b3 100644
--- a/Documentation/media/v4l-drivers/qcom_camss.rst
+++ b/Documentation/media/v4l-drivers/qcom_camss.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 Qualcomm Camera Subsystem driver
diff --git a/Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot b/Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot
index de34f0a7afdc..7ed243b41b67 100644
--- a/Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot
+++ b/Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 digraph board {
 	rankdir=TB
 	n00000001 [label="{{<port0> 0} | msm_csiphy0\n/dev/v4l-subdev0 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
diff --git a/Documentation/media/v4l-drivers/qcom_camss_graph.dot b/Documentation/media/v4l-drivers/qcom_camss_graph.dot
index 827fc7112c1e..ef7dca92fd0b 100644
--- a/Documentation/media/v4l-drivers/qcom_camss_graph.dot
+++ b/Documentation/media/v4l-drivers/qcom_camss_graph.dot
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 digraph board {
 	rankdir=TB
 	n00000001 [label="{{<port0> 0} | msm_csiphy0\n/dev/v4l-subdev0 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
diff --git a/Documentation/media/v4l-drivers/radiotrack.rst b/Documentation/media/v4l-drivers/radiotrack.rst
index 2f6325ebfd16..a85cb6205db8 100644
--- a/Documentation/media/v4l-drivers/radiotrack.rst
+++ b/Documentation/media/v4l-drivers/radiotrack.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The Radiotrack radio driver
 ===========================
 
diff --git a/Documentation/media/v4l-drivers/rcar-fdp1.rst b/Documentation/media/v4l-drivers/rcar-fdp1.rst
index a59b1e8e3e9c..88b0edcf9046 100644
--- a/Documentation/media/v4l-drivers/rcar-fdp1.rst
+++ b/Documentation/media/v4l-drivers/rcar-fdp1.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Renesas R-Car Fine Display Processor (FDP1) Driver
 ==================================================
 
diff --git a/Documentation/media/v4l-drivers/saa7134-cardlist.rst b/Documentation/media/v4l-drivers/saa7134-cardlist.rst
index 6e4c35cbaabf..afb0e2fb52b0 100644
--- a/Documentation/media/v4l-drivers/saa7134-cardlist.rst
+++ b/Documentation/media/v4l-drivers/saa7134-cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 SAA7134 cards list
 ==================
 
diff --git a/Documentation/media/v4l-drivers/saa7134.rst b/Documentation/media/v4l-drivers/saa7134.rst
index 36b2ee9e0fdc..15d06facdbc1 100644
--- a/Documentation/media/v4l-drivers/saa7134.rst
+++ b/Documentation/media/v4l-drivers/saa7134.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The saa7134 driver
 ==================
 
diff --git a/Documentation/media/v4l-drivers/saa7164-cardlist.rst b/Documentation/media/v4l-drivers/saa7164-cardlist.rst
index e28382ba82e6..e8f36e084537 100644
--- a/Documentation/media/v4l-drivers/saa7164-cardlist.rst
+++ b/Documentation/media/v4l-drivers/saa7164-cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 SAA7164 cards list
 ==================
 
diff --git a/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst b/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst
index 9b1e1c5a23f0..822fcb8368ae 100644
--- a/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst
+++ b/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Cropping and Scaling algorithm, used in the sh_mobile_ceu_camera driver
 =======================================================================
 
diff --git a/Documentation/media/v4l-drivers/si470x.rst b/Documentation/media/v4l-drivers/si470x.rst
index 955d8ca159fe..d53bf5f95200 100644
--- a/Documentation/media/v4l-drivers/si470x.rst
+++ b/Documentation/media/v4l-drivers/si470x.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 The Silicon Labs Si470x FM Radio Receivers driver
diff --git a/Documentation/media/v4l-drivers/si4713.rst b/Documentation/media/v4l-drivers/si4713.rst
index 3022e7cfe9a8..be8e6b49b7b4 100644
--- a/Documentation/media/v4l-drivers/si4713.rst
+++ b/Documentation/media/v4l-drivers/si4713.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 The Silicon Labs Si4713 FM Radio Transmitter Driver
diff --git a/Documentation/media/v4l-drivers/si476x.rst b/Documentation/media/v4l-drivers/si476x.rst
index 677512566f15..87062301d6a1 100644
--- a/Documentation/media/v4l-drivers/si476x.rst
+++ b/Documentation/media/v4l-drivers/si476x.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 .. include:: <isonum.txt>
 
 
diff --git a/Documentation/media/v4l-drivers/soc-camera.rst b/Documentation/media/v4l-drivers/soc-camera.rst
index 79d09e423700..7c39711aebf8 100644
--- a/Documentation/media/v4l-drivers/soc-camera.rst
+++ b/Documentation/media/v4l-drivers/soc-camera.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The Soc-Camera Drivers
 ======================
 
diff --git a/Documentation/media/v4l-drivers/tm6000-cardlist.rst b/Documentation/media/v4l-drivers/tm6000-cardlist.rst
index 6bd083544457..6d2769c0f4d8 100644
--- a/Documentation/media/v4l-drivers/tm6000-cardlist.rst
+++ b/Documentation/media/v4l-drivers/tm6000-cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 TM6000 cards list
 =================
 
diff --git a/Documentation/media/v4l-drivers/tuner-cardlist.rst b/Documentation/media/v4l-drivers/tuner-cardlist.rst
index 276dd90e0c59..362617c59c5d 100644
--- a/Documentation/media/v4l-drivers/tuner-cardlist.rst
+++ b/Documentation/media/v4l-drivers/tuner-cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Tuner cards list
 ================
 
diff --git a/Documentation/media/v4l-drivers/tuners.rst b/Documentation/media/v4l-drivers/tuners.rst
index c3e8a1cf64a6..7509be888909 100644
--- a/Documentation/media/v4l-drivers/tuners.rst
+++ b/Documentation/media/v4l-drivers/tuners.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Tuner drivers
 =============
 
diff --git a/Documentation/media/v4l-drivers/usbvision-cardlist.rst b/Documentation/media/v4l-drivers/usbvision-cardlist.rst
index 5a8ffbfc204e..6aee115ee6e2 100644
--- a/Documentation/media/v4l-drivers/usbvision-cardlist.rst
+++ b/Documentation/media/v4l-drivers/usbvision-cardlist.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 USBvision cards list
 ====================
 
diff --git a/Documentation/media/v4l-drivers/uvcvideo.rst b/Documentation/media/v4l-drivers/uvcvideo.rst
index d68b3d59a4b5..e5fd8fad333c 100644
--- a/Documentation/media/v4l-drivers/uvcvideo.rst
+++ b/Documentation/media/v4l-drivers/uvcvideo.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The Linux USB Video Class (UVC) driver
 ======================================
 
diff --git a/Documentation/media/v4l-drivers/v4l-with-ir.rst b/Documentation/media/v4l-drivers/v4l-with-ir.rst
index 613e1e79fc96..ce23c8a7bc93 100644
--- a/Documentation/media/v4l-drivers/v4l-with-ir.rst
+++ b/Documentation/media/v4l-drivers/v4l-with-ir.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Infrared remote control support in video4linux drivers
 ======================================================
 
diff --git a/Documentation/media/v4l-drivers/vivid.rst b/Documentation/media/v4l-drivers/vivid.rst
index 089595ce11c5..edb6f33e029c 100644
--- a/Documentation/media/v4l-drivers/vivid.rst
+++ b/Documentation/media/v4l-drivers/vivid.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The Virtual Video Test Driver (vivid)
 =====================================
 
diff --git a/Documentation/media/v4l-drivers/zoran.rst b/Documentation/media/v4l-drivers/zoran.rst
index c3a0f7bc2c7b..d2724a863d1d 100644
--- a/Documentation/media/v4l-drivers/zoran.rst
+++ b/Documentation/media/v4l-drivers/zoran.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 The Zoran driver
 ================
 
diff --git a/Documentation/media/v4l-drivers/zr364xx.rst b/Documentation/media/v4l-drivers/zr364xx.rst
index 3d193f01d8bb..ec8acb3e98fc 100644
--- a/Documentation/media/v4l-drivers/zr364xx.rst
+++ b/Documentation/media/v4l-drivers/zr364xx.rst
@@ -1,3 +1,5 @@
+.. SPDX-License-Identifier: GPL-2.0
+
 Zoran 364xx based USB webcam module
 ===================================
 
diff --git a/Documentation/media/video.h.rst.exceptions b/Documentation/media/video.h.rst.exceptions
index 371cdbd7d062..ea9de59ad8b7 100644
--- a/Documentation/media/video.h.rst.exceptions
+++ b/Documentation/media/video.h.rst.exceptions
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 # Ignore header name
 ignore define _UAPI_DVBVIDEO_H_
 
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index 1ec425a7c364..4c4bcba0f307 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 # Ignore header name
 ignore define _UAPI__LINUX_VIDEODEV2_H
 
-- 
2.19.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535Ab2FNUix (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 16:38:53 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5EKcrsV017483
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 16:38:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 05/10] [media] dvb-usb: move it to drivers/media/usb/dvb-usb
Date: Thu, 14 Jun 2012 17:35:56 -0300
Message-Id: <1339706161-22713-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
References: <1339706161-22713-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As media/dvb will be removed, move it to a proper place.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/dvb/README.dvb-usb                      |    2 +-
 drivers/media/Kconfig                                 |    1 +
 drivers/media/Makefile                                |    2 +-
 drivers/media/dvb/Kconfig                             |    7 -------
 drivers/media/dvb/Makefile                            |    4 ----
 drivers/media/usb/Kconfig                             |   17 +++++++++++++++++
 drivers/media/usb/Makefile                            |    6 ++++++
 drivers/media/{dvb => usb}/dvb-usb/Kconfig            |    0
 drivers/media/{dvb => usb}/dvb-usb/Makefile           |    0
 drivers/media/{dvb => usb}/dvb-usb/a800.c             |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005-fe.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005-remote.c    |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005-script.h    |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/af9015.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/af9015.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/af9035.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/af9035.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/anysee.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/anysee.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/au6610.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/au6610.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/az6007.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/az6027.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/az6027.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/ce6230.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/ce6230.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/cinergyT2-core.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/cinergyT2-fe.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/cinergyT2.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/cxusb.c            |    0
 drivers/media/{dvb => usb}/dvb-usb/cxusb.h            |    0
 drivers/media/{dvb => usb}/dvb-usb/dib0700.h          |    0
 drivers/media/{dvb => usb}/dvb-usb/dib0700_core.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/dib0700_devices.c  |    0
 drivers/media/{dvb => usb}/dvb-usb/dib07x0.h          |    0
 drivers/media/{dvb => usb}/dvb-usb/dibusb-common.c    |    0
 drivers/media/{dvb => usb}/dvb-usb/dibusb-mb.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/dibusb-mc.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/dibusb.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/digitv.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/digitv.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/dtt200u-fe.c       |    0
 drivers/media/{dvb => usb}/dvb-usb/dtt200u.c          |    0
 drivers/media/{dvb => usb}/dvb-usb/dtt200u.h          |    0
 drivers/media/{dvb => usb}/dvb-usb/dtv5100.c          |    0
 drivers/media/{dvb => usb}/dvb-usb/dtv5100.h          |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-common.h   |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-dvb.c      |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-firmware.c |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-i2c.c      |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-ids.h      |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-init.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-remote.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-urb.c      |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb.h          |    0
 drivers/media/{dvb => usb}/dvb-usb/dw2102.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/dw2102.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/ec168.c            |    0
 drivers/media/{dvb => usb}/dvb-usb/ec168.h            |    0
 drivers/media/{dvb => usb}/dvb-usb/friio-fe.c         |    0
 drivers/media/{dvb => usb}/dvb-usb/friio.c            |    0
 drivers/media/{dvb => usb}/dvb-usb/friio.h            |    0
 drivers/media/{dvb => usb}/dvb-usb/gl861.c            |    0
 drivers/media/{dvb => usb}/dvb-usb/gl861.h            |    0
 drivers/media/{dvb => usb}/dvb-usb/gp8psk-fe.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/gp8psk.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/gp8psk.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/it913x.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/lmedm04.c          |    0
 drivers/media/{dvb => usb}/dvb-usb/lmedm04.h          |    0
 drivers/media/{dvb => usb}/dvb-usb/m920x.c            |    0
 drivers/media/{dvb => usb}/dvb-usb/m920x.h            |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-demod.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-demod.h   |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-gpio.c    |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-gpio.h    |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-i2c.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-i2c.h     |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-phy.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-phy.h     |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-reg.h     |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-tuner.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf-tuner.h   |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf.c         |    0
 drivers/media/{dvb => usb}/dvb-usb/mxl111sf.h         |    0
 drivers/media/{dvb => usb}/dvb-usb/nova-t-usb2.c      |    0
 drivers/media/{dvb => usb}/dvb-usb/opera1.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/pctv452e.c         |    0
 drivers/media/{dvb => usb}/dvb-usb/rtl28xxu.c         |    0
 drivers/media/{dvb => usb}/dvb-usb/rtl28xxu.h         |    0
 drivers/media/{dvb => usb}/dvb-usb/technisat-usb2.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/ttusb2.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/ttusb2.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/umt-010.c          |    0
 drivers/media/{dvb => usb}/dvb-usb/usb-urb.c          |    0
 drivers/media/{dvb => usb}/dvb-usb/vp702x-fe.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/vp702x.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/vp702x.h           |    0
 drivers/media/{dvb => usb}/dvb-usb/vp7045-fe.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/vp7045.c           |    0
 drivers/media/{dvb => usb}/dvb-usb/vp7045.h           |    0
 drivers/media/{dvb => usb}/siano/Kconfig              |    0
 drivers/media/{dvb => usb}/siano/Makefile             |    0
 drivers/media/{dvb => usb}/siano/sms-cards.c          |    0
 drivers/media/{dvb => usb}/siano/sms-cards.h          |    0
 drivers/media/{dvb => usb}/siano/smscoreapi.c         |    0
 drivers/media/{dvb => usb}/siano/smscoreapi.h         |    0
 drivers/media/{dvb => usb}/siano/smsdvb.c             |    0
 drivers/media/{dvb => usb}/siano/smsendian.c          |    0
 drivers/media/{dvb => usb}/siano/smsendian.h          |    0
 drivers/media/{dvb => usb}/siano/smsir.c              |    0
 drivers/media/{dvb => usb}/siano/smsir.h              |    0
 drivers/media/{dvb => usb}/siano/smssdio.c            |    0
 drivers/media/{dvb => usb}/siano/smsusb.c             |    0
 drivers/media/{dvb => usb}/ttusb-budget/Kconfig       |    0
 drivers/media/{dvb => usb}/ttusb-budget/Makefile      |    0
 .../{dvb => usb}/ttusb-budget/dvb-ttusb-budget.c      |    0
 drivers/media/{dvb => usb}/ttusb-dec/Kconfig          |    0
 drivers/media/{dvb => usb}/ttusb-dec/Makefile         |    0
 drivers/media/{dvb => usb}/ttusb-dec/ttusb_dec.c      |    0
 drivers/media/{dvb => usb}/ttusb-dec/ttusbdecfe.c     |    0
 drivers/media/{dvb => usb}/ttusb-dec/ttusbdecfe.h     |    0
 drivers/media/video/cx231xx/Makefile                  |    2 +-
 drivers/staging/media/go7007/Makefile                 |    2 +-
 126 files changed, 28 insertions(+), 15 deletions(-)
 create mode 100644 drivers/media/usb/Kconfig
 create mode 100644 drivers/media/usb/Makefile
 rename drivers/media/{dvb => usb}/dvb-usb/Kconfig (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/Makefile (100%)
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
 rename drivers/media/{dvb => usb}/siano/Kconfig (100%)
 rename drivers/media/{dvb => usb}/siano/Makefile (100%)
 rename drivers/media/{dvb => usb}/siano/sms-cards.c (100%)
 rename drivers/media/{dvb => usb}/siano/sms-cards.h (100%)
 rename drivers/media/{dvb => usb}/siano/smscoreapi.c (100%)
 rename drivers/media/{dvb => usb}/siano/smscoreapi.h (100%)
 rename drivers/media/{dvb => usb}/siano/smsdvb.c (100%)
 rename drivers/media/{dvb => usb}/siano/smsendian.c (100%)
 rename drivers/media/{dvb => usb}/siano/smsendian.h (100%)
 rename drivers/media/{dvb => usb}/siano/smsir.c (100%)
 rename drivers/media/{dvb => usb}/siano/smsir.h (100%)
 rename drivers/media/{dvb => usb}/siano/smssdio.c (100%)
 rename drivers/media/{dvb => usb}/siano/smsusb.c (100%)
 rename drivers/media/{dvb => usb}/ttusb-budget/Kconfig (100%)
 rename drivers/media/{dvb => usb}/ttusb-budget/Makefile (100%)
 rename drivers/media/{dvb => usb}/ttusb-budget/dvb-ttusb-budget.c (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/Kconfig (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/Makefile (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/ttusb_dec.c (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/ttusbdecfe.c (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/ttusbdecfe.h (100%)

diff --git a/Documentation/dvb/README.dvb-usb b/Documentation/dvb/README.dvb-usb
index c4d963a..8eb9226 100644
--- a/Documentation/dvb/README.dvb-usb
+++ b/Documentation/dvb/README.dvb-usb
@@ -30,7 +30,7 @@ with the device via the bus. The connection between the DVB-API-functionality
 is done via callbacks, assigned in a static device-description (struct
 dvb_usb_device) each device-driver has to have.
 
-For an example have a look in drivers/media/dvb/dvb-usb/vp7045*.
+For an example have a look in drivers/media/usb/dvb-usb/vp7045*.
 
 Objective is to migrate all the usb-devices (dibusb, cinergyT2, maybe the
 ttusb; flexcop-usb already benefits from the generic flexcop-device) to use
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 788be30..d71a855 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -165,6 +165,7 @@ source "drivers/media/radio/Kconfig"
 
 source "drivers/media/dvb-core/Kconfig"
 source "drivers/media/dvb/Kconfig"
+source "drivers/media/usb/Kconfig"
 
 comment "Supported FireWire (IEEE 1394) Adapters"
 	depends on DVB_CORE && FIREWIRE
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 37e448c..46a8dc3 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -11,5 +11,5 @@ endif
 obj-y += v4l2-core/ common/ rc/ video/
 
 obj-$(CONFIG_VIDEO_DEV) += radio/
-obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb/ dvb-frontends/
+obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb/ dvb-frontends/ usb/
 obj-$(CONFIG_DVB_FIREDTV) += firewire/
diff --git a/drivers/media/dvb/Kconfig b/drivers/media/dvb/Kconfig
index 71bb941..e2565a4 100644
--- a/drivers/media/dvb/Kconfig
+++ b/drivers/media/dvb/Kconfig
@@ -15,13 +15,6 @@ comment "Supported SAA7146 based PCI Adapters"
 	depends on DVB_CORE && PCI && I2C
 source "drivers/media/dvb/ttpci/Kconfig"
 
-comment "Supported USB Adapters"
-	depends on DVB_CORE && USB && I2C
-source "drivers/media/dvb/dvb-usb/Kconfig"
-source "drivers/media/dvb/ttusb-budget/Kconfig"
-source "drivers/media/dvb/ttusb-dec/Kconfig"
-source "drivers/media/dvb/siano/Kconfig"
-
 comment "Supported FlexCopII (B2C2) Adapters"
 	depends on DVB_CORE && (PCI || USB) && I2C
 source "drivers/media/dvb/b2c2/Kconfig"
diff --git a/drivers/media/dvb/Makefile b/drivers/media/dvb/Makefile
index dd2864b..c5fa43a 100644
--- a/drivers/media/dvb/Makefile
+++ b/drivers/media/dvb/Makefile
@@ -3,13 +3,9 @@
 #
 
 obj-y        :=	ttpci/		\
-		ttusb-dec/	\
-		ttusb-budget/	\
 		b2c2/		\
 		bt8xx/		\
-		dvb-usb/	\
 		pluto2/		\
-		siano/		\
 		dm1105/		\
 		pt1/		\
 		mantis/		\
diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
new file mode 100644
index 0000000..d8891ad
--- /dev/null
+++ b/drivers/media/usb/Kconfig
@@ -0,0 +1,17 @@
+#
+# USB media device configuration
+#
+
+menuconfig MEDIA_USB_DRIVERS
+	bool "Supported DVB USB Adapters"
+        depends on USB
+        default y
+
+if MEDIA_USB_DRIVERS && DVB_CORE && I2C
+
+source "drivers/media/usb/dvb-usb/Kconfig"
+source "drivers/media/usb/ttusb-budget/Kconfig"
+source "drivers/media/usb/ttusb-dec/Kconfig"
+source "drivers/media/usb/siano/Kconfig"
+
+endif
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
new file mode 100644
index 0000000..b6c2229
--- /dev/null
+++ b/drivers/media/usb/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the USB media device drivers
+#
+
+# DVB USB-only drivers
+obj-y := ttusb-dec/ ttusb-budget/ dvb-usb/ siano/
diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
similarity index 100%
rename from drivers/media/dvb/dvb-usb/Kconfig
rename to drivers/media/usb/dvb-usb/Kconfig
diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/usb/dvb-usb/Makefile
similarity index 100%
rename from drivers/media/dvb/dvb-usb/Makefile
rename to drivers/media/usb/dvb-usb/Makefile
diff --git a/drivers/media/dvb/dvb-usb/a800.c b/drivers/media/usb/dvb-usb/a800.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/a800.c
rename to drivers/media/usb/dvb-usb/a800.c
diff --git a/drivers/media/dvb/dvb-usb/af9005-fe.c b/drivers/media/usb/dvb-usb/af9005-fe.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/af9005-fe.c
rename to drivers/media/usb/dvb-usb/af9005-fe.c
diff --git a/drivers/media/dvb/dvb-usb/af9005-remote.c b/drivers/media/usb/dvb-usb/af9005-remote.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/af9005-remote.c
rename to drivers/media/usb/dvb-usb/af9005-remote.c
diff --git a/drivers/media/dvb/dvb-usb/af9005-script.h b/drivers/media/usb/dvb-usb/af9005-script.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/af9005-script.h
rename to drivers/media/usb/dvb-usb/af9005-script.h
diff --git a/drivers/media/dvb/dvb-usb/af9005.c b/drivers/media/usb/dvb-usb/af9005.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/af9005.c
rename to drivers/media/usb/dvb-usb/af9005.c
diff --git a/drivers/media/dvb/dvb-usb/af9005.h b/drivers/media/usb/dvb-usb/af9005.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/af9005.h
rename to drivers/media/usb/dvb-usb/af9005.h
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/usb/dvb-usb/af9015.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/af9015.c
rename to drivers/media/usb/dvb-usb/af9015.c
diff --git a/drivers/media/dvb/dvb-usb/af9015.h b/drivers/media/usb/dvb-usb/af9015.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/af9015.h
rename to drivers/media/usb/dvb-usb/af9015.h
diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/usb/dvb-usb/af9035.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/af9035.c
rename to drivers/media/usb/dvb-usb/af9035.c
diff --git a/drivers/media/dvb/dvb-usb/af9035.h b/drivers/media/usb/dvb-usb/af9035.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/af9035.h
rename to drivers/media/usb/dvb-usb/af9035.h
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/usb/dvb-usb/anysee.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/anysee.c
rename to drivers/media/usb/dvb-usb/anysee.c
diff --git a/drivers/media/dvb/dvb-usb/anysee.h b/drivers/media/usb/dvb-usb/anysee.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/anysee.h
rename to drivers/media/usb/dvb-usb/anysee.h
diff --git a/drivers/media/dvb/dvb-usb/au6610.c b/drivers/media/usb/dvb-usb/au6610.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/au6610.c
rename to drivers/media/usb/dvb-usb/au6610.c
diff --git a/drivers/media/dvb/dvb-usb/au6610.h b/drivers/media/usb/dvb-usb/au6610.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/au6610.h
rename to drivers/media/usb/dvb-usb/au6610.h
diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/usb/dvb-usb/az6007.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/az6007.c
rename to drivers/media/usb/dvb-usb/az6007.c
diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/az6027.c
rename to drivers/media/usb/dvb-usb/az6027.c
diff --git a/drivers/media/dvb/dvb-usb/az6027.h b/drivers/media/usb/dvb-usb/az6027.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/az6027.h
rename to drivers/media/usb/dvb-usb/az6027.h
diff --git a/drivers/media/dvb/dvb-usb/ce6230.c b/drivers/media/usb/dvb-usb/ce6230.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/ce6230.c
rename to drivers/media/usb/dvb-usb/ce6230.c
diff --git a/drivers/media/dvb/dvb-usb/ce6230.h b/drivers/media/usb/dvb-usb/ce6230.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/ce6230.h
rename to drivers/media/usb/dvb-usb/ce6230.h
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-core.c b/drivers/media/usb/dvb-usb/cinergyT2-core.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/cinergyT2-core.c
rename to drivers/media/usb/dvb-usb/cinergyT2-core.c
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/cinergyT2-fe.c
rename to drivers/media/usb/dvb-usb/cinergyT2-fe.c
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2.h b/drivers/media/usb/dvb-usb/cinergyT2.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/cinergyT2.h
rename to drivers/media/usb/dvb-usb/cinergyT2.h
diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/cxusb.c
rename to drivers/media/usb/dvb-usb/cxusb.c
diff --git a/drivers/media/dvb/dvb-usb/cxusb.h b/drivers/media/usb/dvb-usb/cxusb.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/cxusb.h
rename to drivers/media/usb/dvb-usb/cxusb.h
diff --git a/drivers/media/dvb/dvb-usb/dib0700.h b/drivers/media/usb/dvb-usb/dib0700.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dib0700.h
rename to drivers/media/usb/dvb-usb/dib0700.h
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dib0700_core.c
rename to drivers/media/usb/dvb-usb/dib0700_core.c
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dib0700_devices.c
rename to drivers/media/usb/dvb-usb/dib0700_devices.c
diff --git a/drivers/media/dvb/dvb-usb/dib07x0.h b/drivers/media/usb/dvb-usb/dib07x0.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dib07x0.h
rename to drivers/media/usb/dvb-usb/dib07x0.h
diff --git a/drivers/media/dvb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dibusb-common.c
rename to drivers/media/usb/dvb-usb/dibusb-common.c
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mb.c b/drivers/media/usb/dvb-usb/dibusb-mb.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dibusb-mb.c
rename to drivers/media/usb/dvb-usb/dibusb-mb.c
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mc.c b/drivers/media/usb/dvb-usb/dibusb-mc.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dibusb-mc.c
rename to drivers/media/usb/dvb-usb/dibusb-mc.c
diff --git a/drivers/media/dvb/dvb-usb/dibusb.h b/drivers/media/usb/dvb-usb/dibusb.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dibusb.h
rename to drivers/media/usb/dvb-usb/dibusb.h
diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/usb/dvb-usb/digitv.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/digitv.c
rename to drivers/media/usb/dvb-usb/digitv.c
diff --git a/drivers/media/dvb/dvb-usb/digitv.h b/drivers/media/usb/dvb-usb/digitv.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/digitv.h
rename to drivers/media/usb/dvb-usb/digitv.h
diff --git a/drivers/media/dvb/dvb-usb/dtt200u-fe.c b/drivers/media/usb/dvb-usb/dtt200u-fe.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dtt200u-fe.c
rename to drivers/media/usb/dvb-usb/dtt200u-fe.c
diff --git a/drivers/media/dvb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dtt200u.c
rename to drivers/media/usb/dvb-usb/dtt200u.c
diff --git a/drivers/media/dvb/dvb-usb/dtt200u.h b/drivers/media/usb/dvb-usb/dtt200u.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dtt200u.h
rename to drivers/media/usb/dvb-usb/dtt200u.h
diff --git a/drivers/media/dvb/dvb-usb/dtv5100.c b/drivers/media/usb/dvb-usb/dtv5100.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dtv5100.c
rename to drivers/media/usb/dvb-usb/dtv5100.c
diff --git a/drivers/media/dvb/dvb-usb/dtv5100.h b/drivers/media/usb/dvb-usb/dtv5100.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dtv5100.h
rename to drivers/media/usb/dvb-usb/dtv5100.h
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-common.h b/drivers/media/usb/dvb-usb/dvb-usb-common.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dvb-usb-common.h
rename to drivers/media/usb/dvb-usb/dvb-usb-common.h
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
rename to drivers/media/usb/dvb-usb/dvb-usb-dvb.c
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
rename to drivers/media/usb/dvb-usb/dvb-usb-firmware.c
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c b/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dvb-usb-i2c.c
rename to drivers/media/usb/dvb-usb/dvb-usb-i2c.c
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/usb/dvb-usb/dvb-usb-ids.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dvb-usb-ids.h
rename to drivers/media/usb/dvb-usb/dvb-usb-ids.h
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dvb-usb-init.c
rename to drivers/media/usb/dvb-usb/dvb-usb-init.c
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dvb-usb-remote.c
rename to drivers/media/usb/dvb-usb/dvb-usb-remote.c
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-urb.c b/drivers/media/usb/dvb-usb/dvb-usb-urb.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dvb-usb-urb.c
rename to drivers/media/usb/dvb-usb/dvb-usb-urb.c
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dvb-usb.h
rename to drivers/media/usb/dvb-usb/dvb-usb.h
diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dw2102.c
rename to drivers/media/usb/dvb-usb/dw2102.c
diff --git a/drivers/media/dvb/dvb-usb/dw2102.h b/drivers/media/usb/dvb-usb/dw2102.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/dw2102.h
rename to drivers/media/usb/dvb-usb/dw2102.h
diff --git a/drivers/media/dvb/dvb-usb/ec168.c b/drivers/media/usb/dvb-usb/ec168.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/ec168.c
rename to drivers/media/usb/dvb-usb/ec168.c
diff --git a/drivers/media/dvb/dvb-usb/ec168.h b/drivers/media/usb/dvb-usb/ec168.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/ec168.h
rename to drivers/media/usb/dvb-usb/ec168.h
diff --git a/drivers/media/dvb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/friio-fe.c
rename to drivers/media/usb/dvb-usb/friio-fe.c
diff --git a/drivers/media/dvb/dvb-usb/friio.c b/drivers/media/usb/dvb-usb/friio.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/friio.c
rename to drivers/media/usb/dvb-usb/friio.c
diff --git a/drivers/media/dvb/dvb-usb/friio.h b/drivers/media/usb/dvb-usb/friio.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/friio.h
rename to drivers/media/usb/dvb-usb/friio.h
diff --git a/drivers/media/dvb/dvb-usb/gl861.c b/drivers/media/usb/dvb-usb/gl861.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/gl861.c
rename to drivers/media/usb/dvb-usb/gl861.c
diff --git a/drivers/media/dvb/dvb-usb/gl861.h b/drivers/media/usb/dvb-usb/gl861.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/gl861.h
rename to drivers/media/usb/dvb-usb/gl861.h
diff --git a/drivers/media/dvb/dvb-usb/gp8psk-fe.c b/drivers/media/usb/dvb-usb/gp8psk-fe.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/gp8psk-fe.c
rename to drivers/media/usb/dvb-usb/gp8psk-fe.c
diff --git a/drivers/media/dvb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/gp8psk.c
rename to drivers/media/usb/dvb-usb/gp8psk.c
diff --git a/drivers/media/dvb/dvb-usb/gp8psk.h b/drivers/media/usb/dvb-usb/gp8psk.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/gp8psk.h
rename to drivers/media/usb/dvb-usb/gp8psk.h
diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/usb/dvb-usb/it913x.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/it913x.c
rename to drivers/media/usb/dvb-usb/it913x.c
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/usb/dvb-usb/lmedm04.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/lmedm04.c
rename to drivers/media/usb/dvb-usb/lmedm04.c
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.h b/drivers/media/usb/dvb-usb/lmedm04.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/lmedm04.h
rename to drivers/media/usb/dvb-usb/lmedm04.h
diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/m920x.c
rename to drivers/media/usb/dvb-usb/m920x.c
diff --git a/drivers/media/dvb/dvb-usb/m920x.h b/drivers/media/usb/dvb-usb/m920x.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/m920x.h
rename to drivers/media/usb/dvb-usb/m920x.h
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-demod.c b/drivers/media/usb/dvb-usb/mxl111sf-demod.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf-demod.c
rename to drivers/media/usb/dvb-usb/mxl111sf-demod.c
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-demod.h b/drivers/media/usb/dvb-usb/mxl111sf-demod.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf-demod.h
rename to drivers/media/usb/dvb-usb/mxl111sf-demod.h
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-gpio.c b/drivers/media/usb/dvb-usb/mxl111sf-gpio.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf-gpio.c
rename to drivers/media/usb/dvb-usb/mxl111sf-gpio.c
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-gpio.h b/drivers/media/usb/dvb-usb/mxl111sf-gpio.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf-gpio.h
rename to drivers/media/usb/dvb-usb/mxl111sf-gpio.h
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-i2c.c b/drivers/media/usb/dvb-usb/mxl111sf-i2c.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf-i2c.c
rename to drivers/media/usb/dvb-usb/mxl111sf-i2c.c
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-i2c.h b/drivers/media/usb/dvb-usb/mxl111sf-i2c.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf-i2c.h
rename to drivers/media/usb/dvb-usb/mxl111sf-i2c.h
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-phy.c b/drivers/media/usb/dvb-usb/mxl111sf-phy.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf-phy.c
rename to drivers/media/usb/dvb-usb/mxl111sf-phy.c
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-phy.h b/drivers/media/usb/dvb-usb/mxl111sf-phy.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf-phy.h
rename to drivers/media/usb/dvb-usb/mxl111sf-phy.h
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-reg.h b/drivers/media/usb/dvb-usb/mxl111sf-reg.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf-reg.h
rename to drivers/media/usb/dvb-usb/mxl111sf-reg.h
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c b/drivers/media/usb/dvb-usb/mxl111sf-tuner.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
rename to drivers/media/usb/dvb-usb/mxl111sf-tuner.c
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.h b/drivers/media/usb/dvb-usb/mxl111sf-tuner.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf-tuner.h
rename to drivers/media/usb/dvb-usb/mxl111sf-tuner.h
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf.c b/drivers/media/usb/dvb-usb/mxl111sf.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf.c
rename to drivers/media/usb/dvb-usb/mxl111sf.c
diff --git a/drivers/media/dvb/dvb-usb/mxl111sf.h b/drivers/media/usb/dvb-usb/mxl111sf.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/mxl111sf.h
rename to drivers/media/usb/dvb-usb/mxl111sf.h
diff --git a/drivers/media/dvb/dvb-usb/nova-t-usb2.c b/drivers/media/usb/dvb-usb/nova-t-usb2.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/nova-t-usb2.c
rename to drivers/media/usb/dvb-usb/nova-t-usb2.c
diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/usb/dvb-usb/opera1.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/opera1.c
rename to drivers/media/usb/dvb-usb/opera1.c
diff --git a/drivers/media/dvb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/pctv452e.c
rename to drivers/media/usb/dvb-usb/pctv452e.c
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/usb/dvb-usb/rtl28xxu.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/rtl28xxu.c
rename to drivers/media/usb/dvb-usb/rtl28xxu.c
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.h b/drivers/media/usb/dvb-usb/rtl28xxu.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/rtl28xxu.h
rename to drivers/media/usb/dvb-usb/rtl28xxu.h
diff --git a/drivers/media/dvb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/technisat-usb2.c
rename to drivers/media/usb/dvb-usb/technisat-usb2.c
diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/usb/dvb-usb/ttusb2.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/ttusb2.c
rename to drivers/media/usb/dvb-usb/ttusb2.c
diff --git a/drivers/media/dvb/dvb-usb/ttusb2.h b/drivers/media/usb/dvb-usb/ttusb2.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/ttusb2.h
rename to drivers/media/usb/dvb-usb/ttusb2.h
diff --git a/drivers/media/dvb/dvb-usb/umt-010.c b/drivers/media/usb/dvb-usb/umt-010.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/umt-010.c
rename to drivers/media/usb/dvb-usb/umt-010.c
diff --git a/drivers/media/dvb/dvb-usb/usb-urb.c b/drivers/media/usb/dvb-usb/usb-urb.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/usb-urb.c
rename to drivers/media/usb/dvb-usb/usb-urb.c
diff --git a/drivers/media/dvb/dvb-usb/vp702x-fe.c b/drivers/media/usb/dvb-usb/vp702x-fe.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/vp702x-fe.c
rename to drivers/media/usb/dvb-usb/vp702x-fe.c
diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/usb/dvb-usb/vp702x.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/vp702x.c
rename to drivers/media/usb/dvb-usb/vp702x.c
diff --git a/drivers/media/dvb/dvb-usb/vp702x.h b/drivers/media/usb/dvb-usb/vp702x.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/vp702x.h
rename to drivers/media/usb/dvb-usb/vp702x.h
diff --git a/drivers/media/dvb/dvb-usb/vp7045-fe.c b/drivers/media/usb/dvb-usb/vp7045-fe.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/vp7045-fe.c
rename to drivers/media/usb/dvb-usb/vp7045-fe.c
diff --git a/drivers/media/dvb/dvb-usb/vp7045.c b/drivers/media/usb/dvb-usb/vp7045.c
similarity index 100%
rename from drivers/media/dvb/dvb-usb/vp7045.c
rename to drivers/media/usb/dvb-usb/vp7045.c
diff --git a/drivers/media/dvb/dvb-usb/vp7045.h b/drivers/media/usb/dvb-usb/vp7045.h
similarity index 100%
rename from drivers/media/dvb/dvb-usb/vp7045.h
rename to drivers/media/usb/dvb-usb/vp7045.h
diff --git a/drivers/media/dvb/siano/Kconfig b/drivers/media/usb/siano/Kconfig
similarity index 100%
rename from drivers/media/dvb/siano/Kconfig
rename to drivers/media/usb/siano/Kconfig
diff --git a/drivers/media/dvb/siano/Makefile b/drivers/media/usb/siano/Makefile
similarity index 100%
rename from drivers/media/dvb/siano/Makefile
rename to drivers/media/usb/siano/Makefile
diff --git a/drivers/media/dvb/siano/sms-cards.c b/drivers/media/usb/siano/sms-cards.c
similarity index 100%
rename from drivers/media/dvb/siano/sms-cards.c
rename to drivers/media/usb/siano/sms-cards.c
diff --git a/drivers/media/dvb/siano/sms-cards.h b/drivers/media/usb/siano/sms-cards.h
similarity index 100%
rename from drivers/media/dvb/siano/sms-cards.h
rename to drivers/media/usb/siano/sms-cards.h
diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/usb/siano/smscoreapi.c
similarity index 100%
rename from drivers/media/dvb/siano/smscoreapi.c
rename to drivers/media/usb/siano/smscoreapi.c
diff --git a/drivers/media/dvb/siano/smscoreapi.h b/drivers/media/usb/siano/smscoreapi.h
similarity index 100%
rename from drivers/media/dvb/siano/smscoreapi.h
rename to drivers/media/usb/siano/smscoreapi.h
diff --git a/drivers/media/dvb/siano/smsdvb.c b/drivers/media/usb/siano/smsdvb.c
similarity index 100%
rename from drivers/media/dvb/siano/smsdvb.c
rename to drivers/media/usb/siano/smsdvb.c
diff --git a/drivers/media/dvb/siano/smsendian.c b/drivers/media/usb/siano/smsendian.c
similarity index 100%
rename from drivers/media/dvb/siano/smsendian.c
rename to drivers/media/usb/siano/smsendian.c
diff --git a/drivers/media/dvb/siano/smsendian.h b/drivers/media/usb/siano/smsendian.h
similarity index 100%
rename from drivers/media/dvb/siano/smsendian.h
rename to drivers/media/usb/siano/smsendian.h
diff --git a/drivers/media/dvb/siano/smsir.c b/drivers/media/usb/siano/smsir.c
similarity index 100%
rename from drivers/media/dvb/siano/smsir.c
rename to drivers/media/usb/siano/smsir.c
diff --git a/drivers/media/dvb/siano/smsir.h b/drivers/media/usb/siano/smsir.h
similarity index 100%
rename from drivers/media/dvb/siano/smsir.h
rename to drivers/media/usb/siano/smsir.h
diff --git a/drivers/media/dvb/siano/smssdio.c b/drivers/media/usb/siano/smssdio.c
similarity index 100%
rename from drivers/media/dvb/siano/smssdio.c
rename to drivers/media/usb/siano/smssdio.c
diff --git a/drivers/media/dvb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
similarity index 100%
rename from drivers/media/dvb/siano/smsusb.c
rename to drivers/media/usb/siano/smsusb.c
diff --git a/drivers/media/dvb/ttusb-budget/Kconfig b/drivers/media/usb/ttusb-budget/Kconfig
similarity index 100%
rename from drivers/media/dvb/ttusb-budget/Kconfig
rename to drivers/media/usb/ttusb-budget/Kconfig
diff --git a/drivers/media/dvb/ttusb-budget/Makefile b/drivers/media/usb/ttusb-budget/Makefile
similarity index 100%
rename from drivers/media/dvb/ttusb-budget/Makefile
rename to drivers/media/usb/ttusb-budget/Makefile
diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
similarity index 100%
rename from drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
rename to drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
diff --git a/drivers/media/dvb/ttusb-dec/Kconfig b/drivers/media/usb/ttusb-dec/Kconfig
similarity index 100%
rename from drivers/media/dvb/ttusb-dec/Kconfig
rename to drivers/media/usb/ttusb-dec/Kconfig
diff --git a/drivers/media/dvb/ttusb-dec/Makefile b/drivers/media/usb/ttusb-dec/Makefile
similarity index 100%
rename from drivers/media/dvb/ttusb-dec/Makefile
rename to drivers/media/usb/ttusb-dec/Makefile
diff --git a/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
similarity index 100%
rename from drivers/media/dvb/ttusb-dec/ttusb_dec.c
rename to drivers/media/usb/ttusb-dec/ttusb_dec.c
diff --git a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
similarity index 100%
rename from drivers/media/dvb/ttusb-dec/ttusbdecfe.c
rename to drivers/media/usb/ttusb-dec/ttusbdecfe.c
diff --git a/drivers/media/dvb/ttusb-dec/ttusbdecfe.h b/drivers/media/usb/ttusb-dec/ttusbdecfe.h
similarity index 100%
rename from drivers/media/dvb/ttusb-dec/ttusbdecfe.h
rename to drivers/media/usb/ttusb-dec/ttusbdecfe.h
diff --git a/drivers/media/video/cx231xx/Makefile b/drivers/media/video/cx231xx/Makefile
index 2697325..fe5706d 100644
--- a/drivers/media/video/cx231xx/Makefile
+++ b/drivers/media/video/cx231xx/Makefile
@@ -12,5 +12,5 @@ ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
-ccflags-y += -Idrivers/media/dvb/dvb-usb
+ccflags-y += -Idrivers/media/usb/dvb-usb
 
diff --git a/drivers/staging/media/go7007/Makefile b/drivers/staging/media/go7007/Makefile
index f654ddc..3fdbef5 100644
--- a/drivers/staging/media/go7007/Makefile
+++ b/drivers/staging/media/go7007/Makefile
@@ -24,7 +24,7 @@ s2250-y := s2250-board.o
 #ccflags-$(CONFIG_VIDEO_SAA7134:m=y) += -Idrivers/media/video/saa7134 -DSAA7134_MPEG_GO7007=3
 
 # S2250 needs cypress ezusb loader from dvb-usb
-ccflags-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD:m=y) += -Idrivers/media/dvb/dvb-usb
+ccflags-$(CONFIG_VIDEO_GO7007_USB_S2250_BOARD:m=y) += -Idrivers/media/usb/dvb-usb
 
 ccflags-y += -Idrivers/media/dvb-frontends
 ccflags-y += -Idrivers/media/dvb-core
-- 
1.7.10.2


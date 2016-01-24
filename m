Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout01.posteo.de ([185.67.36.65]:44095 "EHLO mout01.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbcAXO5J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 09:57:09 -0500
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 323F9209CC
	for <linux-media@vger.kernel.org>; Sun, 24 Jan 2016 15:57:05 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: linux-media@vger.kernel.org
Cc: Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH] media: change email address
Date: Sun, 24 Jan 2016 15:56:58 +0100
Message-Id: <1453647418-15555-1-git-send-email-patrick.boettcher@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Soon my dibcom.fr/parrot.com-address won't respond anymore.
Thus I'm replacing it. And, while being at it,
let's adapt some other (old) email-addresses as well.

Signed-off-by: Patrick Boettcher <patrick.boettcher@posteo.de>
---
 Documentation/dvb/README.dvb-usb              | 2 +-
 drivers/media/common/b2c2/flexcop.c           | 4 ++--
 drivers/media/common/cypress_firmware.c       | 2 +-
 drivers/media/common/cypress_firmware.h       | 2 +-
 drivers/media/dvb-core/dvb-usb-ids.h          | 2 +-
 drivers/media/dvb-frontends/bcm3510.c         | 4 ++--
 drivers/media/dvb-frontends/bcm3510.h         | 2 +-
 drivers/media/dvb-frontends/bcm3510_priv.h    | 2 +-
 drivers/media/dvb-frontends/dib0070.c         | 2 +-
 drivers/media/dvb-frontends/dib0090.c         | 4 ++--
 drivers/media/dvb-frontends/dib3000.h         | 6 +++---
 drivers/media/dvb-frontends/dib3000mb.c       | 8 ++++----
 drivers/media/dvb-frontends/dib3000mb_priv.h  | 2 +-
 drivers/media/dvb-frontends/dib3000mc.c       | 4 ++--
 drivers/media/dvb-frontends/dib3000mc.h       | 2 +-
 drivers/media/dvb-frontends/dib7000m.c        | 2 +-
 drivers/media/dvb-frontends/dib7000p.c        | 4 ++--
 drivers/media/dvb-frontends/dib8000.c         | 2 +-
 drivers/media/dvb-frontends/dib9000.c         | 4 ++--
 drivers/media/dvb-frontends/dibx000_common.c  | 2 +-
 drivers/media/pci/b2c2/flexcop-pci.c          | 2 +-
 drivers/media/usb/b2c2/flexcop-usb.c          | 2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h        | 2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_common.h | 2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c   | 4 ++--
 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c    | 2 +-
 drivers/media/usb/dvb-usb-v2/usb_urb.c        | 2 +-
 drivers/media/usb/dvb-usb/a800.c              | 4 ++--
 drivers/media/usb/dvb-usb/cxusb.c             | 4 ++--
 drivers/media/usb/dvb-usb/dib0700_core.c      | 2 +-
 drivers/media/usb/dvb-usb/dibusb-common.c     | 2 +-
 drivers/media/usb/dvb-usb/dibusb-mb.c         | 6 +++---
 drivers/media/usb/dvb-usb/dibusb-mc.c         | 6 +++---
 drivers/media/usb/dvb-usb/dibusb.h            | 2 +-
 drivers/media/usb/dvb-usb/digitv.c            | 4 ++--
 drivers/media/usb/dvb-usb/dtt200u-fe.c        | 2 +-
 drivers/media/usb/dvb-usb/dtt200u.c           | 4 ++--
 drivers/media/usb/dvb-usb/dtt200u.h           | 2 +-
 drivers/media/usb/dvb-usb/dvb-usb-common.h    | 2 +-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c       | 2 +-
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c  | 2 +-
 drivers/media/usb/dvb-usb/dvb-usb-i2c.c       | 2 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c      | 4 ++--
 drivers/media/usb/dvb-usb/dvb-usb-remote.c    | 2 +-
 drivers/media/usb/dvb-usb/dvb-usb-urb.c       | 2 +-
 drivers/media/usb/dvb-usb/dvb-usb.h           | 2 +-
 drivers/media/usb/dvb-usb/nova-t-usb2.c       | 4 ++--
 drivers/media/usb/dvb-usb/ttusb2.c            | 2 +-
 drivers/media/usb/dvb-usb/umt-010.c           | 4 ++--
 drivers/media/usb/dvb-usb/usb-urb.c           | 2 +-
 drivers/media/usb/dvb-usb/vp702x-fe.c         | 2 +-
 drivers/media/usb/dvb-usb/vp702x.c            | 4 ++--
 drivers/media/usb/dvb-usb/vp7045-fe.c         | 2 +-
 drivers/media/usb/dvb-usb/vp7045.c            | 4 ++--
 drivers/media/usb/dvb-usb/vp7045.h            | 2 +-
 55 files changed, 80 insertions(+), 80 deletions(-)

diff --git a/Documentation/dvb/README.dvb-usb b/Documentation/dvb/README.dvb-usb
index 669dc6c..6f4b12f7 100644
--- a/Documentation/dvb/README.dvb-usb
+++ b/Documentation/dvb/README.dvb-usb
@@ -190,7 +190,7 @@ and watch another one.
 Patches, comments and suggestions are very very welcome.
 
 3. Acknowledgements
-   Amaury Demol (ademol@dibcom.fr) and Francois Kanounnikoff from DiBcom for
+   Amaury Demol (Amaury.Demol@parrot.com) and Francois Kanounnikoff from DiBcom for
     providing specs, code and help, on which the dvb-dibusb, dib3000mb and
     dib3000mc are based.
 
diff --git a/drivers/media/common/b2c2/flexcop.c b/drivers/media/common/b2c2/flexcop.c
index 412c5da..0f5114d 100644
--- a/drivers/media/common/b2c2/flexcop.c
+++ b/drivers/media/common/b2c2/flexcop.c
@@ -1,7 +1,7 @@
 /*
  * Linux driver for digital TV devices equipped with B2C2 FlexcopII(b)/III
  * flexcop.c - main module part
- * Copyright (C) 2004-9 Patrick Boettcher <patrick.boettcher@desy.de>
+ * Copyright (C) 2004-9 Patrick Boettcher <patrick.boettcher@posteo.de>
  * based on skystar2-driver Copyright (C) 2003 Vadim Catana, skystar@moldova.cc
  *
  * Acknowledgements:
@@ -34,7 +34,7 @@
 #include "flexcop.h"
 
 #define DRIVER_NAME "B2C2 FlexcopII/II(b)/III digital TV receiver chip"
-#define DRIVER_AUTHOR "Patrick Boettcher <patrick.boettcher@desy.de"
+#define DRIVER_AUTHOR "Patrick Boettcher <patrick.boettcher@posteo.de"
 
 #ifdef CONFIG_DVB_B2C2_FLEXCOP_DEBUG
 #define DEBSTATUS ""
diff --git a/drivers/media/common/cypress_firmware.c b/drivers/media/common/cypress_firmware.c
index 577e820..50e3f76 100644
--- a/drivers/media/common/cypress_firmware.c
+++ b/drivers/media/common/cypress_firmware.c
@@ -1,6 +1,6 @@
 /*  cypress_firmware.c is part of the DVB USB library.
  *
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@posteo.de)
  * see dvb-usb-init.c for copyright information.
  *
  * This file contains functions for downloading the firmware to Cypress FX 1
diff --git a/drivers/media/common/cypress_firmware.h b/drivers/media/common/cypress_firmware.h
index e493cbc..1e4f273 100644
--- a/drivers/media/common/cypress_firmware.h
+++ b/drivers/media/common/cypress_firmware.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@posteo.de)
  * see dvb-usb-init.c for copyright information.
  *
  * This file contains functions for downloading the firmware to Cypress FX 1
diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 1c1c298..4745822 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -1,6 +1,6 @@
 /* dvb-usb-ids.h is part of the DVB USB library.
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de) see
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de) see
  * dvb-usb-init.c for copyright information.
  *
  * a header file containing define's for the USB device supported by the
diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
index d30275f..bb69883 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2001-5, B2C2 inc.
  *
- *  GPL/Linux driver written by Patrick Boettcher <patrick.boettcher@desy.de>
+ *  GPL/Linux driver written by Patrick Boettcher <patrick.boettcher@posteo.de>
  *
  *  This driver is "hard-coded" to be used with the 1st generation of
  *  Technisat/B2C2's Air2PC ATSC PCI/USB cards/boxes. The pll-programming
@@ -865,5 +865,5 @@ static struct dvb_frontend_ops bcm3510_ops = {
 };
 
 MODULE_DESCRIPTION("Broadcom BCM3510 ATSC (8VSB/16VSB & ITU J83 AnnexB FEC QAM64/256) demodulator driver");
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/bcm3510.h b/drivers/media/dvb-frontends/bcm3510.h
index ff66492..961c2eb 100644
--- a/drivers/media/dvb-frontends/bcm3510.h
+++ b/drivers/media/dvb-frontends/bcm3510.h
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2001-5, B2C2 inc.
  *
- *  GPL/Linux driver written by Patrick Boettcher <patrick.boettcher@desy.de>
+ *  GPL/Linux driver written by Patrick Boettcher <patrick.boettcher@posteo.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/dvb-frontends/bcm3510_priv.h b/drivers/media/dvb-frontends/bcm3510_priv.h
index 3bb1bc2..67f2468 100644
--- a/drivers/media/dvb-frontends/bcm3510_priv.h
+++ b/drivers/media/dvb-frontends/bcm3510_priv.h
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2001-5, B2C2 inc.
  *
- *  GPL/Linux driver written by Patrick Boettcher <patrick.boettcher@desy.de>
+ *  GPL/Linux driver written by Patrick Boettcher <patrick.boettcher@posteo.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/dvb-frontends/dib0070.c b/drivers/media/dvb-frontends/dib0070.c
index 0b8fb5d..ee7d669 100644
--- a/drivers/media/dvb-frontends/dib0070.c
+++ b/drivers/media/dvb-frontends/dib0070.c
@@ -774,6 +774,6 @@ free_mem:
 }
 EXPORT_SYMBOL(dib0070_attach);
 
-MODULE_AUTHOR("Patrick Boettcher <pboettcher@dibcom.fr>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for the DiBcom 0070 base-band RF Tuner");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index 47cb722..976ee03 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -2669,7 +2669,7 @@ free_mem:
 }
 EXPORT_SYMBOL(dib0090_fw_register);
 
-MODULE_AUTHOR("Patrick Boettcher <pboettcher@dibcom.fr>");
-MODULE_AUTHOR("Olivier Grenie <olivier.grenie@dibcom.fr>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
+MODULE_AUTHOR("Olivier Grenie <olivier.grenie@parrot.com>");
 MODULE_DESCRIPTION("Driver for the DiBcom 0090 base-band RF Tuner");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/dib3000.h b/drivers/media/dvb-frontends/dib3000.h
index 6ae9899..d5dfafb 100644
--- a/drivers/media/dvb-frontends/dib3000.h
+++ b/drivers/media/dvb-frontends/dib3000.h
@@ -2,11 +2,11 @@
  * public header file of the frontend drivers for mobile DVB-T demodulators
  * DiBcom 3000M-B and DiBcom 3000P/M-C (http://www.dibcom.fr/)
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  * based on GPL code from DibCom, which has
  *
- * Copyright (C) 2004 Amaury Demol for DiBcom (ademol@dibcom.fr)
+ * Copyright (C) 2004 Amaury Demol for DiBcom
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License as
@@ -14,7 +14,7 @@
  *
  * Acknowledgements
  *
- *  Amaury Demol (ademol@dibcom.fr) from DiBcom for providing specs and driver
+ *  Amaury Demol from DiBcom for providing specs and driver
  *  sources, on which this driver (and the dvb-dibusb) are based.
  *
  * see Documentation/dvb/README.dvb-usb for more information
diff --git a/drivers/media/dvb-frontends/dib3000mb.c b/drivers/media/dvb-frontends/dib3000mb.c
index 7a61172..3ca3009 100644
--- a/drivers/media/dvb-frontends/dib3000mb.c
+++ b/drivers/media/dvb-frontends/dib3000mb.c
@@ -2,11 +2,11 @@
  * Frontend driver for mobile DVB-T demodulator DiBcom 3000M-B
  * DiBcom (http://www.dibcom.fr/)
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  * based on GPL code from DibCom, which has
  *
- * Copyright (C) 2004 Amaury Demol for DiBcom (ademol@dibcom.fr)
+ * Copyright (C) 2004 Amaury Demol for DiBcom
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License as
@@ -14,7 +14,7 @@
  *
  * Acknowledgements
  *
- *  Amaury Demol (ademol@dibcom.fr) from DiBcom for providing specs and driver
+ *  Amaury Demol from DiBcom for providing specs and driver
  *  sources, on which this driver (and the dvb-dibusb) are based.
  *
  * see Documentation/dvb/README.dvb-usb for more information
@@ -36,7 +36,7 @@
 /* Version information */
 #define DRIVER_VERSION "0.1"
 #define DRIVER_DESC "DiBcom 3000M-B DVB-T demodulator"
-#define DRIVER_AUTHOR "Patrick Boettcher, patrick.boettcher@desy.de"
+#define DRIVER_AUTHOR "Patrick Boettcher, patrick.boettcher@posteo.de"
 
 static int debug;
 module_param(debug, int, 0644);
diff --git a/drivers/media/dvb-frontends/dib3000mb_priv.h b/drivers/media/dvb-frontends/dib3000mb_priv.h
index 9dc235a..0459d5c 100644
--- a/drivers/media/dvb-frontends/dib3000mb_priv.h
+++ b/drivers/media/dvb-frontends/dib3000mb_priv.h
@@ -1,7 +1,7 @@
 /*
  * dib3000mb_priv.h
  *
- * Copyright (C) 2004 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License as
diff --git a/drivers/media/dvb-frontends/dib3000mc.c b/drivers/media/dvb-frontends/dib3000mc.c
index 583d6b7..ac90ed3 100644
--- a/drivers/media/dvb-frontends/dib3000mc.c
+++ b/drivers/media/dvb-frontends/dib3000mc.c
@@ -2,7 +2,7 @@
  * Driver for DiBcom DiB3000MC/P-demodulator.
  *
  * Copyright (C) 2004-7 DiBcom (http://www.dibcom.fr/)
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  * This code is partially based on the previous dib3000mc.c .
  *
@@ -939,6 +939,6 @@ static struct dvb_frontend_ops dib3000mc_ops = {
 	.read_ucblocks        = dib3000mc_read_unc_blocks,
 };
 
-MODULE_AUTHOR("Patrick Boettcher <pboettcher@dibcom.fr>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for the DiBcom 3000MC/P COFDM demodulator");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/dib3000mc.h b/drivers/media/dvb-frontends/dib3000mc.h
index 74816f7..b37e69e 100644
--- a/drivers/media/dvb-frontends/dib3000mc.h
+++ b/drivers/media/dvb-frontends/dib3000mc.h
@@ -2,7 +2,7 @@
  * Driver for DiBcom DiB3000MC/P-demodulator.
  *
  * Copyright (C) 2004-6 DiBcom (http://www.dibcom.fr/)
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher\@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  * This code is partially based on the previous dib3000mc.c .
  *
diff --git a/drivers/media/dvb-frontends/dib7000m.c b/drivers/media/dvb-frontends/dib7000m.c
index 35eb71f..8b21ccc 100644
--- a/drivers/media/dvb-frontends/dib7000m.c
+++ b/drivers/media/dvb-frontends/dib7000m.c
@@ -1465,6 +1465,6 @@ static struct dvb_frontend_ops dib7000m_ops = {
 	.read_ucblocks        = dib7000m_read_unc_blocks,
 };
 
-MODULE_AUTHOR("Patrick Boettcher <pboettcher@dibcom.fr>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for the DiBcom 7000MA/MB/PA/PB/MC COFDM demodulator");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 33be5d6..65ab79e 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2834,7 +2834,7 @@ static struct dvb_frontend_ops dib7000p_ops = {
 	.read_ucblocks = dib7000p_read_unc_blocks,
 };
 
-MODULE_AUTHOR("Olivier Grenie <ogrenie@dibcom.fr>");
-MODULE_AUTHOR("Patrick Boettcher <pboettcher@dibcom.fr>");
+MODULE_AUTHOR("Olivier Grenie <olivie.grenie@parrot.com>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for the DiBcom 7000PC COFDM demodulator");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 94c2627..349d2f1 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -4516,6 +4516,6 @@ void *dib8000_attach(struct dib8000_ops *ops)
 }
 EXPORT_SYMBOL(dib8000_attach);
 
-MODULE_AUTHOR("Olivier Grenie <Olivier.Grenie@dibcom.fr, " "Patrick Boettcher <pboettcher@dibcom.fr>");
+MODULE_AUTHOR("Olivier Grenie <Olivier.Grenie@parrot.com, Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for the DiBcom 8000 ISDB-T demodulator");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
index 8f92aca..91888a2 100644
--- a/drivers/media/dvb-frontends/dib9000.c
+++ b/drivers/media/dvb-frontends/dib9000.c
@@ -2589,7 +2589,7 @@ static struct dvb_frontend_ops dib9000_ops = {
 	.read_ucblocks = dib9000_read_unc_blocks,
 };
 
-MODULE_AUTHOR("Patrick Boettcher <pboettcher@dibcom.fr>");
-MODULE_AUTHOR("Olivier Grenie <ogrenie@dibcom.fr>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
+MODULE_AUTHOR("Olivier Grenie <olivier.grenie@parrot.com>");
 MODULE_DESCRIPTION("Driver for the DiBcom 9000 COFDM demodulator");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/dibx000_common.c b/drivers/media/dvb-frontends/dibx000_common.c
index 43be723..723358d 100644
--- a/drivers/media/dvb-frontends/dibx000_common.c
+++ b/drivers/media/dvb-frontends/dibx000_common.c
@@ -510,6 +510,6 @@ u32 systime(void)
 }
 EXPORT_SYMBOL(systime);
 
-MODULE_AUTHOR("Patrick Boettcher <pboettcher@dibcom.fr>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Common function the DiBcom demodulator family");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/pci/b2c2/flexcop-pci.c b/drivers/media/pci/b2c2/flexcop-pci.c
index 8b5e0b3..4cac1fc 100644
--- a/drivers/media/pci/b2c2/flexcop-pci.c
+++ b/drivers/media/pci/b2c2/flexcop-pci.c
@@ -39,7 +39,7 @@ MODULE_PARM_DESC(debug,
 
 #define DRIVER_VERSION "0.1"
 #define DRIVER_NAME "flexcop-pci"
-#define DRIVER_AUTHOR "Patrick Boettcher <patrick.boettcher@desy.de>"
+#define DRIVER_AUTHOR "Patrick Boettcher <patrick.boettcher@posteo.de>"
 
 struct flexcop_pci {
 	struct pci_dev *pdev;
diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 0bd9690..d4bdba6 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -10,7 +10,7 @@
 /* Version information */
 #define DRIVER_VERSION "0.1"
 #define DRIVER_NAME "Technisat/B2C2 FlexCop II/IIb/III Digital TV USB Driver"
-#define DRIVER_AUTHOR "Patrick Boettcher <patrick.boettcher@desy.de>"
+#define DRIVER_AUTHOR "Patrick Boettcher <patrick.boettcher@posteo.de>"
 
 /* debug */
 #ifdef CONFIG_DVB_B2C2_FLEXCOP_DEBUG
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 023d91f..35f27e2e 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -1,7 +1,7 @@
 /*
  * DVB USB framework
  *
- * Copyright (C) 2004-6 Patrick Boettcher <patrick.boettcher@desy.de>
+ * Copyright (C) 2004-6 Patrick Boettcher <patrick.boettcher@posteo.de>
  * Copyright (C) 2012 Antti Palosaari <crope@iki.fi>
  *
  *    This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_common.h b/drivers/media/usb/dvb-usb-v2/dvb_usb_common.h
index 45f0709..a1622bd 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_common.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_common.h
@@ -1,7 +1,7 @@
 /*
  * DVB USB framework
  *
- * Copyright (C) 2004-6 Patrick Boettcher <patrick.boettcher@desy.de>
+ * Copyright (C) 2004-6 Patrick Boettcher <patrick.boettcher@posteo.de>
  * Copyright (C) 2012 Antti Palosaari <crope@iki.fi>
  *
  *    This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index f0565bf..5ec159f 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -1,7 +1,7 @@
 /*
  * DVB USB framework
  *
- * Copyright (C) 2004-6 Patrick Boettcher <patrick.boettcher@desy.de>
+ * Copyright (C) 2004-6 Patrick Boettcher <patrick.boettcher@posteo.de>
  * Copyright (C) 2012 Antti Palosaari <crope@iki.fi>
  *
  *    This program is free software; you can redistribute it and/or modify
@@ -1129,7 +1129,7 @@ int dvb_usbv2_reset_resume(struct usb_interface *intf)
 EXPORT_SYMBOL(dvb_usbv2_reset_resume);
 
 MODULE_VERSION("2.0");
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("DVB USB common");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
index 22bdce1..5bafeb6 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
@@ -1,7 +1,7 @@
 /*
  * DVB USB framework
  *
- * Copyright (C) 2004-6 Patrick Boettcher <patrick.boettcher@desy.de>
+ * Copyright (C) 2004-6 Patrick Boettcher <patrick.boettcher@posteo.de>
  * Copyright (C) 2012 Antti Palosaari <crope@iki.fi>
  *
  *    This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/usb/dvb-usb-v2/usb_urb.c b/drivers/media/usb/dvb-usb-v2/usb_urb.c
index ca8f3c2..55136cd 100644
--- a/drivers/media/usb/dvb-usb-v2/usb_urb.c
+++ b/drivers/media/usb/dvb-usb-v2/usb_urb.c
@@ -1,6 +1,6 @@
 /* usb-urb.c is part of the DVB USB library.
  *
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@posteo.de)
  * see dvb-usb-init.c for copyright information.
  *
  * This file keeps functions for initializing and handling the
diff --git a/drivers/media/usb/dvb-usb/a800.c b/drivers/media/usb/dvb-usb/a800.c
index 83684ed..7ba975b 100644
--- a/drivers/media/usb/dvb-usb/a800.c
+++ b/drivers/media/usb/dvb-usb/a800.c
@@ -1,7 +1,7 @@
 /* DVB USB framework compliant Linux driver for the AVerMedia AverTV DVB-T
  * USB2.0 (A800) DVB-T receiver.
  *
- * Copyright (C) 2005 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2005 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  * Thanks to
  *   - AVerMedia who kindly provided information and
@@ -185,7 +185,7 @@ static struct usb_driver a800_driver = {
 
 module_usb_driver(a800_driver);
 
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("AVerMedia AverTV DVB-T USB 2.0 (A800)");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index ab71511..907ac01 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -13,7 +13,7 @@
  *
  * TODO: Use the cx25840-driver for the analogue part
  *
- * Copyright (C) 2005 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2005 Patrick Boettcher (patrick.boettcher@posteo.de)
  * Copyright (C) 2006 Michael Krufky (mkrufky@linuxtv.org)
  * Copyright (C) 2006, 2007 Chris Pascoe (c.pascoe@itee.uq.edu.au)
  *
@@ -2314,7 +2314,7 @@ static struct usb_driver cxusb_driver = {
 
 module_usb_driver(cxusb_driver);
 
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_AUTHOR("Michael Krufky <mkrufky@linuxtv.org>");
 MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
 MODULE_DESCRIPTION("Driver for Conexant USB2.0 hybrid reference design");
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 0d248ce..c16f999 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -881,7 +881,7 @@ static struct usb_driver dib0700_driver = {
 module_usb_driver(dib0700_driver);
 
 MODULE_FIRMWARE("dvb-usb-dib0700-1.20.fw");
-MODULE_AUTHOR("Patrick Boettcher <pboettcher@dibcom.fr>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for devices based on DiBcom DiB0700 - USB bridge");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index ef3a8f7..35de609 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -1,6 +1,6 @@
 /* Common methods for dibusb-based-receivers.
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  *	This program is free software; you can redistribute it and/or modify it
  *	under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/media/usb/dvb-usb/dibusb-mb.c b/drivers/media/usb/dvb-usb/dibusb-mb.c
index a4ac37e..a005764 100644
--- a/drivers/media/usb/dvb-usb/dibusb-mb.c
+++ b/drivers/media/usb/dvb-usb/dibusb-mb.c
@@ -1,10 +1,10 @@
 /* DVB USB compliant linux driver for mobile DVB-T USB devices based on
  * reference designs made by DiBcom (http://www.dibcom.fr/) (DiB3000M-B)
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  * based on GPL code from DiBcom, which has
- * Copyright (C) 2004 Amaury Demol for DiBcom (ademol@dibcom.fr)
+ * Copyright (C) 2004 Amaury Demol for DiBcom
  *
  *	This program is free software; you can redistribute it and/or modify it
  *	under the terms of the GNU General Public License as published by the Free
@@ -465,7 +465,7 @@ static struct usb_driver dibusb_driver = {
 
 module_usb_driver(dibusb_driver);
 
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for DiBcom USB DVB-T devices (DiB3000M-B based)");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/dibusb-mc.c b/drivers/media/usb/dvb-usb/dibusb-mc.c
index 9d1a59d0..08fb8a3 100644
--- a/drivers/media/usb/dvb-usb/dibusb-mc.c
+++ b/drivers/media/usb/dvb-usb/dibusb-mc.c
@@ -1,10 +1,10 @@
 /* DVB USB compliant linux driver for mobile DVB-T USB devices based on
  * reference designs made by DiBcom (http://www.dibcom.fr/) (DiB3000M-C/P)
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  * based on GPL code from DiBcom, which has
- * Copyright (C) 2004 Amaury Demol for DiBcom (ademol@dibcom.fr)
+ * Copyright (C) 2004 Amaury Demol for DiBcom
  *
  *	This program is free software; you can redistribute it and/or modify it
  *	under the terms of the GNU General Public License as published by the Free
@@ -143,7 +143,7 @@ static struct usb_driver dibusb_mc_driver = {
 
 module_usb_driver(dibusb_mc_driver);
 
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for DiBcom USB2.0 DVB-T (DiB3000M-C/P based) devices");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/dibusb.h b/drivers/media/usb/dvb-usb/dibusb.h
index 32ab139..3f82163 100644
--- a/drivers/media/usb/dvb-usb/dibusb.h
+++ b/drivers/media/usb/dvb-usb/dibusb.h
@@ -1,6 +1,6 @@
 /* Header file for all dibusb-based-receivers.
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  *	This program is free software; you can redistribute it and/or modify it
  *	under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/media/usb/dvb-usb/digitv.c b/drivers/media/usb/dvb-usb/digitv.c
index 772bde3..6313433 100644
--- a/drivers/media/usb/dvb-usb/digitv.c
+++ b/drivers/media/usb/dvb-usb/digitv.c
@@ -1,7 +1,7 @@
 /* DVB USB compliant linux driver for Nebula Electronics uDigiTV DVB-T USB2.0
  * receiver
  *
- * Copyright (C) 2005 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2005 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  * partly based on the SDK published by Nebula Electronics
  *
@@ -348,7 +348,7 @@ static struct usb_driver digitv_driver = {
 
 module_usb_driver(digitv_driver);
 
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for Nebula Electronics uDigiTV DVB-T USB2.0");
 MODULE_VERSION("1.0-alpha");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/dtt200u-fe.c b/drivers/media/usb/dvb-usb/dtt200u-fe.c
index 8637ad1..7e72a1b 100644
--- a/drivers/media/usb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/usb/dvb-usb/dtt200u-fe.c
@@ -1,7 +1,7 @@
 /* Frontend part of the Linux driver for the WideView/ Yakumo/ Hama/
  * Typhoon/ Yuan DVB-T USB2.0 receiver.
  *
- * Copyright (C) 2005 Patrick Boettcher <patrick.boettcher@desy.de>
+ * Copyright (C) 2005 Patrick Boettcher <patrick.boettcher@posteo.de>
  *
  *	This program is free software; you can redistribute it and/or modify it
  *	under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c
index c357fb3..ca3b69a 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.c
+++ b/drivers/media/usb/dvb-usb/dtt200u.c
@@ -1,7 +1,7 @@
 /* DVB USB library compliant Linux driver for the WideView/ Yakumo/ Hama/
  * Typhoon/ Yuan/ Miglia DVB-T USB2.0 receiver.
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  * Thanks to Steve Chang from WideView for providing support for the WT-220U.
  *
@@ -362,7 +362,7 @@ static struct usb_driver dtt200u_usb_driver = {
 
 module_usb_driver(dtt200u_usb_driver);
 
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for the WideView/Yakumo/Hama/Typhoon/Club3D/Miglia DVB-T USB2.0 devices");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/dtt200u.h b/drivers/media/usb/dvb-usb/dtt200u.h
index 005b0a7..efccc39 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.h
+++ b/drivers/media/usb/dvb-usb/dtt200u.h
@@ -1,7 +1,7 @@
 /* Common header file of Linux driver for the WideView/ Yakumo/ Hama/
  * Typhoon/ Yuan DVB-T USB2.0 receiver.
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  *	This program is free software; you can redistribute it and/or modify it
  *	under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-common.h b/drivers/media/usb/dvb-usb/dvb-usb-common.h
index 6b7b2a8..7e619d6 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-common.h
+++ b/drivers/media/usb/dvb-usb/dvb-usb-common.h
@@ -1,6 +1,6 @@
 /* dvb-usb-common.h is part of the DVB USB library.
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  * see dvb-usb-init.c for copyright information.
  *
  * a header file containing prototypes and types for internal use of the dvb-usb-lib
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 9ddfcab..71de19b 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -1,6 +1,6 @@
 /* dvb-usb-dvb.c is part of the DVB USB library.
  *
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@posteo.de)
  * see dvb-usb-init.c for copyright information.
  *
  * This file contains functions for initializing and handling the
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
index 733a7ff..dd048a7 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
@@ -1,6 +1,6 @@
 /* dvb-usb-firmware.c is part of the DVB USB library.
  *
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@posteo.de)
  * see dvb-usb-init.c for copyright information.
  *
  * This file contains functions for downloading the firmware to Cypress FX 1 and 2 based devices.
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-i2c.c b/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
index 88e4a62..4f0b0ad 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
@@ -1,6 +1,6 @@
 /* dvb-usb-i2c.c is part of the DVB USB library.
  *
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@posteo.de)
  * see dvb-usb-init.c for copyright information.
  *
  * This file contains functions for (de-)initializing an I2C adapter.
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index 1adf325..3896ba9 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -3,7 +3,7 @@
  *
  * dvb-usb-init.c
  *
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  *	This program is free software; you can redistribute it and/or modify it
  *	under the terms of the GNU General Public License as published by the Free
@@ -299,6 +299,6 @@ void dvb_usb_device_exit(struct usb_interface *intf)
 EXPORT_SYMBOL(dvb_usb_device_exit);
 
 MODULE_VERSION("1.0");
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("A library module containing commonly used USB and DVB function USB DVB devices");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-remote.c b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
index 7b5dae3..c259f9e 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
@@ -1,6 +1,6 @@
 /* dvb-usb-remote.c is part of the DVB USB library.
  *
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@posteo.de)
  * see dvb-usb-init.c for copyright information.
  *
  * This file contains functions for initializing the input-device and for handling remote-control-queries.
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-urb.c b/drivers/media/usb/dvb-usb/dvb-usb-urb.c
index 5c8f651..95f9097 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-urb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-urb.c
@@ -1,6 +1,6 @@
 /* dvb-usb-urb.c is part of the DVB USB library.
  *
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@posteo.de)
  * see dvb-usb-init.c for copyright information.
  *
  * This file keeps functions for initializing and handling the
diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
index ce4c4e3..639c467 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb.h
+++ b/drivers/media/usb/dvb-usb/dvb-usb.h
@@ -1,6 +1,6 @@
 /* dvb-usb.h is part of the DVB USB library.
  *
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@posteo.de)
  * see dvb-usb-init.c for copyright information.
  *
  * the headerfile, all dvb-usb-drivers have to include.
diff --git a/drivers/media/usb/dvb-usb/nova-t-usb2.c b/drivers/media/usb/dvb-usb/nova-t-usb2.c
index 6c55384..fc7569e 100644
--- a/drivers/media/usb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/usb/dvb-usb/nova-t-usb2.c
@@ -1,7 +1,7 @@
 /* DVB USB framework compliant Linux driver for the Hauppauge WinTV-NOVA-T usb2
  * DVB-T receiver.
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  *	This program is free software; you can redistribute it and/or modify it
  *	under the terms of the GNU General Public License as published by the Free
@@ -227,7 +227,7 @@ static struct usb_driver nova_t_driver = {
 
 module_usb_driver(nova_t_driver);
 
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Hauppauge WinTV-NOVA-T usb2");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/ttusb2.c b/drivers/media/usb/dvb-usb/ttusb2.c
index f107173..ecc207f 100644
--- a/drivers/media/usb/dvb-usb/ttusb2.c
+++ b/drivers/media/usb/dvb-usb/ttusb2.c
@@ -820,7 +820,7 @@ static struct usb_driver ttusb2_driver = {
 
 module_usb_driver(ttusb2_driver);
 
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for Pinnacle PCTV 400e DVB-S USB2.0");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/umt-010.c b/drivers/media/usb/dvb-usb/umt-010.c
index 9b04229..58ad5b4 100644
--- a/drivers/media/usb/dvb-usb/umt-010.c
+++ b/drivers/media/usb/dvb-usb/umt-010.c
@@ -1,7 +1,7 @@
 /* DVB USB framework compliant Linux driver for the HanfTek UMT-010 USB2.0
  * DVB-T receiver.
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  *	This program is free software; you can redistribute it and/or modify it
  *	under the terms of the GNU General Public License as published by the Free
@@ -145,7 +145,7 @@ static struct usb_driver umt_driver = {
 
 module_usb_driver(umt_driver);
 
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for HanfTek UMT 010 USB2.0 DVB-T device");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/usb-urb.c b/drivers/media/usb/dvb-usb/usb-urb.c
index d62ee0f..8917360 100644
--- a/drivers/media/usb/dvb-usb/usb-urb.c
+++ b/drivers/media/usb/dvb-usb/usb-urb.c
@@ -1,6 +1,6 @@
 /* usb-urb.c is part of the DVB USB library.
  *
- * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-6 Patrick Boettcher (patrick.boettcher@posteo.de)
  * see dvb-usb-init.c for copyright information.
  *
  * This file keeps functions for initializing and handling the
diff --git a/drivers/media/usb/dvb-usb/vp702x-fe.c b/drivers/media/usb/dvb-usb/vp702x-fe.c
index d361a72..27398c0 100644
--- a/drivers/media/usb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/usb/dvb-usb/vp702x-fe.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2005 Ralph Metzler <rjkm@metzlerbros.de>
  *                    Metzler Brothers Systementwicklung GbR
  *
- * Copyright (C) 2005 Patrick Boettcher <patrick.boettcher@desy.de>
+ * Copyright (C) 2005 Patrick Boettcher <patrick.boettcher@posteo.de>
  *
  * Thanks to Twinhan who kindly provided hardware and information.
  *
diff --git a/drivers/media/usb/dvb-usb/vp702x.c b/drivers/media/usb/dvb-usb/vp702x.c
index ee1e19e..40de33d 100644
--- a/drivers/media/usb/dvb-usb/vp702x.c
+++ b/drivers/media/usb/dvb-usb/vp702x.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2005 Ralph Metzler <rjkm@metzlerbros.de>
  *                    Metzler Brothers Systementwicklung GbR
  *
- * Copyright (C) 2005 Patrick Boettcher <patrick.boettcher@desy.de>
+ * Copyright (C) 2005 Patrick Boettcher <patrick.boettcher@posteo.de>
  *
  * Thanks to Twinhan who kindly provided hardware and information.
  *
@@ -439,7 +439,7 @@ static struct usb_driver vp702x_usb_driver = {
 
 module_usb_driver(vp702x_usb_driver);
 
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for Twinhan StarBox DVB-S USB2.0 and clones");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/vp7045-fe.c b/drivers/media/usb/dvb-usb/vp7045-fe.c
index e708afc..7765602 100644
--- a/drivers/media/usb/dvb-usb/vp7045-fe.c
+++ b/drivers/media/usb/dvb-usb/vp7045-fe.c
@@ -1,7 +1,7 @@
 /* DVB frontend part of the Linux driver for TwinhanDTV Alpha/MagicBoxII USB2.0
  * DVB-T receiver.
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  * Thanks to Twinhan who kindly provided hardware and information.
  *
diff --git a/drivers/media/usb/dvb-usb/vp7045.c b/drivers/media/usb/dvb-usb/vp7045.c
index d750724..13340af 100644
--- a/drivers/media/usb/dvb-usb/vp7045.c
+++ b/drivers/media/usb/dvb-usb/vp7045.c
@@ -2,7 +2,7 @@
  *  - TwinhanDTV Alpha/MagicBoxII USB2.0 DVB-T receiver
  *  - DigitalNow TinyUSB2 DVB-t receiver
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  * Thanks to Twinhan who kindly provided hardware and information.
  *
@@ -296,7 +296,7 @@ static struct usb_driver vp7045_usb_driver = {
 
 module_usb_driver(vp7045_usb_driver);
 
-MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
+MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@posteo.de>");
 MODULE_DESCRIPTION("Driver for Twinhan MagicBox/Alpha and DNTV tinyUSB2 DVB-T USB2.0");
 MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/vp7045.h b/drivers/media/usb/dvb-usb/vp7045.h
index cf5ec46..6649993 100644
--- a/drivers/media/usb/dvb-usb/vp7045.h
+++ b/drivers/media/usb/dvb-usb/vp7045.h
@@ -1,7 +1,7 @@
 /* Common header-file of the Linux driver for the TwinhanDTV Alpha/MagicBoxII
  * USB2.0 DVB-T receiver.
  *
- * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@posteo.de)
  *
  * Thanks to Twinhan who kindly provided hardware and information.
  *
-- 
2.7.0.rc3


Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44250 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab2EWJtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:49:50 -0400
Subject: [PATCH 02/43] rc-core: add separate defines for protocol bitmaps and
 numbers
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:42:11 +0200
Message-ID: <20120523094210.14474.16678.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RC_TYPE_* defines are currently used both where a single protocol is
expected and where a bitmap of protocols is expected. This patch tries
to separate the two in preparation for the following patches.

The intended use is also clearer to anyone reading the code. Where a
single protocol is expected, enum rc_type is used, where one or more
protocol(s) are expected, something like u64 is used.

The format of the sysfs "protocols" file is slightly changed by
this patch, but it should still accept the same protocol names
as before, it's only the output that is more specific.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/dvb/dvb-usb/af9015.c             |   12 +-
 drivers/media/dvb/dvb-usb/af9035.c             |    4 -
 drivers/media/dvb/dvb-usb/anysee.c             |    2 
 drivers/media/dvb/dvb-usb/az6007.c             |    2 
 drivers/media/dvb/dvb-usb/dib0700_core.c       |    9 +
 drivers/media/dvb/dvb-usb/dib0700_devices.c    |  146 ++++++++++++------------
 drivers/media/dvb/dvb-usb/it913x.c             |    4 -
 drivers/media/dvb/dvb-usb/lmedm04.c            |    8 +
 drivers/media/dvb/dvb-usb/pctv452e.c           |    4 -
 drivers/media/dvb/dvb-usb/rtl28xxu.c           |    8 +
 drivers/media/dvb/dvb-usb/technisat-usb2.c     |    2 
 drivers/media/dvb/dvb-usb/ttusb2.c             |    2 
 drivers/media/dvb/mantis/mantis_input.c        |    2 
 drivers/media/dvb/siano/smsir.c                |    2 
 drivers/media/rc/ati_remote.c                  |    2 
 drivers/media/rc/ene_ir.c                      |    2 
 drivers/media/rc/fintek-cir.c                  |    2 
 drivers/media/rc/gpio-ir-recv.c                |    2 
 drivers/media/rc/imon.c                        |   27 ++--
 drivers/media/rc/ir-jvc-decoder.c              |    4 -
 drivers/media/rc/ir-lirc-codec.c               |    4 -
 drivers/media/rc/ir-mce_kbd-decoder.c          |    4 -
 drivers/media/rc/ir-nec-decoder.c              |    4 -
 drivers/media/rc/ir-rc5-decoder.c              |   14 ++
 drivers/media/rc/ir-rc5-sz-decoder.c           |    6 -
 drivers/media/rc/ir-rc6-decoder.c              |    8 +
 drivers/media/rc/ir-sanyo-decoder.c            |    4 -
 drivers/media/rc/ir-sony-decoder.c             |   17 ++-
 drivers/media/rc/ite-cir.c                     |    2 
 drivers/media/rc/keymaps/rc-imon-mce.c         |    2 
 drivers/media/rc/keymaps/rc-rc6-mce.c          |    2 
 drivers/media/rc/mceusb.c                      |    2 
 drivers/media/rc/nuvoton-cir.c                 |    2 
 drivers/media/rc/rc-loopback.c                 |    2 
 drivers/media/rc/rc-main.c                     |   79 ++++++++-----
 drivers/media/rc/redrat3.c                     |    2 
 drivers/media/rc/streamzap.c                   |    2 
 drivers/media/video/cx18/cx18-i2c.c            |    2 
 drivers/media/video/cx231xx/cx231xx-input.c    |    2 
 drivers/media/video/cx23885/cx23885-input.c    |    4 -
 drivers/media/video/cx88/cx88-input.c          |    8 +
 drivers/media/video/em28xx/em28xx-input.c      |   10 +-
 drivers/media/video/hdpvr/hdpvr-i2c.c          |    2 
 drivers/media/video/ir-kbd-i2c.c               |   14 +-
 drivers/media/video/ivtv/ivtv-i2c.c            |    8 +
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |    4 -
 drivers/media/video/saa7134/saa7134-input.c    |    2 
 drivers/media/video/tm6000/tm6000-input.c      |   16 +--
 include/media/ir-kbd-i2c.h                     |    2 
 include/media/rc-core.h                        |    2 
 include/media/rc-map.h                         |   64 ++++++++---
 51 files changed, 308 insertions(+), 234 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 677fed7..5395c6a 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1576,11 +1576,11 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.identify_state = af9015_identify_state,
 
 		.rc.core = {
-			.protocol         = RC_TYPE_NEC,
+			.protocol         = RC_BIT_NEC,
 			.module_name      = "af9015",
 			.rc_query         = af9015_rc_query,
 			.rc_interval      = AF9015_RC_INTERVAL,
-			.allowed_protos   = RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_NEC,
 		},
 
 		.i2c_algo = &af9015_i2c_algo,
@@ -1712,11 +1712,11 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.identify_state = af9015_identify_state,
 
 		.rc.core = {
-			.protocol         = RC_TYPE_NEC,
+			.protocol         = RC_BIT_NEC,
 			.module_name      = "af9015",
 			.rc_query         = af9015_rc_query,
 			.rc_interval      = AF9015_RC_INTERVAL,
-			.allowed_protos   = RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_NEC,
 		},
 
 		.i2c_algo = &af9015_i2c_algo,
@@ -1837,11 +1837,11 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 		.identify_state = af9015_identify_state,
 
 		.rc.core = {
-			.protocol         = RC_TYPE_NEC,
+			.protocol         = RC_BIT_NEC,
 			.module_name      = "af9015",
 			.rc_query         = af9015_rc_query,
 			.rc_interval      = AF9015_RC_INTERVAL,
-			.allowed_protos   = RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_NEC,
 		},
 
 		.i2c_algo = &af9015_i2c_algo,
diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
index e83b39d..d7c7c17 100644
--- a/drivers/media/dvb/dvb-usb/af9035.c
+++ b/drivers/media/dvb/dvb-usb/af9035.c
@@ -666,8 +666,8 @@ static int af9035_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
 			d->props.rc.core.allowed_protos = RC_TYPE_NEC;
 			break;
 		case 1: /* RC6 */
-			d->props.rc.core.protocol = RC_TYPE_RC6;
-			d->props.rc.core.allowed_protos = RC_TYPE_RC6;
+			d->props.rc.core.protocol = RC_TYPE_RC6_MCE;
+			d->props.rc.core.allowed_protos = RC_TYPE_RC6_MCE;
 			break;
 		}
 		d->props.rc.core.rc_query = af9035_rc_query;
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index 03c2865..f510f91 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -1371,7 +1371,7 @@ static struct dvb_usb_device_properties anysee_properties = {
 
 	.rc.core = {
 		.rc_codes         = RC_MAP_ANYSEE,
-		.protocol         = RC_TYPE_OTHER,
+		.protocol         = RC_BIT_OTHER,
 		.module_name      = "anysee",
 		.rc_query         = anysee_rc_query,
 		.rc_interval      = 250,  /* windows driver uses 500ms */
diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 4008b9c..102114e 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -899,7 +899,7 @@ static struct dvb_usb_device_properties az6007_properties = {
 		.rc_codes         = RC_MAP_NEC_TERRATEC_CINERGY_XS,
 		.module_name	  = "az6007",
 		.rc_query         = az6007_rc_query,
-		.allowed_protos   = RC_TYPE_NEC,
+		.allowed_protos   = RC_BIT_NEC,
 	},
 	.i2c_algo         = &az6007_i2c_algo,
 
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 7e9e00f..192d805 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -621,16 +621,15 @@ int dib0700_change_protocol(struct rc_dev *rc, u64 rc_type)
 	st->buf[2] = 0;
 
 	/* Set the IR mode */
-	if (rc_type == RC_TYPE_RC5)
+	if (rc_type == RC_BIT_RC5)
 		new_proto = 1;
-	else if (rc_type == RC_TYPE_NEC)
+	else if (rc_type == RC_BIT_NEC)
 		new_proto = 0;
-	else if (rc_type == RC_TYPE_RC6) {
+	else if (rc_type == RC_BIT_RC6_MCE) {
 		if (st->fw_version < 0x10200) {
 			ret = -EINVAL;
 			goto out;
 		}
-
 		new_proto = 2;
 	} else {
 		ret = -EINVAL;
@@ -707,7 +706,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		 purb->actual_length);
 
 	switch (d->props.rc.core.protocol) {
-	case RC_TYPE_NEC:
+	case RC_BIT_NEC:
 		toggle = 0;
 
 		/* NEC protocol sends repeat code as 0 0 0 FF */
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 510001d..1179842 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -518,7 +518,7 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 
 	d->last_event = 0;
 	switch (d->props.rc.core.protocol) {
-	case RC_TYPE_NEC:
+	case RC_BIT_NEC:
 		/* NEC protocol sends repeat code as 0 0 0 FF */
 		if ((key[3-2] == 0x00) && (key[3-3] == 0x00) &&
 		    (key[3] == 0xff))
@@ -3658,9 +3658,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3698,9 +3698,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3763,9 +3763,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3808,9 +3808,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3890,9 +3890,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3936,9 +3936,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -3987,9 +3987,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4055,9 +4055,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4106,9 +4106,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4177,9 +4177,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4215,9 +4215,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4295,9 +4295,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4341,9 +4341,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4394,9 +4394,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4433,9 +4433,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4472,9 +4472,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4511,9 +4511,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4550,9 +4550,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4589,9 +4589,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4644,9 +4644,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4681,9 +4681,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4721,9 +4721,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4761,9 +4761,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
@@ -4802,9 +4802,9 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
 			.module_name	  = "dib0700",
 			.rc_query         = dib0700_rc_query_old_firmware,
-			.allowed_protos   = RC_TYPE_RC5 |
-					    RC_TYPE_RC6 |
-					    RC_TYPE_NEC,
+			.allowed_protos   = RC_BIT_RC5 |
+					    RC_BIT_RC6_MCE |
+					    RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
 	},
diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 6244fe9..e54f3dc 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -888,11 +888,11 @@ static struct dvb_usb_device_properties it913x_properties = {
 	},
 	.identify_state   = it913x_identify_state,
 	.rc.core = {
-		.protocol	= RC_TYPE_NEC,
+		.protocol	= RC_BIT_NEC,
 		.module_name	= "it913x",
 		.rc_query	= it913x_rc_query,
 		.rc_interval	= IT913X_POLL,
-		.allowed_protos	= RC_TYPE_NEC,
+		.allowed_protos	= RC_BIT_NEC,
 		.rc_codes	= RC_MAP_IT913X_V1,
 	},
 	.i2c_algo         = &it913x_i2c_algo,
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 25d1031..8ff161e 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -1279,9 +1279,9 @@ static struct dvb_usb_device_properties lme2510_properties = {
 		}
 	},
 	.rc.core = {
-		.protocol	= RC_TYPE_NEC,
+		.protocol	= RC_BIT_NEC,
 		.module_name	= "LME2510 Remote Control",
-		.allowed_protos	= RC_TYPE_NEC,
+		.allowed_protos	= RC_BIT_NEC,
 		.rc_codes	= RC_MAP_LME2510,
 	},
 	.power_ctrl       = lme2510_powerup,
@@ -1330,9 +1330,9 @@ static struct dvb_usb_device_properties lme2510c_properties = {
 		}
 	},
 	.rc.core = {
-		.protocol	= RC_TYPE_NEC,
+		.protocol	= RC_BIT_NEC,
 		.module_name	= "LME2510 Remote Control",
-		.allowed_protos	= RC_TYPE_NEC,
+		.allowed_protos	= RC_BIT_NEC,
 		.rc_codes	= RC_MAP_LME2510,
 	},
 	.power_ctrl       = lme2510_powerup,
diff --git a/drivers/media/dvb/dvb-usb/pctv452e.c b/drivers/media/dvb/dvb-usb/pctv452e.c
index f526eb0..6eefd4e 100644
--- a/drivers/media/dvb/dvb-usb/pctv452e.c
+++ b/drivers/media/dvb/dvb-usb/pctv452e.c
@@ -928,7 +928,7 @@ static struct dvb_usb_device_properties pctv452e_properties = {
 
 	.rc.core = {
 		.rc_codes	= RC_MAP_DIB0700_RC5_TABLE,
-		.allowed_protos	= RC_TYPE_UNKNOWN,
+		.allowed_protos	= RC_BIT_UNKNOWN,
 		.rc_query	= pctv452e_rc_query,
 		.rc_interval	= 100,
 	},
@@ -981,7 +981,7 @@ static struct dvb_usb_device_properties tt_connect_s2_3600_properties = {
 
 	.rc.core = {
 		.rc_codes	= RC_MAP_TT_1500,
-		.allowed_protos	= RC_TYPE_UNKNOWN,
+		.allowed_protos	= RC_BIT_UNKNOWN,
 		.rc_query	= pctv452e_rc_query,
 		.rc_interval	= 100,
 	},
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index 41e1f55..1abd247 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -824,11 +824,11 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 		.power_ctrl = rtl28xxu_power_ctrl,
 
 		.rc.core = {
-			.protocol       = RC_TYPE_NEC,
+			.protocol       = RC_BIT_NEC,
 			.module_name    = "rtl28xxu",
 			.rc_query       = rtl2831u_rc_query,
 			.rc_interval    = 400,
-			.allowed_protos = RC_TYPE_NEC,
+			.allowed_protos = RC_BIT_NEC,
 			.rc_codes       = RC_MAP_EMPTY,
 		},
 
@@ -886,11 +886,11 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 		.power_ctrl = rtl28xxu_power_ctrl,
 
 		.rc.core = {
-			.protocol       = RC_TYPE_NEC,
+			.protocol       = RC_BIT_NEC,
 			.module_name    = "rtl28xxu",
 			.rc_query       = rtl2832u_rc_query,
 			.rc_interval    = 400,
-			.allowed_protos = RC_TYPE_NEC,
+			.allowed_protos = RC_BIT_NEC,
 			.rc_codes       = RC_MAP_EMPTY,
 		},
 
diff --git a/drivers/media/dvb/dvb-usb/technisat-usb2.c b/drivers/media/dvb/dvb-usb/technisat-usb2.c
index acefaa8..3b8752a 100644
--- a/drivers/media/dvb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/dvb/dvb-usb/technisat-usb2.c
@@ -731,7 +731,7 @@ static struct dvb_usb_device_properties technisat_usb2_devices = {
 		.rc_codes    = RC_MAP_TECHNISAT_USB2,
 		.module_name = "technisat-usb2",
 		.rc_query    = technisat_usb2_rc_query,
-		.allowed_protos = RC_TYPE_ALL,
+		.allowed_protos = RC_BIT_ALL,
 		.driver_type    = RC_DRIVER_IR_RAW,
 	}
 };
diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
index e53a106..c5be462 100644
--- a/drivers/media/dvb/dvb-usb/ttusb2.c
+++ b/drivers/media/dvb/dvb-usb/ttusb2.c
@@ -741,7 +741,7 @@ static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
 		.rc_interval      = 150, /* Less than IR_KEYPRESS_TIMEOUT */
 		.rc_codes         = RC_MAP_TT_1500,
 		.rc_query         = tt3650_rc_query,
-		.allowed_protos   = RC_TYPE_UNKNOWN,
+		.allowed_protos   = RC_BIT_UNKNOWN,
 	},
 
 	.num_adapters = 1,
diff --git a/drivers/media/dvb/mantis/mantis_input.c b/drivers/media/dvb/mantis/mantis_input.c
index db6d54d..8efd971 100644
--- a/drivers/media/dvb/mantis/mantis_input.c
+++ b/drivers/media/dvb/mantis/mantis_input.c
@@ -99,7 +99,7 @@ static struct rc_map_list ir_mantis_map = {
 	.map = {
 		.scan = mantis_ir_table,
 		.size = ARRAY_SIZE(mantis_ir_table),
-		.rc_type = RC_TYPE_UNKNOWN,
+		.rc_type = RC_BIT_UNKNOWN,
 		.name = RC_MAP_MANTIS,
 	}
 };
diff --git a/drivers/media/dvb/siano/smsir.c b/drivers/media/dvb/siano/smsir.c
index 37bc5c4..b8c5cad 100644
--- a/drivers/media/dvb/siano/smsir.c
+++ b/drivers/media/dvb/siano/smsir.c
@@ -88,7 +88,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 
 	dev->priv = coredev;
 	dev->driver_type = RC_DRIVER_IR_RAW;
-	dev->allowed_protos = RC_TYPE_ALL;
+	dev->allowed_protos = RC_BIT_ALL;
 	dev->map_name = sms_get_board(board_id)->rc_codes;
 	dev->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 7be377f..dfeabd7 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -771,7 +771,7 @@ static void ati_remote_rc_init(struct ati_remote *ati_remote)
 
 	rdev->priv = ati_remote;
 	rdev->driver_type = RC_DRIVER_SCANCODE;
-	rdev->allowed_protos = RC_TYPE_OTHER;
+	rdev->allowed_protos = RC_BIT_OTHER;
 	rdev->driver_name = "ati_remote";
 
 	rdev->open = ati_remote_rc_open;
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index bef5296..10621dc 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1041,7 +1041,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		learning_mode_force = false;
 
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_TYPE_ALL;
+	rdev->allowed_protos = RC_BIT_ALL;
 	rdev->priv = dev;
 	rdev->open = ene_open;
 	rdev->close = ene_close;
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 6aabf7a..f684dd8 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -532,7 +532,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 	/* Set up the rc device */
 	rdev->priv = fintek;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_TYPE_ALL;
+	rdev->allowed_protos = RC_BIT_ALL;
 	rdev->open = fintek_open;
 	rdev->close = fintek_close;
 	rdev->input_name = FINTEK_DESCRIPTION;
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 0d87545..478b2e9 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -83,7 +83,7 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
 	}
 
 	rcdev->driver_type = RC_DRIVER_IR_RAW;
-	rcdev->allowed_protos = RC_TYPE_ALL;
+	rcdev->allowed_protos = RC_BIT_ALL;
 	rcdev->input_name = GPIO_IR_DEVICE_NAME;
 	rcdev->input_id.bustype = BUS_HOST;
 	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 5dd0386..24eb493 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1015,17 +1015,16 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 			 "this device does not support\n");
 
 	switch (rc_type) {
-	case RC_TYPE_RC6:
+	case RC_BIT_RC6_MCE:
 		dev_dbg(dev, "Configuring IR receiver for MCE protocol\n");
 		ir_proto_packet[0] = 0x01;
 		break;
-	case RC_TYPE_UNKNOWN:
-	case RC_TYPE_OTHER:
+	case RC_BIT_OTHER:
 		dev_dbg(dev, "Configuring IR receiver for iMON protocol\n");
 		if (!pad_stabilize)
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
 		/* ir_proto_packet[0] = 0x00; // already the default */
-		rc_type = RC_TYPE_OTHER;
+		rc_type = RC_BIT_OTHER;
 		break;
 	default:
 		dev_warn(dev, "Unsupported IR protocol specified, overriding "
@@ -1033,7 +1032,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 		if (!pad_stabilize)
 			dev_dbg(dev, "PAD stabilize functionality disabled\n");
 		/* ir_proto_packet[0] = 0x00; // already the default */
-		rc_type = RC_TYPE_OTHER;
+		rc_type = RC_BIT_OTHER;
 		break;
 	}
 
@@ -1323,7 +1322,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		rel_x = buf[2];
 		rel_y = buf[3];
 
-		if (ictx->rc_type == RC_TYPE_OTHER && pad_stabilize) {
+		if (ictx->rc_type == RC_BIT_OTHER && pad_stabilize) {
 			if ((buf[1] == 0) && ((rel_x != 0) || (rel_y != 0))) {
 				dir = stabilize((int)rel_x, (int)rel_y,
 						timeout, threshold);
@@ -1390,7 +1389,7 @@ static void imon_pad_to_keys(struct imon_context *ictx, unsigned char *buf)
 		buf[0] = 0x01;
 		buf[1] = buf[4] = buf[5] = buf[6] = buf[7] = 0;
 
-		if (ictx->rc_type == RC_TYPE_OTHER && pad_stabilize) {
+		if (ictx->rc_type == RC_BIT_OTHER && pad_stabilize) {
 			dir = stabilize((int)rel_x, (int)rel_y,
 					timeout, threshold);
 			if (!dir) {
@@ -1511,7 +1510,7 @@ static void imon_incoming_packet(struct imon_context *ictx,
 		kc = imon_panel_key_lookup(scancode);
 	} else {
 		scancode = be32_to_cpu(*((u32 *)buf));
-		if (ictx->rc_type == RC_TYPE_RC6) {
+		if (ictx->rc_type == RC_BIT_RC6_MCE) {
 			ktype = IMON_KEY_IMON;
 			if (buf[0] == 0x80)
 				ktype = IMON_KEY_MCE;
@@ -1744,7 +1743,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 {
 	u8 ffdc_cfg_byte = ictx->usb_rx_buf[6];
 	u8 detected_display_type = IMON_DISPLAY_TYPE_NONE;
-	u64 allowed_protos = RC_TYPE_OTHER;
+	u64 allowed_protos = RC_BIT_OTHER;
 
 	switch (ffdc_cfg_byte) {
 	/* iMON Knob, no display, iMON IR + vol knob */
@@ -1775,13 +1774,13 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 	case 0x9e:
 		dev_info(ictx->dev, "0xffdc iMON VFD, MCE IR");
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
-		allowed_protos = RC_TYPE_RC6;
+		allowed_protos = RC_BIT_RC6_MCE;
 		break;
 	/* iMON LCD, MCE IR */
 	case 0x9f:
 		dev_info(ictx->dev, "0xffdc iMON LCD, MCE IR");
 		detected_display_type = IMON_DISPLAY_TYPE_LCD;
-		allowed_protos = RC_TYPE_RC6;
+		allowed_protos = RC_BIT_RC6_MCE;
 		break;
 	default:
 		dev_info(ictx->dev, "Unknown 0xffdc device, "
@@ -1789,7 +1788,7 @@ static void imon_get_ffdc_type(struct imon_context *ictx)
 		detected_display_type = IMON_DISPLAY_TYPE_VFD;
 		/* We don't know which one it is, allow user to set the
 		 * RC6 one from userspace if OTHER wasn't correct. */
-		allowed_protos |= RC_TYPE_RC6;
+		allowed_protos |= RC_BIT_RC6_MCE;
 		break;
 	}
 
@@ -1875,7 +1874,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	rdev->priv = ictx;
 	rdev->driver_type = RC_DRIVER_SCANCODE;
-	rdev->allowed_protos = RC_TYPE_OTHER | RC_TYPE_RC6; /* iMON PAD or MCE */
+	rdev->allowed_protos = RC_BIT_OTHER | RC_BIT_RC6_MCE; /* iMON PAD or MCE */
 	rdev->change_protocol = imon_ir_change_protocol;
 	rdev->driver_name = MOD_NAME;
 
@@ -1893,7 +1892,7 @@ static struct rc_dev *imon_init_rdev(struct imon_context *ictx)
 
 	imon_set_display_type(ictx);
 
-	if (ictx->rc_type == RC_TYPE_RC6)
+	if (ictx->rc_type == RC_BIT_RC6_MCE)
 		rdev->map_name = RC_MAP_IMON_MCE;
 	else
 		rdev->map_name = RC_MAP_IMON_PAD;
diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 035668e..69edffb 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -47,7 +47,7 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct jvc_dec *data = &dev->raw->jvc;
 
-	if (!(dev->raw->enabled_protocols & RC_TYPE_JVC))
+	if (!(dev->raw->enabled_protocols & RC_BIT_JVC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -174,7 +174,7 @@ out:
 }
 
 static struct ir_raw_handler jvc_handler = {
-	.protocols	= RC_TYPE_JVC,
+	.protocols	= RC_BIT_JVC,
 	.decode		= ir_jvc_decode,
 };
 
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 0287716..439879c 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -35,7 +35,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
 
-	if (!(dev->raw->enabled_protocols & RC_TYPE_LIRC))
+	if (!(dev->raw->enabled_protocols & RC_BIT_LIRC))
 		return 0;
 
 	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
@@ -408,7 +408,7 @@ static int ir_lirc_unregister(struct rc_dev *dev)
 }
 
 static struct ir_raw_handler lirc_handler = {
-	.protocols	= RC_TYPE_LIRC,
+	.protocols	= RC_BIT_LIRC,
 	.decode		= ir_lirc_decode,
 	.raw_register	= ir_lirc_register,
 	.raw_unregister	= ir_lirc_unregister,
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 3784ebf..33fafa4 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -216,7 +216,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	unsigned long delay;
 
-	if (!(dev->raw->enabled_protocols & RC_TYPE_MCE_KBD))
+	if (!(dev->raw->enabled_protocols & RC_BIT_MCE_KBD))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -422,7 +422,7 @@ static int ir_mce_kbd_unregister(struct rc_dev *dev)
 }
 
 static struct ir_raw_handler mce_kbd_handler = {
-	.protocols	= RC_TYPE_MCE_KBD,
+	.protocols	= RC_BIT_MCE_KBD,
 	.decode		= ir_mce_kbd_decode,
 	.raw_register	= ir_mce_kbd_register,
 	.raw_unregister	= ir_mce_kbd_unregister,
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 3c9431a..dc21a67 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -52,7 +52,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 address, not_address, command, not_command;
 	bool send_32bits = false;
 
-	if (!(dev->raw->enabled_protocols & RC_TYPE_NEC))
+	if (!(dev->raw->enabled_protocols & RC_BIT_NEC))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -201,7 +201,7 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 }
 
 static struct ir_raw_handler nec_handler = {
-	.protocols	= RC_TYPE_NEC,
+	.protocols	= RC_BIT_NEC,
 	.decode		= ir_nec_decode,
 };
 
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 9ab663a..5b4d1dd 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -52,8 +52,8 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle;
 	u32 scancode;
 
-        if (!(dev->raw->enabled_protocols & RC_TYPE_RC5))
-                return 0;
+	if (!(dev->raw->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
+		return 0;
 
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
@@ -128,6 +128,10 @@ again:
 		if (data->wanted_bits == RC5X_NBITS) {
 			/* RC5X */
 			u8 xdata, command, system;
+			if (!(dev->raw->enabled_protocols & RC_BIT_RC5X)) {
+				data->state = STATE_INACTIVE;
+				return 0;
+			}
 			xdata    = (data->bits & 0x0003F) >> 0;
 			command  = (data->bits & 0x00FC0) >> 6;
 			system   = (data->bits & 0x1F000) >> 12;
@@ -141,6 +145,10 @@ again:
 		} else {
 			/* RC5 */
 			u8 command, system;
+			if (!(dev->raw->enabled_protocols & RC_BIT_RC5)) {
+				data->state = STATE_INACTIVE;
+				return 0;
+			}
 			command  = (data->bits & 0x0003F) >> 0;
 			system   = (data->bits & 0x007C0) >> 6;
 			toggle   = (data->bits & 0x00800) ? 1 : 0;
@@ -164,7 +172,7 @@ out:
 }
 
 static struct ir_raw_handler rc5_handler = {
-	.protocols	= RC_TYPE_RC5,
+	.protocols	= RC_BIT_RC5 | RC_BIT_RC5X,
 	.decode		= ir_rc5_decode,
 };
 
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index ec8d4a2..fd807a8 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -48,8 +48,8 @@ static int ir_rc5_sz_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle, command, system;
 	u32 scancode;
 
-        if (!(dev->raw->enabled_protocols & RC_TYPE_RC5_SZ))
-                return 0;
+	if (!(dev->raw->enabled_protocols & RC_BIT_RC5_SZ))
+		return 0;
 
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
@@ -128,7 +128,7 @@ out:
 }
 
 static struct ir_raw_handler rc5_sz_handler = {
-	.protocols	= RC_TYPE_RC5_SZ,
+	.protocols	= RC_BIT_RC5_SZ,
 	.decode		= ir_rc5_sz_decode,
 };
 
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 4cfdd7f..e19072f 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -89,7 +89,9 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 toggle;
 
-	if (!(dev->raw->enabled_protocols & RC_TYPE_RC6))
+	if (!(dev->raw->enabled_protocols &
+	      (RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
+	       RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -271,7 +273,9 @@ out:
 }
 
 static struct ir_raw_handler rc6_handler = {
-	.protocols	= RC_TYPE_RC6,
+	.protocols	= RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 |
+			  RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 |
+			  RC_BIT_RC6_MCE,
 	.decode		= ir_rc6_decode,
 };
 
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 7e54ec5..7e69a3b 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -58,7 +58,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 address, command, not_command;
 
-	if (!(dev->raw->enabled_protocols & RC_TYPE_SANYO))
+	if (!(dev->raw->enabled_protocols & RC_BIT_SANYO))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -179,7 +179,7 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 }
 
 static struct ir_raw_handler sanyo_handler = {
-	.protocols	= RC_TYPE_SANYO,
+	.protocols	= RC_BIT_SANYO,
 	.decode		= ir_sanyo_decode,
 };
 
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index dab98b3..fb91434 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -45,7 +45,8 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 device, subdevice, function;
 
-	if (!(dev->raw->enabled_protocols & RC_TYPE_SONY))
+	if (!(dev->raw->enabled_protocols &
+	      (RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20)))
 		return 0;
 
 	if (!is_timing_event(ev)) {
@@ -123,16 +124,28 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		switch (data->count) {
 		case 12:
+			if (!(dev->raw->enabled_protocols & RC_BIT_SONY12)) {
+				data->state = STATE_INACTIVE;
+				return 0;
+			}
 			device    = bitrev8((data->bits <<  3) & 0xF8);
 			subdevice = 0;
 			function  = bitrev8((data->bits >>  4) & 0xFE);
 			break;
 		case 15:
+			if (!(dev->raw->enabled_protocols & RC_BIT_SONY15)) {
+				data->state = STATE_INACTIVE;
+				return 0;
+			}
 			device    = bitrev8((data->bits >>  0) & 0xFF);
 			subdevice = 0;
 			function  = bitrev8((data->bits >>  7) & 0xFE);
 			break;
 		case 20:
+			if (!(dev->raw->enabled_protocols & RC_BIT_SONY20)) {
+				data->state = STATE_INACTIVE;
+				return 0;
+			}
 			device    = bitrev8((data->bits >>  5) & 0xF8);
 			subdevice = bitrev8((data->bits >>  0) & 0xFF);
 			function  = bitrev8((data->bits >> 12) & 0xFE);
@@ -157,7 +170,7 @@ out:
 }
 
 static struct ir_raw_handler sony_handler = {
-	.protocols	= RC_TYPE_SONY,
+	.protocols	= RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20,
 	.decode		= ir_sony_decode,
 };
 
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 36fe5a3..494801e 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1562,7 +1562,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	/* set up ir-core props */
 	rdev->priv = itdev;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_TYPE_ALL;
+	rdev->allowed_protos = RC_BIT_ALL;
 	rdev->open = ite_open;
 	rdev->close = ite_close;
 	rdev->s_idle = ite_s_idle;
diff --git a/drivers/media/rc/keymaps/rc-imon-mce.c b/drivers/media/rc/keymaps/rc-imon-mce.c
index 124c722..f0da960 100644
--- a/drivers/media/rc/keymaps/rc-imon-mce.c
+++ b/drivers/media/rc/keymaps/rc-imon-mce.c
@@ -121,7 +121,7 @@ static struct rc_map_list imon_mce_map = {
 		.scan    = imon_mce,
 		.size    = ARRAY_SIZE(imon_mce),
 		/* its RC6, but w/a hardware decoder */
-		.rc_type = RC_TYPE_RC6,
+		.rc_type = RC_TYPE_RC6_MCE,
 		.name    = RC_MAP_IMON_MCE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-rc6-mce.c b/drivers/media/rc/keymaps/rc-rc6-mce.c
index 753e43e..ef4006f 100644
--- a/drivers/media/rc/keymaps/rc-rc6-mce.c
+++ b/drivers/media/rc/keymaps/rc-rc6-mce.c
@@ -97,7 +97,7 @@ static struct rc_map_list rc6_mce_map = {
 	.map = {
 		.scan    = rc6_mce,
 		.size    = ARRAY_SIZE(rc6_mce),
-		.rc_type = RC_TYPE_RC6,
+		.rc_type = RC_TYPE_RC6_MCE,
 		.name    = RC_MAP_RC6_MCE,
 	}
 };
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 6e430dd..f0f053d 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1196,7 +1196,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->dev.parent = dev;
 	rc->priv = ir;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protos = RC_TYPE_ALL;
+	rc->allowed_protos = RC_BIT_ALL;
 	rc->timeout = MS_TO_NS(100);
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index dc8a7dd..f4ce071 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1043,7 +1043,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* Set up the rc device */
 	rdev->priv = nvt;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_TYPE_ALL;
+	rdev->allowed_protos = RC_BIT_ALL;
 	rdev->open = nvt_open;
 	rdev->close = nvt_close;
 	rdev->tx_ir = nvt_tx_ir;
diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index f9be681..53d0282 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -195,7 +195,7 @@ static int __init loop_init(void)
 	rc->map_name		= RC_MAP_EMPTY;
 	rc->priv		= &loopdev;
 	rc->driver_type		= RC_DRIVER_IR_RAW;
-	rc->allowed_protos	= RC_TYPE_ALL;
+	rc->allowed_protos	= RC_BIT_ALL;
 	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
 	rc->min_timeout		= 1;
 	rc->max_timeout		= UINT_MAX;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 6e16b09..3455a9e 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -725,25 +725,47 @@ static struct class ir_input_class = {
 	.devnode	= ir_devnode,
 };
 
+/*
+ * These are the protocol textual descriptions that are
+ * used by the sysfs protocols file. Note that the order
+ * of the entries is relevant.
+ */
 static struct {
 	u64	type;
 	char	*name;
 } proto_names[] = {
-	{ RC_TYPE_UNKNOWN,	"unknown"	},
-	{ RC_TYPE_RC5,		"rc-5"		},
-	{ RC_TYPE_NEC,		"nec"		},
-	{ RC_TYPE_RC6,		"rc-6"		},
-	{ RC_TYPE_JVC,		"jvc"		},
-	{ RC_TYPE_SONY,		"sony"		},
-	{ RC_TYPE_RC5_SZ,	"rc-5-sz"	},
-	{ RC_TYPE_SANYO,	"sanyo"		},
-	{ RC_TYPE_MCE_KBD,	"mce_kbd"	},
-	{ RC_TYPE_LIRC,		"lirc"		},
-	{ RC_TYPE_OTHER,	"other"		},
+	{ RC_BIT_NONE,		"none"		},
+	{ RC_BIT_OTHER,		"other"		},
+	{ RC_BIT_UNKNOWN,	"unknown"	},
+	{ RC_BIT_RC5,		"rc-5:plain"	},
+	{ RC_BIT_RC5X,		"rc-5:x"	},
+	{ RC_BIT_RC5_SZ,	"rc-5:sz"	},
+	{ RC_BIT_RC5 |
+	  RC_BIT_RC5X |
+	  RC_BIT_RC5_SZ,	"rc-5"		},
+	{ RC_BIT_RC6_0,		"rc-6:0"	},
+	{ RC_BIT_RC6_6A_20,	"rc-6:6a-20"	},
+	{ RC_BIT_RC6_6A_24,	"rc-6:6a-24"	},
+	{ RC_BIT_RC6_6A_32,	"rc-6:6a-32"	},
+	{ RC_BIT_RC6_MCE,	"rc-6:mce"	},
+	{ RC_BIT_RC6_0 |
+	  RC_BIT_RC6_6A_20 |
+	  RC_BIT_RC6_6A_24 |
+	  RC_BIT_RC6_6A_32 |
+	  RC_BIT_RC6_MCE,	"rc-6"		},
+	{ RC_BIT_JVC,		"jvc"		},
+	{ RC_BIT_SONY12,	"sony:12"	},
+	{ RC_BIT_SONY15,	"sony:15"	},
+	{ RC_BIT_SONY20,	"sony:20"	},
+	{ RC_BIT_SONY12 |
+	  RC_BIT_SONY15 |
+	  RC_BIT_SONY20,	"sony"		},
+	{ RC_BIT_NEC,		"nec"		},
+	{ RC_BIT_SANYO,		"sanyo"		},
+	{ RC_BIT_MCE_KBD,	"mce_kbd"	},
+	{ RC_BIT_LIRC,		"lirc"		},
 };
 
-#define PROTO_NONE	"none"
-
 /**
  * show_protocols() - shows the current IR protocol(s)
  * @device:	the device descriptor
@@ -789,6 +811,9 @@ static ssize_t show_protocols(struct device *device,
 			tmp += sprintf(tmp, "[%s] ", proto_names[i].name);
 		else if (allowed & proto_names[i].type)
 			tmp += sprintf(tmp, "%s ", proto_names[i].name);
+
+		if (allowed & proto_names[i].type)
+			allowed &= ~proto_names[i].type;
 	}
 
 	if (tmp != buf)
@@ -866,26 +891,20 @@ static ssize_t store_protocols(struct device *device,
 			disable = false;
 		}
 
-		if (!enable && !disable && !strncasecmp(tmp, PROTO_NONE, sizeof(PROTO_NONE))) {
-			tmp += sizeof(PROTO_NONE);
-			mask = 0;
-			count++;
-		} else {
-			for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
-				if (!strcasecmp(tmp, proto_names[i].name)) {
-					tmp += strlen(proto_names[i].name);
-					mask = proto_names[i].type;
-					break;
-				}
-			}
-			if (i == ARRAY_SIZE(proto_names)) {
-				IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
-				ret = -EINVAL;
-				goto out;
+		for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
+			if (!strcasecmp(tmp, proto_names[i].name)) {
+				mask = proto_names[i].type;
+				break;
 			}
-			count++;
 		}
 
+		if (i == ARRAY_SIZE(proto_names)) {
+			IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
+			return -EINVAL;
+		}
+
+		count++;
+
 		if (enable)
 			type |= mask;
 		else if (disable)
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 2878b0e..13a679f 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1079,7 +1079,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	rc->dev.parent = dev;
 	rc->priv = rr3;
 	rc->driver_type = RC_DRIVER_IR_RAW;
-	rc->allowed_protos = RC_TYPE_ALL;
+	rc->allowed_protos = RC_BIT_ALL;
 	rc->timeout = US_TO_NS(2750);
 	rc->tx_ir = redrat3_transmit_ir;
 	rc->s_tx_carrier = redrat3_set_tx_carrier;
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index d6f4bfe..c720f12 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -322,7 +322,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	rdev->dev.parent = dev;
 	rdev->priv = sz;
 	rdev->driver_type = RC_DRIVER_IR_RAW;
-	rdev->allowed_protos = RC_TYPE_ALL;
+	rdev->allowed_protos = RC_BIT_ALL;
 	rdev->driver_name = DRIVER_NAME;
 	rdev->map_name = RC_MAP_STREAMZAP;
 
diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/video/cx18/cx18-i2c.c
index 51609d5..4908eb7 100644
--- a/drivers/media/video/cx18/cx18-i2c.c
+++ b/drivers/media/video/cx18/cx18-i2c.c
@@ -98,7 +98,7 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 	case CX18_HW_Z8F0811_IR_RX_HAUP:
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type = RC_TYPE_RC5;
+		init_data->type = RC_BIT_RC5;
 		init_data->name = cx->card_name;
 		info.platform_data = init_data;
 		break;
diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index 96176e9..0f7b424 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -99,7 +99,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	/* The i2c micro-controller only outputs the cmd part of NEC protocol */
 	dev->init_data.rc_dev->scanmask = 0xff;
 	dev->init_data.rc_dev->driver_name = "cx231xx";
-	dev->init_data.type = RC_TYPE_NEC;
+	dev->init_data.type = RC_BIT_NEC;
 	info.addr = 0x30;
 
 	/* Load and bind ir-kbd-i2c */
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index ce765e3..6aa96a2 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -268,14 +268,14 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 		/* Integrated CX2388[58] IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = RC_TYPE_ALL;
+		allowed_protos = RC_BIT_ALL;
 		/* The grey Hauppauge RC-5 remote */
 		rc_map = RC_MAP_HAUPPAUGE;
 		break;
 	case CX23885_BOARD_TEVII_S470:
 		/* Integrated CX23885 IR controller */
 		driver_type = RC_DRIVER_IR_RAW;
-		allowed_protos = RC_TYPE_ALL;
+		allowed_protos = RC_BIT_ALL;
 		/* A guess at the remote */
 		rc_map = RC_MAP_TEVII_NEC;
 		break;
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index ebf448c..f29e18c 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -248,7 +248,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	struct cx88_IR *ir;
 	struct rc_dev *dev;
 	char *ir_codes = NULL;
-	u64 rc_type = RC_TYPE_OTHER;
+	u64 rc_type = RC_BIT_OTHER;
 	int err = -ENOMEM;
 	u32 hardware_mask = 0;	/* For devices with a hardware mask, when
 				 * used with a full-code IR table
@@ -416,7 +416,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_TWINHAN_VP1027_DVBS:
 		ir_codes         = RC_MAP_TWINHAN_VP1027_DVBS;
-		rc_type          = RC_TYPE_NEC;
+		rc_type          = RC_BIT_NEC;
 		ir->sampling     = 0xff00; /* address */
 		break;
 	}
@@ -592,7 +592,7 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 	case CX88_BOARD_LEADTEK_PVR2000:
 		addr_list = pvr2000_addr_list;
 		core->init_data.name = "cx88 Leadtek PVR 2000 remote";
-		core->init_data.type = RC_TYPE_UNKNOWN;
+		core->init_data.type = RC_BIT_UNKNOWN;
 		core->init_data.get_key = get_key_pvr2000;
 		core->init_data.ir_codes = RC_MAP_EMPTY;
 		break;
@@ -613,7 +613,7 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 			/* Hauppauge XVR */
 			core->init_data.name = "cx88 Hauppauge XVR remote";
 			core->init_data.ir_codes = RC_MAP_HAUPPAUGE;
-			core->init_data.type = RC_TYPE_RC5;
+			core->init_data.type = RC_BIT_RC5;
 			core->init_data.internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 
 			info.platform_data = &core->init_data;
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index fce5f76..55808a9 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -354,14 +354,14 @@ int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 rc_type)
 
 	/* Adjust xclk based o IR table for RC5/NEC tables */
 
-	if (rc_type == RC_TYPE_RC5) {
+	if (rc_type == RC_BIT_RC5) {
 		dev->board.xclk |= EM28XX_XCLK_IR_RC5_MODE;
 		ir->full_code = 1;
-	} else if (rc_type == RC_TYPE_NEC) {
+	} else if (rc_type == RC_BIT_NEC) {
 		dev->board.xclk &= ~EM28XX_XCLK_IR_RC5_MODE;
 		ir_config = EM2874_IR_NEC;
 		ir->full_code = 1;
-	} else if (rc_type != RC_TYPE_UNKNOWN)
+	} else if (rc_type != RC_BIT_UNKNOWN)
 		rc = -EINVAL;
 
 	em28xx_write_reg_bits(dev, EM28XX_R0F_XCLK, dev->board.xclk,
@@ -544,14 +544,14 @@ static int em28xx_ir_init(struct em28xx *dev)
 	 * em2874 supports more protocols. For now, let's just announce
 	 * the two protocols that were already tested
 	 */
-	rc->allowed_protos = RC_TYPE_RC5 | RC_TYPE_NEC;
+	rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
 	rc->priv = ir;
 	rc->change_protocol = em28xx_ir_change_protocol;
 	rc->open = em28xx_ir_start;
 	rc->close = em28xx_ir_stop;
 
 	/* By default, keep protocol field untouched */
-	err = em28xx_ir_change_protocol(rc, RC_TYPE_UNKNOWN);
+	err = em28xx_ir_change_protocol(rc, RC_BIT_UNKNOWN);
 	if (err)
 		goto err_out_free;
 
diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
index 82e819f..031cf02 100644
--- a/drivers/media/video/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
@@ -55,7 +55,7 @@ struct i2c_client *hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev)
 	/* Our default information for ir-kbd-i2c.c to use */
 	init_data->ir_codes = RC_MAP_HAUPPAUGE;
 	init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-	init_data->type = RC_TYPE_RC5;
+	init_data->type = RC_BIT_RC5;
 	init_data->name = "HD-PVR";
 	init_data->polling_interval = 405; /* ms, duplicated from Windows */
 	hdpvr_ir_rx_i2c_board_info.platform_data = init_data;
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 04f192a..08ae067 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -284,7 +284,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	char *ir_codes = NULL;
 	const char *name = NULL;
-	u64 rc_type = RC_TYPE_UNKNOWN;
+	u64 rc_type = RC_BIT_UNKNOWN;
 	struct IR_i2c *ir;
 	struct rc_dev *rc = NULL;
 	struct i2c_adapter *adap = client->adapter;
@@ -303,7 +303,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x64:
 		name        = "Pixelview";
 		ir->get_key = get_key_pixelview;
-		rc_type     = RC_TYPE_OTHER;
+		rc_type     = RC_BIT_OTHER;
 		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x18:
@@ -311,31 +311,31 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	case 0x1a:
 		name        = "Hauppauge";
 		ir->get_key = get_key_haup;
-		rc_type     = RC_TYPE_RC5;
+		rc_type     = RC_BIT_RC5;
 		ir_codes    = RC_MAP_HAUPPAUGE;
 		break;
 	case 0x30:
 		name        = "KNC One";
 		ir->get_key = get_key_knc1;
-		rc_type     = RC_TYPE_OTHER;
+		rc_type     = RC_BIT_OTHER;
 		ir_codes    = RC_MAP_EMPTY;
 		break;
 	case 0x6b:
 		name        = "FusionHDTV";
 		ir->get_key = get_key_fusionhdtv;
-		rc_type     = RC_TYPE_RC5;
+		rc_type     = RC_BIT_RC5;
 		ir_codes    = RC_MAP_FUSIONHDTV_MCE;
 		break;
 	case 0x40:
 		name        = "AVerMedia Cardbus remote";
 		ir->get_key = get_key_avermedia_cardbus;
-		rc_type     = RC_TYPE_OTHER;
+		rc_type     = RC_BIT_OTHER;
 		ir_codes    = RC_MAP_AVERMEDIA_CARDBUS;
 		break;
 	case 0x71:
 		name        = "Hauppauge/Zilog Z8";
 		ir->get_key = get_key_haup_xvr;
-		rc_type     = RC_TYPE_RC5;
+		rc_type     = RC_BIT_RC5;
 		ir_codes    = RC_MAP_HAUPPAUGE;
 		break;
 	}
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index d47f41a..46e262b 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -200,21 +200,21 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		init_data->ir_codes = RC_MAP_AVERMEDIA_CARDBUS;
 		init_data->internal_get_key_func =
 					IR_KBD_GET_KEY_AVERMEDIA_CARDBUS;
-		init_data->type = RC_TYPE_OTHER;
+		init_data->type = RC_BIT_OTHER;
 		init_data->name = "AVerMedia AVerTV card";
 		break;
 	case IVTV_HW_I2C_IR_RX_HAUP_EXT:
 	case IVTV_HW_I2C_IR_RX_HAUP_INT:
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
-		init_data->type = RC_TYPE_RC5;
+		init_data->type = RC_BIT_RC5;
 		init_data->name = itv->card_name;
 		break;
 	case IVTV_HW_Z8F0811_IR_RX_HAUP:
 		/* Default to grey remote */
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type = RC_TYPE_RC5;
+		init_data->type = RC_BIT_RC5;
 		init_data->name = itv->card_name;
 		break;
 	case IVTV_HW_I2C_IR_RX_ADAPTEC:
@@ -222,7 +222,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		init_data->name = itv->card_name;
 		/* FIXME: The protocol and RC_MAP needs to be corrected */
 		init_data->ir_codes = RC_MAP_EMPTY;
-		init_data->type = RC_TYPE_UNKNOWN;
+		init_data->type = RC_BIT_UNKNOWN;
 		break;
 	}
 
diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
index 885ce11..9ab596c 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
@@ -581,7 +581,7 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
 	case PVR2_IR_SCHEME_29XXX: /* Original 29xxx device */
 		init_data->ir_codes              = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
-		init_data->type                  = RC_TYPE_RC5;
+		init_data->type                  = RC_BIT_RC5;
 		init_data->name                  = hdw->hdw_desc->description;
 		init_data->polling_interval      = 100; /* ms From ir-kbd-i2c */
 		/* IR Receiver */
@@ -596,7 +596,7 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
 	case PVR2_IR_SCHEME_24XXX_MCE: /* 24xxx MCE device */
 		init_data->ir_codes              = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
-		init_data->type                  = RC_TYPE_RC5;
+		init_data->type                  = RC_BIT_RC5;
 		init_data->name                  = hdw->hdw_desc->description;
 		/* IR Receiver */
 		info.addr          = 0x71;
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 05c6e21..6ad49c6 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -995,7 +995,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
 		dev->init_data.ir_codes = RC_MAP_BEHOLD;
-		dev->init_data.type = RC_TYPE_NEC;
+		dev->init_data.type = RC_BIT_NEC;
 		info.addr = 0x2d;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/video/tm6000/tm6000-input.c
index e80b7e1..8ce028f 100644
--- a/drivers/media/video/tm6000/tm6000-input.c
+++ b/drivers/media/video/tm6000/tm6000-input.c
@@ -109,12 +109,12 @@ static int tm6000_ir_config(struct tm6000_IR *ir)
 	 */
 
 	switch (ir->rc_type) {
-	case RC_TYPE_NEC:
+	case RC_BIT_NEC:
 		leader = 900;	/* ms */
 		pulse  = 700;	/* ms - the actual value would be 562 */
 		break;
 	default:
-	case RC_TYPE_RC5:
+	case RC_BIT_RC5:
 		leader = 900;	/* ms - from the NEC decoding */
 		pulse  = 1780;	/* ms - The actual value would be 1776 */
 		break;
@@ -122,12 +122,12 @@ static int tm6000_ir_config(struct tm6000_IR *ir)
 
 	pulse = ir_clock_mhz * pulse;
 	leader = ir_clock_mhz * leader;
-	if (ir->rc_type == RC_TYPE_NEC)
+	if (ir->rc_type == RC_BIT_NEC)
 		leader = leader | 0x8000;
 
-	dprintk(2, "%s: %s, %d MHz, leader = 0x%04x, pulse = 0x%06x \n",
+	dprintk(2, "%s: %s, %d MHz, leader = 0x%04x, pulse = 0x%06x\n",
 		__func__,
-		(ir->rc_type == RC_TYPE_NEC) ? "NEC" : "RC-5",
+		(ir->rc_type == RC_BIT_NEC) ? "NEC" : "RC-5",
 		ir_clock_mhz, leader, pulse);
 
 	/* Remote WAKEUP = enable, normal mode, from IR decoder output */
@@ -306,7 +306,7 @@ static int tm6000_ir_change_protocol(struct rc_dev *rc, u64 rc_type)
 
 	dprintk(2, "%s\n",__func__);
 
-	if ((rc->rc_map.scan) && (rc_type == RC_TYPE_NEC))
+	if ((rc->rc_map.scan) && (rc_type == RC_BIT_NEC))
 		ir->key_addr = ((rc->rc_map.scan[0].scancode >> 8) & 0xffff);
 
 	ir->rc_type = rc_type;
@@ -420,7 +420,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	ir->rc = rc;
 
 	/* input setup */
-	rc->allowed_protos = RC_TYPE_RC5 | RC_TYPE_NEC;
+	rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC;
 	/* Neded, in order to support NEC remotes with 24 or 32 bits */
 	rc->scanmask = 0xffff;
 	rc->priv = ir;
@@ -443,7 +443,7 @@ int tm6000_ir_init(struct tm6000_core *dev)
 	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
-	tm6000_ir_change_protocol(rc, RC_TYPE_UNKNOWN);
+	tm6000_ir_change_protocol(rc, RC_BIT_UNKNOWN);
 
 	rc->input_name = ir->name;
 	rc->input_phys = ir->phys;
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index 768aa77..e221bc7 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -37,7 +37,7 @@ enum ir_kbd_get_key_fn {
 struct IR_i2c_init_data {
 	char			*ir_codes;
 	const char		*name;
-	u64			type; /* RC_TYPE_RC5, etc */
+	u64			type; /* RC_BIT_RC5, etc */
 	u32			polling_interval; /* 0 means DEFAULT_POLLING_INTERVAL */
 
 	/*
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index b0c494a..58f12da 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -50,7 +50,7 @@ enum rc_driver_type {
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
  * @idle: used to keep track of RX state
- * @allowed_protos: bitmask with the supported RC_TYPE_* protocols
+ * @allowed_protos: bitmask with the supported RC_BIT_* protocols
  * @scanmask: some hardware decoders are not capable of providing the full
  *	scancode to the application. As this is a hardware limit, we can't do
  *	anything with it. Yet, as the same keycode table can be used with other
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index cfd5163..909c2ed 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -11,22 +11,54 @@
 
 #include <linux/input.h>
 
-#define RC_TYPE_UNKNOWN	0
-#define RC_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
-#define RC_TYPE_NEC	(1  << 1)
-#define RC_TYPE_RC6	(1  << 2)	/* Philips RC6 protocol */
-#define RC_TYPE_JVC	(1  << 3)	/* JVC protocol */
-#define RC_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
-#define RC_TYPE_RC5_SZ	(1  << 5)	/* RC5 variant used by Streamzap */
-#define RC_TYPE_SANYO   (1  << 6)	/* Sanyo protocol */
-#define RC_TYPE_MCE_KBD	(1  << 29)	/* RC6-ish MCE keyboard/mouse */
-#define RC_TYPE_LIRC	(1  << 30)	/* Pass raw IR to lirc userspace */
-#define RC_TYPE_OTHER	(1u << 31)
+enum rc_type {
+	RC_TYPE_UNKNOWN		= 0,	/* Protocol not known */
+	RC_TYPE_OTHER		= 0,	/* Protocol known but proprietary */
+	RC_TYPE_LIRC		= 1,	/* Pass raw IR to lirc userspace */
+	RC_TYPE_RC5		= 2,	/* Philips RC5 protocol */
+	RC_TYPE_RC5X		= 3,	/* Philips RC5x protocol */
+	RC_TYPE_RC5_SZ		= 4,	/* StreamZap variant of RC5 */
+	RC_TYPE_JVC		= 5,	/* JVC protocol */
+	RC_TYPE_SONY12		= 6,	/* Sony 12 bit protocol */
+	RC_TYPE_SONY15		= 7,	/* Sony 15 bit protocol */
+	RC_TYPE_SONY20		= 8,	/* Sony 20 bit protocol */
+	RC_TYPE_NEC		= 9,	/* NEC protocol */
+	RC_TYPE_SANYO		= 10,	/* Sanyo protocol */
+	RC_TYPE_MCE_KBD		= 11,	/* RC6-ish MCE keyboard/mouse */
+	RC_TYPE_RC6_0		= 12,	/* Philips RC6-0-16 protocol */
+	RC_TYPE_RC6_6A_20	= 13,	/* Philips RC6-6A-20 protocol */
+	RC_TYPE_RC6_6A_24	= 14,	/* Philips RC6-6A-24 protocol */
+	RC_TYPE_RC6_6A_32	= 15,	/* Philips RC6-6A-32 protocol */
+	RC_TYPE_RC6_MCE		= 16,	/* MCE (Philips RC6-6A-32 subtype) protocol */
+};
+
+#define RC_BIT_NONE		0
+#define RC_BIT_UNKNOWN		(1 << RC_TYPE_UNKNOWN)
+#define RC_BIT_OTHER		(1 << RC_TYPE_OTHER)
+#define RC_BIT_LIRC		(1 << RC_TYPE_LIRC)
+#define RC_BIT_RC5		(1 << RC_TYPE_RC5)
+#define RC_BIT_RC5X		(1 << RC_TYPE_RC5X)
+#define RC_BIT_RC5_SZ		(1 << RC_TYPE_RC5_SZ)
+#define RC_BIT_JVC		(1 << RC_TYPE_JVC)
+#define RC_BIT_SONY12		(1 << RC_TYPE_SONY12)
+#define RC_BIT_SONY15		(1 << RC_TYPE_SONY15)
+#define RC_BIT_SONY20		(1 << RC_TYPE_SONY20)
+#define RC_BIT_NEC		(1 << RC_TYPE_NEC)
+#define RC_BIT_SANYO		(1 << RC_TYPE_SANYO)
+#define RC_BIT_MCE_KBD		(1 << RC_TYPE_MCE_KBD)
+#define RC_BIT_RC6_0		(1 << RC_TYPE_RC6_0)
+#define RC_BIT_RC6_6A_20	(1 << RC_TYPE_RC6_6A_20)
+#define RC_BIT_RC6_6A_24	(1 << RC_TYPE_RC6_6A_24)
+#define RC_BIT_RC6_6A_32	(1 << RC_TYPE_RC6_6A_32)
+#define RC_BIT_RC6_MCE		(1 << RC_TYPE_RC6_MCE)
 
-#define RC_TYPE_ALL (RC_TYPE_RC5    | RC_TYPE_NEC   | RC_TYPE_RC6     | \
-		     RC_TYPE_JVC    | RC_TYPE_SONY  | RC_TYPE_LIRC    | \
-		     RC_TYPE_RC5_SZ | RC_TYPE_SANYO | RC_TYPE_MCE_KBD | \
-		     RC_TYPE_OTHER)
+#define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | RC_BIT_LIRC | \
+			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
+			 RC_BIT_JVC | \
+			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
+			 RC_BIT_NEC | RC_BIT_SANYO | RC_BIT_MCE_KBD | \
+			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
+			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)
 
 struct rc_map_table {
 	u32	scancode;
@@ -38,7 +70,7 @@ struct rc_map {
 	unsigned int		size;	/* Max number of entries */
 	unsigned int		len;	/* Used number of entries */
 	unsigned int		alloc;	/* Size of *scan in bytes */
-	u64			rc_type;
+	enum rc_type		rc_type;
 	const char		*name;
 	spinlock_t		lock;
 };


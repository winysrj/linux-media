Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762AbbBQObR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 09:31:17 -0500
Subject: [PATCH] cxusb: Use enum to represent table offsets rather than
 hard-coding numbers [ver #3]
From: David Howells <dhowells@redhat.com>
To: mchehab@osg.samsung.com
Cc: mkrufky@linuxtv.org, linux-media@vger.kernel.org
Date: Tue, 17 Feb 2015 14:30:34 +0000
Message-ID: <20150217143034.22539.62892.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use enum to represent table offsets rather than hard-coding numbers to avoid
problems with the numbers becoming out of sync with the table.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/media/usb/dvb-usb/cxusb.c |  155 ++++++++++++++++++++++++++-----------
 1 file changed, 111 insertions(+), 44 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index f327c49..ffc3704 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1516,28 +1516,95 @@ static void cxusb_disconnect(struct usb_interface *intf)
 	dvb_usb_device_exit(intf);
 }
 
-static struct usb_device_id cxusb_table [] = {
-	{ USB_DEVICE(USB_VID_MEDION, USB_PID_MEDION_MD95700) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LG064F_COLD) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LG064F_WARM) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_1_COLD) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_1_WARM) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LGZ201_COLD) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LGZ201_WARM) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_TH7579_COLD) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_TH7579_WARM) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_COLD) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_WARM) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_2_COLD) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_2_WARM) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_4) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM) },
-	{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_A868R) },
-	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2) },
-	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_CONEXANT_D680_DMB) },
-	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_D689) },
-	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230) },
+enum cxusb_table_index {
+	MEDION_MD95700,
+	DVICO_BLUEBIRD_LG064F_COLD,
+	DVICO_BLUEBIRD_LG064F_WARM,
+	DVICO_BLUEBIRD_DUAL_1_COLD,
+	DVICO_BLUEBIRD_DUAL_1_WARM,
+	DVICO_BLUEBIRD_LGZ201_COLD,
+	DVICO_BLUEBIRD_LGZ201_WARM,
+	DVICO_BLUEBIRD_TH7579_COLD,
+	DVICO_BLUEBIRD_TH7579_WARM,
+	DIGITALNOW_BLUEBIRD_DUAL_1_COLD,
+	DIGITALNOW_BLUEBIRD_DUAL_1_WARM,
+	DVICO_BLUEBIRD_DUAL_2_COLD,
+	DVICO_BLUEBIRD_DUAL_2_WARM,
+	DVICO_BLUEBIRD_DUAL_4,
+	DVICO_BLUEBIRD_DVB_T_NANO_2,
+	DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM,
+	AVERMEDIA_VOLAR_A868R,
+	DVICO_BLUEBIRD_DUAL_4_REV_2,
+	CONEXANT_D680_DMB,
+	MYGICA_D689,
+	MYGICA_T230,
+	NR__cxusb_table_index
+};
+
+static struct usb_device_id cxusb_table[NR__cxusb_table_index + 1] = {
+	[MEDION_MD95700] = {
+		USB_DEVICE(USB_VID_MEDION, USB_PID_MEDION_MD95700)
+	},
+	[DVICO_BLUEBIRD_LG064F_COLD] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LG064F_COLD)
+	},
+	[DVICO_BLUEBIRD_LG064F_WARM] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LG064F_WARM)
+	},
+	[DVICO_BLUEBIRD_DUAL_1_COLD] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_1_COLD)
+	},
+	[DVICO_BLUEBIRD_DUAL_1_WARM] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_1_WARM)
+	},
+	[DVICO_BLUEBIRD_LGZ201_COLD] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LGZ201_COLD)
+	},
+	[DVICO_BLUEBIRD_LGZ201_WARM] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LGZ201_WARM)
+	},
+	[DVICO_BLUEBIRD_TH7579_COLD] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_TH7579_COLD)
+	},
+	[DVICO_BLUEBIRD_TH7579_WARM] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_TH7579_WARM)
+	},
+	[DIGITALNOW_BLUEBIRD_DUAL_1_COLD] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_COLD)
+	},
+	[DIGITALNOW_BLUEBIRD_DUAL_1_WARM] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_WARM)
+	},
+	[DVICO_BLUEBIRD_DUAL_2_COLD] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_2_COLD)
+	},
+	[DVICO_BLUEBIRD_DUAL_2_WARM] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_2_WARM)
+	},
+	[DVICO_BLUEBIRD_DUAL_4] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_4)
+	},
+	[DVICO_BLUEBIRD_DVB_T_NANO_2] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2)
+	},
+	[DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM)
+	},
+	[AVERMEDIA_VOLAR_A868R] = {
+		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_A868R)
+	},
+	[DVICO_BLUEBIRD_DUAL_4_REV_2] = {
+		USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2)
+	},
+	[CONEXANT_D680_DMB] = {
+		USB_DEVICE(USB_VID_CONEXANT, USB_PID_CONEXANT_D680_DMB)
+	},
+	[MYGICA_D689] = {
+		USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_D689)
+	},
+	[MYGICA_T230] = {
+		USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230)
+	},
 	{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, cxusb_table);
@@ -1581,7 +1648,7 @@ static struct dvb_usb_device_properties cxusb_medion_properties = {
 	.devices = {
 		{   "Medion MD95700 (MDUSBTV-HYBRID)",
 			{ NULL },
-			{ &cxusb_table[0], NULL },
+			{ &cxusb_table[MEDION_MD95700], NULL },
 		},
 	}
 };
@@ -1637,8 +1704,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgh064f_properties = {
 	.num_device_descs = 1,
 	.devices = {
 		{   "DViCO FusionHDTV5 USB Gold",
-			{ &cxusb_table[1], NULL },
-			{ &cxusb_table[2], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_LG064F_COLD], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_LG064F_WARM], NULL },
 		},
 	}
 };
@@ -1693,16 +1760,16 @@ static struct dvb_usb_device_properties cxusb_bluebird_dee1601_properties = {
 	.num_device_descs = 3,
 	.devices = {
 		{   "DViCO FusionHDTV DVB-T Dual USB",
-			{ &cxusb_table[3], NULL },
-			{ &cxusb_table[4], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_DUAL_1_COLD], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_DUAL_1_WARM], NULL },
 		},
 		{   "DigitalNow DVB-T Dual USB",
-			{ &cxusb_table[9],  NULL },
-			{ &cxusb_table[10], NULL },
+			{ &cxusb_table[DIGITALNOW_BLUEBIRD_DUAL_1_COLD],  NULL },
+			{ &cxusb_table[DIGITALNOW_BLUEBIRD_DUAL_1_WARM], NULL },
 		},
 		{   "DViCO FusionHDTV DVB-T Dual Digital 2",
-			{ &cxusb_table[11], NULL },
-			{ &cxusb_table[12], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_DUAL_2_COLD], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_DUAL_2_WARM], NULL },
 		},
 	}
 };
@@ -1756,8 +1823,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties = {
 	.num_device_descs = 1,
 	.devices = {
 		{   "DViCO FusionHDTV DVB-T USB (LGZ201)",
-			{ &cxusb_table[5], NULL },
-			{ &cxusb_table[6], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_LGZ201_COLD], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_LGZ201_WARM], NULL },
 		},
 	}
 };
@@ -1812,8 +1879,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_dtt7579_properties = {
 	.num_device_descs = 1,
 	.devices = {
 		{   "DViCO FusionHDTV DVB-T USB (TH7579)",
-			{ &cxusb_table[7], NULL },
-			{ &cxusb_table[8], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_TH7579_COLD], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_TH7579_WARM], NULL },
 		},
 	}
 };
@@ -1865,7 +1932,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_properties = {
 	.devices = {
 		{   "DViCO FusionHDTV DVB-T Dual Digital 4",
 			{ NULL },
-			{ &cxusb_table[13], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_DUAL_4], NULL },
 		},
 	}
 };
@@ -1918,7 +1985,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties = {
 	.devices = {
 		{   "DViCO FusionHDTV DVB-T NANO2",
 			{ NULL },
-			{ &cxusb_table[14], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_DVB_T_NANO_2], NULL },
 		},
 	}
 };
@@ -1972,8 +2039,8 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_prope
 	.num_device_descs = 1,
 	.devices = {
 		{   "DViCO FusionHDTV DVB-T NANO2 w/o firmware",
-			{ &cxusb_table[14], NULL },
-			{ &cxusb_table[15], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_DVB_T_NANO_2], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM], NULL },
 		},
 	}
 };
@@ -2017,7 +2084,7 @@ static struct dvb_usb_device_properties cxusb_aver_a868r_properties = {
 	.devices = {
 		{   "AVerMedia AVerTVHD Volar (A868R)",
 			{ NULL },
-			{ &cxusb_table[16], NULL },
+			{ &cxusb_table[AVERMEDIA_VOLAR_A868R], NULL },
 		},
 	}
 };
@@ -2071,7 +2138,7 @@ struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
 	.devices = {
 		{   "DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2)",
 			{ NULL },
-			{ &cxusb_table[17], NULL },
+			{ &cxusb_table[DVICO_BLUEBIRD_DUAL_4_REV_2], NULL },
 		},
 	}
 };
@@ -2125,7 +2192,7 @@ static struct dvb_usb_device_properties cxusb_d680_dmb_properties = {
 		{
 			"Conexant DMB-TH Stick",
 			{ NULL },
-			{ &cxusb_table[18], NULL },
+			{ &cxusb_table[CONEXANT_D680_DMB], NULL },
 		},
 	}
 };
@@ -2179,7 +2246,7 @@ static struct dvb_usb_device_properties cxusb_mygica_d689_properties = {
 		{
 			"Mygica D689 DMB-TH",
 			{ NULL },
-			{ &cxusb_table[19], NULL },
+			{ &cxusb_table[MYGICA_D689], NULL },
 		},
 	}
 };
@@ -2232,7 +2299,7 @@ static struct dvb_usb_device_properties cxusb_mygica_t230_properties = {
 		{
 			"Mygica T230 DVB-T/T2/C",
 			{ NULL },
-			{ &cxusb_table[20], NULL },
+			{ &cxusb_table[MYGICA_T230], NULL },
 		},
 	}
 };


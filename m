Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47888 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbZA2MFt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 07:05:49 -0500
Date: Thu, 29 Jan 2009 10:05:20 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: matthieu castet <castet.matthieu@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Support faulty USB IDs on DIBUSB_MC
Message-ID: <20090129100520.3331f41f@caramujo.chehab.org>
In-Reply-To: <alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de>
References: <484A72D3.7070500@free.fr>
	<4974E4BE.2060107@free.fr>
	<20090129074735.76e07d47@caramujo.chehab.org>
	<alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009 11:19:32 +0100 (CET)
Patrick Boettcher <patrick.boettcher@desy.de> wrote:

> > It doesn't sound a very good approach the need of recompiling the driver to
> > allow it to work with a broken card. The better would be to have some modprobe
> > option to force it to accept a certain USB ID as a valid ID for the card.
> 
> The most correct way would be to reprogram the eeprom, by simply writing 
> to 0xa0 (0x50 << 1) I2C address... There was a thread on the linux-dvb some 
> time ago.

Yes. Yet, it might be interesting to have some option to allow forcing.

> > The above is really ugly. IMO, we should replace this by
> > ARRAY_SIZE(dibusb_mc_properties.devices). Of course, for this to work,
> > num_device_descs should be bellow devices.
> 
> We could do that, still I'm not sure if ARRAY_SIZE will work in that 
> situation?! Are you 
> sure, Mauro?

Well, at least here, it is compiling fine. I can't really test it, since I
don't have any dib0700 devices here.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff -r 39a646207d0c linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Thu Jan 29 09:11:45 2009 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Thu Jan 29 10:04:08 2009 -0200
@@ -1447,7 +1447,7 @@
 	}
 
 struct dvb_usb_device_properties dib0700_devices[] = {
-	{
+	[0] = {
 		DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 1,
@@ -1460,7 +1460,6 @@
 			},
 		},
 
-		.num_device_descs = 8,
 		.devices = {
 			{   "DiBcom STK7700P reference design",
 				{ &dib0700_usb_id_table[0], &dib0700_usb_id_table[1] },
@@ -1496,11 +1495,13 @@
 			}
 		},
 
+		.num_device_descs = ARRAY_SIZE(dib0700_devices[0].devices),
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
 		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
 		.rc_query         = dib0700_rc_query
-	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+	},
+	[1] = { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 2,
 		.adapter = {
@@ -1517,19 +1518,20 @@
 			}
 		},
 
-		.num_device_descs = 1,
 		.devices = {
 			{   "Hauppauge Nova-T 500 Dual DVB-T",
 				{ &dib0700_usb_id_table[2], &dib0700_usb_id_table[3], NULL },
 				{ NULL },
 			},
 		},
+		.num_device_descs = ARRAY_SIZE(dib0700_devices[1].devices),
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
 		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
 		.rc_query         = dib0700_rc_query
-	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+	}, 
+	[2] = { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 2,
 		.adapter = {
@@ -1546,7 +1548,6 @@
 			}
 		},
 
-		.num_device_descs = 4,
 		.devices = {
 			{   "Pinnacle PCTV 2000e",
 				{ &dib0700_usb_id_table[11], NULL },
@@ -1566,13 +1567,15 @@
 			},
 
 		},
+		.num_device_descs = ARRAY_SIZE(dib0700_devices[2].devices),
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
 		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
 		.rc_query         = dib0700_rc_query
 
-	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+	},
+	[3] = { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 1,
 		.adapter = {
@@ -1584,7 +1587,6 @@
 			},
 		},
 
-		.num_device_descs = 3,
 		.devices = {
 			{   "ASUS My Cinema U3000 Mini DVBT Tuner",
 				{ &dib0700_usb_id_table[23], NULL },
@@ -1599,12 +1601,14 @@
 				{ NULL },
 			}
 		},
+		.num_device_descs = ARRAY_SIZE(dib0700_devices[3].devices),
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
 		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
 		.rc_query         = dib0700_rc_query
-	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+	},
+	[4] = { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 1,
 		.adapter = {
@@ -1618,7 +1622,6 @@
 			},
 		},
 
-		.num_device_descs = 9,
 		.devices = {
 			{   "DiBcom STK7070P reference design",
 				{ &dib0700_usb_id_table[15], NULL },
@@ -1657,13 +1660,15 @@
 				{ NULL },
 			},
 		},
+		.num_device_descs = ARRAY_SIZE(dib0700_devices[4].devices),
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
 		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
 		.rc_query         = dib0700_rc_query
 
-	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+	},
+	[5] = { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 2,
 		.adapter = {
@@ -1684,7 +1689,6 @@
 			}
 		},
 
-		.num_device_descs = 5,
 		.devices = {
 			{   "DiBcom STK7070PD reference design",
 				{ &dib0700_usb_id_table[17], NULL },
@@ -1707,11 +1711,13 @@
 				{ NULL },
 			}
 		},
+		.num_device_descs = ARRAY_SIZE(dib0700_devices[5].devices),
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
 		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
 		.rc_query         = dib0700_rc_query
-	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+	}, 
+	[6] = { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
 		.num_adapters = 1,
 		.adapter = {
@@ -1726,7 +1732,6 @@
 			},
 		},
 
-		.num_device_descs = 5,
 		.devices = {
 			{   "Terratec Cinergy HT USB XE",
 				{ &dib0700_usb_id_table[27], NULL },
@@ -1753,11 +1758,13 @@
 				{ NULL },
 			},
 		},
+		.num_device_descs = ARRAY_SIZE(dib0700_devices[6].devices),
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
 		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
 		.rc_query         = dib0700_rc_query
-	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+	}, 
+	[7] = { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 		.num_adapters = 1,
 		.adapter = {
 			{
@@ -1771,7 +1778,6 @@
 			},
 		},
 
-		.num_device_descs = 2,
 		.devices = {
 			{   "Pinnacle PCTV HD Pro USB Stick",
 				{ &dib0700_usb_id_table[40], NULL },
@@ -1782,6 +1788,7 @@
 				{ NULL },
 			},
 		},
+		.num_device_descs = ARRAY_SIZE(dib0700_devices[7].devices),
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
 		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),

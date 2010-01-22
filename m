Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:45361 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab0AVPLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 10:11:00 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: crope@iki.fi
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 3/4] media: dvb/af9015, refactor remote setting
Date: Fri, 22 Jan 2010 16:10:54 +0100
Message-Id: <1264173055-14787-3-git-send-email-jslaby@suse.cz>
In-Reply-To: <4B4F6BE5.2040102@iki.fi>
References: <4B4F6BE5.2040102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add af9015_setup structure to hold (right now only remote) setup
of distinct receivers.

Add af9015_setup_match for matching ids against tables.

This is for easier matching different kind of ids against tables
to obtain setups. Currently module parameters and usb vendor ids
are switched into and matched against tables. Hashes will follow.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/dvb-usb/af9015.c |  222 ++++++++++++++---------------------
 1 files changed, 89 insertions(+), 133 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index adba90d..796f9d5 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -732,98 +732,80 @@ error:
 	return ret;
 }
 
+struct af9015_setup {
+	unsigned int id;
+	struct dvb_usb_rc_key *rc_key_map;
+	unsigned int rc_key_map_size;
+	u8 *ir_table;
+	unsigned int ir_table_size;
+};
+
+static const struct af9015_setup *af9015_setup_match(unsigned int id,
+		const struct af9015_setup *table)
+{
+	for (; table->rc_key_map; table++)
+		if (table->id == id)
+			return table;
+	return NULL;
+}
+
+static const struct af9015_setup af9015_setup_modparam[] = {
+	{ AF9015_REMOTE_A_LINK_DTU_M,
+		af9015_rc_keys_a_link, ARRAY_SIZE(af9015_rc_keys_a_link),
+		af9015_ir_table_a_link, ARRAY_SIZE(af9015_ir_table_a_link) },
+	{ AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3,
+		af9015_rc_keys_msi, ARRAY_SIZE(af9015_rc_keys_msi),
+		af9015_ir_table_msi, ARRAY_SIZE(af9015_ir_table_msi) },
+	{ AF9015_REMOTE_MYGICTV_U718,
+		af9015_rc_keys_mygictv, ARRAY_SIZE(af9015_rc_keys_mygictv),
+		af9015_ir_table_mygictv, ARRAY_SIZE(af9015_ir_table_mygictv) },
+	{ AF9015_REMOTE_DIGITTRADE_DVB_T,
+		af9015_rc_keys_digittrade, ARRAY_SIZE(af9015_rc_keys_digittrade),
+		af9015_ir_table_digittrade, ARRAY_SIZE(af9015_ir_table_digittrade) },
+	{ AF9015_REMOTE_AVERMEDIA_KS,
+		af9015_rc_keys_avermedia, ARRAY_SIZE(af9015_rc_keys_avermedia),
+		af9015_ir_table_avermedia_ks, ARRAY_SIZE(af9015_ir_table_avermedia_ks) },
+	{ }
+};
+
+/* don't add new entries here anymore, use hashes instead */
+static const struct af9015_setup af9015_setup_usbids[] = {
+	{ USB_VID_LEADTEK,
+		af9015_rc_keys_leadtek, ARRAY_SIZE(af9015_rc_keys_leadtek),
+		af9015_ir_table_leadtek, ARRAY_SIZE(af9015_ir_table_leadtek) },
+	{ USB_VID_VISIONPLUS,
+		af9015_rc_keys_twinhan, ARRAY_SIZE(af9015_rc_keys_twinhan),
+		af9015_ir_table_twinhan, ARRAY_SIZE(af9015_ir_table_twinhan) },
+	{ USB_VID_KWORLD_2, /* TODO: use correct rc keys */
+		af9015_rc_keys_twinhan, ARRAY_SIZE(af9015_rc_keys_twinhan),
+		af9015_ir_table_kworld, ARRAY_SIZE(af9015_ir_table_kworld) },
+	{ USB_VID_AVERMEDIA,
+		af9015_rc_keys_avermedia, ARRAY_SIZE(af9015_rc_keys_avermedia),
+		af9015_ir_table_avermedia, ARRAY_SIZE(af9015_ir_table_avermedia) },
+	{ USB_VID_MSI_2,
+		af9015_rc_keys_msi_digivox_iii, ARRAY_SIZE(af9015_rc_keys_msi_digivox_iii),
+		af9015_ir_table_msi_digivox_iii, ARRAY_SIZE(af9015_ir_table_msi_digivox_iii) },
+	{ }
+};
+
 static void af9015_set_remote_config(struct usb_device *udev,
 		struct dvb_usb_device_properties *props)
 {
+	const struct af9015_setup *table = NULL;
+
 	if (dvb_usb_af9015_remote) {
 		/* load remote defined as module param */
-		switch (dvb_usb_af9015_remote) {
-		case AF9015_REMOTE_A_LINK_DTU_M:
-			props->rc_key_map =
-			  af9015_rc_keys_a_link;
-			props->rc_key_map_size =
-			  ARRAY_SIZE(af9015_rc_keys_a_link);
-			af9015_config.ir_table = af9015_ir_table_a_link;
-			af9015_config.ir_table_size =
-			  ARRAY_SIZE(af9015_ir_table_a_link);
-			break;
-		case AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3:
-			props->rc_key_map =
-			  af9015_rc_keys_msi;
-			props->rc_key_map_size =
-			  ARRAY_SIZE(af9015_rc_keys_msi);
-			af9015_config.ir_table = af9015_ir_table_msi;
-			af9015_config.ir_table_size =
-			  ARRAY_SIZE(af9015_ir_table_msi);
-			break;
-		case AF9015_REMOTE_MYGICTV_U718:
-			props->rc_key_map =
-			  af9015_rc_keys_mygictv;
-			props->rc_key_map_size =
-			  ARRAY_SIZE(af9015_rc_keys_mygictv);
-			af9015_config.ir_table =
-			  af9015_ir_table_mygictv;
-			af9015_config.ir_table_size =
-			  ARRAY_SIZE(af9015_ir_table_mygictv);
-			break;
-		case AF9015_REMOTE_DIGITTRADE_DVB_T:
-			props->rc_key_map =
-			  af9015_rc_keys_digittrade;
-			props->rc_key_map_size =
-			  ARRAY_SIZE(af9015_rc_keys_digittrade);
-			af9015_config.ir_table =
-			  af9015_ir_table_digittrade;
-			af9015_config.ir_table_size =
-			  ARRAY_SIZE(af9015_ir_table_digittrade);
-			break;
-		case AF9015_REMOTE_AVERMEDIA_KS:
-			props->rc_key_map =
-			  af9015_rc_keys_avermedia;
-			props->rc_key_map_size =
-			  ARRAY_SIZE(af9015_rc_keys_avermedia);
-			af9015_config.ir_table =
-			  af9015_ir_table_avermedia_ks;
-			af9015_config.ir_table_size =
-			  ARRAY_SIZE(af9015_ir_table_avermedia_ks);
-			break;
-		}
+		table = af9015_setup_match(dvb_usb_af9015_remote,
+				af9015_setup_modparam);
 	} else {
-		switch (le16_to_cpu(udev->descriptor.idVendor)) {
-		case USB_VID_LEADTEK:
-			props->rc_key_map =
-			  af9015_rc_keys_leadtek;
-			props->rc_key_map_size =
-			  ARRAY_SIZE(af9015_rc_keys_leadtek);
-			af9015_config.ir_table =
-			  af9015_ir_table_leadtek;
-			af9015_config.ir_table_size =
-			  ARRAY_SIZE(af9015_ir_table_leadtek);
-			break;
-		case USB_VID_VISIONPLUS:
-			props->rc_key_map =
-			  af9015_rc_keys_twinhan;
-			props->rc_key_map_size =
-			  ARRAY_SIZE(af9015_rc_keys_twinhan);
-			af9015_config.ir_table =
-			  af9015_ir_table_twinhan;
-			af9015_config.ir_table_size =
-			  ARRAY_SIZE(af9015_ir_table_twinhan);
-			break;
-		case USB_VID_KWORLD_2:
-			/* TODO: use correct rc keys */
-			props->rc_key_map =
-			  af9015_rc_keys_twinhan;
-			props->rc_key_map_size =
-			  ARRAY_SIZE(af9015_rc_keys_twinhan);
-			af9015_config.ir_table = af9015_ir_table_kworld;
-			af9015_config.ir_table_size =
-			  ARRAY_SIZE(af9015_ir_table_kworld);
-			break;
-		/* Check USB manufacturer and product strings and try
-		   to determine correct remote in case of chip vendor
-		   reference IDs are used. */
-		case USB_VID_AFATECH:
-		{
+		u16 vendor = le16_to_cpu(udev->descriptor.idVendor);
+
+		if (vendor == USB_VID_AFATECH) {
+			/* Check USB manufacturer and product strings and try
+			   to determine correct remote in case of chip vendor
+			   reference IDs are used.
+			   DO NOT ADD ANYTHING NEW HERE. Use hashes instead.
+			 */
 			char manufacturer[10];
 			memset(manufacturer, 0, sizeof(manufacturer));
 			usb_string(udev, udev->descriptor.iManufacturer,
@@ -831,59 +813,33 @@ static void af9015_set_remote_config(struct usb_device *udev,
 			if (!strcmp("Geniatech", manufacturer)) {
 				/* iManufacturer 1 Geniatech
 				   iProduct      2 AF9015 */
-				props->rc_key_map =
-				  af9015_rc_keys_mygictv;
-				props->rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_mygictv);
-				af9015_config.ir_table =
-				  af9015_ir_table_mygictv;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_mygictv);
+				table = af9015_setup_match(
+					AF9015_REMOTE_MYGICTV_U718,
+					af9015_setup_modparam);
 			} else if (!strcmp("MSI", manufacturer)) {
 				/* iManufacturer 1 MSI
 				   iProduct      2 MSI K-VOX */
-				props->rc_key_map =
-				  af9015_rc_keys_msi;
-				props->rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_msi);
-				af9015_config.ir_table =
-				  af9015_ir_table_msi;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_msi);
+				table = af9015_setup_match(
+					AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3,
+					af9015_setup_modparam);
 			} else if (udev->descriptor.idProduct ==
 				cpu_to_le16(USB_PID_TREKSTOR_DVBT)) {
-				props->rc_key_map =
-				  af9015_rc_keys_trekstor;
-				props->rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_trekstor);
-				af9015_config.ir_table =
-				  af9015_ir_table_trekstor;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_trekstor);
+				table = &(const struct af9015_setup){ 0,
+					af9015_rc_keys_trekstor,
+					ARRAY_SIZE(af9015_rc_keys_trekstor),
+					af9015_ir_table_trekstor,
+					ARRAY_SIZE(af9015_ir_table_trekstor)
+				};
 			}
-			break;
-		}
-		case USB_VID_AVERMEDIA:
-			props->rc_key_map =
-			  af9015_rc_keys_avermedia;
-			props->rc_key_map_size =
-			  ARRAY_SIZE(af9015_rc_keys_avermedia);
-			af9015_config.ir_table =
-			  af9015_ir_table_avermedia;
-			af9015_config.ir_table_size =
-			  ARRAY_SIZE(af9015_ir_table_avermedia);
-			break;
-		case USB_VID_MSI_2:
-			props->rc_key_map =
-			  af9015_rc_keys_msi_digivox_iii;
-			props->rc_key_map_size =
-			  ARRAY_SIZE(af9015_rc_keys_msi_digivox_iii);
-			af9015_config.ir_table =
-			  af9015_ir_table_msi_digivox_iii;
-			af9015_config.ir_table_size =
-			  ARRAY_SIZE(af9015_ir_table_msi_digivox_iii);
-			break;
-		}
+		} else
+			table = af9015_setup_match(vendor, af9015_setup_usbids);
+	}
+
+	if (table) {
+		props->rc_key_map = table->rc_key_map;
+		props->rc_key_map_size = table->rc_key_map_size;
+		af9015_config.ir_table = table->ir_table;
+		af9015_config.ir_table_size = table->ir_table_size;
 	}
 }
 
-- 
1.6.5.7


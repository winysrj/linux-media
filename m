Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:45353 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0AVPLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 10:11:00 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: crope@iki.fi
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 2/4] media: dvb/af9015, factor out remote setting
Date: Fri, 22 Jan 2010 16:10:53 +0100
Message-Id: <1264173055-14787-2-git-send-email-jslaby@suse.cz>
In-Reply-To: <4B4F6BE5.2040102@iki.fi>
References: <4B4F6BE5.2040102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is just a code shuffle without functional changes. For easier
review of later changes, i.e. preparation.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/dvb-usb/af9015.c |  305 ++++++++++++++++++-----------------
 1 files changed, 157 insertions(+), 148 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 616b3ba..adba90d 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -732,12 +732,166 @@ error:
 	return ret;
 }
 
+static void af9015_set_remote_config(struct usb_device *udev,
+		struct dvb_usb_device_properties *props)
+{
+	if (dvb_usb_af9015_remote) {
+		/* load remote defined as module param */
+		switch (dvb_usb_af9015_remote) {
+		case AF9015_REMOTE_A_LINK_DTU_M:
+			props->rc_key_map =
+			  af9015_rc_keys_a_link;
+			props->rc_key_map_size =
+			  ARRAY_SIZE(af9015_rc_keys_a_link);
+			af9015_config.ir_table = af9015_ir_table_a_link;
+			af9015_config.ir_table_size =
+			  ARRAY_SIZE(af9015_ir_table_a_link);
+			break;
+		case AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3:
+			props->rc_key_map =
+			  af9015_rc_keys_msi;
+			props->rc_key_map_size =
+			  ARRAY_SIZE(af9015_rc_keys_msi);
+			af9015_config.ir_table = af9015_ir_table_msi;
+			af9015_config.ir_table_size =
+			  ARRAY_SIZE(af9015_ir_table_msi);
+			break;
+		case AF9015_REMOTE_MYGICTV_U718:
+			props->rc_key_map =
+			  af9015_rc_keys_mygictv;
+			props->rc_key_map_size =
+			  ARRAY_SIZE(af9015_rc_keys_mygictv);
+			af9015_config.ir_table =
+			  af9015_ir_table_mygictv;
+			af9015_config.ir_table_size =
+			  ARRAY_SIZE(af9015_ir_table_mygictv);
+			break;
+		case AF9015_REMOTE_DIGITTRADE_DVB_T:
+			props->rc_key_map =
+			  af9015_rc_keys_digittrade;
+			props->rc_key_map_size =
+			  ARRAY_SIZE(af9015_rc_keys_digittrade);
+			af9015_config.ir_table =
+			  af9015_ir_table_digittrade;
+			af9015_config.ir_table_size =
+			  ARRAY_SIZE(af9015_ir_table_digittrade);
+			break;
+		case AF9015_REMOTE_AVERMEDIA_KS:
+			props->rc_key_map =
+			  af9015_rc_keys_avermedia;
+			props->rc_key_map_size =
+			  ARRAY_SIZE(af9015_rc_keys_avermedia);
+			af9015_config.ir_table =
+			  af9015_ir_table_avermedia_ks;
+			af9015_config.ir_table_size =
+			  ARRAY_SIZE(af9015_ir_table_avermedia_ks);
+			break;
+		}
+	} else {
+		switch (le16_to_cpu(udev->descriptor.idVendor)) {
+		case USB_VID_LEADTEK:
+			props->rc_key_map =
+			  af9015_rc_keys_leadtek;
+			props->rc_key_map_size =
+			  ARRAY_SIZE(af9015_rc_keys_leadtek);
+			af9015_config.ir_table =
+			  af9015_ir_table_leadtek;
+			af9015_config.ir_table_size =
+			  ARRAY_SIZE(af9015_ir_table_leadtek);
+			break;
+		case USB_VID_VISIONPLUS:
+			props->rc_key_map =
+			  af9015_rc_keys_twinhan;
+			props->rc_key_map_size =
+			  ARRAY_SIZE(af9015_rc_keys_twinhan);
+			af9015_config.ir_table =
+			  af9015_ir_table_twinhan;
+			af9015_config.ir_table_size =
+			  ARRAY_SIZE(af9015_ir_table_twinhan);
+			break;
+		case USB_VID_KWORLD_2:
+			/* TODO: use correct rc keys */
+			props->rc_key_map =
+			  af9015_rc_keys_twinhan;
+			props->rc_key_map_size =
+			  ARRAY_SIZE(af9015_rc_keys_twinhan);
+			af9015_config.ir_table = af9015_ir_table_kworld;
+			af9015_config.ir_table_size =
+			  ARRAY_SIZE(af9015_ir_table_kworld);
+			break;
+		/* Check USB manufacturer and product strings and try
+		   to determine correct remote in case of chip vendor
+		   reference IDs are used. */
+		case USB_VID_AFATECH:
+		{
+			char manufacturer[10];
+			memset(manufacturer, 0, sizeof(manufacturer));
+			usb_string(udev, udev->descriptor.iManufacturer,
+				manufacturer, sizeof(manufacturer));
+			if (!strcmp("Geniatech", manufacturer)) {
+				/* iManufacturer 1 Geniatech
+				   iProduct      2 AF9015 */
+				props->rc_key_map =
+				  af9015_rc_keys_mygictv;
+				props->rc_key_map_size =
+				  ARRAY_SIZE(af9015_rc_keys_mygictv);
+				af9015_config.ir_table =
+				  af9015_ir_table_mygictv;
+				af9015_config.ir_table_size =
+				  ARRAY_SIZE(af9015_ir_table_mygictv);
+			} else if (!strcmp("MSI", manufacturer)) {
+				/* iManufacturer 1 MSI
+				   iProduct      2 MSI K-VOX */
+				props->rc_key_map =
+				  af9015_rc_keys_msi;
+				props->rc_key_map_size =
+				  ARRAY_SIZE(af9015_rc_keys_msi);
+				af9015_config.ir_table =
+				  af9015_ir_table_msi;
+				af9015_config.ir_table_size =
+				  ARRAY_SIZE(af9015_ir_table_msi);
+			} else if (udev->descriptor.idProduct ==
+				cpu_to_le16(USB_PID_TREKSTOR_DVBT)) {
+				props->rc_key_map =
+				  af9015_rc_keys_trekstor;
+				props->rc_key_map_size =
+				  ARRAY_SIZE(af9015_rc_keys_trekstor);
+				af9015_config.ir_table =
+				  af9015_ir_table_trekstor;
+				af9015_config.ir_table_size =
+				  ARRAY_SIZE(af9015_ir_table_trekstor);
+			}
+			break;
+		}
+		case USB_VID_AVERMEDIA:
+			props->rc_key_map =
+			  af9015_rc_keys_avermedia;
+			props->rc_key_map_size =
+			  ARRAY_SIZE(af9015_rc_keys_avermedia);
+			af9015_config.ir_table =
+			  af9015_ir_table_avermedia;
+			af9015_config.ir_table_size =
+			  ARRAY_SIZE(af9015_ir_table_avermedia);
+			break;
+		case USB_VID_MSI_2:
+			props->rc_key_map =
+			  af9015_rc_keys_msi_digivox_iii;
+			props->rc_key_map_size =
+			  ARRAY_SIZE(af9015_rc_keys_msi_digivox_iii);
+			af9015_config.ir_table =
+			  af9015_ir_table_msi_digivox_iii;
+			af9015_config.ir_table_size =
+			  ARRAY_SIZE(af9015_ir_table_msi_digivox_iii);
+			break;
+		}
+	}
+}
+
 static int af9015_read_config(struct usb_device *udev)
 {
 	int ret;
 	u8 val, i, offset = 0;
 	struct req_t req = {READ_I2C, AF9015_I2C_EEPROM, 0, 0, 1, 1, &val};
-	char manufacturer[10];
 
 	/* IR remote controller */
 	req.addr = AF9015_EEPROM_IR_MODE;
@@ -759,153 +913,8 @@ static int af9015_read_config(struct usb_device *udev)
 		if (val == AF9015_IR_MODE_DISABLED) {
 			af9015_properties[i].rc_key_map = NULL;
 			af9015_properties[i].rc_key_map_size  = 0;
-		} else if (dvb_usb_af9015_remote) {
-			/* load remote defined as module param */
-			switch (dvb_usb_af9015_remote) {
-			case AF9015_REMOTE_A_LINK_DTU_M:
-				af9015_properties[i].rc_key_map =
-				  af9015_rc_keys_a_link;
-				af9015_properties[i].rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_a_link);
-				af9015_config.ir_table = af9015_ir_table_a_link;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_a_link);
-				break;
-			case AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3:
-				af9015_properties[i].rc_key_map =
-				  af9015_rc_keys_msi;
-				af9015_properties[i].rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_msi);
-				af9015_config.ir_table = af9015_ir_table_msi;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_msi);
-				break;
-			case AF9015_REMOTE_MYGICTV_U718:
-				af9015_properties[i].rc_key_map =
-				  af9015_rc_keys_mygictv;
-				af9015_properties[i].rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_mygictv);
-				af9015_config.ir_table =
-				  af9015_ir_table_mygictv;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_mygictv);
-				break;
-			case AF9015_REMOTE_DIGITTRADE_DVB_T:
-				af9015_properties[i].rc_key_map =
-				  af9015_rc_keys_digittrade;
-				af9015_properties[i].rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_digittrade);
-				af9015_config.ir_table =
-				  af9015_ir_table_digittrade;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_digittrade);
-				break;
-			case AF9015_REMOTE_AVERMEDIA_KS:
-				af9015_properties[i].rc_key_map =
-				  af9015_rc_keys_avermedia;
-				af9015_properties[i].rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_avermedia);
-				af9015_config.ir_table =
-				  af9015_ir_table_avermedia_ks;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_avermedia_ks);
-				break;
-			}
-		} else {
-			switch (le16_to_cpu(udev->descriptor.idVendor)) {
-			case USB_VID_LEADTEK:
-				af9015_properties[i].rc_key_map =
-				  af9015_rc_keys_leadtek;
-				af9015_properties[i].rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_leadtek);
-				af9015_config.ir_table =
-				  af9015_ir_table_leadtek;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_leadtek);
-				break;
-			case USB_VID_VISIONPLUS:
-				af9015_properties[i].rc_key_map =
-				  af9015_rc_keys_twinhan;
-				af9015_properties[i].rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_twinhan);
-				af9015_config.ir_table =
-				  af9015_ir_table_twinhan;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_twinhan);
-				break;
-			case USB_VID_KWORLD_2:
-				/* TODO: use correct rc keys */
-				af9015_properties[i].rc_key_map =
-				  af9015_rc_keys_twinhan;
-				af9015_properties[i].rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_twinhan);
-				af9015_config.ir_table = af9015_ir_table_kworld;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_kworld);
-				break;
-			/* Check USB manufacturer and product strings and try
-			   to determine correct remote in case of chip vendor
-			   reference IDs are used. */
-			case USB_VID_AFATECH:
-				memset(manufacturer, 0, sizeof(manufacturer));
-				usb_string(udev, udev->descriptor.iManufacturer,
-					manufacturer, sizeof(manufacturer));
-				if (!strcmp("Geniatech", manufacturer)) {
-					/* iManufacturer 1 Geniatech
-					   iProduct      2 AF9015 */
-					af9015_properties[i].rc_key_map =
-					  af9015_rc_keys_mygictv;
-					af9015_properties[i].rc_key_map_size =
-					  ARRAY_SIZE(af9015_rc_keys_mygictv);
-					af9015_config.ir_table =
-					  af9015_ir_table_mygictv;
-					af9015_config.ir_table_size =
-					  ARRAY_SIZE(af9015_ir_table_mygictv);
-				} else if (!strcmp("MSI", manufacturer)) {
-					/* iManufacturer 1 MSI
-					   iProduct      2 MSI K-VOX */
-					af9015_properties[i].rc_key_map =
-					  af9015_rc_keys_msi;
-					af9015_properties[i].rc_key_map_size =
-					  ARRAY_SIZE(af9015_rc_keys_msi);
-					af9015_config.ir_table =
-					  af9015_ir_table_msi;
-					af9015_config.ir_table_size =
-					  ARRAY_SIZE(af9015_ir_table_msi);
-				} else if (udev->descriptor.idProduct ==
-					cpu_to_le16(USB_PID_TREKSTOR_DVBT)) {
-					af9015_properties[i].rc_key_map =
-					  af9015_rc_keys_trekstor;
-					af9015_properties[i].rc_key_map_size =
-					  ARRAY_SIZE(af9015_rc_keys_trekstor);
-					af9015_config.ir_table =
-					  af9015_ir_table_trekstor;
-					af9015_config.ir_table_size =
-					  ARRAY_SIZE(af9015_ir_table_trekstor);
-				}
-				break;
-			case USB_VID_AVERMEDIA:
-				af9015_properties[i].rc_key_map =
-				  af9015_rc_keys_avermedia;
-				af9015_properties[i].rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_avermedia);
-				af9015_config.ir_table =
-				  af9015_ir_table_avermedia;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_avermedia);
-				break;
-			case USB_VID_MSI_2:
-				af9015_properties[i].rc_key_map =
-				  af9015_rc_keys_msi_digivox_iii;
-				af9015_properties[i].rc_key_map_size =
-				  ARRAY_SIZE(af9015_rc_keys_msi_digivox_iii);
-				af9015_config.ir_table =
-				  af9015_ir_table_msi_digivox_iii;
-				af9015_config.ir_table_size =
-				  ARRAY_SIZE(af9015_ir_table_msi_digivox_iii);
-				break;
-			}
-		}
+		} else
+			af9015_set_remote_config(udev, &af9015_properties[i]);
 	}
 
 	/* TS mode - one or two receivers */
-- 
1.6.5.7


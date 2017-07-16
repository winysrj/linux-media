Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46235 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751247AbdGPAni (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:38 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 10/16] [media] dvb-core/dvb_ca_en50221.c: Fixed C++ comments
Date: Sun, 16 Jul 2017 02:43:11 +0200
Message-Id: <1500165797-16987-11-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

- Changed all C++ style comments ("// ..") to C style ones ("/* .. */").

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 6547f6e..99cf460 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -263,7 +263,7 @@ static int dvb_ca_en50221_check_camstatus(struct dvb_ca_private *ca, int slot)
 	} else {
 		if ((sl->slot_state == DVB_CA_SLOTSTATE_WAITREADY) &&
 		    (slot_status & DVB_CA_EN50221_POLL_CAM_READY)) {
-			// move to validate state if reset is completed
+			/* move to validate state if reset is completed */
 			sl->slot_state = DVB_CA_SLOTSTATE_VALIDATE;
 		}
 	}
@@ -442,7 +442,7 @@ static int dvb_ca_en50221_read_tuple(struct dvb_ca_private *ca, int slot,
 	}
 	_address += (_tuple_length * 2);
 
-	// success
+	/* success */
 	*tuple_type = _tuple_type;
 	*tuple_length = _tuple_length;
 	*address = _address;
@@ -476,7 +476,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 	u16 devid = 0;
 
 
-	// CISTPL_DEVICE_0A
+	/* CISTPL_DEVICE_0A */
 	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
 					   &tuple_length, tuple);
 	if (status < 0)
@@ -486,7 +486,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 
-	// CISTPL_DEVICE_0C
+	/* CISTPL_DEVICE_0C */
 	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
 					   &tuple_length, tuple);
 	if (status < 0)
@@ -496,7 +496,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 
-	// CISTPL_VERS_1
+	/* CISTPL_VERS_1 */
 	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
 					   &tuple_length, tuple);
 	if (status < 0)
@@ -506,7 +506,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 
-	// CISTPL_MANFID
+	/* CISTPL_MANFID */
 	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
 					   &tuple_length, tuple);
 	if (status < 0)
@@ -520,7 +520,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 
 
-	// CISTPL_CONFIG
+	/* CISTPL_CONFIG */
 	status = dvb_ca_en50221_read_tuple(ca, slot, &address, &tuple_type,
 					   &tuple_length, tuple);
 	if (status < 0)
@@ -562,7 +562,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 		if (status < 0)
 			return status;
 		switch (tuple_type) {
-		case 0x1B:	// CISTPL_CFTABLE_ENTRY
+		case 0x1B:	/* CISTPL_CFTABLE_ENTRY */
 			if (tuple_length < (2 + 11 + 17))
 				break;
 
@@ -583,10 +583,10 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 			got_cftableentry = 1;
 			break;
 
-		case 0x14:	// CISTPL_NO_LINK
+		case 0x14:	/* CISTPL_NO_LINK */
 			break;
 
-		case 0xFF:	// CISTPL_END
+		case 0xFF:	/* CISTPL_END */
 			end_chain = 1;
 			break;
 
@@ -603,7 +603,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 	dprintk("Valid DVB CAM detected MANID:%x DEVID:%x CONFIGBASE:0x%x CONFIGOPTION:0x%x\n",
 		manfid, devid, sl->config_base, sl->config_option);
 
-	// success!
+	/* success! */
 	return 0;
 }
 
-- 
2.7.4

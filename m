Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0HAUSb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Aug 2010 16:18:31 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o71KIV20027621
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 1 Aug 2010 16:18:31 -0400
Received: from pedra (vpn-10-244.rdu.redhat.com [10.11.10.244])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o71KIMmd018029
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 1 Aug 2010 16:18:30 -0400
Date: Sun, 1 Aug 2010 17:17:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/6] V4L/DVB: dib0700: Fix RC protocol logic to properly
 handle NEC/NECx and RC-5
Message-ID: <20100801171716.2e84d901@pedra>
In-Reply-To: <cover.1280693675.git.mchehab@redhat.com>
References: <cover.1280693675.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplifies the logic for handling firmware 1.20 RC messages, fixing the
logic.

While here, I tried to use a RC-6 remote controller from my TV set, but it
didn't work with dib0700. Not sure why, but maybe this never worked.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index d73a688..fe81834 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -499,7 +499,7 @@ int dib0700_change_protocol(void *priv, u64 ir_type)
 		return ret;
 	}
 
-	d->props.rc.core.protocol = new_proto;
+	d->props.rc.core.protocol = ir_type;
 
 	return ret;
 }
@@ -511,7 +511,13 @@ int dib0700_change_protocol(void *priv, u64 ir_type)
 struct dib0700_rc_response {
 	u8 report_id;
 	u8 data_state;
-	u16 system;
+	union {
+		u16 system16;
+		struct {
+			u8 system;
+			u8 not_system;
+		};
+	};
 	u8 data;
 	u8 not_data;
 };
@@ -521,9 +527,8 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 {
 	struct dvb_usb_device *d = purb->context;
 	struct dib0700_state *st;
-	struct dib0700_rc_response poll_reply;
-	u8 *buf;
-	u32 keycode;
+	struct dib0700_rc_response *poll_reply;
+	u32 uninitialized_var(keycode);
 	u8 toggle;
 
 	deb_info("%s()\n", __func__);
@@ -537,7 +542,7 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 	}
 
 	st = d->priv;
-	buf = (u8 *)purb->transfer_buffer;
+	poll_reply = purb->transfer_buffer;
 
 	if (purb->status < 0) {
 		deb_info("discontinuing polling\n");
@@ -550,52 +555,51 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		goto resubmit;
 	}
 
-	deb_data("IR raw %02X %02X %02X %02X %02X %02X (len %d)\n", buf[0],
-		 buf[1], buf[2], buf[3], buf[4], buf[5], purb->actual_length);
+	deb_data("IR ID = %02X state = %02X System = %02X %02X Cmd = %02X %02X (len %d)\n",
+		 poll_reply->report_id, poll_reply->data_state,
+		 poll_reply->system, poll_reply->not_system,
+		 poll_reply->data, poll_reply->not_data,
+		 purb->actual_length);
 
 	switch (d->props.rc.core.protocol) {
 	case IR_TYPE_NEC:
-		poll_reply.data_state = 0;
-		poll_reply.system     = buf[2];
-		poll_reply.data       = buf[4];
-		poll_reply.not_data   = buf[5];
 		toggle = 0;
 
 		/* NEC protocol sends repeat code as 0 0 0 FF */
-		if ((poll_reply.system == 0x00) && (poll_reply.data == 0x00)
-		    && (poll_reply.not_data == 0xff)) {
-			poll_reply.data_state = 2;
+		if ((poll_reply->system == 0x00) && (poll_reply->data == 0x00)
+		    && (poll_reply->not_data == 0xff)) {
+			poll_reply->data_state = 2;
 			break;
 		}
 
+		if ((poll_reply->system ^ poll_reply->not_system) != 0xff) {
+			deb_data("NEC extended protocol\n");
+			/* NEC extended code - 24 bits */
+			keycode = poll_reply->system16 << 8 | poll_reply->data;
+		} else {
+			deb_data("NEC normal protocol\n");
+			/* normal NEC code - 16 bits */
+			keycode = poll_reply->system << 8 | poll_reply->data;
+		}
+
 		break;
 	default:
+		deb_data("RC5 protocol\n");
 		/* RC5 Protocol */
-		/* TODO: need to check the mapping for RC6 */
-		poll_reply.report_id  = buf[0];
-		poll_reply.data_state = buf[1];
-		poll_reply.system     = (buf[2] << 8) | buf[3];
-		poll_reply.data       = buf[4];
-		poll_reply.not_data   = buf[5];
-
-		toggle = poll_reply.report_id;
+		toggle = poll_reply->report_id;
+		keycode = poll_reply->system16 << 8 | poll_reply->data;
 
 		break;
 	}
 
-	if ((poll_reply.data + poll_reply.not_data) != 0xff) {
+	if ((poll_reply->data + poll_reply->not_data) != 0xff) {
 		/* Key failed integrity check */
 		err("key failed integrity check: %04x %02x %02x",
-		    poll_reply.system,
-		    poll_reply.data, poll_reply.not_data);
+		    poll_reply->system,
+		    poll_reply->data, poll_reply->not_data);
 		goto resubmit;
 	}
 
-	deb_data("rid=%02x ds=%02x sm=%04x d=%02x nd=%02x\n",
-		 poll_reply.report_id, poll_reply.data_state,
-		 poll_reply.system, poll_reply.data, poll_reply.not_data);
-
-	keycode = poll_reply.system << 8 | poll_reply.data;
 	ir_keydown(d->rc_input_dev, keycode, toggle);
 
 resubmit:
-- 
1.7.1



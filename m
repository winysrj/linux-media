Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:58731 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753402AbdKXLoF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 06:44:05 -0500
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 3/3] media: cec: move cec autorepeat handling to rc-core
Date: Fri, 24 Nov 2017 11:44:01 +0000
Message-Id: <7cbde018f677ba69b012142bee517e0d7b08ce13.1511523174.git.sean@mess.org>
In-Reply-To: <cover.1511523174.git.sean@mess.org>
References: <cover.1511523174.git.sean@mess.org>
In-Reply-To: <cover.1511523174.git.sean@mess.org>
References: <cover.1511523174.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CEC autorepeat is different than other protocols. Autorepeat is triggered
by the first repeated user control pressed CEC message, rather than a
fixed REP_DELAY.

This change also does away with the KEY_UP event directly after the first
KEY_DOWN event, which was used to stop autorepeat from starting.

See commit a9a249a2c997 ("media: cec: fix remote control passthrough")
for the original change.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/cec/cec-adap.c | 56 ++++----------------------------------------
 drivers/media/cec/cec-core.c | 12 ----------
 drivers/media/rc/rc-main.c   | 10 +++++++-
 include/media/cec.h          |  5 ----
 4 files changed, 14 insertions(+), 69 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 98f88c43f62c..258a91800963 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1788,9 +1788,6 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	int la_idx = cec_log_addr2idx(adap, dest_laddr);
 	bool from_unregistered = init_laddr == 0xf;
 	struct cec_msg tx_cec_msg = { };
-#ifdef CONFIG_MEDIA_CEC_RC
-	int scancode;
-#endif
 
 	dprintk(2, "%s: %*ph\n", __func__, msg->len, msg->msg);
 
@@ -1886,9 +1883,11 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		 */
 		case 0x60:
 			if (msg->len == 2)
-				scancode = msg->msg[2];
+				rc_keydown(adap->rc, RC_PROTO_CEC,
+					   msg->msg[2], 0);
 			else
-				scancode = msg->msg[2] << 8 | msg->msg[3];
+				rc_keydown(adap->rc, RC_PROTO_CEC,
+					   msg->msg[2] << 8 | msg->msg[3], 0);
 			break;
 		/*
 		 * Other function messages that are not handled.
@@ -1901,54 +1900,11 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		 */
 		case 0x56: case 0x57:
 		case 0x67: case 0x68: case 0x69: case 0x6a:
-			scancode = -1;
 			break;
 		default:
-			scancode = msg->msg[2];
-			break;
-		}
-
-		/* Was repeating, but keypress timed out */
-		if (adap->rc_repeating && !adap->rc->keypressed) {
-			adap->rc_repeating = false;
-			adap->rc_last_scancode = -1;
-		}
-		/* Different keypress from last time, ends repeat mode */
-		if (adap->rc_last_scancode != scancode) {
-			rc_keyup(adap->rc);
-			adap->rc_repeating = false;
-		}
-		/* We can't handle this scancode */
-		if (scancode < 0) {
-			adap->rc_last_scancode = scancode;
-			break;
-		}
-
-		/* Send key press */
-		rc_keydown(adap->rc, RC_PROTO_CEC, scancode, 0);
-
-		/* When in repeating mode, we're done */
-		if (adap->rc_repeating)
-			break;
-
-		/*
-		 * We are not repeating, but the new scancode is
-		 * the same as the last one, and this second key press is
-		 * within 550 ms (the 'Follower Safety Timeout') from the
-		 * previous key press, so we now enable the repeating mode.
-		 */
-		if (adap->rc_last_scancode == scancode &&
-		    msg->rx_ts - adap->rc_last_keypress < 550 * NSEC_PER_MSEC) {
-			adap->rc_repeating = true;
+			rc_keydown(adap->rc, RC_PROTO_CEC, msg->msg[2], 0);
 			break;
 		}
-		/*
-		 * Not in repeating mode, so avoid triggering repeat mode
-		 * by calling keyup.
-		 */
-		rc_keyup(adap->rc);
-		adap->rc_last_scancode = scancode;
-		adap->rc_last_keypress = msg->rx_ts;
 #endif
 		break;
 
@@ -1958,8 +1914,6 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 			break;
 #ifdef CONFIG_MEDIA_CEC_RC
 		rc_keyup(adap->rc);
-		adap->rc_repeating = false;
-		adap->rc_last_scancode = -1;
 #endif
 		break;
 
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 5870da6a567f..3c67af511c66 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -280,7 +280,6 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	adap->rc->priv = adap;
 	adap->rc->map_name = RC_MAP_CEC;
 	adap->rc->timeout = MS_TO_NS(100);
-	adap->rc_last_scancode = -1;
 #endif
 	return adap;
 }
@@ -312,17 +311,6 @@ int cec_register_adapter(struct cec_adapter *adap,
 			adap->rc = NULL;
 			return res;
 		}
-		/*
-		 * The REP_DELAY for CEC is really the time between the initial
-		 * 'User Control Pressed' message and the second. The first
-		 * keypress is always seen as non-repeating, the second
-		 * (provided it has the same UI Command) will start the 'Press
-		 * and Hold' (aka repeat) behavior. By setting REP_DELAY to the
-		 * same value as REP_PERIOD the expected CEC behavior is
-		 * reproduced.
-		 */
-		adap->rc->input_dev->rep[REP_DELAY] =
-			adap->rc->input_dev->rep[REP_PERIOD];
 	}
 #endif
 
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 17950e29d4e3..4cf0b51be6c9 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -719,6 +719,11 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_proto protocol,
 		led_trigger_event(led_feedback, LED_FULL);
 	}
 
+	/* For CEC, ensure that repeated messages trigger repeat */
+	if (!new_event && keycode != KEY_RESERVED &&
+	    dev->allowed_protocols == RC_PROTO_BIT_CEC)
+		input_event(dev->input_dev, EV_KEY, keycode, 3);
+
 	input_sync(dev->input_dev);
 }
 
@@ -1704,7 +1709,10 @@ static int rc_setup_rx_device(struct rc_dev *dev)
 	 * to avoid wrong repetition of the keycodes. Note that this must be
 	 * set after the call to input_register_device().
 	 */
-	dev->input_dev->rep[REP_DELAY] = 500;
+	if (dev->allowed_protocols == RC_PROTO_BIT_CEC)
+		dev->input_dev->rep[REP_DELAY] = 0;
+	else
+		dev->input_dev->rep[REP_DELAY] = 500;
 
 	/*
 	 * As a repeat event on protocols like RC-5 and NEC take as long as
diff --git a/include/media/cec.h b/include/media/cec.h
index 16341210d3ba..5db31bbdf133 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -191,11 +191,6 @@ struct cec_adapter {
 
 	u32 tx_timeouts;
 
-#ifdef CONFIG_MEDIA_CEC_RC
-	bool rc_repeating;
-	int rc_last_scancode;
-	u64 rc_last_keypress;
-#endif
 #ifdef CONFIG_CEC_NOTIFIER
 	struct cec_notifier *notifier;
 #endif
-- 
2.14.3

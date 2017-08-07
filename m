Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:60521 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751872AbdHGNb1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 09:31:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sean Young <sean@mess.org>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] cec: fix remote control passthrough
Date: Mon,  7 Aug 2017 15:31:24 +0200
Message-Id: <20170807133124.30682-3-hverkuil@xs4all.nl>
In-Reply-To: <20170807133124.30682-1-hverkuil@xs4all.nl>
References: <20170807133124.30682-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The 'Press and Hold' operation was not correctly implemented, in
particular the requirement that the repeat doesn't start until
the second identical keypress arrives. The REP_DELAY value also
had to be adjusted (see the comment in the code) to achieve the
desired behavior.

The 'enabled_protocols' field was also never set, fix that too. Since
CEC is a fixed protocol the driver has to set this field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 56 ++++++++++++++++++++++++++++++++++++++++----
 drivers/media/cec/cec-core.c | 13 ++++++++++
 include/media/cec.h          |  5 ++++
 3 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 1a021828c8d4..6a2f38f000e8 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1766,6 +1766,9 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	int la_idx = cec_log_addr2idx(adap, dest_laddr);
 	bool from_unregistered = init_laddr == 0xf;
 	struct cec_msg tx_cec_msg = { };
+#ifdef CONFIG_MEDIA_CEC_RC
+	int scancode;
+#endif
 
 	dprintk(2, "%s: %*ph\n", __func__, msg->len, msg->msg);
 
@@ -1854,11 +1857,9 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		 */
 		case 0x60:
 			if (msg->len == 2)
-				rc_keydown(adap->rc, RC_TYPE_CEC,
-					   msg->msg[2], 0);
+				scancode = msg->msg[2];
 			else
-				rc_keydown(adap->rc, RC_TYPE_CEC,
-					   msg->msg[2] << 8 | msg->msg[3], 0);
+				scancode = msg->msg[2] << 8 | msg->msg[3];
 			break;
 		/*
 		 * Other function messages that are not handled.
@@ -1871,11 +1872,54 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		 */
 		case 0x56: case 0x57:
 		case 0x67: case 0x68: case 0x69: case 0x6a:
+			scancode = -1;
 			break;
 		default:
-			rc_keydown(adap->rc, RC_TYPE_CEC, msg->msg[2], 0);
+			scancode = msg->msg[2];
+			break;
+		}
+
+		/* Was repeating, but keypress timed out */
+		if (adap->rc_repeating && !adap->rc->keypressed) {
+			adap->rc_repeating = false;
+			adap->rc_last_scancode = -1;
+		}
+		/* Different keypress from last time, ends repeat mode */
+		if (adap->rc_last_scancode != scancode) {
+			rc_keyup(adap->rc);
+			adap->rc_repeating = false;
+		}
+		/* We can't handle this scancode */
+		if (scancode < 0) {
+			adap->rc_last_scancode = scancode;
+			break;
+		}
+
+		/* Send key press */
+		rc_keydown(adap->rc, RC_TYPE_CEC, scancode, 0);
+
+		/* When in repeating mode, we're done */
+		if (adap->rc_repeating)
+			break;
+
+		/*
+		 * We are not repeating, but the new scancode is
+		 * the same as the last one, and this second key press is
+		 * within 550 ms (the 'Follower Safety Timeout') from the
+		 * previous key press, so we now enable the repeating mode.
+		 */
+		if (adap->rc_last_scancode == scancode &&
+		    msg->rx_ts - adap->rc_last_keypress < 550 * NSEC_PER_MSEC) {
+			adap->rc_repeating = true;
 			break;
 		}
+		/*
+		 * Not in repeating mode, so avoid triggering repeat mode
+		 * by calling keyup.
+		 */
+		rc_keyup(adap->rc);
+		adap->rc_last_scancode = scancode;
+		adap->rc_last_keypress = msg->rx_ts;
 #endif
 		break;
 
@@ -1885,6 +1929,8 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 			break;
 #ifdef CONFIG_MEDIA_CEC_RC
 		rc_keyup(adap->rc);
+		adap->rc_repeating = false;
+		adap->rc_last_scancode = -1;
 #endif
 		break;
 
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 52f085ba104a..018a95cae6b0 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -276,9 +276,11 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	adap->rc->input_id.version = 1;
 	adap->rc->driver_name = CEC_NAME;
 	adap->rc->allowed_protocols = RC_BIT_CEC;
+	adap->rc->enabled_protocols = RC_BIT_CEC;
 	adap->rc->priv = adap;
 	adap->rc->map_name = RC_MAP_CEC;
 	adap->rc->timeout = MS_TO_NS(100);
+	adap->rc_last_scancode = -1;
 #endif
 	return adap;
 }
@@ -310,6 +312,17 @@ int cec_register_adapter(struct cec_adapter *adap,
 			adap->rc = NULL;
 			return res;
 		}
+		/*
+		 * The REP_DELAY for CEC is really the time between the initial
+		 * 'User Control Pressed' message and the second. The first
+		 * keypress is always seen as non-repeating, the second
+		 * (provided it has the same UI Command) will start the 'Press
+		 * and Hold' (aka repeat) behavior. By setting REP_DELAY to the
+		 * same value as REP_PERIOD the expected CEC behavior is
+		 * reproduced.
+		 */
+		adap->rc->input_dev->rep[REP_DELAY] =
+			adap->rc->input_dev->rep[REP_PERIOD];
 	}
 #endif
 
diff --git a/include/media/cec.h b/include/media/cec.h
index 224a6e225c52..be3b243a0d5e 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -187,6 +187,11 @@ struct cec_adapter {
 
 	u32 tx_timeouts;
 
+#ifdef CONFIG_MEDIA_CEC_RC
+	bool rc_repeating;
+	int rc_last_scancode;
+	u64 rc_last_keypress;
+#endif
 #ifdef CONFIG_CEC_NOTIFIER
 	struct cec_notifier *notifier;
 #endif
-- 
2.13.2

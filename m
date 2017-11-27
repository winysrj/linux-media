Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48883 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751505AbdK0Jr0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 04:47:26 -0500
Date: Mon, 27 Nov 2017 09:47:24 +0000
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] Improve CEC autorepeat handling
Message-ID: <20171127094724.6cjl6zex46y6wgfd@gofer.mess.org>
References: <cover.1511523174.git.sean@mess.org>
 <20171125234752.2z46d3ya7qiaovby@dtor-ws>
 <27b40fb8-a422-e43d-45d4-b4f763f7b82a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27b40fb8-a422-e43d-45d4-b4f763f7b82a@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Nov 27, 2017 at 10:13:51AM +0100, Hans Verkuil wrote:
> On 11/26/2017 12:47 AM, Dmitry Torokhov wrote:
> > On Fri, Nov 24, 2017 at 11:43:58AM +0000, Sean Young wrote:
> >> Due to the slowness of the CEC bus, autorepeat handling rather special
> >> on CEC. If the repeated user control pressed message is received, a 
> >> keydown repeat should be sent immediately.
> > 
> > This sounds like you want to have hardware autorepeat combined with
> > software one. This seems fairly specific to CEC and I do not think that
> > this should be in input core; but stay in the driver.
> > 
> > Another option just to decide what common delay for CEC autorepeat is
> > and rely on the standard autorepeat handling. The benefit is that users
> > can control the delay before autorepeat kicks in.
> 
> They are not allowed to. Autorepeat is only allowed to start when a second
> keydown message arrives within 550 ms as per the spec. After that autorepeat
> continues as long as keydown messages are received within 550ms from the
> previous one. The actual REP_PERIOD time is unrelated to the frequency of
> the CEC messages but should be that of the local system.
> 
> The thing to remember here is that CEC is slooow (400 bits/s) so you cannot
> send messages at REP_PERIOD rate. You should see it as messages that tell
> you to enter/stay in autorepeat mode. Not as actual autorepeat messages.
> 
> > 
> >>
> >> By handling this in the input layer, we can remove some ugly code from
> >> cec, which also sends a keyup event after the first keydown, to prevent
> >> autorepeat.
> > 
> > If driver does not want input core to handle autorepeat (but handle
> > autorepeat by themselves) they should indicate it by setting appropriate
> > dev->rep[REP_DELAY] and dev->rep[REP_PERIOD] before calling
> > input_register_device(). This will let input core know that it should
> > not setup its autorepeat timer.
> 
> That only means that I have to setup the autorepeat timer myself, there
> is no benefit in that :-)
> 
> Sean, I kind of agree with Dmitry here. The way autorepeat works for CEC
> is pretty specific to that protocol and unlikely to be needed for other
> protocols.

That's a valid point, I guess. The only downside is special case handling
outside the input layer, which would be much simpler in the input layer.

> It is also no big deal to keep knowledge of that within cec-adap.c.

So first of all, the sii8620 uses the CEC protocol as well (see commit
e25f1f7c94e1 drm/bridge/sii8620: add remote control support), so this
will have to go into rc-core, not cec-adap.c. There was a discussion about
some time ago.

The current implementation has an ugly key up event which would be nice
to do without.

> The only thing that would be nice to have control over is that with CEC
> userspace shouldn't be able to change REP_DELAY and that REP_DELAY should
> always be identical to REP_PERIOD. If this can be done easily, then that
> would be nice, but it's a nice-to-have in my opinion.

The REP_DELAY must be equal to REP_PERIOD seems a bit odd to me. In fact,
I propose something different. If REP_DELAY != 0 then the input layer
produces autorepeats as normal. If REP_DELAY == 0, then generate repeats
on the second key down event.

See patch below.

Thanks,
Sean
----
>From 3f439e326888a0ab8688d73c4276ac87b4225b1c Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Thu, 23 Nov 2017 22:37:10 +0000
Subject: [PATCH] media: cec: move cec autorepeat handling to rc-core

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
 drivers/media/rc/rc-main.c   | 45 +++++++++++++++++++++++++++++++++--
 include/media/cec.h          |  5 ----
 include/media/rc-core.h      |  3 +++
 5 files changed, 51 insertions(+), 70 deletions(-)

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
index 17950e29d4e3..7860ed50bc7f 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -599,6 +599,7 @@ static void ir_do_keyup(struct rc_dev *dev, bool sync)
 		return;
 
 	IR_dprintk(1, "keyup key 0x%04x\n", dev->last_keycode);
+	del_timer_sync(&dev->timer_repeat);
 	input_report_key(dev->input_dev, dev->last_keycode, 0);
 	led_trigger_event(led_feedback, LED_OFF);
 	if (sync)
@@ -625,7 +626,6 @@ EXPORT_SYMBOL_GPL(rc_keyup);
 
 /**
  * ir_timer_keyup() - generates a keyup event after a timeout
- * @cookie:	a pointer to the struct rc_dev for the device
  *
  * This routine will generate a keyup event some time after a keydown event
  * is generated when no further activity has been detected.
@@ -651,6 +651,26 @@ static void ir_timer_keyup(struct timer_list *t)
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 
+/**
+ * ir_timer_repeat() - generates a repeat event after a timeout
+ *
+ * This routine will generate a soft repeat event every REP_PERIOD
+ * milliseconds.
+ */
+static void ir_timer_repeat(struct timer_list *t)
+{
+	struct rc_dev *dev = from_timer(dev, t, timer_repeat);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->keylock, flags);
+	if (dev->keypressed) {
+		input_event(dev->input_dev, EV_KEY, dev->last_keycode, 2);
+		mod_timer(&dev->timer_repeat,
+			  jiffies + dev->input_dev->rep[REP_PERIOD]);
+	}
+	spin_unlock_irqrestore(&dev->keylock, flags);
+}
+
 /**
  * rc_repeat() - signals that a key is still pressed
  * @dev:	the struct rc_dev descriptor of the device
@@ -719,6 +739,22 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_proto protocol,
 		led_trigger_event(led_feedback, LED_FULL);
 	}
 
+	/*
+	 * For CEC, start sending repeat messages as soon as the first
+	 * repeated message is sent, as long as REP_DELAY = 0 and REP_PERIOD
+	 * is non-zero. Otherwise, the input layer will generate repeat
+	 * messages.
+	 */
+	if (!new_event && keycode != KEY_RESERVED &&
+	    dev->allowed_protocols == RC_PROTO_BIT_CEC &&
+	    !timer_pending(&dev->timer_repeat) &&
+	    dev->input_dev->rep[REP_PERIOD] &&
+	    !dev->input_dev->rep[REP_DELAY]) {
+		input_event(dev->input_dev, EV_KEY, keycode, 2);
+		mod_timer(&dev->timer_repeat, jiffies +
+			  msecs_to_jiffies(dev->input_dev->rep[REP_PERIOD]));
+	}
+
 	input_sync(dev->input_dev);
 }
 
@@ -1571,6 +1607,7 @@ struct rc_dev *rc_allocate_device(enum rc_driver_type type)
 		input_set_drvdata(dev->input_dev, dev);
 
 		timer_setup(&dev->timer_keyup, ir_timer_keyup, 0);
+		timer_setup(&dev->timer_repeat, ir_timer_repeat, 0);
 
 		spin_lock_init(&dev->rc_map.lock);
 		spin_lock_init(&dev->keylock);
@@ -1704,7 +1741,10 @@ static int rc_setup_rx_device(struct rc_dev *dev)
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
@@ -1846,6 +1886,7 @@ void rc_unregister_device(struct rc_dev *dev)
 		return;
 
 	del_timer_sync(&dev->timer_keyup);
+	del_timer_sync(&dev->timer_repeat);
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
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
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 314a1edb6189..6ba4be82ef73 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -106,6 +106,8 @@ enum rc_filter_type {
  * @keypressed: whether a key is currently pressed
  * @keyup_jiffies: time (in jiffies) when the current keypress should be released
  * @timer_keyup: timer for releasing a keypress
+ * @timer_repeat: timer for autorepeat events. This is needed for CEC, which
+ *	has non-standard repeats.
  * @last_keycode: keycode of last keypress
  * @last_protocol: protocol of last keypress
  * @last_scancode: scancode of last keypress
@@ -165,6 +167,7 @@ struct rc_dev {
 	bool				keypressed;
 	unsigned long			keyup_jiffies;
 	struct timer_list		timer_keyup;
+	struct timer_list		timer_repeat;
 	u32				last_keycode;
 	enum rc_proto			last_protocol;
 	u32				last_scancode;
-- 
2.14.3

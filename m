Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55905 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753467AbdKXLoE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 06:44:04 -0500
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 2/3] input: handle case whether first repeated key triggers repeat
Date: Fri, 24 Nov 2017 11:44:00 +0000
Message-Id: <e00a5bd5e87f011c92f7af5aac7e1654bf455cfb.1511523174.git.sean@mess.org>
In-Reply-To: <cover.1511523174.git.sean@mess.org>
References: <cover.1511523174.git.sean@mess.org>
In-Reply-To: <cover.1511523174.git.sean@mess.org>
References: <cover.1511523174.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the CEC protocol, as soon as the first repeated key is received,
the autorepeat should start. We introduce a special value 3 for this
situation.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/input/input.rst |  4 +++-
 drivers/input/input.c         | 17 +++++++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/Documentation/input/input.rst b/Documentation/input/input.rst
index 47f86a4bf16c..31cea9026193 100644
--- a/Documentation/input/input.rst
+++ b/Documentation/input/input.rst
@@ -276,6 +276,8 @@ list is in include/uapi/linux/input-event-codes.h.
 
 ``value`` is the value the event carries. Either a relative change for
 EV_REL, absolute new value for EV_ABS (joysticks ...), or 0 for EV_KEY for
-release, 1 for keypress and 2 for autorepeat.
+release, 1 for keypress and 2 for autorepeat, and 3 for autorepeat where
+the repeats should start immediately, rather than waiting REP_DELAY
+milliseconds.
 
 See :ref:`input-event-codes` for more information about various even codes.
diff --git a/drivers/input/input.c b/drivers/input/input.c
index ecc41d65b82a..84182d7e5a6b 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -72,6 +72,16 @@ static int input_defuzz_abs_event(int value, int old_val, int fuzz)
 	return value;
 }
 
+static void input_start_autorepeat_now(struct input_dev *dev, int code)
+{
+	if (dev->rep[REP_PERIOD] && dev->timer.data &&
+	    !timer_pending(&dev->timer)) {
+		dev->repeat_key = code;
+		mod_timer(&dev->timer,
+			  jiffies + msecs_to_jiffies(dev->rep[REP_PERIOD]));
+	}
+}
+
 static void input_start_autorepeat(struct input_dev *dev, int code)
 {
 	if (dev->rep[REP_PERIOD] && dev->rep[REP_DELAY] && dev->timer.data) {
@@ -155,7 +165,10 @@ static void input_pass_values(struct input_dev *dev,
 	if (test_bit(EV_REP, dev->evbit) && test_bit(EV_KEY, dev->evbit)) {
 		for (v = vals; v != vals + count; v++) {
 			if (v->type == EV_KEY && v->value != 2) {
-				if (v->value)
+				if (v->value == 3)
+					input_start_autorepeat_now(dev,
+								   v->code);
+				else if (v->value)
 					input_start_autorepeat(dev, v->code);
 				else
 					input_stop_autorepeat(dev);
@@ -285,7 +298,7 @@ static int input_get_disposition(struct input_dev *dev,
 		if (is_event_supported(code, dev->keybit, KEY_MAX)) {
 
 			/* auto-repeat bypasses state updates */
-			if (value == 2) {
+			if (value == 2 || value == 3) {
 				disposition = INPUT_PASS_TO_HANDLERS;
 				break;
 			}
-- 
2.14.3

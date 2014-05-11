Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:34799 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757950AbaEKLPp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 07:15:45 -0400
Date: 11 May 2014 07:15:44 -0400
Message-ID: <20140511111544.14913.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: james.hogan@imgtec.com, linux-media@vger.kernel.org,
	linux@horizon.com, m.chehab@samsung.com
Subject: [PATCH 06/10] ati_remote: Merge some duplicate code
In-Reply-To: <20140511111113.14427.qmail@ns.horizon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The KIND_FILTERED assignment of old_jiffies can't be merged, because
it must precede repeat handling.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/media/rc/ati_remote.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 8d9937fd5d..69d7912e03 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -568,7 +568,6 @@ static void ati_remote_input_report(struct urb *urb)
 		 */
 		input_event(dev, EV_KEY, ati_remote_tbl[index].code,
 			!(data[2] & 1));
-		input_sync(dev);
 
 		ati_remote->old_jiffies = jiffies;
 
@@ -585,7 +584,6 @@ static void ati_remote_input_report(struct urb *urb)
 			ati_remote->first_jiffies = now;
 		}
 
-		ati_remote->old_data = data[2];
 		ati_remote->old_jiffies = now;
 
 		/* Ensure we skip at least the 4 first duplicate events
@@ -598,7 +596,10 @@ static void ati_remote_input_report(struct urb *urb)
 				      msecs_to_jiffies(repeat_delay))))
 			return;
 
-		if (index < 0) {
+		if (index >= 0) {
+			input_event(dev, EV_KEY, ati_remote_tbl[index].code, 1);
+			input_event(dev, EV_KEY, ati_remote_tbl[index].code, 0);
+		} else {
 			/* Not a mouse event, hand it to rc-core. */
 			int count = 1;
 
@@ -623,13 +624,9 @@ static void ati_remote_input_report(struct urb *urb)
 						     data[2]);
 				rc_keyup(ati_remote->rdev);
 			}
-			return;
+			goto nosync;
 		}
 
-		input_event(dev, EV_KEY, ati_remote_tbl[index].code, 1);
-		input_event(dev, EV_KEY, ati_remote_tbl[index].code, 0);
-		input_sync(dev);
-
 	} else if (ati_remote_tbl[index].kind == KIND_ACCEL) {
 		signed char dx = ati_remote_tbl[index].code >> 8;
 		signed char dy = ati_remote_tbl[index].code & 255;
@@ -644,14 +641,16 @@ static void ati_remote_input_report(struct urb *urb)
 			input_report_rel(dev, REL_X, dx * acc);
 		if (dy)
 			input_report_rel(dev, REL_Y, dy * acc);
-		input_sync(dev);
-
 		ati_remote->old_jiffies = jiffies;
-		ati_remote->old_data = data[2];
+
 	} else {
 		dev_dbg(&ati_remote->interface->dev, "ati_remote kind=%d\n",
 			ati_remote_tbl[index].kind);
+		return;
 	}
+	input_sync(dev);
+nosync:
+	ati_remote->old_data = data[2];
 }
 
 /*
-- 
1.9.2


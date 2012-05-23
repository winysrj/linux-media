Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44279 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758759Ab2EWJy5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:57 -0400
Subject: [PATCH 38/43] rc-ir-raw: add various rc_events
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:45:20 +0200
Message-ID: <20120523094519.14474.90654.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reporting pulse/space events via the /dev/rc/rcX device node is an
important step towards having feature parity with LIRC.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-ir-raw.c |   11 +++++++++++
 include/media/rc-core.h      |   10 ++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 88a2932..e6a6eea 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -73,6 +73,17 @@ int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
 	IR_dprintk(2, "sample: (%05dus %s)\n",
 		   TO_US(ev->duration), TO_STR(ev->pulse));
 
+	if (ev->reset)
+		rc_event(dev, RC_IR_RAW, RC_IR_RAW_RESET, 1);
+	else if (ev->carrier_report)
+		rc_event(dev, RC_IR_RAW, RC_IR_RAW_CARRIER, ev->carrier);
+	else if (ev->timeout)
+		rc_event(dev, RC_IR_RAW, RC_IR_RAW_STOP, 1);
+	else if (ev->pulse)
+		rc_event(dev, RC_IR_RAW, RC_IR_RAW_PULSE, ev->duration);
+	else
+		rc_event(dev, RC_IR_RAW, RC_IR_RAW_SPACE, ev->duration);
+
 	if (kfifo_in(&dev->raw->kfifo, ev, 1) != 1)
 		return -ENOMEM;
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index ab9a72e..f2ff7f7 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -378,6 +378,7 @@ struct rc_keytable {
 #define RC_DEBUG		0x0
 #define RC_CORE			0x1
 #define RC_KEY			0x2
+#define RC_IR_RAW		0x3
 
 /* RC_CORE codes */
 #define RC_CORE_DROPPED		0x0
@@ -388,6 +389,15 @@ struct rc_keytable {
 #define RC_KEY_SCANCODE		0x2
 #define RC_KEY_TOGGLE		0x3
 
+/* RC_IR_RAW codes */
+#define RC_IR_RAW_SPACE		0x0
+#define RC_IR_RAW_PULSE		0x1
+#define RC_IR_RAW_START		0x2
+#define RC_IR_RAW_STOP		0x3
+#define RC_IR_RAW_RESET		0x4
+#define RC_IR_RAW_CARRIER	0x5
+#define RC_IR_RAW_DUTY_CYCLE	0x6
+
 /**
  * struct rc_event - used to communicate rc events to userspace
  * @type:	the event type


Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40353 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbaDCXfG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:35:06 -0400
Subject: [PATCH 45/49] rc-ir-raw: add various rc_events
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:35:03 +0200
Message-ID: <20140403233503.27099.89532.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
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
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index bf5215b..3b68975 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -71,6 +71,17 @@ int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
 	IR_dprintk(2, "sample: (%05dus %s)\n",
 		   TO_US(ev->duration), TO_STR(ev->pulse));
 
+	if (ev->reset)
+		rc_event(dev, RC_IR, RC_IR_RESET, 1);
+	else if (ev->carrier_report)
+		rc_event(dev, RC_IR, RC_IR_CARRIER, ev->carrier);
+	else if (ev->timeout)
+		rc_event(dev, RC_IR, RC_IR_STOP, 1);
+	else if (ev->pulse)
+		rc_event(dev, RC_IR, RC_IR_PULSE, ev->duration);
+	else
+		rc_event(dev, RC_IR, RC_IR_SPACE, ev->duration);
+
 	if (kfifo_in(&dev->raw->kfifo, ev, 1) != 1)
 		return -ENOMEM;
 


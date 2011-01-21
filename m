Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1AUE1h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 23:27:37 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0L4RbHH021482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 23:27:37 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] rc/ir-lirc-codec: add back debug spew
Date: Thu, 20 Jan 2011 23:27:33 -0500
Message-Id: <1295584053-20978-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Some occasionally useful debug spew disappeared as part of a feature
update a while back, and I'm finding myself in need of it again to help
diagnose some issues.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/ir-lirc-codec.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index f011c5d..1c5cc65 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -1,4 +1,4 @@
-/* ir-lirc-codec.c - ir-core to classic lirc interface bridge
+/* ir-lirc-codec.c - rc-core to classic lirc interface bridge
  *
  * Copyright (C) 2010 by Jarod Wilson <jarod@redhat.com>
  *
@@ -47,6 +47,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	/* Carrier reports */
 	if (ev.carrier_report) {
 		sample = LIRC_FREQUENCY(ev.carrier);
+		IR_dprintk(2, "carrier report (freq: %d)\n", sample);
 
 	/* Packet end */
 	} else if (ev.timeout) {
@@ -62,6 +63,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			return 0;
 
 		sample = LIRC_TIMEOUT(ev.duration / 1000);
+		IR_dprintk(2, "timeout report (duration: %d)\n", sample);
 
 	/* Normal sample */
 	} else {
@@ -85,6 +87,8 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		sample = ev.pulse ? LIRC_PULSE(ev.duration / 1000) :
 					LIRC_SPACE(ev.duration / 1000);
+		IR_dprintk(2, "delivering %uus %s to lirc_dev\n",
+			   TO_US(ev.duration), TO_STR(ev.pulse));
 	}
 
 	lirc_buffer_write(dev->raw->lirc.drv->rbuf,
-- 
1.7.3.4


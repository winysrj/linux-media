Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:64000 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLHQRl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 11:17:41 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Sifan Naeem <sifan.naeem@imgtec.com>,
	James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	<stable@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [REVIEW PATCH v2] rc-main: Re-apply filter for no-op protocol change
Date: Mon, 8 Dec 2014 16:17:07 +0000
Message-ID: <1418055427-6707-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit da6e162d6a46 ("[media] rc-core: simplify sysfs code"), when
the IR protocol is set using the sysfs interface to the same set of
protocols that are already set, store_protocols() does not refresh the
scancode filter with the new protocol, even if it has already called the
change_protocol() callback successfully. This results in the filter
being disabled in the hardware and not re-enabled until the filter is
set again using sysfs.

Fix in store_protocols() by still re-applying the filter whenever the
change_protocol() driver callback succeeded.

The problem can be reproduced with the img-ir driver by setting a
filter, and then setting the protocol to the same protocol that is
already set:
$ echo nec > protocols
$ echo 0xffff > filter_mask
$ echo nec > protocols

After this, messages which don't match the filter were still being
received.

Fixes: da6e162d6a46 ("[media] rc-core: simplify sysfs code")
Reported-by: Sifan Naeem <sifan.naeem@imgtec.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: David Härdeman <david@hardeman.nu>
Cc: <stable@vger.kernel.org> # v3.17+
Cc: linux-media@vger.kernel.org
---
Changes in v2:
- Move fix to store_protocols(). Still set filter again even if protocol
  mask hasn't been changed as a result of the protocol change (Mauro).
---
 drivers/media/rc/rc-main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 8d3b74c5a717..fc369b033484 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1021,16 +1021,16 @@ static ssize_t store_protocols(struct device *device,
 		goto out;
 	}
 
-	if (new_protocols == old_protocols) {
-		rc = len;
-		goto out;
+	if (new_protocols != old_protocols) {
+		*current_protocols = new_protocols;
+		IR_dprintk(1, "Protocols changed to 0x%llx\n",
+			   (long long)new_protocols);
 	}
 
-	*current_protocols = new_protocols;
-	IR_dprintk(1, "Protocols changed to 0x%llx\n", (long long)new_protocols);
-
 	/*
-	 * If the protocol is changed the filter needs updating.
+	 * If a protocol change was attempted the filter may need updating, even
+	 * if the actual protocol mask hasn't changed (since the driver may have
+	 * cleared the filter).
 	 * Try setting the same filter with the new protocol (if any).
 	 * Fall back to clearing the filter.
 	 */
-- 
2.0.4


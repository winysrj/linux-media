Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:38625 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbaLAMzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 07:55:22 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Sifan Naeem <sifan.naeem@imgtec.com>,
	James Hogan <james.hogan@imgtec.com>, <stable@vger.kernel.org>,
	<linux-media@vger.kernel.org>
Subject: [REVIEW PATCH 1/2] img-ir/hw: Avoid clearing filter for no-op protocol change
Date: Mon, 1 Dec 2014 12:55:09 +0000
Message-ID: <1417438510-18977-2-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1417438510-18977-1-git-send-email-james.hogan@imgtec.com>
References: <1417438510-18977-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the img-ir driver is asked to change protocol, if the chosen
decoder is already loaded then don't call img_ir_set_decoder(), so as
not to clear the current filter.

This is important because store_protocol() does not refresh the scancode
filter with the new protocol if the set of enabled protocols hasn't
actually changed, but it will still call the change_protocol() callback,
resulting in the filter being disabled in the hardware.

The problem can be reproduced by setting a filter, and then setting the
protocol to the same protocol that is already set:
$ echo nec > protocols
$ echo 0xffff > filter_mask
$ echo nec > protocols

After this, messages which don't match the filter still get received.

Reported-by: Sifan Naeem <sifan.naeem@imgtec.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: <stable@vger.kernel.org> # v3.15+
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/img-ir/img-ir-hw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 9db065344b41..1566337c1059 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -643,6 +643,12 @@ static int img_ir_change_protocol(struct rc_dev *dev, u64 *ir_type)
 			continue;
 		if (*ir_type & dec->type) {
 			*ir_type &= dec->type;
+			/*
+			 * We don't want to clear the filter if nothing is
+			 * changing as it won't get set again.
+			 */
+			if (dec == hw->decoder)
+				return 0;
 			img_ir_set_decoder(priv, dec, *ir_type);
 			goto success;
 		}
-- 
2.0.4


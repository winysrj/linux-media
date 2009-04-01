Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41097 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684AbZDAUZP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 16:25:15 -0400
Date: Wed, 1 Apr 2009 22:25:00 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] Revert "V4L/DVB (10962): fired-avc: fix printk formatting
 warning."
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <tkrat.c13edc1832a38d6d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 34aecd2851bba5c2b7dae2f0dbe8e629b1c5e4ac was made obsolete
and invalid by commit 40cf65d149053889c8876c6c2b4ce204fde55baa.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-avc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/firewire/firedtv-avc.c b/drivers/media/dvb/firewire/firedtv-avc.c
index 12f7730..32526f1 100644
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -151,7 +151,7 @@ static void debug_fcp(const u8 *data, int length)
 		subunit_type = data[1] >> 3;
 		subunit_id = data[1] & 7;
 		op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
-		printk(KERN_INFO "%ssu=%x.%x l=%zu: %-8s - %s\n",
+		printk(KERN_INFO "%ssu=%x.%x l=%d: %-8s - %s\n",
 		       prefix, subunit_type, subunit_id, length,
 		       debug_fcp_ctype(data[0]),
 		       debug_fcp_opcode(op, data, length));

-- 
Stefan Richter
-=====-==--= -=-- ----=
http://arcgraph.de/sr/


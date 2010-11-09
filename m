Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:44016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab0KIVlt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 16:41:49 -0500
Date: Tue, 9 Nov 2010 16:41:46 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: [PATCH 2/3 v2] mceusb: buffer parsing fixups for 1st-gen device
Message-ID: <20101109214146.GF11073@redhat.com>
References: <20101109213921.GD11073@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109213921.GD11073@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If we pass in an offset, we shouldn't skip 2 bytes. And the first-gen
hardware generates a constant stream of interrupts, always with two
header bytes, and if there's been no IR, with nothing else. Bail from
ir processing without calling ir_handle_raw_event when we get such a
buffer delivered to us.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/mceusb.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index 1811098..ed151c8 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -446,7 +446,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 		return;
 
 	/* skip meaningless 0xb1 0x60 header bytes on orig receiver */
-	if (ir->flags.microsoft_gen1 && !out)
+	if (ir->flags.microsoft_gen1 && !out && !offset)
 		skip = 2;
 
 	if (len <= skip)
@@ -807,6 +807,10 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 	if (ir->flags.microsoft_gen1)
 		i = 2;
 
+	/* if there's no data, just return now */
+	if (buf_len <= i)
+		return;
+
 	for (; i < buf_len; i++) {
 		switch (ir->parser_state) {
 		case SUBCMD:
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com


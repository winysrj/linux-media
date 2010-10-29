Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab0J2DIn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 23:08:43 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9T38gxJ008146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:08:43 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9T38gd1020465
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:08:42 -0400
Date: Thu, 28 Oct 2010 23:08:42 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] mceusb: buffer parsing fixups for 1st-gen device
Message-ID: <20101029030842.GD17238@redhat.com>
References: <20101029030545.GA17238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029030545.GA17238@redhat.com>
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
index a05dec7..09a62f1 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -445,7 +445,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 		return;
 
 	/* skip meaningless 0xb1 0x60 header bytes on orig receiver */
-	if (ir->flags.microsoft_gen1 && !out)
+	if (ir->flags.microsoft_gen1 && !out && !offset)
 		skip = 2;
 
 	if (len <= skip)
@@ -806,6 +806,10 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
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


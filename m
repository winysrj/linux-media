Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760300Ab0J2DNU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 23:13:20 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9T3DJN4029072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:13:19 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id o9T3DJ6A024398
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:13:19 -0400
Date: Thu, 28 Oct 2010 23:13:19 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 1/2] ir-nec-decoder: decode Apple's NEC remote variant
Message-ID: <20101029031319.GF17238@redhat.com>
References: <20101029031131.GE17238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029031131.GE17238@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Apple's remotes use an NEC-like protocol, but without checksumming. See
http://en.wikipedia.org/wiki/Apple_Remote for details. Since they always
send a specific vendor code, check for that, and bypass the checksum
check.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/ir-nec-decoder.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 70993f7..6dcddd2 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -50,6 +50,7 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 	struct nec_dec *data = &ir_dev->raw->nec;
 	u32 scancode;
 	u8 address, not_address, command, not_command;
+	bool apple = false;
 
 	if (!(ir_dev->raw->enabled_protocols & IR_TYPE_NEC))
 		return 0;
@@ -158,7 +159,14 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 		command	    = bitrev8((data->bits >>  8) & 0xff);
 		not_command = bitrev8((data->bits >>  0) & 0xff);
 
-		if ((command ^ not_command) != 0xff) {
+		/* Apple remotes use an NEC-like proto, but w/o a checksum */
+		if ((address == 0xee) && (not_address == 0x87)) {
+			apple = true;
+			IR_dprintk(1, "Apple remote, ID byte 0x%02x\n",
+				   not_command);
+		}
+
+		if (((command ^ not_command) != 0xff) && !apple) {
 			IR_dprintk(1, "NEC checksum error: received 0x%08x\n",
 				   data->bits);
 			break;
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com


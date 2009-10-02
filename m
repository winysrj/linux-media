Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy3.bredband.net ([195.54.101.73]:41337 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbZJBFGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 01:06:50 -0400
Received: from iph2.telenor.se (195.54.127.133) by proxy3.bredband.net (7.3.140.3)
        id 49F597CD03ED7655 for linux-media@vger.kernel.org; Fri, 2 Oct 2009 07:06:52 +0200
From: "Henrik Kurelid" <henke@kurelid.se>
To: <linux-media@vger.kernel.org>
Cc: <stefanr@s5r6.in-berlin.de>, <henke@kurelid.se>
Subject: [PATCH] firedtv: length field corrupt in ca2host if length>127
Date: Fri, 2 Oct 2009 07:06:18 +0200
Message-ID: <000a01ca431e$14250210$6301a8c0@ds.mot.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is a patch that solves a problem in firedtv that has become major for
Swedish DVB-T users the last month or so.
It will most likely solve issues seen by other users as well.
Please review and comment.

---

>From 751c52ea5509b85590cc6eeddb16ecc1eecfcb0c Mon Sep 17 00:00:00 2001
From: Henrik Kurelid <henrik@kurelid.se>
Date: Thu, 1 Oct 2009 07:17:31 +0200
Subject: [PATCH] firedtv: length field corrupt in ca2host if length>127

If the length of an AVC message is greater than 127, the length field should
be encoded in LV mode instead of V mode. V mode can only be used if the
length
is 127 or less. This patch ensures that the CA_PMT message is always encoded
in LV mode so PMT message of greater lengths can be supported.

Signed-off-by: Henrik Kurelid <henrik@kurelid.se>
---
 drivers/media/dvb/firewire/firedtv-avc.c |   38
+++++++++++++++--------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/firewire/firedtv-avc.c
b/drivers/media/dvb/firewire/firedtv-avc.c
index d056a40..143a322 100644
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -1051,28 +1051,28 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int
length)
 	c->operand[4] = 0; /* slot */
 	c->operand[5] = SFE_VENDOR_TAG_CA_PMT; /* ca tag */
 	c->operand[6] = 0; /* more/last */
-	/* c->operand[7] = XXXprogram_info_length + 17; */ /* length */
-	c->operand[8] = list_management;
-	c->operand[9] = 0x01; /* pmt_cmd=OK_descramble */
+	/* Use three bytes for length field in case length > 127 */
+	c->operand[10] = list_management;
+	c->operand[11] = 0x01; /* pmt_cmd=OK_descramble */
 
 	/* TS program map table */
 
-	c->operand[10] = 0x02; /* Table id=2 */
-	c->operand[11] = 0x80; /* Section syntax + length */
-	/* c->operand[12] = XXXprogram_info_length + 12; */
-	c->operand[13] = msg[1]; /* Program number */
-	c->operand[14] = msg[2];
-	c->operand[15] = 0x01; /* Version number=0 + current/next=1 */
-	c->operand[16] = 0x00; /* Section number=0 */
-	c->operand[17] = 0x00; /* Last section number=0 */
-	c->operand[18] = 0x1f; /* PCR_PID=1FFF */
-	c->operand[19] = 0xff;
-	c->operand[20] = (program_info_length >> 8); /* Program info length
*/
-	c->operand[21] = (program_info_length & 0xff);
+	c->operand[12] = 0x02; /* Table id=2 */
+	c->operand[13] = 0x80; /* Section syntax + length */
+	/* c->operand[14] = XXXprogram_info_length + 12; */
+	c->operand[15] = msg[1]; /* Program number */
+	c->operand[16] = msg[2];
+	c->operand[17] = 0x01; /* Version number=0 + current/next=1 */
+	c->operand[18] = 0x00; /* Section number=0 */
+	c->operand[19] = 0x00; /* Last section number=0 */
+	c->operand[20] = 0x1f; /* PCR_PID=1FFF */
+	c->operand[21] = 0xff;
+	c->operand[22] = (program_info_length >> 8); /* Program info length
*/
+	c->operand[23] = (program_info_length & 0xff);
 
 	/* CA descriptors at programme level */
 	read_pos = 6;
-	write_pos = 22;
+	write_pos = 24;
 	if (program_info_length > 0) {
 		pmt_cmd_id = msg[read_pos++];
 		if (pmt_cmd_id != 1 && pmt_cmd_id != 4)
@@ -1114,8 +1114,10 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int
length)
 	c->operand[write_pos++] = 0x00;
 	c->operand[write_pos++] = 0x00;
 
-	c->operand[7] = write_pos - 8;
-	c->operand[12] = write_pos - 13;
+	c->operand[7] = 0x82;
+	c->operand[8] = (write_pos - 10) >> 8;
+	c->operand[9] = (write_pos - 10) & 0xFF;
+	c->operand[14] = write_pos - 15;
 
 	crc32_csum = crc32_be(0, &c->operand[10], c->operand[12] - 1);
 	c->operand[write_pos - 4] = (crc32_csum >> 24) & 0xff;
-- 
1.6.0.6



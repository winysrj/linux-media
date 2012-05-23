Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44276 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298Ab2EWJyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:54 -0400
Subject: [PATCH 12/43] redrat: cleanup debug functions
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:43:03 +0200
Message-ID: <20120523094303.14474.1823.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for the next patches I had to understand the redrat driver (not
an easy task).

In the process I noticed that the debug printing functions look quite
suspicious. This is a minimal attempt at cleaning them up (though more work
remains to be done).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/redrat3.c |   40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 13a679f..46137b8 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -252,25 +252,29 @@ static void redrat3_dump_signal_header(struct redrat3_signal_header *header)
 	pr_info(" * repeats: %u\n", header->no_repeats);
 }
 
-static void redrat3_dump_signal_data(char *buffer, u16 len)
+static void redrat3_dump_signal_lens(u16 *buf, u8 n)
 {
-	int offset, i;
-	char *data_vals;
+	unsigned i;
 
 	pr_info("%s:", __func__);
+	for (i = 0; i < n; i++) {
+		if (i % 10 == 0)
+			pr_cont("\n * ");
+		pr_cont("%02x ", buf[i]);
+	}
+	pr_cont("\n");
+}
 
-	offset = RR3_TX_HEADER_OFFSET + RR3_HEADER_LENGTH
-		 + (RR3_DRIVER_MAXLENS * sizeof(u16));
-
-	/* read RR3_DRIVER_MAXLENS from ctrl msg */
-	data_vals = buffer + offset;
+static void redrat3_dump_signal_data(u8 *buf, u16 n)
+{
+	unsigned i;
 
-	for (i = 0; i < len; i++) {
+	pr_info("%s:", __func__);
+	for (i = 0; i < n; i++) {
 		if (i % 10 == 0)
 			pr_cont("\n * ");
-		pr_cont("%02x ", *data_vals++);
+		pr_cont("%02x ", buf[i]);
 	}
-
 	pr_cont("\n");
 }
 
@@ -466,11 +470,6 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 
 	header.no_repeats= sig_data[RR3_REPEATS_OFFSET];
 
-	if (debug) {
-		redrat3_dump_signal_header(&header);
-		redrat3_dump_signal_data(sig_data, header.sig_size);
-	}
-
 	mod_freq = redrat3_val_to_mod_freq(&header);
 	rr3_dbg(dev, "Got mod_freq of %u\n", mod_freq);
 
@@ -480,6 +479,12 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 	data_vals = sig_data + RR3_HEADER_LENGTH +
 		    (header.max_lengths * sizeof(u16));
 
+	if (debug) {
+		redrat3_dump_signal_header(&header);
+		redrat3_dump_signal_lens(len_vals, header.no_lengths);
+		redrat3_dump_signal_data(data_vals, header.sig_size);
+	}
+
 	/* process each rr3 encoded byte into an int */
 	for (i = 0; i < header.sig_size; i++) {
 		u16 val = len_vals[data_vals[i]];
@@ -1022,7 +1027,8 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 
 	if (debug) {
 		redrat3_dump_signal_header(&header);
-		redrat3_dump_signal_data(buffer, header.sig_size);
+		redrat3_dump_signal_lens(lengths_ptr, curlencheck);
+		redrat3_dump_signal_data(sigdata, count);
 	}
 
 	pipe = usb_sndbulkpipe(rr3->udev, rr3->ep_out->bEndpointAddress);


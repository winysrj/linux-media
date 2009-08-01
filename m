Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46654 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZHALGo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2009 07:06:44 -0400
Date: Sat, 1 Aug 2009 13:04:06 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/3 update] firedtv: refine AVC debugging
To: Henrik Kurelid <henke@kurelid.se>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-media@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.2933b45909e8fb83@s5r6.in-berlin.de>
Message-ID: <tkrat.301e627fc650b780@s5r6.in-berlin.de>
References: <2f15391f4f76f6a3126c0e8a9d61562c.squirrel@mail.kurelid.se>
 <tkrat.54463abf6a774c27@s5r6.in-berlin.de>
 <tkrat.2933b45909e8fb83@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Henrik Kurelid <henke@kurelid.se>

The current AVC debugging can clog the log down a lot since many
applications tend to check the signal strength very often.  This patch
enables users to select which AVC messages to log using a bitmask.  In
addition, it also enables the possibility to debug application PMTs sent
to the driver.  This will be usable since the CA support is still poorly
tested for lots of CAMs and CA systems.

Signed-off-by: Henrik Kurelid <henrik@kurelid.se>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Update (Stefan R):
Remove pre 2.6.22 compatibility #ifdefs, small whitespace changes.

 drivers/media/dvb/firewire/firedtv-avc.c |   79 ++++++++++++++++++++---
 1 file changed, 67 insertions(+), 12 deletions(-)

Index: b/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -89,14 +89,31 @@ struct avc_response_frame {
 	u8 operand[509];
 };
 
-#define AVC_DEBUG_FCP_SUBACTIONS	1
-#define AVC_DEBUG_FCP_PAYLOADS		2
+#define AVC_DEBUG_READ_DESCRIPTOR              0x0001
+#define AVC_DEBUG_DSIT                         0x0002
+#define AVC_DEBUG_DSD                          0x0004
+#define AVC_DEBUG_REGISTER_REMOTE_CONTROL      0x0008
+#define AVC_DEBUG_LNB_CONTROL                  0x0010
+#define AVC_DEBUG_TUNE_QPSK                    0x0020
+#define AVC_DEBUG_TUNE_QPSK2                   0x0040
+#define AVC_DEBUG_HOST2CA                      0x0080
+#define AVC_DEBUG_CA2HOST                      0x0100
+#define AVC_DEBUG_APPLICATION_PMT              0x4000
+#define AVC_DEBUG_FCP_PAYLOADS                 0x8000
 
 static int avc_debug;
 module_param_named(debug, avc_debug, int, 0644);
-MODULE_PARM_DESC(debug, "Verbose logging (default = 0"
-	", FCP subactions = "	__stringify(AVC_DEBUG_FCP_SUBACTIONS)
-	", FCP payloads = "	__stringify(AVC_DEBUG_FCP_PAYLOADS)
+MODULE_PARM_DESC(debug, "Verbose logging bitmask (none (default) = 0"
+	", FCP subaction(READ DESCRIPTOR) = "		__stringify(AVC_DEBUG_READ_DESCRIPTOR)
+	", FCP subaction(DSIT) = "			__stringify(AVC_DEBUG_DSIT)
+	", FCP subaction(REGISTER_REMOTE_CONTROL) = "	__stringify(AVC_DEBUG_REGISTER_REMOTE_CONTROL)
+	", FCP subaction(LNB CONTROL) = "		__stringify(AVC_DEBUG_LNB_CONTROL)
+	", FCP subaction(TUNE QPSK) = "			__stringify(AVC_DEBUG_TUNE_QPSK)
+	", FCP subaction(TUNE QPSK2) = "		__stringify(AVC_DEBUG_TUNE_QPSK2)
+	", FCP subaction(HOST2CA) = "			__stringify(AVC_DEBUG_HOST2CA)
+	", FCP subaction(CA2HOST) = "			__stringify(AVC_DEBUG_CA2HOST)
+	", Application sent PMT = "			__stringify(AVC_DEBUG_APPLICATION_PMT)
+	", FCP payloads(for selected subactions) = "	__stringify(AVC_DEBUG_FCP_PAYLOADS)
 	", or all = -1)");
 
 static const char *debug_fcp_ctype(unsigned int ctype)
@@ -142,26 +159,61 @@ static const char *debug_fcp_opcode(unsi
 	return "Vendor";
 }
 
+static int debug_fcp_opcode_flag_set(unsigned int opcode,
+				     const u8 *data, int length)
+{
+	switch (opcode) {
+	case AVC_OPCODE_VENDOR:			break;
+	case AVC_OPCODE_READ_DESCRIPTOR:	return avc_debug & AVC_DEBUG_READ_DESCRIPTOR;
+	case AVC_OPCODE_DSIT:			return avc_debug & AVC_DEBUG_DSIT;
+	case AVC_OPCODE_DSD:			return avc_debug & AVC_DEBUG_DSD;
+	default:				return 1;
+	}
+
+	if (length < 7 ||
+	    data[3] != SFE_VENDOR_DE_COMPANYID_0 ||
+	    data[4] != SFE_VENDOR_DE_COMPANYID_1 ||
+	    data[5] != SFE_VENDOR_DE_COMPANYID_2)
+		return 1;
+
+	switch (data[6]) {
+	case SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL:	return avc_debug & AVC_DEBUG_REGISTER_REMOTE_CONTROL;
+	case SFE_VENDOR_OPCODE_LNB_CONTROL:		return avc_debug & AVC_DEBUG_LNB_CONTROL;
+	case SFE_VENDOR_OPCODE_TUNE_QPSK:		return avc_debug & AVC_DEBUG_TUNE_QPSK;
+	case SFE_VENDOR_OPCODE_TUNE_QPSK2:		return avc_debug & AVC_DEBUG_TUNE_QPSK2;
+	case SFE_VENDOR_OPCODE_HOST2CA:			return avc_debug & AVC_DEBUG_HOST2CA;
+	case SFE_VENDOR_OPCODE_CA2HOST:			return avc_debug & AVC_DEBUG_CA2HOST;
+	}
+	return 1;
+}
+
 static void debug_fcp(const u8 *data, int length)
 {
 	unsigned int subunit_type, subunit_id, op;
 	const char *prefix = data[0] > 7 ? "FCP <- " : "FCP -> ";
 
-	if (avc_debug & AVC_DEBUG_FCP_SUBACTIONS) {
-		subunit_type = data[1] >> 3;
-		subunit_id = data[1] & 7;
-		op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
+	subunit_type = data[1] >> 3;
+	subunit_id = data[1] & 7;
+	op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
+	if (debug_fcp_opcode_flag_set(op, data, length)) {
 		printk(KERN_INFO "%ssu=%x.%x l=%d: %-8s - %s\n",
 		       prefix, subunit_type, subunit_id, length,
 		       debug_fcp_ctype(data[0]),
 		       debug_fcp_opcode(op, data, length));
+		if (avc_debug & AVC_DEBUG_FCP_PAYLOADS)
+			print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_NONE,
+				       16, 1, data, length, false);
 	}
+}
 
-	if (avc_debug & AVC_DEBUG_FCP_PAYLOADS)
-		print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_NONE, 16, 1,
-			       data, length, false);
+static void debug_pmt(char *msg, int length)
+{
+	printk(KERN_INFO "APP PMT -> l=%d\n", length);
+	print_hex_dump(KERN_INFO, "APP PMT -> ", DUMP_PREFIX_NONE,
+		       16, 1, msg, length, false);
 }
 
+
 static int __avc_write(struct firedtv *fdtv,
 		const struct avc_command_frame *c, struct avc_response_frame *r)
 {
@@ -983,6 +1035,9 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
 	int es_info_length;
 	int crc32_csum;
 
+	if (unlikely(avc_debug & AVC_DEBUG_APPLICATION_PMT))
+		debug_pmt(msg, length);
+
 	memset(c, 0, sizeof(*c));
 
 	c->ctype   = AVC_CTYPE_CONTROL;

-- 
Stefan Richter
-=====-==--= =--- ----=
http://arcgraph.de/sr/


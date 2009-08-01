Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46650 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZHALFj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2009 07:05:39 -0400
Date: Sat, 1 Aug 2009 13:05:16 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/3] firedtv: combine some debug logging code
To: Henrik Kurelid <henke@kurelid.se>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-media@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.301e627fc650b780@s5r6.in-berlin.de>
Message-ID: <tkrat.fc1c1269de053cb2@s5r6.in-berlin.de>
References: <2f15391f4f76f6a3126c0e8a9d61562c.squirrel@mail.kurelid.se>
 <tkrat.54463abf6a774c27@s5r6.in-berlin.de>
 <tkrat.2933b45909e8fb83@s5r6.in-berlin.de>
 <tkrat.301e627fc650b780@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Shrinks source and kernel object size a bit.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-avc.c |  109 ++++++++++-------------
 1 file changed, 49 insertions(+), 60 deletions(-)

Index: b/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -103,18 +103,19 @@ struct avc_response_frame {
 
 static int avc_debug;
 module_param_named(debug, avc_debug, int, 0644);
-MODULE_PARM_DESC(debug, "Verbose logging bitmask (none (default) = 0"
-	", FCP subaction(READ DESCRIPTOR) = "		__stringify(AVC_DEBUG_READ_DESCRIPTOR)
-	", FCP subaction(DSIT) = "			__stringify(AVC_DEBUG_DSIT)
-	", FCP subaction(REGISTER_REMOTE_CONTROL) = "	__stringify(AVC_DEBUG_REGISTER_REMOTE_CONTROL)
-	", FCP subaction(LNB CONTROL) = "		__stringify(AVC_DEBUG_LNB_CONTROL)
-	", FCP subaction(TUNE QPSK) = "			__stringify(AVC_DEBUG_TUNE_QPSK)
-	", FCP subaction(TUNE QPSK2) = "		__stringify(AVC_DEBUG_TUNE_QPSK2)
-	", FCP subaction(HOST2CA) = "			__stringify(AVC_DEBUG_HOST2CA)
-	", FCP subaction(CA2HOST) = "			__stringify(AVC_DEBUG_CA2HOST)
-	", Application sent PMT = "			__stringify(AVC_DEBUG_APPLICATION_PMT)
-	", FCP payloads(for selected subactions) = "	__stringify(AVC_DEBUG_FCP_PAYLOADS)
-	", or all = -1)");
+MODULE_PARM_DESC(debug, "Verbose logging (none = 0"
+	", FCP subactions"
+	": READ DESCRIPTOR = "		__stringify(AVC_DEBUG_READ_DESCRIPTOR)
+	", DSIT = "			__stringify(AVC_DEBUG_DSIT)
+	", REGISTER_REMOTE_CONTROL = "	__stringify(AVC_DEBUG_REGISTER_REMOTE_CONTROL)
+	", LNB CONTROL = "		__stringify(AVC_DEBUG_LNB_CONTROL)
+	", TUNE QPSK = "		__stringify(AVC_DEBUG_TUNE_QPSK)
+	", TUNE QPSK2 = "		__stringify(AVC_DEBUG_TUNE_QPSK2)
+	", HOST2CA = "			__stringify(AVC_DEBUG_HOST2CA)
+	", CA2HOST = "			__stringify(AVC_DEBUG_CA2HOST)
+	"; Application sent PMT = "	__stringify(AVC_DEBUG_APPLICATION_PMT)
+	", FCP payloads = "		__stringify(AVC_DEBUG_FCP_PAYLOADS)
+	", or a combination, or all = -1)");
 
 static const char *debug_fcp_ctype(unsigned int ctype)
 {
@@ -135,71 +136,59 @@ static const char *debug_fcp_opcode(unsi
 				    const u8 *data, int length)
 {
 	switch (opcode) {
-	case AVC_OPCODE_VENDOR:			break;
-	case AVC_OPCODE_READ_DESCRIPTOR:	return "ReadDescriptor";
-	case AVC_OPCODE_DSIT:			return "DirectSelectInfo.Type";
-	case AVC_OPCODE_DSD:			return "DirectSelectData";
-	default:				return "?";
-	}
-
-	if (length < 7 ||
-	    data[3] != SFE_VENDOR_DE_COMPANYID_0 ||
-	    data[4] != SFE_VENDOR_DE_COMPANYID_1 ||
-	    data[5] != SFE_VENDOR_DE_COMPANYID_2)
-		return "Vendor";
-
-	switch (data[6]) {
-	case SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL:	return "RegisterRC";
-	case SFE_VENDOR_OPCODE_LNB_CONTROL:		return "LNBControl";
-	case SFE_VENDOR_OPCODE_TUNE_QPSK:		return "TuneQPSK";
-	case SFE_VENDOR_OPCODE_TUNE_QPSK2:		return "TuneQPSK2";
-	case SFE_VENDOR_OPCODE_HOST2CA:			return "Host2CA";
-	case SFE_VENDOR_OPCODE_CA2HOST:			return "CA2Host";
-	}
-	return "Vendor";
-}
-
-static int debug_fcp_opcode_flag_set(unsigned int opcode,
-				     const u8 *data, int length)
-{
-	switch (opcode) {
-	case AVC_OPCODE_VENDOR:			break;
-	case AVC_OPCODE_READ_DESCRIPTOR:	return avc_debug & AVC_DEBUG_READ_DESCRIPTOR;
-	case AVC_OPCODE_DSIT:			return avc_debug & AVC_DEBUG_DSIT;
-	case AVC_OPCODE_DSD:			return avc_debug & AVC_DEBUG_DSD;
-	default:				return 1;
+	case AVC_OPCODE_VENDOR:
+		break;
+	case AVC_OPCODE_READ_DESCRIPTOR:
+		return avc_debug & AVC_DEBUG_READ_DESCRIPTOR ?
+				"ReadDescriptor" : NULL;
+	case AVC_OPCODE_DSIT:
+		return avc_debug & AVC_DEBUG_DSIT ?
+				"DirectSelectInfo.Type" : NULL;
+	case AVC_OPCODE_DSD:
+		return avc_debug & AVC_DEBUG_DSD ? "DirectSelectData" : NULL;
+	default:
+		return "Unknown";
 	}
 
 	if (length < 7 ||
 	    data[3] != SFE_VENDOR_DE_COMPANYID_0 ||
 	    data[4] != SFE_VENDOR_DE_COMPANYID_1 ||
 	    data[5] != SFE_VENDOR_DE_COMPANYID_2)
-		return 1;
+		return "Vendor/Unknown";
 
 	switch (data[6]) {
-	case SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL:	return avc_debug & AVC_DEBUG_REGISTER_REMOTE_CONTROL;
-	case SFE_VENDOR_OPCODE_LNB_CONTROL:		return avc_debug & AVC_DEBUG_LNB_CONTROL;
-	case SFE_VENDOR_OPCODE_TUNE_QPSK:		return avc_debug & AVC_DEBUG_TUNE_QPSK;
-	case SFE_VENDOR_OPCODE_TUNE_QPSK2:		return avc_debug & AVC_DEBUG_TUNE_QPSK2;
-	case SFE_VENDOR_OPCODE_HOST2CA:			return avc_debug & AVC_DEBUG_HOST2CA;
-	case SFE_VENDOR_OPCODE_CA2HOST:			return avc_debug & AVC_DEBUG_CA2HOST;
+	case SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL:
+		return avc_debug & AVC_DEBUG_REGISTER_REMOTE_CONTROL ?
+				"RegisterRC" : NULL;
+	case SFE_VENDOR_OPCODE_LNB_CONTROL:
+		return avc_debug & AVC_DEBUG_LNB_CONTROL ? "LNBControl" : NULL;
+	case SFE_VENDOR_OPCODE_TUNE_QPSK:
+		return avc_debug & AVC_DEBUG_TUNE_QPSK ? "TuneQPSK" : NULL;
+	case SFE_VENDOR_OPCODE_TUNE_QPSK2:
+		return avc_debug & AVC_DEBUG_TUNE_QPSK2 ? "TuneQPSK2" : NULL;
+	case SFE_VENDOR_OPCODE_HOST2CA:
+		return avc_debug & AVC_DEBUG_HOST2CA ? "Host2CA" : NULL;
+	case SFE_VENDOR_OPCODE_CA2HOST:
+		return avc_debug & AVC_DEBUG_CA2HOST ? "CA2Host" : NULL;
 	}
-	return 1;
+	return "Vendor/Unknown";
 }
 
 static void debug_fcp(const u8 *data, int length)
 {
-	unsigned int subunit_type, subunit_id, op;
-	const char *prefix = data[0] > 7 ? "FCP <- " : "FCP -> ";
+	unsigned int subunit_type, subunit_id, opcode;
+	const char *op, *prefix;
 
+	prefix       = data[0] > 7 ? "FCP <- " : "FCP -> ";
 	subunit_type = data[1] >> 3;
-	subunit_id = data[1] & 7;
-	op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
-	if (debug_fcp_opcode_flag_set(op, data, length)) {
+	subunit_id   = data[1] & 7;
+	opcode       = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
+	op           = debug_fcp_opcode(opcode, data, length);
+
+	if (op) {
 		printk(KERN_INFO "%ssu=%x.%x l=%d: %-8s - %s\n",
 		       prefix, subunit_type, subunit_id, length,
-		       debug_fcp_ctype(data[0]),
-		       debug_fcp_opcode(op, data, length));
+		       debug_fcp_ctype(data[0]), op);
 		if (avc_debug & AVC_DEBUG_FCP_PAYLOADS)
 			print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_NONE,
 				       16, 1, data, length, false);

-- 
Stefan Richter
-=====-==--= =--- ----=
http://arcgraph.de/sr/


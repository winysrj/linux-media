Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy1.bredband.net ([195.54.101.71]:41643 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805AbZGPVey (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 17:34:54 -0400
Received: from iph1.telenor.se (195.54.127.132) by proxy1.bredband.net (7.3.140.3)
        id 49F5A15201A53E6B for linux-media@vger.kernel.org; Thu, 16 Jul 2009 23:34:52 +0200
Message-ID: <101260728ec51cc1ec78699fbb0e5c37.squirrel@mail.kurelid.se>
Date: Thu, 16 Jul 2009 23:34:50 +0200
Subject: [PATCH] firedtv: refine AVC debugging
From: "Henrik Kurelid" <henke@kurelid.se>
To: linux-media@vger.kernel.org
Cc: stefanr@s5r6.in-berlin.de
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is another patch for the firedtv driver. This one changes the debug logging somewhat to make it easier to find issues with the driver since it
is still fairly untested for variants of delivery systems, CAMs and CA systems.

---

firedtv: refine AVC debugging

The current AVC debugging can clog the log down a lot since many applications
tend to check the signal strength very often. This patch enables users to
select which AVC messages to log using a bitmask.
In addition, it also enables the possibility to debug application PMTs sent
to the driver. This will be usable since the CA support is still poorly tested
for lots of CAMs and CA systems.

Signed-off-by: Henrik Kurelid <henrik@kurelid.se>

diff -r 48086ebb22a8 linux/drivers/media/dvb/firewire/firedtv-avc.c
--- a/linux/drivers/media/dvb/firewire/firedtv-avc.c    Thu Jul 16 16:13:09 2009 +0200
+++ b/linux/drivers/media/dvb/firewire/firedtv-avc.c    Thu Jul 16 21:54:34 2009 +0200
@@ -89,14 +89,31 @@ struct avc_response_frame {
        u8 operand[509];
 };

-#define AVC_DEBUG_FCP_SUBACTIONS       1
-#define AVC_DEBUG_FCP_PAYLOADS         2
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
-       ", FCP subactions = "   __stringify(AVC_DEBUG_FCP_SUBACTIONS)
-       ", FCP payloads = "     __stringify(AVC_DEBUG_FCP_PAYLOADS)
+MODULE_PARM_DESC(debug, "Verbose logging bitmask (none (default) = 0"
+       ", FCP subaction(READ DESCRIPTOR) = "           __stringify(AVC_DEBUG_READ_DESCRIPTOR)
+       ", FCP subaction(DSIT) = "                      __stringify(AVC_DEBUG_DSIT)
+       ", FCP subaction(REGISTER_REMOTE_CONTROL) = "   __stringify(AVC_DEBUG_REGISTER_REMOTE_CONTROL)
+       ", FCP subaction(LNB CONTROL) = "               __stringify(AVC_DEBUG_LNB_CONTROL)
+       ", FCP subaction(TUNE QPSK) = "                 __stringify(AVC_DEBUG_TUNE_QPSK)
+       ", FCP subaction(TUNE QPSK2) = "                __stringify(AVC_DEBUG_TUNE_QPSK2)
+       ", FCP subaction(HOST2CA) = "                   __stringify(AVC_DEBUG_HOST2CA)
+       ", FCP subaction(CA2HOST) = "                   __stringify(AVC_DEBUG_CA2HOST)
+       ", Application sent PMT = "                     __stringify(AVC_DEBUG_APPLICATION_PMT)
+       ", FCP payloads(for selected subactions) = "    __stringify(AVC_DEBUG_FCP_PAYLOADS)
        ", or all = -1)");

 static const char *debug_fcp_ctype(unsigned int ctype)
@@ -142,31 +159,67 @@ static const char *debug_fcp_opcode(unsi
        return "Vendor";
 }

+static int debug_fcp_opcode_flag_set(unsigned int opcode,
+                                    const u8 *data, int length)
+{
+       switch (opcode) {
+       case AVC_OPCODE_VENDOR:                 break;
+       case AVC_OPCODE_READ_DESCRIPTOR:        return avc_debug & AVC_DEBUG_READ_DESCRIPTOR;
+       case AVC_OPCODE_DSIT:                   return avc_debug & AVC_DEBUG_DSIT;
+       case AVC_OPCODE_DSD:                    return avc_debug & AVC_DEBUG_DSD;
+       default:                                return 1;
+       }
+
+       if (length < 7 ||
+           data[3] != SFE_VENDOR_DE_COMPANYID_0 ||
+           data[4] != SFE_VENDOR_DE_COMPANYID_1 ||
+           data[5] != SFE_VENDOR_DE_COMPANYID_2)
+               return 1;
+
+       switch (data[6]) {
+       case SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL: return avc_debug & AVC_DEBUG_REGISTER_REMOTE_CONTROL;
+       case SFE_VENDOR_OPCODE_LNB_CONTROL:             return avc_debug & AVC_DEBUG_LNB_CONTROL;
+       case SFE_VENDOR_OPCODE_TUNE_QPSK:               return avc_debug & AVC_DEBUG_TUNE_QPSK;
+       case SFE_VENDOR_OPCODE_TUNE_QPSK2:              return avc_debug & AVC_DEBUG_TUNE_QPSK2;
+       case SFE_VENDOR_OPCODE_HOST2CA:                 return avc_debug & AVC_DEBUG_HOST2CA;
+       case SFE_VENDOR_OPCODE_CA2HOST:                 return avc_debug & AVC_DEBUG_CA2HOST;
+       }
+       return 1;
+}
+
 static void debug_fcp(const u8 *data, int length)
 {
        unsigned int subunit_type, subunit_id, op;
        const char *prefix = data[0] > 7 ? "FCP <- " : "FCP -> ";

-       if (avc_debug & AVC_DEBUG_FCP_SUBACTIONS) {
-               subunit_type = data[1] >> 3;
-               subunit_id = data[1] & 7;
-               op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
+       subunit_type = data[1] >> 3;
+       subunit_id = data[1] & 7;
+       op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
+       if (debug_fcp_opcode_flag_set(op, data, length)) {
                printk(KERN_INFO "%ssu=%x.%x l=%d: %-8s - %s\n",
                       prefix, subunit_type, subunit_id, length,
                       debug_fcp_ctype(data[0]),
                       debug_fcp_opcode(op, data, length));
+               if (avc_debug & AVC_DEBUG_FCP_PAYLOADS)
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 22)
+                       print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_NONE, 16, 1,
+                                      data, length, false);
+#else
+                       print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_NONE, 16, 1,
+                                      (void *)data, length, false);
+#endif
        }
+}

-       if (avc_debug & AVC_DEBUG_FCP_PAYLOADS)
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 22)
-               print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_NONE, 16, 1,
-                              data, length, false);
-#else
-               print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_NONE, 16, 1,
-                              (void *)data, length, false);
-#endif
+static void debug_pmt(char* msg,
+                     int length)
+{
+       printk(KERN_INFO "APP PMT -> l=%d\n", length);
+       print_hex_dump(KERN_INFO, "APP PMT -> ", DUMP_PREFIX_NONE, 16, 1,
+                      msg, length, false);
 }

+
 static int __avc_write(struct firedtv *fdtv,
                const struct avc_command_frame *c, struct avc_response_frame *r)
 {
@@ -987,6 +1040,9 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
        int es_info_length;
        int crc32_csum;

+       if (unlikely(avc_debug & AVC_DEBUG_APPLICATION_PMT))
+               debug_pmt(msg, length);
+
        memset(c, 0, sizeof(*c));

        c->ctype   = AVC_CTYPE_CONTROL;



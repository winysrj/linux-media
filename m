Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:63662 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab0DIXQw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Apr 2010 19:16:52 -0400
Received: by fxm23 with SMTP id 23so3143872fxm.21
        for <linux-media@vger.kernel.org>; Fri, 09 Apr 2010 16:16:50 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 10 Apr 2010 02:16:50 +0300
Message-ID: <y2p94764e701004091616x59467e3qc4efc2580dad53d@mail.gmail.com>
Subject: [PATCH] DVB-T initial scan file for Israel (dvb-utils)
From: Shaul Kremer <shaulkr@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is an initial scan file for IBA's DVB-T transmitters.

Generated from info at http://www.iba.org.il/reception/ (Hebrew)

# HG changeset patch
# User Shaul Kremer <shaulkr@gmail.com>
# Date 1270854557 -10800
# Node ID ac84f6db6f031db82509c247ac1775ca48b0e2f3
# Parent  7de0663facd92bbb9049aeeda3dcba9601228f30
Added DVB-T initial tuning tables for Israel.

diff -r 7de0663facd9 -r ac84f6db6f03 util/scan/dvb-t/il-SFN1
--- /dev/null   Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/il-SFN1   Sat Apr 10 02:09:17 2010 +0300
@@ -0,0 +1,4 @@
+# Israel, Israel Broadcasting Authority's SFN-1 transmitter (northern Israel)
+# Generated from list in http://www.iba.org.il/reception/
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 538000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
diff -r 7de0663facd9 -r ac84f6db6f03 util/scan/dvb-t/il-SFN2
--- /dev/null   Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/il-SFN2   Sat Apr 10 02:09:17 2010 +0300
@@ -0,0 +1,4 @@
+# Israel, Israel Broadcasting Authority's SFN-2 transmitter (central Israel)
+# Generated from list in http://www.iba.org.il/reception/
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
diff -r 7de0663facd9 -r ac84f6db6f03 util/scan/dvb-t/il-SFN3
--- /dev/null   Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/il-SFN3   Sat Apr 10 02:09:17 2010 +0300
@@ -0,0 +1,4 @@
+# Israel, Israel Broadcasting Authority's SFN-3 transmitter (southern Israel)
+# Generated from list in http://www.iba.org.il/reception/
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 538000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE

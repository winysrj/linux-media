Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:62239 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab0ACPeh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jan 2010 10:34:37 -0500
Received: by fg-out-1718.google.com with SMTP id 22so5873182fge.1
        for <linux-media@vger.kernel.org>; Sun, 03 Jan 2010 07:34:35 -0800 (PST)
Message-ID: <4B40B909.4050200@gmail.com>
Date: Sun, 03 Jan 2010 16:34:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: pfister@linuxtv.org
CC: linux-media@vger.kernel.org
Subject: dvb-apps: add scan file for Kojal, Czech Republic
Content-Type: multipart/mixed;
 boundary="------------000808010400090707070904"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000808010400090707070904
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit


--------------000808010400090707070904
Content-Type: text/x-patch;
 name="cz-kojal.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cz-kojal.patch"

# HG changeset patch
# User Jiri Slaby <jirislaby@gmail.com>
# Date 1262532622 -3600
# Node ID 5f093a32da807e2e324e978e36ab092402aece6f
# Parent  a66ed623e524395f3805ce6266354f9e52913941
add scan file for Kojal, Czech Republic

diff -r a66ed623e524 -r 5f093a32da80 util/scan/dvb-t/cz-Kojal
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Kojal	Sun Jan 03 16:30:22 2010 +0100
@@ -0,0 +1,8 @@
+# DVB-T Kojal (Brno, Czech Republic)
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# CT - Ceska televize (multiplex 1)
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# CRa - Ceske radiokomunikace (multiplex 2)
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# Czech Digital Group (multiplex 3)
+T 778000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE

--------------000808010400090707070904--

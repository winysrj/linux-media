Return-path: <linux-media-owner@vger.kernel.org>
Received: from postie.bluegum.com ([125.255.44.10]:59404 "EHLO
	postie.bluegum.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852AbZDOLgh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 07:36:37 -0400
Received: from mailhub.bluegum.com (jackie.bluegum.com [192.168.9.17])
	by postie.bluegum.com (Postfix) with ESMTP id 6893310002
	for <linux-media@vger.kernel.org>; Wed, 15 Apr 2009 21:27:05 +1000 (EST)
Received: from chesty.bluegum.com (chesty.bluegum.com [192.168.9.36])
	by mailhub.bluegum.com (Postfix) with ESMTP id 385B1ACCD
	for <linux-media@vger.kernel.org>; Wed, 15 Apr 2009 21:26:51 +1000 (EST)
From: Lindsay Harris <lindsay@bluegum.com>
To: linux-media@vger.kernel.org
Subject: Bug & fix for drivers/media/dvb/dvb-usb/cxusb.c
Date: Wed, 15 Apr 2009 21:26:50 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904152126.50903.lindsay@bluegum.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!   I'm new to the list,  mostly joining to report a bug (with fix) 
for the DViCO dual digital card,   using the XC3028 tuner.

I'm using suse kernels,  which is currently 2.6.27.21.   I downloaded 
the 2.6.29.1 kernel,  and the relevant pieces of code have not 
changed.  This driver worked fine in the 2.6.25.16 kernel.

Symptom: card detects carrier,   but does not lock onto it.
Cause: the driver was NOT loading the SCODE for the card.


PATCH (against 2.6.29.1):
====================================================
lindsay@chesty:/working/build/linux-2.6.29.1/drivers/media/dvb/dvb-usb> 
diff -u cxusb.c FIXED-cxusb.c
--- cxusb.c     2009-04-03 07:55:27.000000000 +1100
+++ FIXED-cxusb.c       2009-04-15 21:01:15.000000000 +1000
@@ -34,6 +34,7 @@
 #include "mt352_priv.h"
 #include "zl10353.h"
 #include "tuner-xc2028.h"
+#include "tuner-xc2028-types.h"
 #include "tuner-simple.h"
 #include "mxl5005s.h"
 #include "dib7000p.h"
@@ -775,7 +776,7 @@
        static struct xc2028_ctrl ctl = {
                .fname       = XC2028_DEFAULT_FIRMWARE,
                .max_len     = 64,
-               .demod       = XC3028_FE_ZARLINK456,
+               .scode_table = ZARLINK456,
        };

        /* FIXME: generalize & move to common area */
====================================================

Explanation: Setting the .demod element above results in 
the "int_freq" parameter to load_scode() 
(drivers/media/common/tuners/tuner-xc2028.c) being non-zero (value is 
derived from the .demod line above).  The first if() is false, and 
it's all downhill from there.

The above patch puts things back to the state of the 2.6.25.16 kernel.  
Tested on both IA32 and AMD 64 systems.

Thanks,

Lindsay

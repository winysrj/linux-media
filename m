Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.sissa.it ([147.122.11.135]:60279 "EHLO smtp.sissa.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbZA0RDp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 12:03:45 -0500
Received: from ozzy.localnet (dhpc-2-12.sissa.it [147.122.2.192])
	by smtp.sissa.it (Postfix) with ESMTP id DF9E41B48074
	for <linux-media@vger.kernel.org>; Tue, 27 Jan 2009 18:03:42 +0100 (CET)
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: linux-media@vger.kernel.org
Subject: [PATCH] make clean should delete 2 more files
Date: Tue, 27 Jan 2009 18:03:50 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271803.50996.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The files v4l/Module.markers and v4l/modules.order , created by make, are not 
removed by make clean.

Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>

---
diff -ur v4l-dvb-6a6eb9efc6cd/v4l/Makefile v4l-dvb-new/v4l/Makefile
--- v4l-dvb-6a6eb9efc6cd/v4l/Makefile	2009-01-24 01:35:12.000000000 +0100
+++ v4l-dvb-new/v4l/Makefile	2009-01-19 19:22:27.000000000 +0100
@@ -278,7 +278,7 @@
 	@find . -name '*.c' -type l -exec rm '{}' \;
 	@find . -name '*.h' -type l -exec rm '{}' \;
 	-rm -f *~ *.o *.ko .*.o.cmd .*.ko.cmd *.mod.c av7110_firm.h fdump \
-		config-compat.h Module.symvers
+		config-compat.h Module.symvers Module.markers modules.order
 	make -C firmware clean
 
 distclean:: clean

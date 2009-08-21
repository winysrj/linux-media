Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54372 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315AbZHUQjM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 12:39:12 -0400
Subject: [PATCH] v4l-dvb-compat: Fix build for older kernels using
 DIV_ROUND_CLOSEST
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Julia Lawall <julia@diku.dk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Avo Aasma <Avo.Aasma@webit.ee>,
	Lou Otway <lotway@nildram.co.uk>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 12:41:21 -0400
Message-Id: <1250872881.3139.23.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DIV_ROUND_CLOSEST() is not available on older kernels.  Include compat.h
in a few files to fix building v4l-dvb from mercurial on older kernels.

Reported-by: Lou Otway <lotway@nildram.co.uk>
Reported-by: Avo Aasma <Avo.Aasma@webit.ee>
Signed-off-by: Andy Walls <awalls@radix.net>


diff -r d0ec20a376fe linux/drivers/media/dvb/frontends/stb6100.c
--- a/linux/drivers/media/dvb/frontends/stb6100.c	Thu Aug 20 01:30:58 2009 +0000
+++ b/linux/drivers/media/dvb/frontends/stb6100.c	Fri Aug 21 12:33:46 2009 -0400
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 
+#include "compat.h"
 #include "dvb_frontend.h"
 #include "stb6100.h"
 
diff -r d0ec20a376fe linux/drivers/media/dvb/frontends/tda10021.c
--- a/linux/drivers/media/dvb/frontends/tda10021.c	Thu Aug 20 01:30:58 2009 +0000
+++ b/linux/drivers/media/dvb/frontends/tda10021.c	Fri Aug 21 12:33:46 2009 -0400
@@ -29,6 +29,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 
+#include "compat.h"
 #include "dvb_frontend.h"
 #include "tda1002x.h"
 
diff -r d0ec20a376fe linux/drivers/media/dvb/frontends/ves1820.c
--- a/linux/drivers/media/dvb/frontends/ves1820.c	Thu Aug 20 01:30:58 2009 +0000
+++ b/linux/drivers/media/dvb/frontends/ves1820.c	Fri Aug 21 12:33:46 2009 -0400
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <asm/div64.h>
 
+#include "compat.h"
 #include "dvb_frontend.h"
 #include "ves1820.h"
 



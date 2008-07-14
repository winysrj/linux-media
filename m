Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KIFmk-0001wF-MU
	for linux-dvb@linuxtv.org; Mon, 14 Jul 2008 06:35:42 +0200
Message-ID: <487AD795.9030205@linuxtv.org>
Date: Mon, 14 Jul 2008 00:35:33 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Johannes Weber <jowebe@web.de>
References: <1068982688@web.de>
In-Reply-To: <1068982688@web.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] problems with smscoreapi
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Johannes Weber wrote:
>  CC [M]  /root/v4l-dvb/v4l/smscoreapi.o
> /root/v4l-dvb/v4l/smscoreapi.c: In function 'smscore_detect_mode':
> /root/v4l-dvb/v4l/smscoreapi.c:689: error: 'uintptr_t' undeclared (first use in this function)
> /root/v4l-dvb/v4l/smscoreapi.c:689: error: (Each undeclared identifier is reported only once
> /root/v4l-dvb/v4l/smscoreapi.c:689: error: for each function it appears in.)
> /root/v4l-dvb/v4l/smscoreapi.c: In function 'smscore_set_device_mode':
> /root/v4l-dvb/v4l/smscoreapi.c:820: error: 'uintptr_t' undeclared (first use in this function)
> make[5]: *** [/root/v4l-dvb/v4l/smscoreapi.o] Error 1
> make[4]: *** [_module_/root/v4l-dvb/v4l] Error 2
> make[3]: *** [modules] Error 2
> make[2]: *** [modules] Error 2
> make[2]: Leaving directory `/usr/src/linux-2.6.22.18-0.2-obj/i386/default'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/root/v4l-dvb/v4l'
> make: *** [all] Error 2


Please try this patch:

# HG changeset patch
# User Michael Krufky <mkrufky@linuxtv.org>
# Date 1216010022 14400
# Node ID 9ccf2533792a1e91988ae827190d1472f96e1ba4
# Parent  d49b1e522b37ecdbe659b234f156788216216b11
sms1xxx: fix compat for kernel 2.6.22 and earlier

From: Michael Krufky <mkrufky@linuxtv.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

diff -r d49b1e522b37 -r 9ccf2533792a linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Sat Jul 12 18:58:24 2008 -0400
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Mon Jul 14 00:33:42 2008 -0400
@@ -29,7 +29,7 @@
 #include <linux/scatterlist.h>
 #include <linux/types.h>
 #include <asm/page.h>
-
+#include "compat.h"
 #include "dmxdev.h"
 #include "dvbdev.h"
 #include "dvb_demux.h"
diff -r d49b1e522b37 -r 9ccf2533792a v4l/compat.h
--- a/v4l/compat.h	Sat Jul 12 18:58:24 2008 -0400
+++ b/v4l/compat.h	Mon Jul 14 00:33:42 2008 -0400
@@ -210,4 +210,8 @@ static inline struct proc_dir_entry *pro
 
 #endif
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 23)
+typedef unsigned long uintptr_t;
 #endif
+
+#endif

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6CMugvo025725
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 18:56:42 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6CMuUuj004003
	for <video4linux-list@redhat.com>; Sat, 12 Jul 2008 18:56:30 -0400
Message-ID: <48793697.3080704@linuxtv.org>
Date: Sat, 12 Jul 2008 18:56:23 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Peter Schlaf <peter.schlaf@web.de>
References: <48793439.20700@web.de>
In-Reply-To: <48793439.20700@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: smscoreapi.c:689: error: 'uintptr_t' undeclared
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Peter,

Peter Schlaf wrote:
> to workaround this i edited v4l/Makefile.media and commented out
> 
>   sms1xxx-objs := smscoreapi.o smsusb.o smsdvb.o sms-cards.o
> 
>   obj-$(CONFIG_DVB_SIANO_SMS1XXX) += sms1xxx.o
> 
> 
> after that, compiling all the other modules ended successfully.


Thank you for posting this error.  Here is a fix:

diff -r f6b65eef0c94 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Fri Jul 11 20:37:08 2008 -0400
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Sat Jul 12 18:55:02 2008 -0400
@@ -27,6 +27,7 @@
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
+#include <linux/types.h>
 #include <asm/page.h>
 
 #include "dmxdev.h"


I'll push this in now.

Regards,

Mike Krufky


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

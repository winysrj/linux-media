Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd16922.kasserver.com ([85.13.137.202]:33997 "EHLO
	dd16922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab0EZVdD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 17:33:03 -0400
Received: from [127.0.0.1] (p50817871.dip.t-dialin.net [80.129.120.113])
	by dd16922.kasserver.com (Postfix) with ESMTPA id 218FD10FC102
	for <linux-media@vger.kernel.org>; Wed, 26 May 2010 23:32:59 +0200 (CEST)
Message-ID: <4BFD939A.1090206@helmutauer.de>
Date: Wed, 26 May 2010 23:33:14 +0200
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l-dvb does not compile with kernel 2.6.34 [solved]
References: <4BFC4858.8060403@helmutauer.de>
In-Reply-To: <4BFC4858.8060403@helmutauer.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 25.05.2010 23:59, schrieb Helmut Auer:
> Hello
> 
> I just wanted to compile v4l-dvb for my Gen2VDR Ditribution with kernel 2.6.34, but it fails
> because many modules are missing:
> 
> #include <linux/slab.h>
> 
> and are getting errors like:
> 
> /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c: In function
> 'free_firmware':
> /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c:252: error: implicit
> declaration of function 'kfree'
> /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c: In function
> 'load_all_firmwares':
> /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c:314: error: implicit
> declaration of function
> 
> Am I missing something or is v4l-dvb broken ?
> 
Here is the complete patch I am using:

--- v4l/compat.h.org    2010-05-26 22:22:31.000000000 +0200
+++ v4l/compat.h        2010-05-26 22:22:43.000000000 +0200
@@ -28,6 +28,10 @@
 #include <linux/i2c-dev.h>
 #endif

+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 33)
+#include <linux/slab.h>
+#endif
+
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 26)
 #ifdef CONFIG_PROC_FS
 #include <linux/module.h>
--- linux/drivers/media/IR/ir-raw-event.c.org   2010-05-26 22:35:12.000000000 +0200
+++ linux/drivers/media/IR/ir-raw-event.c       2010-05-26 22:35:43.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include "ir-core-priv.h"

 /* Define the max number of pulse/space transitions to buffer */
--- linux/drivers/media/dvb/dvb-core/dvb_frontend.h.org 2010-05-26 23:06:50.000000000 +0200
+++ linux/drivers/media/dvb/dvb-core/dvb_frontend.h     2010-05-26 23:06:21.000000000 +0200
@@ -39,6 +39,7 @@

 #include <linux/dvb/frontend.h>

+#include "compat.h"
 #include "dvbdev.h"

 struct dvb_frontend_tune_settings {
diff -upr /home/v4l/tmp/oldtree/drivers/media/radio/radio-tea5764.c
./drivers/media/radio/radio-tea5764.c
--- linux/drivers/media/radio/radio-tea5764.c.org       2010-05-25 23:56:57.000000000 -0300
+++ linux/drivers/media/radio/radio-tea5764.c   2010-05-21 11:21:19.000000000 -0300
@@ -32,6 +32,7 @@
  *  add RDS support
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>                        /* Initdata                     */
 #include <linux/videodev2.h>           /* kernel radio structs         */

-- 
Helmut Auer, helmut@helmutauer.de

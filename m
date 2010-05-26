Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd16922.kasserver.com ([85.13.137.202]:48871 "EHLO
	dd16922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab0EZUY1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 16:24:27 -0400
Received: from [127.0.0.1] (p50817871.dip.t-dialin.net [80.129.120.113])
	by dd16922.kasserver.com (Postfix) with ESMTPA id D3A4510FC102
	for <linux-media@vger.kernel.org>; Wed, 26 May 2010 22:24:25 +0200 (CEST)
Message-ID: <4BFD8388.9060904@helmutauer.de>
Date: Wed, 26 May 2010 22:24:40 +0200
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l-dvb does not compile with kernel 2.6.34
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
An easy patch for this problem is:

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


-- 
Helmut Auer, helmut@helmutauer.de

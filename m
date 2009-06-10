Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755988AbZFJTod (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 15:44:33 -0400
Message-Id: <200906101944.n5AJiIKQ031735@imap1.linux-foundation.org>
Subject: [patch 1/6] radio-mr800.c: missing mutex include
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	abogani@texware.it
From: akpm@linux-foundation.org
Date: Wed, 10 Jun 2009 12:44:18 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alessio Igor Bogani <abogani@texware.it>

radio-mr800.c uses struct mutex, so while <linux/mutex.h> seems to be
pulled in indirectly by one of the headers it already includes, the right
thing is to include it directly.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/radio-mr800.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/radio/radio-mr800.c~radio-mr800c-missing-mutex-include drivers/media/radio/radio-mr800.c
--- a/drivers/media/radio/radio-mr800.c~radio-mr800c-missing-mutex-include
+++ a/drivers/media/radio/radio-mr800.c
@@ -64,6 +64,7 @@
 #include <media/v4l2-ioctl.h>
 #include <linux/usb.h>
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO */
+#include <linux/mutex.h>
 
 /* driver and module definitions */
 #define DRIVER_AUTHOR "Alexey Klimov <klimov.linux@gmail.com>"
_

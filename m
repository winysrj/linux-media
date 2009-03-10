Return-path: <linux-media-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:51050 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbZCJINJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 04:13:09 -0400
Received: by mu-out-0910.google.com with SMTP id i10so571425mue.1
        for <linux-media@vger.kernel.org>; Tue, 10 Mar 2009 01:13:04 -0700 (PDT)
Subject: [patch review] radio-terratec: remove unused delay.h
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 11:13:48 +0300
Message-Id: <1236672828.11988.46.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, all

I don't know if this patch okay, so it should be tested/reviewed.
Anyway, compilation process shows no warnings.

---
Patch removes linux/delay.h which hadn't been used.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 615fb8f01610 linux/drivers/media/radio/radio-terratec.c
--- a/linux/drivers/media/radio/radio-terratec.c	Tue Mar 10 02:33:02 2009 -0300
+++ b/linux/drivers/media/radio/radio-terratec.c	Tue Mar 10 09:49:36 2009 +0300
@@ -27,7 +27,6 @@
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
-#include <linux/delay.h>	/* udelay			*/
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/mutex.h>
 #include <linux/version.h>      /* for KERNEL_VERSION MACRO     */


-- 
Best regards, Klimov Alexey


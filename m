Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47476 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760392Ab2ERKiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 06:38:18 -0400
Received: by bkcji2 with SMTP id ji2so2231115bkc.19
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 03:38:16 -0700 (PDT)
Message-ID: <4FB62695.3030909@gmail.com>
Date: Fri, 18 May 2012 12:38:13 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Thomas Mair <thomas.mair86@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4 1/5] rtl2832 ver. 0.4: removed signal statistics
References: <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com> <1337206420-23810-2-git-send-email-thomas.mair86@googlemail.com> <4FB50909.7030101@iki.fi> <4FB59E03.7080800@gmail.com> <CAKZ=SG_mvvFae9ZE2H3ci_3HosLmQ1kihyGx6QCdyQGgQro52Q@mail.gmail.com> <4FB61328.3090707@gmail.com>
In-Reply-To: <4FB61328.3090707@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090000020008020906040801"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090000020008020906040801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[…]

printk(KERN_ERR LOG_PREFIX": " f "\n" , ## arg)
pr_err(LOG_PREFIX": " f "\n" , ## arg)

printk(KERN_INFO LOG_PREFIX": " f "\n" , ## arg)
pr_info(LOG_PREFIX": " f "\n" , ## arg)

printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
pr_warn(LOG_PREFIX": " f "\n" , ## arg)

Besides what 'checkpatch' suggest/output - Antti, is it a correct
conversions?

cheers,
poma


--------------090000020008020906040801
Content-Type: text/x-patch;
 name="rtl2832_priv.h-v2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl2832_priv.h-v2.diff"

--- rtl2832_priv.h.orig	2012-05-18 02:02:48.561114101 +0200
+++ rtl2832_priv.h	2012-05-18 12:20:45.000000000 +0200
@@ -29,13 +29,13 @@
 #undef dbg
 #define dbg(f, arg...) \
 	if (rtl2832_debug) \
-		printk(KERN_INFO LOG_PREFIX": " f "\n" , ## arg)
+		pr_info(LOG_PREFIX": " f "\n" , ## arg)
 #undef err
-#define err(f, arg...)  printk(KERN_ERR	LOG_PREFIX": " f "\n" , ## arg)
+#define err(f, arg...) pr_err(LOG_PREFIX": " f "\n" , ## arg)
 #undef info
-#define info(f, arg...) printk(KERN_INFO LOG_PREFIX": " f "\n" , ## arg)
+#define info(f, arg...) pr_info(LOG_PREFIX": " f "\n" , ## arg)
 #undef warn
-#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
+#define warn(f, arg...) pr_warn(LOG_PREFIX": " f "\n" , ## arg)
 
 struct rtl2832_priv {
 	struct i2c_adapter *i2c;

--------------090000020008020906040801--

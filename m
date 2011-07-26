Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:32853 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1GZSeQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 14:34:16 -0400
Received: by gxk21 with SMTP id 21so466630gxk.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2011 11:34:16 -0700 (PDT)
Date: Tue, 26 Jul 2011 15:34:10 -0300 (BRT)
From: =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=
	<fredlwm@fredlwm.net>
To: linux-media@vger.kernel.org
Subject: v4l-utils: rds-saa6588 doesn't compile if i2c-tools is installed
Message-ID: <alpine.LNX.2.00.1107261422430.9258@pervalidus.fredlwm.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not sure if it's the right place to report it.

At least here, v4l-utils doesn't compile if i2c-tools is installed, 
because the latter installs a i2c-dev.h, like the kernel does with make 
headers_install, but which is incompatible if used with i2c.h.

While rds-saa6588 isn't installed by default, it's compiled, and aborts:

In file included from rds-saa6588.c:16:0:
/usr/local/include/linux/i2c-dev.h:38:8: error: redefinition of 'struct i2c_msg'
/usr/include/linux/i2c.h:67:8: note: originally defined here
/usr/local/include/linux/i2c-dev.h:90:7: error: redefinition of 'union i2c_smbus_data'
/usr/include/linux/i2c.h:125:7: note: originally defined here

The same would happen if i2c-tools was installed in /usr, overwriting 
the kernel header.

I think that a fix would be something like the following, which worked 
in all scenarios for me:

diff -urN rds.old/Makefile rds/Makefile
--- rds.old/Makefile	2011-07-17 13:06:39.000000000 -0300
+++ rds/Makefile	2011-07-26 15:15:31.000000000 -0300
@@ -1,5 +1,7 @@
  TARGETS = rds-saa6588

+override CPPFLAGS += -DLINUX_I2C_DEV_H
+
  all: $(TARGETS)

  -include *.d
diff -urN rds.old/rds-saa6588.c rds/rds-saa6588.c
--- rds.old/rds-saa6588.c	2011-07-17 13:06:39.000000000 -0300
+++ rds/rds-saa6588.c	2011-07-26 15:16:13.000000000 -0300
@@ -12,8 +12,12 @@
  #include <errno.h>
  #include <sys/ioctl.h>
  #include <linux/types.h>
+#ifdef LINUX_I2C_DEV_H
+#include <linux/i2c-dev.h>
+#else
  #include <linux/i2c.h>
  #include <linux/i2c-dev.h>
+#endif

  int debug;


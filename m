Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:52789 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbZCFVYH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 16:24:07 -0500
Message-ID: <49B1949E.2000300@oracle.com>
Date: Fri, 06 Mar 2009 13:24:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] dvb/frontends: fix duplicate 'debug' symbol
References: <20090306191311.697e7b97.sfr@canb.auug.org.au>
In-Reply-To: <20090306191311.697e7b97.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix dvb frontend debug variable to be static, to avoid linker
errors:

drivers/built-in.o:(.data+0xf4b0): multiple definition of `debug'
arch/x86/kernel/built-in.o:(.kprobes.text+0x90): first defined here
ld: Warning: size of symbol `debug' changed from 85 in arch/x86/kernel/built-in.o to 4 in drivers/built-in.o

It would also be Good if arch/x86/kernel/entry_32.S didn't have a
non-static 'debug' symbol.  OTOH, it helps catch things like this one.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/dvb/frontends/stv0900_core.c |    4 ++--
 drivers/media/dvb/frontends/stv0900_priv.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20090306.orig/drivers/media/dvb/frontends/stv0900_core.c
+++ linux-next-20090306/drivers/media/dvb/frontends/stv0900_core.c
@@ -34,8 +34,8 @@
 #include "stv0900_priv.h"
 #include "stv0900_init.h"
 
-int debug = 1;
-module_param(debug, int, 0644);
+static int stvdebug = 1;
+module_param_named(debug, stvdebug, int, 0644);
 
 /* internal params node */
 struct stv0900_inode {
--- linux-next-20090306.orig/drivers/media/dvb/frontends/stv0900_priv.h
+++ linux-next-20090306/drivers/media/dvb/frontends/stv0900_priv.h
@@ -62,11 +62,11 @@
 
 #define dmd_choose(a, b)	(demod = STV0900_DEMOD_2 ? b : a))
 
-extern int debug;
+static int stvdebug;
 
 #define dprintk(args...) \
 	do { \
-		if (debug) \
+		if (stvdebug) \
 			printk(KERN_DEBUG args); \
 	} while (0)
 

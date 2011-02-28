Return-path: <mchehab@pedra>
Received: from lebrac.rtp-net.org ([88.191.135.105]:41174 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab1B1Nh3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 08:37:29 -0500
Message-Id: <20110228131609.628261675@rtp-net.org>
Date: Mon, 28 Feb 2011 14:15:59 +0100
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: [patch 1/1] mantis_pci: remove asm/pgtable.h include
Content-Disposition: inline; filename=mantis.patch
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

mantis_pci.c is including asm/pgtable.h and it's leading to a build failure on
arm. It has been noticed here :

https://buildd.debian.org/fetch.cgi?pkg=linux-2.6&arch=armel&ver=2.6.38~rc6-1~experimental.1&stamp=1298430952&file=log&as=raw

As this header doesn't seem to be used, I'm removing it. I've build tested it
with arm and x86.

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Index: linux-2.6/drivers/media/dvb/mantis/mantis_pci.c
===================================================================
--- linux-2.6.orig/drivers/media/dvb/mantis/mantis_pci.c	2011-02-27 21:21:57.370731954 +0100
+++ linux-2.6/drivers/media/dvb/mantis/mantis_pci.c	2011-02-27 21:22:02.142211398 +0100
@@ -22,7 +22,6 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/page.h>
 #include <linux/kmod.h>
 #include <linux/vmalloc.h>



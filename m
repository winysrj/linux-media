Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:49645 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZH3FvJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 01:51:09 -0400
Message-ID: <4A9A134B.3030406@freemail.hu>
Date: Sun, 30 Aug 2009 07:51:07 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>
CC: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: [PATCH] v4l2: fix typos in INSTALL
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Fix some typos in INSTALL documentation coming from http://linuxtv.org/hg/v4l-dvb .

Priority: low
Signed-off-by: Márton Németh <nm127@freemai.hu>
---
diff -r 6f58a5d8c7c6 INSTALL
--- a/INSTALL	Sat Aug 29 09:01:54 2009 -0300
+++ b/INSTALL	Sun Aug 30 07:45:10 2009 +0200
@@ -1,7 +1,7 @@
 Mauro Carvalho Chehab                                   2006 Apr 26

 V4L/DVB building procedures are based at the use of Makefile rules.
-Those rules are close tho the ones at Linux Kernel, to allow an easier
+Those rules are close to the ones at Linux Kernel, to allow an easier
 usage.

 =======================================================================
@@ -9,7 +9,7 @@
 	make all
 ======================================================================

-For those that may want more than just build all stuff there are some
+For those who may want more than just build all stuff there are some
 other interesting parameters to make:

 ======================

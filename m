Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:57378 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0A2Um0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 15:42:26 -0500
Received: from [192.168.1.67] (dsl5402C4B8.pool.t-online.hu [84.2.196.184])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail01d.mail.t-online.hu (Postfix) with ESMTPSA id 8FC0275916D
	for <linux-media@vger.kernel.org>; Fri, 29 Jan 2010 21:39:38 +0100 (CET)
Message-ID: <4B634829.5090706@freemail.hu>
Date: Fri, 29 Jan 2010 21:42:17 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] smsir: make local variables static
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Make the file local parameters static.

This will remove the following sparse warnings (see "make C=1"):
 * warning: symbol 'ir_pos' was not declared. Should it be static?
 * warning: symbol 'ir_word' was not declared. Should it be static?
 * warning: symbol 'ir_toggle' was not declared. Should it be static?

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 8b9a62386b64 linux/drivers/media/dvb/siano/smsir.c
--- a/linux/drivers/media/dvb/siano/smsir.c	Fri Jan 29 01:23:57 2010 -0200
+++ b/linux/drivers/media/dvb/siano/smsir.c	Fri Jan 29 21:39:06 2010 +0100
@@ -85,9 +85,9 @@
 		{ } /* Terminating entry */
 };

-u32 ir_pos;
-u32	ir_word;
-u32 ir_toggle;
+static u32 ir_pos;
+static u32 ir_word;
+static u32 ir_toggle;

 #define RC5_PUSH_BIT(dst, bit, pos)	\
 	{ dst <<= 1; dst |= bit; pos++; }


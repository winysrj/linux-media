Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:64026 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbZKVVw2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 16:52:28 -0500
Received: from [192.168.1.64] (dsl51B6C41D.pool.t-online.hu [81.182.196.29])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail02a.mail.t-online.hu (Postfix) with ESMTPSA id 13D3B256240
	for <linux-media@vger.kernel.org>; Sun, 22 Nov 2009 22:51:51 +0100 (CET)
Message-ID: <4B09B29F.7090502@freemail.hu>
Date: Sun, 22 Nov 2009 22:52:31 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] smssdio: initialize return value
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The return value may be used uninitialized when the size parameter
happens to be 0.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r bc16afd1e7a4 linux/drivers/media/dvb/siano/smssdio.c
--- a/linux/drivers/media/dvb/siano/smssdio.c	Sat Nov 21 12:01:36 2009 +0100
+++ b/linux/drivers/media/dvb/siano/smssdio.c	Sun Nov 22 22:40:31 2009 +0100
@@ -78,7 +78,7 @@

 static int smssdio_sendrequest(void *context, void *buffer, size_t size)
 {
-	int ret;
+	int ret = 0;
 	struct smssdio_device *smsdev;

 	smsdev = context;

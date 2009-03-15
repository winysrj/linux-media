Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110809.mail.gq1.yahoo.com ([67.195.13.232]:46337 "HELO
	web110809.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752702AbZCOKN5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 06:13:57 -0400
Message-ID: <355858.3677.qm@web110809.mail.gq1.yahoo.com>
Date: Sun, 15 Mar 2009 03:13:55 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] Siano: SDIO interface driver - remove two redundant lines
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Alexey Klimov <klimov.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1237111557 -7200
# Node ID 7311d23c3355629b617013cd51223895a2423770
# Parent  7352ee1288f651d19d58c7bb479a98f070ad98e6
Siano: remove two redundant lines

From: Uri Shkolnik <uris@siano-ms.com>

Remove two redundant lines, based on Klimov Alexey code review.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 7352ee1288f6 -r 7311d23c3355 linux/drivers/media/dvb/siano/smssdio.c
--- a/linux/drivers/media/dvb/siano/smssdio.c	Thu Mar 12 15:48:17 2009 +0200
+++ b/linux/drivers/media/dvb/siano/smssdio.c	Sun Mar 15 12:05:57 2009 +0200
@@ -96,8 +96,6 @@ static int smssdio_sendrequest(void *con
 	if (size) {
 		ret = sdio_write_bytes(smsdev->func, SMSSDIO_DATA,
 				       buffer, size);
-		if (ret)
-			goto out;
 	}
 
 out:



      

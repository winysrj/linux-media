Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46419 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0LWTjF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 14:39:05 -0500
Received: by fxm20 with SMTP id 20so7401156fxm.19
        for <linux-media@vger.kernel.org>; Thu, 23 Dec 2010 11:39:04 -0800 (PST)
Date: Thu, 23 Dec 2010 22:38:53 +0300
From: Dan Carpenter <error27@gmail.com>
To: Sri Deevi <Srinivasa.Deevi@conexant.com>
Cc: 'Andy Walls' <awalls@md.metrocast.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	mchehab@infradead.org
Subject: [patch] [media] cx231xxx: fix typo in saddr_len check
Message-ID: <20101223193853.GN1936@bicker>
References: <20101223164347.GA16612@bicker>
 <1293129292.24752.9.camel@morgan.silverblock.net>
 <34B38BE41EDBA046A4AFBB591FA311320249B057C6@NBMBX01.bbnet.ad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34B38BE41EDBA046A4AFBB591FA311320249B057C6@NBMBX01.bbnet.ad>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The original code compared "saddr_len" with zero twice in a nonsensical
way.  I asked the list, and Andy Walls and Sri Deevi say that the second
check should be if "saddr_len == 1".

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-core.c b/drivers/media/video/cx231xx/cx231xx-core.c
index 44d124c..7d62d58 100644
--- a/drivers/media/video/cx231xx/cx231xx-core.c
+++ b/drivers/media/video/cx231xx/cx231xx-core.c
@@ -1515,7 +1515,7 @@ int cx231xx_read_i2c_master(struct cx231xx *dev, u8 dev_addr, u16 saddr,
 
 	if (saddr_len == 0)
 		saddr = 0;
-	else if (saddr_len == 0)
+	else if (saddr_len == 1)
 		saddr &= 0xff;
 
 	/* prepare xfer_data struct */
@@ -1566,7 +1566,7 @@ int cx231xx_write_i2c_master(struct cx231xx *dev, u8 dev_addr, u16 saddr,
 
 	if (saddr_len == 0)
 		saddr = 0;
-	else if (saddr_len == 0)
+	else if (saddr_len == 1)
 		saddr &= 0xff;
 
 	/* prepare xfer_data struct */
@@ -1600,7 +1600,7 @@ int cx231xx_read_i2c_data(struct cx231xx *dev, u8 dev_addr, u16 saddr,
 
 	if (saddr_len == 0)
 		saddr = 0;
-	else if (saddr_len == 0)
+	else if (saddr_len == 1)
 		saddr &= 0xff;
 
 	/* prepare xfer_data struct */
@@ -1641,7 +1641,7 @@ int cx231xx_write_i2c_data(struct cx231xx *dev, u8 dev_addr, u16 saddr,
 
 	if (saddr_len == 0)
 		saddr = 0;
-	else if (saddr_len == 0)
+	else if (saddr_len == 1)
 		saddr &= 0xff;
 
 	/* prepare xfer_data struct */

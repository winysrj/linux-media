Return-path: <mchehab@gaivota>
Received: from cnxtsmtp2.conexant.com ([198.62.9.253]:39501 "EHLO
	cnxtsmtp2.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0LWT5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 14:57:49 -0500
Received: from nbwsmx1.bbnet.ad (nbwsmx1.bbnet.ad [157.152.183.211]) (using TLSv1 with cipher
 RC4-MD5 (128/128 bits)) (No client certificate requested) by cnxtsmtp2.conexant.com (Tumbleweed
 MailGate 3.7.1) with ESMTP id 2581D2508FB for <linux-media@vger.kernel.org>; Thu, 23 Dec 2010
 11:40:23 -0800 (PST)
From: "Sri Deevi" <Srinivasa.Deevi@conexant.com>
To: "'Dan Carpenter'" <error27@gmail.com>
cc: "'Andy Walls'" <awalls@md.metrocast.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@infradead.org" <mchehab@infradead.org>
Date: Thu, 23 Dec 2010 11:40:22 -0800
Subject: RE: [patch] [media] cx231xxx: fix typo in saddr_len check
Message-ID: <34B38BE41EDBA046A4AFBB591FA31132024A7F38D1@NBMBX01.bbnet.ad>
References: <20101223164347.GA16612@bicker> <1293129292.24752.9.camel@morgan.silverblock.net>
 <34B38BE41EDBA046A4AFBB591FA311320249B057C6@NBMBX01.bbnet.ad> <20101223193853.GN1936@bicker>
In-Reply-To: <20101223193853.GN1936@bicker>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

I am ok with the changes.

Signed-off-by: Srinivasa Deevi <Srinivasa.deevi@conexant.com>

Sri

-----Original Message-----
From: Dan Carpenter [mailto:error27@gmail.com] 
Sent: Thursday, December 23, 2010 11:39 AM
To: Sri Deevi
Cc: 'Andy Walls'; linux-media@vger.kernel.org; mchehab@infradead.org
Subject: [patch] [media] cx231xxx: fix typo in saddr_len check

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

Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------


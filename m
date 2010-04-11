Return-path: <linux-media-owner@vger.kernel.org>
Received: from fb1.tech.numericable.fr ([82.216.111.51]:45302 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab0DKVZx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Apr 2010 17:25:53 -0400
Received: from smtp6.tech.numericable.fr (smtp6.nc.sdv.fr [10.0.0.83])
	by fb1.tech.numericable.fr (Postfix) with ESMTP id E45069EC4E
	for <linux-media@vger.kernel.org>; Sun, 11 Apr 2010 23:18:53 +0200 (CEST)
Received: from ibiza.bxl.tuxicoman.be (cable-85.28.93.50.coditel.net [85.28.93.50])
	by smtp6.tech.numericable.fr (Postfix) with ESMTP id DB49114401C
	for <linux-media@vger.kernel.org>; Sun, 11 Apr 2010 23:18:10 +0200 (CEST)
Received: from borg.bxl.tuxicoman.be ([172.19.0.10])
	by ibiza.bxl.tuxicoman.be with esmtps (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.71)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1O14Xe-000890-1G
	for linux-media@vger.kernel.org; Sun, 11 Apr 2010 23:18:10 +0200
Date: Sun, 11 Apr 2010 23:18:05 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH] TT S2-1600 allow more current for diseqc
Message-ID: <20100411231805.4bc7fdef@borg.bxl.tuxicoman.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/74QMhLjdMvWTT28KDcHyxBM"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/74QMhLjdMvWTT28KDcHyxBM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hi linux-media,

The following patch increases the current limit for the isl6423 chip
on the TT S2-1600 card. This allows DiSEqC to work with more complex
and current demanding configurations.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>

Regards,
  Guy
--MP_/74QMhLjdMvWTT28KDcHyxBM
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tt-s2-1600-more-diseqc-current.patch

diff -r 7c0b887911cf linux/drivers/media/dvb/ttpci/budget.c
--- a/linux/drivers/media/dvb/ttpci/budget.c	Mon Apr 05 22:56:43 2010 -0400
+++ b/linux/drivers/media/dvb/ttpci/budget.c	Sun Apr 11 13:46:43 2010 +0200
@@ -461,7 +461,7 @@
 };
 
 static struct isl6423_config tt1600_isl6423_config = {
-	.current_max		= SEC_CURRENT_515m,
+	.current_max		= SEC_CURRENT_800m,
 	.curlim			= SEC_CURRENT_LIM_ON,
 	.mod_extern		= 1,
 	.addr			= 0x08,

--MP_/74QMhLjdMvWTT28KDcHyxBM--

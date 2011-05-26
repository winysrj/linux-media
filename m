Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37230 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab1EZIpV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 04:45:21 -0400
Date: Thu, 26 May 2011 11:44:52 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Steven Toth <stoth@kernellabs.com>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] DVB: dvb_frontend: off by one in dtv_property_dump()
Message-ID: <20110526084452.GB14591@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If the tvp->cmd == DTV_MAX_COMMAND then we read past the end of the
array.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 9827804..607e293 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -981,7 +981,7 @@ static void dtv_property_dump(struct dtv_property *tvp)
 {
 	int i;
 
-	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
+	if (tvp->cmd <= 0 || tvp->cmd >= DTV_MAX_COMMAND) {
 		printk(KERN_WARNING "%s: tvp.cmd = 0x%08x undefined\n",
 			__func__, tvp->cmd);
 		return;

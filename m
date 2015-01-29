Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:57374 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbbA2Sot (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 13:44:49 -0500
Received: by mail-lb0-f182.google.com with SMTP id l4so31336934lbv.13
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2015 10:44:48 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Gulsah Kose <gulsah.1004@gmail.com>,
	Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
	Martin Kaiser <martin@kaiser.cx>, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: lirc: lirc_zilog: Fix for possible null pointer dereference
Date: Thu, 29 Jan 2015 19:48:08 +0100
Message-Id: <1422557288-3617-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a possible null pointer dereference, there is
otherwise a risk of a possible null pointer dereference.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/media/lirc/lirc_zilog.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index cc872fb..78ce3b0 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1332,10 +1332,8 @@ static int close(struct inode *node, struct file *filep)
 	/* find our IR struct */
 	struct IR *ir = filep->private_data;
 
-	if (ir == NULL) {
-		dev_err(ir->l.dev, "close: no private_data attached to the file!\n");
+	if (ir == NULL)
 		return -ENODEV;
-	}
 
 	atomic_dec(&ir->open_count);
 
-- 
1.7.10.4


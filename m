Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:44587 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2DTNPX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 09:15:23 -0400
Date: Fri, 20 Apr 2012 16:15:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rmetzler@digitaldevices.de>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] ngene: remove an unneeded condition
Message-ID: <20120420131502.GB26339@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"stat" is always zero here.  The condition used to be needed, but we
shifted stuff around in 0f0b270f90 "[media] ngene: CXD2099AR Common
Interface driver".

This doesn't change how the code works, it's just a bit tidier.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index f129a93..3985738 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -1409,10 +1409,8 @@ static int ngene_start(struct ngene *dev)
 	if (stat < 0)
 		goto fail;
 
-	if (!stat)
-		return stat;
+	return 0;
 
-	/* otherwise error: fall through */
 fail:
 	ngwritel(0, NGENE_INT_ENABLE);
 	free_irq(dev->pci_dev->irq, dev);

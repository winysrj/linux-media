Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35342 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab2LBKnS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Dec 2012 05:43:18 -0500
Date: Sun, 2 Dec 2012 13:43:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] mantis: cleanup NULL checking in mantis_ca_exit()
Message-ID: <20121202104313.GC16078@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch complainst that the call to mantis_evmgr_exit() dereferences "ca"
but then we check it for NULL on the next line.  I've moved the NULL
check forward to avoid that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
There aren't any callers for this function.  It is commented out in
mantis_dvb_exit().

diff --git a/drivers/media/pci/mantis/mantis_ca.c b/drivers/media/pci/mantis/mantis_ca.c
index 3d70469..60c6c2f 100644
--- a/drivers/media/pci/mantis/mantis_ca.c
+++ b/drivers/media/pci/mantis/mantis_ca.c
@@ -198,11 +198,12 @@ void mantis_ca_exit(struct mantis_pci *mantis)
 	struct mantis_ca *ca = mantis->mantis_ca;
 
 	dprintk(MANTIS_DEBUG, 1, "Mantis CA exit");
+	if (!ca)
+		return;
 
 	mantis_evmgr_exit(ca);
 	dprintk(MANTIS_ERROR, 1, "Unregistering EN50221 device");
-	if (ca)
-		dvb_ca_en50221_release(&ca->en50221);
+	dvb_ca_en50221_release(&ca->en50221);
 
 	kfree(ca);
 }

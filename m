Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab1G2FyI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 01:54:08 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6T5s7ZW016381
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 01:54:07 -0400
Received: from localhost.localdomain (vpn-227-36.phx2.redhat.com [10.3.227.36])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6T5s61R013209
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 01:54:06 -0400
Date: Fri, 29 Jul 2011 02:53:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] em28xx: Fix IR unregister logic
Message-ID: <20110729025355.2fe04c6b@redhat.com>
In-Reply-To: <d2fea3477b6527f29b946f6aa5842398d72c3a1e.1311918789.git.mchehab@redhat.com>
References: <d2fea3477b6527f29b946f6aa5842398d72c3a1e.1311918789.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The input stop() callback already calls the em28xx_ir_stop method.
Calling it again causes an oops.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index 5d12b14..679da48 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -463,11 +463,11 @@ int em28xx_ir_fini(struct em28xx *dev)
 	if (!ir)
 		return 0;
 
-	em28xx_ir_stop(ir->rc);
-	rc_unregister_device(ir->rc);
-	kfree(ir);
+	if (ir->rc)
+		rc_unregister_device(ir->rc);
 
 	/* done */
+	kfree(ir);
 	dev->ir = NULL;
 	return 0;
 }
-- 
1.7.1


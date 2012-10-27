Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab2J0UmB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:01 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKg0sr004754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:01 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 23/68] [media] nuvoton-cir: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:41 -0200
Message-Id: <1351370486-29040-24-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/rc/nuvoton-cir.c:1223:5: warning: no previous prototype for 'nvt_init' [-Wmissing-prototypes]
drivers/media/rc/nuvoton-cir.c:1228:6: warning: no previous prototype for 'nvt_exit' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/rc/nuvoton-cir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 0190dfc..44ba834 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1220,12 +1220,12 @@ static struct pnp_driver nvt_driver = {
 	.shutdown	= nvt_shutdown,
 };
 
-int nvt_init(void)
+static int nvt_init(void)
 {
 	return pnp_register_driver(&nvt_driver);
 }
 
-void nvt_exit(void)
+static void nvt_exit(void)
 {
 	pnp_unregister_driver(&nvt_driver);
 }
-- 
1.7.11.7


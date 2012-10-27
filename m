Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933334Ab2J0Um6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:58 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgvxC019942
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:58 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 22/68] [media] ite-cir.c: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:40 -0200
Message-Id: <1351370486-29040-23-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/rc/ite-cir.c:1711:5: warning: no previous prototype for 'ite_init' [-Wmissing-prototypes]
drivers/media/rc/ite-cir.c:1716:6: warning: no previous prototype for 'ite_exit' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/rc/ite-cir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index d635115..5e5a7f2 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1708,12 +1708,12 @@ static struct pnp_driver ite_driver = {
 	.shutdown	= ite_shutdown,
 };
 
-int ite_init(void)
+static int ite_init(void)
 {
 	return pnp_register_driver(&ite_driver);
 }
 
-void ite_exit(void)
+static void ite_exit(void)
 {
 	pnp_unregister_driver(&ite_driver);
 }
-- 
1.7.11.7


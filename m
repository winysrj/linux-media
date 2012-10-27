Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab2J0UmU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:20 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgKMW004806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:20 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 67/68] fintek-cir: get rid of warning: no previous prototype Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Sat, 27 Oct 2012 18:41:25 -0200
Message-Id: <1351370486-29040-68-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/rc/fintek-cir.c:687:5: warning: no previous prototype for 'fintek_init' [-Wmissing-prototypes]
drivers/media/rc/fintek-cir.c:692:6: warning: no previous prototype for 'fintek_exit' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/rc/fintek-cir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index d2d93cb..936c3f7 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -684,12 +684,12 @@ static struct pnp_driver fintek_driver = {
 	.shutdown	= fintek_shutdown,
 };
 
-int fintek_init(void)
+static int fintek_init(void)
 {
 	return pnp_register_driver(&fintek_driver);
 }
 
-void fintek_exit(void)
+static void fintek_exit(void)
 {
 	pnp_unregister_driver(&fintek_driver);
 }
-- 
1.7.11.7


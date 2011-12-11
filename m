Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab1LKOWa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 09:22:30 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBBEMU3H001027
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 11 Dec 2011 09:22:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [media] tm6000: Fix a warning at tm6000_ir_int_start()
Date: Sun, 11 Dec 2011 12:22:25 -0200
Message-Id: <1323613345-10387-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/video/tm6000/tm6000-input.c: In function ‘tm6000_ir_int_start’:
drivers/media/video/tm6000/tm6000-input.c:381:3: warning: ‘return’ with no value, in function returning non-void [-Wreturn-type]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/tm6000/tm6000-input.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/video/tm6000/tm6000-input.c
index 89e003c..8d92527 100644
--- a/drivers/media/video/tm6000/tm6000-input.c
+++ b/drivers/media/video/tm6000/tm6000-input.c
@@ -378,7 +378,7 @@ int tm6000_ir_int_start(struct tm6000_core *dev)
 	struct tm6000_IR *ir = dev->ir;
 
 	if (!ir)
-		return;
+		return 0;
 
 	return __tm6000_ir_int_start(ir->rc);
 }
-- 
1.7.8


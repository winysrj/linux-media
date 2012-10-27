Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab2J0UmK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:10 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgAa7019810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:10 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 13/68] [media] dm1105: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:31 -0200
Message-Id: <1351370486-29040-14-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/dm1105/dm1105.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index a609b3a..d0dfa5d 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -736,7 +736,7 @@ static irqreturn_t dm1105_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
+static int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 {
 	struct rc_dev *dev;
 	int err = -ENOMEM;
@@ -776,7 +776,7 @@ int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
 	return 0;
 }
 
-void __devexit dm1105_ir_exit(struct dm1105_dev *dm1105)
+static void __devexit dm1105_ir_exit(struct dm1105_dev *dm1105)
 {
 	rc_unregister_device(dm1105->ir.dev);
 }
-- 
1.7.11.7


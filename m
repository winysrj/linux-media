Return-path: <mchehab@pedra>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126Ab0JAVOa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Oct 2010 17:14:30 -0400
Message-Id: <201010012113.o91LDeMi020977@imap1.linux-foundation.org>
Subject: [patch 1/2] drivers/media/IR/ene_ir.c: fix NULL dereference
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	jslaby@suse.cz, maximlevitsky@gmail.com, mchehab@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 01 Oct 2010 14:13:40 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Jiri Slaby <jslaby@suse.cz>

When 'dev' allocation fails in ene_probe we jump to error label where we
dereference the 'dev'.  Fix it by jumping few lines below.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/IR/ene_ir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/IR/ene_ir.c~drivers-media-ir-ene_irc-fix-null-dereference drivers/media/IR/ene_ir.c
--- a/drivers/media/IR/ene_ir.c~drivers-media-ir-ene_irc-fix-null-dereference
+++ a/drivers/media/IR/ene_ir.c
@@ -785,7 +785,7 @@ static int ene_probe(struct pnp_dev *pnp
 	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
 
 	if (!input_dev || !ir_props || !dev)
-		goto error;
+		goto error1;
 
 	/* validate resources */
 	error = -ENODEV;
@@ -899,7 +899,7 @@ error:
 		free_irq(dev->irq, dev);
 	if (dev->hw_io)
 		release_region(dev->hw_io, ENE_MAX_IO);
-
+error1:
 	input_free_device(input_dev);
 	kfree(ir_props);
 	kfree(dev);
_

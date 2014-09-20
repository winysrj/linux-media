Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4307 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbaITMmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 15/16] cx88: pci_disable_device comes after free_irq.
Date: Sat, 20 Sep 2014 14:41:50 +0200
Message-Id: <1411216911-7950-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Move pci_disable_device() down otherwise it will complain about an
unfreed irq.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index d8a86cd..a64ae31 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1571,12 +1571,12 @@ static void cx8800_finidev(struct pci_dev *pci_dev)
 		cx88_ir_stop(core);
 
 	cx88_shutdown(core); /* FIXME */
-	pci_disable_device(pci_dev);
 
 	/* unregister stuff */
 
 	free_irq(pci_dev->irq, dev);
 	cx8800_unregister_video(dev);
+	pci_disable_device(pci_dev);
 
 	core->v4ldev = NULL;
 
-- 
2.1.0


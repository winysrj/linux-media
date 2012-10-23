Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61542 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab2JWT7Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 15:59:16 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 17/23] cx23885: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:20 -0300
Message-Id: <1351022246-8201-17-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This kind of memcpy() is error-prone. Its replacement with a struct
assignment is prefered because it's type-safe and much easier to read.

Found by coccinelle. Hand patched and reviewed.
Tested by compilation only.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier struct_name;
struct struct_name to;
struct struct_name from;
expression E;
@@
-memcpy(&(to), &(from), E);
+to = from;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-video.c |    3 +--
 drivers/media/pci/cx23885/cx23888-ir.c    |    6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 1a21926..62be144 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1818,8 +1818,7 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	spin_lock_init(&dev->slock);
 
 	/* Initialize VBI template */
-	memcpy(&cx23885_vbi_template, &cx23885_video_template,
-		sizeof(cx23885_vbi_template));
+	cx23885_vbi_template = cx23885_video_template;
 	strcpy(cx23885_vbi_template.name, "cx23885-vbi");
 
 	dev->tvnorm = cx23885_video_template.current_norm;
diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index c2bc39c..e448146 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -1236,13 +1236,11 @@ int cx23888_ir_probe(struct cx23885_dev *dev)
 		cx23888_ir_write4(dev, CX23888_IR_IRQEN_REG, 0);
 
 		mutex_init(&state->rx_params_lock);
-		memcpy(&default_params, &default_rx_params,
-		       sizeof(struct v4l2_subdev_ir_parameters));
+		default_params = default_rx_params;
 		v4l2_subdev_call(sd, ir, rx_s_parameters, &default_params);
 
 		mutex_init(&state->tx_params_lock);
-		memcpy(&default_params, &default_tx_params,
-		       sizeof(struct v4l2_subdev_ir_parameters));
+		default_params = default_tx_params;
 		v4l2_subdev_call(sd, ir, tx_s_parameters, &default_params);
 	} else {
 		kfifo_free(&state->rx_kfifo);
-- 
1.7.4.4


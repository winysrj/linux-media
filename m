Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:39610 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215AbbLFQDr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2015 11:03:47 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/media/usb/as102: constify as102_priv_ops_t structure
Date: Sun,  6 Dec 2015 16:51:38 +0100
Message-Id: <1449417098-8822-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The as102_priv_ops_t structure is never modified, so declare it as
const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/usb/as102/as102_drv.h     |    2 +-
 drivers/media/usb/as102/as102_usb_drv.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/as102/as102_drv.h b/drivers/media/usb/as102/as102_drv.h
index aee2d76..8def19d 100644
--- a/drivers/media/usb/as102/as102_drv.h
+++ b/drivers/media/usb/as102/as102_drv.h
@@ -52,7 +52,7 @@ struct as10x_bus_adapter_t {
 	struct as10x_cmd_t *cmd, *rsp;
 
 	/* bus adapter private ops callback */
-	struct as102_priv_ops_t *ops;
+	const struct as102_priv_ops_t *ops;
 };
 
 struct as102_dev_t {
diff --git a/drivers/media/usb/as102/as102_usb_drv.c b/drivers/media/usb/as102/as102_usb_drv.c
index 3f66906..0e8030c 100644
--- a/drivers/media/usb/as102/as102_usb_drv.c
+++ b/drivers/media/usb/as102/as102_usb_drv.c
@@ -189,7 +189,7 @@ static int as102_read_ep2(struct as10x_bus_adapter_t *bus_adap,
 	return actual_len;
 }
 
-static struct as102_priv_ops_t as102_priv_ops = {
+static const struct as102_priv_ops_t as102_priv_ops = {
 	.upload_fw_pkt	= as102_send_ep1,
 	.xfer_cmd	= as102_usb_xfer_cmd,
 	.as102_read_ep2	= as102_read_ep2,


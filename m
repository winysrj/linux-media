Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:18697 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552AbbLKQ3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 11:29:05 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] go7007: constify go7007_hpi_ops structures
Date: Fri, 11 Dec 2015 17:16:48 +0100
Message-Id: <1449850608-5788-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The go7007_hpi_ops structures are never modified, so declare them as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/pci/saa7134/saa7134-go7007.c |    2 +-
 drivers/media/usb/go7007/go7007-priv.h     |    2 +-
 drivers/media/usb/go7007/go7007-usb.c      |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-priv.h b/drivers/media/usb/go7007/go7007-priv.h
index 745185e..bebee8c 100644
--- a/drivers/media/usb/go7007/go7007-priv.h
+++ b/drivers/media/usb/go7007/go7007-priv.h
@@ -250,7 +250,7 @@ struct go7007 {
 	struct i2c_adapter i2c_adapter;
 
 	/* HPI driver */
-	struct go7007_hpi_ops *hpi_ops;
+	const struct go7007_hpi_ops *hpi_ops;
 	void *hpi_context;
 	int interrupt_available;
 	wait_queue_head_t interrupt_waitq;
diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index 3dbf14c..14d3f8c 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -932,7 +932,7 @@ static void go7007_usb_release(struct go7007 *go)
 	kfree(go->hpi_context);
 }
 
-static struct go7007_hpi_ops go7007_usb_ezusb_hpi_ops = {
+static const struct go7007_hpi_ops go7007_usb_ezusb_hpi_ops = {
 	.interface_reset	= go7007_usb_interface_reset,
 	.write_interrupt	= go7007_usb_ezusb_write_interrupt,
 	.read_interrupt		= go7007_usb_read_interrupt,
@@ -942,7 +942,7 @@ static struct go7007_hpi_ops go7007_usb_ezusb_hpi_ops = {
 	.release		= go7007_usb_release,
 };
 
-static struct go7007_hpi_ops go7007_usb_onboard_hpi_ops = {
+static const struct go7007_hpi_ops go7007_usb_onboard_hpi_ops = {
 	.interface_reset	= go7007_usb_interface_reset,
 	.write_interrupt	= go7007_usb_onboard_write_interrupt,
 	.read_interrupt		= go7007_usb_read_interrupt,
diff --git a/drivers/media/pci/saa7134/saa7134-go7007.c b/drivers/media/pci/saa7134/saa7134-go7007.c
index 8a2abb3..2799538 100644
--- a/drivers/media/pci/saa7134/saa7134-go7007.c
+++ b/drivers/media/pci/saa7134/saa7134-go7007.c
@@ -378,7 +378,7 @@ static int saa7134_go7007_send_firmware(struct go7007 *go, u8 *data, int len)
 	return 0;
 }
 
-static struct go7007_hpi_ops saa7134_go7007_hpi_ops = {
+static const struct go7007_hpi_ops saa7134_go7007_hpi_ops = {
 	.interface_reset	= saa7134_go7007_interface_reset,
 	.write_interrupt	= saa7134_go7007_write_interrupt,
 	.read_interrupt		= saa7134_go7007_read_interrupt,


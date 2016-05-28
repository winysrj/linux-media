Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34969 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbcE1Qno (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2016 12:43:44 -0400
Date: Sat, 28 May 2016 22:13:39 +0530
From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] saa7164: Replace if and BUG with BUG_ON
Message-ID: <20160528164339.GA31143@amitoj-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace if condition and BUG() with a BUG_ON having the conditional
expression of the if statement as argument.

The Coccinelle semantic patch used to make this change is as follows:
@@ expression E,f; @@

(
  if (<+... f(...) ...+>) { BUG(); }
|
- if (E) { BUG(); }
+ BUG_ON(E);
)

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/media/pci/saa7164/saa7164-encoder.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 1b184c3..32a353d 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -1022,8 +1022,7 @@ int saa7164_encoder_register(struct saa7164_port *port)
 
 	dprintk(DBGLVL_ENC, "%s()\n", __func__);
 
-	if (port->type != SAA7164_MPEG_ENCODER)
-		BUG();
+	BUG_ON(port->type != SAA7164_MPEG_ENCODER);
 
 	/* Sanity check that the PCI configuration space is active */
 	if (port->hwcfg.BARLocation == 0) {
@@ -1151,8 +1150,7 @@ void saa7164_encoder_unregister(struct saa7164_port *port)
 
 	dprintk(DBGLVL_ENC, "%s(port=%d)\n", __func__, port->nr);
 
-	if (port->type != SAA7164_MPEG_ENCODER)
-		BUG();
+	BUG_ON(port->type != SAA7164_MPEG_ENCODER);
 
 	if (port->v4l_device) {
 		if (port->v4l_device->minor != -1)
-- 
1.9.1


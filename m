Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:45124 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613AbcACMK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jan 2016 07:10:59 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] av7110: constify sp8870_config structure
Date: Sun,  3 Jan 2016 12:58:14 +0100
Message-Id: <1451822294-9559-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This sp8870_config structure is never modified, so declare it as
const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/pci/ttpci/av7110.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index a69dc6a..18d229f 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -1739,7 +1739,7 @@ static int alps_tdlb7_request_firmware(struct dvb_frontend* fe, const struct fir
 #endif
 }
 
-static struct sp8870_config alps_tdlb7_config = {
+static const struct sp8870_config alps_tdlb7_config = {
 
 	.demod_address = 0x71,
 	.request_firmware = alps_tdlb7_request_firmware,


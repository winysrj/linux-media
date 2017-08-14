Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:40743 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751494AbdHNRYx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 13:24:53 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: ddbridge: constify stv0910_p and lnbh25_cfg
Date: Mon, 14 Aug 2017 18:59:13 +0200
Message-Id: <1502729953-3630-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These structures are only copied into other stuructures, so
they can be const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/pci/ddbridge/ddbridge-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 7e164a37..7ff570b 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -800,14 +800,14 @@ static int tuner_attach_stv6110(struct ddb_input *input, int type)
 	return 0;
 }
 
-static struct stv0910_cfg stv0910_p = {
+static const struct stv0910_cfg stv0910_p = {
 	.adr      = 0x68,
 	.parallel = 1,
 	.rptlvl   = 4,
 	.clk      = 30000000,
 };
 
-static struct lnbh25_config lnbh25_cfg = {
+static const struct lnbh25_config lnbh25_cfg = {
 	.i2c_address = 0x0c << 1,
 	.data2_config = LNBH25_TEN
 };

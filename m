Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47122 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754294AbeDTKJj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 06:09:39 -0400
Date: Fri, 20 Apr 2018 13:09:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] media: davinci_vpfe: fix some potential overflows
Message-ID: <20180420100927.GA30237@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We check "lutdpc->dpc_size" in ipipe_validate_lutdpc_params() but if
it's invalid then we would have corrupted memory already when we do
the memcpy() before calling it.

We don't ever check "gamma->tbl_size" but we should since they come from
the user.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 95942768639c..068b3333e224 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -82,6 +82,8 @@ static int ipipe_set_lutdpc_params(struct vpfe_ipipe_device *ipipe, void *param)
 	lutdpc->en = dpc_param->en;
 	lutdpc->repl_white = dpc_param->repl_white;
 	lutdpc->dpc_size = dpc_param->dpc_size;
+	if (dpc_param->dpc_size > LUT_DPC_MAX_SIZE)
+		return -EINVAL;
 	memcpy(&lutdpc->table, &dpc_param->table,
 	       (dpc_param->dpc_size * sizeof(struct vpfe_ipipe_lutdpc_entry)));
 	if (ipipe_validate_lutdpc_params(lutdpc) < 0)
@@ -591,7 +593,7 @@ ipipe_validate_gamma_entry(struct vpfe_ipipe_gamma_entry *table, int size)
 static int
 ipipe_validate_gamma_params(struct vpfe_ipipe_gamma *gamma, struct device *dev)
 {
-	int table_size;
+	unsigned int table_size;
 	int err;
 
 	if (gamma->bypass_r > 1 ||
@@ -603,6 +605,8 @@ ipipe_validate_gamma_params(struct vpfe_ipipe_gamma *gamma, struct device *dev)
 		return 0;
 
 	table_size = gamma->tbl_size;
+	if (table_size > VPFE_IPIPE_MAX_SIZE_GAMMA)
+		return -EINVAL;
 	if (!gamma->bypass_r) {
 		err = ipipe_validate_gamma_entry(gamma->table_r, table_size);
 		if (err) {

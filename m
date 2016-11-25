Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18540 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbcKYV3W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 16:29:22 -0500
Date: Sat, 26 Nov 2016 00:28:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Benoit Parrot <bparrot@ti.com>,
        Nikhil Devshatwar <nikhil.nd@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] media: ti-vpe: vpdma: fix a timeout loop
Message-ID: <20161125201957.GA30161@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The check assumes that we end on zero but actually we end on -1.  Change
the post-op to a pre-op so that we do end on zero.  Techinically now we
only loop 499 times instead of 500 but that's fine.

Fixes: dc12b124353b ("[media] media: ti-vpe: vpdma: Add abort channel desc and cleanup APIs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 13bfd71..23472e3 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -453,7 +453,7 @@ int vpdma_list_cleanup(struct vpdma_data *vpdma, int list_num,
 	if (ret)
 		return ret;
 
-	while (vpdma_list_busy(vpdma, list_num) && timeout--)
+	while (vpdma_list_busy(vpdma, list_num) && --timeout)
 		;
 
 	if (timeout == 0) {

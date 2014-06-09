Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19609 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbaFIPKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jun 2014 11:10:55 -0400
Date: Mon, 9 Jun 2014 18:10:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] davinci: vpfe: dm365: remove duplicate
 RSZ_LPF_INT_MASK
Message-ID: <20140609151046.GE9600@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RSZ_LPF_INT_MASK define is cut and pasted twice so we can remove the
second instance.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.h b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.h
index 010fdb2..81176fb 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.h
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.h
@@ -479,7 +479,6 @@
 #define RSZ_TYP_Y_SHIFT			0
 #define RSZ_TYP_C_SHIFT			1
 #define RSZ_LPF_INT_MASK		0x3f
-#define RSZ_LPF_INT_MASK		0x3f
 #define RSZ_LPF_INT_C_SHIFT		6
 #define RSZ_H_PHS_MASK			0x3fff
 #define RSZ_H_DIF_MASK			0x3fff

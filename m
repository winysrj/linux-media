Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28191 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbcGNKSg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 06:18:36 -0400
Date: Thu, 14 Jul 2016 13:18:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Sonic Zhang <sonic.zhang@analog.com>
Cc: Maurom.chehab@samsung.com,
	adi-buildroot-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] blackfin: check devm_pinctrl_get() for errors
Message-ID: <20160714101813.GC18175@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_pinctrl_get() can fail so we should check for that.

Fixes: 0a6824bc10de ('[media] v4l2: blackfin: select proper pinctrl state in ppi_set_params if CONFIG_PINCTRL is enabled')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/platform/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
index cff63e5..b8f3d9f 100644
--- a/drivers/media/platform/blackfin/ppi.c
+++ b/drivers/media/platform/blackfin/ppi.c
@@ -214,6 +214,8 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
 	if (params->dlen > 24 || params->dlen <= 0)
 		return -EINVAL;
 	pctrl = devm_pinctrl_get(ppi->dev);
+	if (IS_ERR(pctrl))
+		return PTR_ERR(pctrl);
 	pstate = pinctrl_lookup_state(pctrl,
 				      pin_state[(params->dlen + 7) / 8 - 1]);
 	if (pinctrl_select_state(pctrl, pstate))

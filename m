Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18231 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499AbbJAO1N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2015 10:27:13 -0400
Date: Thu, 1 Oct 2015 22:25:57 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] i2c: fix platform_no_drv_owner.cocci warnings
Message-ID: <20151001142557.GA111674@xian>
References: <201510012253.SfwiqXQS%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201510012253.SfwiqXQS%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/ml86v7667.c:430:3-8: No need to set .owner here. The core will do it.

 Remove .owner field if calls are used which set it automatically

Generated by: scripts/coccinelle/api/platform_no_drv_owner.cocci

CC: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---

 ml86v7667.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/i2c/ml86v7667.c
+++ b/drivers/media/i2c/ml86v7667.c
@@ -427,7 +427,6 @@ MODULE_DEVICE_TABLE(i2c, ml86v7667_id);
 static struct i2c_driver ml86v7667_i2c_driver = {
 	.driver = {
 		.name	= DRV_NAME,
-		.owner	= THIS_MODULE,
 	},
 	.probe		= ml86v7667_probe,
 	.remove		= ml86v7667_remove,

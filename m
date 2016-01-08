Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22972 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbcAHLDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2016 06:03:12 -0500
Date: Fri, 8 Jan 2016 14:02:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Fabian Frederick <fabf@skynet.be>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] wl128x: fix typo in MODULE_PARM_DESC
Message-ID: <20160108110256.GJ32195@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The module_param() is "default_rds_buf" and the MODULE_PARM_DESC()
should match.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index ebc73b0..3f9e6df 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -68,7 +68,7 @@ MODULE_PARM_DESC(default_radio_region, "Region: 0=Europe/US, 1=Japan");
 /* RDS buffer blocks */
 static u32 default_rds_buf = 300;
 module_param(default_rds_buf, uint, 0444);
-MODULE_PARM_DESC(rds_buf, "RDS buffer entries");
+MODULE_PARM_DESC(default_rds_buf, "RDS buffer entries");
 
 /* Radio Nr */
 static u32 radio_nr = -1;

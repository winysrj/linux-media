Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17231 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbcB0KvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 05:51:25 -0500
Date: Sat, 27 Feb 2016 13:51:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch 1/2] [media] tvp5150: off by one
Message-ID: <20160227105109.GD14086@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ->input_ent[] array has TVP5150_INPUT_NUM elements so the > here
should be >=.

Fixes: f7b4b54e6364 ('[media] tvp5150: add HW input connectors support')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index ef393f5..ff18444 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1386,7 +1386,7 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 			goto err_connector;
 		}
 
-		if (input_type > TVP5150_INPUT_NUM) {
+		if (input_type >= TVP5150_INPUT_NUM) {
 			ret = -EINVAL;
 			goto err_connector;
 		}

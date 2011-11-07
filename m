Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:37473 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1KGSom (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 13:44:42 -0500
Date: Mon, 7 Nov 2011 21:44:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Paul Mundt <lethal@linux-sh.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] V4L: mt9t112: use after free in mt9t112_probe()
Message-ID: <20111107184412.GA9207@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

priv gets dereferenced in mt9t112_set_params() so we should return
before calling that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index 32114a3..7b34b11 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -1083,8 +1083,10 @@ static int mt9t112_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
 
 	ret = mt9t112_camera_probe(client);
-	if (ret)
+	if (ret) {
 		kfree(priv);
+		return ret;
+	}
 
 	/* Cannot fail: using the default supported pixel code */
 	mt9t112_set_params(priv, &rect, V4L2_MBUS_FMT_UYVY8_2X8);

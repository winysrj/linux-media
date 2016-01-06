Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36616 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbcAFKGI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2016 05:06:08 -0500
Date: Wed, 6 Jan 2016 13:05:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] vpx3220: signedness bug in vpx3220_fp_read()
Message-ID: <20160106100552.GI23185@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The intent was to return -1 on error and that's what the callers expect
but the current code returns USHRT_MAX instead.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/i2c/vpx3220.c b/drivers/media/i2c/vpx3220.c
index 4b564f1..90b693f 100644
--- a/drivers/media/i2c/vpx3220.c
+++ b/drivers/media/i2c/vpx3220.c
@@ -124,7 +124,7 @@ static int vpx3220_fp_write(struct v4l2_subdev *sd, u8 fpaddr, u16 data)
 	return 0;
 }
 
-static u16 vpx3220_fp_read(struct v4l2_subdev *sd, u16 fpaddr)
+static int vpx3220_fp_read(struct v4l2_subdev *sd, u16 fpaddr)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	s16 data;

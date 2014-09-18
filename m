Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31453 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaIRMXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 08:23:54 -0400
Date: Thu, 18 Sep 2014 15:23:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] mx2-camera: potential negative underflow bug
Message-ID: <20140918122336.GA13147@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My static checker complains:

	drivers/media/platform/soc_camera/mx2_camera.c:1070
	mx2_emmaprp_resize() warn: no lower bound on 'num'

The heuristic is that it's looking for values which the user can
influence and we put an upper bound on them but we (perhaps
accidentally) allow negative numbers.

I am not very familiar with this code but I have looked at it and think
there might be a bug.  Making the variable unsigned seems like a safe
option either way and this silences the static checker warning.

The call tree is:
  -> subdev_do_ioctl()
     -> mx2_camera_set_fmt()
        -> mx2_emmaprp_resize()
The check:
	if (num > RESIZE_NUM_MAX)
can underflow and then we use "num" on the else path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index b40bc2e..bc27a47 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1003,7 +1003,7 @@ static int mx2_emmaprp_resize(struct mx2_camera_dev *pcdev,
 			      struct v4l2_mbus_framefmt *mf_in,
 			      struct v4l2_pix_format *pix_out, bool apply)
 {
-	int num, den;
+	unsigned int num, den;
 	unsigned long m;
 	int i, dir;
 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:45077 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab2AJJEy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 04:04:54 -0500
Date: Tue, 10 Jan 2012 12:04:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Steven Toth <stoth@kernellabs.com>,
	Mijhail Moreyra <mijhail.moreyra@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] cx23885: handle errors from
 videobuf_dvb_get_frontend()
Message-ID: <20120110090439.GA15570@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The error handling in the original code wasn't complete so static
checkers complained about a potential NULL deference.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Compile tested only.  I don't think there is anything else that needs to
be done before returning, but it would be great if someone could look it
over.

diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index a01cd11..7ad7b4f 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -1541,7 +1541,6 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 	struct v4l2_control ctrl;
 	struct videobuf_dvb_frontend *vfe;
 	struct dvb_frontend *fe;
-	int err = 0;
 
 	struct analog_parameters params = {
 		.mode      = V4L2_TUNER_ANALOG_TV,
@@ -1563,8 +1562,10 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 		params.frequency, f->tuner, params.std);
 
 	vfe = videobuf_dvb_get_frontend(&dev->ts2.frontends, 1);
-	if (!vfe)
-		err = -EINVAL;
+	if (!vfe) {
+		mutex_unlock(&dev->lock);
+		return -EINVAL;
+	}
 
 	fe = vfe->dvb.frontend;
 

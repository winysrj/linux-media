Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:18807 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933966Ab2GLOrt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 10:47:49 -0400
Date: Thu, 12 Jul 2012 17:47:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [media] tvp5150: signedness bug in tvp5150_selmux()
Message-ID: <20120712144727.GC24202@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tvp5150_read() returns negative error codes so this needs to be an int
for the error handling to work.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index 0d897cb..a751b6c 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -257,7 +257,7 @@ static inline void tvp5150_selmux(struct v4l2_subdev *sd)
 	int opmode = 0;
 	struct tvp5150 *decoder = to_tvp5150(sd);
 	int input = 0;
-	unsigned char val;
+	int val;
 
 	if ((decoder->output & TVP5150_BLACK_SCREEN) || !decoder->enable)
 		input = 8;

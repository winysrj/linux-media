Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60404 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab0IXOOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>,
	Mike Isely <isely@pobox.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: [PATCH 07/16] pvrusb2: Don't use module names to load I2C modules
Date: Fri, 24 Sep 2010 16:14:05 +0200
Message-Id: <1285337654-5044-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the v4l2_i2c_new_subdev* functions now supporting loading modules
based on modaliases, replace the hardcoded module name passed to those
functions by NULL.

All corresponding I2C modules have been checked, and all of them include
a module aliases table with names corresponding to what the pvrusb2
driver uses.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/pvrusb2/pvrusb2-hdw.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index 70ea578..bef2027 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -2082,20 +2082,13 @@ static int pvr2_hdw_load_subdev(struct pvr2_hdw *hdw,
 		return -EINVAL;
 	}
 
-	/* Note how the 2nd and 3rd arguments are the same for
-	 * v4l2_i2c_new_subdev().  Why?
-	 * Well the 2nd argument is the module name to load, while the 3rd
-	 * argument is documented in the framework as being the "chipid" -
-	 * and every other place where I can find examples of this, the
-	 * "chipid" appears to just be the module name again.  So here we
-	 * just do the same thing. */
 	if (i2ccnt == 1) {
 		pvr2_trace(PVR2_TRACE_INIT,
 			   "Module ID %u:"
 			   " Setting up with specified i2c address 0x%x",
 			   mid, i2caddr[0]);
 		sd = v4l2_i2c_new_subdev(&hdw->v4l2_dev, &hdw->i2c_adap,
-					 fname, fname,
+					 NULL, fname,
 					 i2caddr[0], NULL);
 	} else {
 		pvr2_trace(PVR2_TRACE_INIT,
@@ -2103,7 +2096,7 @@ static int pvr2_hdw_load_subdev(struct pvr2_hdw *hdw,
 			   " Setting up with address probe list",
 			   mid);
 		sd = v4l2_i2c_new_subdev(&hdw->v4l2_dev, &hdw->i2c_adap,
-						fname, fname,
+						NULL, fname,
 						0, i2caddr);
 	}
 
-- 
1.7.2.2


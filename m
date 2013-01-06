Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab3AFR2n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 12:28:43 -0500
Date: Sun, 6 Jan 2013 15:28:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>,
	LMML <linux-media@vger.kernel.org>
Subject: Fw: [PATCH] media: cx18, ivtv: do not dereference array before
 index check
Message-ID: <20130106152810.4a6493e2@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This one also didn't arrive.

I only noticed those two messages because I cleaned today my patchwork's
queue and didn't notice them arriving at patchwork on linuxtv.org.

Regards,
Mauro

Forwarded message:

Date: Sat,  5 Jan 2013 14:11:56 -0500
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Andy Walls <awalls@md.metrocast.net>,        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] media: cx18, ivtv: do not dereference array before index check


Move dereferencing of hw_devicenames[], hw_bus[] arrays until after
checking that idx is within range.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 drivers/media/pci/cx18/cx18-i2c.c |   10 +++++++---
 drivers/media/pci/ivtv/ivtv-i2c.c |    5 ++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
index 4908eb7..d164239 100644
--- a/drivers/media/pci/cx18/cx18-i2c.c
+++ b/drivers/media/pci/cx18/cx18-i2c.c
@@ -111,14 +111,18 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 int cx18_i2c_register(struct cx18 *cx, unsigned idx)
 {
 	struct v4l2_subdev *sd;
-	int bus = hw_bus[idx];
-	struct i2c_adapter *adap = &cx->i2c_adap[bus];
-	const char *type = hw_devicenames[idx];
+	int bus;
+	struct i2c_adapter *adap;
+	const char *type;
 	u32 hw = 1 << idx;
 
 	if (idx >= ARRAY_SIZE(hw_addrs))
 		return -1;
 
+	bus = hw_bus[idx];
+	adap = &cx->i2c_adap[bus];
+	type = hw_devicenames[idx];
+
 	if (hw == CX18_HW_TUNER) {
 		/* special tuner group handling */
 		sd = v4l2_i2c_new_subdev(&cx->v4l2_dev,
diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index 46e262b..c6af94c 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -264,11 +264,14 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
 {
 	struct v4l2_subdev *sd;
 	struct i2c_adapter *adap = &itv->i2c_adap;
-	const char *type = hw_devicenames[idx];
+	const char *type;
 	u32 hw = 1 << idx;
 
 	if (idx >= ARRAY_SIZE(hw_addrs))
 		return -1;
+
+	type = hw_devicenames[idx];
+
 	if (hw == IVTV_HW_TUNER) {
 		/* special tuner handling */
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev, adap, type, 0,
-- 
1.7.10.4



-- 

Cheers,
Mauro

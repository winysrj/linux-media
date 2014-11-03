Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:49225 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbaKCKol (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 05:44:41 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0DC522A0376
	for <linux-media@vger.kernel.org>; Mon,  3 Nov 2014 11:44:37 +0100 (CET)
Message-ID: <54575C94.7060205@xs4all.nl>
Date: Mon, 03 Nov 2014 11:44:36 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v3.18] vivid: default to single planar device instances
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The default used to be that the first vivid device instance was
single planar, the second multi planar, the third single planar, etc.

However, that turned out to be unexpected and awkward. Change the
driver to always default to single planar.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/vivid.txt       | 12 +++++-------
 drivers/media/platform/vivid/vivid-core.c | 11 +++--------
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/Documentation/video4linux/vivid.txt b/Documentation/video4linux/vivid.txt
index eeb11a2..e5a940e 100644
--- a/Documentation/video4linux/vivid.txt
+++ b/Documentation/video4linux/vivid.txt
@@ -221,12 +221,11 @@ ccs_out_mode: specify the allowed video output crop/compose/scaling combination
 		       key, not quality.
 
 multiplanar: select whether each device instance supports multi-planar formats,
-	and thus the V4L2 multi-planar API. By default the first device instance
-	is single-planar, the second multi-planar, and it keeps alternating.
+	and thus the V4L2 multi-planar API. By default device instances are
+	single-planar.
 
 	This module option can override that for each instance. Values are:
 
-		0: use alternating single and multi-planar devices.
 		1: this is a single-planar instance.
 		2: this is a multi-planar instance.
 
@@ -975,9 +974,8 @@ is set, then the alpha component is only used for the color red and set to
 0 otherwise.
 
 The driver has to be configured to support the multiplanar formats. By default
-the first driver instance is single-planar, the second is multi-planar, and it
-keeps alternating. This can be changed by setting the multiplanar module option,
-see section 1 for more details on that option.
+the driver instances are single-planar. This can be changed by setting the
+multiplanar module option, see section 1 for more details on that option.
 
 If the driver instance is using the multiplanar formats/API, then the first
 single planar format (YUYV) and the multiplanar NV16M and NV61M formats the
@@ -1021,7 +1019,7 @@ the output overlay for the video output, turn on video looping and capture
 to see the blended framebuffer overlay that's being written to by the second
 instance. This setup would require the following commands:
 
-	$ sudo modprobe vivid n_devs=2 node_types=0x10101,0x1 multiplanar=1,1
+	$ sudo modprobe vivid n_devs=2 node_types=0x10101,0x1
 	$ v4l2-ctl -d1 --find-fb
 	/dev/fb1 is the framebuffer associated with base address 0x12800000
 	$ sudo v4l2-ctl -d2 --set-fbuf fb=1
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 2c61a62..686c3c2 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -100,11 +100,9 @@ MODULE_PARM_DESC(ccs_out_mode, " output crop/compose/scale mode:\n"
 			   "\t\t    bit 0=crop, 1=compose, 2=scale,\n"
 			   "\t\t    -1=user-controlled (default)");
 
-static unsigned multiplanar[VIVID_MAX_DEVS];
+static unsigned multiplanar[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = 1 };
 module_param_array(multiplanar, uint, NULL, 0444);
-MODULE_PARM_DESC(multiplanar, " 0 (default) is alternating single and multiplanar devices,\n"
-			      "\t\t    1 is single planar devices,\n"
-			      "\t\t    2 is multiplanar devices");
+MODULE_PARM_DESC(multiplanar, " 1 (default) creates a single planar device, 2 creates a multiplanar device.");
 
 /* Default: video + vbi-cap (raw and sliced) + radio rx + radio tx + sdr + vbi-out + vid-out */
 static unsigned node_types[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = 0x1d3d };
@@ -669,10 +667,7 @@ static int __init vivid_create_instance(int inst)
 	/* start detecting feature set */
 
 	/* do we use single- or multi-planar? */
-	if (multiplanar[inst] == 0)
-		dev->multiplanar = inst & 1;
-	else
-		dev->multiplanar = multiplanar[inst] > 1;
+	dev->multiplanar = multiplanar[inst] > 1;
 	v4l2_info(&dev->v4l2_dev, "using %splanar format API\n",
 			dev->multiplanar ? "multi" : "single ");
 
-- 
2.1.0


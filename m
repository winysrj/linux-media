Return-path: <mchehab@localhost>
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:32974 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1GKKlu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 06:41:50 -0400
Message-ID: <4E1AD36D.4030702@cam.ac.uk>
Date: Mon, 11 Jul 2011 11:41:49 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Error routes through omap3isp ccdc.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi All,

Came across this when my camera driver failed to load..

Following causes a kernel panic.

Set up link between cdcc and ccdc output to memory.
(at this point intitializing a capture gives an invalid
arguement error which is fine.)

Now set the format on ISP CCDC/0 to SGRBG10 752x480 (doubt what these
settings are actually matters).  Actually come to think of it, this
may only be relevant as otherwise, the format of my attempted stream
setup from userspace doesn't matter.

Blithely attempt to grab frames from userspace off the ccdc output.
(note it has no input.)

Null pointer exception occurs because:

pad = media_entity_remote_source(&ccdc->pads[CCDC_PAD_SINK]);
in 
static void ccdc_configure(struct isp_ccdc_device *ccdc)

returns null and this is not checked.

Obvious local fix is to check the value of pad and allow ccdc_configure
to return an error + pass this up out of ccdc_set_stream.

Something like the following does the trick.
(not sure error code is right choice!)

Patch is against todays linux-next + a few unconnected things to make
that tree actually build for the beagle xm.

Grep isn't indicating any exactly matching cases to this problem, so
the rest of the tree may be fine.

 [PATCH] omap3isp: check if there is actually a source for ispccdc when
 setting up the link.

Without this if no source actually exists and the ccdc is configured
to output to memory, a read from userspace will cause a null pointer
exception.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/media/video/omap3isp/ispccdc.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 6766247..2703a94 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1110,7 +1110,7 @@ static const u32 ccdc_sgbrg_pattern =
 	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP3PLC2_SHIFT |
 	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP3PLC3_SHIFT;
 
-static void ccdc_configure(struct isp_ccdc_device *ccdc)
+static int ccdc_configure(struct isp_ccdc_device *ccdc)
 {
 	struct isp_device *isp = to_isp_device(ccdc);
 	struct isp_parallel_platform_data *pdata = NULL;
@@ -1127,6 +1127,8 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	u32 ccdc_pattern;
 
 	pad = media_entity_remote_source(&ccdc->pads[CCDC_PAD_SINK]);
+	if (pad == NULL)
+		return -ENODEV;
 	sensor = media_entity_to_v4l2_subdev(pad->entity);
 	if (ccdc->input == CCDC_INPUT_PARALLEL)
 		pdata = &((struct isp_v4l2_subdevs_group *)sensor->host_priv)
@@ -1257,6 +1259,7 @@ unlock:
 	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
 
 	ccdc_apply_controls(ccdc);
+	return 0;
 }
 
 static void __ccdc_enable(struct isp_ccdc_device *ccdc, int enable)
@@ -1726,7 +1729,9 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
 		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
 			    ISPCCDC_CFG_VDLC);
 
-		ccdc_configure(ccdc);
+		ret = ccdc_configure(ccdc);
+		if (ret < 0)
+			return ret;
 
 		/* TODO: Don't configure the video port if all of its output
 		 * links are inactive.
-- 
1.7.3.4


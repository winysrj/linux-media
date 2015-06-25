Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53790 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbbFYNQ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 09:16:27 -0400
Message-ID: <1435238185.3761.20.camel@pengutronix.de>
Subject: Re: i.MX6 video capture support in mainline
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Javier Martin <javiermartin@by.com.es>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Thu, 25 Jun 2015 15:16:25 +0200
In-Reply-To: <558932F7.3070509@by.com.es>
References: <558932F7.3070509@by.com.es>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Am Dienstag, den 23.06.2015, 12:20 +0200 schrieb Javier Martin:
[...]
> media-ctl -l '"IPU0 SMFC0":1->"imx-ipuv3-camera.2":0[1]'
> 
> The last command will fail like this:
> 
> imx-ipuv3 2400000.ipu: invalid link 'IPU0 SMFC0'(5):1 -> 
> 'imx-ipuv3-camera.2'(2):0
> Unable to parse link: Invalid argument (22)
> 
> The reason it fails, apparently, is that the links that have been 
> created when opening /dev/video0 are not included in the "ipu_links[]" 
> static table defined in "drivers/gpio/ipu-v3/ipu-media.c" which is where 
> the "ipu_smfc_link_setup()" function tries to find a valid link.

Those are the IPU internal links, not handling the video device node
entities is a bug in ipu-media. Try something like this:

-----8<-----
diff --git a/drivers/gpu/ipu-v3/ipu-media.c b/drivers/gpu/ipu-v3/ipu-media.c
index fda80c7..920806c 100644
--- a/drivers/gpu/ipu-v3/ipu-media.c
+++ b/drivers/gpu/ipu-v3/ipu-media.c
@@ -341,14 +341,16 @@ static int ipu_smfc_link_setup(struct media_entity *entity,
 			       const struct media_pad *remote, u32 flags)
 {
 	struct ipu_soc *ipu = to_ipu(entity);
-	const struct ipu_link *link;
+	const struct ipu_link *link = NULL;
 	const struct ipu_pad *pad;
 	u32 mask, sel = FS_SEL_ARM;
 	int csi, smfc;
 
-	link = ipu_find_link(ipu, local, remote);
-	if (!link)
-		return ipu_invalid_link(ipu, local, remote);
+	if (remote->entity->type != MEDIA_ENT_T_DEVNODE_V4L) {
+		link = ipu_find_link(ipu, local, remote);
+		if (!link)
+			return ipu_invalid_link(ipu, local, remote);
+	}
 
 	if (local->flags & MEDIA_PAD_FL_SINK) {
 		/* SMFC_MAP_CHx */
@@ -371,7 +373,7 @@ static int ipu_smfc_link_setup(struct media_entity *entity,
 		/* SMFCx_DEST_SEL */
 		pad = &ipu_entities[ipu_entity(ipu, entity)].pads[local->index];
 		mask = pad->mask << pad->offset;
-		if (flags & MEDIA_LNK_FL_ENABLED)
+		if (link && (flags & MEDIA_LNK_FL_ENABLED))
 			sel = link->dest_sel << pad->offset;
 
 		ipu_cm_update_bits(ipu, IPU_FS_PROC_FLOW3, mask, sel);
----->8-----

> I've got some questions regarding this driver and iMX6 video capture 
> support in general that someone here may gladly answer:
> 
> a) Is anyone currently working on mainlining iMX6 video capture support? 
> I know about Steve's and Philipp's work but I haven't seen any progress 
> since September 2014.

I am working on this on and off, but haven't found the time to fit in
the media entity rework.

> b) Does anyone know whether it's possible to capture YUV420P video using 
> the driver in Philipp's repository? If so could you please provide the 
> pipeline setup that you used with media-ctl?

What do you mean by YUV420P? The capture driver supports
V4L2_PIX_FMT_YUV420, but not the V4L2_PIX_FMT_YUV420M multiplanar
format, because the hardware U/V planes are just fixed offsets from a
base address. Memory bandwidth consumption wise, the most efficient
formats are NV12 and YUYV/UYVY.

> c) If we were willing to help with mainline submission of this driver 
> what issues should we focus on?

In my opinion, the media entities should be reworked and reduced to just
two CSI entities, a single IC(PRP) entity, and four video device nodes
(that correspond to the SMFC[0-3] FIFOs / CSI[0-3] IDMAC channels) with
their entities for each IPU.
Describing details like the SMFC FIFOs or different IC stages as media
entities and describing the IDMAC channel linking via buffers in system
RAM as links between media entities turned out to be the wrong
abstraction.
One thing I'm not yet clear about is how to handle MIPI CSI-2 streams
with multiple virtual channels properly, but I haven't seen hardware
that produces such streams yet.

regards
Philipp


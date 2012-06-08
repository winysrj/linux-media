Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55414 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776Ab2FHInQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 04:43:16 -0400
Date: Fri, 8 Jun 2012 10:43:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Uzycki <janusz.uzycki@elproma.com.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: SH7724, VOU, PAL mode
In-Reply-To: <D97F21569FF045CD872858C23EBB78B0@laptop2>
Message-ID: <Pine.LNX.4.64.1206080855020.31213@axis700.grange>
References: <1E539FC23CF84B8A91428720570395E0@laptop2>
 <Pine.LNX.4.64.1101241720001.17567@axis700.grange> <AD14536027B946D6B4504D4F43E352A5@laptop2>
 <Pine.LNX.4.64.1101262045550.3989@axis700.grange> <F95361ABAE1D4A70A10790A798004482@laptop2>
 <Pine.LNX.4.64.1101271809030.8916@axis700.grange> <8026191608244DB98F002E983C866149@laptop2>
 <Pine.LNX.4.64.1102011420540.6673@axis700.grange> <18BE1662A1F04B6C8B39AA46440A3FBB@laptop2>
 <Pine.LNX.4.64.1102011532360.6673@axis700.grange> <2F2263A44E0F466F898DD3E2F1D19F12@laptop2>
 <Pine.LNX.4.64.1102081427500.1393@axis700.grange> <CEA83F28AF7C47E7B83AE1DBFFBC8514@laptop2>
 <Pine.LNX.4.64.1206051651220.2145@axis700.grange> <151B1A2540C945E48D7AAE0A8FC2DDEE@laptop2>
 <Pine.LNX.4.64.1206061614250.12739@axis700.grange> <D97F21569FF045CD872858C23EBB78B0@laptop2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Janusz

On Wed, 6 Jun 2012, Janusz Uzycki wrote:

> > > This is why "v4l2-ctl -s 5" used before my simple test program (modified
> > > capture example with mmap method) finally has no effect for VOU.
> > > When the test program opens video device it causes reset PAL mode in VOU
> > > and
> > > does not in TV encoder.
> > 
> > Right, this is actually a bug in the VOU driver. It didn't affect me,
> > because I was opening the device only once before all the configuration
> > and streaming. Could you create and submit a patch to save the standard in
> > driver private data and restore it on open() after the reset? I guess,
> > other configuration parameters are lost too, feel free to fix them as
> > well.
> 
> Here you are. Something like that?

Yes, thanks, something like that. But please use a proper line-wrap 
formatting and submit it as a patch, according to the rules, specified in 
Documentation/SubmittingPatches, i.e., i.e., send it as a separate email 
with an appropriate subject, patch description, your Signed-off-by.

> I avoided encoder reconfiguration (it is
> not needed) - do not call sh_vou_s_std() and in result
> v4l2_device_call_until_err().
> 
> --- sh_vou.c.orig       2012-06-06 15:58:28.785086939 +0000
> +++ sh_vou.c    2012-06-06 17:04:30.684586479 +0000
> @@ -1183,6 +1183,13 @@ static int sh_vou_open(struct file *file
>                        vou_dev->status = SH_VOU_IDLE;
>                        return ret;
>                }
> +
> +               /* restore std */
> +               if (vou_dev->std & V4L2_STD_525_60)
> +                       sh_vou_reg_ab_set(vou_dev, VOUCR,
> + sh_vou_ntsc_mode(vou_dev->pdata->bus_fmt) << 29, 7 << 29);
> +               else
> +                       sh_vou_reg_ab_set(vou_dev, VOUCR, 5 << 29, 7 << 29);
>        }
> 
>        videobuf_queue_dma_contig_init(&vou_file->vbq, &sh_vou_video_qops,

Looks like you copied this code from sh_vou_s_std(). This does fix your 
PAL problem, at least to some extent, right? But we think, that we will 
eventually have to restore more configuration, than only the video 
standard on open(), right? Thinking about that, maybe it's easier to 
actually configure the hardware not as currently done immediately, but 
inside the .vidioc_streamon() handler. Could you maybe try the patch, 
attached below (to be applied without your proposed fix)? It's only 
compile tested, so, no guarantees.

> I tested the std restoring and picture is synced/stable in PAL mode now.
> However I  have still problem after 480 line because next lines are always
> green.
> Fixing other configuration parameters seems little more complicated
> (sh_vou_s_fmt_vid_out(), sh_vou_configure_geometry()).
> 
> > > > > I noticed that VOU is limited to NTSC resolution: "Maximum > >
> > > destination
> > > > > image
> > > > > size: 720 x 240 per field".
> > > >
> > > > You mean in the datasheet?
> > > 
> > > Yes, exactly.
> > > 
> > > > I don't have it currently at hand, but I seem
> > > > to remember, that there was a bug and the VOU does actually support a >
> > > full
> > > > PAL resolution too. I'm not 100% certain, though.
> > > 
> > > OK, I will test it. Do you remember how you discovered that?
> > 
> > Asked the manufacturer company :)
> 
> OK:) I found the sentence in sh_vou.c: "Cropping scheme: max useful image is
> 720x480, and the total video area is 858x525 (NTSC) or 864x625 (PAL)." Next is
> some magic:)

BTW, I've found the commit, that addresses that PAL documentation bug: 
765fe17c4f018c019f1976455084f528474fc7f8

> > No, I'll send it to you off the list - Laurent agreed. But he also said,
> > it was a preliminary version of his yavta proram, so, you might be able to
> > use that one.
> 
> OK, the code you sent works much better than my simple video output program
> but the same problem after 480 line. I have to investigate it.
> I use yavta for frame capturing tests.
> 
> Unfortunately I will be outside the company next 2 weeks. I will have remote
> access only to my hardware so more tests are not possible then.

Ok, let's wait then. Have a good journey!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

Subject: V4L: sh_vou: move hardware configuration to .vidioc_streamon()

The V4L2 spec mandates, that drivers preserve their configuration across 
close() / open() cycles. Currently the sh_vou driver violates this 
requirement by resetting the hardware upon each open() thus losing VOU's 
configuration. This patch moves hardware configuration from respective 
ioctl()s to the .vidioc_streamon() handler to guarantee, that the 
streaming is always performed with a configured hardware.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index 6a72987..50e39f7 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -72,6 +72,8 @@ struct sh_vou_device {
 	struct list_head queue;
 	v4l2_std_id std;
 	int pix_idx;
+	int w_idx;
+	int h_idx;
 	struct videobuf_buffer *active;
 	enum sh_vou_status status;
 	struct mutex fop_lock;
@@ -436,15 +438,16 @@ static const unsigned char vou_scale_v_num[] = {1, 2, 4};
 static const unsigned char vou_scale_v_den[] = {1, 1, 1};
 static const unsigned char vou_scale_v_fld[] = {0, 1};
 
-static void sh_vou_configure_geometry(struct sh_vou_device *vou_dev,
-				      int pix_idx, int w_idx, int h_idx)
+static void sh_vou_configure_geometry(struct sh_vou_device *vou_dev)
 {
-	struct sh_vou_fmt *fmt = vou_fmt + pix_idx;
 	unsigned int black_left, black_top, width_max, height_max,
 		frame_in_height, frame_out_height, frame_out_top;
 	struct v4l2_rect *rect = &vou_dev->rect;
 	struct v4l2_pix_format *pix = &vou_dev->pix;
 	u32 vouvcr = 0, dsr_h, dsr_v;
+	int w_idx = vou_dev->w_idx;
+	int h_idx = vou_dev->h_idx;
+	struct sh_vou_fmt *fmt = vou_fmt + vou_dev->pix_idx;
 
 	if (vou_dev->std & V4L2_STD_525_60) {
 		width_max = 858;
@@ -754,8 +757,8 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 
 	vou_dev->pix = *pix;
 
-	sh_vou_configure_geometry(vou_dev, pix_idx,
-				  geo.scale_idx_h, geo.scale_idx_v);
+	vou_dev->w_idx = geo.scale_idx_h;
+	vou_dev->h_idx = geo.scale_idx_v;
 
 	return 0;
 }
@@ -825,6 +828,21 @@ static int sh_vou_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 	return videobuf_dqbuf(&vou_file->vbq, b, file->f_flags & O_NONBLOCK);
 }
 
+static u32 sh_vou_ntsc_mode(enum sh_vou_bus_fmt bus_fmt)
+{
+	switch (bus_fmt) {
+	default:
+		pr_warning("%s(): Invalid bus-format code %d, using default 8-bit\n",
+			   __func__, bus_fmt);
+	case SH_VOU_BUS_8BIT:
+		return 1;
+	case SH_VOU_BUS_16BIT:
+		return 0;
+	case SH_VOU_BUS_BT656:
+		return 3;
+	}
+}
+
 static int sh_vou_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type buftype)
 {
@@ -835,6 +853,14 @@ static int sh_vou_streamon(struct file *file, void *priv,
 
 	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
 
+	if (vou_dev->std & V4L2_STD_525_60)
+		sh_vou_reg_ab_set(vou_dev, VOUCR,
+			sh_vou_ntsc_mode(vou_dev->pdata->bus_fmt) << 29, 7 << 29);
+	else
+		sh_vou_reg_ab_set(vou_dev, VOUCR, 5 << 29, 7 << 29);
+
+	sh_vou_configure_geometry(vou_dev);
+
 	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0,
 					 video, s_stream, 1);
 	if (ret < 0 && ret != -ENOIOCTLCMD)
@@ -863,21 +889,6 @@ static int sh_vou_streamoff(struct file *file, void *priv,
 	return 0;
 }
 
-static u32 sh_vou_ntsc_mode(enum sh_vou_bus_fmt bus_fmt)
-{
-	switch (bus_fmt) {
-	default:
-		pr_warning("%s(): Invalid bus-format code %d, using default 8-bit\n",
-			   __func__, bus_fmt);
-	case SH_VOU_BUS_8BIT:
-		return 1;
-	case SH_VOU_BUS_16BIT:
-		return 0;
-	case SH_VOU_BUS_BT656:
-		return 3;
-	}
-}
-
 static int sh_vou_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 {
 	struct video_device *vdev = video_devdata(file);
@@ -895,12 +906,6 @@ static int sh_vou_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 	if (ret < 0 && ret != -ENOIOCTLCMD)
 		return ret;
 
-	if (*std_id & V4L2_STD_525_60)
-		sh_vou_reg_ab_set(vou_dev, VOUCR,
-			sh_vou_ntsc_mode(vou_dev->pdata->bus_fmt) << 29, 7 << 29);
-	else
-		sh_vou_reg_ab_set(vou_dev, VOUCR, 5 << 29, 7 << 29);
-
 	vou_dev->std = *std_id;
 
 	return 0;
@@ -1010,8 +1015,8 @@ static int sh_vou_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
 	pix->width = geo.in_width;
 	pix->height = geo.in_height;
 
-	sh_vou_configure_geometry(vou_dev, vou_dev->pix_idx,
-				  geo.scale_idx_h, geo.scale_idx_v);
+	vou_dev->w_idx = geo.scale_idx_h;
+	vou_dev->h_idx = geo.scale_idx_v;
 
 	return 0;
 }

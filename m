Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3454 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab0CMQ1U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 11:27:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: e9hack <e9hack@googlemail.com>
Subject: Re: changeset 14351:2eda2bcc8d6f
Date: Sat, 13 Mar 2010 17:27:06 +0100
Cc: dougsland@redhat.com, Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <4B8E4A6F.2050809@googlemail.com>
In-Reply-To: <4B8E4A6F.2050809@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003131727.06450.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hartmut,

After reviewing your patch I realized that more needed to be done to get this
to work properly. The core problem is that the probe function does not have a
counterpart that can do a cleanup.

So if the probe fails, then v4l2_device_unregister will never be called, which
is a particular problem on mxb.

I've made a new patch that basically reverts my original patch and instead
modifies the mxb driver. I realized that mxb doesn't need to do a separate
probe. Instead attach can just call probe and return an error if it fails.

This way I can avoid the devinit and the cleanup is also much more straightforward.

If there are no further comments, then I'll post a pull request in a few days.

Tested with the mxb board. It would be nice if you can verify this with the
av7110.

Regards,

	Hans

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index fd8e1f4..7364b96 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -423,15 +423,14 @@ static void vv_callback(struct saa7146_dev *dev, unsigned long status)
 	}
 }
 
-int saa7146_vv_devinit(struct saa7146_dev *dev)
-{
-	return v4l2_device_register(&dev->pci->dev, &dev->v4l2_dev);
-}
-EXPORT_SYMBOL_GPL(saa7146_vv_devinit);
-
 int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 {
 	struct saa7146_vv *vv;
+	int err;
+
+	err = v4l2_device_register(&dev->pci->dev, &dev->v4l2_dev);
+	if (err)
+		return err;
 
 	vv = kzalloc(sizeof(struct saa7146_vv), GFP_KERNEL);
 	if (vv == NULL) {
diff --git a/drivers/media/video/hexium_gemini.c b/drivers/media/video/hexium_gemini.c
index e620a3a..ad2c232 100644
--- a/drivers/media/video/hexium_gemini.c
+++ b/drivers/media/video/hexium_gemini.c
@@ -356,9 +356,6 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 
 	DEB_EE((".\n"));
 
-	ret = saa7146_vv_devinit(dev);
-	if (ret)
-		return ret;
 	hexium = kzalloc(sizeof(struct hexium), GFP_KERNEL);
 	if (NULL == hexium) {
 		printk("hexium_gemini: not enough kernel memory in hexium_attach().\n");
diff --git a/drivers/media/video/hexium_orion.c b/drivers/media/video/hexium_orion.c
index fe596a1..938a1f8 100644
--- a/drivers/media/video/hexium_orion.c
+++ b/drivers/media/video/hexium_orion.c
@@ -216,10 +216,6 @@ static int hexium_probe(struct saa7146_dev *dev)
 		return -EFAULT;
 	}
 
-	err = saa7146_vv_devinit(dev);
-	if (err)
-		return err;
-
 	hexium = kzalloc(sizeof(struct hexium), GFP_KERNEL);
 	if (NULL == hexium) {
 		printk("hexium_orion: hexium_probe: not enough kernel memory.\n");
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index 9f01f14..ef0c817 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -169,11 +169,7 @@ static struct saa7146_extension extension;
 static int mxb_probe(struct saa7146_dev *dev)
 {
 	struct mxb *mxb = NULL;
-	int err;
 
-	err = saa7146_vv_devinit(dev);
-	if (err)
-		return err;
 	mxb = kzalloc(sizeof(struct mxb), GFP_KERNEL);
 	if (mxb == NULL) {
 		DEB_D(("not enough kernel memory.\n"));
@@ -699,14 +695,17 @@ static struct saa7146_ext_vv vv_data;
 /* this function only gets called when the probing was successful */
 static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
 {
-	struct mxb *mxb = (struct mxb *)dev->ext_priv;
+	struct mxb *mxb;
 
 	DEB_EE(("dev:%p\n", dev));
 
-	/* checking for i2c-devices can be omitted here, because we
-	   already did this in "mxb_vl42_probe" */
-
 	saa7146_vv_init(dev, &vv_data);
+	if (mxb_probe(dev)) {
+		saa7146_vv_release(dev);
+		return -1;
+	}
+	mxb = (struct mxb *)dev->ext_priv;
+
 	vv_data.ops.vidioc_queryctrl = vidioc_queryctrl;
 	vv_data.ops.vidioc_g_ctrl = vidioc_g_ctrl;
 	vv_data.ops.vidioc_s_ctrl = vidioc_s_ctrl;
@@ -726,6 +725,7 @@ static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data
 	vv_data.ops.vidioc_default = vidioc_default;
 	if (saa7146_register_device(&mxb->video_dev, dev, "mxb", VFL_TYPE_GRABBER)) {
 		ERR(("cannot register capture v4l2 device. skipping.\n"));
+		saa7146_vv_release(dev);
 		return -1;
 	}
 
@@ -846,7 +846,6 @@ static struct saa7146_extension extension = {
 	.pci_tbl	= &pci_tbl[0],
 	.module		= THIS_MODULE,
 
-	.probe		= mxb_probe,
 	.attach		= mxb_attach,
 	.detach		= mxb_detach,
 
diff --git a/include/media/saa7146_vv.h b/include/media/saa7146_vv.h
index b9da1f5..4aeff96 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/saa7146_vv.h
@@ -188,7 +188,6 @@ void saa7146_buffer_timeout(unsigned long data);
 void saa7146_dma_free(struct saa7146_dev* dev,struct videobuf_queue *q,
 						struct saa7146_buf *buf);
 
-int saa7146_vv_devinit(struct saa7146_dev *dev);
 int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv);
 int saa7146_vv_release(struct saa7146_dev* dev);
 


On Wednesday 03 March 2010 12:39:27 e9hack wrote:
> Hi,
> 
> changeset 14351:2eda2bcc8d6f is incomplete. If the init function is split in two function,
> the deinit function shall consider this. The changes shall be apply also to av7110_init_v4l().
> 
> diff -r 58ae12f18e80 linux/drivers/media/common/saa7146_fops.c
> --- a/linux/drivers/media/common/saa7146_fops.c Tue Mar 02 23:52:36 2010 -0300
> +++ b/linux/drivers/media/common/saa7146_fops.c Wed Mar 03 12:15:23 2010 +0100
> @@ -481,8 +481,10 @@ int saa7146_vv_release(struct saa7146_de
>         DEB_EE(("dev:%p\n",dev));
> 
>         v4l2_device_unregister(&dev->v4l2_dev);
> -       pci_free_consistent(dev->pci, SAA7146_CLIPPING_MEM, vv->d_clipping.cpu_addr,
> vv->d_clipping.dma_handle);
> -       kfree(vv);
> +       if (vv) {
> +               pci_free_consistent(dev->pci, SAA7146_CLIPPING_MEM,
> vv->d_clipping.cpu_addr, vv->d_clipping.dma_handle);
> +               kfree(vv);
> +       }
>         dev->vv_data = NULL;
>         dev->vv_callback = NULL;
> 
> diff -r 58ae12f18e80 linux/drivers/media/dvb/ttpci/av7110_v4l.c
> --- a/linux/drivers/media/dvb/ttpci/av7110_v4l.c        Tue Mar 02 23:52:36 2010 -0300
> +++ b/linux/drivers/media/dvb/ttpci/av7110_v4l.c        Wed Mar 03 12:15:23 2010 +0100
> @@ -790,12 +790,20 @@ int av7110_init_v4l(struct av7110 *av711
>                 vv_data = &av7110_vv_data_c;
>         else
>                 vv_data = &av7110_vv_data_st;
> +       ret = saa7146_vv_devinit(dev);
> +
> +       if (ret < 0) {
> +               ERR(("cannot init device. skipping.\n"));
> +               return ret;
> +       }
> +
>         ret = saa7146_vv_init(dev, vv_data);
> -
> -       if (ret) {
> +       if (ret < 0) {
>                 ERR(("cannot init capture device. skipping.\n"));
> +               saa7146_vv_release(dev);
>                 return ret;
>         }
> +
>         vv_data->ops.vidioc_enum_input = vidioc_enum_input;
>         vv_data->ops.vidioc_g_input = vidioc_g_input;
>         vv_data->ops.vidioc_s_input = vidioc_s_input;
> 
> Regards,
> Hartmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

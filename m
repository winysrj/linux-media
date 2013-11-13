Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-d05.mx.aol.com ([205.188.109.202]:52491 "EHLO
	omr-d05.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab3KMPhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Nov 2013 10:37:38 -0500
Message-ID: <52839246.7050600@netscape.net>
Date: Wed, 13 Nov 2013 11:52:54 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH 1/2] cx23885 Radio Support [was: cx23885: Add basic analog
 radio support]
References: <CAEN_-SBR5qGJfUk6h+n04Q4zP-zofiLO+Jr6pOBJU2nqYBuDWQ@mail.gmail.com> <524F0F57.5020605@netscape.net> <20131031081255.65111ad6@samsung.com>
In-Reply-To: <20131031081255.65111ad6@samsung.com>
Content-Type: multipart/mixed;
 boundary="------------090903070702090201040009"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090903070702090201040009
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Mauro and all

El 31/10/13 07:12, Mauro Carvalho Chehab escribió:
>
> Hi Alfredo,
>
> My understanding is that the patch you've enclosed is incomplete and
> depends on Miroslav's patch.
>
> As he have you his ack to rework on it, could you please prepare a
> patch series addressing the above comments for us to review?
>
> Than

This patch supports only radio is for CX23885

I've only applied to current git version of V4L, and I've also removed the lines that support two cards in particular.

The original patch is: https://linuxtv.org/patch/9498/

I found the following issue

Details of the issue:

Some warning when compiling

...
   CC [M] /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.o
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1910:8: : initialization from incompatible pointer type [enabled by default]
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1910:8: warning: (near initialization for 'radio_ioctl_ops.vidioc_s_tuner') [enabled by default]
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1911:8: warning: initialization from incompatible pointer type [enabled by default]
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-video.c:1911:8: warning: (near initialization for 'radio_ioctl_ops.vidioc_s_audio') [enabled by default]
   CC [M] /home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/cx23885-vbi.o
...

--------------------------------------------------------
static const struct v4l2_ioctl_ops radio_ioctl_ops = {

        .vidioc_s_tuner       = radio_s_tuner, /* line 1910 */
        .vidioc_s_audio       = radio_s_audio, /* line 1911 */

--------------------------------------------------------



Signed-off-by: Miroslav Slugen <thunder.mmm@gmail.com>
Tested-by: Alfredo J. Delaiti <alfredodelaiti@netscape.net>


--------------090903070702090201040009
Content-Type: text/x-patch;
 name="radio_parche.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="radio_parche.patch"

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 7891f34..9eed6fe 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -889,6 +889,8 @@ static int video_open(struct file *file)
 	fh->width    = 320;
 	fh->height   = 240;
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_YUYV);
+	
+	mutex_lock(&dev->lock);
 
 	videobuf_queue_sg_init(&fh->vidq, &cx23885_video_qops,
 			    &dev->pci->dev, &dev->slock,
@@ -904,6 +906,14 @@ static int video_open(struct file *file)
 		sizeof(struct cx23885_buffer),
 		fh, NULL);
 
+       if (fh->radio) {
+               dprintk(1,"video_open: setting radio device\n");
+               cx_write(GPIO_0, cx23885_boards[dev->board].radio.gpio0);
+               call_all(dev, tuner, s_radio);
+       }
+
+       dev->users++;
+       mutex_unlock(&dev->lock);
 
 	dprintk(1, "post videobuf_queue_init()\n");
 
@@ -1001,15 +1011,26 @@ static int video_release(struct file *file)
 
 	videobuf_mmap_free(&fh->vidq);
 	videobuf_mmap_free(&fh->vbiq);
+	
+	mutex_lock(&dev->lock);
 
 	file->private_data = NULL;
 	kfree(fh);
+	
+	dev->users--;
 
 	/* We are not putting the tuner to sleep here on exit, because
 	 * we want to use the mpeg encoder in another session to capture
 	 * tuner video. Closing this will result in no video to the encoder.
 	 */
 
+#if 0
+       if (!dev->users)
+               call_all(dev, core, s_power, 0);
+       #endif
+
+       mutex_unlock(&dev->lock);
+
 	return 0;
 }
 
@@ -1635,6 +1656,106 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 /* ----------------------------------------------------------- */
 
+/*              RADIO ESPECIFIC IOCTLS                         */
+
+static int radio_querycap (struct file *file, void  *priv,
+                               struct v4l2_capability *cap)
+{
+       struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
+
+       strcpy(cap->driver, "cx23885");
+       strlcpy(cap->card, cx23885_boards[dev->board].name, sizeof(cap->card));
+       sprintf(cap->bus_info,"PCIe:%s", pci_name(dev->pci));
+       cap->capabilities = V4L2_CAP_TUNER;
+       return 0;
+}
+
+static int radio_g_tuner (struct file *file, void *priv,
+                               struct v4l2_tuner *t)
+{
+       struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
+
+       if (unlikely(t->index > 0))
+               return -EINVAL;
+
+       strcpy(t->name, "Radio");
+       t->type = V4L2_TUNER_RADIO;
+
+       call_all(dev, tuner, g_tuner, t);
+       return 0;
+}
+
+static int radio_enum_input (struct file *file, void *priv,
+                               struct v4l2_input *i)
+{
+       if (i->index != 0)
+               return -EINVAL;
+       strcpy(i->name,"Radio");
+       i->type = V4L2_INPUT_TYPE_TUNER;
+
+       return 0;
+}
+
+static int radio_g_audio (struct file *file, void *priv, struct v4l2_audio *a)
+{
+       if (unlikely(a->index))
+               return -EINVAL;
+
+       strcpy(a->name,"Radio");
+       return 0;
+}
+
+/* FIXME: Should add a standard for radio */
+
+static int radio_s_tuner (struct file *file, void *priv,
+                               struct v4l2_tuner *t)
+{
+       struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
+
+       if (0 != t->index)
+               return -EINVAL;
+
+       call_all(dev, tuner, s_tuner, t);
+
+       return 0;
+}
+
+static int radio_s_audio (struct file *file, void *fh,
+                               struct v4l2_audio *a)
+{
+       return 0;
+}
+
+static int radio_s_input (struct file *file, void *fh, unsigned int i)
+{
+       return 0;
+}
+
+static int radio_queryctrl (struct file *file, void *priv,
+                               struct v4l2_queryctrl *c)
+{
+       int i;
+
+       if (c->id < V4L2_CID_BASE ||
+               c->id >= V4L2_CID_LASTP1)
+               return -EINVAL;
+       if (c->id == V4L2_CID_AUDIO_MUTE ||
+               c->id == V4L2_CID_AUDIO_VOLUME ||
+               c->id == V4L2_CID_AUDIO_BALANCE) {
+               for (i = 0; i < CX23885_CTLS; i++) {
+                       if (cx23885_ctls[i].v.id == c->id)
+                               break;
+               }
+               if (i == CX23885_CTLS) {
+                       *c = no_ctl;
+                       return 0;
+               }
+               *c = cx23885_ctls[i].v;
+       } else
+               *c = no_ctl;
+       return 0;
+}
+
 static void cx23885_vid_timeout(unsigned long data)
 {
 	struct cx23885_dev *dev = (struct cx23885_dev *)data;
@@ -1781,11 +1902,43 @@ static const struct v4l2_file_operations radio_fops = {
 	.ioctl         = video_ioctl2,
 };
 
+static const struct v4l2_ioctl_ops radio_ioctl_ops = {
+       .vidioc_querycap      = radio_querycap,
+       .vidioc_g_tuner       = radio_g_tuner,
+       .vidioc_enum_input    = radio_enum_input,
+       .vidioc_g_audio       = radio_g_audio,
+       .vidioc_s_tuner       = radio_s_tuner,
+       .vidioc_s_audio       = radio_s_audio,
+       .vidioc_s_input       = radio_s_input,
+       .vidioc_queryctrl     = radio_queryctrl,
+       .vidioc_g_ctrl        = vidioc_g_ctrl,
+       .vidioc_s_ctrl        = vidioc_s_ctrl,
+       .vidioc_g_frequency   = vidioc_g_frequency,
+       .vidioc_s_frequency   = vidioc_s_frequency,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+       .vidioc_g_register    = cx23885_g_register,
+       .vidioc_s_register    = cx23885_s_register,
+#endif
+};
+
+static struct video_device cx23885_radio_template = {
+       .name                 = "cx23885-radio",
+       .fops                 = &radio_fops,
+       .ioctl_ops            = &radio_ioctl_ops,
+};
 
 void cx23885_video_unregister(struct cx23885_dev *dev)
 {
 	dprintk(1, "%s()\n", __func__);
 	cx23885_irq_remove(dev, 0x01);
+	
+       if (dev->radio_dev) {
+               if (video_is_registered(dev->radio_dev))
+                       video_unregister_device(dev->radio_dev);
+               else
+                       video_device_release(dev->radio_dev);
+               dev->radio_dev = NULL;
+       }
 
 	if (dev->vbi_dev) {
 		if (video_is_registered(dev->vbi_dev))
@@ -1858,7 +2011,7 @@ int cx23885_video_register(struct cx23885_dev *dev)
 			struct tuner_setup tun_setup;
 
 			memset(&tun_setup, 0, sizeof(tun_setup));
-			tun_setup.mode_mask = T_ANALOG_TV;
+			tun_setup.mode_mask = T_ANALOG_TV | T_RADIO;
 			tun_setup.type = dev->tuner_type;
 			tun_setup.addr = v4l2_i2c_subdev_addr(sd);
 			tun_setup.tuner_callback = cx23885_tuner_callback;
@@ -1918,6 +2071,22 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	printk(KERN_INFO "%s: registered device %s\n",
 	       dev->name, video_device_node_name(dev->vbi_dev));
 
+       /* register Radio device */
+       if (cx23885_boards[dev->board].radio.type == CX23885_RADIO) {
+               dev->radio_dev = cx23885_vdev_init(dev, dev->pci,
+                                       &cx23885_radio_template, "radio");
+               video_set_drvdata(dev->radio_dev, dev);
+               err = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
+                                               radio_nr[dev->nr]);
+               if (err < 0) {
+                       printk(KERN_ERR "%s: can't register radio device\n",
+                               dev->name);
+               goto fail_unreg;
+               }
+       printk(KERN_INFO "%s: registered device %s\n",
+               dev->name, video_device_node_name(dev->radio_dev));
+       }
+
 	/* Register ALSA audio device */
 	dev->audio_dev = cx23885_audio_register(dev);
 
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 0fa4048..6263bcd 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -234,6 +234,7 @@ struct cx23885_board {
 	 */
 	u32			clk_freq;
 	struct cx23885_input    input[MAX_CX23885_INPUT];
+	struct cx23885_input    radio;
 	int			ci_type; /* for NetUP */
 	/* Force bottom field first during DMA (888 workaround) */
 	u32                     force_bff;
@@ -431,6 +432,7 @@ struct cx23885_dev {
 
 	/* V4l */
 	u32                        freq;
+	int                        users;
 	struct video_device        *video_dev;
 	struct video_device        *vbi_dev;
 	struct video_device        *radio_dev;


--------------090903070702090201040009--

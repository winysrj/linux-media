Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnxtsmtp2.conexant.com ([198.62.9.253]:42384 "EHLO
	cnxtsmtp2.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0FJEpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jun 2010 00:45:36 -0400
Received: from cps (nbwsmx2.bbnet.ad [157.152.183.212]) (using TLSv1 with cipher RC4-MD5 (128/128
 bits)) (No client certificate requested) by cnxtsmtp2.conexant.com (Tumbleweed MailGate 3.7.1) with
 ESMTP id 22FF1255823 for <linux-media@vger.kernel.org>; Wed, 9 Jun 2010 21:28:00 -0700 (PDT)
From: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jay Guillory" <Jay.Guillory@conexant.com>,
	"Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
Date: Wed, 9 Jun 2010 21:27:53 -0700
Subject: [cx25821] Removed duplicate code and cleaned up
Message-ID: <34B38BE41EDBA046A4AFBB591FA31132F4B404@NBMBX01.bbnet.ad>
References: <34B38BE41EDBA046A4AFBB591FA31132F4B402@NBMBX01.bbnet.ad>
In-Reply-To: <34B38BE41EDBA046A4AFBB591FA31132F4B402@NBMBX01.bbnet.ad>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 58fd4cad5f6acbe16bff86b8e878d2352cc73637 Mon Sep 17 00:00:00 2001
Message-Id: <58fd4cad5f6acbe16bff86b8e878d2352cc73637.1276143362.git.palash.bandyopadhyay@conexant.com>
From: palash <palash.bandyopadhyay@conexant.com>
Date: Wed, 9 Jun 2010 21:11:20 -0700
Subject: [cx25821] Removed duplicate code and cleaned up
To: linux-media@vger.kernel.org

Signed-off-by: palash <palash.bandyopadhyay@conexant.com>

 delete mode 100644 drivers/staging/cx25821/cx25821-audups11.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video0.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video1.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video2.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video3.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video4.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video5.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video6.c
 delete mode 100644 drivers/staging/cx25821/cx25821-video7.c
 delete mode 100644 drivers/staging/cx25821/cx25821-videoioctl.c
 delete mode 100644 drivers/staging/cx25821/cx25821-vidups10.c
 delete mode 100644 drivers/staging/cx25821/cx25821-vidups9.c

diff --git a/drivers/staging/cx25821/Makefile b/drivers/staging/cx25821/Makefile
index 10f87f0..0f90970 100644
--- a/drivers/staging/cx25821/Makefile
+++ b/drivers/staging/cx25821/Makefile
@@ -1,9 +1,8 @@
-cx25821-objs   := cx25821-core.o cx25821-cards.o cx25821-i2c.o cx25821-gpio.o                          \
-                               cx25821-medusa-video.o cx25821-video.o cx25821-video0.o cx25821-video1.o    \
-                               cx25821-video2.o cx25821-video3.o cx25821-video4.o cx25821-video5.o         \
-                               cx25821-video6.o cx25821-video7.o cx25821-vidups9.o cx25821-vidups10.o      \
-                               cx25821-audups11.o cx25821-video-upstream.o cx25821-video-upstream-ch2.o        \
-                               cx25821-audio-upstream.o cx25821-videoioctl.o
+cx25821-objs   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
+                       cx25821-gpio.o cx25821-medusa-video.o \
+                       cx25821-video.o cx25821-video-upstream.o \
+                       cx25821-video-upstream-ch2.o \
+                       cx25821-audio-upstream.o

 obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
 obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index eb39d13..586b511 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -106,7 +106,7 @@ static __le32 *cx25821_risc_field_upstream_audio(struct cx25821_dev *dev,
 {
        unsigned int line;
        struct sram_channel *sram_ch =
-           &dev->sram_channels[dev->_audio_upstream_channel_select];
+           dev->channels[dev->_audio_upstream_channel_select].sram_channels;
        int offset = 0;

        /* scan lines */
@@ -217,7 +217,7 @@ void cx25821_free_memory_audio(struct cx25821_dev *dev)
 void cx25821_stop_upstream_audio(struct cx25821_dev *dev)
 {
        struct sram_channel *sram_ch =
-           &dev->sram_channels[AUDIO_UPSTREAM_SRAM_CHANNEL_B];
+           dev->channels[AUDIO_UPSTREAM_SRAM_CHANNEL_B].sram_channels;
        u32 tmp = 0;

        if (!dev->_audio_is_running) {
@@ -353,8 +353,9 @@ static void cx25821_audioups_handler(struct work_struct *work)
        }

        cx25821_get_audio_data(dev,
-                              &dev->sram_channels[dev->
-                                                  _audio_upstream_channel_select]);
+                              dev->channels[dev->
+                                       _audio_upstream_channel_select].
+                                       sram_channels);
 }

 int cx25821_openfile_audio(struct cx25821_dev *dev,
@@ -505,7 +506,7 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 {
        int i = 0;
        u32 int_msk_tmp;
-       struct sram_channel *channel = &dev->sram_channels[chan_num];
+       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
        dma_addr_t risc_phys_jump_addr;
        __le32 *rp;

@@ -607,7 +608,8 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
        if (!dev)
                return -1;

-       sram_ch = &dev->sram_channels[dev->_audio_upstream_channel_select];
+       sram_ch = dev->channels[dev->_audio_upstream_channel_select].
+                                       sram_channels;

        msk_stat = cx_read(sram_ch->int_mstat);
        audio_status = cx_read(sram_ch->int_stat);
@@ -731,7 +733,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
        }

        dev->_audio_upstream_channel_select = channel_select;
-       sram_ch = &dev->sram_channels[channel_select];
+       sram_ch = dev->channels[channel_select].sram_channels;

        /* Work queue */
        INIT_WORK(&dev->_audio_work_entry, cx25821_audioups_handler);
diff --git a/drivers/staging/cx25821/cx25821-audio.h b/drivers/staging/cx25821/cx25821-audio.h
index 503f42f..434b2a3 100644
--- a/drivers/staging/cx25821/cx25821-audio.h
+++ b/drivers/staging/cx25821/cx25821-audio.h
@@ -27,24 +27,25 @@
 #define LINES_PER_BUFFER            15
 #define AUDIO_LINE_SIZE             128

-//Number of buffer programs to use at once.
+/* Number of buffer programs to use at once. */
 #define NUMBER_OF_PROGRAMS  8

-//Max size of the RISC program for a buffer. - worst case is 2 writes per line
-// Space is also added for the 4 no-op instructions added on the end.
-
+/*
+  Max size of the RISC program for a buffer. - worst case is 2 writes per line
+  Space is also added for the 4 no-op instructions added on the end.
+*/
 #ifndef USE_RISC_NOOP
 #define MAX_BUFFER_PROGRAM_SIZE     \
     (2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE*4)
 #endif

-// MAE 12 July 2005 Try to use NOOP RISC instruction instead
+/* MAE 12 July 2005 Try to use NOOP RISC instruction instead */
 #ifdef USE_RISC_NOOP
 #define MAX_BUFFER_PROGRAM_SIZE     \
     (2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_NOOP_INSTRUCTION_SIZE*4)
 #endif

-//Sizes of various instructions in bytes.  Used when adding instructions.
+/* Sizes of various instructions in bytes.  Used when adding instructions. */
 #define RISC_WRITE_INSTRUCTION_SIZE 12
 #define RISC_JUMP_INSTRUCTION_SIZE  12
 #define RISC_SKIP_INSTRUCTION_SIZE  4
diff --git a/drivers/staging/cx25821/cx25821-audups11.c b/drivers/staging/cx25821/cx25821-audups11.c
deleted file mode 100644
index e49ead9..0000000
--- a/drivers/staging/cx25821/cx25821-audups11.c
+++ /dev/null
@@ -1,420 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/slab.h>
-
-#include "cx25821-video.h"
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-       struct cx25821_buffer *buf =
-           container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH11];
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-       if (!list_empty(&q->queued)) {
-               list_add_tail(&buf->vb.queue, &q->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-                       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-               list_add_tail(&buf->vb.queue, &q->active);
-               cx25821_start_video_dma(dev, q, buf,
-                                       &dev->sram_channels[SRAM_CH11]);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               buf->count = q->count++;
-               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-               dprintk(2,
-                       "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-                       buf, buf->vb.i, buf->count, q->count);
-       } else {
-               prev =
-                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-               if (prev->vb.width == buf->vb.width
-                   && prev->vb.height == buf->vb.height
-                   && prev->fmt == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &q->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       buf->count = q->count++;
-                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-                       /* 64 bit bits 63-32 */
-                       prev->risc.jmp[2] = cpu_to_le32(0);
-                       dprintk(2,
-                               "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-                               buf, buf->vb.i, buf->count);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &q->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-                               buf->vb.i);
-               }
-       }
-
-       if (list_empty(&q->active)) {
-               dprintk(2, "active queue empty!\n");
-       }
-}
-
-static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
-};
-
-static int video_open(struct file *file)
-{
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-       printk("open dev=%s type=%s\n", video_device_node_name(vdev),
-               v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-               return -ENOMEM;
-
-       lock_kernel();
-
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-               fh->height = 576;
-       else
-               fh->height = 480;
-
-       dev->channel_opened = 10;
-       fh->fmt = format_by_fourcc(V4L2_PIX_FMT_YUYV);
-
-       v4l2_prio_open(&dev->prio, &fh->prio);
-
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-                              &dev->pci->dev, &dev->slock,
-                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
-                              V4L2_FIELD_INTERLACED,
-                              sizeof(struct cx25821_buffer), fh);
-
-       dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
-
-       return 0;
-}
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-                         loff_t * ppos)
-{
-       struct cx25821_fh *fh = file->private_data;
-
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-               if (cx25821_res_locked(fh->dev, RESOURCE_VIDEO11))
-                       return -EBUSY;
-
-               return videobuf_read_one(&fh->vidq, data, count, ppos,
-                                        file->f_flags & O_NONBLOCK);
-
-       default:
-               BUG();
-               return 0;
-       }
-}
-
-static unsigned int video_poll(struct file *file,
-                              struct poll_table_struct *wait)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
-
-       if (cx25821_res_check(fh, RESOURCE_VIDEO11)) {
-               /* streaming capture */
-               if (list_empty(&fh->vidq.stream))
-                       return POLLERR;
-               buf = list_entry(fh->vidq.stream.next,
-                                struct cx25821_buffer, vb.stream);
-       } else {
-               /* read() capture */
-               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-               if (NULL == buf)
-                       return POLLERR;
-       }
-
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR)
-               return POLLIN | POLLRDNORM;
-       return 0;
-}
-
-static int video_release(struct file *file)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-
-       //stop the risc engine and fifo
-       //cx_write(channel11->dma_ctl, 0);
-
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO11)) {
-               videobuf_queue_cancel(&fh->vidq);
-               cx25821_res_free(dev, fh, RESOURCE_VIDEO11);
-       }
-
-       if (fh->vidq.read_buf) {
-               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-               kfree(fh->vidq.read_buf);
-       }
-
-       videobuf_mmap_free(&fh->vidq);
-
-       v4l2_prio_close(&dev->prio, fh->prio);
-
-       file->private_data = NULL;
-       kfree(fh);
-
-       return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(i != fh->type)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO11)))) {
-               return -EBUSY;
-       }
-
-       return videobuf_streamon(get_queue(fh));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
-
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               return -EINVAL;
-       if (i != fh->type)
-               return -EINVAL;
-
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO11);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-               return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-                               struct v4l2_format *f)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
-
-       if (0 != err)
-               return err;
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->width = f->fmt.pix.width;
-       fh->height = f->fmt.pix.height;
-       fh->vidq.field = f->fmt.pix.field;
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-               fh->height, fh->vidq.field);
-       cx25821_call_all(dev, video, s_fmt, f);
-       return 0;
-}
-
-static long video_ioctl_upstream11(struct file *file, unsigned int cmd,
-                                  unsigned long arg)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-       int command = 0;
-       struct upstream_user_struct *data_from_user;
-
-       data_from_user = (struct upstream_user_struct *)arg;
-
-       if (!data_from_user) {
-               printk
-                   ("cx25821 in %s(): Upstream data is INVALID. Returning.\n",
-                    __func__);
-               return 0;
-       }
-
-       command = data_from_user->command;
-
-       if (command != UPSTREAM_START_AUDIO && command != UPSTREAM_STOP_AUDIO) {
-               return 0;
-       }
-
-       dev->input_filename = data_from_user->input_filename;
-       dev->input_audiofilename = data_from_user->input_filename;
-       dev->vid_stdname = data_from_user->vid_stdname;
-       dev->pixel_format = data_from_user->pixel_format;
-       dev->channel_select = data_from_user->channel_select;
-       dev->command = data_from_user->command;
-
-       switch (command) {
-       case UPSTREAM_START_AUDIO:
-               cx25821_start_upstream_audio(dev, data_from_user);
-               break;
-
-       case UPSTREAM_STOP_AUDIO:
-               cx25821_stop_upstream_audio(dev);
-               break;
-       }
-
-       return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-       struct cx25821_fh *fh = priv;
-       return videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-}
-
-static int vidioc_log_status(struct file *file, void *priv)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       char name[32 + 2];
-
-       snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-              dev->name);
-       cx25821_call_all(dev, core, log_status);
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-              dev->name);
-       return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-                        struct v4l2_control *ctl)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev;
-       int err;
-
-       if (fh) {
-               dev = fh->dev;
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-       return 0;
-}
-
-// exported stuff
-static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = video_ioctl_upstream11,
-};
-
-static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
-#endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-       .vidiocgmbuf = cx25821_vidiocgmbuf,
-#endif
-#ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
-#endif
-};
-
-struct video_device cx25821_video_template11 = {
-       .name = "cx25821-audioupstream",
-       .fops = &video_fops,
-       .ioctl_ops = &video_ioctl_ops,
-       .tvnorms = CX25821_NORMS,
-       .current_norm = V4L2_STD_NTSC_M,
-};
diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index d90abb3..19ee3af 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -781,14 +781,14 @@ static void cx25821_shutdown(struct cx25821_dev *dev)

        /* Disable Video A/B activity */
        for (i = 0; i < VID_CHANNEL_NUM; i++) {
-               cx_write(dev->sram_channels[i].dma_ctl, 0);
-               cx_write(dev->sram_channels[i].int_msk, 0);
+               cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
+               cx_write(dev->channels[i].sram_channels->int_msk, 0);
        }

        for (i = VID_UPSTREAM_SRAM_CHANNEL_I; i <= VID_UPSTREAM_SRAM_CHANNEL_J;
             i++) {
-               cx_write(dev->sram_channels[i].dma_ctl, 0);
-               cx_write(dev->sram_channels[i].int_msk, 0);
+               cx_write(dev->channels[i].sram_channels->dma_ctl, 0);
+               cx_write(dev->channels[i].sram_channels->int_msk, 0);
        }

        /* Disable Audio activity */
@@ -805,12 +805,10 @@ static void cx25821_shutdown(struct cx25821_dev *dev)
 void cx25821_set_pixel_format(struct cx25821_dev *dev, int channel_select,
                              u32 format)
 {
-       struct sram_channel *ch;
-
        if (channel_select <= 7 && channel_select >= 0) {
-               ch = &cx25821_sram_channels[channel_select];
-               cx_write(ch->pix_frmt, format);
-               dev->pixel_formats[channel_select] = format;
+               cx_write(dev->channels[channel_select].
+                               sram_channels->pix_frmt, format);
+               dev->channels[channel_select].pixel_formats = format;
        }
 }

@@ -831,7 +829,7 @@ static void cx25821_initialize(struct cx25821_dev *dev)
        cx_write(PCI_INT_STAT, 0xffffffff);

        for (i = 0; i < VID_CHANNEL_NUM; i++)
-               cx_write(dev->sram_channels[i].int_stat, 0xffffffff);
+               cx_write(dev->channels[i].sram_channels->int_stat, 0xffffffff);

        cx_write(AUD_A_INT_STAT, 0xffffffff);
        cx_write(AUD_B_INT_STAT, 0xffffffff);
@@ -845,21 +843,22 @@ static void cx25821_initialize(struct cx25821_dev *dev)
        mdelay(100);

        for (i = 0; i < VID_CHANNEL_NUM; i++) {
-               cx25821_set_vip_mode(dev, &dev->sram_channels[i]);
-               cx25821_sram_channel_setup(dev, &dev->sram_channels[i], 1440,
-                                          0);
-               dev->pixel_formats[i] = PIXEL_FRMT_422;
-               dev->use_cif_resolution[i] = FALSE;
+               cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
+               cx25821_sram_channel_setup(dev, dev->channels[i].sram_channels,
+                                               1440, 0);
+               dev->channels[i].pixel_formats = PIXEL_FRMT_422;
+               dev->channels[i].use_cif_resolution = FALSE;
        }

        /* Probably only affect Downstream */
        for (i = VID_UPSTREAM_SRAM_CHANNEL_I; i <= VID_UPSTREAM_SRAM_CHANNEL_J;
             i++) {
-               cx25821_set_vip_mode(dev, &dev->sram_channels[i]);
+               cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
        }

-       cx25821_sram_channel_setup_audio(dev, &dev->sram_channels[SRAM_CH08],
-                                        128, 0);
+       cx25821_sram_channel_setup_audio(dev,
+                               dev->channels[SRAM_CH08].sram_channels,
+                               128, 0);

        cx25821_gpio_init(dev);
 }
@@ -902,21 +901,6 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 {
        int io_size = 0, i;

-       struct video_device *video_template[] = {
-               &cx25821_video_template0,
-               &cx25821_video_template1,
-               &cx25821_video_template2,
-               &cx25821_video_template3,
-               &cx25821_video_template4,
-               &cx25821_video_template5,
-               &cx25821_video_template6,
-               &cx25821_video_template7,
-               &cx25821_video_template9,
-               &cx25821_video_template10,
-               &cx25821_video_template11,
-               &cx25821_videoioctl_template,
-       };
-
        printk(KERN_INFO "\n***********************************\n");
        printk(KERN_INFO "cx25821 set up\n");
        printk(KERN_INFO "***********************************\n\n");
@@ -947,7 +931,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)

        /* Apply a sensible clock frequency for the PCIe bridge */
        dev->clk_freq = 28000000;
-       dev->sram_channels = cx25821_sram_channels;
+       for (i = 0; i < MAX_VID_CHANNEL_NUM; i++)
+               dev->channels[i].sram_channels = &cx25821_sram_channels[i];

        if (dev->nr > 1)
                CX25821_INFO("dev->nr > 1!");
@@ -970,7 +955,6 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
        dev->i2c_bus[0].reg_wdata = I2C1_WDATA;
        dev->i2c_bus[0].i2c_period = (0x07 << 24);      /* 1.95MHz */

-
        if (cx25821_get_resources(dev) < 0) {
                printk(KERN_ERR "%s No more PCIe resources for "
                       "subsystem: %04x:%04x\n",
@@ -1018,37 +1002,24 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
                     dev->i2c_bus[0].i2c_rc);

        cx25821_card_setup(dev);
-       medusa_video_init(dev);

-       for (i = 0; i < VID_CHANNEL_NUM; i++) {
-               if (cx25821_video_register(dev, i, video_template[i]) < 0) {
-                       printk(KERN_ERR
-                              "%s() Failed to register analog video adapters on VID channel %d\n",
-                              __func__, i);
-               }
-       }
+       if (medusa_video_init(dev) < 0)
+               CX25821_ERR("%s() Failed to initialize medusa!\n"
+               , __func__);

-       for (i = VID_UPSTREAM_SRAM_CHANNEL_I;
-            i <= AUDIO_UPSTREAM_SRAM_CHANNEL_B; i++) {
-               /* Since we don't have template8 for Audio Downstream */
-               if (cx25821_video_register(dev, i, video_template[i - 1]) < 0) {
-                       printk(KERN_ERR
-                              "%s() Failed to register analog video adapters for Upstream channel %d.\n",
-                              __func__, i);
-               }
-       }
+       cx25821_video_register(dev);

        /* register IOCTL device */
        dev->ioctl_dev =
-           cx25821_vdev_init(dev, dev->pci, video_template[VIDEO_IOCTL_CH],
+           cx25821_vdev_init(dev, dev->pci, &cx25821_videoioctl_template,
                              "video");

        if (video_register_device
            (dev->ioctl_dev, VFL_TYPE_GRABBER, VIDEO_IOCTL_CH) < 0) {
                cx25821_videoioctl_unregister(dev);
                printk(KERN_ERR
-                      "%s() Failed to register video adapter for IOCTL so releasing.\n",
-                      __func__);
+                   "%s() Failed to register video adapter for IOCTL, so \
+                   unregistering videoioctl device.\n", __func__);
        }

        cx25821_dev_checkrevision(dev);
@@ -1371,7 +1342,8 @@ static irqreturn_t cx25821_irq(int irq, void *dev_id)

        for (i = 0; i < VID_CHANNEL_NUM; i++) {
                if (pci_status & mask[i]) {
-                       vid_status = cx_read(dev->sram_channels[i].int_stat);
+                       vid_status = cx_read(dev->channels[i].
+                               sram_channels->int_stat);

                        if (vid_status)
                                handled +=
diff --git a/drivers/staging/cx25821/cx25821-i2c.c b/drivers/staging/cx25821/cx25821-i2c.c
index 08f45b5..2b14bcc 100644
--- a/drivers/staging/cx25821/cx25821-i2c.c
+++ b/drivers/staging/cx25821/cx25821-i2c.c
@@ -282,6 +282,9 @@ static u32 cx25821_functionality(struct i2c_adapter *adap)
 static struct i2c_algorithm cx25821_i2c_algo_template = {
        .master_xfer = i2c_xfer,
        .functionality = cx25821_functionality,
+#ifdef NEED_ALGO_CONTROL
+       .algo_control = dummy_algo_control,
+#endif
 };

 static struct i2c_adapter cx25821_i2c_adap_template = {
diff --git a/drivers/staging/cx25821/cx25821-medusa-defines.h b/drivers/staging/cx25821/cx25821-medusa-defines.h
index b0d216b..60d197f 100644
--- a/drivers/staging/cx25821/cx25821-medusa-defines.h
+++ b/drivers/staging/cx25821/cx25821-medusa-defines.h
@@ -23,7 +23,7 @@
 #ifndef _MEDUSA_DEF_H_
 #define _MEDUSA_DEF_H_

-// Video deocder that we supported
+/* Video deocder that we supported */
 #define VDEC_A         0
 #define VDEC_B         1
 #define VDEC_C         2
@@ -33,19 +33,10 @@
 #define VDEC_G         6
 #define VDEC_H         7

-//#define AUTO_SWITCH_BIT[]  = { 8, 9, 10, 11, 12, 13, 14, 15 };
-
-// The following bit position enables automatic source switching for decoder A-H.
-// Display index per camera.
-//#define VDEC_INDEX[] = {0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7};
-
-// Select input bit to video decoder A-H.
-//#define CH_SRC_SEL_BIT[] = {24, 25, 26, 27, 28, 29, 30, 31};
-
-// end of display sequence
+/* end of display sequence */
 #define END_OF_SEQ                                     0xF;

-// registry string size
+/* registry string size */
 #define MAX_REGISTRY_SZ                                        40;

 #endif
diff --git a/drivers/staging/cx25821/cx25821-medusa-reg.h b/drivers/staging/cx25821/cx25821-medusa-reg.h
index 12c90f8..f7f33b3 100644
--- a/drivers/staging/cx25821/cx25821-medusa-reg.h
+++ b/drivers/staging/cx25821/cx25821-medusa-reg.h
@@ -23,11 +23,11 @@
 #ifndef __MEDUSA_REGISTERS__
 #define __MEDUSA_REGISTERS__

-// Serial Slave Registers
+/* Serial Slave Registers */
 #define        HOST_REGISTER1                          0x0000
 #define        HOST_REGISTER2                          0x0001

-// Chip Configuration Registers
+/* Chip Configuration Registers */
 #define        CHIP_CTRL                                       0x0100
 #define        AFE_AB_CTRL                                     0x0104
 #define        AFE_CD_CTRL                                     0x0108
@@ -92,7 +92,7 @@
 #define        ABIST_CLAMP_E                           0x01F4
 #define        ABIST_CLAMP_F                           0x01F8

-//              Digital Video Encoder A Registers
+/*              Digital Video Encoder A Registers */
 #define        DENC_A_REG_1                                    0x0200
 #define        DENC_A_REG_2                                    0x0204
 #define        DENC_A_REG_3                                    0x0208
@@ -102,7 +102,7 @@
 #define        DENC_A_REG_7                                    0x0218
 #define        DENC_A_REG_8                                    0x021C

-//      Digital Video Encoder B Registers
+/*      Digital Video Encoder B Registers */
 #define        DENC_B_REG_1                                    0x0300
 #define        DENC_B_REG_2                                    0x0304
 #define        DENC_B_REG_3                                    0x0308
@@ -112,7 +112,7 @@
 #define        DENC_B_REG_7                                    0x0318
 #define        DENC_B_REG_8                                    0x031C

-//              Video Decoder A Registers
+/*              Video Decoder A Registers */
 #define        MODE_CTRL                                               0x1000
 #define        OUT_CTRL1                                               0x1004
 #define        OUT_CTRL_NS                                             0x1008
@@ -153,7 +153,7 @@
 #define        VERSION                                                 0x11F8
 #define        SOFT_RST_CTRL                                   0x11FC

-//      Video Decoder B Registers
+/*      Video Decoder B Registers */
 #define        VDEC_B_MODE_CTRL                                0x1200
 #define        VDEC_B_OUT_CTRL1                                0x1204
 #define        VDEC_B_OUT_CTRL_NS                              0x1208
@@ -194,7 +194,7 @@
 #define        VDEC_B_VERSION                                  0x13F8
 #define        VDEC_B_SOFT_RST_CTRL                    0x13FC

-// Video Decoder C Registers
+/* Video Decoder C Registers */
 #define        VDEC_C_MODE_CTRL                                0x1400
 #define        VDEC_C_OUT_CTRL1                                0x1404
 #define        VDEC_C_OUT_CTRL_NS                              0x1408
@@ -235,7 +235,7 @@
 #define        VDEC_C_VERSION                                  0x15F8
 #define        VDEC_C_SOFT_RST_CTRL                    0x15FC

-// Video Decoder D Registers
+/* Video Decoder D Registers */
 #define VDEC_D_MODE_CTRL                               0x1600
 #define VDEC_D_OUT_CTRL1                               0x1604
 #define VDEC_D_OUT_CTRL_NS                             0x1608
@@ -276,7 +276,7 @@
 #define VDEC_D_VERSION                                 0x17F8
 #define VDEC_D_SOFT_RST_CTRL                   0x17FC

-// Video Decoder E Registers
+/* Video Decoder E Registers */
 #define        VDEC_E_MODE_CTRL                                0x1800
 #define        VDEC_E_OUT_CTRL1                                0x1804
 #define        VDEC_E_OUT_CTRL_NS                              0x1808
@@ -317,7 +317,7 @@
 #define        VDEC_E_VERSION                                  0x19F8
 #define        VDEC_E_SOFT_RST_CTRL                    0x19FC

-// Video Decoder F Registers
+/* Video Decoder F Registers */
 #define        VDEC_F_MODE_CTRL                                0x1A00
 #define        VDEC_F_OUT_CTRL1                                0x1A04
 #define        VDEC_F_OUT_CTRL_NS                              0x1A08
@@ -358,7 +358,7 @@
 #define        VDEC_F_VERSION                                  0x1BF8
 #define        VDEC_F_SOFT_RST_CTRL                    0x1BFC

-// Video Decoder G Registers
+/* Video Decoder G Registers */
 #define        VDEC_G_MODE_CTRL                                0x1C00
 #define        VDEC_G_OUT_CTRL1                                0x1C04
 #define        VDEC_G_OUT_CTRL_NS                              0x1C08
@@ -399,7 +399,7 @@
 #define        VDEC_G_VERSION                                  0x1DF8
 #define        VDEC_G_SOFT_RST_CTRL                    0x1DFC

-//              Video Decoder H Registers
+/*              Video Decoder H Registers  */
 #define        VDEC_H_MODE_CTRL                                0x1E00
 #define        VDEC_H_OUT_CTRL1                                0x1E04
 #define        VDEC_H_OUT_CTRL_NS                              0x1E08
@@ -440,14 +440,14 @@
 #define        VDEC_H_VERSION                                  0x1FF8
 #define        VDEC_H_SOFT_RST_CTRL                    0x1FFC

-//*****************************************************************************
-// LUMA_CTRL register fields
+/*****************************************************************************/
+/* LUMA_CTRL register fields */
 #define VDEC_A_BRITE_CTRL                              0x1014
 #define VDEC_A_CNTRST_CTRL                     0x1015
 #define VDEC_A_PEAK_SEL                        0x1016

-//*****************************************************************************
-// CHROMA_CTRL register fields
+/*****************************************************************************/
+/* CHROMA_CTRL register fields */
 #define VDEC_A_USAT_CTRL                       0x1018
 #define VDEC_A_VSAT_CTRL                       0x1019
 #define VDEC_A_HUE_CTRL                        0x101A
diff --git a/drivers/staging/cx25821/cx25821-medusa-video.c b/drivers/staging/cx25821/cx25821-medusa-video.c
index 34616dc..4edbb1a 100644
--- a/drivers/staging/cx25821/cx25821-medusa-video.c
+++ b/drivers/staging/cx25821/cx25821-medusa-video.c
@@ -778,9 +778,9 @@ int medusa_set_saturation(struct cx25821_dev *dev, int saturation, int decoder)

 int medusa_video_init(struct cx25821_dev *dev)
 {
-       u32 value, tmp = 0;
-       int ret_val;
-       int i;
+       u32 value = 0, tmp = 0;
+       int ret_val = 0;
+       int i = 0;

        mutex_lock(&dev->lock);

@@ -790,6 +790,7 @@ int medusa_video_init(struct cx25821_dev *dev)
        value = cx25821_i2c_read(&dev->i2c_bus[0], MON_A_CTRL, &tmp);
        value &= 0xFFFFF0FF;
        ret_val = cx25821_i2c_write(&dev->i2c_bus[0], MON_A_CTRL, value);
+
        if (ret_val < 0)
                goto error;

@@ -797,6 +798,7 @@ int medusa_video_init(struct cx25821_dev *dev)
        value = cx25821_i2c_read(&dev->i2c_bus[0], MON_A_CTRL, &tmp);
        value &= 0xFFFFFFDF;
        ret_val = cx25821_i2c_write(&dev->i2c_bus[0], MON_A_CTRL, value);
+
        if (ret_val < 0)
                goto error;

@@ -812,6 +814,7 @@ int medusa_video_init(struct cx25821_dev *dev)
        value &= 0xFF70FF70;
        value |= 0x00090008;    /* set en_active */
        ret_val = cx25821_i2c_write(&dev->i2c_bus[0], DENC_AB_CTRL, value);
+
        if (ret_val < 0)
                goto error;

@@ -826,8 +829,10 @@ int medusa_video_init(struct cx25821_dev *dev)
        /* select AFE clock to output mode */
        value = cx25821_i2c_read(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL, &tmp);
        value &= 0x83FFFFFF;
-       ret_val = cx25821_i2c_write(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL,
-                                   value | 0x10000000);
+       ret_val =
+           cx25821_i2c_write(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL,
+                             value | 0x10000000);
+
        if (ret_val < 0)
                goto error;

@@ -849,12 +854,15 @@ int medusa_video_init(struct cx25821_dev *dev)

        value |= 7;
        ret_val = cx25821_i2c_write(&dev->i2c_bus[0], PIN_OE_CTRL, value);
+
        if (ret_val < 0)
                goto error;

+
        mutex_unlock(&dev->lock);

        ret_val = medusa_set_videostandard(dev);
+
        return ret_val;

 error:
diff --git a/drivers/staging/cx25821/cx25821-medusa-video.h b/drivers/staging/cx25821/cx25821-medusa-video.h
index 2fab4b2..6175e09 100644
--- a/drivers/staging/cx25821/cx25821-medusa-video.h
+++ b/drivers/staging/cx25821/cx25821-medusa-video.h
@@ -25,7 +25,7 @@

 #include "cx25821-medusa-defines.h"

-// Color control constants
+/* Color control constants */
 #define VIDEO_PROCAMP_MIN                 0
 #define VIDEO_PROCAMP_MAX                 10000
 #define UNSIGNED_BYTE_MIN                 0
@@ -33,7 +33,7 @@
 #define SIGNED_BYTE_MIN                   -128
 #define SIGNED_BYTE_MAX                   127

-// Default video color settings
+/* Default video color settings */
 #define SHARPNESS_DEFAULT                 50
 #define SATURATION_DEFAULT              5000
 #define BRIGHTNESS_DEFAULT              6200
diff --git a/drivers/staging/cx25821/cx25821-reg.h b/drivers/staging/cx25821/cx25821-reg.h
index 7241e7e..6f4151c 100644
--- a/drivers/staging/cx25821/cx25821-reg.h
+++ b/drivers/staging/cx25821/cx25821-reg.h
@@ -48,17 +48,17 @@
 #define RISC_SYNC_EVEN_VBI      0x00000207
 #define RISC_NOOP                       0xF0000000

-//*****************************************************************************
-// ASB SRAM
-//*****************************************************************************
+/*****************************************************************************
+* ASB SRAM
+ *****************************************************************************/
 #define  TX_SRAM                   0x000000    // Transmit SRAM

-//*****************************************************************************
+/*****************************************************************************/
 #define  RX_RAM                    0x010000    // Receive SRAM

-//*****************************************************************************
-// Application Layer (AL)
-//*****************************************************************************
+/*****************************************************************************
+* Application Layer (AL)
+ *****************************************************************************/
 #define  DEV_CNTRL2                0x040000    // Device control
 #define  FLD_RUN_RISC              0x00000020

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index 343df66..44648e4 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -84,7 +84,7 @@ static __le32 *cx25821_risc_field_upstream_ch2(struct cx25821_dev *dev,
 {
        unsigned int line, i;
        struct sram_channel *sram_ch =
-           &dev->sram_channels[dev->_channel2_upstream_select];
+           dev->channels[dev->_channel2_upstream_select].sram_channels;
        int dist_betwn_starts = bpl * 2;

        /* sync instruction */
@@ -110,8 +110,11 @@ static __le32 *cx25821_risc_field_upstream_ch2(struct cx25821_dev *dev,
                        offset += dist_betwn_starts;
                }

-               // check if we need to enable the FIFO after the first 4 lines
-               // For the upstream video channel, the risc engine will enable the FIFO.
+               /*
+                 check if we need to enable the FIFO after the first 4 lines
+                  For the upstream video channel, the risc engine will enable
+                  the FIFO.
+               */
                if (fifo_enable && line == 3) {
                        *(rp++) = RISC_WRITECR;
                        *(rp++) = sram_ch->dma_ctl;
@@ -130,7 +133,7 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 {
        __le32 *rp;
        int fifo_enable = 0;
-       int singlefield_lines = lines >> 1;     //get line count for single field
+       int singlefield_lines = lines >> 1; /*get line count for single field */
        int odd_num_lines = singlefield_lines;
        int frame = 0;
        int frame_size = 0;
@@ -174,7 +177,7 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,

                fifo_enable = FIFO_DISABLE;

-               //Even field
+               /* Even field */
                rp = cx25821_risc_field_upstream_ch2(dev, rp,
                                                     dev->
                                                     _data_buf_phys_addr_ch2 +
@@ -192,7 +195,10 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
                        risc_phys_jump_addr = dev->_dma_phys_start_addr_ch2;
                }

-               // Loop to 2ndFrameRISC or to Start of Risc program & generate IRQ
+               /*
+                  Loop to 2ndFrameRISC or to Start of
+                  Risc program & generate IRQ
+               */
                *(rp++) = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | risc_flag);
                *(rp++) = cpu_to_le32(risc_phys_jump_addr);
                *(rp++) = cpu_to_le32(0);
@@ -204,7 +210,7 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)
 {
        struct sram_channel *sram_ch =
-           &dev->sram_channels[VID_UPSTREAM_SRAM_CHANNEL_J];
+           dev->channels[VID_UPSTREAM_SRAM_CHANNEL_J].sram_channels;
        u32 tmp = 0;

        if (!dev->_is_running_ch2) {
@@ -212,15 +218,15 @@ void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)
                    ("cx25821: No video file is currently running so return!\n");
                return;
        }
-       //Disable RISC interrupts
+       /* Disable RISC interrupts */
        tmp = cx_read(sram_ch->int_msk);
        cx_write(sram_ch->int_msk, tmp & ~_intr_msk);

-       //Turn OFF risc and fifo
+       /* Turn OFF risc and fifo */
        tmp = cx_read(sram_ch->dma_ctl);
        cx_write(sram_ch->dma_ctl, tmp & ~(FLD_VID_FIFO_EN | FLD_VID_RISC_EN));

-       //Clear data buffer memory
+       /* Clear data buffer memory */
        if (dev->_data_buf_virt_addr_ch2)
                memset(dev->_data_buf_virt_addr_ch2, 0,
                       dev->_data_buf_size_ch2);
@@ -371,8 +377,8 @@ static void cx25821_vidups_handler_ch2(struct work_struct *work)
        }

        cx25821_get_frame_ch2(dev,
-                             &dev->sram_channels[dev->
-                                                 _channel2_upstream_select]);
+                             dev->channels[dev->
+                               _channel2_upstream_select].sram_channels);
 }

 int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
@@ -488,7 +494,7 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
                return -ENOMEM;
        }

-       //Iniitize at this address until n bytes to 0
+       /* Iniitize at this address until n bytes to 0 */
        memset(dev->_dma_virt_addr_ch2, 0, dev->_risc_size_ch2);

        if (dev->_data_buf_virt_addr_ch2 != NULL) {
@@ -496,7 +502,7 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
                                    dev->_data_buf_virt_addr_ch2,
                                    dev->_data_buf_phys_addr_ch2);
        }
-       //For Video Data buffer allocation
+       /* For Video Data buffer allocation */
        dev->_data_buf_virt_addr_ch2 =
            pci_alloc_consistent(dev->pci, dev->upstream_databuf_size_ch2,
                                 &data_dma_addr);
@@ -509,14 +515,14 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
                return -ENOMEM;
        }

-       //Initialize at this address until n bytes to 0
+       /* Initialize at this address until n bytes to 0 */
        memset(dev->_data_buf_virt_addr_ch2, 0, dev->_data_buf_size_ch2);

        ret = cx25821_openfile_ch2(dev, sram_ch);
        if (ret < 0)
                return ret;

-       //Creating RISC programs
+       /* Creating RISC programs */
        ret =
            cx25821_risc_buffer_upstream_ch2(dev, dev->pci, 0, bpl,
                                             dev->_lines_count_ch2);
@@ -536,7 +542,7 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
                                   u32 status)
 {
        u32 int_msk_tmp;
-       struct sram_channel *channel = &dev->sram_channels[chan_num];
+       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
        int singlefield_lines = NTSC_FIELD_HEIGHT;
        int line_size_in_bytes = Y422_LINE_SZ;
        int odd_risc_prog_size = 0;
@@ -544,10 +550,13 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
        __le32 *rp;

        if (status & FLD_VID_SRC_RISC1) {
-               // We should only process one program per call
+               /* We should only process one program per call */
                u32 prog_cnt = cx_read(channel->gpcnt);

-               //Since we've identified our IRQ, clear our bits from the interrupt mask and interrupt status registers
+               /*
+                  Since we've identified our IRQ, clear our bits from the
+                  interrupt mask and interrupt status registers
+               */
                int_msk_tmp = cx_read(channel->int_msk);
                cx_write(channel->int_msk, int_msk_tmp & ~_intr_msk);
                cx_write(channel->int_stat, _intr_msk);
@@ -588,7 +597,7 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
                                                                    FIFO_DISABLE,
                                                                    ODD_FIELD);

-                               // Jump to Even Risc program of 1st Frame
+                               /* Jump to Even Risc program of 1st Frame */
                                *(rp++) = cpu_to_le32(RISC_JUMP);
                                *(rp++) = cpu_to_le32(risc_phys_jump_addr);
                                *(rp++) = cpu_to_le32(0);
@@ -603,7 +612,7 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
                       dev->_frame_count_ch2);
                return -1;
        }
-       //ElSE, set the interrupt mask register, re-enable irq.
+       /* ElSE, set the interrupt mask register, re-enable irq. */
        int_msk_tmp = cx_read(channel->int_msk);
        cx_write(channel->int_msk, int_msk_tmp |= _intr_msk);

@@ -623,12 +632,12 @@ static irqreturn_t cx25821_upstream_irq_ch2(int irq, void *dev_id)

        channel_num = VID_UPSTREAM_SRAM_CHANNEL_J;

-       sram_ch = &dev->sram_channels[channel_num];
+       sram_ch = dev->channels[channel_num].sram_channels;

        msk_stat = cx_read(sram_ch->int_mstat);
        vid_status = cx_read(sram_ch->int_stat);

-       // Only deal with our interrupt
+       /* Only deal with our interrupt */
        if (vid_status) {
                handled =
                    cx25821_video_upstream_irq_ch2(dev, channel_num,
@@ -658,7 +667,10 @@ static void cx25821_set_pixelengine_ch2(struct cx25821_dev *dev,
        value |= dev->_isNTSC_ch2 ? 0 : 0x10;
        cx_write(ch->vid_fmt_ctl, value);

-       // set number of active pixels in each line. Default is 720 pixels in both NTSC and PAL format
+       /*
+          set number of active pixels in each line. Default is 720
+          pixels in both NTSC and PAL format
+       */
        cx_write(ch->vid_active_ctl1, width);

        num_lines = (height / 2) & 0x3FF;
@@ -670,7 +682,7 @@ static void cx25821_set_pixelengine_ch2(struct cx25821_dev *dev,

        value = (num_lines << 16) | odd_num_lines;

-       // set number of active lines in field 0 (top) and field 1 (bottom)
+       /* set number of active lines in field 0 (top) and field 1 (bottom) */
        cx_write(ch->vid_active_ctl2, value);

        cx_write(ch->vid_cdt_size, VID_CDT_SIZE >> 3);
@@ -682,21 +694,27 @@ int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
        u32 tmp = 0;
        int err = 0;

-       // 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for channel A-C
+       /*
+          656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface
+          for channel A-C
+       */
        tmp = cx_read(VID_CH_MODE_SEL);
        cx_write(VID_CH_MODE_SEL, tmp | 0x1B0001FF);

-       // Set the physical start address of the RISC program in the initial program counter(IPC) member of the cmds.
+       /*
+          Set the physical start address of the RISC program in the initial
+          program counter(IPC) member of the cmds.
+       */
        cx_write(sram_ch->cmds_start + 0, dev->_dma_phys_addr_ch2);
-       cx_write(sram_ch->cmds_start + 4, 0);   /* Risc IPC High 64 bits 63-32 */
+       cx_write(sram_ch->cmds_start + 4, 0); /* Risc IPC High 64 bits 63-32 */

        /* reset counter */
        cx_write(sram_ch->gpcnt_ctl, 3);

-       // Clear our bits from the interrupt status register.
+       /* Clear our bits from the interrupt status register. */
        cx_write(sram_ch->int_stat, _intr_msk);

-       //Set the interrupt mask register, enable irq.
+       /* Set the interrupt mask register, enable irq. */
        cx_set(PCI_INT_MSK, cx_read(PCI_INT_MSK) | (1 << sram_ch->irq_bit));
        tmp = cx_read(sram_ch->int_msk);
        cx_write(sram_ch->int_msk, tmp |= _intr_msk);
@@ -709,7 +727,7 @@ int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
                       dev->pci->irq);
                goto fail_irq;
        }
-       // Start the DMA  engine
+       /* Start the DMA  engine */
        tmp = cx_read(sram_ch->dma_ctl);
        cx_set(sram_ch->dma_ctl, tmp | FLD_VID_RISC_EN);

@@ -740,7 +758,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
        }

        dev->_channel2_upstream_select = channel_select;
-       sram_ch = &dev->sram_channels[channel_select];
+       sram_ch = dev->channels[channel_select].sram_channels;

        INIT_WORK(&dev->_irq_work_entry_ch2, cx25821_vidups_handler_ch2);
        dev->_irq_queues_ch2 =
@@ -751,7 +769,10 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
                    ("cx25821: create_singlethread_workqueue() for Video FAILED!\n");
                return -ENOMEM;
        }
-       // 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for channel A-C
+       /*
+          656/VIP SRC Upstream Channel I & J and 7 -
+          Host Bus Interface for channel A-C
+       */
        tmp = cx_read(VID_CH_MODE_SEL);
        cx_write(VID_CH_MODE_SEL, tmp | 0x1B0001FF);

@@ -787,7 +808,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
                       str_length + 1);
        }

-       //Default if filename is empty string
+       /* Default if filename is empty string */
        if (strcmp(dev->input_filename_ch2, "") == 0) {
                if (dev->_isNTSC_ch2) {
                        dev->_filename_ch2 =
@@ -812,7 +833,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
        dev->upstream_riscbuf_size_ch2 = risc_buffer_size * 2;
        dev->upstream_databuf_size_ch2 = data_frame_size * 2;

-       //Allocating buffers and prepare RISC program
+       /* Allocating buffers and prepare RISC program */
        retval =
            cx25821_upstream_buffer_prepare_ch2(dev, sram_ch,
                                                dev->_line_size_ch2);
diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 7a3dad9..c45eebe 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -134,7 +134,7 @@ static __le32 *cx25821_risc_field_upstream(struct cx25821_dev *dev, __le32 * rp,
 {
        unsigned int line, i;
        struct sram_channel *sram_ch =
-           &dev->sram_channels[dev->_channel_upstream_select];
+           dev->channels[dev->_channel_upstream_select].sram_channels;
        int dist_betwn_starts = bpl * 2;

        /* sync instruction */
@@ -253,7 +253,7 @@ int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev)
 {
        struct sram_channel *sram_ch =
-           &dev->sram_channels[VID_UPSTREAM_SRAM_CHANNEL_I];
+           dev->channels[VID_UPSTREAM_SRAM_CHANNEL_I].sram_channels;
        u32 tmp = 0;

        if (!dev->_is_running) {
@@ -346,20 +346,23 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)

        if (IS_ERR(myfile)) {
                const int open_errno = -PTR_ERR(myfile);
-               printk(KERN_ERR "%s(): ERROR opening file(%s) with errno = %d!\n",
-                      __func__, dev->_filename, open_errno);
+               printk(KERN_ERR
+                   "%s(): ERROR opening file(%s) with errno = %d!\n",
+                   __func__, dev->_filename, open_errno);
                return PTR_ERR(myfile);
        } else {
                if (!(myfile->f_op)) {
-                       printk(KERN_ERR "%s: File has no file operations registered!",
-                              __func__);
+                       printk(KERN_ERR
+                           "%s: File has no file operations registered!",
+                           __func__);
                        filp_close(myfile, NULL);
                        return -EIO;
                }

                if (!myfile->f_op->read) {
-                       printk(KERN_ERR "%s: File has no READ operations registered!",
-                              __func__);
+                       printk(KERN_ERR
+                           "%s: File has no READ operations registered!",
+                           __func__);
                        filp_close(myfile, NULL);
                        return -EIO;
                }
@@ -386,7 +389,8 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)

                        if (vfs_read_retval < line_size) {
                                printk(KERN_INFO
-                                      "Done: exit %s() since no more bytes to read from Video file.\n",
+                                      "Done: exit %s() since no more bytes to \
+                                      read from Video file.\n",
                                       __func__);
                                break;
                        }
@@ -411,13 +415,15 @@ static void cx25821_vidups_handler(struct work_struct *work)
            container_of(work, struct cx25821_dev, _irq_work_entry);

        if (!dev) {
-               printk(KERN_ERR "ERROR %s(): since container_of(work_struct) FAILED!\n",
-                      __func__);
+               printk(KERN_ERR
+                   "ERROR %s(): since container_of(work_struct) FAILED!\n",
+                   __func__);
                return;
        }

        cx25821_get_frame(dev,
-                         &dev->sram_channels[dev->_channel_upstream_select]);
+                         dev->channels[dev->_channel_upstream_select].
+                                               sram_channels);
 }

 int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
@@ -437,20 +443,22 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)

        if (IS_ERR(myfile)) {
                const int open_errno = -PTR_ERR(myfile);
-               printk(KERN_ERR "%s(): ERROR opening file(%s) with errno = %d!\n",
+               printk(KERN_ERR  "%s(): ERROR opening file(%s) with errno = %d!\n",
                       __func__, dev->_filename, open_errno);
                return PTR_ERR(myfile);
        } else {
                if (!(myfile->f_op)) {
-                       printk(KERN_ERR "%s: File has no file operations registered!",
-                              __func__);
+                       printk(KERN_ERR
+                           "%s: File has no file operations registered!",
+                           __func__);
                        filp_close(myfile, NULL);
                        return -EIO;
                }

                if (!myfile->f_op->read) {
-                       printk
-                           (KERN_ERR "%s: File has no READ operations registered!  Returning.",
+                       printk(KERN_ERR
+                           "%s: File has no READ operations registered!  \
+                           Returning.",
                             __func__);
                        filp_close(myfile, NULL);
                        return -EIO;
@@ -480,7 +488,8 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)

                                if (vfs_read_retval < line_size) {
                                        printk(KERN_INFO
-                                              "Done: exit %s() since no more bytes to read from Video file.\n",
+                                            "Done: exit %s() since no more \
+                                            bytes to read from Video file.\n",
                                               __func__);
                                        break;
                                }
@@ -526,7 +535,8 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,

        if (!dev->_dma_virt_addr) {
                printk
-                   (KERN_ERR "cx25821: FAILED to allocate memory for Risc buffer! Returning.\n");
+                   (KERN_ERR "cx25821: FAILED to allocate memory for Risc \
+                   buffer! Returning.\n");
                return -ENOMEM;
        }

@@ -547,7 +557,8 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,

        if (!dev->_data_buf_virt_addr) {
                printk
-                   (KERN_ERR "cx25821: FAILED to allocate memory for data buffer! Returning.\n");
+                   (KERN_ERR "cx25821: FAILED to allocate memory for data \
+                   buffer! Returning.\n");
                return -ENOMEM;
        }

@@ -578,7 +589,7 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
                               u32 status)
 {
        u32 int_msk_tmp;
-       struct sram_channel *channel = &dev->sram_channels[chan_num];
+       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
        int singlefield_lines = NTSC_FIELD_HEIGHT;
        int line_size_in_bytes = Y422_LINE_SZ;
        int odd_risc_prog_size = 0;
@@ -642,16 +653,16 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
        } else {
                if (status & FLD_VID_SRC_UF)
                        printk
-                           (KERN_ERR "%s: Video Received Underflow Error Interrupt!\n",
-                            __func__);
+                           (KERN_ERR "%s: Video Received Underflow Error \
+                           Interrupt!\n", __func__);

                if (status & FLD_VID_SRC_SYNC)
-                       printk(KERN_ERR "%s: Video Received Sync Error Interrupt!\n",
-                              __func__);
+                       printk(KERN_ERR "%s: Video Received Sync Error \
+                       Interrupt!\n", __func__);

                if (status & FLD_VID_SRC_OPC_ERR)
-                       printk(KERN_ERR "%s: Video Received OpCode Error Interrupt!\n",
-                              __func__);
+                       printk(KERN_ERR "%s: Video Received OpCode Error \
+                       Interrupt!\n", __func__);
        }

        if (dev->_file_status == END_OF_FILE) {
@@ -679,7 +690,7 @@ static irqreturn_t cx25821_upstream_irq(int irq, void *dev_id)

        channel_num = VID_UPSTREAM_SRAM_CHANNEL_I;

-       sram_ch = &dev->sram_channels[channel_num];
+       sram_ch = dev->channels[channel_num].sram_channels;

        msk_stat = cx_read(sram_ch->int_mstat);
        vid_status = cx_read(sram_ch->int_stat);
@@ -800,14 +811,15 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
        }

        dev->_channel_upstream_select = channel_select;
-       sram_ch = &dev->sram_channels[channel_select];
+       sram_ch = dev->channels[channel_select].sram_channels;

        INIT_WORK(&dev->_irq_work_entry, cx25821_vidups_handler);
        dev->_irq_queues = create_singlethread_workqueue("cx25821_workqueue");

        if (!dev->_irq_queues) {
                printk
-                   (KERN_ERR "cx25821: create_singlethread_workqueue() for Video FAILED!\n");
+                   (KERN_ERR "cx25821: create_singlethread_workqueue() for \
+                   Video FAILED!\n");
                return -ENOMEM;
        }
        /* 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for
diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 791212c..fd98d8d 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -4,6 +4,9 @@
  *  Copyright (C) 2009 Conexant Systems Inc.
  *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
  *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
+ *  Parts adapted/taken from Eduardo Moscoso Rubino
+ *  Copyright (C) 2009 Eduardo Moscoso Rubino <moscoso@TopoLogica.com>
+ *
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -24,7 +27,7 @@
 #include "cx25821-video.h"

 MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
-MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
+MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
 MODULE_LICENSE("GPL");

 static unsigned int video_nr[] = {[0 ... (CX25821_MAXBOARDS - 1)] = UNSET };
@@ -48,7 +51,10 @@ unsigned int vid_limit = 16;
 module_param(vid_limit, int, 0644);
 MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");

-static void init_controls(struct cx25821_dev *dev, int chan_num);
+static void cx25821_init_controls(struct cx25821_dev *dev, int chan_num);
+
+static const struct v4l2_file_operations video_fops;
+static const struct v4l2_ioctl_ops video_ioctl_ops;

 #define FORMAT_FLAGS_PACKED       0x01

@@ -211,7 +217,7 @@ static int cx25821_ctrl_query(struct v4l2_queryctrl *qctrl)
 }
 */

-// resource management
+/* resource management */
 int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh, unsigned int bit)
 {
        dprintk(1, "%s()\n", __func__);
@@ -221,14 +227,14 @@ int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh, unsigned int

        /* is it free? */
        mutex_lock(&dev->lock);
-       if (dev->resources & bit) {
+       if (dev->channels[fh->channel_id].resources & bit) {
                /* no, someone else uses it */
                mutex_unlock(&dev->lock);
                return 0;
        }
        /* it's free, grab it */
        fh->resources |= bit;
-       dev->resources |= bit;
+       dev->channels[fh->channel_id].resources |= bit;
        dprintk(1, "res: get %d\n", bit);
        mutex_unlock(&dev->lock);
        return 1;
@@ -239,9 +245,9 @@ int cx25821_res_check(struct cx25821_fh *fh, unsigned int bit)
        return fh->resources & bit;
 }

-int cx25821_res_locked(struct cx25821_dev *dev, unsigned int bit)
+int cx25821_res_locked(struct cx25821_fh *fh, unsigned int bit)
 {
-       return dev->resources & bit;
+       return fh->dev->channels[fh->channel_id].resources & bit;
 }

 void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh, unsigned int bits)
@@ -251,7 +257,7 @@ void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh, unsigned i

        mutex_lock(&dev->lock);
        fh->resources &= ~bits;
-       dev->resources &= ~bits;
+       dev->channels[fh->channel_id].resources &= ~bits;
        dprintk(1, "res: put %d\n", bits);
        mutex_unlock(&dev->lock);
 }
@@ -358,11 +364,11 @@ void cx25821_vid_timeout(unsigned long data)
        struct cx25821_data *timeout_data = (struct cx25821_data *)data;
        struct cx25821_dev *dev = timeout_data->dev;
        struct sram_channel *channel = timeout_data->channel;
-       struct cx25821_dmaqueue *q = &dev->vidq[channel->i];
+       struct cx25821_dmaqueue *q = &dev->channels[channel->i].vidq;
        struct cx25821_buffer *buf;
        unsigned long flags;

-       //cx25821_sram_channel_dump(dev, channel);
+       /* cx25821_sram_channel_dump(dev, channel); */
        cx_clear(channel->dma_ctl, 0x11);

        spin_lock_irqsave(&dev->slock, flags);
@@ -384,7 +390,7 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
        u32 count = 0;
        int handled = 0;
        u32 mask;
-       struct sram_channel *channel = &dev->sram_channels[chan_num];
+       struct sram_channel *channel = dev->channels[chan_num].sram_channels;

        mask = cx_read(channel->int_msk);
        if (0 == (status & mask))
@@ -404,7 +410,8 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
        if (status & FLD_VID_DST_RISC1) {
                spin_lock(&dev->slock);
                count = cx_read(channel->gpcnt);
-               cx25821_video_wakeup(dev, &dev->vidq[channel->i], count);
+               cx25821_video_wakeup(dev,
+                       &dev->channels[channel->i].vidq, count);
                spin_unlock(&dev->slock);
                handled++;
        }
@@ -413,8 +420,9 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
        if (status & 0x10) {
                dprintk(2, "stopper video\n");
                spin_lock(&dev->slock);
-               cx25821_restart_video_queue(dev, &dev->vidq[channel->i],
-                                           channel);
+               cx25821_restart_video_queue(dev,
+                               &dev->channels[channel->i].vidq,
+                                       channel);
                spin_unlock(&dev->slock);
                handled++;
        }
@@ -437,72 +445,95 @@ void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
 {
        cx_clear(PCI_INT_MSK, 1);

-       if (dev->video_dev[chan_num]) {
-               if (video_is_registered(dev->video_dev[chan_num]))
-                       video_unregister_device(dev->video_dev[chan_num]);
+       if (dev->channels[chan_num].video_dev) {
+               if (video_is_registered(dev->channels[chan_num].video_dev))
+                       video_unregister_device(
+                               dev->channels[chan_num].video_dev);
                else
-                       video_device_release(dev->video_dev[chan_num]);
+                       video_device_release(
+                               dev->channels[chan_num].video_dev);

-               dev->video_dev[chan_num] = NULL;
+               dev->channels[chan_num].video_dev = NULL;

-               btcx_riscmem_free(dev->pci, &dev->vidq[chan_num].stopper);
+               btcx_riscmem_free(dev->pci,
+                       &dev->channels[chan_num].vidq.stopper);

                printk(KERN_WARNING "device %d released!\n", chan_num);
        }

 }

-int cx25821_video_register(struct cx25821_dev *dev, int chan_num,
-                          struct video_device *video_template)
+int cx25821_video_register(struct cx25821_dev *dev)
 {
        int err;
+       int i;
+
+       struct video_device cx25821_video_device = {
+               .name = "cx25821-video",
+               .fops = &video_fops,
+               .minor = -1,
+               .ioctl_ops = &video_ioctl_ops,
+               .tvnorms = CX25821_NORMS,
+               .current_norm = V4L2_STD_NTSC_M,
+       };

        spin_lock_init(&dev->slock);

-       //printk(KERN_WARNING "Channel %d\n", chan_num);
-
-#ifdef TUNER_FLAG
-       dev->tvnorm = video_template->current_norm;
-#endif
-
-       /* init video dma queues */
-       dev->timeout_data[chan_num].dev = dev;
-       dev->timeout_data[chan_num].channel = &dev->sram_channels[chan_num];
-       INIT_LIST_HEAD(&dev->vidq[chan_num].active);
-       INIT_LIST_HEAD(&dev->vidq[chan_num].queued);
-       dev->vidq[chan_num].timeout.function = cx25821_vid_timeout;
-       dev->vidq[chan_num].timeout.data =
-           (unsigned long)&dev->timeout_data[chan_num];
-       init_timer(&dev->vidq[chan_num].timeout);
-       cx25821_risc_stopper(dev->pci, &dev->vidq[chan_num].stopper,
-                            dev->sram_channels[chan_num].dma_ctl, 0x11, 0);
-
-       /* register v4l devices */
-       dev->video_dev[chan_num] =
-           cx25821_vdev_init(dev, dev->pci, video_template, "video");
-       err =
-           video_register_device(dev->video_dev[chan_num], VFL_TYPE_GRABBER,
-                                 video_nr[dev->nr]);
-
-       if (err < 0) {
-               goto fail_unreg;
+    for (i = 0; i < MAX_VID_CHANNEL_NUM - 1; ++i) {
+               cx25821_init_controls(dev, i);
+
+               cx25821_risc_stopper(dev->pci,
+                               &dev->channels[i].vidq.stopper,
+                               dev->channels[i].sram_channels->dma_ctl,
+                               0x11, 0);
+
+               dev->channels[i].sram_channels = &cx25821_sram_channels[i];
+               dev->channels[i].video_dev = NULL;
+               dev->channels[i].resources = 0;
+
+               cx_write(dev->channels[i].sram_channels->int_stat,
+                               0xffffffff);
+
+               INIT_LIST_HEAD(&dev->channels[i].vidq.active);
+               INIT_LIST_HEAD(&dev->channels[i].vidq.queued);
+
+               dev->channels[i].timeout_data.dev = dev;
+               dev->channels[i].timeout_data.channel =
+                                       &cx25821_sram_channels[i];
+               dev->channels[i].vidq.timeout.function =
+                                       cx25821_vid_timeout;
+               dev->channels[i].vidq.timeout.data =
+                       (unsigned long)&dev->channels[i].timeout_data;
+               init_timer(&dev->channels[i].vidq.timeout);
+
+               /* register v4l devices */
+               dev->channels[i].video_dev = cx25821_vdev_init(dev,
+                       dev->pci, &cx25821_video_device, "video");
+
+               err = video_register_device(dev->channels[i].video_dev,
+                               VFL_TYPE_GRABBER, video_nr[dev->nr]);
+
+               if (err < 0)
+                       goto fail_unreg;
+
        }
-       //set PCI interrupt
+
+    /* set PCI interrupt */
        cx_set(PCI_INT_MSK, 0xff);

        /* initial device configuration */
        mutex_lock(&dev->lock);
 #ifdef TUNER_FLAG
+       dev->tvnorm = cx25821_video_device.current_norm;
        cx25821_set_tvnorm(dev, dev->tvnorm);
 #endif
        mutex_unlock(&dev->lock);

-       init_controls(dev, chan_num);

-       return 0;
+    return 0;

-      fail_unreg:
-       cx25821_video_unregister(dev, chan_num);
+fail_unreg:
+       cx25821_video_unregister(dev, i);
        return err;
 }

@@ -533,7 +564,7 @@ int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
        u32 line0_offset, line1_offset;
        struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
        int bpl_local = LINE_SIZE_D1;
-       int channel_opened = 0;
+       int channel_opened = fh->channel_id;

        BUG_ON(NULL == fh->fmt);
        if (fh->width < 48 || fh->width > 720 ||
@@ -572,26 +603,29 @@ int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
                channel_opened = (channel_opened < 0
                                  || channel_opened > 7) ? 7 : channel_opened;

-               if (dev->pixel_formats[channel_opened] == PIXEL_FRMT_411)
+               if (dev->channels[channel_opened]
+                       .pixel_formats == PIXEL_FRMT_411)
                        buf->bpl = (buf->fmt->depth * buf->vb.width) >> 3;
                else
                        buf->bpl = (buf->fmt->depth >> 3) * (buf->vb.width);

-               if (dev->pixel_formats[channel_opened] == PIXEL_FRMT_411) {
+               if (dev->channels[channel_opened]
+                       .pixel_formats == PIXEL_FRMT_411) {
                        bpl_local = buf->bpl;
                } else {
-                       bpl_local = buf->bpl;   //Default
+                       bpl_local = buf->bpl;   /* Default */

                        if (channel_opened >= 0 && channel_opened <= 7) {
-                               if (dev->use_cif_resolution[channel_opened]) {
+                               if (dev->channels[channel_opened]
+                                               .use_cif_resolution) {
                                        if (dev->tvnorm & V4L2_STD_PAL_BG
                                            || dev->tvnorm & V4L2_STD_PAL_DK)
                                                bpl_local = 352 << 1;
                                        else
                                                bpl_local =
-                                                   dev->
-                                                   cif_width[channel_opened] <<
-                                                   1;
+                                                 dev->channels[channel_opened].
+                                                 cif_width <<
+                                                 1;
                                }
                        }
                }
@@ -685,6 +719,383 @@ int cx25821_video_mmap(struct file *file, struct vm_area_struct *vma)
        return videobuf_mmap_mapper(get_queue(fh), vma);
 }

+
+static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+{
+       struct cx25821_buffer *buf =
+           container_of(vb, struct cx25821_buffer, vb);
+       struct cx25821_buffer *prev;
+       struct cx25821_fh *fh = vq->priv_data;
+       struct cx25821_dev *dev = fh->dev;
+       struct cx25821_dmaqueue *q = &dev->channels[fh->channel_id].vidq;
+
+       /* add jump to stopper */
+       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
+       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
+       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
+
+       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
+
+       if (!list_empty(&q->queued)) {
+               list_add_tail(&buf->vb.queue, &q->queued);
+               buf->vb.state = VIDEOBUF_QUEUED;
+               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
+                       buf->vb.i);
+
+       } else if (list_empty(&q->active)) {
+               list_add_tail(&buf->vb.queue, &q->active);
+               cx25821_start_video_dma(dev, q, buf,
+                                       dev->channels[fh->channel_id].
+                                       sram_channels);
+               buf->vb.state = VIDEOBUF_ACTIVE;
+               buf->count = q->count++;
+               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
+               dprintk(2,
+                       "[%p/%d] buffer_queue - first active, buf cnt = %d, \
+                       q->count = %d\n",
+                       buf, buf->vb.i, buf->count, q->count);
+       } else {
+               prev =
+                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
+               if (prev->vb.width == buf->vb.width
+                   && prev->vb.height == buf->vb.height
+                   && prev->fmt == buf->fmt) {
+                       list_add_tail(&buf->vb.queue, &q->active);
+                       buf->vb.state = VIDEOBUF_ACTIVE;
+                       buf->count = q->count++;
+                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
+
+                       /* 64 bit bits 63-32 */
+                       prev->risc.jmp[2] = cpu_to_le32(0);
+                       dprintk(2,
+                               "[%p/%d] buffer_queue - append to active, \
+                               buf->count=%d\n",
+                               buf, buf->vb.i, buf->count);
+
+               } else {
+                       list_add_tail(&buf->vb.queue, &q->queued);
+                       buf->vb.state = VIDEOBUF_QUEUED;
+                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
+                               buf->vb.i);
+               }
+       }
+
+       if (list_empty(&q->active))
+               dprintk(2, "active queue empty!\n");
+}
+
+static struct videobuf_queue_ops cx25821_video_qops = {
+       .buf_setup = cx25821_buffer_setup,
+       .buf_prepare = cx25821_buffer_prepare,
+       .buf_queue = buffer_queue,
+       .buf_release = cx25821_buffer_release,
+};
+
+static int video_open(struct file *file)
+{
+       struct video_device *vdev = video_devdata(file);
+       struct cx25821_dev *h, *dev = video_drvdata(file);
+       struct cx25821_fh *fh;
+       struct list_head *list;
+       int minor = video_devdata(file)->minor;
+       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+       u32 pix_format;
+       int ch_id = 0;
+       int i;
+
+       dprintk(1, "open dev=%s type=%s\n",
+                       video_device_node_name(vdev),
+                       v4l2_type_names[type]);
+
+       /* allocate + initialize per filehandle data */
+       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+       if (NULL == fh)
+               return -ENOMEM;
+
+       lock_kernel();
+
+       list_for_each(list, &cx25821_devlist)
+       {
+               h = list_entry(list, struct cx25821_dev, devlist);
+
+               for (i = 0; i < MAX_VID_CHANNEL_NUM; i++) {
+                       if (h->channels[i].video_dev &&
+                           h->channels[i].video_dev->minor == minor) {
+                               dev = h;
+                               ch_id = i;
+                               type  = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+                       }
+               }
+       }
+
+       if (NULL == dev) {
+               unlock_kernel();
+               return -ENODEV;
+       }
+
+       file->private_data = fh;
+       fh->dev = dev;
+       fh->type = type;
+       fh->width = 720;
+    fh->channel_id = ch_id;
+
+       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
+               fh->height = 576;
+       else
+               fh->height = 480;
+
+       dev->channel_opened = fh->channel_id;
+       pix_format =
+           (dev->channels[ch_id].pixel_formats ==
+            PIXEL_FRMT_411) ? V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
+       fh->fmt = format_by_fourcc(pix_format);
+
+       v4l2_prio_open(&dev->channels[ch_id].prio, &fh->prio);
+
+       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
+                              &dev->pci->dev, &dev->slock,
+                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
+                              V4L2_FIELD_INTERLACED,
+                              sizeof(struct cx25821_buffer), fh);
+
+       dprintk(1, "post videobuf_queue_init()\n");
+       unlock_kernel();
+
+       return 0;
+}
+
+static ssize_t video_read(struct file *file, char __user * data, size_t count,
+                         loff_t *ppos)
+{
+       struct cx25821_fh *fh = file->private_data;
+
+       switch (fh->type) {
+       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+               if (cx25821_res_locked(fh, RESOURCE_VIDEO0))
+                       return -EBUSY;
+
+               return videobuf_read_one(&fh->vidq, data, count, ppos,
+                                        file->f_flags & O_NONBLOCK);
+
+       default:
+               BUG();
+               return 0;
+       }
+}
+
+static unsigned int video_poll(struct file *file,
+                              struct poll_table_struct *wait)
+{
+       struct cx25821_fh *fh = file->private_data;
+       struct cx25821_buffer *buf;
+
+       if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
+               /* streaming capture */
+               if (list_empty(&fh->vidq.stream))
+                       return POLLERR;
+               buf = list_entry(fh->vidq.stream.next,
+                                struct cx25821_buffer, vb.stream);
+       } else {
+               /* read() capture */
+               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
+               if (NULL == buf)
+                       return POLLERR;
+       }
+
+       poll_wait(file, &buf->vb.done, wait);
+       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR) {
+               if (buf->vb.state == VIDEOBUF_DONE) {
+                       struct cx25821_dev *dev = fh->dev;
+
+                       if (dev && dev->channels[fh->channel_id]
+                                               .use_cif_resolution) {
+                               u8 cam_id = *((char *)buf->vb.baddr + 3);
+                               memcpy((char *)buf->vb.baddr,
+                                      (char *)buf->vb.baddr + (fh->width * 2),
+                                      (fh->width * 2));
+                               *((char *)buf->vb.baddr + 3) = cam_id;
+                       }
+               }
+
+               return POLLIN | POLLRDNORM;
+       }
+
+       return 0;
+}
+
+static int video_release(struct file *file)
+{
+       struct cx25821_fh *fh = file->private_data;
+       struct cx25821_dev *dev = fh->dev;
+
+       /* stop the risc engine and fifo */
+       cx_write(channel0->dma_ctl, 0); /* FIFO and RISC disable */
+
+       /* stop video capture */
+       if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
+               videobuf_queue_cancel(&fh->vidq);
+               cx25821_res_free(dev, fh, RESOURCE_VIDEO0);
+       }
+
+       if (fh->vidq.read_buf) {
+               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
+               kfree(fh->vidq.read_buf);
+       }
+
+       videobuf_mmap_free(&fh->vidq);
+
+       v4l2_prio_close(&dev->channels[fh->channel_id].prio, fh->prio);
+       file->private_data = NULL;
+       kfree(fh);
+
+       return 0;
+}
+
+static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+       struct cx25821_fh *fh = priv;
+       struct cx25821_dev *dev = fh->dev;
+
+       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
+               return -EINVAL;
+
+       if (unlikely(i != fh->type))
+               return -EINVAL;
+
+       if (unlikely(!cx25821_res_get(dev, fh,
+                       cx25821_get_resource(fh, RESOURCE_VIDEO0))))
+               return -EBUSY;
+
+       return videobuf_streamon(get_queue(fh));
+}
+
+static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+       struct cx25821_fh *fh = priv;
+       struct cx25821_dev *dev = fh->dev;
+       int err, res;
+
+       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+               return -EINVAL;
+       if (i != fh->type)
+               return -EINVAL;
+
+       res = cx25821_get_resource(fh, RESOURCE_VIDEO0);
+       err = videobuf_streamoff(get_queue(fh));
+       if (err < 0)
+               return err;
+       cx25821_res_free(dev, fh, res);
+       return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+                               struct v4l2_format *f)
+{
+       struct cx25821_fh *fh = priv;
+       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+       int err;
+       int pix_format = PIXEL_FRMT_422;
+
+       if (fh) {
+               err = v4l2_prio_check(&dev->channels[fh->channel_id]
+                                               .prio, fh->prio);
+               if (0 != err)
+                       return err;
+       }
+
+       dprintk(2, "%s()\n", __func__);
+       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
+
+       if (0 != err)
+               return err;
+
+       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
+       fh->vidq.field = f->fmt.pix.field;
+
+       /* check if width and height is valid based on set standard */
+       if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm))
+               fh->width = f->fmt.pix.width;
+
+       if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm))
+               fh->height = f->fmt.pix.height;
+
+       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
+               pix_format = PIXEL_FRMT_411;
+       else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
+               pix_format = PIXEL_FRMT_422;
+       else
+               return -EINVAL;
+
+       cx25821_set_pixel_format(dev, SRAM_CH00, pix_format);
+
+       /* check if cif resolution */
+       if (fh->width == 320 || fh->width == 352)
+               dev->channels[fh->channel_id].use_cif_resolution = 1;
+       else
+               dev->channels[fh->channel_id].use_cif_resolution = 0;
+
+       dev->channels[fh->channel_id].cif_width = fh->width;
+       medusa_set_resolution(dev, fh->width, SRAM_CH00);
+
+       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
+               fh->height, fh->vidq.field);
+       cx25821_call_all(dev, video, s_fmt, f);
+
+       return 0;
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+       int ret_val = 0;
+       struct cx25821_fh *fh = priv;
+       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+
+       ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
+
+    p->sequence = dev->channels[fh->channel_id].vidq.count;
+
+       return ret_val;
+}
+
+static int vidioc_log_status(struct file *file, void *priv)
+{
+       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+       struct cx25821_fh *fh = priv;
+       char name[32 + 2];
+
+       struct sram_channel *sram_ch = dev->channels[fh->channel_id]
+                                                       .sram_channels;
+       u32 tmp = 0;
+
+       snprintf(name, sizeof(name), "%s/2", dev->name);
+       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
+              dev->name);
+       cx25821_call_all(dev, core, log_status);
+       tmp = cx_read(sram_ch->dma_ctl);
+       printk(KERN_INFO "Video input 0 is %s\n",
+              (tmp & 0x11) ? "streaming" : "stopped");
+       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
+              dev->name);
+       return 0;
+}
+
+static int vidioc_s_ctrl(struct file *file, void *priv,
+                        struct v4l2_control *ctl)
+{
+       struct cx25821_fh *fh = priv;
+       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+       int err;
+
+       if (fh) {
+               err = v4l2_prio_check(&dev->channels[fh->channel_id]
+                                               .prio, fh->prio);
+               if (0 != err)
+                       return err;
+       }
+
+       return cx25821_set_control(dev, ctl, fh->channel_id);
+}
+
 /* VIDEO IOCTLS                                                       */
 int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f)
 {
@@ -822,8 +1233,9 @@ int cx25821_vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 int cx25821_vidioc_g_priority(struct file *file, void *f, enum v4l2_priority *p)
 {
        struct cx25821_dev *dev = ((struct cx25821_fh *)f)->dev;
+       struct cx25821_fh *fh = f;

-       *p = v4l2_prio_max(&dev->prio);
+       *p = v4l2_prio_max(&dev->channels[fh->channel_id].prio);

        return 0;
 }
@@ -833,7 +1245,8 @@ int cx25821_vidioc_s_priority(struct file *file, void *f, enum v4l2_priority pri
        struct cx25821_fh *fh = f;
        struct cx25821_dev *dev = ((struct cx25821_fh *)f)->dev;

-       return v4l2_prio_change(&dev->prio, &fh->prio, prio);
+       return v4l2_prio_change(&dev->channels[fh->channel_id]
+                                       .prio, &fh->prio, prio);
 }

 #ifdef TUNER_FLAG
@@ -846,7 +1259,8 @@ int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id * tvnorms)
        dprintk(1, "%s()\n", __func__);

        if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
+               err = v4l2_prio_check(&dev->channels[fh->channel_id]
+                                               .prio, fh->prio);
                if (0 != err)
                        return err;
        }
@@ -916,7 +1330,8 @@ int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
        dprintk(1, "%s(%d)\n", __func__, i);

        if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
+               err = v4l2_prio_check(&dev->channels[fh->channel_id]
+                                               .prio, fh->prio);
                if (0 != err)
                        return err;
        }
@@ -967,9 +1382,14 @@ int cx25821_vidioc_s_frequency(struct file *file, void *priv, struct v4l2_freque
        int err;

        if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
+               dev = fh->dev;
+               err = v4l2_prio_check(&dev->channels[fh->channel_id]
+                                               .prio, fh->prio);
                if (0 != err)
                        return err;
+       } else {
+               printk(KERN_ERR "Invalid fh pointer!\n");
+               return -EINVAL;
        }

        return cx25821_set_freq(dev, f);
@@ -1031,7 +1451,8 @@ int cx25821_vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
        int err;

        if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
+               err = v4l2_prio_check(&dev->channels[fh->channel_id]
+                                               .prio, fh->prio);
                if (0 != err)
                        return err;
        }
@@ -1046,7 +1467,7 @@ int cx25821_vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 }

 #endif
-// ******************************************************************************************
+/*****************************************************************************/
 static const struct v4l2_queryctrl no_ctl = {
        .name = "42",
        .flags = V4L2_CTRL_FLAG_DISABLED,
@@ -1129,6 +1550,7 @@ static const struct v4l2_queryctrl *ctrl_by_id(unsigned int id)
 int cx25821_vidioc_g_ctrl(struct file *file, void *priv, struct v4l2_control *ctl)
 {
        struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+       struct cx25821_fh *fh = priv;

        const struct v4l2_queryctrl *ctrl;

@@ -1138,16 +1560,16 @@ int cx25821_vidioc_g_ctrl(struct file *file, void *priv, struct v4l2_control *ct
                return -EINVAL;
        switch (ctl->id) {
        case V4L2_CID_BRIGHTNESS:
-               ctl->value = dev->ctl_bright;
+               ctl->value = dev->channels[fh->channel_id].ctl_bright;
                break;
        case V4L2_CID_HUE:
-               ctl->value = dev->ctl_hue;
+               ctl->value = dev->channels[fh->channel_id].ctl_hue;
                break;
        case V4L2_CID_CONTRAST:
-               ctl->value = dev->ctl_contrast;
+               ctl->value = dev->channels[fh->channel_id].ctl_contrast;
                break;
        case V4L2_CID_SATURATION:
-               ctl->value = dev->ctl_saturation;
+               ctl->value = dev->channels[fh->channel_id].ctl_saturation;
                break;
        }
        return 0;
@@ -1181,19 +1603,19 @@ int cx25821_set_control(struct cx25821_dev *dev,

        switch (ctl->id) {
        case V4L2_CID_BRIGHTNESS:
-               dev->ctl_bright = ctl->value;
+               dev->channels[chan_num].ctl_bright = ctl->value;
                medusa_set_brightness(dev, ctl->value, chan_num);
                break;
        case V4L2_CID_HUE:
-               dev->ctl_hue = ctl->value;
+               dev->channels[chan_num].ctl_hue = ctl->value;
                medusa_set_hue(dev, ctl->value, chan_num);
                break;
        case V4L2_CID_CONTRAST:
-               dev->ctl_contrast = ctl->value;
+               dev->channels[chan_num].ctl_contrast = ctl->value;
                medusa_set_contrast(dev, ctl->value, chan_num);
                break;
        case V4L2_CID_SATURATION:
-               dev->ctl_saturation = ctl->value;
+               dev->channels[chan_num].ctl_saturation = ctl->value;
                medusa_set_saturation(dev, ctl->value, chan_num);
                break;
        }
@@ -1203,7 +1625,7 @@ int cx25821_set_control(struct cx25821_dev *dev,
        return err;
 }

-static void init_controls(struct cx25821_dev *dev, int chan_num)
+static void cx25821_init_controls(struct cx25821_dev *dev, int chan_num)
 {
        struct v4l2_control ctrl;
        int i;
@@ -1239,23 +1661,24 @@ int cx25821_vidioc_s_crop(struct file *file, void *priv, struct v4l2_crop *crop)
        int err;

        if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
+               err = v4l2_prio_check(&dev->channels[fh->channel_id].
+                                               prio, fh->prio);
                if (0 != err)
                        return err;
        }
-       // cx25821_vidioc_s_crop not supported
+       /* cx25821_vidioc_s_crop not supported */
        return -EINVAL;
 }

 int cx25821_vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
 {
-       // cx25821_vidioc_g_crop not supported
+       /* cx25821_vidioc_g_crop not supported */
        return -EINVAL;
 }

 int cx25821_vidioc_querystd(struct file *file, void *priv, v4l2_std_id * norm)
 {
-       // medusa does not support video standard sensing of current input
+       /* medusa does not support video standard sensing of current input */
        *norm = CX25821_NORMS;

        return 0;
@@ -1297,3 +1720,325 @@ int cx25821_is_valid_height(u32 height, v4l2_std_id tvnorm)

        return 0;
 }
+
+static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
+                                 unsigned long arg)
+{
+       struct cx25821_fh *fh = file->private_data;
+       struct cx25821_dev *dev = fh->dev;
+       int command = 0;
+       struct upstream_user_struct *data_from_user;
+
+       data_from_user = (struct upstream_user_struct *)arg;
+
+       if (!data_from_user) {
+               printk
+                   ("cx25821 in %s(): Upstream data is INVALID. Returning.\n",
+                    __func__);
+               return 0;
+       }
+
+       command = data_from_user->command;
+
+       if (command != UPSTREAM_START_VIDEO &&
+               command != UPSTREAM_STOP_VIDEO)
+               return 0;
+
+       dev->input_filename = data_from_user->input_filename;
+       dev->input_audiofilename = data_from_user->input_filename;
+       dev->vid_stdname = data_from_user->vid_stdname;
+       dev->pixel_format = data_from_user->pixel_format;
+       dev->channel_select = data_from_user->channel_select;
+       dev->command = data_from_user->command;
+
+       switch (command) {
+       case UPSTREAM_START_VIDEO:
+               cx25821_start_upstream_video_ch1(dev, data_from_user);
+               break;
+
+       case UPSTREAM_STOP_VIDEO:
+               cx25821_stop_upstream_video_ch1(dev);
+               break;
+       }
+
+       return 0;
+}
+
+static long video_ioctl_upstream10(struct file *file, unsigned int cmd,
+                                  unsigned long arg)
+{
+       struct cx25821_fh *fh = file->private_data;
+       struct cx25821_dev *dev = fh->dev;
+       int command = 0;
+       struct upstream_user_struct *data_from_user;
+
+       data_from_user = (struct upstream_user_struct *)arg;
+
+       if (!data_from_user) {
+               printk
+                   ("cx25821 in %s(): Upstream data is INVALID. Returning.\n",
+                    __func__);
+               return 0;
+       }
+
+       command = data_from_user->command;
+
+       if (command != UPSTREAM_START_VIDEO &&
+               command != UPSTREAM_STOP_VIDEO)
+               return 0;
+
+       dev->input_filename_ch2 = data_from_user->input_filename;
+       dev->input_audiofilename = data_from_user->input_filename;
+       dev->vid_stdname_ch2 = data_from_user->vid_stdname;
+       dev->pixel_format_ch2 = data_from_user->pixel_format;
+       dev->channel_select_ch2 = data_from_user->channel_select;
+       dev->command_ch2 = data_from_user->command;
+
+       switch (command) {
+       case UPSTREAM_START_VIDEO:
+               cx25821_start_upstream_video_ch2(dev, data_from_user);
+               break;
+
+       case UPSTREAM_STOP_VIDEO:
+               cx25821_stop_upstream_video_ch2(dev);
+               break;
+       }
+
+       return 0;
+}
+
+static long video_ioctl_upstream11(struct file *file, unsigned int cmd,
+                                  unsigned long arg)
+{
+       struct cx25821_fh *fh = file->private_data;
+       struct cx25821_dev *dev = fh->dev;
+       int command = 0;
+       struct upstream_user_struct *data_from_user;
+
+       data_from_user = (struct upstream_user_struct *)arg;
+
+       if (!data_from_user) {
+               printk
+                   ("cx25821 in %s(): Upstream data is INVALID. Returning.\n",
+                    __func__);
+               return 0;
+       }
+
+       command = data_from_user->command;
+
+       if (command != UPSTREAM_START_AUDIO &&
+               command != UPSTREAM_STOP_AUDIO)
+               return 0;
+
+       dev->input_filename = data_from_user->input_filename;
+       dev->input_audiofilename = data_from_user->input_filename;
+       dev->vid_stdname = data_from_user->vid_stdname;
+       dev->pixel_format = data_from_user->pixel_format;
+       dev->channel_select = data_from_user->channel_select;
+       dev->command = data_from_user->command;
+
+       switch (command) {
+       case UPSTREAM_START_AUDIO:
+               cx25821_start_upstream_audio(dev, data_from_user);
+               break;
+
+       case UPSTREAM_STOP_AUDIO:
+               cx25821_stop_upstream_audio(dev);
+               break;
+       }
+
+       return 0;
+}
+
+static long video_ioctl_set(struct file *file, unsigned int cmd,
+                           unsigned long arg)
+{
+       struct cx25821_fh *fh = file->private_data;
+       struct cx25821_dev *dev = fh->dev;
+       struct downstream_user_struct *data_from_user;
+       int command;
+       int width = 720;
+       int selected_channel = 0, pix_format = 0, i = 0;
+       int cif_enable = 0, cif_width = 0;
+       u32 value = 0;
+
+       data_from_user = (struct downstream_user_struct *)arg;
+
+       if (!data_from_user) {
+               printk(
+               "cx25821 in %s(): User data is INVALID. Returning.\n",
+               __func__);
+               return 0;
+       }
+
+       command = data_from_user->command;
+
+       if (command != SET_VIDEO_STD && command != SET_PIXEL_FORMAT
+           && command != ENABLE_CIF_RESOLUTION && command != REG_READ
+           && command != REG_WRITE && command != MEDUSA_READ
+           && command != MEDUSA_WRITE) {
+               return 0;
+       }
+
+       switch (command) {
+       case SET_VIDEO_STD:
+               dev->tvnorm =
+                   !strcmp(data_from_user->vid_stdname,
+                           "PAL") ? V4L2_STD_PAL_BG : V4L2_STD_NTSC_M;
+               medusa_set_videostandard(dev);
+               break;
+
+       case SET_PIXEL_FORMAT:
+               selected_channel = data_from_user->decoder_select;
+               pix_format = data_from_user->pixel_format;
+
+               if (!(selected_channel <= 7 && selected_channel >= 0)) {
+                       selected_channel -= 4;
+                       selected_channel = selected_channel % 8;
+               }
+
+               if (selected_channel >= 0)
+                       cx25821_set_pixel_format(dev, selected_channel,
+                                                pix_format);
+
+               break;
+
+       case ENABLE_CIF_RESOLUTION:
+               selected_channel = data_from_user->decoder_select;
+               cif_enable = data_from_user->cif_resolution_enable;
+               cif_width = data_from_user->cif_width;
+
+               if (cif_enable) {
+                       if (dev->tvnorm & V4L2_STD_PAL_BG
+                           || dev->tvnorm & V4L2_STD_PAL_DK)
+                               width = 352;
+                       else
+                               width = (cif_width == 320
+                                        || cif_width == 352) ? cif_width : 320;
+               }
+
+               if (!(selected_channel <= 7 && selected_channel >= 0)) {
+                       selected_channel -= 4;
+                       selected_channel = selected_channel % 8;
+               }
+
+               if (selected_channel <= 7 && selected_channel >= 0) {
+                       dev->channels[selected_channel].
+                               use_cif_resolution = cif_enable;
+                       dev->channels[selected_channel].cif_width = width;
+               } else {
+                       for (i = 0; i < VID_CHANNEL_NUM; i++) {
+                               dev->channels[i].use_cif_resolution =
+                                       cif_enable;
+                               dev->channels[i].cif_width = width;
+                       }
+               }
+
+               medusa_set_resolution(dev, width, selected_channel);
+               break;
+       case REG_READ:
+               data_from_user->reg_data = cx_read(data_from_user->reg_address);
+               break;
+       case REG_WRITE:
+               cx_write(data_from_user->reg_address, data_from_user->reg_data);
+               break;
+       case MEDUSA_READ:
+               value =
+                   cx25821_i2c_read(&dev->i2c_bus[0],
+                                    (u16) data_from_user->reg_address,
+                                    &data_from_user->reg_data);
+               break;
+       case MEDUSA_WRITE:
+               cx25821_i2c_write(&dev->i2c_bus[0],
+                                 (u16) data_from_user->reg_address,
+                                 data_from_user->reg_data);
+               break;
+       }
+
+       return 0;
+}
+
+static long cx25821_video_ioctl(struct file *file,
+                               unsigned int cmd, unsigned long arg)
+{
+       int  ret = 0;
+
+       struct cx25821_fh  *fh  = file->private_data;
+
+       /* check to see if it's the video upstream */
+       if (fh->channel_id == SRAM_CH09) {
+               ret = video_ioctl_upstream9(file, cmd, arg);
+               return ret;
+       } else if (fh->channel_id == SRAM_CH10) {
+               ret = video_ioctl_upstream10(file, cmd, arg);
+               return ret;
+       } else if (fh->channel_id == SRAM_CH11) {
+               ret = video_ioctl_upstream11(file, cmd, arg);
+               ret = video_ioctl_set(file, cmd, arg);
+               return ret;
+       }
+
+    return video_ioctl2(file, cmd, arg);
+}
+
+/* exported stuff */
+static const struct v4l2_file_operations video_fops = {
+       .owner = THIS_MODULE,
+       .open = video_open,
+       .release = video_release,
+       .read = video_read,
+       .poll = video_poll,
+       .mmap = cx25821_video_mmap,
+       .ioctl = cx25821_video_ioctl,
+};
+
+static const struct v4l2_ioctl_ops video_ioctl_ops = {
+       .vidioc_querycap = cx25821_vidioc_querycap,
+       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
+       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
+       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
+       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
+       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
+       .vidioc_querybuf = cx25821_vidioc_querybuf,
+       .vidioc_qbuf = cx25821_vidioc_qbuf,
+       .vidioc_dqbuf = vidioc_dqbuf,
+#ifdef TUNER_FLAG
+       .vidioc_s_std = cx25821_vidioc_s_std,
+       .vidioc_querystd = cx25821_vidioc_querystd,
+#endif
+       .vidioc_cropcap = cx25821_vidioc_cropcap,
+       .vidioc_s_crop = cx25821_vidioc_s_crop,
+       .vidioc_g_crop = cx25821_vidioc_g_crop,
+       .vidioc_enum_input = cx25821_vidioc_enum_input,
+       .vidioc_g_input = cx25821_vidioc_g_input,
+       .vidioc_s_input = cx25821_vidioc_s_input,
+       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
+       .vidioc_s_ctrl = vidioc_s_ctrl,
+       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
+       .vidioc_streamon = vidioc_streamon,
+       .vidioc_streamoff = vidioc_streamoff,
+       .vidioc_log_status = vidioc_log_status,
+       .vidioc_g_priority = cx25821_vidioc_g_priority,
+       .vidioc_s_priority = cx25821_vidioc_s_priority,
+#ifdef CONFIG_VIDEO_V4L1_COMPAT
+       .vidiocgmbuf = cx25821_vidiocgmbuf,
+#endif
+#ifdef TUNER_FLAG
+       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
+       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
+       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
+       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
+#endif
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+       .vidioc_g_register = cx25821_vidioc_g_register,
+       .vidioc_s_register = cx25821_vidioc_s_register,
+#endif
+};
+
+struct video_device cx25821_videoioctl_template = {
+               .name = "cx25821-videoioctl",
+               .fops = &video_fops,
+               .ioctl_ops = &video_ioctl_ops,
+               .tvnorms = CX25821_NORMS,
+               .current_norm = V4L2_STD_NTSC_M,
+};
diff --git a/drivers/staging/cx25821/cx25821-video.h b/drivers/staging/cx25821/cx25821-video.h
index 0bddc02..513eaba 100644
--- a/drivers/staging/cx25821/cx25821-video.h
+++ b/drivers/staging/cx25821/cx25821-video.h
@@ -80,17 +80,6 @@ extern struct sram_channel *channel7;
 extern struct sram_channel *channel9;
 extern struct sram_channel *channel10;
 extern struct sram_channel *channel11;
-extern struct video_device cx25821_video_template0;
-extern struct video_device cx25821_video_template1;
-extern struct video_device cx25821_video_template2;
-extern struct video_device cx25821_video_template3;
-extern struct video_device cx25821_video_template4;
-extern struct video_device cx25821_video_template5;
-extern struct video_device cx25821_video_template6;
-extern struct video_device cx25821_video_template7;
-extern struct video_device cx25821_video_template9;
-extern struct video_device cx25821_video_template10;
-extern struct video_device cx25821_video_template11;
 extern struct video_device cx25821_videoioctl_template;
 //extern const u32 *ctrl_classes[];

@@ -113,7 +102,7 @@ extern int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm);
 extern int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh,
                   unsigned int bit);
 extern int cx25821_res_check(struct cx25821_fh *fh, unsigned int bit);
-extern int cx25821_res_locked(struct cx25821_dev *dev, unsigned int bit);
+extern int cx25821_res_locked(struct cx25821_fh *fh, unsigned int bit);
 extern void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh,
                     unsigned int bits);
 extern int cx25821_video_mux(struct cx25821_dev *dev, unsigned int input);
@@ -126,8 +115,7 @@ extern int cx25821_set_scale(struct cx25821_dev *dev, unsigned int width,
                             unsigned int height, enum v4l2_field field);
 extern int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status);
 extern void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num);
-extern int cx25821_video_register(struct cx25821_dev *dev, int chan_num,
-                                 struct video_device *video_template);
+extern int cx25821_video_register(struct cx25821_dev *dev);
 extern int cx25821_get_format_size(void);

 extern int cx25821_buffer_setup(struct videobuf_queue *q, unsigned int *count,
diff --git a/drivers/staging/cx25821/cx25821-video0.c b/drivers/staging/cx25821/cx25821-video0.c
deleted file mode 100644
index 0be2cc1..0000000
--- a/drivers/staging/cx25821/cx25821-video0.c
+++ /dev/null
@@ -1,434 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "cx25821-video.h"
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-       struct cx25821_buffer *buf =
-           container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH00];
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-       if (!list_empty(&q->queued)) {
-               list_add_tail(&buf->vb.queue, &q->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-                       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-               list_add_tail(&buf->vb.queue, &q->active);
-               cx25821_start_video_dma(dev, q, buf,
-                                       &dev->sram_channels[SRAM_CH00]);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               buf->count = q->count++;
-               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-               dprintk(2,
-                       "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-                       buf, buf->vb.i, buf->count, q->count);
-       } else {
-               prev =
-                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-               if (prev->vb.width == buf->vb.width
-                   && prev->vb.height == buf->vb.height
-                   && prev->fmt == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &q->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       buf->count = q->count++;
-                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-                       /* 64 bit bits 63-32 */
-                       prev->risc.jmp[2] = cpu_to_le32(0);
-                       dprintk(2,
-                               "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-                               buf, buf->vb.i, buf->count);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &q->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-                               buf->vb.i);
-               }
-       }
-
-       if (list_empty(&q->active)) {
-               dprintk(2, "active queue empty!\n");
-       }
-}
-
-static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
-};
-
-static int video_open(struct file *file)
-{
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-       u32 pix_format;
-
-       printk("open dev=%s type=%s\n", video_device_node_name(vdev),
-               v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-               return -ENOMEM;
-
-       lock_kernel();
-
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-               fh->height = 576;
-       else
-               fh->height = 480;
-
-       dev->channel_opened = SRAM_CH00;
-       pix_format =
-           (dev->pixel_formats[dev->channel_opened] ==
-            PIXEL_FRMT_411) ? V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
-       fh->fmt = format_by_fourcc(pix_format);
-
-       v4l2_prio_open(&dev->prio, &fh->prio);
-
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-                              &dev->pci->dev, &dev->slock,
-                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
-                              V4L2_FIELD_INTERLACED,
-                              sizeof(struct cx25821_buffer), fh);
-
-       dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
-
-       return 0;
-}
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-                         loff_t * ppos)
-{
-       struct cx25821_fh *fh = file->private_data;
-
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-               if (cx25821_res_locked(fh->dev, RESOURCE_VIDEO0))
-                       return -EBUSY;
-
-               return videobuf_read_one(&fh->vidq, data, count, ppos,
-                                        file->f_flags & O_NONBLOCK);
-
-       default:
-               BUG();
-               return 0;
-       }
-}
-
-static unsigned int video_poll(struct file *file,
-                              struct poll_table_struct *wait)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
-
-       if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
-               /* streaming capture */
-               if (list_empty(&fh->vidq.stream))
-                       return POLLERR;
-               buf = list_entry(fh->vidq.stream.next,
-                                struct cx25821_buffer, vb.stream);
-       } else {
-               /* read() capture */
-               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-               if (NULL == buf)
-                       return POLLERR;
-       }
-
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR) {
-               if (buf->vb.state == VIDEOBUF_DONE) {
-                       struct cx25821_dev *dev = fh->dev;
-
-                       if (dev && dev->use_cif_resolution[SRAM_CH00]) {
-                               u8 cam_id = *((char *)buf->vb.baddr + 3);
-                               memcpy((char *)buf->vb.baddr,
-                                      (char *)buf->vb.baddr + (fh->width * 2),
-                                      (fh->width * 2));
-                               *((char *)buf->vb.baddr + 3) = cam_id;
-                       }
-               }
-
-               return POLLIN | POLLRDNORM;
-       }
-
-       return 0;
-}
-
-static int video_release(struct file *file)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-
-       //stop the risc engine and fifo
-       cx_write(channel0->dma_ctl, 0); /* FIFO and RISC disable */
-
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO0)) {
-               videobuf_queue_cancel(&fh->vidq);
-               cx25821_res_free(dev, fh, RESOURCE_VIDEO0);
-       }
-
-       if (fh->vidq.read_buf) {
-               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-               kfree(fh->vidq.read_buf);
-       }
-
-       videobuf_mmap_free(&fh->vidq);
-
-       v4l2_prio_close(&dev->prio, fh->prio);
-       file->private_data = NULL;
-       kfree(fh);
-
-       return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(i != fh->type)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO0)))) {
-               return -EBUSY;
-       }
-
-       return videobuf_streamon(get_queue(fh));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
-
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               return -EINVAL;
-       if (i != fh->type)
-               return -EINVAL;
-
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO0);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-               return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-                               struct v4l2_format *f)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-       int pix_format = PIXEL_FRMT_422;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
-
-       if (0 != err)
-               return err;
-
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->vidq.field = f->fmt.pix.field;
-
-       // check if width and height is valid based on set standard
-       if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm)) {
-               fh->width = f->fmt.pix.width;
-       }
-
-       if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm)) {
-               fh->height = f->fmt.pix.height;
-       }
-
-       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
-               pix_format = PIXEL_FRMT_411;
-       else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
-               pix_format = PIXEL_FRMT_422;
-       else
-               return -EINVAL;
-
-       cx25821_set_pixel_format(dev, SRAM_CH00, pix_format);
-
-       // check if cif resolution
-       if (fh->width == 320 || fh->width == 352) {
-               dev->use_cif_resolution[SRAM_CH00] = 1;
-       } else {
-               dev->use_cif_resolution[SRAM_CH00] = 0;
-       }
-       dev->cif_width[SRAM_CH00] = fh->width;
-       medusa_set_resolution(dev, fh->width, SRAM_CH00);
-
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-               fh->height, fh->vidq.field);
-       cx25821_call_all(dev, video, s_fmt, f);
-
-       return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-       int ret_val = 0;
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-
-       ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-
-       p->sequence = dev->vidq[SRAM_CH00].count;
-
-       return ret_val;
-}
-
-static int vidioc_log_status(struct file *file, void *priv)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       char name[32 + 2];
-
-       struct sram_channel *sram_ch = &dev->sram_channels[SRAM_CH00];
-       u32 tmp = 0;
-
-       snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-              dev->name);
-       cx25821_call_all(dev, core, log_status);
-       tmp = cx_read(sram_ch->dma_ctl);
-       printk(KERN_INFO "Video input 0 is %s\n",
-              (tmp & 0x11) ? "streaming" : "stopped");
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-              dev->name);
-       return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-                        struct v4l2_control *ctl)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       return cx25821_set_control(dev, ctl, SRAM_CH00);
-}
-
-// exported stuff
-static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = video_ioctl2,
-};
-
-static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
-#endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-       .vidiocgmbuf = cx25821_vidiocgmbuf,
-#endif
-#ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
-#endif
-};
-
-struct video_device cx25821_video_template0 = {
-       .name = "cx25821-video",
-       .fops = &video_fops,
-       .ioctl_ops = &video_ioctl_ops,
-       .tvnorms = CX25821_NORMS,
-       .current_norm = V4L2_STD_NTSC_M,
-};
diff --git a/drivers/staging/cx25821/cx25821-video1.c b/drivers/staging/cx25821/cx25821-video1.c
deleted file mode 100644
index b0bae62..0000000
--- a/drivers/staging/cx25821/cx25821-video1.c
+++ /dev/null
@@ -1,434 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "cx25821-video.h"
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-       struct cx25821_buffer *buf =
-           container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH01];
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-       if (!list_empty(&q->queued)) {
-               list_add_tail(&buf->vb.queue, &q->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-                       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-               list_add_tail(&buf->vb.queue, &q->active);
-               cx25821_start_video_dma(dev, q, buf,
-                                       &dev->sram_channels[SRAM_CH01]);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               buf->count = q->count++;
-               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-               dprintk(2,
-                       "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-                       buf, buf->vb.i, buf->count, q->count);
-       } else {
-               prev =
-                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-               if (prev->vb.width == buf->vb.width
-                   && prev->vb.height == buf->vb.height
-                   && prev->fmt == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &q->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       buf->count = q->count++;
-                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-                       /* 64 bit bits 63-32 */
-                       prev->risc.jmp[2] = cpu_to_le32(0);
-                       dprintk(2,
-                               "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-                               buf, buf->vb.i, buf->count);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &q->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-                               buf->vb.i);
-               }
-       }
-
-       if (list_empty(&q->active)) {
-               dprintk(2, "active queue empty!\n");
-       }
-}
-
-static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
-};
-
-static int video_open(struct file *file)
-{
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-       u32 pix_format;
-
-       printk("open dev=%s type=%s\n", video_device_node_name(vdev),
-               v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-               return -ENOMEM;
-
-       lock_kernel();
-
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-               fh->height = 576;
-       else
-               fh->height = 480;
-
-       dev->channel_opened = SRAM_CH01;
-       pix_format =
-           (dev->pixel_formats[dev->channel_opened] ==
-            PIXEL_FRMT_411) ? V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
-       fh->fmt = format_by_fourcc(pix_format);
-
-       v4l2_prio_open(&dev->prio, &fh->prio);
-
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-                              &dev->pci->dev, &dev->slock,
-                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
-                              V4L2_FIELD_INTERLACED,
-                              sizeof(struct cx25821_buffer), fh);
-
-       dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
-
-       return 0;
-}
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-                         loff_t * ppos)
-{
-       struct cx25821_fh *fh = file->private_data;
-
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-               if (cx25821_res_locked(fh->dev, RESOURCE_VIDEO1))
-                       return -EBUSY;
-
-               return videobuf_read_one(&fh->vidq, data, count, ppos,
-                                        file->f_flags & O_NONBLOCK);
-
-       default:
-               BUG();
-               return 0;
-       }
-}
-
-static unsigned int video_poll(struct file *file,
-                              struct poll_table_struct *wait)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
-
-       if (cx25821_res_check(fh, RESOURCE_VIDEO1)) {
-               /* streaming capture */
-               if (list_empty(&fh->vidq.stream))
-                       return POLLERR;
-               buf = list_entry(fh->vidq.stream.next,
-                                struct cx25821_buffer, vb.stream);
-       } else {
-               /* read() capture */
-               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-               if (NULL == buf)
-                       return POLLERR;
-       }
-
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR) {
-               if (buf->vb.state == VIDEOBUF_DONE) {
-                       struct cx25821_dev *dev = fh->dev;
-
-                       if (dev && dev->use_cif_resolution[SRAM_CH01]) {
-                               u8 cam_id = *((char *)buf->vb.baddr + 3);
-                               memcpy((char *)buf->vb.baddr,
-                                      (char *)buf->vb.baddr + (fh->width * 2),
-                                      (fh->width * 2));
-                               *((char *)buf->vb.baddr + 3) = cam_id;
-                       }
-               }
-
-               return POLLIN | POLLRDNORM;
-       }
-
-       return 0;
-}
-
-static int video_release(struct file *file)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-
-       //stop the risc engine and fifo
-       cx_write(channel1->dma_ctl, 0); /* FIFO and RISC disable */
-
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO1)) {
-               videobuf_queue_cancel(&fh->vidq);
-               cx25821_res_free(dev, fh, RESOURCE_VIDEO1);
-       }
-
-       if (fh->vidq.read_buf) {
-               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-               kfree(fh->vidq.read_buf);
-       }
-
-       videobuf_mmap_free(&fh->vidq);
-
-       v4l2_prio_close(&dev->prio, fh->prio);
-       file->private_data = NULL;
-       kfree(fh);
-
-       return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(i != fh->type)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO1)))) {
-               return -EBUSY;
-       }
-
-       return videobuf_streamon(get_queue(fh));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
-
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               return -EINVAL;
-       if (i != fh->type)
-               return -EINVAL;
-
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO1);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-               return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-                               struct v4l2_format *f)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-       int pix_format = 0;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
-
-       if (0 != err)
-               return err;
-
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->vidq.field = f->fmt.pix.field;
-
-       // check if width and height is valid based on set standard
-       if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm)) {
-               fh->width = f->fmt.pix.width;
-       }
-
-       if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm)) {
-               fh->height = f->fmt.pix.height;
-       }
-
-       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
-               pix_format = PIXEL_FRMT_411;
-       else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
-               pix_format = PIXEL_FRMT_422;
-       else
-               return -EINVAL;
-
-       cx25821_set_pixel_format(dev, SRAM_CH01, pix_format);
-
-       // check if cif resolution
-       if (fh->width == 320 || fh->width == 352) {
-               dev->use_cif_resolution[SRAM_CH01] = 1;
-       } else {
-               dev->use_cif_resolution[SRAM_CH01] = 0;
-       }
-       dev->cif_width[SRAM_CH01] = fh->width;
-       medusa_set_resolution(dev, fh->width, SRAM_CH01);
-
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-               fh->height, fh->vidq.field);
-       cx25821_call_all(dev, video, s_fmt, f);
-
-       return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-       int ret_val = 0;
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-
-       ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-
-       p->sequence = dev->vidq[SRAM_CH01].count;
-
-       return ret_val;
-}
-
-static int vidioc_log_status(struct file *file, void *priv)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       char name[32 + 2];
-
-       struct sram_channel *sram_ch = &dev->sram_channels[SRAM_CH01];
-       u32 tmp = 0;
-
-       snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-              dev->name);
-       cx25821_call_all(dev, core, log_status);
-       tmp = cx_read(sram_ch->dma_ctl);
-       printk(KERN_INFO "Video input 1 is %s\n",
-              (tmp & 0x11) ? "streaming" : "stopped");
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-              dev->name);
-       return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-                        struct v4l2_control *ctl)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       return cx25821_set_control(dev, ctl, SRAM_CH01);
-}
-
-//exported stuff
-static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = video_ioctl2,
-};
-
-static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
-#endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-       .vidiocgmbuf = cx25821_vidiocgmbuf,
-#endif
-#ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
-#endif
-};
-
-struct video_device cx25821_video_template1 = {
-       .name = "cx25821-video",
-       .fops = &video_fops,
-       .ioctl_ops = &video_ioctl_ops,
-       .tvnorms = CX25821_NORMS,
-       .current_norm = V4L2_STD_NTSC_M,
-};
diff --git a/drivers/staging/cx25821/cx25821-video2.c b/drivers/staging/cx25821/cx25821-video2.c
deleted file mode 100644
index 400cdb8..0000000
--- a/drivers/staging/cx25821/cx25821-video2.c
+++ /dev/null
@@ -1,436 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "cx25821-video.h"
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-       struct cx25821_buffer *buf =
-           container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH02];
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-       if (!list_empty(&q->queued)) {
-               list_add_tail(&buf->vb.queue, &q->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-                       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-               list_add_tail(&buf->vb.queue, &q->active);
-               cx25821_start_video_dma(dev, q, buf,
-                                       &dev->sram_channels[SRAM_CH02]);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               buf->count = q->count++;
-               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-               dprintk(2,
-                       "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-                       buf, buf->vb.i, buf->count, q->count);
-       } else {
-               prev =
-                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-               if (prev->vb.width == buf->vb.width
-                   && prev->vb.height == buf->vb.height
-                   && prev->fmt == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &q->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       buf->count = q->count++;
-                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-                       /* 64 bit bits 63-32 */
-                       prev->risc.jmp[2] = cpu_to_le32(0);
-                       dprintk(2,
-                               "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-                               buf, buf->vb.i, buf->count);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &q->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-                               buf->vb.i);
-               }
-       }
-
-       if (list_empty(&q->active)) {
-               dprintk(2, "active queue empty!\n");
-       }
-}
-
-static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
-};
-
-static int video_open(struct file *file)
-{
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-       u32 pix_format;
-
-       printk("open dev=%s type=%s\n", video_device_node_name(vdev),
-               v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-               return -ENOMEM;
-
-       lock_kernel();
-
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-               fh->height = 576;
-       else
-               fh->height = 480;
-
-       dev->channel_opened = SRAM_CH02;
-       pix_format =
-           (dev->pixel_formats[dev->channel_opened] ==
-            PIXEL_FRMT_411) ? V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
-       fh->fmt = format_by_fourcc(pix_format);
-
-       v4l2_prio_open(&dev->prio, &fh->prio);
-
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-                              &dev->pci->dev, &dev->slock,
-                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
-                              V4L2_FIELD_INTERLACED,
-                              sizeof(struct cx25821_buffer), fh);
-
-       dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
-
-       return 0;
-}
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-                         loff_t * ppos)
-{
-       struct cx25821_fh *fh = file->private_data;
-
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-               if (cx25821_res_locked(fh->dev, RESOURCE_VIDEO2))
-                       return -EBUSY;
-
-               return videobuf_read_one(&fh->vidq, data, count, ppos,
-                                        file->f_flags & O_NONBLOCK);
-
-       default:
-               BUG();
-               return 0;
-       }
-}
-
-static unsigned int video_poll(struct file *file,
-                              struct poll_table_struct *wait)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
-
-       if (cx25821_res_check(fh, RESOURCE_VIDEO2)) {
-               /* streaming capture */
-               if (list_empty(&fh->vidq.stream))
-                       return POLLERR;
-               buf = list_entry(fh->vidq.stream.next,
-                                struct cx25821_buffer, vb.stream);
-       } else {
-               /* read() capture */
-               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-               if (NULL == buf)
-                       return POLLERR;
-       }
-
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR) {
-               if (buf->vb.state == VIDEOBUF_DONE) {
-                       struct cx25821_dev *dev = fh->dev;
-
-                       if (dev && dev->use_cif_resolution[SRAM_CH02]) {
-                               u8 cam_id = *((char *)buf->vb.baddr + 3);
-                               memcpy((char *)buf->vb.baddr,
-                                      (char *)buf->vb.baddr + (fh->width * 2),
-                                      (fh->width * 2));
-                               *((char *)buf->vb.baddr + 3) = cam_id;
-                       }
-               }
-
-               return POLLIN | POLLRDNORM;
-       }
-
-       return 0;
-}
-
-static int video_release(struct file *file)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-
-       //stop the risc engine and fifo
-       cx_write(channel2->dma_ctl, 0); /* FIFO and RISC disable */
-
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO2)) {
-               videobuf_queue_cancel(&fh->vidq);
-               cx25821_res_free(dev, fh, RESOURCE_VIDEO2);
-       }
-
-       if (fh->vidq.read_buf) {
-               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-               kfree(fh->vidq.read_buf);
-       }
-
-       videobuf_mmap_free(&fh->vidq);
-
-       v4l2_prio_close(&dev->prio, fh->prio);
-       file->private_data = NULL;
-       kfree(fh);
-
-       return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(i != fh->type)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO2)))) {
-               return -EBUSY;
-       }
-
-       return videobuf_streamon(get_queue(fh));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
-
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               return -EINVAL;
-       if (i != fh->type)
-               return -EINVAL;
-
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO2);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-               return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-                               struct v4l2_format *f)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-       int pix_format = 0;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
-
-       if (0 != err)
-               return err;
-
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->vidq.field = f->fmt.pix.field;
-
-       // check if width and height is valid based on set standard
-       if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm)) {
-               fh->width = f->fmt.pix.width;
-       }
-
-       if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm)) {
-               fh->height = f->fmt.pix.height;
-       }
-
-       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
-               pix_format = PIXEL_FRMT_411;
-       else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
-               pix_format = PIXEL_FRMT_422;
-       else
-               return -EINVAL;
-
-       cx25821_set_pixel_format(dev, SRAM_CH02, pix_format);
-
-       // check if cif resolution
-       if (fh->width == 320 || fh->width == 352) {
-               dev->use_cif_resolution[SRAM_CH02] = 1;
-       } else {
-               dev->use_cif_resolution[SRAM_CH02] = 0;
-       }
-       dev->cif_width[SRAM_CH02] = fh->width;
-       medusa_set_resolution(dev, fh->width, SRAM_CH02);
-
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-               fh->height, fh->vidq.field);
-       cx25821_call_all(dev, video, s_fmt, f);
-
-       return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-       int ret_val = 0;
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-
-       ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-
-       p->sequence = dev->vidq[SRAM_CH02].count;
-
-       return ret_val;
-}
-
-static int vidioc_log_status(struct file *file, void *priv)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       char name[32 + 2];
-
-       struct sram_channel *sram_ch = &dev->sram_channels[SRAM_CH02];
-       u32 tmp = 0;
-
-       snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-              dev->name);
-
-       cx25821_call_all(dev, core, log_status);
-
-       tmp = cx_read(sram_ch->dma_ctl);
-       printk(KERN_INFO "Video input 2 is %s\n",
-              (tmp & 0x11) ? "streaming" : "stopped");
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-              dev->name);
-       return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-                        struct v4l2_control *ctl)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       return cx25821_set_control(dev, ctl, SRAM_CH02);
-}
-
-// exported stuff
-static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = video_ioctl2,
-};
-
-static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
-#endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-       .vidiocgmbuf = cx25821_vidiocgmbuf,
-#endif
-#ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
-#endif
-};
-
-struct video_device cx25821_video_template2 = {
-       .name = "cx25821-video",
-       .fops = &video_fops,
-       .ioctl_ops = &video_ioctl_ops,
-       .tvnorms = CX25821_NORMS,
-       .current_norm = V4L2_STD_NTSC_M,
-};
diff --git a/drivers/staging/cx25821/cx25821-video3.c b/drivers/staging/cx25821/cx25821-video3.c
deleted file mode 100644
index 3b216ed..0000000
--- a/drivers/staging/cx25821/cx25821-video3.c
+++ /dev/null
@@ -1,435 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "cx25821-video.h"
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-       struct cx25821_buffer *buf =
-           container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH03];
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-       if (!list_empty(&q->queued)) {
-               list_add_tail(&buf->vb.queue, &q->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-                       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-               list_add_tail(&buf->vb.queue, &q->active);
-               cx25821_start_video_dma(dev, q, buf,
-                                       &dev->sram_channels[SRAM_CH03]);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               buf->count = q->count++;
-               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-               dprintk(2,
-                       "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-                       buf, buf->vb.i, buf->count, q->count);
-       } else {
-               prev =
-                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-               if (prev->vb.width == buf->vb.width
-                   && prev->vb.height == buf->vb.height
-                   && prev->fmt == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &q->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       buf->count = q->count++;
-                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-                       /* 64 bit bits 63-32 */
-                       prev->risc.jmp[2] = cpu_to_le32(0);
-                       dprintk(2,
-                               "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-                               buf, buf->vb.i, buf->count);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &q->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-                               buf->vb.i);
-               }
-       }
-
-       if (list_empty(&q->active)) {
-               dprintk(2, "active queue empty!\n");
-       }
-}
-
-static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
-};
-
-static int video_open(struct file *file)
-{
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-       u32 pix_format;
-
-       printk("open dev=%s type=%s\n", video_device_node_name(vdev),
-               v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-               return -ENOMEM;
-
-       lock_kernel();
-
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-               fh->height = 576;
-       else
-               fh->height = 480;
-
-       dev->channel_opened = SRAM_CH03;
-       pix_format =
-           (dev->pixel_formats[dev->channel_opened] ==
-            PIXEL_FRMT_411) ? V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
-       fh->fmt = format_by_fourcc(pix_format);
-
-       v4l2_prio_open(&dev->prio, &fh->prio);
-
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-                              &dev->pci->dev, &dev->slock,
-                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
-                              V4L2_FIELD_INTERLACED,
-                              sizeof(struct cx25821_buffer), fh);
-
-       dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
-
-       return 0;
-}
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-                         loff_t * ppos)
-{
-       struct cx25821_fh *fh = file->private_data;
-
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-               if (cx25821_res_locked(fh->dev, RESOURCE_VIDEO3))
-                       return -EBUSY;
-
-               return videobuf_read_one(&fh->vidq, data, count, ppos,
-                                        file->f_flags & O_NONBLOCK);
-
-       default:
-               BUG();
-               return 0;
-       }
-}
-
-static unsigned int video_poll(struct file *file,
-                              struct poll_table_struct *wait)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
-
-       if (cx25821_res_check(fh, RESOURCE_VIDEO3)) {
-               /* streaming capture */
-               if (list_empty(&fh->vidq.stream))
-                       return POLLERR;
-               buf = list_entry(fh->vidq.stream.next,
-                                struct cx25821_buffer, vb.stream);
-       } else {
-               /* read() capture */
-               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-               if (NULL == buf)
-                       return POLLERR;
-       }
-
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR) {
-               if (buf->vb.state == VIDEOBUF_DONE) {
-                       struct cx25821_dev *dev = fh->dev;
-
-                       if (dev && dev->use_cif_resolution[SRAM_CH03]) {
-                               u8 cam_id = *((char *)buf->vb.baddr + 3);
-                               memcpy((char *)buf->vb.baddr,
-                                      (char *)buf->vb.baddr + (fh->width * 2),
-                                      (fh->width * 2));
-                               *((char *)buf->vb.baddr + 3) = cam_id;
-                       }
-               }
-
-               return POLLIN | POLLRDNORM;
-       }
-
-       return 0;
-}
-
-static int video_release(struct file *file)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-
-       //stop the risc engine and fifo
-       cx_write(channel3->dma_ctl, 0); /* FIFO and RISC disable */
-
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO3)) {
-               videobuf_queue_cancel(&fh->vidq);
-               cx25821_res_free(dev, fh, RESOURCE_VIDEO3);
-       }
-
-       if (fh->vidq.read_buf) {
-               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-               kfree(fh->vidq.read_buf);
-       }
-
-       videobuf_mmap_free(&fh->vidq);
-
-       v4l2_prio_close(&dev->prio, fh->prio);
-       file->private_data = NULL;
-       kfree(fh);
-
-       return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(i != fh->type)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO3)))) {
-               return -EBUSY;
-       }
-
-       return videobuf_streamon(get_queue(fh));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
-
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               return -EINVAL;
-       if (i != fh->type)
-               return -EINVAL;
-
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO3);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-               return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-                               struct v4l2_format *f)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-       int pix_format = 0;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
-
-       if (0 != err)
-               return err;
-
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->vidq.field = f->fmt.pix.field;
-
-       // check if width and height is valid based on set standard
-       if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm)) {
-               fh->width = f->fmt.pix.width;
-       }
-
-       if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm)) {
-               fh->height = f->fmt.pix.height;
-       }
-
-       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
-               pix_format = PIXEL_FRMT_411;
-       else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
-               pix_format = PIXEL_FRMT_422;
-       else
-               return -EINVAL;
-
-       cx25821_set_pixel_format(dev, SRAM_CH03, pix_format);
-
-       // check if cif resolution
-       if (fh->width == 320 || fh->width == 352) {
-               dev->use_cif_resolution[SRAM_CH03] = 1;
-       } else {
-               dev->use_cif_resolution[SRAM_CH03] = 0;
-       }
-       dev->cif_width[SRAM_CH03] = fh->width;
-       medusa_set_resolution(dev, fh->width, SRAM_CH03);
-
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-               fh->height, fh->vidq.field);
-       cx25821_call_all(dev, video, s_fmt, f);
-
-       return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-       int ret_val = 0;
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-
-       ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-
-       p->sequence = dev->vidq[SRAM_CH03].count;
-
-       return ret_val;
-}
-
-static int vidioc_log_status(struct file *file, void *priv)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       char name[32 + 2];
-
-       struct sram_channel *sram_ch = &dev->sram_channels[SRAM_CH03];
-       u32 tmp = 0;
-
-       snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-              dev->name);
-       cx25821_call_all(dev, core, log_status);
-
-       tmp = cx_read(sram_ch->dma_ctl);
-       printk(KERN_INFO "Video input 3 is %s\n",
-              (tmp & 0x11) ? "streaming" : "stopped");
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-              dev->name);
-       return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-                        struct v4l2_control *ctl)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       return cx25821_set_control(dev, ctl, SRAM_CH03);
-}
-
-// exported stuff
-static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = video_ioctl2,
-};
-
-static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
-#endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-       .vidiocgmbuf = cx25821_vidiocgmbuf,
-#endif
-#ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
-#endif
-};
-
-struct video_device cx25821_video_template3 = {
-       .name = "cx25821-video",
-       .fops = &video_fops,
-       .ioctl_ops = &video_ioctl_ops,
-       .tvnorms = CX25821_NORMS,
-       .current_norm = V4L2_STD_NTSC_M,
-};
diff --git a/drivers/staging/cx25821/cx25821-video4.c b/drivers/staging/cx25821/cx25821-video4.c
deleted file mode 100644
index f7b08c5..0000000
--- a/drivers/staging/cx25821/cx25821-video4.c
+++ /dev/null
@@ -1,434 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "cx25821-video.h"
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-       struct cx25821_buffer *buf =
-           container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH04];
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-       if (!list_empty(&q->queued)) {
-               list_add_tail(&buf->vb.queue, &q->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-                       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-               list_add_tail(&buf->vb.queue, &q->active);
-               cx25821_start_video_dma(dev, q, buf,
-                                       &dev->sram_channels[SRAM_CH04]);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               buf->count = q->count++;
-               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-               dprintk(2,
-                       "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-                       buf, buf->vb.i, buf->count, q->count);
-       } else {
-               prev =
-                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-               if (prev->vb.width == buf->vb.width
-                   && prev->vb.height == buf->vb.height
-                   && prev->fmt == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &q->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       buf->count = q->count++;
-                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-                       /* 64 bit bits 63-32 */
-                       prev->risc.jmp[2] = cpu_to_le32(0);
-                       dprintk(2,
-                               "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-                               buf, buf->vb.i, buf->count);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &q->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-                               buf->vb.i);
-               }
-       }
-
-       if (list_empty(&q->active)) {
-               dprintk(2, "active queue empty!\n");
-       }
-}
-
-static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
-};
-
-static int video_open(struct file *file)
-{
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-       u32 pix_format;
-
-       printk("open dev=%s type=%s\n", video_device_node_name(vdev),
-               v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-               return -ENOMEM;
-
-       lock_kernel();
-
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-               fh->height = 576;
-       else
-               fh->height = 480;
-
-       dev->channel_opened = SRAM_CH04;
-       pix_format =
-           (dev->pixel_formats[dev->channel_opened] ==
-            PIXEL_FRMT_411) ? V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
-       fh->fmt = format_by_fourcc(pix_format);
-
-       v4l2_prio_open(&dev->prio, &fh->prio);
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-                              &dev->pci->dev, &dev->slock,
-                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
-                              V4L2_FIELD_INTERLACED,
-                              sizeof(struct cx25821_buffer), fh);
-
-       dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
-
-       return 0;
-}
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-                         loff_t * ppos)
-{
-       struct cx25821_fh *fh = file->private_data;
-
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-               if (cx25821_res_locked(fh->dev, RESOURCE_VIDEO4))
-                       return -EBUSY;
-
-               return videobuf_read_one(&fh->vidq, data, count, ppos,
-                                        file->f_flags & O_NONBLOCK);
-
-       default:
-               BUG();
-               return 0;
-       }
-}
-
-static unsigned int video_poll(struct file *file,
-                              struct poll_table_struct *wait)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
-
-       if (cx25821_res_check(fh, RESOURCE_VIDEO4)) {
-               /* streaming capture */
-               if (list_empty(&fh->vidq.stream))
-                       return POLLERR;
-               buf = list_entry(fh->vidq.stream.next,
-                                struct cx25821_buffer, vb.stream);
-       } else {
-               /* read() capture */
-               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-               if (NULL == buf)
-                       return POLLERR;
-       }
-
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR) {
-               if (buf->vb.state == VIDEOBUF_DONE) {
-                       struct cx25821_dev *dev = fh->dev;
-
-                       if (dev && dev->use_cif_resolution[SRAM_CH04]) {
-                               u8 cam_id = *((char *)buf->vb.baddr + 3);
-                               memcpy((char *)buf->vb.baddr,
-                                      (char *)buf->vb.baddr + (fh->width * 2),
-                                      (fh->width * 2));
-                               *((char *)buf->vb.baddr + 3) = cam_id;
-                       }
-               }
-
-               return POLLIN | POLLRDNORM;
-       }
-
-       return 0;
-}
-
-static int video_release(struct file *file)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-
-       //stop the risc engine and fifo
-       cx_write(channel4->dma_ctl, 0); /* FIFO and RISC disable */
-
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO4)) {
-               videobuf_queue_cancel(&fh->vidq);
-               cx25821_res_free(dev, fh, RESOURCE_VIDEO4);
-       }
-
-       if (fh->vidq.read_buf) {
-               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-               kfree(fh->vidq.read_buf);
-       }
-
-       videobuf_mmap_free(&fh->vidq);
-
-       v4l2_prio_close(&dev->prio, fh->prio);
-       file->private_data = NULL;
-       kfree(fh);
-
-       return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(i != fh->type)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO4)))) {
-               return -EBUSY;
-       }
-
-       return videobuf_streamon(get_queue(fh));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
-
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               return -EINVAL;
-       if (i != fh->type)
-               return -EINVAL;
-
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO4);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-               return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-                               struct v4l2_format *f)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-       int pix_format = 0;
-
-       // check priority
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
-
-       if (0 != err)
-               return err;
-
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->vidq.field = f->fmt.pix.field;
-
-       // check if width and height is valid based on set standard
-       if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm)) {
-               fh->width = f->fmt.pix.width;
-       }
-
-       if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm)) {
-               fh->height = f->fmt.pix.height;
-       }
-
-       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
-               pix_format = PIXEL_FRMT_411;
-       else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
-               pix_format = PIXEL_FRMT_422;
-       else
-               return -EINVAL;
-
-       cx25821_set_pixel_format(dev, SRAM_CH04, pix_format);
-
-       // check if cif resolution
-       if (fh->width == 320 || fh->width == 352) {
-               dev->use_cif_resolution[SRAM_CH04] = 1;
-       } else {
-               dev->use_cif_resolution[SRAM_CH04] = 0;
-       }
-       dev->cif_width[SRAM_CH04] = fh->width;
-       medusa_set_resolution(dev, fh->width, SRAM_CH04);
-
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-               fh->height, fh->vidq.field);
-       cx25821_call_all(dev, video, s_fmt, f);
-
-       return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-       int ret_val = 0;
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-
-       ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-
-       p->sequence = dev->vidq[SRAM_CH04].count;
-
-       return ret_val;
-}
-
-static int vidioc_log_status(struct file *file, void *priv)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       char name[32 + 2];
-
-       struct sram_channel *sram_ch = &dev->sram_channels[SRAM_CH04];
-       u32 tmp = 0;
-
-       snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-              dev->name);
-       cx25821_call_all(dev, core, log_status);
-
-       tmp = cx_read(sram_ch->dma_ctl);
-       printk(KERN_INFO "Video input 4 is %s\n",
-              (tmp & 0x11) ? "streaming" : "stopped");
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-              dev->name);
-       return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-                        struct v4l2_control *ctl)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       return cx25821_set_control(dev, ctl, SRAM_CH04);
-}
-
-// exported stuff
-static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = video_ioctl2,
-};
-
-static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
-#endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-       .vidiocgmbuf = cx25821_vidiocgmbuf,
-#endif
-#ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
-#endif
-};
-
-struct video_device cx25821_video_template4 = {
-       .name = "cx25821-video",
-       .fops = &video_fops,
-       .ioctl_ops = &video_ioctl_ops,
-       .tvnorms = CX25821_NORMS,
-       .current_norm = V4L2_STD_NTSC_M,
-};
diff --git a/drivers/staging/cx25821/cx25821-video5.c b/drivers/staging/cx25821/cx25821-video5.c
deleted file mode 100644
index 5937033..0000000
--- a/drivers/staging/cx25821/cx25821-video5.c
+++ /dev/null
@@ -1,434 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "cx25821-video.h"
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-       struct cx25821_buffer *buf =
-           container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH05];
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-       if (!list_empty(&q->queued)) {
-               list_add_tail(&buf->vb.queue, &q->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-                       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-               list_add_tail(&buf->vb.queue, &q->active);
-               cx25821_start_video_dma(dev, q, buf,
-                                       &dev->sram_channels[SRAM_CH05]);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               buf->count = q->count++;
-               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-               dprintk(2,
-                       "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-                       buf, buf->vb.i, buf->count, q->count);
-       } else {
-               prev =
-                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-               if (prev->vb.width == buf->vb.width
-                   && prev->vb.height == buf->vb.height
-                   && prev->fmt == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &q->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       buf->count = q->count++;
-                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-                       /* 64 bit bits 63-32 */
-                       prev->risc.jmp[2] = cpu_to_le32(0);
-                       dprintk(2,
-                               "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-                               buf, buf->vb.i, buf->count);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &q->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-                               buf->vb.i);
-               }
-       }
-
-       if (list_empty(&q->active)) {
-               dprintk(2, "active queue empty!\n");
-       }
-}
-
-static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
-};
-
-static int video_open(struct file *file)
-{
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-       u32 pix_format;
-
-       printk("open dev=%s type=%s\n", video_device_node_name(vdev),
-               v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-               return -ENOMEM;
-
-       lock_kernel();
-
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-               fh->height = 576;
-       else
-               fh->height = 480;
-
-       dev->channel_opened = SRAM_CH05;
-       pix_format =
-           (dev->pixel_formats[dev->channel_opened] ==
-            PIXEL_FRMT_411) ? V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
-       fh->fmt = format_by_fourcc(pix_format);
-
-       v4l2_prio_open(&dev->prio, &fh->prio);
-
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-                              &dev->pci->dev, &dev->slock,
-                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
-                              V4L2_FIELD_INTERLACED,
-                              sizeof(struct cx25821_buffer), fh);
-
-       dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
-
-       return 0;
-}
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-                         loff_t * ppos)
-{
-       struct cx25821_fh *fh = file->private_data;
-
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-               if (cx25821_res_locked(fh->dev, RESOURCE_VIDEO5))
-                       return -EBUSY;
-
-               return videobuf_read_one(&fh->vidq, data, count, ppos,
-                                        file->f_flags & O_NONBLOCK);
-
-       default:
-               BUG();
-               return 0;
-       }
-}
-
-static unsigned int video_poll(struct file *file,
-                              struct poll_table_struct *wait)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
-
-       if (cx25821_res_check(fh, RESOURCE_VIDEO5)) {
-               /* streaming capture */
-               if (list_empty(&fh->vidq.stream))
-                       return POLLERR;
-               buf = list_entry(fh->vidq.stream.next,
-                                struct cx25821_buffer, vb.stream);
-       } else {
-               /* read() capture */
-               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-               if (NULL == buf)
-                       return POLLERR;
-       }
-
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR) {
-               if (buf->vb.state == VIDEOBUF_DONE) {
-                       struct cx25821_dev *dev = fh->dev;
-
-                       if (dev && dev->use_cif_resolution[SRAM_CH05]) {
-                               u8 cam_id = *((char *)buf->vb.baddr + 3);
-                               memcpy((char *)buf->vb.baddr,
-                                      (char *)buf->vb.baddr + (fh->width * 2),
-                                      (fh->width * 2));
-                               *((char *)buf->vb.baddr + 3) = cam_id;
-                       }
-               }
-
-               return POLLIN | POLLRDNORM;
-       }
-
-       return 0;
-}
-
-static int video_release(struct file *file)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-
-       //stop the risc engine and fifo
-       cx_write(channel5->dma_ctl, 0); /* FIFO and RISC disable */
-
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO5)) {
-               videobuf_queue_cancel(&fh->vidq);
-               cx25821_res_free(dev, fh, RESOURCE_VIDEO5);
-       }
-
-       if (fh->vidq.read_buf) {
-               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-               kfree(fh->vidq.read_buf);
-       }
-
-       videobuf_mmap_free(&fh->vidq);
-
-       v4l2_prio_close(&dev->prio, fh->prio);
-       file->private_data = NULL;
-       kfree(fh);
-
-       return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(i != fh->type)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO5)))) {
-               return -EBUSY;
-       }
-
-       return videobuf_streamon(get_queue(fh));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
-
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               return -EINVAL;
-       if (i != fh->type)
-               return -EINVAL;
-
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO5);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-               return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-                               struct v4l2_format *f)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-       int pix_format = 0;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
-
-       if (0 != err)
-               return err;
-
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->vidq.field = f->fmt.pix.field;
-
-       // check if width and height is valid based on set standard
-       if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm)) {
-               fh->width = f->fmt.pix.width;
-       }
-
-       if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm)) {
-               fh->height = f->fmt.pix.height;
-       }
-
-       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
-               pix_format = PIXEL_FRMT_411;
-       else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
-               pix_format = PIXEL_FRMT_422;
-       else
-               return -EINVAL;
-
-       cx25821_set_pixel_format(dev, SRAM_CH05, pix_format);
-
-       // check if cif resolution
-       if (fh->width == 320 || fh->width == 352) {
-               dev->use_cif_resolution[SRAM_CH05] = 1;
-       } else {
-               dev->use_cif_resolution[SRAM_CH05] = 0;
-       }
-       dev->cif_width[SRAM_CH05] = fh->width;
-       medusa_set_resolution(dev, fh->width, SRAM_CH05);
-
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-               fh->height, fh->vidq.field);
-       cx25821_call_all(dev, video, s_fmt, f);
-
-       return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-       int ret_val = 0;
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-
-       ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-
-       p->sequence = dev->vidq[SRAM_CH05].count;
-
-       return ret_val;
-}
-static int vidioc_log_status(struct file *file, void *priv)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       char name[32 + 2];
-
-       struct sram_channel *sram_ch = &dev->sram_channels[SRAM_CH05];
-       u32 tmp = 0;
-
-       snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-              dev->name);
-       cx25821_call_all(dev, core, log_status);
-
-       tmp = cx_read(sram_ch->dma_ctl);
-       printk(KERN_INFO "Video input 5 is %s\n",
-              (tmp & 0x11) ? "streaming" : "stopped");
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-              dev->name);
-       return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-                        struct v4l2_control *ctl)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       return cx25821_set_control(dev, ctl, SRAM_CH05);
-}
-
-// exported stuff
-static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = video_ioctl2,
-};
-
-static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
-#endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-       .vidiocgmbuf = cx25821_vidiocgmbuf,
-#endif
-#ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
-#endif
-};
-
-struct video_device cx25821_video_template5 = {
-       .name = "cx25821-video",
-       .fops = &video_fops,
-       .ioctl_ops = &video_ioctl_ops,
-       .tvnorms = CX25821_NORMS,
-       .current_norm = V4L2_STD_NTSC_M,
-};
diff --git a/drivers/staging/cx25821/cx25821-video6.c b/drivers/staging/cx25821/cx25821-video6.c
deleted file mode 100644
index 4db2eb8..0000000
--- a/drivers/staging/cx25821/cx25821-video6.c
+++ /dev/null
@@ -1,434 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "cx25821-video.h"
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-       struct cx25821_buffer *buf =
-           container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH06];
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-       if (!list_empty(&q->queued)) {
-               list_add_tail(&buf->vb.queue, &q->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-                       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-               list_add_tail(&buf->vb.queue, &q->active);
-               cx25821_start_video_dma(dev, q, buf,
-                                       &dev->sram_channels[SRAM_CH06]);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               buf->count = q->count++;
-               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-               dprintk(2,
-                       "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-                       buf, buf->vb.i, buf->count, q->count);
-       } else {
-               prev =
-                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-               if (prev->vb.width == buf->vb.width
-                   && prev->vb.height == buf->vb.height
-                   && prev->fmt == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &q->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       buf->count = q->count++;
-                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-                       /* 64 bit bits 63-32 */
-                       prev->risc.jmp[2] = cpu_to_le32(0);
-                       dprintk(2,
-                               "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-                               buf, buf->vb.i, buf->count);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &q->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-                               buf->vb.i);
-               }
-       }
-
-       if (list_empty(&q->active)) {
-               dprintk(2, "active queue empty!\n");
-       }
-}
-
-static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
-};
-
-static int video_open(struct file *file)
-{
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-       u32 pix_format;
-
-       printk("open dev=%s type=%s\n", video_device_node_name(vdev),
-               v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-               return -ENOMEM;
-
-       lock_kernel();
-
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-               fh->height = 576;
-       else
-               fh->height = 480;
-
-       dev->channel_opened = SRAM_CH06;
-       pix_format =
-           (dev->pixel_formats[dev->channel_opened] ==
-            PIXEL_FRMT_411) ? V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
-       fh->fmt = format_by_fourcc(pix_format);
-
-       v4l2_prio_open(&dev->prio, &fh->prio);
-
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-                              &dev->pci->dev, &dev->slock,
-                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
-                              V4L2_FIELD_INTERLACED,
-                              sizeof(struct cx25821_buffer), fh);
-
-       dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
-
-       return 0;
-}
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-                         loff_t * ppos)
-{
-       struct cx25821_fh *fh = file->private_data;
-
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-               if (cx25821_res_locked(fh->dev, RESOURCE_VIDEO6))
-                       return -EBUSY;
-
-               return videobuf_read_one(&fh->vidq, data, count, ppos,
-                                        file->f_flags & O_NONBLOCK);
-
-       default:
-               BUG();
-               return 0;
-       }
-}
-
-static unsigned int video_poll(struct file *file,
-                              struct poll_table_struct *wait)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
-
-       if (cx25821_res_check(fh, RESOURCE_VIDEO6)) {
-               /* streaming capture */
-               if (list_empty(&fh->vidq.stream))
-                       return POLLERR;
-               buf = list_entry(fh->vidq.stream.next,
-                                struct cx25821_buffer, vb.stream);
-       } else {
-               /* read() capture */
-               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-               if (NULL == buf)
-                       return POLLERR;
-       }
-
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR) {
-               if (buf->vb.state == VIDEOBUF_DONE) {
-                       struct cx25821_dev *dev = fh->dev;
-
-                       if (dev && dev->use_cif_resolution[SRAM_CH06]) {
-                               u8 cam_id = *((char *)buf->vb.baddr + 3);
-                               memcpy((char *)buf->vb.baddr,
-                                      (char *)buf->vb.baddr + (fh->width * 2),
-                                      (fh->width * 2));
-                               *((char *)buf->vb.baddr + 3) = cam_id;
-                       }
-               }
-
-               return POLLIN | POLLRDNORM;
-       }
-
-       return 0;
-}
-
-static int video_release(struct file *file)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-
-       //stop the risc engine and fifo
-       cx_write(channel6->dma_ctl, 0); /* FIFO and RISC disable */
-
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO6)) {
-               videobuf_queue_cancel(&fh->vidq);
-               cx25821_res_free(dev, fh, RESOURCE_VIDEO6);
-       }
-       if (fh->vidq.read_buf) {
-               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-               kfree(fh->vidq.read_buf);
-       }
-
-       videobuf_mmap_free(&fh->vidq);
-
-       v4l2_prio_close(&dev->prio, fh->prio);
-       file->private_data = NULL;
-       kfree(fh);
-
-       return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(i != fh->type)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO6)))) {
-               return -EBUSY;
-       }
-
-       return videobuf_streamon(get_queue(fh));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
-
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               return -EINVAL;
-       if (i != fh->type)
-               return -EINVAL;
-
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO6);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-               return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-                               struct v4l2_format *f)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-       int pix_format = 0;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
-
-       if (0 != err)
-               return err;
-
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->vidq.field = f->fmt.pix.field;
-
-       // check if width and height is valid based on set standard
-       if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm)) {
-               fh->width = f->fmt.pix.width;
-       }
-
-       if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm)) {
-               fh->height = f->fmt.pix.height;
-       }
-
-       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
-               pix_format = PIXEL_FRMT_411;
-       else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
-               pix_format = PIXEL_FRMT_422;
-       else
-               return -EINVAL;
-
-       cx25821_set_pixel_format(dev, SRAM_CH06, pix_format);
-
-       // check if cif resolution
-       if (fh->width == 320 || fh->width == 352) {
-               dev->use_cif_resolution[SRAM_CH06] = 1;
-       } else {
-               dev->use_cif_resolution[SRAM_CH06] = 0;
-       }
-       dev->cif_width[SRAM_CH06] = fh->width;
-       medusa_set_resolution(dev, fh->width, SRAM_CH06);
-
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-               fh->height, fh->vidq.field);
-       cx25821_call_all(dev, video, s_fmt, f);
-
-       return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-       int ret_val = 0;
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-
-       ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-
-       p->sequence = dev->vidq[SRAM_CH06].count;
-
-       return ret_val;
-}
-
-static int vidioc_log_status(struct file *file, void *priv)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       char name[32 + 2];
-
-       struct sram_channel *sram_ch = &dev->sram_channels[SRAM_CH06];
-       u32 tmp = 0;
-
-       snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-              dev->name);
-       cx25821_call_all(dev, core, log_status);
-
-       tmp = cx_read(sram_ch->dma_ctl);
-       printk(KERN_INFO "Video input 6 is %s\n",
-              (tmp & 0x11) ? "streaming" : "stopped");
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-              dev->name);
-       return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-                        struct v4l2_control *ctl)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       return cx25821_set_control(dev, ctl, SRAM_CH06);
-}
-
-// exported stuff
-static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = video_ioctl2,
-};
-
-static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
-#endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-       .vidiocgmbuf = cx25821_vidiocgmbuf,
-#endif
-#ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
-#endif
-};
-
-struct video_device cx25821_video_template6 = {
-       .name = "cx25821-video",
-       .fops = &video_fops,
-       .ioctl_ops = &video_ioctl_ops,
-       .tvnorms = CX25821_NORMS,
-       .current_norm = V4L2_STD_NTSC_M,
-};
diff --git a/drivers/staging/cx25821/cx25821-video7.c b/drivers/staging/cx25821/cx25821-video7.c
deleted file mode 100644
index 5e4a769..0000000
--- a/drivers/staging/cx25821/cx25821-video7.c
+++ /dev/null
@@ -1,433 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "cx25821-video.h"
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-       struct cx25821_buffer *buf =
-           container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH07];
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-       if (!list_empty(&q->queued)) {
-               list_add_tail(&buf->vb.queue, &q->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-                       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-               list_add_tail(&buf->vb.queue, &q->active);
-               cx25821_start_video_dma(dev, q, buf,
-                                       &dev->sram_channels[SRAM_CH07]);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               buf->count = q->count++;
-               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-               dprintk(2,
-                       "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-                       buf, buf->vb.i, buf->count, q->count);
-       } else {
-               prev =
-                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-               if (prev->vb.width == buf->vb.width
-                   && prev->vb.height == buf->vb.height
-                   && prev->fmt == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &q->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       buf->count = q->count++;
-                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-                       /* 64 bit bits 63-32 */
-                       prev->risc.jmp[2] = cpu_to_le32(0);
-                       dprintk(2,
-                               "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-                               buf, buf->vb.i, buf->count);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &q->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-                               buf->vb.i);
-               }
-       }
-
-       if (list_empty(&q->active)) {
-               dprintk(2, "active queue empty!\n");
-       }
-}
-
-static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
-};
-
-static int video_open(struct file *file)
-{
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-       u32 pix_format;
-
-       printk("open dev=%s type=%s\n", video_device_node_name(vdev),
-               v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-               return -ENOMEM;
-
-       lock_kernel();
-
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-               fh->height = 576;
-       else
-               fh->height = 480;
-
-       dev->channel_opened = SRAM_CH07;
-       pix_format =
-           (dev->pixel_formats[dev->channel_opened] ==
-            PIXEL_FRMT_411) ? V4L2_PIX_FMT_Y41P : V4L2_PIX_FMT_YUYV;
-       fh->fmt = format_by_fourcc(pix_format);
-
-       v4l2_prio_open(&dev->prio, &fh->prio);
-
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-                              &dev->pci->dev, &dev->slock,
-                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
-                              V4L2_FIELD_INTERLACED,
-                              sizeof(struct cx25821_buffer), fh);
-
-       dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
-
-       return 0;
-}
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-                         loff_t * ppos)
-{
-       struct cx25821_fh *fh = file->private_data;
-
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-               if (cx25821_res_locked(fh->dev, RESOURCE_VIDEO7))
-                       return -EBUSY;
-
-               return videobuf_read_one(&fh->vidq, data, count, ppos,
-                                        file->f_flags & O_NONBLOCK);
-
-       default:
-               BUG();
-               return 0;
-       }
-}
-
-static unsigned int video_poll(struct file *file,
-                              struct poll_table_struct *wait)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
-
-       if (cx25821_res_check(fh, RESOURCE_VIDEO7)) {
-               /* streaming capture */
-               if (list_empty(&fh->vidq.stream))
-                       return POLLERR;
-               buf = list_entry(fh->vidq.stream.next,
-                                struct cx25821_buffer, vb.stream);
-       } else {
-               /* read() capture */
-               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-               if (NULL == buf)
-                       return POLLERR;
-       }
-
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR) {
-               if (buf->vb.state == VIDEOBUF_DONE) {
-                       struct cx25821_dev *dev = fh->dev;
-
-                       if (dev && dev->use_cif_resolution[SRAM_CH07]) {
-                               u8 cam_id = *((char *)buf->vb.baddr + 3);
-                               memcpy((char *)buf->vb.baddr,
-                                      (char *)buf->vb.baddr + (fh->width * 2),
-                                      (fh->width * 2));
-                               *((char *)buf->vb.baddr + 3) = cam_id;
-                       }
-               }
-
-               return POLLIN | POLLRDNORM;
-       }
-
-       return 0;
-}
-
-static int video_release(struct file *file)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-
-       //stop the risc engine and fifo
-       cx_write(channel7->dma_ctl, 0); /* FIFO and RISC disable */
-
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO7)) {
-               videobuf_queue_cancel(&fh->vidq);
-               cx25821_res_free(dev, fh, RESOURCE_VIDEO7);
-       }
-
-       if (fh->vidq.read_buf) {
-               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-               kfree(fh->vidq.read_buf);
-       }
-
-       videobuf_mmap_free(&fh->vidq);
-
-       v4l2_prio_close(&dev->prio, fh->prio);
-       file->private_data = NULL;
-       kfree(fh);
-
-       return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(i != fh->type)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO7)))) {
-               return -EBUSY;
-       }
-
-       return videobuf_streamon(get_queue(fh));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
-
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               return -EINVAL;
-       if (i != fh->type)
-               return -EINVAL;
-
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO7);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-               return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-                               struct v4l2_format *f)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-       int pix_format = 0;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
-
-       if (0 != err)
-               return err;
-
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->vidq.field = f->fmt.pix.field;
-
-       // check if width and height is valid based on set standard
-       if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm)) {
-               fh->width = f->fmt.pix.width;
-       }
-
-       if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm)) {
-               fh->height = f->fmt.pix.height;
-       }
-
-       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
-               pix_format = PIXEL_FRMT_411;
-       else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
-               pix_format = PIXEL_FRMT_422;
-       else
-               return -EINVAL;
-
-       cx25821_set_pixel_format(dev, SRAM_CH07, pix_format);
-
-       // check if cif resolution
-       if (fh->width == 320 || fh->width == 352) {
-               dev->use_cif_resolution[SRAM_CH07] = 1;
-       } else {
-               dev->use_cif_resolution[SRAM_CH07] = 0;
-       }
-       dev->cif_width[SRAM_CH07] = fh->width;
-       medusa_set_resolution(dev, fh->width, SRAM_CH07);
-
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-               fh->height, fh->vidq.field);
-       cx25821_call_all(dev, video, s_fmt, f);
-
-       return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-       int ret_val = 0;
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-
-       ret_val = videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-
-       p->sequence = dev->vidq[SRAM_CH07].count;
-
-       return ret_val;
-}
-static int vidioc_log_status(struct file *file, void *priv)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       char name[32 + 2];
-
-       struct sram_channel *sram_ch = &dev->sram_channels[SRAM_CH07];
-       u32 tmp = 0;
-
-       snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-              dev->name);
-       cx25821_call_all(dev, core, log_status);
-
-       tmp = cx_read(sram_ch->dma_ctl);
-       printk(KERN_INFO "Video input 7 is %s\n",
-              (tmp & 0x11) ? "streaming" : "stopped");
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-              dev->name);
-       return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-                        struct v4l2_control *ctl)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       return cx25821_set_control(dev, ctl, SRAM_CH07);
-}
-
-// exported stuff
-static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = video_ioctl2,
-};
-
-static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
-#endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-       .vidiocgmbuf = cx25821_vidiocgmbuf,
-#endif
-#ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
-#endif
-};
-
-struct video_device cx25821_video_template7 = {
-       .name = "cx25821-video",
-       .fops = &video_fops,
-       .ioctl_ops = &video_ioctl_ops,
-       .tvnorms = CX25821_NORMS,
-       .current_norm = V4L2_STD_NTSC_M,
-};
diff --git a/drivers/staging/cx25821/cx25821-videoioctl.c b/drivers/staging/cx25821/cx25821-videoioctl.c
deleted file mode 100644
index d16807d..0000000
--- a/drivers/staging/cx25821/cx25821-videoioctl.c
+++ /dev/null
@@ -1,480 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "cx25821-video.h"
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-       struct cx25821_buffer *buf =
-           container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->vidq[VIDEO_IOCTL_CH];
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-       if (!list_empty(&q->queued)) {
-               list_add_tail(&buf->vb.queue, &q->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-                       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-               list_add_tail(&buf->vb.queue, &q->active);
-               cx25821_start_video_dma(dev, q, buf,
-                                       &dev->sram_channels[VIDEO_IOCTL_CH]);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               buf->count = q->count++;
-               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-               dprintk(2,
-                       "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-                       buf, buf->vb.i, buf->count, q->count);
-       } else {
-               prev =
-                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-               if (prev->vb.width == buf->vb.width
-                   && prev->vb.height == buf->vb.height
-                   && prev->fmt == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &q->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       buf->count = q->count++;
-                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-                       /* 64 bit bits 63-32 */
-                       prev->risc.jmp[2] = cpu_to_le32(0);
-                       dprintk(2,
-                               "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-                               buf, buf->vb.i, buf->count);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &q->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-                               buf->vb.i);
-               }
-       }
-
-       if (list_empty(&q->active)) {
-               dprintk(2, "active queue empty!\n");
-       }
-}
-
-static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
-};
-
-static int video_open(struct file *file)
-{
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-       u32 pix_format;
-
-       printk("open dev=%s type=%s\n", video_device_node_name(vdev),
-               v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-               return -ENOMEM;
-
-       lock_kernel();
-
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-               fh->height = 576;
-       else
-               fh->height = 480;
-
-       dev->channel_opened = VIDEO_IOCTL_CH;
-       pix_format = V4L2_PIX_FMT_YUYV;
-       fh->fmt = format_by_fourcc(pix_format);
-
-       v4l2_prio_open(&dev->prio, &fh->prio);
-
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-                              &dev->pci->dev, &dev->slock,
-                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
-                              V4L2_FIELD_INTERLACED,
-                              sizeof(struct cx25821_buffer), fh);
-
-       dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
-
-       return 0;
-}
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-                         loff_t * ppos)
-{
-       struct cx25821_fh *fh = file->private_data;
-
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-               if (cx25821_res_locked(fh->dev, RESOURCE_VIDEO_IOCTL))
-                       return -EBUSY;
-
-               return videobuf_read_one(&fh->vidq, data, count, ppos,
-                                        file->f_flags & O_NONBLOCK);
-
-       default:
-               BUG();
-               return 0;
-       }
-}
-
-static unsigned int video_poll(struct file *file,
-                              struct poll_table_struct *wait)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
-
-       if (cx25821_res_check(fh, RESOURCE_VIDEO_IOCTL)) {
-               /* streaming capture */
-               if (list_empty(&fh->vidq.stream))
-                       return POLLERR;
-               buf = list_entry(fh->vidq.stream.next,
-                                struct cx25821_buffer, vb.stream);
-       } else {
-               /* read() capture */
-               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-               if (NULL == buf)
-                       return POLLERR;
-       }
-
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR)
-               return POLLIN | POLLRDNORM;
-
-       return 0;
-}
-
-static int video_release(struct file *file)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO_IOCTL)) {
-               videobuf_queue_cancel(&fh->vidq);
-               cx25821_res_free(dev, fh, RESOURCE_VIDEO_IOCTL);
-       }
-
-       if (fh->vidq.read_buf) {
-               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-               kfree(fh->vidq.read_buf);
-       }
-
-       videobuf_mmap_free(&fh->vidq);
-
-       v4l2_prio_close(&dev->prio, fh->prio);
-
-       file->private_data = NULL;
-       kfree(fh);
-
-       return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(i != fh->type)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO_IOCTL)))) {
-               return -EBUSY;
-       }
-
-       return videobuf_streamon(get_queue(fh));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
-
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               return -EINVAL;
-       if (i != fh->type)
-               return -EINVAL;
-
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO_IOCTL);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-               return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-                               struct v4l2_format *f)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
-
-       if (0 != err)
-               return err;
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->width = f->fmt.pix.width;
-       fh->height = f->fmt.pix.height;
-       fh->vidq.field = f->fmt.pix.field;
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-               fh->height, fh->vidq.field);
-       cx25821_call_all(dev, video, s_fmt, f);
-       return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-       struct cx25821_fh *fh = priv;
-       return videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-}
-
-static long video_ioctl_set(struct file *file, unsigned int cmd,
-                           unsigned long arg)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct downstream_user_struct *data_from_user;
-       int command;
-       int width = 720;
-       int selected_channel = 0, pix_format = 0, i = 0;
-       int cif_enable = 0, cif_width = 0;
-       u32 value = 0;
-
-       data_from_user = (struct downstream_user_struct *)arg;
-
-       if (!data_from_user) {
-               printk("cx25821 in %s(): User data is INVALID. Returning.\n",
-                      __func__);
-               return 0;
-       }
-
-       command = data_from_user->command;
-
-       if (command != SET_VIDEO_STD && command != SET_PIXEL_FORMAT
-           && command != ENABLE_CIF_RESOLUTION && command != REG_READ
-           && command != REG_WRITE && command != MEDUSA_READ
-           && command != MEDUSA_WRITE) {
-               return 0;
-       }
-
-       switch (command) {
-       case SET_VIDEO_STD:
-               dev->tvnorm =
-                   !strcmp(data_from_user->vid_stdname,
-                           "PAL") ? V4L2_STD_PAL_BG : V4L2_STD_NTSC_M;
-               medusa_set_videostandard(dev);
-               break;
-
-       case SET_PIXEL_FORMAT:
-               selected_channel = data_from_user->decoder_select;
-               pix_format = data_from_user->pixel_format;
-
-               if (!(selected_channel <= 7 && selected_channel >= 0)) {
-                       selected_channel -= 4;
-                       selected_channel = selected_channel % 8;
-               }
-
-               if (selected_channel >= 0)
-                       cx25821_set_pixel_format(dev, selected_channel,
-                                                pix_format);
-
-               break;
-
-       case ENABLE_CIF_RESOLUTION:
-               selected_channel = data_from_user->decoder_select;
-               cif_enable = data_from_user->cif_resolution_enable;
-               cif_width = data_from_user->cif_width;
-
-               if (cif_enable) {
-                       if (dev->tvnorm & V4L2_STD_PAL_BG
-                           || dev->tvnorm & V4L2_STD_PAL_DK)
-                               width = 352;
-                       else
-                               width = (cif_width == 320
-                                        || cif_width == 352) ? cif_width : 320;
-               }
-
-               if (!(selected_channel <= 7 && selected_channel >= 0)) {
-                       selected_channel -= 4;
-                       selected_channel = selected_channel % 8;
-               }
-
-               if (selected_channel <= 7 && selected_channel >= 0) {
-                       dev->use_cif_resolution[selected_channel] = cif_enable;
-                       dev->cif_width[selected_channel] = width;
-               } else {
-                       for (i = 0; i < VID_CHANNEL_NUM; i++) {
-                               dev->use_cif_resolution[i] = cif_enable;
-                               dev->cif_width[i] = width;
-                       }
-               }
-
-               medusa_set_resolution(dev, width, selected_channel);
-               break;
-       case REG_READ:
-               data_from_user->reg_data = cx_read(data_from_user->reg_address);
-               break;
-       case REG_WRITE:
-               cx_write(data_from_user->reg_address, data_from_user->reg_data);
-               break;
-       case MEDUSA_READ:
-               value =
-                   cx25821_i2c_read(&dev->i2c_bus[0],
-                                    (u16) data_from_user->reg_address,
-                                    &data_from_user->reg_data);
-               break;
-       case MEDUSA_WRITE:
-               cx25821_i2c_write(&dev->i2c_bus[0],
-                                 (u16) data_from_user->reg_address,
-                                 data_from_user->reg_data);
-               break;
-       }
-
-       return 0;
-}
-
-static int vidioc_log_status(struct file *file, void *priv)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       char name[32 + 2];
-
-       snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-              dev->name);
-       cx25821_call_all(dev, core, log_status);
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-              dev->name);
-       return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-                        struct v4l2_control *ctl)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       return 0;
-}
-
-// exported stuff
-static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = video_ioctl_set,
-};
-
-static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
-#endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-       .vidiocgmbuf = cx25821_vidiocgmbuf,
-#endif
-#ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
-#endif
-};
-
-struct video_device cx25821_videoioctl_template = {
-       .name = "cx25821-videoioctl",
-       .fops = &video_fops,
-       .ioctl_ops = &video_ioctl_ops,
-       .tvnorms = CX25821_NORMS,
-       .current_norm = V4L2_STD_NTSC_M,
-};
diff --git a/drivers/staging/cx25821/cx25821-vidups10.c b/drivers/staging/cx25821/cx25821-vidups10.c
deleted file mode 100644
index c746a17..0000000
--- a/drivers/staging/cx25821/cx25821-vidups10.c
+++ /dev/null
@@ -1,418 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "cx25821-video.h"
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-       struct cx25821_buffer *buf =
-           container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH10];
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-       if (!list_empty(&q->queued)) {
-               list_add_tail(&buf->vb.queue, &q->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-                       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-               list_add_tail(&buf->vb.queue, &q->active);
-               cx25821_start_video_dma(dev, q, buf,
-                                       &dev->sram_channels[SRAM_CH10]);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               buf->count = q->count++;
-               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-               dprintk(2,
-                       "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-                       buf, buf->vb.i, buf->count, q->count);
-       } else {
-               prev =
-                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-               if (prev->vb.width == buf->vb.width
-                   && prev->vb.height == buf->vb.height
-                   && prev->fmt == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &q->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       buf->count = q->count++;
-                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-                       /* 64 bit bits 63-32 */
-                       prev->risc.jmp[2] = cpu_to_le32(0);
-                       dprintk(2,
-                               "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-                               buf, buf->vb.i, buf->count);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &q->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-                               buf->vb.i);
-               }
-       }
-
-       if (list_empty(&q->active)) {
-               dprintk(2, "active queue empty!\n");
-       }
-}
-
-static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
-};
-
-static int video_open(struct file *file)
-{
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-       printk("open dev=%s type=%s\n", video_device_node_name(vdev),
-               v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-               return -ENOMEM;
-
-       lock_kernel();
-
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-               fh->height = 576;
-       else
-               fh->height = 480;
-
-       dev->channel_opened = 9;
-       fh->fmt = format_by_fourcc(V4L2_PIX_FMT_YUYV);
-
-       v4l2_prio_open(&dev->prio, &fh->prio);
-
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-                              &dev->pci->dev, &dev->slock,
-                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
-                              V4L2_FIELD_INTERLACED,
-                              sizeof(struct cx25821_buffer), fh);
-
-       dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
-
-       return 0;
-}
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-                         loff_t * ppos)
-{
-       struct cx25821_fh *fh = file->private_data;
-
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-               if (cx25821_res_locked(fh->dev, RESOURCE_VIDEO10))
-                       return -EBUSY;
-
-               return videobuf_read_one(&fh->vidq, data, count, ppos,
-                                        file->f_flags & O_NONBLOCK);
-
-       default:
-               BUG();
-               return 0;
-       }
-}
-
-static unsigned int video_poll(struct file *file,
-                              struct poll_table_struct *wait)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
-
-       if (cx25821_res_check(fh, RESOURCE_VIDEO10)) {
-               /* streaming capture */
-               if (list_empty(&fh->vidq.stream))
-                       return POLLERR;
-               buf = list_entry(fh->vidq.stream.next,
-                                struct cx25821_buffer, vb.stream);
-       } else {
-               /* read() capture */
-               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-               if (NULL == buf)
-                       return POLLERR;
-       }
-
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR)
-               return POLLIN | POLLRDNORM;
-       return 0;
-}
-
-static int video_release(struct file *file)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-
-       //stop the risc engine and fifo
-       //cx_write(channel10->dma_ctl, 0);
-
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO10)) {
-               videobuf_queue_cancel(&fh->vidq);
-               cx25821_res_free(dev, fh, RESOURCE_VIDEO10);
-       }
-
-       if (fh->vidq.read_buf) {
-               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-               kfree(fh->vidq.read_buf);
-       }
-
-       videobuf_mmap_free(&fh->vidq);
-
-       v4l2_prio_close(&dev->prio, fh->prio);
-
-       file->private_data = NULL;
-       kfree(fh);
-
-       return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(i != fh->type)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO10)))) {
-               return -EBUSY;
-       }
-
-       return videobuf_streamon(get_queue(fh));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
-
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               return -EINVAL;
-       if (i != fh->type)
-               return -EINVAL;
-
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO10);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-               return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
-}
-
-static long video_ioctl_upstream10(struct file *file, unsigned int cmd,
-                                  unsigned long arg)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-       int command = 0;
-       struct upstream_user_struct *data_from_user;
-
-       data_from_user = (struct upstream_user_struct *)arg;
-
-       if (!data_from_user) {
-               printk
-                   ("cx25821 in %s(): Upstream data is INVALID. Returning.\n",
-                    __func__);
-               return 0;
-       }
-
-       command = data_from_user->command;
-
-       if (command != UPSTREAM_START_VIDEO && command != UPSTREAM_STOP_VIDEO) {
-               return 0;
-       }
-
-       dev->input_filename_ch2 = data_from_user->input_filename;
-       dev->input_audiofilename = data_from_user->input_filename;
-       dev->vid_stdname_ch2 = data_from_user->vid_stdname;
-       dev->pixel_format_ch2 = data_from_user->pixel_format;
-       dev->channel_select_ch2 = data_from_user->channel_select;
-       dev->command_ch2 = data_from_user->command;
-
-       switch (command) {
-       case UPSTREAM_START_VIDEO:
-               cx25821_start_upstream_video_ch2(dev, data_from_user);
-               break;
-
-       case UPSTREAM_STOP_VIDEO:
-               cx25821_stop_upstream_video_ch2(dev);
-               break;
-       }
-
-       return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-                               struct v4l2_format *f)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
-
-       if (0 != err)
-               return err;
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->width = f->fmt.pix.width;
-       fh->height = f->fmt.pix.height;
-       fh->vidq.field = f->fmt.pix.field;
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-               fh->height, fh->vidq.field);
-       cx25821_call_all(dev, video, s_fmt, f);
-       return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-       struct cx25821_fh *fh = priv;
-       return videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-}
-
-static int vidioc_log_status(struct file *file, void *priv)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       char name[32 + 2];
-
-       snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-              dev->name);
-       cx25821_call_all(dev, core, log_status);
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-              dev->name);
-       return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-                        struct v4l2_control *ctl)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       return 0;
-}
-
-//exported stuff
-static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = video_ioctl_upstream10,
-};
-
-static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
-#endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-       .vidiocgmbuf = cx25821_vidiocgmbuf,
-#endif
-#ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
-#endif
-};
-
-struct video_device cx25821_video_template10 = {
-       .name = "cx25821-upstream10",
-       .fops = &video_fops,
-       .ioctl_ops = &video_ioctl_ops,
-       .tvnorms = CX25821_NORMS,
-       .current_norm = V4L2_STD_NTSC_M,
-};
diff --git a/drivers/staging/cx25821/cx25821-vidups9.c b/drivers/staging/cx25821/cx25821-vidups9.c
deleted file mode 100644
index 466e0f3..0000000
--- a/drivers/staging/cx25821/cx25821-vidups9.c
+++ /dev/null
@@ -1,416 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <shu.lin@conexant.com>, <hiep.huynh@conexant.com>
- *  Based on Steven Toth <stoth@linuxtv.org> cx23885 driver
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include "cx25821-video.h"
-
-static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-       struct cx25821_buffer *buf =
-           container_of(vb, struct cx25821_buffer, vb);
-       struct cx25821_buffer *prev;
-       struct cx25821_fh *fh = vq->priv_data;
-       struct cx25821_dev *dev = fh->dev;
-       struct cx25821_dmaqueue *q = &dev->vidq[SRAM_CH09];
-
-       /* add jump to stopper */
-       buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
-       buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
-       buf->risc.jmp[2] = cpu_to_le32(0);      /* bits 63-32 */
-
-       dprintk(2, "jmp to stopper (0x%x)\n", buf->risc.jmp[1]);
-
-       if (!list_empty(&q->queued)) {
-               list_add_tail(&buf->vb.queue, &q->queued);
-               buf->vb.state = VIDEOBUF_QUEUED;
-               dprintk(2, "[%p/%d] buffer_queue - append to queued\n", buf,
-                       buf->vb.i);
-
-       } else if (list_empty(&q->active)) {
-               list_add_tail(&buf->vb.queue, &q->active);
-               cx25821_start_video_dma(dev, q, buf,
-                                       &dev->sram_channels[SRAM_CH09]);
-               buf->vb.state = VIDEOBUF_ACTIVE;
-               buf->count = q->count++;
-               mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
-               dprintk(2,
-                       "[%p/%d] buffer_queue - first active, buf cnt = %d, q->count = %d\n",
-                       buf, buf->vb.i, buf->count, q->count);
-       } else {
-               prev =
-                   list_entry(q->active.prev, struct cx25821_buffer, vb.queue);
-               if (prev->vb.width == buf->vb.width
-                   && prev->vb.height == buf->vb.height
-                   && prev->fmt == buf->fmt) {
-                       list_add_tail(&buf->vb.queue, &q->active);
-                       buf->vb.state = VIDEOBUF_ACTIVE;
-                       buf->count = q->count++;
-                       prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-
-                       /* 64 bit bits 63-32 */
-                       prev->risc.jmp[2] = cpu_to_le32(0);
-                       dprintk(2,
-                               "[%p/%d] buffer_queue - append to active, buf->count=%d\n",
-                               buf, buf->vb.i, buf->count);
-
-               } else {
-                       list_add_tail(&buf->vb.queue, &q->queued);
-                       buf->vb.state = VIDEOBUF_QUEUED;
-                       dprintk(2, "[%p/%d] buffer_queue - first queued\n", buf,
-                               buf->vb.i);
-               }
-       }
-
-       if (list_empty(&q->active)) {
-               dprintk(2, "active queue empty!\n");
-       }
-}
-
-static struct videobuf_queue_ops cx25821_video_qops = {
-       .buf_setup = cx25821_buffer_setup,
-       .buf_prepare = cx25821_buffer_prepare,
-       .buf_queue = buffer_queue,
-       .buf_release = cx25821_buffer_release,
-};
-
-static int video_open(struct file *file)
-{
-       struct video_device *vdev = video_devdata(file);
-       struct cx25821_dev *dev = video_drvdata(file);
-       struct cx25821_fh *fh;
-       enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-       printk("open dev=%s type=%s\n", video_device_node_name(vdev),
-               v4l2_type_names[type]);
-
-       /* allocate + initialize per filehandle data */
-       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-       if (NULL == fh)
-               return -ENOMEM;
-
-       lock_kernel();
-
-       file->private_data = fh;
-       fh->dev = dev;
-       fh->type = type;
-       fh->width = 720;
-
-       if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
-               fh->height = 576;
-       else
-               fh->height = 480;
-
-       dev->channel_opened = 8;
-       fh->fmt = format_by_fourcc(V4L2_PIX_FMT_YUYV);
-
-       v4l2_prio_open(&dev->prio, &fh->prio);
-
-       videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops,
-                              &dev->pci->dev, &dev->slock,
-                              V4L2_BUF_TYPE_VIDEO_CAPTURE,
-                              V4L2_FIELD_INTERLACED,
-                              sizeof(struct cx25821_buffer), fh);
-
-       dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
-
-       return 0;
-}
-
-static ssize_t video_read(struct file *file, char __user * data, size_t count,
-                         loff_t * ppos)
-{
-       struct cx25821_fh *fh = file->private_data;
-
-       switch (fh->type) {
-       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-               if (cx25821_res_locked(fh->dev, RESOURCE_VIDEO9))
-                       return -EBUSY;
-
-               return videobuf_read_one(&fh->vidq, data, count, ppos,
-                                        file->f_flags & O_NONBLOCK);
-
-       default:
-               BUG();
-               return 0;
-       }
-}
-
-static unsigned int video_poll(struct file *file,
-                              struct poll_table_struct *wait)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_buffer *buf;
-
-       if (cx25821_res_check(fh, RESOURCE_VIDEO9)) {
-               /* streaming capture */
-               if (list_empty(&fh->vidq.stream))
-                       return POLLERR;
-               buf = list_entry(fh->vidq.stream.next,
-                                struct cx25821_buffer, vb.stream);
-       } else {
-               /* read() capture */
-               buf = (struct cx25821_buffer *)fh->vidq.read_buf;
-               if (NULL == buf)
-                       return POLLERR;
-       }
-
-       poll_wait(file, &buf->vb.done, wait);
-       if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR)
-               return POLLIN | POLLRDNORM;
-       return 0;
-}
-
-static int video_release(struct file *file)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-
-       //stop the risc engine and fifo
-       //cx_write(channel9->dma_ctl, 0);
-
-       /* stop video capture */
-       if (cx25821_res_check(fh, RESOURCE_VIDEO9)) {
-               videobuf_queue_cancel(&fh->vidq);
-               cx25821_res_free(dev, fh, RESOURCE_VIDEO9);
-       }
-
-       if (fh->vidq.read_buf) {
-               cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
-               kfree(fh->vidq.read_buf);
-       }
-
-       videobuf_mmap_free(&fh->vidq);
-
-       v4l2_prio_close(&dev->prio, fh->prio);
-
-       file->private_data = NULL;
-       kfree(fh);
-
-       return 0;
-}
-
-static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-
-       if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(i != fh->type)) {
-               return -EINVAL;
-       }
-
-       if (unlikely(!cx25821_res_get(dev, fh, cx25821_get_resource(fh, RESOURCE_VIDEO9)))) {
-               return -EBUSY;
-       }
-
-       return videobuf_streamon(get_queue(fh));
-}
-
-static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = fh->dev;
-       int err, res;
-
-       if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               return -EINVAL;
-       if (i != fh->type)
-               return -EINVAL;
-
-       res = cx25821_get_resource(fh, RESOURCE_VIDEO9);
-       err = videobuf_streamoff(get_queue(fh));
-       if (err < 0)
-               return err;
-       cx25821_res_free(dev, fh, res);
-       return 0;
-}
-
-static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
-                                 unsigned long arg)
-{
-       struct cx25821_fh *fh = file->private_data;
-       struct cx25821_dev *dev = fh->dev;
-       int command = 0;
-       struct upstream_user_struct *data_from_user;
-
-       data_from_user = (struct upstream_user_struct *)arg;
-
-       if (!data_from_user) {
-               printk
-                   ("cx25821 in %s(): Upstream data is INVALID. Returning.\n",
-                    __func__);
-               return 0;
-       }
-
-       command = data_from_user->command;
-
-       if (command != UPSTREAM_START_VIDEO && command != UPSTREAM_STOP_VIDEO) {
-               return 0;
-       }
-
-       dev->input_filename = data_from_user->input_filename;
-       dev->input_audiofilename = data_from_user->input_filename;
-       dev->vid_stdname = data_from_user->vid_stdname;
-       dev->pixel_format = data_from_user->pixel_format;
-       dev->channel_select = data_from_user->channel_select;
-       dev->command = data_from_user->command;
-
-       switch (command) {
-       case UPSTREAM_START_VIDEO:
-               cx25821_start_upstream_video_ch1(dev, data_from_user);
-               break;
-
-       case UPSTREAM_STOP_VIDEO:
-               cx25821_stop_upstream_video_ch1(dev);
-               break;
-       }
-
-       return 0;
-}
-
-static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
-                               struct v4l2_format *f)
-{
-       struct cx25821_fh *fh = priv;
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       int err;
-
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       dprintk(2, "%s()\n", __func__);
-       err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
-
-       if (0 != err)
-               return err;
-       fh->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
-       fh->width = f->fmt.pix.width;
-       fh->height = f->fmt.pix.height;
-       fh->vidq.field = f->fmt.pix.field;
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-               fh->height, fh->vidq.field);
-       cx25821_call_all(dev, video, s_fmt, f);
-       return 0;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-       struct cx25821_fh *fh = priv;
-       return videobuf_dqbuf(get_queue(fh), p, file->f_flags & O_NONBLOCK);
-}
-static int vidioc_log_status(struct file *file, void *priv)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       char name[32 + 2];
-
-       snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-              dev->name);
-       cx25821_call_all(dev, core, log_status);
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-              dev->name);
-       return 0;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-                        struct v4l2_control *ctl)
-{
-       struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-       struct cx25821_fh *fh = priv;
-       int err;
-       if (fh) {
-               err = v4l2_prio_check(&dev->prio, fh->prio);
-               if (0 != err)
-                       return err;
-       }
-
-       return 0;
-}
-
-// exported stuff
-static const struct v4l2_file_operations video_fops = {
-       .owner = THIS_MODULE,
-       .open = video_open,
-       .release = video_release,
-       .read = video_read,
-       .poll = video_poll,
-       .mmap = cx25821_video_mmap,
-       .ioctl = video_ioctl_upstream9,
-};
-
-static const struct v4l2_ioctl_ops video_ioctl_ops = {
-       .vidioc_querycap = cx25821_vidioc_querycap,
-       .vidioc_enum_fmt_vid_cap = cx25821_vidioc_enum_fmt_vid_cap,
-       .vidioc_g_fmt_vid_cap = cx25821_vidioc_g_fmt_vid_cap,
-       .vidioc_try_fmt_vid_cap = cx25821_vidioc_try_fmt_vid_cap,
-       .vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
-       .vidioc_reqbufs = cx25821_vidioc_reqbufs,
-       .vidioc_querybuf = cx25821_vidioc_querybuf,
-       .vidioc_qbuf = cx25821_vidioc_qbuf,
-       .vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
-       .vidioc_s_std = cx25821_vidioc_s_std,
-       .vidioc_querystd = cx25821_vidioc_querystd,
-#endif
-       .vidioc_cropcap = cx25821_vidioc_cropcap,
-       .vidioc_s_crop = cx25821_vidioc_s_crop,
-       .vidioc_g_crop = cx25821_vidioc_g_crop,
-       .vidioc_enum_input = cx25821_vidioc_enum_input,
-       .vidioc_g_input = cx25821_vidioc_g_input,
-       .vidioc_s_input = cx25821_vidioc_s_input,
-       .vidioc_g_ctrl = cx25821_vidioc_g_ctrl,
-       .vidioc_s_ctrl = vidioc_s_ctrl,
-       .vidioc_queryctrl = cx25821_vidioc_queryctrl,
-       .vidioc_streamon = vidioc_streamon,
-       .vidioc_streamoff = vidioc_streamoff,
-       .vidioc_log_status = vidioc_log_status,
-       .vidioc_g_priority = cx25821_vidioc_g_priority,
-       .vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef CONFIG_VIDEO_V4L1_COMPAT
-       .vidiocgmbuf = cx25821_vidiocgmbuf,
-#endif
-#ifdef TUNER_FLAG
-       .vidioc_g_tuner = cx25821_vidioc_g_tuner,
-       .vidioc_s_tuner = cx25821_vidioc_s_tuner,
-       .vidioc_g_frequency = cx25821_vidioc_g_frequency,
-       .vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-       .vidioc_g_register = cx25821_vidioc_g_register,
-       .vidioc_s_register = cx25821_vidioc_s_register,
-#endif
-};
-
-struct video_device cx25821_video_template9 = {
-       .name = "cx25821-upstream9",
-       .fops = &video_fops,
-       .ioctl_ops = &video_ioctl_ops,
-       .tvnorms = CX25821_NORMS,
-       .current_norm = V4L2_STD_NTSC_M,
-};
diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index cf2286d..8816980 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -61,7 +61,7 @@
 #define FALSE   0
 #define LINE_SIZE_D1    1440

-// Number of decoders and encoders
+/* Number of decoders and encoders */
 #define MAX_DECODERS            8
 #define MAX_ENCODERS            2
 #define QUAD_DECODERS           4
@@ -139,6 +139,7 @@ struct cx25821_fh {
        /* video capture */
        struct cx25821_fmt *fmt;
        unsigned int width, height;
+    int channel_id;

        /* vbi capture */
        struct videobuf_queue vidq;
@@ -236,13 +237,34 @@ struct cx25821_data {
        struct sram_channel *channel;
 };

+struct cx25821_channel {
+       struct v4l2_prio_state prio;
+
+       int ctl_bright;
+       int ctl_contrast;
+       int ctl_hue;
+       int ctl_saturation;
+
+       struct cx25821_data timeout_data;
+
+       struct video_device *video_dev;
+       struct cx25821_dmaqueue vidq;
+
+       struct sram_channel *sram_channels;
+
+       struct mutex lock;
+       int resources;
+
+       int pixel_formats;
+       int use_cif_resolution;
+       int cif_width;
+};
+
 struct cx25821_dev {
        struct list_head devlist;
        atomic_t refcount;
        struct v4l2_device v4l2_dev;

-       struct v4l2_prio_state prio;
-
        /* pci stuff */
        struct pci_dev *pci;
        unsigned char pci_rev, pci_lat;
@@ -261,13 +283,12 @@ struct cx25821_dev {
        int nr;
        struct mutex lock;

+    struct cx25821_channel channels[MAX_VID_CHANNEL_NUM];
+
        /* board details */
        unsigned int board;
        char name[32];

-       /* sram configuration */
-       struct sram_channel *sram_channels;
-
        /* Analog video */
        u32 resources;
        unsigned int input;
@@ -282,13 +303,6 @@ struct cx25821_dev {
        unsigned char videc_addr;
        unsigned short _max_num_decoders;

-       int ctl_bright;
-       int ctl_contrast;
-       int ctl_hue;
-       int ctl_saturation;
-
-       struct cx25821_data timeout_data[MAX_VID_CHANNEL_NUM];
-
        /* Analog Audio Upstream */
        int _audio_is_running;
        int _audiopixel_format;
@@ -297,7 +311,7 @@ struct cx25821_dev {
        int _audio_lines_count;
        int _audioframe_count;
        int _audio_upstream_channel_select;
-       int _last_index_irq;    //The last interrupt index processed.
+       int _last_index_irq;    /* The last interrupt index processed. */

        __le32 *_risc_audio_jmp_addr;
        __le32 *_risc_virt_start_addr;
@@ -313,12 +327,10 @@ struct cx25821_dev {

        /* V4l */
        u32 freq;
-       struct video_device *video_dev[MAX_VID_CHANNEL_NUM];
        struct video_device *vbi_dev;
        struct video_device *radio_dev;
        struct video_device *ioctl_dev;

-       struct cx25821_dmaqueue vidq[MAX_VID_CHANNEL_NUM];
        spinlock_t slock;

        /* Video Upstream */
@@ -401,9 +413,6 @@ struct cx25821_dev {
        int pixel_format;
        int channel_select;
        int command;
-       int pixel_formats[VID_CHANNEL_NUM];
-       int use_cif_resolution[VID_CHANNEL_NUM];
-       int cif_width[VID_CHANNEL_NUM];
        int channel_opened;
 };

@@ -482,7 +491,7 @@ struct sram_channel {
        u32 fld_aud_fifo_en;
        u32 fld_aud_risc_en;

-       //For Upstream Video
+       /* For Upstream Video */
        u32 vid_fmt_ctl;
        u32 vid_active_ctl1;
        u32 vid_active_ctl2;
--
1.7.0.4


Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------


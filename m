Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46806 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785AbbDYPn2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/12] dt3155v4l: code cleanup
Date: Sat, 25 Apr 2015 17:42:40 +0200
Message-Id: <1429976571-34872-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
References: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- Fix various spelling mistakes
- Whitespace cleanups
- Remove _ioc_ from ioctl names to shorten those names
- Remove bogus ifdef __KERNEL__
- Remove commented out code

No actual code is changed in this patch.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 202 +++++++++-------------------
 drivers/staging/media/dt3155v4l/dt3155v4l.h |   8 --
 2 files changed, 66 insertions(+), 144 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 52a8ffe..07cf8c3 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -12,10 +12,6 @@
  *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
  *   GNU General Public License for more details.                          *
  *                                                                         *
- *   You should have received a copy of the GNU General Public License     *
- *   along with this program; if not, write to the                         *
- *   Free Software Foundation, Inc.,                                       *
- *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
  ***************************************************************************/
 
 #include <linux/module.h>
@@ -96,12 +92,11 @@ static u8 config_init = ACQ_MODE_EVEN;
  * and busy waits for the process to finish. The result is placed
  * in a byte pointed by data.
  */
-static int
-read_i2c_reg(void __iomem *addr, u8 index, u8 *data)
+static int read_i2c_reg(void __iomem *addr, u8 index, u8 *data)
 {
 	u32 tmp = index;
 
-	iowrite32((tmp<<17) | IIC_READ, addr + IIC_CSR2);
+	iowrite32((tmp << 17) | IIC_READ, addr + IIC_CSR2);
 	mmiowb();
 	udelay(45); /* wait at least 43 usec for NEW_CYCLE to clear */
 	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE)
@@ -112,7 +107,7 @@ read_i2c_reg(void __iomem *addr, u8 index, u8 *data)
 		iowrite32(DIRECT_ABORT, addr + IIC_CSR1);
 		return -EIO; /* error: DIRECT_ABORT set */
 	}
-	*data = tmp>>24;
+	*data = tmp >> 24;
 	return 0;
 }
 
@@ -125,15 +120,14 @@ read_i2c_reg(void __iomem *addr, u8 index, u8 *data)
  *
  * returns:	zero on success or error code
  *
- * This function starts writting the specified (by index) register
+ * This function starts writing the specified (by index) register
  * and busy waits for the process to finish.
  */
-static int
-write_i2c_reg(void __iomem *addr, u8 index, u8 data)
+static int write_i2c_reg(void __iomem *addr, u8 index, u8 data)
 {
 	u32 tmp = index;
 
-	iowrite32((tmp<<17) | IIC_WRITE | data, addr + IIC_CSR2);
+	iowrite32((tmp << 17) | IIC_WRITE | data, addr + IIC_CSR2);
 	mmiowb();
 	udelay(65); /* wait at least 63 usec for NEW_CYCLE to clear */
 	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE)
@@ -153,14 +147,14 @@ write_i2c_reg(void __iomem *addr, u8 index, u8 data)
  * @index:	index (internal address) of register to read
  * @data:	data to be written
  *
- * This function starts writting the specified (by index) register
+ * This function starts writing the specified (by index) register
  * and then returns.
  */
 static void write_i2c_reg_nowait(void __iomem *addr, u8 index, u8 data)
 {
 	u32 tmp = index;
 
-	iowrite32((tmp<<17) | IIC_WRITE | data, addr + IIC_CSR2);
+	iowrite32((tmp << 17) | IIC_WRITE | data, addr + IIC_CSR2);
 	mmiowb();
 }
 
@@ -171,7 +165,7 @@ static void write_i2c_reg_nowait(void __iomem *addr, u8 index, u8 data)
  *
  * returns:	zero on success or error code
  *
- * This function waits reading/writting to finish.
+ * This function waits reading/writing to finish.
  */
 static int wait_i2c_reg(void __iomem *addr)
 {
@@ -187,8 +181,7 @@ static int wait_i2c_reg(void __iomem *addr)
 	return 0;
 }
 
-static int
-dt3155_start_acq(struct dt3155_priv *pd)
+static int dt3155_start_acq(struct dt3155_priv *pd)
 {
 	struct vb2_buffer *vb = pd->curr_buf;
 	dma_addr_t dma_addr;
@@ -214,9 +207,6 @@ dt3155_start_acq(struct dt3155_priv *pd)
 	return 0; /* success  */
 }
 
-/*
- *	driver-specific callbacks (vb2_ops)
- */
 static int
 dt3155_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 		unsigned int *num_buffers, unsigned int *num_planes,
@@ -239,31 +229,27 @@ dt3155_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 	return 0;
 }
 
-static void
-dt3155_wait_prepare(struct vb2_queue *q)
+static void dt3155_wait_prepare(struct vb2_queue *q)
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(q);
 
 	mutex_unlock(pd->vdev.lock);
 }
 
-static void
-dt3155_wait_finish(struct vb2_queue *q)
+static void dt3155_wait_finish(struct vb2_queue *q)
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(q);
 
 	mutex_lock(pd->vdev.lock);
 }
 
-static int
-dt3155_buf_prepare(struct vb2_buffer *vb)
+static int dt3155_buf_prepare(struct vb2_buffer *vb)
 {
 	vb2_set_plane_payload(vb, 0, img_width * img_height);
 	return 0;
 }
 
-static void
-dt3155_stop_streaming(struct vb2_queue *q)
+static void dt3155_stop_streaming(struct vb2_queue *q)
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(q);
 	struct vb2_buffer *vb;
@@ -278,8 +264,7 @@ dt3155_stop_streaming(struct vb2_queue *q)
 	msleep(45); /* irq hendler will stop the hardware */
 }
 
-static void
-dt3155_buf_queue(struct vb2_buffer *vb)
+static void dt3155_buf_queue(struct vb2_buffer *vb)
 {
 	struct dt3155_priv *pd = vb2_get_drv_priv(vb->vb2_queue);
 
@@ -293,9 +278,6 @@ dt3155_buf_queue(struct vb2_buffer *vb)
 	}
 	spin_unlock_irq(&pd->lock);
 }
-/*
- *	end driver-specific callbacks
- */
 
 static const struct vb2_ops q_ops = {
 	.queue_setup = dt3155_queue_setup,
@@ -306,8 +288,7 @@ static const struct vb2_ops q_ops = {
 	.buf_queue = dt3155_buf_queue,
 };
 
-static irqreturn_t
-dt3155_irq_handler_even(int irq, void *dev_id)
+static irqreturn_t dt3155_irq_handler_even(int irq, void *dev_id)
 {
 	struct dt3155_priv *ipd = dev_id;
 	struct vb2_buffer *ivb;
@@ -325,9 +306,6 @@ dt3155_irq_handler_even(int irq, void *dev_id)
 	}
 	if ((tmp & FLD_START) && (tmp & FLD_END_ODD))
 		ipd->stats.start_before_end++;
-	/*	check for corrupted fields     */
-/*	write_i2c_reg(ipd->regs, EVEN_CSR, CSR_ERROR | CSR_DONE);	*/
-/*	write_i2c_reg(ipd->regs, ODD_CSR, CSR_ERROR | CSR_DONE);	*/
 	tmp = ioread32(ipd->regs + CSR1) & (FLD_CRPT_EVEN | FLD_CRPT_ODD);
 	if (tmp) {
 		ipd->stats.corrupted_fields++;
@@ -374,8 +352,7 @@ stop_dma:
 	return IRQ_HANDLED;
 }
 
-static int
-dt3155_open(struct file *filp)
+static int dt3155_open(struct file *filp)
 {
 	int ret = 0;
 	struct dt3155_priv *pd = video_drvdata(filp);
@@ -420,8 +397,7 @@ err_alloc_queue:
 	return ret;
 }
 
-static int
-dt3155_release(struct file *filp)
+static int dt3155_release(struct file *filp)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
@@ -440,8 +416,7 @@ dt3155_release(struct file *filp)
 	return 0;
 }
 
-static ssize_t
-dt3155_read(struct file *filp, char __user *user, size_t size, loff_t *loff)
+static ssize_t dt3155_read(struct file *filp, char __user *user, size_t size, loff_t *loff)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 	ssize_t res;
@@ -453,8 +428,7 @@ dt3155_read(struct file *filp, char __user *user, size_t size, loff_t *loff)
 	return res;
 }
 
-static unsigned int
-dt3155_poll(struct file *filp, struct poll_table_struct *polltbl)
+static unsigned int dt3155_poll(struct file *filp, struct poll_table_struct *polltbl)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 	unsigned int res;
@@ -465,8 +439,7 @@ dt3155_poll(struct file *filp, struct poll_table_struct *polltbl)
 	return res;
 }
 
-static int
-dt3155_mmap(struct file *filp, struct vm_area_struct *vma)
+static int dt3155_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 	int res;
@@ -488,24 +461,21 @@ static const struct v4l2_file_operations dt3155_fops = {
 	.mmap = dt3155_mmap,
 };
 
-static int
-dt3155_ioc_streamon(struct file *filp, void *p, enum v4l2_buf_type type)
+static int dt3155_streamon(struct file *filp, void *p, enum v4l2_buf_type type)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
 	return vb2_streamon(pd->q, type);
 }
 
-static int
-dt3155_ioc_streamoff(struct file *filp, void *p, enum v4l2_buf_type type)
+static int dt3155_streamoff(struct file *filp, void *p, enum v4l2_buf_type type)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
 	return vb2_streamoff(pd->q, type);
 }
 
-static int
-dt3155_ioc_querycap(struct file *filp, void *p, struct v4l2_capability *cap)
+static int dt3155_querycap(struct file *filp, void *p, struct v4l2_capability *cap)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
@@ -518,8 +488,7 @@ dt3155_ioc_querycap(struct file *filp, void *p, struct v4l2_capability *cap)
 	return 0;
 }
 
-static int
-dt3155_ioc_enum_fmt_vid_cap(struct file *filp, void *p, struct v4l2_fmtdesc *f)
+static int dt3155_enum_fmt_vid_cap(struct file *filp, void *p, struct v4l2_fmtdesc *f)
 {
 	if (f->index >= NUM_OF_FORMATS)
 		return -EINVAL;
@@ -527,8 +496,7 @@ dt3155_ioc_enum_fmt_vid_cap(struct file *filp, void *p, struct v4l2_fmtdesc *f)
 	return 0;
 }
 
-static int
-dt3155_ioc_g_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
+static int dt3155_g_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
 {
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -543,8 +511,7 @@ dt3155_ioc_g_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
 	return 0;
 }
 
-static int
-dt3155_ioc_try_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
+static int dt3155_try_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
 {
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -559,68 +526,59 @@ dt3155_ioc_try_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
 		return -EINVAL;
 }
 
-static int
-dt3155_ioc_s_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
+static int dt3155_s_fmt_vid_cap(struct file *filp, void *p, struct v4l2_format *f)
 {
-	return dt3155_ioc_g_fmt_vid_cap(filp, p, f);
+	return dt3155_g_fmt_vid_cap(filp, p, f);
 }
 
-static int
-dt3155_ioc_reqbufs(struct file *filp, void *p, struct v4l2_requestbuffers *b)
+static int dt3155_reqbufs(struct file *filp, void *p, struct v4l2_requestbuffers *b)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
 	return vb2_reqbufs(pd->q, b);
 }
 
-static int
-dt3155_ioc_querybuf(struct file *filp, void *p, struct v4l2_buffer *b)
+static int dt3155_querybuf(struct file *filp, void *p, struct v4l2_buffer *b)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
 	return vb2_querybuf(pd->q, b);
 }
 
-static int
-dt3155_ioc_qbuf(struct file *filp, void *p, struct v4l2_buffer *b)
+static int dt3155_qbuf(struct file *filp, void *p, struct v4l2_buffer *b)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
 	return vb2_qbuf(pd->q, b);
 }
 
-static int
-dt3155_ioc_dqbuf(struct file *filp, void *p, struct v4l2_buffer *b)
+static int dt3155_dqbuf(struct file *filp, void *p, struct v4l2_buffer *b)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
 	return vb2_dqbuf(pd->q, b, filp->f_flags & O_NONBLOCK);
 }
 
-static int
-dt3155_ioc_querystd(struct file *filp, void *p, v4l2_std_id *norm)
+static int dt3155_querystd(struct file *filp, void *p, v4l2_std_id *norm)
 {
 	*norm = DT3155_CURRENT_NORM;
 	return 0;
 }
 
-static int
-dt3155_ioc_g_std(struct file *filp, void *p, v4l2_std_id *norm)
+static int dt3155_g_std(struct file *filp, void *p, v4l2_std_id *norm)
 {
 	*norm = DT3155_CURRENT_NORM;
 	return 0;
 }
 
-static int
-dt3155_ioc_s_std(struct file *filp, void *p, v4l2_std_id norm)
+static int dt3155_s_std(struct file *filp, void *p, v4l2_std_id norm)
 {
 	if (norm & DT3155_CURRENT_NORM)
 		return 0;
 	return -EINVAL;
 }
 
-static int
-dt3155_ioc_enum_input(struct file *filp, void *p, struct v4l2_input *input)
+static int dt3155_enum_input(struct file *filp, void *p, struct v4l2_input *input)
 {
 	if (input->index)
 		return -EINVAL;
@@ -636,23 +594,20 @@ dt3155_ioc_enum_input(struct file *filp, void *p, struct v4l2_input *input)
 	return 0;
 }
 
-static int
-dt3155_ioc_g_input(struct file *filp, void *p, unsigned int *i)
+static int dt3155_g_input(struct file *filp, void *p, unsigned int *i)
 {
 	*i = 0;
 	return 0;
 }
 
-static int
-dt3155_ioc_s_input(struct file *filp, void *p, unsigned int i)
+static int dt3155_s_input(struct file *filp, void *p, unsigned int i)
 {
 	if (i)
 		return -EINVAL;
 	return 0;
 }
 
-static int
-dt3155_ioc_g_parm(struct file *filp, void *p, struct v4l2_streamparm *parms)
+static int dt3155_g_parm(struct file *filp, void *p, struct v4l2_streamparm *parms)
 {
 	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -665,8 +620,7 @@ dt3155_ioc_g_parm(struct file *filp, void *p, struct v4l2_streamparm *parms)
 	return 0;
 }
 
-static int
-dt3155_ioc_s_parm(struct file *filp, void *p, struct v4l2_streamparm *parms)
+static int dt3155_s_parm(struct file *filp, void *p, struct v4l2_streamparm *parms)
 {
 	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -680,48 +634,28 @@ dt3155_ioc_s_parm(struct file *filp, void *p, struct v4l2_streamparm *parms)
 }
 
 static const struct v4l2_ioctl_ops dt3155_ioctl_ops = {
-	.vidioc_streamon = dt3155_ioc_streamon,
-	.vidioc_streamoff = dt3155_ioc_streamoff,
-	.vidioc_querycap = dt3155_ioc_querycap,
-/*
-	.vidioc_g_priority = dt3155_ioc_g_priority,
-	.vidioc_s_priority = dt3155_ioc_s_priority,
-*/
-	.vidioc_enum_fmt_vid_cap = dt3155_ioc_enum_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap = dt3155_ioc_try_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap = dt3155_ioc_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap = dt3155_ioc_s_fmt_vid_cap,
-	.vidioc_reqbufs = dt3155_ioc_reqbufs,
-	.vidioc_querybuf = dt3155_ioc_querybuf,
-	.vidioc_qbuf = dt3155_ioc_qbuf,
-	.vidioc_dqbuf = dt3155_ioc_dqbuf,
-	.vidioc_querystd = dt3155_ioc_querystd,
-	.vidioc_g_std = dt3155_ioc_g_std,
-	.vidioc_s_std = dt3155_ioc_s_std,
-	.vidioc_enum_input = dt3155_ioc_enum_input,
-	.vidioc_g_input = dt3155_ioc_g_input,
-	.vidioc_s_input = dt3155_ioc_s_input,
-/*
-	.vidioc_queryctrl = dt3155_ioc_queryctrl,
-	.vidioc_g_ctrl = dt3155_ioc_g_ctrl,
-	.vidioc_s_ctrl = dt3155_ioc_s_ctrl,
-	.vidioc_querymenu = dt3155_ioc_querymenu,
-	.vidioc_g_ext_ctrls = dt3155_ioc_g_ext_ctrls,
-	.vidioc_s_ext_ctrls = dt3155_ioc_s_ext_ctrls,
-*/
-	.vidioc_g_parm = dt3155_ioc_g_parm,
-	.vidioc_s_parm = dt3155_ioc_s_parm,
-/*
-	.vidioc_cropcap = dt3155_ioc_cropcap,
-	.vidioc_g_crop = dt3155_ioc_g_crop,
-	.vidioc_s_crop = dt3155_ioc_s_crop,
-	.vidioc_enum_framesizes = dt3155_ioc_enum_framesizes,
-	.vidioc_enum_frameintervals = dt3155_ioc_enum_frameintervals,
-*/
+	.vidioc_streamon = dt3155_streamon,
+	.vidioc_streamoff = dt3155_streamoff,
+	.vidioc_querycap = dt3155_querycap,
+	.vidioc_enum_fmt_vid_cap = dt3155_enum_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap = dt3155_try_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = dt3155_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = dt3155_s_fmt_vid_cap,
+	.vidioc_reqbufs = dt3155_reqbufs,
+	.vidioc_querybuf = dt3155_querybuf,
+	.vidioc_qbuf = dt3155_qbuf,
+	.vidioc_dqbuf = dt3155_dqbuf,
+	.vidioc_querystd = dt3155_querystd,
+	.vidioc_g_std = dt3155_g_std,
+	.vidioc_s_std = dt3155_s_std,
+	.vidioc_enum_input = dt3155_enum_input,
+	.vidioc_g_input = dt3155_g_input,
+	.vidioc_s_input = dt3155_s_input,
+	.vidioc_g_parm = dt3155_g_parm,
+	.vidioc_s_parm = dt3155_s_parm,
 };
 
-static int
-dt3155_init_board(struct pci_dev *pdev)
+static int dt3155_init_board(struct pci_dev *pdev)
 {
 	struct dt3155_priv *pd = pci_get_drvdata(pdev);
 	void *buf_cpu;
@@ -737,7 +671,7 @@ dt3155_init_board(struct pci_dev *pdev)
 	mmiowb();
 	msleep(20);
 
-	/*  initializing adaper registers  */
+	/*  initializing adapter registers  */
 	iowrite32(FIFO_EN | SRST, pd->regs + CSR1);
 	mmiowb();
 	iowrite32(0xEEEEEE01, pd->regs + EVEN_PIXEL_FMT);
@@ -837,8 +771,7 @@ struct dma_coherent_mem {
 	unsigned long	*bitmap;
 };
 
-static int
-dt3155_alloc_coherent(struct device *dev, size_t size, int flags)
+static int dt3155_alloc_coherent(struct device *dev, size_t size, int flags)
 {
 	struct dma_coherent_mem *mem;
 	dma_addr_t dev_base;
@@ -878,8 +811,7 @@ out:
 	return 0;
 }
 
-static void
-dt3155_free_coherent(struct device *dev)
+static void dt3155_free_coherent(struct device *dev)
 {
 	struct dma_coherent_mem *mem = dev->dma_mem;
 
@@ -892,8 +824,7 @@ dt3155_free_coherent(struct device *dev)
 	kfree(mem);
 }
 
-static int
-dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int err;
 	struct dt3155_priv *pd;
@@ -948,8 +879,7 @@ err_req_region:
 	return err;
 }
 
-static void
-dt3155_remove(struct pci_dev *pdev)
+static void dt3155_remove(struct pci_dev *pdev)
 {
 	struct dt3155_priv *pd = pci_get_drvdata(pdev);
 
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.h b/drivers/staging/media/dt3155v4l/dt3155v4l.h
index 96f01a0..5aeee75 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.h
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.h
@@ -12,18 +12,12 @@
  *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
  *   GNU General Public License for more details.                          *
  *                                                                         *
- *   You should have received a copy of the GNU General Public License     *
- *   along with this program; if not, write to the                         *
- *   Free Software Foundation, Inc.,                                       *
- *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
  ***************************************************************************/
 
 /*    DT3155 header file    */
 #ifndef _DT3155_H_
 #define _DT3155_H_
 
-#ifdef __KERNEL__
-
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 
@@ -207,6 +201,4 @@ struct dt3155_priv {
 	u8 csr2, config;
 };
 
-#endif /*  __KERNEL__  */
-
 #endif /*  _DT3155_H_  */
-- 
2.1.4


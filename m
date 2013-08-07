Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55600 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223Ab3HGSxT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:19 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 16/16] msi3101: a lot of small cleanups
Date: Wed,  7 Aug 2013 21:51:47 +0300
Message-Id: <1375901507-26661-17-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 141 ++++++++--------------------
 1 file changed, 40 insertions(+), 101 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index e7a21a2..a3cc4c6 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -16,20 +16,36 @@
  *    You should have received a copy of the GNU General Public License along
  *    with this program; if not, write to the Free Software Foundation, Inc.,
  *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * That driver is somehow based of pwc driver:
+ *  (C) 1999-2004 Nemosoft Unv.
+ *  (C) 2004-2006 Luc Saillard (luc@saillard.org)
+ *  (C) 2011 Hans de Goede <hdegoede@redhat.com>
+ *
+ * Development tree of that driver will be on:
+ * http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/mirics
+ *
+ * GNU Radio plugin "gr-kernel" for device usage will be on:
+ * http://git.linuxtv.org/anttip/gr-kernel.git
+ *
+ * TODO:
+ * I will look these:
+ * - split RF tuner and USB ADC interface to own drivers (msi2500 and msi001)
+ * - move controls to V4L2 API
+ *
+ * Help is very highly welcome for these + all the others you could imagine:
+ * - use libv4l2 for stream format conversions
+ * - gr-kernel: switch to v4l2_mmap (current read eats a lot of cpu)
+ * - SDRSharp support
  */
 
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/input.h>
-#include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 #include <linux/usb.h>
-#include <linux/mutex.h>
 #include <media/videobuf2-vmalloc.h>
 
 struct msi3101_gain {
@@ -358,9 +374,9 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
 #define ISO_FRAMES_PER_DESC     (8)
 #define ISO_MAX_FRAME_SIZE      (3 * 1024)
 #define ISO_BUFFER_SIZE         (ISO_FRAMES_PER_DESC * ISO_MAX_FRAME_SIZE)
-
 #define MAX_ISOC_ERRORS         20
 
+/* TODO: These should be moved to V4L2 API */
 #define MSI3101_CID_SAMPLING_MODE         ((V4L2_CID_USER_BASE | 0xf000) + 0)
 #define MSI3101_CID_SAMPLING_RATE         ((V4L2_CID_USER_BASE | 0xf000) + 1)
 #define MSI3101_CID_SAMPLING_RESOLUTION   ((V4L2_CID_USER_BASE | 0xf000) + 2)
@@ -373,8 +389,6 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
 struct msi3101_frame_buf {
 	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
-	void *data;             /* raw data from USB device */
-	int filled;             /* number of bytes filled to *data */
 };
 
 struct msi3101_state {
@@ -478,14 +492,19 @@ leave:
  */
 
 /*
- * Converts signed 10-bit integer into 32-bit IEEE floating point
- * representation.
- * Will be exact from 0 to 2^24.  Above that, we round towards zero
- * as the fractional bits will not fit in a float.  (It would be better to
- * round towards even as the fpu does, but that is slower.)
+ * Integer to 32-bit IEEE floating point representation routine is taken
+ * from Radeon R600 driver (drivers/gpu/drm/radeon/r600_blit_kms.c).
+ *
+ * TODO: Currently we do conversion here in Kernel, but in future that will
+ * be moved to the libv4l2 library as video format conversions are.
  */
 #define I2F_FRAC_BITS  23
 #define I2F_MASK ((1 << I2F_FRAC_BITS) - 1)
+
+/*
+ * Converts signed ~10+3-bit integer into 32-bit IEEE floating point
+ * representation.
+ */
 static u32 msi3101_convert_sample_384(struct msi3101_state *s, u16 x, int shift)
 {
 	u32 msb, exponent, fraction, sign;
@@ -510,35 +529,26 @@ static u32 msi3101_convert_sample_384(struct msi3101_state *s, u16 x, int shift)
 	/* Get location of the most significant bit */
 	msb = __fls(x);
 
-	/*
-	 * Use a rotate instead of a shift because that works both leftwards
-	 * and rightwards due to the mod(32) behaviour.  This means we don't
-	 * need to check to see if we are above 2^24 or not.
-	 */
 	fraction = ror32(x, (msb - I2F_FRAC_BITS) & 0x1f) & I2F_MASK;
 	exponent = (127 + msb) << I2F_FRAC_BITS;
 
 	return (fraction + exponent) | sign;
 }
 
-#define MSI3101_CONVERT_IN_URB_HANDLER
-#define MSI3101_EXTENSIVE_DEBUG
 static int msi3101_convert_stream_384(struct msi3101_state *s, u32 *dst,
 		u8 *src, unsigned int src_len)
 {
 	int i, j, k, l, i_max, dst_len = 0;
 	u16 sample[4];
 	u32 bits;
-#ifdef MSI3101_EXTENSIVE_DEBUG
 	u32 sample_num[3];
-#endif
+
 	/* There could be 1-3 1024 bytes URB frames */
 	i_max = src_len / 1024;
 	for (i = 0; i < i_max; i++) {
-#ifdef MSI3101_EXTENSIVE_DEBUG
 		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
 		if (i == 0 && s->next_sample != sample_num[0]) {
-			dev_dbg(&s->udev->dev,
+			dev_dbg_ratelimited(&s->udev->dev,
 					"%d samples lost, %d %08x:%08x\n",
 					sample_num[0] - s->next_sample,
 					src_len, s->next_sample, sample_num[0]);
@@ -550,9 +560,7 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u32 *dst,
 		 */
 		dev_dbg_ratelimited(&s->udev->dev,
 				"%*ph  %*ph\n", 12, &src[4], 24, &src[1000]);
-		memset(&src[4], 0, 12);
-		memset(&src[1000], 0, 24);
-#endif
+
 		src += 16;
 		for (j = 0; j < 6; j++) {
 			bits = src[160 + 3] << 24 | src[160 + 2] << 16 | src[160 + 1] << 8 | src[160 + 0] << 0;
@@ -567,22 +575,18 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u32 *dst,
 					*dst++ = msi3101_convert_sample_384(s, sample[1], (bits >> (2 * k)) & 0x3);
 					*dst++ = msi3101_convert_sample_384(s, sample[2], (bits >> (2 * k)) & 0x3);
 					*dst++ = msi3101_convert_sample_384(s, sample[3], (bits >> (2 * k)) & 0x3);
-
-					/* 4 x 32bit float samples */
-					dst_len += 4 * 4;
 				}
 				src += 10;
 			}
-#ifdef MSI3101_EXTENSIVE_DEBUG
 			dev_dbg_ratelimited(&s->udev->dev,
 					"sample control bits %08x\n", bits);
-#endif
 			src += 4;
 		}
+		/* 384 x I+Q 32bit float samples */
+		dst_len += 384 * 2 * 4;
 		src += 24;
 	}
 
-#ifdef MSI3101_EXTENSIVE_DEBUG
 	/* calculate samping rate and output it in 10 seconds intervals */
 	if ((s->jiffies + msecs_to_jiffies(10000)) <= jiffies) {
 		unsigned long jiffies_now = jiffies;
@@ -600,7 +604,7 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u32 *dst,
 
 	/* next sample (sample = sample + i * 384) */
 	s->next_sample = sample_num[i_max - 1] + 384;
-#endif
+
 	return dst_len;
 }
 
@@ -628,11 +632,6 @@ static u32 msi3101_convert_sample_336(struct msi3101_state *s, u16 x)
 	/* Get location of the most significant bit */
 	msb = __fls(x);
 
-	/*
-	 * Use a rotate instead of a shift because that works both leftwards
-	 * and rightwards due to the mod(32) behaviour.  This means we don't
-	 * need to check to see if we are above 2^24 or not.
-	 */
 	fraction = ror32(x, (msb - I2F_FRAC_BITS) & 0x1f) & I2F_MASK;
 	exponent = (127 + msb) << I2F_FRAC_BITS;
 
@@ -699,12 +698,7 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u32 *dst,
 /*
  * Converts signed 14-bit integer into 32-bit IEEE floating point
  * representation.
- * Will be exact from 0 to 2^24.  Above that, we round towards zero
- * as the fractional bits will not fit in a float.  (It would be better to
- * round towards even as the fpu does, but that is slower.)
  */
-#define I2F_FRAC_BITS  23
-#define I2F_MASK ((1 << I2F_FRAC_BITS) - 1)
 static u32 msi3101_convert_sample_252(struct msi3101_state *s, u16 x)
 {
 	u32 msb, exponent, fraction, sign;
@@ -725,11 +719,6 @@ static u32 msi3101_convert_sample_252(struct msi3101_state *s, u16 x)
 	/* Get location of the most significant bit */
 	msb = __fls(x);
 
-	/*
-	 * Use a rotate instead of a shift because that works both leftwards
-	 * and rightwards due to the mod(32) behaviour.  This means we don't
-	 * need to check to see if we are above 2^24 or not.
-	 */
 	fraction = ror32(x, (msb - I2F_FRAC_BITS) & 0x1f) & I2F_MASK;
 	exponent = (127 + msb) << I2F_FRAC_BITS;
 
@@ -832,7 +821,7 @@ static void msi3101_isoc_handler(struct urb *urb)
 		/* Check frame error */
 		fstatus = urb->iso_frame_desc[i].status;
 		if (fstatus) {
-			dev_dbg(&s->udev->dev,
+			dev_dbg_ratelimited(&s->udev->dev,
 					"frame=%d/%d has error %d skipping\n",
 					i, urb->number_of_packets, fstatus);
 			goto skip;
@@ -856,14 +845,9 @@ static void msi3101_isoc_handler(struct urb *urb)
 		}
 
 		/* fill framebuffer */
-#ifdef MSI3101_CONVERT_IN_URB_HANDLER
 		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
 		flen = s->convert_stream(s, ptr, iso_buf, flen);
 		vb2_set_plane_payload(&fbuf->vb, 0, flen);
-#else
-		memcpy(fbuf->data, iso_buf, flen);
-		fbuf->filled = flen;
-#endif
 		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
 skip:
 		;
@@ -1063,20 +1047,6 @@ static int msi3101_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static int msi3101_buf_init(struct vb2_buffer *vb)
-{
-	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
-	struct msi3101_frame_buf *fbuf =
-			container_of(vb, struct msi3101_frame_buf, vb);
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
-
-	fbuf->data = vzalloc(ISO_MAX_FRAME_SIZE);
-	if (fbuf->data == NULL)
-		return -ENOMEM;
-
-	return 0;
-}
-
 static int msi3101_buf_prepare(struct vb2_buffer *vb)
 {
 	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
@@ -1088,34 +1058,6 @@ static int msi3101_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-#ifdef MSI3101_CONVERT_IN_URB_HANDLER
-static int msi3101_buf_finish(struct vb2_buffer *vb)
-{
-	return 0;
-}
-#else
-static int msi3101_buf_finish(struct vb2_buffer *vb)
-{
-	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
-	struct msi3101_frame_buf *fbuf =
-			container_of(vb, struct msi3101_frame_buf, vb);
-	int ret;
-	u32 *dst = vb2_plane_vaddr(&fbuf->vb, 0);
-	ret = msi3101_convert_stream_384(s, dst, fbuf->data, fbuf->filled);
-	vb2_set_plane_payload(&fbuf->vb, 0, ret);
-	return 0;
-}
-#endif
-
-static void msi3101_buf_cleanup(struct vb2_buffer *vb)
-{
-	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
-	struct msi3101_frame_buf *buf =
-			container_of(vb, struct msi3101_frame_buf, vb);
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
-
-	vfree(buf->data);
-}
 static void msi3101_buf_queue(struct vb2_buffer *vb)
 {
 	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
@@ -1544,10 +1486,7 @@ static int msi3101_stop_streaming(struct vb2_queue *vq)
 
 static struct vb2_ops msi3101_vb2_ops = {
 	.queue_setup            = msi3101_queue_setup,
-	.buf_init               = msi3101_buf_init,
 	.buf_prepare            = msi3101_buf_prepare,
-	.buf_finish             = msi3101_buf_finish,
-	.buf_cleanup            = msi3101_buf_cleanup,
 	.buf_queue              = msi3101_buf_queue,
 	.start_streaming        = msi3101_start_streaming,
 	.stop_streaming         = msi3101_stop_streaming,
@@ -1862,7 +1801,7 @@ err_free_mem:
 
 /* USB device ID list */
 static struct usb_device_id msi3101_id_table[] = {
-	{ USB_DEVICE(0x1df7, 0x2500) },
+	{ USB_DEVICE(0x1df7, 0x2500) }, /* Mirics MSi3101 SDR Dongle */
 	{ USB_DEVICE(0x2040, 0xd300) }, /* Hauppauge WinTV 133559 LF */
 	{ }
 };
-- 
1.7.11.7


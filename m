Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:47052 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab1KQUJy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 15:09:54 -0500
Date: Thu, 17 Nov 2011 22:09:49 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3][media] Exynos4 JPEG codec v4l2 driver
Message-ID: <20111117200949.GA27136@valkosipuli.localdomain>
References: <1321522871-9222-1-git-send-email-andrzej.p@samsung.com>
 <4EC5410C.6050407@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC5410C.6050407@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 17, 2011 at 06:14:52PM +0100, Tomasz Stanislawski wrote:
> Hi Andrzej,

Hi Andrzej and Tomasz,

Thanks for the patch. I have a few more minor comments below.

> Please take a look on some comments below. You have done a great
> work, thanks for using selection API.

I fully agree. Thanks, Andrzej!

> On 11/17/2011 10:41 AM, Andrzej Pietrasiewicz wrote:
...
> >+static const struct v4l2_file_operations s5p_jpeg_fops = {
> >+	.owner		= THIS_MODULE,
> >+	.open		= s5p_jpeg_open,
> >+	.release	= s5p_jpeg_release,
> >+	.poll		= s5p_jpeg_poll,
> >+	.unlocked_ioctl	= video_ioctl2,
> >+	.mmap		= s5p_jpeg_mmap,
> >+};
> >+
> >+/*
> >+ * ============================================================================
> >+ * video ioctl operations
> >+ * ============================================================================
> >+ */
> >+
> >+static int get_byte(struct s5p_jpeg_buffer *buf)
> >+{
> >+	if (buf->curr>= buf->size)
> 
> space before >= is needed. Did checkpatch detect it?

I see that in a number of other places as well.

> >+		return -1;
> >+
> >+	return ((unsigned char *)buf->data)[buf->curr++];
> >+}
> >+
> >+static int get_word_be(struct s5p_jpeg_buffer *buf, unsigned int *word)
> >+{
> >+	unsigned int temp;
> >+	int byte;
> >+
> >+	byte = get_byte(buf);
> >+	if (byte == -1)
> 
> Maybe you should decrement buf->curr to retrieve previous buffer state.
> 
> >+		return -1;
> >+	temp = byte<<  8;
> >+	byte = get_byte(buf);
> >+	if (byte == -1)
> 
> [as above]
> 
> >+		return -1;
> >+	*word = (unsigned int)byte | temp;
> >+	return 0;
> >+}
> >+
> >+static void skip(struct s5p_jpeg_buffer *buf, long len)
> >+{
> >+	int c;
> >+
> >+	while (len>  0) {
> >+		c = get_byte(buf);
> >+		len--;
> >+	}
> 
> try:
> while (len--)
> 	get_byte(buf);

If you are certain len can't be actually less than zero, then yes.

What is the variable c being used for?

...

> >+static int vidioc_g_fmt(struct s5p_jpeg_ctx *ctx, struct v4l2_format *f)
> >+{
> >+	struct vb2_queue *vq;
> >+	struct s5p_jpeg_q_data *q_data = NULL;
> >+	struct v4l2_pix_format *pix =&f->fmt.pix;
> >+
> >+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> >+	if (!vq)
> >+		return -EINVAL;
> >+
> >+	switch (f->type) {
> >+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> >+		q_data =&ctx->out_q;
> >+		break;
> >+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> >+		if (ctx->mode == S5P_JPEG_DECODE&&  !ctx->hdr_parsed)
> >+			return -EINVAL;
> >+		q_data =&ctx->cap_q;
> >+		break;
> >+	default:
> 
> Should -EINVAL be returned here?

I'd rather BUG(). See below.

> >+		;
> >+	}
> >+	pix->width = q_data->w;
> >+	pix->height = q_data->h;
> >+	pix->field = V4L2_FIELD_NONE;
> >+	pix->pixelformat = q_data->fmt->fourcc;
> >+	if (q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG)
> >+		pix->bytesperline = (q_data->w * q_data->fmt->depth)>>  3;
> 
> According to spec the size of the largest plane should be used here.
> For YUV420 it should be luminance plane. Its size is equal to
> q_data->w bytes. 50% bigger value is returned by formula above.
> 
> 
> >+	else
> >+		pix->bytesperline = 0;
> >+	pix->sizeimage = q_data->size;
> >+
> >+	return 0;
> >+}
> >+
> >+static int s5p_jpeg_g_fmt_vid_cap(struct file *file, void *priv,
> >+				struct v4l2_format *f)
> >+{
> >+	return vidioc_g_fmt(priv, f);
> >+}
> >+
> >+static int s5p_jpeg_g_fmt_vid_out(struct file *file, void *priv,
> >+				struct v4l2_format *f)
> >+{
> >+	return vidioc_g_fmt(priv, f);
> >+}

You should define vidioc_g_fmt() so the prototype matches what the op struct
expects and use that function in the ops struct. The above two functions are
useless.

...

> >+static int vidioc_s_fmt(struct s5p_jpeg_ctx *ctx, struct v4l2_format *f)
> Function name is confusing. The name vidioc_s_fmt is used in struct
> v4l2_ioctl_ops, suggesting that is this function is implementation
> of this callback.
> >+{
> >+	struct vb2_queue *vq;
> >+	struct s5p_jpeg_q_data *q_data = NULL;
> >+	struct v4l2_pix_format *pix =&f->fmt.pix;
> >+
> >+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> >+	if (!vq)
> >+		return -EINVAL;
> >+
> >+	switch (f->type) {
> >+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> >+		q_data =&ctx->out_q;
> >+		break;
> >+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> >+		q_data =&ctx->cap_q;
> >+		break;
> >+	default:
> Returning -EINVAL, or generating WARN/BUG is better than getting
> kernel fault few lines below.

WARN() isn't an option since the pointer is NULL and it'll be accessed very
soon. I don't think it's possible to get here in the first place, so BUG()
might be just the best option here.

...

> >+}
> >+
> >+static inline int jpeg_compressed_size(void __iomem *regs)
> >+{
> >+	unsigned long jpeg_size = 0;
> >+
> >+	jpeg_size |= (readl(regs + S5P_JPGCNT_U)&  0xff)<<  16;
> >+	jpeg_size |= (readl(regs + S5P_JPGCNT_M)&  0xff)<<  8;
> >+	jpeg_size |= (readl(regs + S5P_JPGCNT_L)&  0xff);
> 
> Use readb here and in many cases above.

If the hardware allows byte access to the register. Is it possible that it
doesn't?

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk

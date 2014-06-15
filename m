Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53798 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaFOJkH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 05:40:07 -0400
Message-ID: <539D69E7.4030800@iki.fi>
Date: Sun, 15 Jun 2014 12:39:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Ovidiu Toader <ovi@phas.ubc.ca>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] staging/media/rtl2832u_sdr: fix coding style problems
 by adding blank lines
References: <538D18EE.6070509@phas.ubc.ca>
In-Reply-To: <538D18EE.6070509@phas.ubc.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

Mauro, pick that from patchwork to 3.16. I am not going to PULL request it.

Antti

On 06/03/2014 03:38 AM, Ovidiu Toader wrote:
> This minor patch fixes all WARNING:SPACING style warnings in rtl2832_sdr.c
>
> The new version of the file pleases checkpatch.pl when run with "--ignore LONG_LINE".
>
> Signed-off-by: Ovidiu Toader <ovi@phas.ubc.ca>
> ---
> Changes since v1:
>   * made commit brief description clearer
>
>   drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
>
> diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> index 093df6b..3b80637 100644
> --- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> +++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> @@ -348,6 +348,7 @@ static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_state *s,
>   		/* convert u8 to u16 */
>   		unsigned int i;
>   		u16 *u16dst = dst;
> +
>   		for (i = 0; i < src_len; i++)
>   			*u16dst++ = (src[i] << 8) | (src[i] >> 0);
>   		dst_len = 2 * src_len;
> @@ -359,6 +360,7 @@ static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_state *s,
>   	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
>   #define MSECS 10000UL
>   		unsigned int samples = s->sample - s->sample_measured;
> +
>   		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
>   		s->sample_measured = s->sample;
>   		dev_dbg(&s->udev->dev,
> @@ -560,11 +562,13 @@ static int rtl2832_sdr_alloc_urbs(struct rtl2832_sdr_state *s)
>   static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_state *s)
>   {
>   	unsigned long flags = 0;
> +
>   	dev_dbg(&s->udev->dev, "%s:\n", __func__);
>
>   	spin_lock_irqsave(&s->queued_bufs_lock, flags);
>   	while (!list_empty(&s->queued_bufs)) {
>   		struct rtl2832_sdr_frame_buf *buf;
> +
>   		buf = list_entry(s->queued_bufs.next,
>   				struct rtl2832_sdr_frame_buf, list);
>   		list_del(&buf->list);
> @@ -577,6 +581,7 @@ static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_state *s)
>   static void rtl2832_sdr_release_sec(struct dvb_frontend *fe)
>   {
>   	struct rtl2832_sdr_state *s = fe->sec_priv;
> +
>   	dev_dbg(&s->udev->dev, "%s:\n", __func__);
>
>   	mutex_lock(&s->vb_queue_lock);
> @@ -598,6 +603,7 @@ static int rtl2832_sdr_querycap(struct file *file, void *fh,
>   		struct v4l2_capability *cap)
>   {
>   	struct rtl2832_sdr_state *s = video_drvdata(file);
> +
>   	dev_dbg(&s->udev->dev, "%s:\n", __func__);
>
>   	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
> @@ -615,6 +621,7 @@ static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
>   		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
>   {
>   	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vq);
> +
>   	dev_dbg(&s->udev->dev, "%s: *nbuffers=%d\n", __func__, *nbuffers);
>
>   	/* Need at least 8 buffers */
> @@ -665,6 +672,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
>   	u8 buf[4], u8tmp1, u8tmp2;
>   	u64 u64tmp;
>   	u32 u32tmp;
> +
>   	dev_dbg(&s->udev->dev, "%s: f_adc=%u\n", __func__, s->f_adc);
>
>   	if (!test_bit(POWER_ON, &s->flags))
> @@ -987,6 +995,7 @@ static int rtl2832_sdr_start_streaming(struct vb2_queue *vq, unsigned int count)
>   {
>   	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vq);
>   	int ret;
> +
>   	dev_dbg(&s->udev->dev, "%s:\n", __func__);
>
>   	if (!s->udev)
> @@ -1035,6 +1044,7 @@ err:
>   static void rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
>   {
>   	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vq);
> +
>   	dev_dbg(&s->udev->dev, "%s:\n", __func__);
>
>   	mutex_lock(&s->v4l2_lock);
> @@ -1068,6 +1078,7 @@ static int rtl2832_sdr_g_tuner(struct file *file, void *priv,
>   		struct v4l2_tuner *v)
>   {
>   	struct rtl2832_sdr_state *s = video_drvdata(file);
> +
>   	dev_dbg(&s->udev->dev, "%s: index=%d type=%d\n",
>   			__func__, v->index, v->type);
>
> @@ -1094,6 +1105,7 @@ static int rtl2832_sdr_s_tuner(struct file *file, void *priv,
>   		const struct v4l2_tuner *v)
>   {
>   	struct rtl2832_sdr_state *s = video_drvdata(file);
> +
>   	dev_dbg(&s->udev->dev, "%s:\n", __func__);
>
>   	if (v->index > 1)
> @@ -1105,6 +1117,7 @@ static int rtl2832_sdr_enum_freq_bands(struct file *file, void *priv,
>   		struct v4l2_frequency_band *band)
>   {
>   	struct rtl2832_sdr_state *s = video_drvdata(file);
> +
>   	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
>   			__func__, band->tuner, band->type, band->index);
>
> @@ -1130,6 +1143,7 @@ static int rtl2832_sdr_g_frequency(struct file *file, void *priv,
>   {
>   	struct rtl2832_sdr_state *s = video_drvdata(file);
>   	int ret  = 0;
> +
>   	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",
>   			__func__, f->tuner, f->type);
>
> @@ -1193,6 +1207,7 @@ static int rtl2832_sdr_enum_fmt_sdr_cap(struct file *file, void *priv,
>   		struct v4l2_fmtdesc *f)
>   {
>   	struct rtl2832_sdr_state *s = video_drvdata(file);
> +
>   	dev_dbg(&s->udev->dev, "%s:\n", __func__);
>
>   	if (f->index >= NUM_FORMATS)
> @@ -1208,6 +1223,7 @@ static int rtl2832_sdr_g_fmt_sdr_cap(struct file *file, void *priv,
>   		struct v4l2_format *f)
>   {
>   	struct rtl2832_sdr_state *s = video_drvdata(file);
> +
>   	dev_dbg(&s->udev->dev, "%s:\n", __func__);
>
>   	f->fmt.sdr.pixelformat = s->pixelformat;
> @@ -1222,6 +1238,7 @@ static int rtl2832_sdr_s_fmt_sdr_cap(struct file *file, void *priv,
>   	struct rtl2832_sdr_state *s = video_drvdata(file);
>   	struct vb2_queue *q = &s->vb_queue;
>   	int i;
> +
>   	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
>   			(char *)&f->fmt.sdr.pixelformat);
>
> @@ -1247,6 +1264,7 @@ static int rtl2832_sdr_try_fmt_sdr_cap(struct file *file, void *priv,
>   {
>   	struct rtl2832_sdr_state *s = video_drvdata(file);
>   	int i;
> +
>   	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
>   			(char *)&f->fmt.sdr.pixelformat);
>
> @@ -1316,6 +1334,7 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
>   	struct dvb_frontend *fe = s->fe;
>   	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>   	int ret;
> +
>   	dev_dbg(&s->udev->dev,
>   			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
>   			__func__, ctrl->id, ctrl->name, ctrl->val,
> @@ -1329,6 +1348,7 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
>   			/* Round towards the closest legal value */
>   			s32 val = s->f_adc + s->bandwidth->step / 2;
>   			u32 offset;
> +
>   			val = clamp(val, s->bandwidth->minimum, s->bandwidth->maximum);
>   			offset = val - s->bandwidth->minimum;
>   			offset = s->bandwidth->step * (offset / s->bandwidth->step);
> -- 1.9.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596Ab2EJING (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 04:13:06 -0400
Message-ID: <4FAB7893.70502@redhat.com>
Date: Thu, 10 May 2012 10:13:07 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 4/5] v4l2-ioctl: handle priority handling based
 on a table lookup.
References: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl> <709bf32842e9ded2d051e3821a2f410c21e9a037.1336632433.git.hans.verkuil@cisco.com>
In-Reply-To: <709bf32842e9ded2d051e3821a2f410c21e9a037.1336632433.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Looks good, ack.

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


On 05/10/2012 09:05 AM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Rather than checking the priority for each ioctl that needs to, just mark
> such ioctls in the table and do it only once.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   drivers/media/video/v4l2-ioctl.c |  181 +++++++++-----------------------------
>   1 file changed, 40 insertions(+), 141 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 21da16d..8d2fdeb 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -189,6 +189,8 @@ struct v4l2_ioctl_info {
>   	const char * const name;
>   };
>
> +/* This control needs a priority check */
> +#define INFO_FL_PRIO	(1<<  0)
>   /* This control can be valid if the filehandle passes a control handler. */
>   #define INFO_FL_CTRL	(1<<  1)
>
> @@ -202,80 +204,82 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
>   	IOCTL_INFO(VIDIOC_QUERYCAP, 0),
>   	IOCTL_INFO(VIDIOC_ENUM_FMT, 0),
>   	IOCTL_INFO(VIDIOC_G_FMT, 0),
> -	IOCTL_INFO(VIDIOC_S_FMT, 0),
> -	IOCTL_INFO(VIDIOC_REQBUFS, 0),
> +	IOCTL_INFO(VIDIOC_S_FMT, INFO_FL_PRIO),
> +	IOCTL_INFO(VIDIOC_REQBUFS, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_QUERYBUF, 0),
>   	IOCTL_INFO(VIDIOC_G_FBUF, 0),
> -	IOCTL_INFO(VIDIOC_S_FBUF, 0),
> -	IOCTL_INFO(VIDIOC_OVERLAY, 0),
> +	IOCTL_INFO(VIDIOC_S_FBUF, INFO_FL_PRIO),
> +	IOCTL_INFO(VIDIOC_OVERLAY, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_QBUF, 0),
>   	IOCTL_INFO(VIDIOC_DQBUF, 0),
> -	IOCTL_INFO(VIDIOC_STREAMON, 0),
> -	IOCTL_INFO(VIDIOC_STREAMOFF, 0),
> +	IOCTL_INFO(VIDIOC_STREAMON, INFO_FL_PRIO),
> +	IOCTL_INFO(VIDIOC_STREAMOFF, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_G_PARM, 0),
> -	IOCTL_INFO(VIDIOC_S_PARM, 0),
> +	IOCTL_INFO(VIDIOC_S_PARM, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_G_STD, 0),
> -	IOCTL_INFO(VIDIOC_S_STD, 0),
> +	IOCTL_INFO(VIDIOC_S_STD, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_ENUMSTD, 0),
>   	IOCTL_INFO(VIDIOC_ENUMINPUT, 0),
>   	IOCTL_INFO(VIDIOC_G_CTRL, INFO_FL_CTRL),
> -	IOCTL_INFO(VIDIOC_S_CTRL, INFO_FL_CTRL),
> +	IOCTL_INFO(VIDIOC_S_CTRL, INFO_FL_PRIO | INFO_FL_CTRL),
>   	IOCTL_INFO(VIDIOC_G_TUNER, 0),
> -	IOCTL_INFO(VIDIOC_S_TUNER, 0),
> +	IOCTL_INFO(VIDIOC_S_TUNER, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_G_AUDIO, 0),
> -	IOCTL_INFO(VIDIOC_S_AUDIO, 0),
> +	IOCTL_INFO(VIDIOC_S_AUDIO, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_QUERYCTRL, INFO_FL_CTRL),
>   	IOCTL_INFO(VIDIOC_QUERYMENU, INFO_FL_CTRL),
>   	IOCTL_INFO(VIDIOC_G_INPUT, 0),
> -	IOCTL_INFO(VIDIOC_S_INPUT, 0),
> +	IOCTL_INFO(VIDIOC_S_INPUT, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_G_OUTPUT, 0),
> -	IOCTL_INFO(VIDIOC_S_OUTPUT, 0),
> +	IOCTL_INFO(VIDIOC_S_OUTPUT, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_ENUMOUTPUT, 0),
>   	IOCTL_INFO(VIDIOC_G_AUDOUT, 0),
> -	IOCTL_INFO(VIDIOC_S_AUDOUT, 0),
> +	IOCTL_INFO(VIDIOC_S_AUDOUT, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_G_MODULATOR, 0),
> -	IOCTL_INFO(VIDIOC_S_MODULATOR, 0),
> +	IOCTL_INFO(VIDIOC_S_MODULATOR, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_G_FREQUENCY, 0),
> -	IOCTL_INFO(VIDIOC_S_FREQUENCY, 0),
> +	IOCTL_INFO(VIDIOC_S_FREQUENCY, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_CROPCAP, 0),
>   	IOCTL_INFO(VIDIOC_G_CROP, 0),
> -	IOCTL_INFO(VIDIOC_S_CROP, 0),
> +	IOCTL_INFO(VIDIOC_S_CROP, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_G_SELECTION, 0),
> -	IOCTL_INFO(VIDIOC_S_SELECTION, 0),
> +	IOCTL_INFO(VIDIOC_S_SELECTION, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_G_JPEGCOMP, 0),
> -	IOCTL_INFO(VIDIOC_S_JPEGCOMP, 0),
> +	IOCTL_INFO(VIDIOC_S_JPEGCOMP, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_QUERYSTD, 0),
>   	IOCTL_INFO(VIDIOC_TRY_FMT, 0),
>   	IOCTL_INFO(VIDIOC_ENUMAUDIO, 0),
>   	IOCTL_INFO(VIDIOC_ENUMAUDOUT, 0),
>   	IOCTL_INFO(VIDIOC_G_PRIORITY, 0),
> -	IOCTL_INFO(VIDIOC_S_PRIORITY, 0),
> +	IOCTL_INFO(VIDIOC_S_PRIORITY, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP, 0),
>   	IOCTL_INFO(VIDIOC_LOG_STATUS, 0),
>   	IOCTL_INFO(VIDIOC_G_EXT_CTRLS, INFO_FL_CTRL),
> -	IOCTL_INFO(VIDIOC_S_EXT_CTRLS, INFO_FL_CTRL),
> +	IOCTL_INFO(VIDIOC_S_EXT_CTRLS, INFO_FL_PRIO | INFO_FL_CTRL),
>   	IOCTL_INFO(VIDIOC_TRY_EXT_CTRLS, 0),
>   	IOCTL_INFO(VIDIOC_ENUM_FRAMESIZES, 0),
>   	IOCTL_INFO(VIDIOC_ENUM_FRAMEINTERVALS, 0),
>   	IOCTL_INFO(VIDIOC_G_ENC_INDEX, 0),
> -	IOCTL_INFO(VIDIOC_ENCODER_CMD, 0),
> +	IOCTL_INFO(VIDIOC_ENCODER_CMD, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_TRY_ENCODER_CMD, 0),
> -	IOCTL_INFO(VIDIOC_DECODER_CMD, 0),
> +	IOCTL_INFO(VIDIOC_DECODER_CMD, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_TRY_DECODER_CMD, 0),
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>   	IOCTL_INFO(VIDIOC_DBG_S_REGISTER, 0),
>   	IOCTL_INFO(VIDIOC_DBG_G_REGISTER, 0),
> +#endif
>   	IOCTL_INFO(VIDIOC_DBG_G_CHIP_IDENT, 0),
> -	IOCTL_INFO(VIDIOC_S_HW_FREQ_SEEK, 0),
> +	IOCTL_INFO(VIDIOC_S_HW_FREQ_SEEK, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_ENUM_DV_PRESETS, 0),
> -	IOCTL_INFO(VIDIOC_S_DV_PRESET, 0),
> +	IOCTL_INFO(VIDIOC_S_DV_PRESET, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_G_DV_PRESET, 0),
>   	IOCTL_INFO(VIDIOC_QUERY_DV_PRESET, 0),
> -	IOCTL_INFO(VIDIOC_S_DV_TIMINGS, 0),
> +	IOCTL_INFO(VIDIOC_S_DV_TIMINGS, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_G_DV_TIMINGS, 0),
>   	IOCTL_INFO(VIDIOC_DQEVENT, 0),
>   	IOCTL_INFO(VIDIOC_SUBSCRIBE_EVENT, 0),
>   	IOCTL_INFO(VIDIOC_UNSUBSCRIBE_EVENT, 0),
> -	IOCTL_INFO(VIDIOC_CREATE_BUFS, 0),
> +	IOCTL_INFO(VIDIOC_CREATE_BUFS, INFO_FL_PRIO),
>   	IOCTL_INFO(VIDIOC_PREPARE_BUF, 0),
>   };
>   #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
> @@ -509,7 +513,6 @@ static long __video_do_ioctl(struct file *file,
>   	void *fh = file->private_data;
>   	struct v4l2_fh *vfh = NULL;
>   	int use_fh_prio = 0;
> -	long ret_prio = 0;
>   	long ret = -ENOTTY;
>
>   	if (ops == NULL) {
> @@ -521,8 +524,6 @@ static long __video_do_ioctl(struct file *file,
>   	if (test_bit(V4L2_FL_USES_V4L2_FH,&vfd->flags)) {
>   		vfh = file->private_data;
>   		use_fh_prio = test_bit(V4L2_FL_USE_FH_PRIO,&vfd->flags);
> -		if (use_fh_prio)
> -			ret_prio = v4l2_prio_check(vfd->prio, vfh->prio);
>   	}
>
>   	if (v4l2_is_valid_ioctl(cmd)) {
> @@ -533,6 +534,11 @@ static long __video_do_ioctl(struct file *file,
>   			    !(vfh&&  vfh->ctrl_handler))
>   				return -ENOTTY;
>   		}
> +		if (use_fh_prio&&  (info->flags&  INFO_FL_PRIO)) {
> +			ret = v4l2_prio_check(vfd->prio, vfh->prio);
> +			if (ret)
> +				return ret;
> +		}
>   	}
>
>   	if ((vfd->debug&  V4L2_DEBUG_IOCTL)&&
> @@ -581,14 +587,11 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		enum v4l2_priority *p = arg;
>
> -		if (!ops->vidioc_s_priority&&  !use_fh_prio)
> -			break;
>   		dbgarg(cmd, "setting priority to %d\n", *p);
>   		if (ops->vidioc_s_priority)
>   			ret = ops->vidioc_s_priority(file, fh, *p);
>   		else
> -			ret = ret_prio ? ret_prio :
> -				v4l2_prio_change(&vfd->v4l2_dev->prio,
> +			ret = v4l2_prio_change(&vfd->v4l2_dev->prio,
>   							&vfh->prio, *p);
>   		break;
>   	}
> @@ -717,10 +720,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_format *f = (struct v4l2_format *)arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		ret = -EINVAL;
>
>   		/* FIXME: Should be one dump per type */
> @@ -887,10 +886,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_requestbuffers *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		ret = check_fmt(ops, p->type);
>   		if (ret)
>   			break;
> @@ -948,10 +943,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		int *i = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		dbgarg(cmd, "value=%d\n", *i);
>   		ret = ops->vidioc_overlay(file, fh, *i);
>   		break;
> @@ -973,10 +964,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_framebuffer *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		dbgarg(cmd, "capability=0x%x, flags=%d, base=0x%08lx\n",
>   			p->capability, p->flags, (unsigned long)p->base);
>   		v4l_print_pix_fmt(vfd,&p->fmt);
> @@ -987,10 +974,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		enum v4l2_buf_type i = *(int *)arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		dbgarg(cmd, "type=%s\n", prt_names(i, v4l2_type_names));
>   		ret = ops->vidioc_streamon(file, fh, i);
>   		break;
> @@ -999,10 +982,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		enum v4l2_buf_type i = *(int *)arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		dbgarg(cmd, "type=%s\n", prt_names(i, v4l2_type_names));
>   		ret = ops->vidioc_streamoff(file, fh, i);
>   		break;
> @@ -1072,10 +1051,6 @@ static long __video_do_ioctl(struct file *file,
>
>   		dbgarg(cmd, "std=%08Lx\n", (long long unsigned)*id);
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		ret = -EINVAL;
>   		norm = (*id)&  vfd->tvnorms;
>   		if (vfd->tvnorms&&  !norm)	/* Check if std is supported */
> @@ -1150,10 +1125,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		unsigned int *i = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		dbgarg(cmd, "value=%d\n", *i);
>   		ret = ops->vidioc_s_input(file, fh, *i);
>   		break;
> @@ -1199,10 +1170,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		unsigned int *i = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		dbgarg(cmd, "value=%d\n", *i);
>   		ret = ops->vidioc_s_output(file, fh, *i);
>   		break;
> @@ -1272,10 +1239,6 @@ static long __video_do_ioctl(struct file *file,
>   		if (!(vfh&&  vfh->ctrl_handler)&&  !vfd->ctrl_handler&&
>   			!ops->vidioc_s_ctrl&&  !ops->vidioc_s_ext_ctrls)
>   			break;
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>
>   		dbgarg(cmd, "id=0x%x, value=%d\n", p->id, p->value);
>
> @@ -1331,10 +1294,6 @@ static long __video_do_ioctl(struct file *file,
>   		if (!(vfh&&  vfh->ctrl_handler)&&  !vfd->ctrl_handler&&
>   				!ops->vidioc_s_ext_ctrls)
>   			break;
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		v4l_print_ext_ctrls(cmd, vfd, p, 1);
>   		if (vfh&&  vfh->ctrl_handler)
>   			ret = v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
> @@ -1416,10 +1375,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_audio *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		dbgarg(cmd, "index=%d, name=%s, capability=0x%x, "
>   					"mode=0x%x\n", p->index, p->name,
>   					p->capability, p->mode);
> @@ -1453,10 +1408,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_audioout *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		dbgarg(cmd, "index=%d, name=%s, capability=%d, "
>   					"mode=%d\n", p->index, p->name,
>   					p->capability, p->mode);
> @@ -1482,10 +1433,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_modulator *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		dbgarg(cmd, "index=%d, name=%s, capability=%d, "
>   				"rangelow=%d, rangehigh=%d, txsubchans=%d\n",
>   				p->index, p->name, p->capability, p->rangelow,
> @@ -1528,10 +1475,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_crop *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
>   		dbgrect(vfd, "",&p->c);
>
> @@ -1569,10 +1512,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_selection *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>
>   		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
>   		dbgrect(vfd, "",&p->r);
> @@ -1641,10 +1580,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_jpegcompression *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		dbgarg(cmd, "quality=%d, APPn=%d, APP_len=%d, "
>   					"COM_len=%d, jpeg_markers=%d\n",
>   					p->quality, p->APPn, p->APP_len,
> @@ -1666,10 +1601,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_encoder_cmd *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		ret = ops->vidioc_encoder_cmd(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
> @@ -1688,10 +1619,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_decoder_cmd *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		ret = ops->vidioc_decoder_cmd(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
> @@ -1737,10 +1664,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_streamparm *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		ret = check_fmt(ops, p->type);
>   		if (ret)
>   			break;
> @@ -1771,10 +1694,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_tuner *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>   			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>   		dbgarg(cmd, "index=%d, name=%s, type=%d, "
> @@ -1805,10 +1724,6 @@ static long __video_do_ioctl(struct file *file,
>   		struct v4l2_frequency *p = arg;
>   		enum v4l2_tuner_type type;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>   			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>   		dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",
> @@ -1883,10 +1798,6 @@ static long __video_do_ioctl(struct file *file,
>   		struct v4l2_hw_freq_seek *p = arg;
>   		enum v4l2_tuner_type type;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>   			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>   		dbgarg(cmd,
> @@ -1980,11 +1891,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_dv_preset *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
> -
>   		dbgarg(cmd, "preset=%d\n", p->preset);
>   		ret = ops->vidioc_s_dv_preset(file, fh, p);
>   		break;
> @@ -2011,11 +1917,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_dv_timings *p = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
> -
>   		switch (p->type) {
>   		case V4L2_DV_BT_656_1120:
>   			dbgarg2("bt-656/1120:interlaced=%d, pixelclock=%lld,"
> @@ -2114,10 +2015,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_create_buffers *create = arg;
>
> -		if (ret_prio) {
> -			ret = ret_prio;
> -			break;
> -		}
>   		ret = check_fmt(ops, create->format.type);
>   		if (ret)
>   			break;
> @@ -2143,7 +2040,9 @@ static long __video_do_ioctl(struct file *file,
>   	default:
>   		if (!ops->vidioc_default)
>   			break;
> -		ret = ops->vidioc_default(file, fh, ret_prio>= 0, cmd, arg);
> +		ret = ops->vidioc_default(file, fh, use_fh_prio ?
> +				v4l2_prio_check(vfd->prio, vfh->prio)>= 0 : 0,
> +				cmd, arg);
>   		break;
>   	} /* switch */
>

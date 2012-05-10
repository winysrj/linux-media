Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab2EJIKV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 04:10:21 -0400
Message-ID: <4FAB77ED.9000105@redhat.com>
Date: Thu, 10 May 2012 10:10:21 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 2/5] v4l2-dev/ioctl: determine the valid ioctls
 upfront.
References: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl> <e75979b946d3934cbfb12e8b5518bcbbb891ceee.1336632433.git.hans.verkuil@cisco.com>
In-Reply-To: <e75979b946d3934cbfb12e8b5518bcbbb891ceee.1336632433.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Comments inline.

On 05/10/2012 09:05 AM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
>
> Rather than testing whether an ioctl is implemented in the driver or not
> every time the ioctl is called, do it upfront when the device is registered.
>
> This also allows a driver to disable certain ioctls based on the capabilities
> of the detected board, something you can't do today without creating separate
> v4l2_ioctl_ops structs for each new variation.
>
> For the most part it is pretty straightforward, but for control ioctls a flag
> is needed since it is possible that you have per-filehandle controls, and that
> can't be determined upfront of course.
>
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   drivers/media/video/v4l2-dev.c   |  171 +++++++++++++++++
>   drivers/media/video/v4l2-ioctl.c |  391 +++++++++++---------------------------
>   include/media/v4l2-dev.h         |   11 ++
>   3 files changed, 297 insertions(+), 276 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index a51a061..4d98ee1 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -516,6 +516,175 @@ static int get_index(struct video_device *vdev)
>   	return find_first_zero_bit(used, VIDEO_NUM_DEVICES);
>   }
>
> +#define SET_VALID_IOCTL(ops, cmd, op)			\
> +	if (ops->op)					\
> +		set_bit(_IOC_NR(cmd), valid_ioctls)
> +
> +/* This determines which ioctls are actually implemented in the driver.
> +   It's a one-time thing which simplifies video_ioctl2 as it can just do
> +   a bit test.
> +
> +   Note that drivers can override this by setting bits to 1 in
> +   vdev->valid_ioctls. If an ioctl is marked as 1 when this function is
> +   called, then that ioctl will actually be marked as unimplemented.
> +
> +   It does that by first setting up the local valid_ioctls bitmap, and
> +   at the end do a:
> +
> +   vdev->valid_ioctls = valid_ioctls&  ~(vdev->valid_ioctls)
> + */
> +static void determine_valid_ioctls(struct video_device *vdev)
> +{
> +	DECLARE_BITMAP(valid_ioctls, BASE_VIDIOC_PRIVATE);
> +	const struct v4l2_ioctl_ops *ops = vdev->ioctl_ops;
> +
> +	bitmap_zero(valid_ioctls, BASE_VIDIOC_PRIVATE);
> +
> +	SET_VALID_IOCTL(ops, VIDIOC_QUERYCAP, vidioc_querycap);
> +	if (ops->vidioc_g_priority ||
> +			test_bit(V4L2_FL_USE_FH_PRIO,&vdev->flags))
> +		set_bit(_IOC_NR(VIDIOC_G_PRIORITY), valid_ioctls);
> +	if (ops->vidioc_s_priority ||
> +			test_bit(V4L2_FL_USE_FH_PRIO,&vdev->flags))
> +		set_bit(_IOC_NR(VIDIOC_S_PRIORITY), valid_ioctls);
> +	if (ops->vidioc_enum_fmt_vid_cap ||
> +	    ops->vidioc_enum_fmt_vid_out ||
> +	    ops->vidioc_enum_fmt_vid_cap_mplane ||
> +	    ops->vidioc_enum_fmt_vid_out_mplane ||
> +	    ops->vidioc_enum_fmt_vid_overlay ||
> +	    ops->vidioc_enum_fmt_type_private)
> +		set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
> +	if (ops->vidioc_g_fmt_vid_cap ||
> +	    ops->vidioc_g_fmt_vid_out ||
> +	    ops->vidioc_g_fmt_vid_cap_mplane ||
> +	    ops->vidioc_g_fmt_vid_out_mplane ||
> +	    ops->vidioc_g_fmt_vid_overlay ||
> +	    ops->vidioc_g_fmt_vbi_cap ||
> +	    ops->vidioc_g_fmt_vid_out_overlay ||
> +	    ops->vidioc_g_fmt_vbi_out ||
> +	    ops->vidioc_g_fmt_sliced_vbi_cap ||
> +	    ops->vidioc_g_fmt_sliced_vbi_out ||
> +	    ops->vidioc_g_fmt_type_private)
> +		set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
> +	if (ops->vidioc_s_fmt_vid_cap ||
> +	    ops->vidioc_s_fmt_vid_out ||
> +	    ops->vidioc_s_fmt_vid_cap_mplane ||
> +	    ops->vidioc_s_fmt_vid_out_mplane ||
> +	    ops->vidioc_s_fmt_vid_overlay ||
> +	    ops->vidioc_s_fmt_vbi_cap ||
> +	    ops->vidioc_s_fmt_vid_out_overlay ||
> +	    ops->vidioc_s_fmt_vbi_out ||
> +	    ops->vidioc_s_fmt_sliced_vbi_cap ||
> +	    ops->vidioc_s_fmt_sliced_vbi_out ||
> +	    ops->vidioc_s_fmt_type_private)
> +		set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
> +	if (ops->vidioc_try_fmt_vid_cap ||
> +	    ops->vidioc_try_fmt_vid_out ||
> +	    ops->vidioc_try_fmt_vid_cap_mplane ||
> +	    ops->vidioc_try_fmt_vid_out_mplane ||
> +	    ops->vidioc_try_fmt_vid_overlay ||
> +	    ops->vidioc_try_fmt_vbi_cap ||
> +	    ops->vidioc_try_fmt_vid_out_overlay ||
> +	    ops->vidioc_try_fmt_vbi_out ||
> +	    ops->vidioc_try_fmt_sliced_vbi_cap ||
> +	    ops->vidioc_try_fmt_sliced_vbi_out ||
> +	    ops->vidioc_try_fmt_type_private)
> +		set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
> +	SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
> +	SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
> +	SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
> +	SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
> +	SET_VALID_IOCTL(ops, VIDIOC_OVERLAY, vidioc_overlay);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_FBUF, vidioc_g_fbuf);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_FBUF, vidioc_s_fbuf);
> +	SET_VALID_IOCTL(ops, VIDIOC_STREAMON, vidioc_streamon);
> +	SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
> +	if (vdev->tvnorms)
> +		set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
> +	if (ops->vidioc_g_std || vdev->current_norm)
> +		set_bit(_IOC_NR(VIDIOC_G_STD), valid_ioctls);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_STD, vidioc_s_std);
> +	SET_VALID_IOCTL(ops, VIDIOC_QUERYSTD, vidioc_querystd);
> +	SET_VALID_IOCTL(ops, VIDIOC_ENUMINPUT, vidioc_enum_input);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_INPUT, vidioc_g_input);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_INPUT, vidioc_s_input);
> +	SET_VALID_IOCTL(ops, VIDIOC_ENUMOUTPUT, vidioc_enum_output);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_OUTPUT, vidioc_g_output);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_OUTPUT, vidioc_s_output);
> +	/* Note: the control handler can also be passed through the filehandle,
> +	   and that can't be tested here. If the bit for these control ioctls
> +	   is set, then the ioctl is valid. But if it is 0, then it can still
> +	   be valid if the filehandle passed the control handler. */
> +	if (vdev->ctrl_handler || ops->vidioc_queryctrl)
> +		set_bit(_IOC_NR(VIDIOC_QUERYCTRL), valid_ioctls);
> +	if (vdev->ctrl_handler || ops->vidioc_g_ctrl || ops->vidioc_g_ext_ctrls)
> +		set_bit(_IOC_NR(VIDIOC_G_CTRL), valid_ioctls);
> +	if (vdev->ctrl_handler || ops->vidioc_s_ctrl || ops->vidioc_s_ext_ctrls)
> +		set_bit(_IOC_NR(VIDIOC_S_CTRL), valid_ioctls);
> +	if (vdev->ctrl_handler || ops->vidioc_g_ext_ctrls)
> +		set_bit(_IOC_NR(VIDIOC_G_EXT_CTRLS), valid_ioctls);
> +	if (vdev->ctrl_handler || ops->vidioc_s_ext_ctrls)
> +		set_bit(_IOC_NR(VIDIOC_S_EXT_CTRLS), valid_ioctls);
> +	if (vdev->ctrl_handler || ops->vidioc_try_ext_ctrls)
> +		set_bit(_IOC_NR(VIDIOC_TRY_EXT_CTRLS), valid_ioctls);
> +	if (vdev->ctrl_handler || ops->vidioc_querymenu)
> +		set_bit(_IOC_NR(VIDIOC_QUERYMENU), valid_ioctls);
> +	SET_VALID_IOCTL(ops, VIDIOC_ENUMAUDIO, vidioc_enumaudio);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_AUDIO, vidioc_g_audio);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_AUDIO, vidioc_s_audio);
> +	SET_VALID_IOCTL(ops, VIDIOC_ENUMAUDOUT, vidioc_enumaudout);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_AUDOUT, vidioc_g_audout);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_AUDOUT, vidioc_s_audout);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_MODULATOR, vidioc_g_modulator);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_MODULATOR, vidioc_s_modulator);
> +	if (ops->vidioc_g_crop || ops->vidioc_g_selection)
> +		set_bit(_IOC_NR(VIDIOC_G_CROP), valid_ioctls);
> +	if (ops->vidioc_s_crop || ops->vidioc_s_selection)
> +		set_bit(_IOC_NR(VIDIOC_S_CROP), valid_ioctls);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_SELECTION, vidioc_g_selection);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_SELECTION, vidioc_s_selection);
> +	if (ops->vidioc_cropcap || ops->vidioc_g_selection)
> +		set_bit(_IOC_NR(VIDIOC_CROPCAP), valid_ioctls);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_JPEGCOMP, vidioc_g_jpegcomp);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_JPEGCOMP, vidioc_s_jpegcomp);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_ENC_INDEX, vidioc_g_enc_index);
> +	SET_VALID_IOCTL(ops, VIDIOC_ENCODER_CMD, vidioc_encoder_cmd);
> +	SET_VALID_IOCTL(ops, VIDIOC_TRY_ENCODER_CMD, vidioc_try_encoder_cmd);
> +	SET_VALID_IOCTL(ops, VIDIOC_DECODER_CMD, vidioc_decoder_cmd);
> +	SET_VALID_IOCTL(ops, VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd);
> +	if (ops->vidioc_g_parm || vdev->current_norm)
> +		set_bit(_IOC_NR(VIDIOC_G_PARM), valid_ioctls);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_PARM, vidioc_s_parm);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_TUNER, vidioc_g_tuner);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_TUNER, vidioc_s_tuner);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_FREQUENCY, vidioc_g_frequency);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_FREQUENCY, vidioc_s_frequency);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_SLICED_VBI_CAP, vidioc_g_sliced_vbi_cap);
> +	SET_VALID_IOCTL(ops, VIDIOC_LOG_STATUS, vidioc_log_status);
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	SET_VALID_IOCTL(ops, VIDIOC_DBG_G_REGISTER, vidioc_g_register);
> +	SET_VALID_IOCTL(ops, VIDIOC_DBG_S_REGISTER, vidioc_s_register);
> +#endif
> +	SET_VALID_IOCTL(ops, VIDIOC_DBG_G_CHIP_IDENT, vidioc_g_chip_ident);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_HW_FREQ_SEEK, vidioc_s_hw_freq_seek);
> +	SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes);
> +	SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals);
> +	SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_PRESETS, vidioc_enum_dv_presets);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_DV_PRESET, vidioc_s_dv_preset);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_DV_PRESET, vidioc_g_dv_preset);
> +	SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_PRESET, vidioc_query_dv_preset);
> +	SET_VALID_IOCTL(ops, VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings);
> +	SET_VALID_IOCTL(ops, VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings);
> +	/* yes, really vidioc_subscribe_event */
> +	SET_VALID_IOCTL(ops, VIDIOC_DQEVENT, vidioc_subscribe_event);
> +	SET_VALID_IOCTL(ops, VIDIOC_SUBSCRIBE_EVENT, vidioc_subscribe_event);
> +	SET_VALID_IOCTL(ops, VIDIOC_UNSUBSCRIBE_EVENT, vidioc_unsubscribe_event);
> +	SET_VALID_IOCTL(ops, VIDIOC_CREATE_BUFS, vidioc_create_bufs);
> +	SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
> +	bitmap_andnot(vdev->valid_ioctls, valid_ioctls, vdev->valid_ioctls,
> +			BASE_VIDIOC_PRIVATE);
> +}
> +
>   /**
>    *	__video_register_device - register video4linux devices
>    *	@vdev: video device structure we want to register
> @@ -663,6 +832,8 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>   	vdev->index = get_index(vdev);
>   	mutex_unlock(&videodev_lock);
>
> +	determine_valid_ioctls(vdev);
> +
>   	/* Part 3: Initialize the character device */
>   	vdev->cdev = cdev_alloc();
>   	if (vdev->cdev == NULL) {
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 3f34098..21da16d 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -55,19 +55,6 @@
>   	memset((u8 *)(p) + offsetof(typeof(*(p)), field) + sizeof((p)->field), \
>   	0, sizeof(*(p)) - offsetof(typeof(*(p)), field) - sizeof((p)->field))
>
> -#define have_fmt_ops(foo) (						\
> -	ops->vidioc_##foo##_fmt_vid_cap ||				\
> -	ops->vidioc_##foo##_fmt_vid_out ||				\
> -	ops->vidioc_##foo##_fmt_vid_cap_mplane ||			\
> -	ops->vidioc_##foo##_fmt_vid_out_mplane ||			\
> -	ops->vidioc_##foo##_fmt_vid_overlay ||				\
> -	ops->vidioc_##foo##_fmt_vbi_cap ||				\
> -	ops->vidioc_##foo##_fmt_vid_out_overlay ||			\
> -	ops->vidioc_##foo##_fmt_vbi_out ||				\
> -	ops->vidioc_##foo##_fmt_sliced_vbi_cap ||			\
> -	ops->vidioc_##foo##_fmt_sliced_vbi_out ||			\
> -	ops->vidioc_##foo##_fmt_type_private)
> -
>   struct std_descr {
>   	v4l2_std_id std;
>   	const char *descr;
> @@ -198,93 +185,98 @@ static const char *v4l2_memory_names[] = {
>
>   struct v4l2_ioctl_info {
>   	unsigned int ioctl;
> +	u16 flags;
>   	const char * const name;
>   };
>
> -#define IOCTL_INFO(_ioctl) [_IOC_NR(_ioctl)] = {	\
> -	.ioctl = _ioctl,				\
> -	.name = #_ioctl,				\
> +/* This control can be valid if the filehandle passes a control handler. */
> +#define INFO_FL_CTRL	(1<<  1)
> +
> +#define IOCTL_INFO(_ioctl, _flags) [_IOC_NR(_ioctl)] = {	\
> +	.ioctl = _ioctl,					\
> +	.flags = _flags,					\
> +	.name = #_ioctl,					\
>   }
>
>   static struct v4l2_ioctl_info v4l2_ioctls[] = {
> -	IOCTL_INFO(VIDIOC_QUERYCAP),
> -	IOCTL_INFO(VIDIOC_ENUM_FMT),
> -	IOCTL_INFO(VIDIOC_G_FMT),
> -	IOCTL_INFO(VIDIOC_S_FMT),
> -	IOCTL_INFO(VIDIOC_REQBUFS),
> -	IOCTL_INFO(VIDIOC_QUERYBUF),
> -	IOCTL_INFO(VIDIOC_G_FBUF),
> -	IOCTL_INFO(VIDIOC_S_FBUF),
> -	IOCTL_INFO(VIDIOC_OVERLAY),
> -	IOCTL_INFO(VIDIOC_QBUF),
> -	IOCTL_INFO(VIDIOC_DQBUF),
> -	IOCTL_INFO(VIDIOC_STREAMON),
> -	IOCTL_INFO(VIDIOC_STREAMOFF),
> -	IOCTL_INFO(VIDIOC_G_PARM),
> -	IOCTL_INFO(VIDIOC_S_PARM),
> -	IOCTL_INFO(VIDIOC_G_STD),
> -	IOCTL_INFO(VIDIOC_S_STD),
> -	IOCTL_INFO(VIDIOC_ENUMSTD),
> -	IOCTL_INFO(VIDIOC_ENUMINPUT),
> -	IOCTL_INFO(VIDIOC_G_CTRL),
> -	IOCTL_INFO(VIDIOC_S_CTRL),
> -	IOCTL_INFO(VIDIOC_G_TUNER),
> -	IOCTL_INFO(VIDIOC_S_TUNER),
> -	IOCTL_INFO(VIDIOC_G_AUDIO),
> -	IOCTL_INFO(VIDIOC_S_AUDIO),
> -	IOCTL_INFO(VIDIOC_QUERYCTRL),
> -	IOCTL_INFO(VIDIOC_QUERYMENU),
> -	IOCTL_INFO(VIDIOC_G_INPUT),
> -	IOCTL_INFO(VIDIOC_S_INPUT),
> -	IOCTL_INFO(VIDIOC_G_OUTPUT),
> -	IOCTL_INFO(VIDIOC_S_OUTPUT),
> -	IOCTL_INFO(VIDIOC_ENUMOUTPUT),
> -	IOCTL_INFO(VIDIOC_G_AUDOUT),
> -	IOCTL_INFO(VIDIOC_S_AUDOUT),
> -	IOCTL_INFO(VIDIOC_G_MODULATOR),
> -	IOCTL_INFO(VIDIOC_S_MODULATOR),
> -	IOCTL_INFO(VIDIOC_G_FREQUENCY),
> -	IOCTL_INFO(VIDIOC_S_FREQUENCY),
> -	IOCTL_INFO(VIDIOC_CROPCAP),
> -	IOCTL_INFO(VIDIOC_G_CROP),
> -	IOCTL_INFO(VIDIOC_S_CROP),
> -	IOCTL_INFO(VIDIOC_G_SELECTION),
> -	IOCTL_INFO(VIDIOC_S_SELECTION),
> -	IOCTL_INFO(VIDIOC_G_JPEGCOMP),
> -	IOCTL_INFO(VIDIOC_S_JPEGCOMP),
> -	IOCTL_INFO(VIDIOC_QUERYSTD),
> -	IOCTL_INFO(VIDIOC_TRY_FMT),
> -	IOCTL_INFO(VIDIOC_ENUMAUDIO),
> -	IOCTL_INFO(VIDIOC_ENUMAUDOUT),
> -	IOCTL_INFO(VIDIOC_G_PRIORITY),
> -	IOCTL_INFO(VIDIOC_S_PRIORITY),
> -	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP),
> -	IOCTL_INFO(VIDIOC_LOG_STATUS),
> -	IOCTL_INFO(VIDIOC_G_EXT_CTRLS),
> -	IOCTL_INFO(VIDIOC_S_EXT_CTRLS),
> -	IOCTL_INFO(VIDIOC_TRY_EXT_CTRLS),
> -	IOCTL_INFO(VIDIOC_ENUM_FRAMESIZES),
> -	IOCTL_INFO(VIDIOC_ENUM_FRAMEINTERVALS),
> -	IOCTL_INFO(VIDIOC_G_ENC_INDEX),
> -	IOCTL_INFO(VIDIOC_ENCODER_CMD),
> -	IOCTL_INFO(VIDIOC_TRY_ENCODER_CMD),
> -	IOCTL_INFO(VIDIOC_DECODER_CMD),
> -	IOCTL_INFO(VIDIOC_TRY_DECODER_CMD),
> -	IOCTL_INFO(VIDIOC_DBG_S_REGISTER),
> -	IOCTL_INFO(VIDIOC_DBG_G_REGISTER),
> -	IOCTL_INFO(VIDIOC_DBG_G_CHIP_IDENT),
> -	IOCTL_INFO(VIDIOC_S_HW_FREQ_SEEK),
> -	IOCTL_INFO(VIDIOC_ENUM_DV_PRESETS),
> -	IOCTL_INFO(VIDIOC_S_DV_PRESET),
> -	IOCTL_INFO(VIDIOC_G_DV_PRESET),
> -	IOCTL_INFO(VIDIOC_QUERY_DV_PRESET),
> -	IOCTL_INFO(VIDIOC_S_DV_TIMINGS),
> -	IOCTL_INFO(VIDIOC_G_DV_TIMINGS),
> -	IOCTL_INFO(VIDIOC_DQEVENT),
> -	IOCTL_INFO(VIDIOC_SUBSCRIBE_EVENT),
> -	IOCTL_INFO(VIDIOC_UNSUBSCRIBE_EVENT),
> -	IOCTL_INFO(VIDIOC_CREATE_BUFS),
> -	IOCTL_INFO(VIDIOC_PREPARE_BUF),
> +	IOCTL_INFO(VIDIOC_QUERYCAP, 0),
> +	IOCTL_INFO(VIDIOC_ENUM_FMT, 0),
> +	IOCTL_INFO(VIDIOC_G_FMT, 0),
> +	IOCTL_INFO(VIDIOC_S_FMT, 0),
> +	IOCTL_INFO(VIDIOC_REQBUFS, 0),
> +	IOCTL_INFO(VIDIOC_QUERYBUF, 0),
> +	IOCTL_INFO(VIDIOC_G_FBUF, 0),
> +	IOCTL_INFO(VIDIOC_S_FBUF, 0),
> +	IOCTL_INFO(VIDIOC_OVERLAY, 0),
> +	IOCTL_INFO(VIDIOC_QBUF, 0),
> +	IOCTL_INFO(VIDIOC_DQBUF, 0),
> +	IOCTL_INFO(VIDIOC_STREAMON, 0),
> +	IOCTL_INFO(VIDIOC_STREAMOFF, 0),
> +	IOCTL_INFO(VIDIOC_G_PARM, 0),
> +	IOCTL_INFO(VIDIOC_S_PARM, 0),
> +	IOCTL_INFO(VIDIOC_G_STD, 0),
> +	IOCTL_INFO(VIDIOC_S_STD, 0),
> +	IOCTL_INFO(VIDIOC_ENUMSTD, 0),
> +	IOCTL_INFO(VIDIOC_ENUMINPUT, 0),
> +	IOCTL_INFO(VIDIOC_G_CTRL, INFO_FL_CTRL),
> +	IOCTL_INFO(VIDIOC_S_CTRL, INFO_FL_CTRL),
> +	IOCTL_INFO(VIDIOC_G_TUNER, 0),
> +	IOCTL_INFO(VIDIOC_S_TUNER, 0),
> +	IOCTL_INFO(VIDIOC_G_AUDIO, 0),
> +	IOCTL_INFO(VIDIOC_S_AUDIO, 0),
> +	IOCTL_INFO(VIDIOC_QUERYCTRL, INFO_FL_CTRL),
> +	IOCTL_INFO(VIDIOC_QUERYMENU, INFO_FL_CTRL),
> +	IOCTL_INFO(VIDIOC_G_INPUT, 0),
> +	IOCTL_INFO(VIDIOC_S_INPUT, 0),
> +	IOCTL_INFO(VIDIOC_G_OUTPUT, 0),
> +	IOCTL_INFO(VIDIOC_S_OUTPUT, 0),
> +	IOCTL_INFO(VIDIOC_ENUMOUTPUT, 0),
> +	IOCTL_INFO(VIDIOC_G_AUDOUT, 0),
> +	IOCTL_INFO(VIDIOC_S_AUDOUT, 0),
> +	IOCTL_INFO(VIDIOC_G_MODULATOR, 0),
> +	IOCTL_INFO(VIDIOC_S_MODULATOR, 0),
> +	IOCTL_INFO(VIDIOC_G_FREQUENCY, 0),
> +	IOCTL_INFO(VIDIOC_S_FREQUENCY, 0),
> +	IOCTL_INFO(VIDIOC_CROPCAP, 0),
> +	IOCTL_INFO(VIDIOC_G_CROP, 0),
> +	IOCTL_INFO(VIDIOC_S_CROP, 0),
> +	IOCTL_INFO(VIDIOC_G_SELECTION, 0),
> +	IOCTL_INFO(VIDIOC_S_SELECTION, 0),
> +	IOCTL_INFO(VIDIOC_G_JPEGCOMP, 0),
> +	IOCTL_INFO(VIDIOC_S_JPEGCOMP, 0),
> +	IOCTL_INFO(VIDIOC_QUERYSTD, 0),
> +	IOCTL_INFO(VIDIOC_TRY_FMT, 0),
> +	IOCTL_INFO(VIDIOC_ENUMAUDIO, 0),
> +	IOCTL_INFO(VIDIOC_ENUMAUDOUT, 0),
> +	IOCTL_INFO(VIDIOC_G_PRIORITY, 0),
> +	IOCTL_INFO(VIDIOC_S_PRIORITY, 0),
> +	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP, 0),
> +	IOCTL_INFO(VIDIOC_LOG_STATUS, 0),
> +	IOCTL_INFO(VIDIOC_G_EXT_CTRLS, INFO_FL_CTRL),
> +	IOCTL_INFO(VIDIOC_S_EXT_CTRLS, INFO_FL_CTRL),
> +	IOCTL_INFO(VIDIOC_TRY_EXT_CTRLS, 0),
> +	IOCTL_INFO(VIDIOC_ENUM_FRAMESIZES, 0),
> +	IOCTL_INFO(VIDIOC_ENUM_FRAMEINTERVALS, 0),
> +	IOCTL_INFO(VIDIOC_G_ENC_INDEX, 0),
> +	IOCTL_INFO(VIDIOC_ENCODER_CMD, 0),
> +	IOCTL_INFO(VIDIOC_TRY_ENCODER_CMD, 0),
> +	IOCTL_INFO(VIDIOC_DECODER_CMD, 0),
> +	IOCTL_INFO(VIDIOC_TRY_DECODER_CMD, 0),
> +	IOCTL_INFO(VIDIOC_DBG_S_REGISTER, 0),
> +	IOCTL_INFO(VIDIOC_DBG_G_REGISTER, 0),
> +	IOCTL_INFO(VIDIOC_DBG_G_CHIP_IDENT, 0),
> +	IOCTL_INFO(VIDIOC_S_HW_FREQ_SEEK, 0),
> +	IOCTL_INFO(VIDIOC_ENUM_DV_PRESETS, 0),
> +	IOCTL_INFO(VIDIOC_S_DV_PRESET, 0),
> +	IOCTL_INFO(VIDIOC_G_DV_PRESET, 0),
> +	IOCTL_INFO(VIDIOC_QUERY_DV_PRESET, 0),
> +	IOCTL_INFO(VIDIOC_S_DV_TIMINGS, 0),
> +	IOCTL_INFO(VIDIOC_G_DV_TIMINGS, 0),
> +	IOCTL_INFO(VIDIOC_DQEVENT, 0),
> +	IOCTL_INFO(VIDIOC_SUBSCRIBE_EVENT, 0),
> +	IOCTL_INFO(VIDIOC_UNSUBSCRIBE_EVENT, 0),
> +	IOCTL_INFO(VIDIOC_CREATE_BUFS, 0),
> +	IOCTL_INFO(VIDIOC_PREPARE_BUF, 0),
>   };
>   #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
>
> @@ -526,19 +518,28 @@ static long __video_do_ioctl(struct file *file,
>   		return ret;
>   	}
>
> -	if ((vfd->debug&  V4L2_DEBUG_IOCTL)&&
> -				!(vfd->debug&  V4L2_DEBUG_IOCTL_ARG)) {
> -		v4l_print_ioctl(vfd->name, cmd);
> -		printk(KERN_CONT "\n");
> -	}
> -
>   	if (test_bit(V4L2_FL_USES_V4L2_FH,&vfd->flags)) {
>   		vfh = file->private_data;
>   		use_fh_prio = test_bit(V4L2_FL_USE_FH_PRIO,&vfd->flags);
> +		if (use_fh_prio)
> +			ret_prio = v4l2_prio_check(vfd->prio, vfh->prio);
>   	}
>
> -	if (use_fh_prio)
> -		ret_prio = v4l2_prio_check(vfd->prio, vfh->prio);
> +	if (v4l2_is_valid_ioctl(cmd)) {

I would prefer for this check to be the first check in the function
in the form of:

	if (!v4l2_is_valid_ioctl(cmd))
		return -ENOTTY;

This will drop an indentation level from the code below and also drop an
indentation level from the prio check introduced in a later patch,
making the end result much more readable IMHO.

> +		struct v4l2_ioctl_info *info =&v4l2_ioctls[_IOC_NR(cmd)];
> +
> +		if (!test_bit(_IOC_NR(cmd), vfd->valid_ioctls)) {
> +			if (!(info->flags&  INFO_FL_CTRL) ||
> +			    !(vfh&&  vfh->ctrl_handler))
> +				return -ENOTTY;
 > +		}
 > +	}

Sort of hard to read, IMHO the below is easier to parse by us humans:

	if (!test_bit(_IOC_NR(cmd), vfd->valid_ioctls) &&
	    !((info->flags & INFO_FL_CTRL) && vfh && vfh->ctrl_handler))
		return -ENOTTY;

Note lots of more patch below, on which I've no further comments.

Regards,

Hans



> +
> +	if ((vfd->debug&  V4L2_DEBUG_IOCTL)&&
> +				!(vfd->debug&  V4L2_DEBUG_IOCTL_ARG)) {
> +		v4l_print_ioctl(vfd->name, cmd);
> +		printk(KERN_CONT "\n");
> +	}
>
>   	switch (cmd) {
>
> @@ -547,9 +548,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_capability *cap = (struct v4l2_capability *)arg;
>
> -		if (!ops->vidioc_querycap)
> -			break;
> -
>   		cap->version = LINUX_VERSION_CODE;
>   		ret = ops->vidioc_querycap(file, fh, cap);
>   		if (!ret)
> @@ -600,6 +598,7 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_fmtdesc *f = arg;
>
> +		ret = -EINVAL;
>   		switch (f->type) {
>   		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>   			if (likely(ops->vidioc_enum_fmt_vid_cap))
> @@ -632,7 +631,7 @@ static long __video_do_ioctl(struct file *file,
>   		default:
>   			break;
>   		}
> -		if (likely (!ret))
> +		if (likely(!ret))
>   			dbgarg(cmd, "index=%d, type=%d, flags=%d, "
>   				"pixelformat=%c%c%c%c, description='%s'\n",
>   				f->index, f->type, f->flags,
> @@ -641,14 +640,6 @@ static long __video_do_ioctl(struct file *file,
>   				(f->pixelformat>>  16)&  0xff,
>   				(f->pixelformat>>  24)&  0xff,
>   				f->description);
> -		else if (ret == -ENOTTY&&
> -			 (ops->vidioc_enum_fmt_vid_cap ||
> -			  ops->vidioc_enum_fmt_vid_out ||
> -			  ops->vidioc_enum_fmt_vid_cap_mplane ||
> -			  ops->vidioc_enum_fmt_vid_out_mplane ||
> -			  ops->vidioc_enum_fmt_vid_overlay ||
> -			  ops->vidioc_enum_fmt_type_private))
> -			ret = -EINVAL;
>   		break;
>   	}
>   	case VIDIOC_G_FMT:
> @@ -658,6 +649,7 @@ static long __video_do_ioctl(struct file *file,
>   		/* FIXME: Should be one dump per type */
>   		dbgarg(cmd, "type=%s\n", prt_names(f->type, v4l2_type_names));
>
> +		ret = -EINVAL;
>   		switch (f->type) {
>   		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>   			if (ops->vidioc_g_fmt_vid_cap)
> @@ -719,17 +711,12 @@ static long __video_do_ioctl(struct file *file,
>   								fh, f);
>   			break;
>   		}
> -		if (unlikely(ret == -ENOTTY&&  have_fmt_ops(g)))
> -			ret = -EINVAL;
> -
>   		break;
>   	}
>   	case VIDIOC_S_FMT:
>   	{
>   		struct v4l2_format *f = (struct v4l2_format *)arg;
>
> -		if (!have_fmt_ops(s))
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -817,6 +804,7 @@ static long __video_do_ioctl(struct file *file,
>   		/* FIXME: Should be one dump per type */
>   		dbgarg(cmd, "type=%s\n", prt_names(f->type,
>   						v4l2_type_names));
> +		ret = -EINVAL;
>   		switch (f->type) {
>   		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>   			CLEAR_AFTER_FIELD(f, fmt.pix);
> @@ -889,8 +877,6 @@ static long __video_do_ioctl(struct file *file,
>   								fh, f);
>   			break;
>   		}
> -		if (unlikely(ret == -ENOTTY&&  have_fmt_ops(try)))
> -			ret = -EINVAL;
>   		break;
>   	}
>   	/* FIXME: Those buf reqs could be handled here,
> @@ -901,8 +887,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_requestbuffers *p = arg;
>
> -		if (!ops->vidioc_reqbufs)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -925,8 +909,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_buffer *p = arg;
>
> -		if (!ops->vidioc_querybuf)
> -			break;
>   		ret = check_fmt(ops, p->type);
>   		if (ret)
>   			break;
> @@ -940,8 +922,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_buffer *p = arg;
>
> -		if (!ops->vidioc_qbuf)
> -			break;
>   		ret = check_fmt(ops, p->type);
>   		if (ret)
>   			break;
> @@ -955,8 +935,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_buffer *p = arg;
>
> -		if (!ops->vidioc_dqbuf)
> -			break;
>   		ret = check_fmt(ops, p->type);
>   		if (ret)
>   			break;
> @@ -970,8 +948,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		int *i = arg;
>
> -		if (!ops->vidioc_overlay)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -984,8 +960,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_framebuffer *p = arg;
>
> -		if (!ops->vidioc_g_fbuf)
> -			break;
>   		ret = ops->vidioc_g_fbuf(file, fh, arg);
>   		if (!ret) {
>   			dbgarg(cmd, "capability=0x%x, flags=%d, base=0x%08lx\n",
> @@ -999,8 +973,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_framebuffer *p = arg;
>
> -		if (!ops->vidioc_s_fbuf)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1015,8 +987,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		enum v4l2_buf_type i = *(int *)arg;
>
> -		if (!ops->vidioc_streamon)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1029,8 +999,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		enum v4l2_buf_type i = *(int *)arg;
>
> -		if (!ops->vidioc_streamoff)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1104,9 +1072,6 @@ static long __video_do_ioctl(struct file *file,
>
>   		dbgarg(cmd, "std=%08Lx\n", (long long unsigned)*id);
>
> -		if (!ops->vidioc_s_std)
> -			break;
> -
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1128,8 +1093,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		v4l2_std_id *p = arg;
>
> -		if (!ops->vidioc_querystd)
> -			break;
>   		/*
>   		 * If nothing detected, it should return all supported
>   		 * Drivers just need to mask the std argument, in order
> @@ -1163,9 +1126,6 @@ static long __video_do_ioctl(struct file *file,
>   		if (ops->vidioc_s_dv_timings)
>   			p->capabilities |= V4L2_IN_CAP_CUSTOM_TIMINGS;
>
> -		if (!ops->vidioc_enum_input)
> -			break;
> -
>   		ret = ops->vidioc_enum_input(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd, "index=%d, name=%s, type=%d, "
> @@ -1181,8 +1141,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		unsigned int *i = arg;
>
> -		if (!ops->vidioc_g_input)
> -			break;
>   		ret = ops->vidioc_g_input(file, fh, i);
>   		if (!ret)
>   			dbgarg(cmd, "value=%d\n", *i);
> @@ -1192,8 +1150,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		unsigned int *i = arg;
>
> -		if (!ops->vidioc_s_input)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1208,9 +1164,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_output *p = arg;
>
> -		if (!ops->vidioc_enum_output)
> -			break;
> -
>   		/*
>   		 * We set the flags for CAP_PRESETS, CAP_CUSTOM_TIMINGS&
>   		* CAP_STD here based on ioctl handler provided by the
> @@ -1237,8 +1190,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		unsigned int *i = arg;
>
> -		if (!ops->vidioc_g_output)
> -			break;
>   		ret = ops->vidioc_g_output(file, fh, i);
>   		if (!ret)
>   			dbgarg(cmd, "value=%d\n", *i);
> @@ -1248,8 +1199,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		unsigned int *i = arg;
>
> -		if (!ops->vidioc_s_output)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1441,8 +1390,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_audio *p = arg;
>
> -		if (!ops->vidioc_enumaudio)
> -			break;
>   		ret = ops->vidioc_enumaudio(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd, "index=%d, name=%s, capability=0x%x, "
> @@ -1456,9 +1403,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_audio *p = arg;
>
> -		if (!ops->vidioc_g_audio)
> -			break;
> -
>   		ret = ops->vidioc_g_audio(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd, "index=%d, name=%s, capability=0x%x, "
> @@ -1472,8 +1416,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_audio *p = arg;
>
> -		if (!ops->vidioc_s_audio)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1488,8 +1430,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_audioout *p = arg;
>
> -		if (!ops->vidioc_enumaudout)
> -			break;
>   		dbgarg(cmd, "Enum for index=%d\n", p->index);
>   		ret = ops->vidioc_enumaudout(file, fh, p);
>   		if (!ret)
> @@ -1502,9 +1442,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_audioout *p = arg;
>
> -		if (!ops->vidioc_g_audout)
> -			break;
> -
>   		ret = ops->vidioc_g_audout(file, fh, p);
>   		if (!ret)
>   			dbgarg2("index=%d, name=%s, capability=%d, "
> @@ -1516,8 +1453,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_audioout *p = arg;
>
> -		if (!ops->vidioc_s_audout)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1533,8 +1468,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_modulator *p = arg;
>
> -		if (!ops->vidioc_g_modulator)
> -			break;
>   		ret = ops->vidioc_g_modulator(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd, "index=%d, name=%s, "
> @@ -1549,8 +1482,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_modulator *p = arg;
>
> -		if (!ops->vidioc_s_modulator)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1566,9 +1497,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_crop *p = arg;
>
> -		if (!ops->vidioc_g_crop&&  !ops->vidioc_g_selection)
> -			break;
> -
>   		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
>
>   		if (ops->vidioc_g_crop) {
> @@ -1600,9 +1528,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_crop *p = arg;
>
> -		if (!ops->vidioc_s_crop&&  !ops->vidioc_s_selection)
> -			break;
> -
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1633,9 +1558,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_selection *p = arg;
>
> -		if (!ops->vidioc_g_selection)
> -			break;
> -
>   		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
>
>   		ret = ops->vidioc_g_selection(file, fh, p);
> @@ -1647,9 +1569,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_selection *p = arg;
>
> -		if (!ops->vidioc_s_selection)
> -			break;
> -
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1666,9 +1585,6 @@ static long __video_do_ioctl(struct file *file,
>   		struct v4l2_cropcap *p = arg;
>
>   		/*FIXME: Should also show v4l2_fract pixelaspect */
> -		if (!ops->vidioc_cropcap&&  !ops->vidioc_g_selection)
> -			break;
> -
>   		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
>   		if (ops->vidioc_cropcap) {
>   			ret = ops->vidioc_cropcap(file, fh, p);
> @@ -1712,9 +1628,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_jpegcompression *p = arg;
>
> -		if (!ops->vidioc_g_jpegcomp)
> -			break;
> -
>   		ret = ops->vidioc_g_jpegcomp(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd, "quality=%d, APPn=%d, "
> @@ -1728,8 +1641,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_jpegcompression *p = arg;
>
> -		if (!ops->vidioc_g_jpegcomp)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1745,8 +1656,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_enc_idx *p = arg;
>
> -		if (!ops->vidioc_g_enc_index)
> -			break;
>   		ret = ops->vidioc_g_enc_index(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd, "entries=%d, entries_cap=%d\n",
> @@ -1757,8 +1666,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_encoder_cmd *p = arg;
>
> -		if (!ops->vidioc_encoder_cmd)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1772,8 +1679,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_encoder_cmd *p = arg;
>
> -		if (!ops->vidioc_try_encoder_cmd)
> -			break;
>   		ret = ops->vidioc_try_encoder_cmd(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
> @@ -1783,8 +1688,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_decoder_cmd *p = arg;
>
> -		if (!ops->vidioc_decoder_cmd)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1798,8 +1701,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_decoder_cmd *p = arg;
>
> -		if (!ops->vidioc_try_decoder_cmd)
> -			break;
>   		ret = ops->vidioc_try_decoder_cmd(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
> @@ -1809,8 +1710,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_streamparm *p = arg;
>
> -		if (!ops->vidioc_g_parm&&  !vfd->current_norm)
> -			break;
>   		if (ops->vidioc_g_parm) {
>   			ret = check_fmt(ops, p->type);
>   			if (ret)
> @@ -1838,8 +1737,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_streamparm *p = arg;
>
> -		if (!ops->vidioc_s_parm)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1856,9 +1753,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_tuner *p = arg;
>
> -		if (!ops->vidioc_g_tuner)
> -			break;
> -
>   		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>   			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>   		ret = ops->vidioc_g_tuner(file, fh, p);
> @@ -1877,8 +1771,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_tuner *p = arg;
>
> -		if (!ops->vidioc_s_tuner)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1900,9 +1792,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_frequency *p = arg;
>
> -		if (!ops->vidioc_g_frequency)
> -			break;
> -
>   		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
>   			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>   		ret = ops->vidioc_g_frequency(file, fh, p);
> @@ -1916,8 +1805,6 @@ static long __video_do_ioctl(struct file *file,
>   		struct v4l2_frequency *p = arg;
>   		enum v4l2_tuner_type type;
>
> -		if (!ops->vidioc_s_frequency)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -1936,9 +1823,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_sliced_vbi_cap *p = arg;
>
> -		if (!ops->vidioc_g_sliced_vbi_cap)
> -			break;
> -
>   		/* Clear up to type, everything after type is zerod already */
>   		memset(p, 0, offsetof(struct v4l2_sliced_vbi_cap, type));
>
> @@ -1950,8 +1834,6 @@ static long __video_do_ioctl(struct file *file,
>   	}
>   	case VIDIOC_LOG_STATUS:
>   	{
> -		if (!ops->vidioc_log_status)
> -			break;
>   		if (vfd->v4l2_dev)
>   			pr_info("%s: =================  START STATUS  =================\n",
>   				vfd->v4l2_dev->name);
> @@ -1966,12 +1848,10 @@ static long __video_do_ioctl(struct file *file,
>   #ifdef CONFIG_VIDEO_ADV_DEBUG
>   		struct v4l2_dbg_register *p = arg;
>
> -		if (ops->vidioc_g_register) {
> -			if (!capable(CAP_SYS_ADMIN))
> -				ret = -EPERM;
> -			else
> -				ret = ops->vidioc_g_register(file, fh, p);
> -		}
> +		if (!capable(CAP_SYS_ADMIN))
> +			ret = -EPERM;
> +		else
> +			ret = ops->vidioc_g_register(file, fh, p);
>   #endif
>   		break;
>   	}
> @@ -1980,12 +1860,10 @@ static long __video_do_ioctl(struct file *file,
>   #ifdef CONFIG_VIDEO_ADV_DEBUG
>   		struct v4l2_dbg_register *p = arg;
>
> -		if (ops->vidioc_s_register) {
> -			if (!capable(CAP_SYS_ADMIN))
> -				ret = -EPERM;
> -			else
> -				ret = ops->vidioc_s_register(file, fh, p);
> -		}
> +		if (!capable(CAP_SYS_ADMIN))
> +			ret = -EPERM;
> +		else
> +			ret = ops->vidioc_s_register(file, fh, p);
>   #endif
>   		break;
>   	}
> @@ -1993,8 +1871,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_dbg_chip_ident *p = arg;
>
> -		if (!ops->vidioc_g_chip_ident)
> -			break;
>   		p->ident = V4L2_IDENT_NONE;
>   		p->revision = 0;
>   		ret = ops->vidioc_g_chip_ident(file, fh, p);
> @@ -2007,8 +1883,6 @@ static long __video_do_ioctl(struct file *file,
>   		struct v4l2_hw_freq_seek *p = arg;
>   		enum v4l2_tuner_type type;
>
> -		if (!ops->vidioc_s_hw_freq_seek)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -2028,9 +1902,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_frmsizeenum *p = arg;
>
> -		if (!ops->vidioc_enum_framesizes)
> -			break;
> -
>   		ret = ops->vidioc_enum_framesizes(file, fh, p);
>   		dbgarg(cmd,
>   			"index=%d, pixelformat=%c%c%c%c, type=%d ",
> @@ -2064,9 +1935,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_frmivalenum *p = arg;
>
> -		if (!ops->vidioc_enum_frameintervals)
> -			break;
> -
>   		ret = ops->vidioc_enum_frameintervals(file, fh, p);
>   		dbgarg(cmd,
>   			"index=%d, pixelformat=%d, width=%d, height=%d, type=%d ",
> @@ -2099,9 +1967,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_dv_enum_preset *p = arg;
>
> -		if (!ops->vidioc_enum_dv_presets)
> -			break;
> -
>   		ret = ops->vidioc_enum_dv_presets(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd,
> @@ -2115,8 +1980,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_dv_preset *p = arg;
>
> -		if (!ops->vidioc_s_dv_preset)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -2130,9 +1993,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_dv_preset *p = arg;
>
> -		if (!ops->vidioc_g_dv_preset)
> -			break;
> -
>   		ret = ops->vidioc_g_dv_preset(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd, "preset=%d\n", p->preset);
> @@ -2142,9 +2002,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_dv_preset *p = arg;
>
> -		if (!ops->vidioc_query_dv_preset)
> -			break;
> -
>   		ret = ops->vidioc_query_dv_preset(file, fh, p);
>   		if (!ret)
>   			dbgarg(cmd, "preset=%d\n", p->preset);
> @@ -2154,8 +2011,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_dv_timings *p = arg;
>
> -		if (!ops->vidioc_s_dv_timings)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -2188,9 +2043,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_dv_timings *p = arg;
>
> -		if (!ops->vidioc_g_dv_timings)
> -			break;
> -
>   		ret = ops->vidioc_g_dv_timings(file, fh, p);
>   		if (!ret) {
>   			switch (p->type) {
> @@ -2222,9 +2074,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_event *ev = arg;
>
> -		if (!ops->vidioc_subscribe_event)
> -			break;
> -
>   		ret = v4l2_event_dequeue(fh, ev, file->f_flags&  O_NONBLOCK);
>   		if (ret<  0) {
>   			dbgarg(cmd, "no pending events?");
> @@ -2241,9 +2090,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_event_subscription *sub = arg;
>
> -		if (!ops->vidioc_subscribe_event)
> -			break;
> -
>   		ret = ops->vidioc_subscribe_event(fh, sub);
>   		if (ret<  0) {
>   			dbgarg(cmd, "failed, ret=%ld", ret);
> @@ -2256,9 +2102,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_event_subscription *sub = arg;
>
> -		if (!ops->vidioc_unsubscribe_event)
> -			break;
> -
>   		ret = ops->vidioc_unsubscribe_event(fh, sub);
>   		if (ret<  0) {
>   			dbgarg(cmd, "failed, ret=%ld", ret);
> @@ -2271,8 +2114,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_create_buffers *create = arg;
>
> -		if (!ops->vidioc_create_bufs)
> -			break;
>   		if (ret_prio) {
>   			ret = ret_prio;
>   			break;
> @@ -2290,8 +2131,6 @@ static long __video_do_ioctl(struct file *file,
>   	{
>   		struct v4l2_buffer *b = arg;
>
> -		if (!ops->vidioc_prepare_buf)
> -			break;
>   		ret = check_fmt(ops, b->type);
>   		if (ret)
>   			break;
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 0da84dc..15e2fe4 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -126,6 +126,7 @@ struct video_device
>
>   	/* ioctl callbacks */
>   	const struct v4l2_ioctl_ops *ioctl_ops;
> +	DECLARE_BITMAP(valid_ioctls, BASE_VIDIOC_PRIVATE);
>
>   	/* serialization lock */
>   	DECLARE_BITMAP(dont_use_lock, BASE_VIDIOC_PRIVATE);
> @@ -184,6 +185,16 @@ static inline void v4l2_dont_use_lock(struct video_device *vdev, unsigned int cm
>   		set_bit(_IOC_NR(cmd), vdev->dont_use_lock);
>   }
>
> +/* Mark that this command isn't implemented, must be called before
> +   video_device_register. See also the comments in determine_valid_ioctls().
> +   This function allows drivers to provide just one v4l2_ioctl_ops struct, but
> +   disable ioctls based on the specific card that is actually found. */
> +static inline void v4l2_dont_use_cmd(struct video_device *vdev, unsigned int cmd)
> +{
> +	if (_IOC_NR(cmd)<  BASE_VIDIOC_PRIVATE)
> +		set_bit(_IOC_NR(cmd), vdev->valid_ioctls);
> +}
> +
>   /* helper functions to access driver private data. */
>   static inline void *video_get_drvdata(struct video_device *vdev)
>   {

Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:58450 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab2EJIQc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 04:16:32 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: linux-media@vger.kernel.org
Subject: Re: [RFCv1 PATCH 2/5] v4l2-dev/ioctl: determine the valid ioctls upfront.
Date: Thu, 10 May 2012 10:06:15 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl> <e75979b946d3934cbfb12e8b5518bcbbb891ceee.1336632433.git.hans.verkuil@cisco.com>
In-Reply-To: <e75979b946d3934cbfb12e8b5518bcbbb891ceee.1336632433.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205101006.15648.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 10 May 2012 09:05:11 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
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
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-dev.c   |  171 +++++++++++++++++
>  drivers/media/video/v4l2-ioctl.c |  391 +++++++++++---------------------------
>  include/media/v4l2-dev.h         |   11 ++
>  3 files changed, 297 insertions(+), 276 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index a51a061..4d98ee1 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -516,6 +516,175 @@ static int get_index(struct video_device *vdev)
>  	return find_first_zero_bit(used, VIDEO_NUM_DEVICES);
>  }
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
> +   vdev->valid_ioctls = valid_ioctls & ~(vdev->valid_ioctls)
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
> +			test_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags))
> +		set_bit(_IOC_NR(VIDIOC_G_PRIORITY), valid_ioctls);
> +	if (ops->vidioc_s_priority ||
> +			test_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags))
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
>  /**
>   *	__video_register_device - register video4linux devices
>   *	@vdev: video device structure we want to register
> @@ -663,6 +832,8 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>  	vdev->index = get_index(vdev);
>  	mutex_unlock(&videodev_lock);
>  
> +	determine_valid_ioctls(vdev);

OK, this fails if ioctl_ops == NULL :-) I need to check for that before
calling determine_valid_ioctls().

I've prepared a new patch series that fixes this (and that also documents
v4l2_dont_use_cmd).

Hans, that one is available here:

  git://linuxtv.org/hverkuil/media_tree.git ioctlv2

Regards,

	Hans

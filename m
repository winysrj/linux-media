Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2088 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3LMOpd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 09:45:33 -0500
Message-ID: <52AB1D71.6060000@xs4all.nl>
Date: Fri, 13 Dec 2013 15:45:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC 2/2] v4l2: enable FMT IOCTLs for SDR
References: <1386867447-1018-1-git-send-email-crope@iki.fi> <1386867447-1018-3-git-send-email-crope@iki.fi>
In-Reply-To: <1386867447-1018-3-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2013 05:57 PM, Antti Palosaari wrote:
> Enable format IOCTLs for SDR use. There are used for negotiate used
> data stream format.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c   | 12 ++++++++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c | 26 ++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index c9cf54c..d67286ba 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -563,6 +563,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  	bool is_vid = vdev->vfl_type == VFL_TYPE_GRABBER;
>  	bool is_vbi = vdev->vfl_type == VFL_TYPE_VBI;
>  	bool is_radio = vdev->vfl_type == VFL_TYPE_RADIO;
> +	bool is_sdr = vdev->vfl_type == VFL_TYPE_SDR;
>  	bool is_rx = vdev->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vdev->vfl_dir != VFL_DIR_RX;
>  
> @@ -612,6 +613,17 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
>  		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
>  
> +	if (is_sdr && is_rx) {

I would drop the is_rx part. If there even is something like a SDR transmitter,
then I would still expect that the same ioctls are needed.

> +		/* SDR specific ioctls */
> +		if (ops->vidioc_enum_fmt_vid_cap)
> +			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
> +		if (ops->vidioc_g_fmt_vid_cap)
> +			set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
> +		if (ops->vidioc_s_fmt_vid_cap)
> +			set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
> +		if (ops->vidioc_try_fmt_vid_cap)
> +			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);

We need sdr-specific ops: vidioc_enum/g/s/try_sdr_cap.

> +	}
>  	if (is_vid) {
>  		/* video specific ioctls */
>  		if ((is_rx && (ops->vidioc_enum_fmt_vid_cap ||

You also need to split up the large 'if (!is_radio)' part:

        if (!is_radio) {
                /* ioctls valid for video, vbi or sdr */
                SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
                SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
                SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
                SET_VALID_IOCTL(ops, VIDIOC_EXPBUF, vidioc_expbuf);
                SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
                SET_VALID_IOCTL(ops, VIDIOC_CREATE_BUFS, vidioc_create_bufs);
                SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
	}
	if (!is_radio && !is_sdr) {

Regards,

	Hans

> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 5b6e0e8..2471179 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -879,6 +879,7 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
>  	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
>  	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
>  	bool is_vbi = vfd->vfl_type == VFL_TYPE_VBI;
> +	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
>  	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>  
> @@ -928,6 +929,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
>  		if (is_vbi && is_tx && ops->vidioc_g_fmt_sliced_vbi_out)
>  			return 0;
>  		break;
> +	case V4L2_BUF_TYPE_SDR_RX:
> +		if (is_sdr && is_rx && ops->vidioc_g_fmt_vid_cap)
> +			return 0;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -1047,6 +1052,10 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!is_tx || !ops->vidioc_enum_fmt_vid_out_mplane))
>  			break;
>  		return ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
> +	case V4L2_BUF_TYPE_SDR_RX:
> +		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_vid_cap))
> +			break;
> +		return ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
>  	}
>  	return -EINVAL;
>  }
> @@ -1057,6 +1066,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_format *p = arg;
>  	struct video_device *vfd = video_devdata(file);
>  	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
> +	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
>  	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>  
> @@ -1101,6 +1111,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!is_tx || is_vid || !ops->vidioc_g_fmt_sliced_vbi_out))
>  			break;
>  		return ops->vidioc_g_fmt_sliced_vbi_out(file, fh, arg);
> +	case V4L2_BUF_TYPE_SDR_RX:
> +		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_g_fmt_vid_cap))
> +			break;
> +		return ops->vidioc_g_fmt_vid_cap(file, fh, arg);
>  	}
>  	return -EINVAL;
>  }
> @@ -1111,6 +1125,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_format *p = arg;
>  	struct video_device *vfd = video_devdata(file);
>  	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
> +	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
>  	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>  
> @@ -1165,6 +1180,11 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sliced);
>  		return ops->vidioc_s_fmt_sliced_vbi_out(file, fh, arg);
> +	case V4L2_BUF_TYPE_SDR_RX:
> +		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_s_fmt_vid_cap))
> +			break;
> +		CLEAR_AFTER_FIELD(p, fmt.sdr);
> +		return ops->vidioc_s_fmt_vid_cap(file, fh, arg);
>  	}
>  	return -EINVAL;
>  }
> @@ -1175,6 +1195,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  	struct v4l2_format *p = arg;
>  	struct video_device *vfd = video_devdata(file);
>  	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
> +	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
>  	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
>  	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>  
> @@ -1229,6 +1250,11 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sliced);
>  		return ops->vidioc_try_fmt_sliced_vbi_out(file, fh, arg);
> +	case V4L2_BUF_TYPE_SDR_RX:
> +		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_try_fmt_vid_cap))
> +			break;
> +		CLEAR_AFTER_FIELD(p, fmt.sdr);
> +		return ops->vidioc_try_fmt_vid_cap(file, fh, arg);
>  	}
>  	return -EINVAL;
>  }
> 


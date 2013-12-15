Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:25484 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3LOLYM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 06:24:12 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXU00AJSICA1I60@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sun, 15 Dec 2013 06:24:10 -0500 (EST)
Date: Sun, 15 Dec 2013 09:23:26 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH RFC v2 7/7] v4l: define own IOCTL ops for SDR FMT
Message-id: <20131215092326.74c28792.m.chehab@samsung.com>
In-reply-to: <52AC8645.2010707@iki.fi>
References: <1387037729-1977-1-git-send-email-crope@iki.fi>
 <1387037729-1977-8-git-send-email-crope@iki.fi> <52AC8645.2010707@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 14 Dec 2013 18:24:37 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> Hello, Mauro, Hans,
> 
> On 14.12.2013 18:15, Antti Palosaari wrote:
> > Use own format ops for SDR data:
> > vidioc_enum_fmt_sdr_cap
> > vidioc_g_fmt_sdr_cap
> > vidioc_s_fmt_sdr_cap
> > vidioc_try_fmt_sdr_cap
> 
> To be honest, I am a little bit against that patch. Is there any good 
> reason we duplicate these FMT ops every-time when new stream format is 
> added? For my eyes that is mostly just bloating the code without good 
> reason.

The is one reason: when the same device can be used in both SDR and non
SDR mode (radio, video, vbi), then either the driver or the core would
need to select the right set of vidioc_*fmt_* ops.

In the past, all drivers had about the same logic for such tests.
Yet, as the implementations weren't the same, several of them were
implementing it wrong.

So, we ended by moving those validations to the core.

> 
> regards
> Antti
> 
> 
> >
> > Cc: Hans Verkuil <hverkuil@xs4all.nl>
> > Signed-off-by: Antti Palosaari <crope@iki.fi>
> > ---
> >   drivers/media/v4l2-core/v4l2-dev.c   |  8 ++++----
> >   drivers/media/v4l2-core/v4l2-ioctl.c | 18 +++++++++---------
> >   include/media/v4l2-ioctl.h           |  8 ++++++++
> >   3 files changed, 21 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> > index 9f15e25..a84f4ea 100644
> > --- a/drivers/media/v4l2-core/v4l2-dev.c
> > +++ b/drivers/media/v4l2-core/v4l2-dev.c
> > @@ -673,13 +673,13 @@ static void determine_valid_ioctls(struct video_device *vdev)
> >   		SET_VALID_IOCTL(ops, VIDIOC_G_SLICED_VBI_CAP, vidioc_g_sliced_vbi_cap);
> >   	} else if (is_sdr) {
> >   		/* SDR specific ioctls */
> > -		if (ops->vidioc_enum_fmt_vid_cap)
> > +		if (ops->vidioc_enum_fmt_sdr_cap)
> >   			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
> > -		if (ops->vidioc_g_fmt_vid_cap)
> > +		if (ops->vidioc_g_fmt_sdr_cap)
> >   			set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
> > -		if (ops->vidioc_s_fmt_vid_cap)
> > +		if (ops->vidioc_s_fmt_sdr_cap)
> >   			set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
> > -		if (ops->vidioc_try_fmt_vid_cap)
> > +		if (ops->vidioc_try_fmt_sdr_cap)
> >   			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
> >
> >   		if (is_rx) {
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> > index a7e6b52..18aa36a 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -939,7 +939,7 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
> >   			return 0;
> >   		break;
> >   	case V4L2_BUF_TYPE_SDR_CAPTURE:
> > -		if (is_sdr && is_rx && ops->vidioc_g_fmt_vid_cap)
> > +		if (is_sdr && is_rx && ops->vidioc_g_fmt_sdr_cap)
> >   			return 0;
> >   		break;
> >   	default:
> > @@ -1062,9 +1062,9 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
> >   			break;
> >   		return ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
> >   	case V4L2_BUF_TYPE_SDR_CAPTURE:
> > -		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_vid_cap))
> > +		if (unlikely(!is_rx || !ops->vidioc_enum_fmt_sdr_cap))
> >   			break;
> > -		return ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
> > +		return ops->vidioc_enum_fmt_sdr_cap(file, fh, arg);
> >   	}
> >   	return -EINVAL;
> >   }
> > @@ -1121,9 +1121,9 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
> >   			break;
> >   		return ops->vidioc_g_fmt_sliced_vbi_out(file, fh, arg);
> >   	case V4L2_BUF_TYPE_SDR_CAPTURE:
> > -		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_g_fmt_vid_cap))
> > +		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_g_fmt_sdr_cap))
> >   			break;
> > -		return ops->vidioc_g_fmt_vid_cap(file, fh, arg);
> > +		return ops->vidioc_g_fmt_sdr_cap(file, fh, arg);
> >   	}
> >   	return -EINVAL;
> >   }
> > @@ -1190,10 +1190,10 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
> >   		CLEAR_AFTER_FIELD(p, fmt.sliced);
> >   		return ops->vidioc_s_fmt_sliced_vbi_out(file, fh, arg);
> >   	case V4L2_BUF_TYPE_SDR_CAPTURE:
> > -		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_s_fmt_vid_cap))
> > +		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_s_fmt_sdr_cap))
> >   			break;
> >   		CLEAR_AFTER_FIELD(p, fmt.sdr);
> > -		return ops->vidioc_s_fmt_vid_cap(file, fh, arg);
> > +		return ops->vidioc_s_fmt_sdr_cap(file, fh, arg);
> >   	}
> >   	return -EINVAL;
> >   }
> > @@ -1260,10 +1260,10 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
> >   		CLEAR_AFTER_FIELD(p, fmt.sliced);
> >   		return ops->vidioc_try_fmt_sliced_vbi_out(file, fh, arg);
> >   	case V4L2_BUF_TYPE_SDR_CAPTURE:
> > -		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_try_fmt_vid_cap))
> > +		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_try_fmt_sdr_cap))
> >   			break;
> >   		CLEAR_AFTER_FIELD(p, fmt.sdr);
> > -		return ops->vidioc_try_fmt_vid_cap(file, fh, arg);
> > +		return ops->vidioc_try_fmt_sdr_cap(file, fh, arg);
> >   	}
> >   	return -EINVAL;
> >   }
> > diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> > index e0b74a4..8be32f5 100644
> > --- a/include/media/v4l2-ioctl.h
> > +++ b/include/media/v4l2-ioctl.h
> > @@ -40,6 +40,8 @@ struct v4l2_ioctl_ops {
> >   					      struct v4l2_fmtdesc *f);
> >   	int (*vidioc_enum_fmt_vid_out_mplane)(struct file *file, void *fh,
> >   					      struct v4l2_fmtdesc *f);
> > +	int (*vidioc_enum_fmt_sdr_cap)     (struct file *file, void *fh,
> > +					    struct v4l2_fmtdesc *f);
> >
> >   	/* VIDIOC_G_FMT handlers */
> >   	int (*vidioc_g_fmt_vid_cap)    (struct file *file, void *fh,
> > @@ -62,6 +64,8 @@ struct v4l2_ioctl_ops {
> >   					   struct v4l2_format *f);
> >   	int (*vidioc_g_fmt_vid_out_mplane)(struct file *file, void *fh,
> >   					   struct v4l2_format *f);
> > +	int (*vidioc_g_fmt_sdr_cap)    (struct file *file, void *fh,
> > +					struct v4l2_format *f);
> >
> >   	/* VIDIOC_S_FMT handlers */
> >   	int (*vidioc_s_fmt_vid_cap)    (struct file *file, void *fh,
> > @@ -84,6 +88,8 @@ struct v4l2_ioctl_ops {
> >   					   struct v4l2_format *f);
> >   	int (*vidioc_s_fmt_vid_out_mplane)(struct file *file, void *fh,
> >   					   struct v4l2_format *f);
> > +	int (*vidioc_s_fmt_sdr_cap)    (struct file *file, void *fh,
> > +					struct v4l2_format *f);
> >
> >   	/* VIDIOC_TRY_FMT handlers */
> >   	int (*vidioc_try_fmt_vid_cap)    (struct file *file, void *fh,
> > @@ -106,6 +112,8 @@ struct v4l2_ioctl_ops {
> >   					     struct v4l2_format *f);
> >   	int (*vidioc_try_fmt_vid_out_mplane)(struct file *file, void *fh,
> >   					     struct v4l2_format *f);
> > +	int (*vidioc_try_fmt_sdr_cap)    (struct file *file, void *fh,
> > +					  struct v4l2_format *f);
> >
> >   	/* Buffer handlers */
> >   	int (*vidioc_reqbufs) (struct file *file, void *fh, struct v4l2_requestbuffers *b);
> >
> 
> 


-- 

Cheers,
Mauro

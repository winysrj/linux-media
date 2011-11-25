Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4026 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1KYL3L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 06:29:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 3/3] ivtv: setup per-device caps.
Date: Fri, 25 Nov 2011 12:29:02 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1321956322-25084-1-git-send-email-hverkuil@xs4all.nl> <a74598d6964e8582de02d3cfbc22d52fc000d033.1321956058.git.hans.verkuil@cisco.com> <4ECF754F.3090207@redhat.com>
In-Reply-To: <4ECF754F.3090207@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251229.02582.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, November 25, 2011 12:00:31 Mauro Carvalho Chehab wrote:
> Em 22-11-2011 08:05, Hans Verkuil escreveu:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/ivtv/ivtv-driver.h  |    1 +
> >  drivers/media/video/ivtv/ivtv-ioctl.c   |    7 +++++--
> >  drivers/media/video/ivtv/ivtv-streams.c |   14 ++++++++++++++
> >  3 files changed, 20 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
> > index 8f9cc17..06b9efd 100644
> > --- a/drivers/media/video/ivtv/ivtv-driver.h
> > +++ b/drivers/media/video/ivtv/ivtv-driver.h
> > @@ -331,6 +331,7 @@ struct ivtv_stream {
> >  	struct ivtv *itv; 		/* for ease of use */
> >  	const char *name;		/* name of the stream */
> >  	int type;			/* stream type */
> > +	u32 caps;			/* V4L2 capabilities */
> >  
> >  	u32 id;
> >  	spinlock_t qlock; 		/* locks access to the queues */
> > diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
> > index ecafa69..6be63e9 100644
> > --- a/drivers/media/video/ivtv/ivtv-ioctl.c
> > +++ b/drivers/media/video/ivtv/ivtv-ioctl.c
> > @@ -752,12 +752,15 @@ static int ivtv_s_register(struct file *file, void *fh, struct v4l2_dbg_register
> >  
> >  static int ivtv_querycap(struct file *file, void *fh, struct v4l2_capability *vcap)
> >  {
> > -	struct ivtv *itv = fh2id(fh)->itv;
> > +	struct ivtv_open_id *id = fh2id(file->private_data);
> > +	struct ivtv *itv = id->itv;
> > +	struct ivtv_stream *s = &itv->streams[id->type];
> >  
> >  	strlcpy(vcap->driver, IVTV_DRIVER_NAME, sizeof(vcap->driver));
> >  	strlcpy(vcap->card, itv->card_name, sizeof(vcap->card));
> >  	snprintf(vcap->bus_info, sizeof(vcap->bus_info), "PCI:%s", pci_name(itv->pdev));
> > -	vcap->capabilities = itv->v4l2_cap; 	    /* capabilities */
> > +	vcap->capabilities = itv->v4l2_cap | V4L2_CAP_DEVICE_CAPS;
> 
> IMO, the right thing to do here would be:
> 
> 	vcap->capabilities = V4L2_CAP_DEVICE_CAPS;
> 	for (i = 0; i < ARRAY_SIZE(ivtv_stream_info); i++)
> 		vcap->capabilities |= ivtv_stream_info[v4l2_caps];

This won't work actually. Which devices are available depends on more things
than just that array. It's not something I think needs to change.

> This avoids the risk of future patches adding new device_caps at the devices, but
> forgetting to update the physical device capabilities.
>
> Also, as the initial patches will be used as implementation reference by others,
> such implementation will be more effective than a "magic" set of features that
> may or may not match the union of all device capabilities.

I wouldn't use ivtv as a reference implementation (other than for cx18). vivi however
is a very nice reference implementation these days.

As soon as this patch is in I'll also update v4l2-compliance.

Regards,

	Hans

> 
> > +	vcap->device_caps = s->caps;
> >  	return 0;
> >  }
> >  
> > diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
> > index e7794dc..4d4ae6e 100644
> > --- a/drivers/media/video/ivtv/ivtv-streams.c
> > +++ b/drivers/media/video/ivtv/ivtv-streams.c
> > @@ -78,60 +78,73 @@ static struct {
> >  	int num_offset;
> >  	int dma, pio;
> >  	enum v4l2_buf_type buf_type;
> > +	u32 v4l2_caps;
> >  	const struct v4l2_file_operations *fops;
> >  } ivtv_stream_info[] = {
> >  	{	/* IVTV_ENC_STREAM_TYPE_MPG */
> >  		"encoder MPG",
> >  		VFL_TYPE_GRABBER, 0,
> >  		PCI_DMA_FROMDEVICE, 0, V4L2_BUF_TYPE_VIDEO_CAPTURE,
> > +		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
> > +			V4L2_CAP_AUDIO | V4L2_CAP_READWRITE,
> >  		&ivtv_v4l2_enc_fops
> >  	},
> >  	{	/* IVTV_ENC_STREAM_TYPE_YUV */
> >  		"encoder YUV",
> >  		VFL_TYPE_GRABBER, IVTV_V4L2_ENC_YUV_OFFSET,
> >  		PCI_DMA_FROMDEVICE, 0, V4L2_BUF_TYPE_VIDEO_CAPTURE,
> > +		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
> > +			V4L2_CAP_AUDIO | V4L2_CAP_READWRITE,
> >  		&ivtv_v4l2_enc_fops
> >  	},
> >  	{	/* IVTV_ENC_STREAM_TYPE_VBI */
> >  		"encoder VBI",
> >  		VFL_TYPE_VBI, 0,
> >  		PCI_DMA_FROMDEVICE, 0, V4L2_BUF_TYPE_VBI_CAPTURE,
> > +		V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_CAPTURE | V4L2_CAP_TUNER |
> > +			V4L2_CAP_AUDIO | V4L2_CAP_READWRITE,
> >  		&ivtv_v4l2_enc_fops
> >  	},
> >  	{	/* IVTV_ENC_STREAM_TYPE_PCM */
> >  		"encoder PCM",
> >  		VFL_TYPE_GRABBER, IVTV_V4L2_ENC_PCM_OFFSET,
> >  		PCI_DMA_FROMDEVICE, 0, V4L2_BUF_TYPE_PRIVATE,
> > +		V4L2_CAP_TUNER | V4L2_CAP_AUDIO | V4L2_CAP_READWRITE,
> >  		&ivtv_v4l2_enc_fops
> >  	},
> >  	{	/* IVTV_ENC_STREAM_TYPE_RAD */
> >  		"encoder radio",
> >  		VFL_TYPE_RADIO, 0,
> >  		PCI_DMA_NONE, 1, V4L2_BUF_TYPE_PRIVATE,
> > +		V4L2_CAP_RADIO | V4L2_CAP_TUNER,
> >  		&ivtv_v4l2_enc_fops
> >  	},
> >  	{	/* IVTV_DEC_STREAM_TYPE_MPG */
> >  		"decoder MPG",
> >  		VFL_TYPE_GRABBER, IVTV_V4L2_DEC_MPG_OFFSET,
> >  		PCI_DMA_TODEVICE, 0, V4L2_BUF_TYPE_VIDEO_OUTPUT,
> > +		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_AUDIO | V4L2_CAP_READWRITE,
> >  		&ivtv_v4l2_dec_fops
> >  	},
> >  	{	/* IVTV_DEC_STREAM_TYPE_VBI */
> >  		"decoder VBI",
> >  		VFL_TYPE_VBI, IVTV_V4L2_DEC_VBI_OFFSET,
> >  		PCI_DMA_NONE, 1, V4L2_BUF_TYPE_VBI_CAPTURE,
> > +		V4L2_CAP_SLICED_VBI_CAPTURE | V4L2_CAP_READWRITE,
> >  		&ivtv_v4l2_enc_fops
> >  	},
> >  	{	/* IVTV_DEC_STREAM_TYPE_VOUT */
> >  		"decoder VOUT",
> >  		VFL_TYPE_VBI, IVTV_V4L2_DEC_VOUT_OFFSET,
> >  		PCI_DMA_NONE, 1, V4L2_BUF_TYPE_VBI_OUTPUT,
> > +		V4L2_CAP_SLICED_VBI_OUTPUT | V4L2_CAP_AUDIO | V4L2_CAP_READWRITE,
> >  		&ivtv_v4l2_dec_fops
> >  	},
> >  	{	/* IVTV_DEC_STREAM_TYPE_YUV */
> >  		"decoder YUV",
> >  		VFL_TYPE_GRABBER, IVTV_V4L2_DEC_YUV_OFFSET,
> >  		PCI_DMA_TODEVICE, 0, V4L2_BUF_TYPE_VIDEO_OUTPUT,
> > +		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_AUDIO | V4L2_CAP_READWRITE,
> >  		&ivtv_v4l2_dec_fops
> >  	}
> >  };
> > @@ -149,6 +162,7 @@ static void ivtv_stream_init(struct ivtv *itv, int type)
> >  	s->itv = itv;
> >  	s->type = type;
> >  	s->name = ivtv_stream_info[type].name;
> > +	s->caps = ivtv_stream_info[type].v4l2_caps;
> >  
> >  	if (ivtv_stream_info[type].pio)
> >  		s->dma = PCI_DMA_NONE;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

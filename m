Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:48180 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbcCKNtO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 08:49:14 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: platform: pxa_camera: convert to vb2
References: <1457543851-17823-1-git-send-email-robert.jarzmik@free.fr>
	<56E2BD79.9080405@xs4all.nl>
Date: Fri, 11 Mar 2016 14:41:37 +0100
In-Reply-To: <56E2BD79.9080405@xs4all.nl> (Hans Verkuil's message of "Fri, 11
	Mar 2016 13:43:37 +0100")
Message-ID: <8760wtdtda.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> Hi Robert,
>
> A quick review below.
>
> I assume this is the first step to moving the pxa_camera driver out of
> soc-camera?
Hi Hans,

It probably is. The next step would be the soc_camera adherence removal. I
already began the work, but it's still in very early draft ugly state.

But if I end up duplicating 50% or more of soc_camera code, we should revisit
the approach, as each driver will duplicate that same code over and over.

A small nitpick for the next reviews, I'd like you to quote only subparts of the
submission, not the full patch where there are no comments. That makes mails
smaller and easier to follow up.

>> +static int pxa_buffer_init(struct pxa_camera_dev *pcdev,
>> +			   struct pxa_buffer *buf)
>> +{
>> +	struct vb2_buffer *vb = &buf->vbuf.vb2_buf;
>> +	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
>> +	int nb_channels = pcdev->channels;
>> +	int i, ret = 0;
>> +	unsigned long size = vb2_get_plane_payload(vb, 0);
>
> I wouldn't use payload here but icd->sizeimage instead.
>
> You set the payload in the prepare function, no need to do that here.
Ah, that's a special case we need to discuss.
I've written in the commit message a chapter about a "special port of this
code". This is it.

This usecase is when a user does the following :
 - set format to 1280x1024, RGB565
 - REQBUF for MMAP buffers
 - QBUF, capture, DQBUF

 - then set format to 640x480, RGB565
   => here the new format fits in the previously allocated video buffer
 - QBUF
   => the test in pxa_vb2_prepare() detects this, and calls pxa_buffer_init()
   again

Now if this usecase is impossible, then I'll do as you say to simplify the code
: use icd->sizeimage, remove the code in pxa_vb2_prepare(), etc ...

>> +	for (i = 0; i < pcdev->channels && vb2_plane_vaddr(vb, i); i++)
>> +		if (vb2_get_plane_payload(vb, i) > vb2_plane_size(vb, i))
>> +			return -EINVAL;
>
> No need for this check, this can't happen. This is checked when the buffers are
> allocated, and once allocated icd->sizeimage can no longer change.
Okay, that's good. Simpler is better, I'll remove it.

>> +
>> +	if ((pcdev->channels != buf->nb_planes) ||
>> +	    (vb2_get_plane_payload(vb, 0) != buf->plane_sizes[0])) {
>> +		pxa_buffer_cleanup(buf);
>> +		ret = pxa_buffer_init(pcdev, buf);
>> +		if (ret)
>> +			return ret;
>> +	}
>
> Ditto, this can't happen on the fly.
That's part of the discussion above. I'll remove it if I get confirmation the
usecase I described above is impossible by construction of the videobuf2 API.

>> +static int pxa_vb2_queue_setup(struct vb2_queue *vq,
>> +			       unsigned int *nbufs,
>> +			       unsigned int *num_planes, unsigned int sizes[],
>> +			       void *alloc_ctxs[])
>> +{
>> +	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vq);
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
>> +	int size = icd->sizeimage;
>> +
>> +	dev_dbg(pcdev_to_dev(pcdev),
>> +		 "%s(vq=%p nbufs=%d num_planes=%d)\n",
>> +		 __func__, vq, *nbufs, *num_planes);
>> +	/*
>> +	 * Called from VIDIOC_REQBUFS or in compatibility mode For YUV422P
>> +	 * format, even if there are 3 planes Y, U and V, we reply there is only
>> +	 * one plane, containing Y, U and V data, one after the other.
>> +	 */
>> +	if (!*num_planes) {
>> +		switch (pcdev->channels) {
>> +		case 1:
>> +		case 3:
>> +			sizes[0] = icd->sizeimage;
>> +			break;
>> +		default:
>> +			return -EINVAL;
>> +		}
>> +		*num_planes = 1;
>> +	}
>
> Missing case when called from VIDIOC_CREATE_BUFS: in that case check that the
> buffer is large enough to store the current format.
>
> 	} else {
> 		return sizes[0] < icd->sizeimage ? -EINVAL : 0;
> 	}
Okay, will add that for v2.

>> +
>> +	alloc_ctxs[0] = pcdev->alloc_ctx;
>> +
>> +	if (!*nbufs)
>> +		*nbufs = 1;
>> +
>> +	if (size * *nbufs > vid_limit * 1024 * 1024)
>> +		*nbufs = (vid_limit * 1024 * 1024) / size;
>
> Is this a real hardware limit or an artificial software limit?
Artificial limit.

> If the latter, then just remove it. If you don't have the memory to allocate
> the buffers, then reqbufs will just return ENOMEM. I never saw a reason for
> such checks.
Okay, that was to be consistent with former driver behavior. This was from the
beginning in this driver. If Guennadi doesn't care, then I'll remove that, as he
is the original author of this limitation.

>> +static void pxa_vb2_stop_streaming(struct vb2_queue *vq)
>> +{
>> +	vb2_wait_for_all_buffers(vq);
>
> This is normally where the DMA is shut off. Is that not needed for this
> hardware?
Well, this is keeping the legacy driver's behavior : wait for all DMAs to have
finished, ie. stopped, which is guaranteed by waiting for all vb2_done() calls
which in turn happen only when DMAs are finished, and then return.

I'm intending in an incremental patch to have the dmaengine_terminate_sync()
call used here, but for the conversion I'll be keeping the legacy behavior.

Thanks for the review.

-- 
Robert

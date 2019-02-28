Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274FEC43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 14:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF2992133D
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551362962;
	bh=3EJM4ngpgvoLhg0Ay2sFWB/2E8KIKqP/U8GpHvQUVvA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=nxrP8oLBOCQz/29XA3LNi8HFTzI8sU7W2Y69+TKWyipNFEnYK2HU8GlC7unmz2mt1
	 W5CR+7gIQfsEuCqNsJBVxDl+d1DljdP7Mjs1K1tI1F/9LHjBBwif+EQnjRkCwG2OiG
	 iTxZtCk0UKYY0UtNeOLEImb6qA1h1W3h8Wr04FFE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbfB1OJV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 09:09:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36196 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbfB1OJU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 09:09:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2r0m9ZXcZSZ0CMZ7bEV6+ll8LzwdfJeQrA2TyHL7Cvg=; b=nHFPm3HQVLbAXRloL50r8Oe8U
        2bGMfKofA9OD987oTXIUHo4Tp8vGeHazP4jUg4Z5/VGfdJcfkCZLn46IN9ua7ZTcGgbD5cZY8cmvv
        DuzouDNe8s9ozxxGSR6CCcdFbu9y5VKgRXQ7TUo95oJv655AcpMlsxmmev32XAUL+7dw/GzWBmKj9
        Q8t0QMzILyGzEbuDg5GaYgPUWcFG+O0vkvxdSceZpaMTg9RNW4XejchSC6yiO6tLnLluixeIiqWWy
        FRuS1y0vehkosR+LeM/NgmQ5+jhcyYyqbVrQ5BOkWVPohu92vXYwc9RmRlpcXJQgNmVWAYNqitO0W
        YnFs2JJMA==;
Received: from 177.41.100.217.dynamic.adsl.gvt.net.br ([177.41.100.217] helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzMNC-0002wL-UX; Thu, 28 Feb 2019 14:09:19 +0000
Date:   Thu, 28 Feb 2019 11:09:14 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [PATCH v2] media: vim2m: better handle cap/out buffers with
 different sizes
Message-ID: <20190228110914.0b2613eb@coco.lan>
In-Reply-To: <84696204-2b3a-74ed-f470-52cc54fa201b@xs4all.nl>
References: <8d0a822ce02e1eb95f4a59cc9aabceb5a5661dda.1551202576.git.mchehab+samsung@kernel.org>
        <84696204-2b3a-74ed-f470-52cc54fa201b@xs4all.nl>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 28 Feb 2019 13:30:49 +0100
Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:

> On 2/26/19 6:36 PM, Mauro Carvalho Chehab wrote:
> > The vim2m driver doesn't enforce that the capture and output
> > buffers would have the same size. Do the right thing if the
> > buffers are different, zeroing the buffer before writing,
> > ensuring that lines will be aligned and it won't write past
> > the buffer area.  
> 
> I don't really like this. Since the vimc driver doesn't scale it shouldn't
> automatically crop either. If you want to crop/compose, then the
> selection API should be implemented.
> 
> That would be the right approach to allowing capture and output
> formats (we're talking formats here, not buffer sizes) with
> different resolutions.

The original vim2m implementation assumes that this driver would
"scale" and do format conversions (except that it didn't do neither).

While I fixed the format conversion on a past patchset, vim2m
still allows a "free" image size on both sides of the pipeline.

I agree with you that the best would be to implement a scaler
(and maybe crop/compose), but for now, we need to solve an issue that
vim2m is doing a very poor job to confine the image at the destination
buffer's resolution.

Also, as far as I remember, the first M2M devices have scalers, so
existing apps likely assume that such devices will do scaling.

So, a non-scaling M2M device is something that, in thesis, we don't
support[1].

[1] Very likely we have several ones that don't do scaling, but the
needed API bits for apps to detect if scaling is supported or not
aren't implemented.

The problem of enforcing the resolution to be identical on both capture
and output buffers is that the V4L2 API doesn't really have
a way for userspace apps to identify that it won't scale until
too late.

How do you imagine an application negotiating the image resolution?

I mean, application A may set first the capture buffer to, let's say,
320x200 and then try to set the output buffer. 

Application B may do the reverse, e. g. set first the output buffer
to 320x200 and then try to set the capture buffer.

Application C could try to initialize with some default for both 
capture and output buffers and only later decide what resolution
it wants and try to set both sides.

Application D could have setup both sides, started streaming at 
320x200. Then, it stopped streaming and changed the capture 
resolution to, let's say 640x480, without changing the resolution
of the output buffer.

For all the above scenarios, the app may either first set both
sides and then request the buffer for both, or do S_FMT/REQBUFS
for one side and then to the other side.

What I mean is that, wit just use the existing ioctls and flags, I 
can't see any way for all the above scenarios work on devices that
don't scale.

One solution would be to filter the output of ENUM_FMT, TRY_FMT,
G_FMT and S_FMT when one of the sides of the M2M buffer is set,
but that would break some possible real usecases.

I suspect that the option that it would work best is to have a
flag to indicate that a M2M device has scalers.

In any case, this should be discussed and properly documented
before we would be able to implement a non-scaling M2M device.

-

Without a clear way for the API to report that the device can't scale,
an application like, for example, the GStreamer plugin, won't be able to 
detect that the resolutions should be identical until too late (at
STREAMON).

IMO, this is something that we should address, but it is out of the
scope of this fixup patch.

That's why I prefer to keep vim2m working supporting different
resolutions on each side of the M2M device.

-

That's said, I may end working on a very simple scaler patch for vim2m. 

I suspect that a simple decimation filtering like:

#define x_scale xout_max / xin_max
#define y_scale yout_max / yin_max

	out_pixel(x, y) = in_pixel(x * x_scale, y * y_scale)

would be simple enough to implement at the current image copy
thread.

Regards,
Mauro

> 
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >  drivers/media/platform/vim2m.c | 26 +++++++++++++++++++-------
> >  1 file changed, 19 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> > index 89384f324e25..46e3e096123e 100644
> > --- a/drivers/media/platform/vim2m.c
> > +++ b/drivers/media/platform/vim2m.c
> > @@ -481,7 +481,9 @@ static int device_process(struct vim2m_ctx *ctx,
> >  	struct vim2m_dev *dev = ctx->dev;
> >  	struct vim2m_q_data *q_data_in, *q_data_out;
> >  	u8 *p_in, *p, *p_out;
> > -	int width, height, bytesperline, x, y, y_out, start, end, step;
> > +	unsigned int width, height, bytesperline, bytesperline_out;
> > +	unsigned int x, y, y_out;
> > +	int start, end, step;
> >  	struct vim2m_fmt *in, *out;
> >  
> >  	q_data_in = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > @@ -491,8 +493,15 @@ static int device_process(struct vim2m_ctx *ctx,
> >  	bytesperline = (q_data_in->width * q_data_in->fmt->depth) >> 3;
> >  
> >  	q_data_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> > +	bytesperline_out = (q_data_out->width * q_data_out->fmt->depth) >> 3;
> >  	out = q_data_out->fmt;
> >  
> > +	/* Crop to the limits of the destination image */
> > +	if (width > q_data_out->width)
> > +		width = q_data_out->width;
> > +	if (height > q_data_out->height)
> > +		height = q_data_out->height;
> > +
> >  	p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
> >  	p_out = vb2_plane_vaddr(&out_vb->vb2_buf, 0);
> >  	if (!p_in || !p_out) {
> > @@ -501,6 +510,10 @@ static int device_process(struct vim2m_ctx *ctx,
> >  		return -EFAULT;
> >  	}
> >  
> > +	/* Image size is different. Zero buffer first */
> > +	if (q_data_in->width  != q_data_out->width ||
> > +	    q_data_in->height != q_data_out->height)
> > +		memset(p_out, 0, q_data_out->sizeimage);
> >  	out_vb->sequence = get_q_data(ctx,
> >  				      V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
> >  	in_vb->sequence = q_data_in->sequence++;
> > @@ -524,6 +537,11 @@ static int device_process(struct vim2m_ctx *ctx,
> >  		for (x = 0; x < width >> 1; x++)
> >  			copy_two_pixels(in, out, &p, &p_out, y_out,
> >  					ctx->mode & MEM2MEM_HFLIP);
> > +
> > +		/* Go to the next line at the out buffer*/  
> 
> Add space after 'buffer'.
> 
> > +		if (width < q_data_out->width)
> > +			p_out += ((q_data_out->width - width)
> > +				  * q_data_out->fmt->depth) >> 3;
> >  	}
> >  
> >  	return 0;
> > @@ -977,12 +995,6 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
> >  	dprintk(ctx->dev, 2, "type: %s\n", type_name(vb->vb2_queue->type));
> >  
> >  	q_data = get_q_data(ctx, vb->vb2_queue->type);
> > -	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
> > -		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
> > -				__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
> > -		return -EINVAL;
> > -	}
> > -  
> 
> As discussed on irc, this can't be removed. It checks if the provided buffer
> is large enough for the current format.
> 
> Regards,
> 
> 	Hans
> 
> >  	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
> >  
> >  	return 0;
> >   
> 



Thanks,
Mauro

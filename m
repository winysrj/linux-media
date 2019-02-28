Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F71C4360F
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 15:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60C08214D8
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 15:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551367305;
	bh=gEa7CO/M1blkEPYiytwwmerX6LfWKI7tUmAv6oh/Xkk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=sHZ+iUUT497kGbFpAXu6Y9Nc4wJ07wYCG7OMp9gdbISJ25LvRch7rtnSYpwJU9tr/
	 b9wQEkhhUBhCO0eDFhgZ6afO0Ry01IcZ1aKLsMV+rhHzmzkaUu89GZdCuEe3flSy04
	 pJwtxsS8v07QeUzfcVQvi9dpKrBd/iKqfSTlFd+I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbfB1PVo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:21:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45638 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbfB1PVn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 10:21:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lAiLndml9tEwQ0g6UgFVU/6BAWRV2pXqlT8aHHJVfPk=; b=AZabywr8ME8qsR4CC0fyHx0bJ
        m/3OFSFI5TJcGCGnPqLj2rcmMVVPQmJsQkwXOV9FCQG27/+Ozg2Y3bUF4nA2S84w2TRxGqgRdP84M
        4+fgsr3psHR+hF01/Cq1VkjlAzhAa2iOoJUFa2Js4mOg9TaH/IpMU4GnUuValrpjI55SFABmqOko0
        Otp2robrVyqdj5/+cW4RTD2qwG7vqt8P0cNhBwG/IA3mMn7kbVtvK+00EFqz6gWrKYrtl5pCN/J47
        Z0ykkd2k6qGrrCZ8w9Kg7ubiAk8s39PEkRq2axM9q+S5ag6oM12WqJ/lSlvYJilXHQE0Iq1JT1BNC
        CSCnJpFaw==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzNVH-0004GX-1v; Thu, 28 Feb 2019 15:21:43 +0000
Date:   Thu, 28 Feb 2019 12:21:39 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [PATCH v2] media: vim2m: better handle cap/out buffers with
 different sizes
Message-ID: <20190228122139.6ac6c25d@coco.lan>
In-Reply-To: <4cc0d8e1-7e25-1b9d-8bfe-921716522909@xs4all.nl>
References: <8d0a822ce02e1eb95f4a59cc9aabceb5a5661dda.1551202576.git.mchehab+samsung@kernel.org>
        <84696204-2b3a-74ed-f470-52cc54fa201b@xs4all.nl>
        <20190228110914.0b2613eb@coco.lan>
        <4cc0d8e1-7e25-1b9d-8bfe-921716522909@xs4all.nl>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 28 Feb 2019 15:35:07 +0100
Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:

> On 2/28/19 3:09 PM, Mauro Carvalho Chehab wrote:
> > Em Thu, 28 Feb 2019 13:30:49 +0100
> > Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:
> >  =20
> >> On 2/26/19 6:36 PM, Mauro Carvalho Chehab wrote: =20
> >>> The vim2m driver doesn't enforce that the capture and output
> >>> buffers would have the same size. Do the right thing if the
> >>> buffers are different, zeroing the buffer before writing,
> >>> ensuring that lines will be aligned and it won't write past
> >>> the buffer area.   =20
> >>
> >> I don't really like this. Since the vimc driver doesn't scale it shoul=
dn't
> >> automatically crop either. If you want to crop/compose, then the
> >> selection API should be implemented.
> >>
> >> That would be the right approach to allowing capture and output
> >> formats (we're talking formats here, not buffer sizes) with
> >> different resolutions. =20
> >=20
> > The original vim2m implementation assumes that this driver would
> > "scale" and do format conversions (except that it didn't do neither). =
=20
>=20
> I'm not sure we should assume anything about the original implementation.
> It had lots of issues. I rather do this right then keep supporting hacks.

True, but we are too close to the merge window. That's why I opted on
solving the bug, and not changing the behavior.

>=20
> > While I fixed the format conversion on a past patchset, vim2m
> > still allows a "free" image size on both sides of the pipeline.
> >=20
> > I agree with you that the best would be to implement a scaler
> > (and maybe crop/compose), but for now, we need to solve an issue that
> > vim2m is doing a very poor job to confine the image at the destination
> > buffer's resolution.
> >=20
> > Also, as far as I remember, the first M2M devices have scalers, so
> > existing apps likely assume that such devices will do scaling. =20
>=20
> Most m2m devices are codecs and codecs do not do scaling (at least,
> I'm not aware of any).

At least on GStreamer, codecs are implemented on a separate logic.
GStreamer checks it using the FOURCC types. If one of the sides is
compressed, it is either an encoder or a decoder. Otherwise, it is
a transform device.

=46rom what I understood from the code (and from my tests), it
assumes that scaler is supported for transform devices.

> I don't think there are many m2m devices that do scaling: most do
> format conversion of one type or another (codecs, deinterlacers,
> yuv-rgb converters). Scalers tend to be integrated into a video
> pipeline. The only m2m drivers I found that also scale are
> exynos-gsc, ti-vpe, mtk-mdp and possibly sti/bdisp.

Well, the M2M API was added with Exynos.=20

> >=20
> > So, a non-scaling M2M device is something that, in thesis, we don't
> > support[1].
> >=20
> > [1] Very likely we have several ones that don't do scaling, but the
> > needed API bits for apps to detect if scaling is supported or not
> > aren't implemented.
> >=20
> > The problem of enforcing the resolution to be identical on both capture
> > and output buffers is that the V4L2 API doesn't really have
> > a way for userspace apps to identify that it won't scale until
> > too late.
> >=20
> > How do you imagine an application negotiating the image resolution?
> >=20
> > I mean, application A may set first the capture buffer to, let's say,
> > 320x200 and then try to set the output buffer.=20
> >=20
> > Application B may do the reverse, e. g. set first the output buffer
> > to 320x200 and then try to set the capture buffer.
> >=20
> > Application C could try to initialize with some default for both=20
> > capture and output buffers and only later decide what resolution
> > it wants and try to set both sides.
> >=20
> > Application D could have setup both sides, started streaming at=20
> > 320x200. Then, it stopped streaming and changed the capture=20
> > resolution to, let's say 640x480, without changing the resolution
> > of the output buffer.
> >=20
> > For all the above scenarios, the app may either first set both
> > sides and then request the buffer for both, or do S_FMT/REQBUFS
> > for one side and then to the other side.
> >=20
> > What I mean is that, wit just use the existing ioctls and flags, I=20
> > can't see any way for all the above scenarios work on devices that
> > don't scale. =20
>=20
> If the device cannot scale, then setting the format on either capture
> or output will modify the format on the other side as well.

That's one way to handle it, but what happens if buffers were already
allocated at one side? If the buffer is USERPTR, this is even worse,
as the size may not fit the image anymore.

Also, changing drivers to this new behavior could break some stuff.

(with this particular matter, changing vim2m code doesn't count as a
change, as this driver should not be used in production - but if any
other driver is doing something different, then we're limited to do
such change)

>=20
> If the device also support cropping and composing, then it becomes
> more complicated, but the basics remain the same.
>=20

I suspect that the above are just assumptions (and perhaps the current
implementation on most drivers). At least, I was unable to find any mention
about the M2M chapter at the V4L2 specs.

> It would certainly be nice if there was a scaling capability. I suspect
> one reason that nobody requested this is that you usually know what
> you are doing when you use an m2m device.

And that's a bad assumption, as it prevents having generic apps
using it. The expected behavior for having and not having scaler
should be described, and we need to be able to cope with legacy stuff.

>=20
> > One solution would be to filter the output of ENUM_FMT, TRY_FMT,
> > G_FMT and S_FMT when one of the sides of the M2M buffer is set,
> > but that would break some possible real usecases. =20
>=20
> Not sure what you mean here.

I mean that one possible solution would be that, if one side sets=20
resolution, the answer for the ioctls on the other side would be
different. IMHO, that's a bad idea.

> >=20
> > I suspect that the option that it would work best is to have a
> > flag to indicate that a M2M device has scalers.
> >=20
> > In any case, this should be discussed and properly documented
> > before we would be able to implement a non-scaling M2M device. =20
>=20
> I don't know where you get the idea that most m2m devices scale.
> The reverse is true, very few m2m devices have a scaler.

No, I didn't say that most m2m devices scale. I said that the initial
M2M implementations scale, and that's probably one of the reasons why=20
this is the behavior that Gstreamer expects scales on transform devices.

>=20
> >=20
> > -
> >=20
> > Without a clear way for the API to report that the device can't scale,
> > an application like, for example, the GStreamer plugin, won't be able t=
o=20
> > detect that the resolutions should be identical until too late (at
> > STREAMON).
> >=20
> > IMO, this is something that we should address, but it is out of the
> > scope of this fixup patch.
> >=20
> > That's why I prefer to keep vim2m working supporting different
> > resolutions on each side of the M2M device. =20
>=20
> I suspect it was always just a bug in vim2m that it allowed different
> resolutions for capture and output.
>=20
> >=20
> > -
> >=20
> > That's said, I may end working on a very simple scaler patch for vim2m.=
  =20
>=20
> v4l2-tpg-core.c uses Coarse Bresenham scaling to implement the scaler.

Yeah, we could reuse part of the logic there, but the challenge here is
to do that at the same logic we already do HFLIP/VFLIP and image transform.

I'll seek for some time to do that.

>=20
> Regards,
>=20
> 	Hans
>=20
> >=20
> > I suspect that a simple decimation filtering like:
> >=20
> > #define x_scale xout_max / xin_max
> > #define y_scale yout_max / yin_max
> >=20
> > 	out_pixel(x, y) =3D in_pixel(x * x_scale, y * y_scale)
> >=20
> > would be simple enough to implement at the current image copy
> > thread.
> >=20
> > Regards,
> > Mauro
> >  =20
> >> =20
> >>>
> >>> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> >>> ---
> >>>  drivers/media/platform/vim2m.c | 26 +++++++++++++++++++-------
> >>>  1 file changed, 19 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/=
vim2m.c
> >>> index 89384f324e25..46e3e096123e 100644
> >>> --- a/drivers/media/platform/vim2m.c
> >>> +++ b/drivers/media/platform/vim2m.c
> >>> @@ -481,7 +481,9 @@ static int device_process(struct vim2m_ctx *ctx,
> >>>  	struct vim2m_dev *dev =3D ctx->dev;
> >>>  	struct vim2m_q_data *q_data_in, *q_data_out;
> >>>  	u8 *p_in, *p, *p_out;
> >>> -	int width, height, bytesperline, x, y, y_out, start, end, step;
> >>> +	unsigned int width, height, bytesperline, bytesperline_out;
> >>> +	unsigned int x, y, y_out;
> >>> +	int start, end, step;
> >>>  	struct vim2m_fmt *in, *out;
> >>> =20
> >>>  	q_data_in =3D get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> >>> @@ -491,8 +493,15 @@ static int device_process(struct vim2m_ctx *ctx,
> >>>  	bytesperline =3D (q_data_in->width * q_data_in->fmt->depth) >> 3;
> >>> =20
> >>>  	q_data_out =3D get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> >>> +	bytesperline_out =3D (q_data_out->width * q_data_out->fmt->depth) >=
> 3;
> >>>  	out =3D q_data_out->fmt;
> >>> =20
> >>> +	/* Crop to the limits of the destination image */
> >>> +	if (width > q_data_out->width)
> >>> +		width =3D q_data_out->width;
> >>> +	if (height > q_data_out->height)
> >>> +		height =3D q_data_out->height;
> >>> +
> >>>  	p_in =3D vb2_plane_vaddr(&in_vb->vb2_buf, 0);
> >>>  	p_out =3D vb2_plane_vaddr(&out_vb->vb2_buf, 0);
> >>>  	if (!p_in || !p_out) {
> >>> @@ -501,6 +510,10 @@ static int device_process(struct vim2m_ctx *ctx,
> >>>  		return -EFAULT;
> >>>  	}
> >>> =20
> >>> +	/* Image size is different. Zero buffer first */
> >>> +	if (q_data_in->width  !=3D q_data_out->width ||
> >>> +	    q_data_in->height !=3D q_data_out->height)
> >>> +		memset(p_out, 0, q_data_out->sizeimage);
> >>>  	out_vb->sequence =3D get_q_data(ctx,
> >>>  				      V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
> >>>  	in_vb->sequence =3D q_data_in->sequence++;
> >>> @@ -524,6 +537,11 @@ static int device_process(struct vim2m_ctx *ctx,
> >>>  		for (x =3D 0; x < width >> 1; x++)
> >>>  			copy_two_pixels(in, out, &p, &p_out, y_out,
> >>>  					ctx->mode & MEM2MEM_HFLIP);
> >>> +
> >>> +		/* Go to the next line at the out buffer*/   =20
> >>
> >> Add space after 'buffer'.
> >> =20
> >>> +		if (width < q_data_out->width)
> >>> +			p_out +=3D ((q_data_out->width - width)
> >>> +				  * q_data_out->fmt->depth) >> 3;
> >>>  	}
> >>> =20
> >>>  	return 0;
> >>> @@ -977,12 +995,6 @@ static int vim2m_buf_prepare(struct vb2_buffer *=
vb)
> >>>  	dprintk(ctx->dev, 2, "type: %s\n", type_name(vb->vb2_queue->type));
> >>> =20
> >>>  	q_data =3D get_q_data(ctx, vb->vb2_queue->type);
> >>> -	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
> >>> -		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
> >>> -				__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
> >>> -		return -EINVAL;
> >>> -	}
> >>> -   =20
> >>
> >> As discussed on irc, this can't be removed. It checks if the provided =
buffer
> >> is large enough for the current format.
> >>
> >> Regards,
> >>
> >> 	Hans
> >> =20
> >>>  	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
> >>> =20
> >>>  	return 0;
> >>>    =20
> >> =20
> >=20
> >=20
> >=20
> > Thanks,
> > Mauro
> >  =20
>=20



Thanks,
Mauro

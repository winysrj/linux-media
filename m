Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36873 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750901AbZAZIhg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2009 03:37:36 -0500
Date: Mon, 26 Jan 2009 09:37:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] ov772x: add support S_CROP operation.
In-Reply-To: <uzlheep1l.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0901260854010.4236@axis700.grange>
References: <uskna4qh8.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0901250245440.4969@axis700.grange> <uzlheep1l.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 26 Jan 2009, morimoto.kuninori@renesas.com wrote:

> 
> Dear Guennadi
> 
> > Have you tested with v4l-dvb/v4l2-apps/test/capture_example.c? I think it 
> > wouldn't work, because it first calls S_CROP, and then S_FMT, and even 
> > with this your patch you'd fail S_CROP if S_FMT hadn't been called before 
> > (priv->fmt == NULL). Am I right? 
> 
> hmm.. I would like to ask you about S_CROP on soc_camera.
> There are a lot of problem for me.
> 
> at first, sh_mobile_ceu (and pxa_camera too) :: set_fmt is this
> -----------------------------------------------
> 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> 	if (!xlate) {
> 		dev_warn(&ici->dev, "Format %x not found\n", pixfmt);
> 		return -EINVAL;
> 	}
> -----------------------------------------------
> 
> and soc_camera_xlate_by_fourcc is this
> -----------------------------------------------
> const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
> 	struct soc_camera_device *icd, unsigned int fourcc)
> {
> 	unsigned int i;
> 
> 	for (i = 0; i < icd->num_user_formats; i++)
> 		if (icd->user_formats[i].host_fmt->fourcc == fourcc)
> 			return icd->user_formats + i;
> 	return NULL;
> }
> -----------------------------------------------
> 
> If pixfmt is 0, it said "Format 0 not found" to me.

Yes, this will be fixed by this:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg00161.html

> even if I fixed this problem (and ov772x set_fmt),
> kernel will run BUG_ON.
> 
> call trace is this.
> -------------
> soc_camera_qbuf
>  -> videobuf_qbuf
>     -> videobuf_next_field
> -------------
> 
> kernel will run BUG_ON when I use capture_example.
> -------------------------------------------------
> /* Locking: Caller holds q->vb_lock */
> enum v4l2_field videobuf_next_field(struct videobuf_queue *q)
> {
> 	enum v4l2_field field = q->field;
> 
> =>	BUG_ON(V4L2_FIELD_ANY == field);
> -------------------------------------------------
> 
> If sh_mobile_ceu use V4L2_FIELD_NONE on sh_mobile_ceu_init_videobuf,
> kernel will not run this BUG_ON.
> But tw9910 and I want sh_mobile_ceu_init_videobuf to use V4L2_FIELD_ANY.
> Do you remember this problem ?

Well, I looked through the old emails, but chenged a few things since 
then, so I am not sure what the behaviour would be like now, if we do 
switch back to _NONE? It looks like you should be prepared to run without 
a call to S_FMT, which also means, your ->field should have a value other 
than _ANY. What would break if you use _ANY now?

> And capture_example doesn't works even If
> sh_mobile_ceu_init_videobuf use V4L2_FIELD_NONE.
> It said "select timeout" to me.
> I don't know why.

This is probably because you don't setup a default mode in 
sh_mobile_ceu_camera.c or ov772x.c if S_FMT is never called. This should 
be fixed. I'm not sure if other drivers would deliver anything meaningful 
without a call to S_FMT - has to be tested / fixed...

> what is the best way to us ???
> or do I miss understanding ???

Fix behaviour if no S_FMT is done.

> > it first calls S_CROP, and then S_FMT
> 
> In this case, shoud ov772x use defaul color format
> when S_CROP order ?

The thing is that older versions of capture.c always called S_FMT, newer 
ones don't unless forced per "-f" switch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

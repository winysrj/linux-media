Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34655 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728267AbeK0S4j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 13:56:39 -0500
Received: by mail-yb1-f194.google.com with SMTP id a67-v6so7145958ybg.1
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2018 23:59:37 -0800 (PST)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id k80sm781875ywe.61.2018.11.26.23.59.35
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Nov 2018 23:59:35 -0800 (PST)
Received: by mail-yb1-f170.google.com with SMTP id o204-v6so8671112yba.9
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2018 23:59:35 -0800 (PST)
MIME-Version: 1.0
References: <20181123171958.17614-1-ezequiel@collabora.com>
 <CAAFQd5Aub8AmM-U9FM-UhOYPtMP=MbGwuX0svkVP-4p0H8MejA@mail.gmail.com> <95c67b23fcba7157f25d387e4ba8eb27cc85d2b5.camel@collabora.com>
In-Reply-To: <95c67b23fcba7157f25d387e4ba8eb27cc85d2b5.camel@collabora.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 27 Nov 2018 16:59:22 +0900
Message-ID: <CAAFQd5DRz3-YwxjgpFNp9h9i1FZTkkiqOkeFGHgVS+jCpNAwmg@mail.gmail.com>
Subject: Re: [PATCH] v4l2-ioctl: Zero v4l2_pix_format_mplane reserved fields
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 27, 2018 at 8:29 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
>
> On Mon, 2018-11-26 at 13:14 +0900, Tomasz Figa wrote:
> > Hi Ezequiel,
> >
> > On Sat, Nov 24, 2018 at 2:20 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
> > > Make the core set the reserved fields to zero in
> > > v4l2_pix_format_mplane and v4l2_plane_pix_format structs,
> > > for _MPLANE queue types.
> > >
> > > Moving this to the core avoids having to do so in each
> > > and every driver.
> > >
> > > Suggested-by: Tomasz Figa <tfiga@chromium.org>
> > > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > > ---
> > >  drivers/media/v4l2-core/v4l2-ioctl.c | 51 ++++++++++++++++++++++++----
> > >  1 file changed, 45 insertions(+), 6 deletions(-)
> > >
> >
> > Thanks for the patch. Please see my comments inline.
> >
> > > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> > > index 10b862dcbd86..3858fffc3e68 100644
> > > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > > @@ -1420,6 +1420,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
> > >  {
> > >         struct v4l2_format *p = arg;
> > >         int ret = check_fmt(file, p->type);
> > > +       int i;
> > >
> > >         if (ret)
> > >                 return ret;
> > > @@ -1458,7 +1459,13 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
> > >                 p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> > >                 return ret;
> > >         case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > > -               return ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
> > > +               ret = ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
> > > +               memset(p->fmt.pix_mp.reserved, 0,
> > > +                      sizeof(p->fmt.pix_mp.reserved));
> > > +               for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> > > +                       memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
> > > +                              sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
> > > +               return ret;
> > >         case V4L2_BUF_TYPE_VIDEO_OVERLAY:
> > >                 return ops->vidioc_g_fmt_vid_overlay(file, fh, arg);
> > >         case V4L2_BUF_TYPE_VBI_CAPTURE:
> > > @@ -1474,7 +1481,13 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
> > >                 p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> > >                 return ret;
> > >         case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > > -               return ops->vidioc_g_fmt_vid_out_mplane(file, fh, arg);
> > > +               ret = ops->vidioc_g_fmt_vid_out_mplane(file, fh, arg);
> > > +               memset(p->fmt.pix_mp.reserved, 0,
> > > +                      sizeof(p->fmt.pix_mp.reserved));
> > > +               for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> > > +                       memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
> > > +                              sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
> > > +               return ret;
> >
> > I wonder if we need this for G_FMT. The driver can just memset() the
> > whole struct itself and then just initialize the fields it cares
> > about, but actually in many cases the driver will just include an
> > instance of the pix_fmt(_mp) struct in its internal state (which has
> > the reserved fields already zeroed) and just copy it to the target
> > struct in the callback.
> >
>
> Perhaps in many cases, but from code inspection it seems not
> all of them (randomly opened vicodec & mtk-jpeg and both need
> a memset!).
>
> I'm thinkig it'd best to keep it this way for consistency
> and to avoid having the worry at all about this in the drivers.

I guess it makes sense indeed. The structure isn't terribly big, so
there shouldn't be any significant performance penalty I suppose.

Perhaps the next step would be to have someone clean up the existing drivers.

>
> Should we use CLEAR_AFTER_FIELD here as well?
>

I think so.

Best regards,
Tomasz

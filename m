Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34348 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbeJDO2d (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 10:28:33 -0400
Received: by mail-yb1-f194.google.com with SMTP id 184-v6so3533167ybg.1
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2018 00:36:39 -0700 (PDT)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id l69-v6sm1623328ywl.51.2018.10.04.00.36.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Oct 2018 00:36:37 -0700 (PDT)
Received: by mail-yw1-f53.google.com with SMTP id e201-v6so3401255ywa.3
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2018 00:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20181002113148.14897-1-mjourdan@baylibre.com> <f681dac8-0698-e0b3-eb15-94a46797a0ea@xs4all.nl>
 <CAMO6nazEn__GJPPRzwhT6BFhOu8EPPXkK_zsrrkzfu_VJUCvhg@mail.gmail.com>
In-Reply-To: <CAMO6nazEn__GJPPRzwhT6BFhOu8EPPXkK_zsrrkzfu_VJUCvhg@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 4 Oct 2018 16:36:26 +0900
Message-ID: <CAAFQd5BTBVEGrVcY+tNYSFrZQ7m2PngiYGnpYO8hQEA=JDxTYA@mail.gmail.com>
Subject: Re: [RFC PATCH] media: v4l2-ctrl: Add control for specific
 V4L2_EVENT_SRC_CH_RESOLUTION support
To: mjourdan@baylibre.com
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 3, 2018 at 7:02 PM Maxime Jourdan <mjourdan@baylibre.com> wrote:
>
> On Tue, Oct 2, 2018 at 1:43 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > On 10/02/18 13:31, Maxime Jourdan wrote:
> > > For drivers that expose both an OUTPUT queue and
> > > V4L2_EVENT_SRC_CH_RESOLUTION such as video decoders, it is
> > > possible that support for this event is limited to a subset
> > > of the enumerated OUTPUT formats.
> > >
> > > This adds V4L2_CID_SUPPORTS_CH_RESOLUTION that allows such a driver to
> > > notify userspace of per-format support for this event.
> >
> > An alternative is a flag returned by ENUMFMT.
> >
> > I would definitely invert the flag/control since the default should be
> > that this event is supported for these types of devices. Instead you
> > want to signal the exception (not supported).
> >
> > I think a format flag is better since this is really tied to the format
> > for this particular driver.
> >
> > This is a limitation of this hardware/firmware, right? It is not a
> > limitation of the format itself?
> >
> > And basically the decoder hardware cannot report when the resolution
> > changes midstream? What happens if userspace does not take this into
> > account and just continue? DMA overflow? Hope not.
> >
>
> I tested it: yep, DMA overflow if you're not careful. A solution is to
> always allocate buffers that can hold the maximum decodable picture
> size.
>
> Upon further investigation, the firmwares for older codecs (MPEG2 &
> MPEG4) expose registers to fetch the parsed width/height.
> There is one issue however: the decoder starts decoding right away,
> and we can gather the width/height only on the first frame decoded,
> which is the first interrupt we get.
>
> So I can send out a V4L2_EVENT_SRC_CH_RESOLUTION, the last remaining
> problem is that these codecs don't support dynamically changing the
> capture buffers, so you can't do a streamoff/reqbufs/streamon on the
> capture queue without doing a full reset and losing the pending
> capture/output frames.

I believe that, if there was a resolution change, you need to do a
full reset anyway, before you can continue decoding. So it doesn't
sound like a problem. Or am I missing something?

>
> And then there's MJPEG where you just can't gather the width/height
> and must rely on userspace setting it. Also need to allocate max size
> capture buffers for that one.

I guess that could be a case for the JPEG_RAW format, which moves the
responsibility for parsing the headers and setting relevant parameters
(format, controls) to userspace.

>
> I end up needing two ENUMFMT flags:
>  - the format doesn't support V4L2_EVENT_SRC_CH_RESOLUTION
>  - the format doesn't support dynamically changing the capture buffers
> (but you can keep going with the original buffer set)
>
> Would this be okay ?

With my replies above, would you still need any of those?

Best regards,
Tomasz

>
> Regards,
> Maxime
>
> > Regards,
> >
> >         Hans
> >
> > >
> > > RFC notes: This patch is motivated by the work I'm doing on the Amlogic
> > > video decoder where the firmwares allow me to support
> > > V4L2_EVENT_SRC_CH_RESOLUTION for newer formats (H.264, HEVC..) but
> > > can't support it for older ones (MPEG2, MPEG4, MJPEG..).
> > > For the latter formats, userspace is expected to set the resolution via
> > > S_FMT prior to decoding.
> > >
> > > Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
> > > ---
> > >  Documentation/media/uapi/v4l/control.rst | 7 +++++++
> > >  drivers/media/v4l2-core/v4l2-ctrls.c     | 3 +++
> > >  include/uapi/linux/v4l2-controls.h       | 4 +++-
> > >  3 files changed, 13 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/media/uapi/v4l/control.rst b/Documentation/media/uapi/v4l/control.rst
> > > index c1e6adbe83d7..029a4e88bfd5 100644
> > > --- a/Documentation/media/uapi/v4l/control.rst
> > > +++ b/Documentation/media/uapi/v4l/control.rst
> > > @@ -297,6 +297,13 @@ Control IDs
> > >      set the alpha component value of all pixels for further processing
> > >      in the device.
> > >
> > > +``V4L2_CID_SUPPORTS_CH_RESOLUTION`` ``(boolean)``
> > > +    This is a read-only control that can be read by the application when
> > > +    the driver exposes an OUTPUT queue and event
> > > +    ``V4L2_EVENT_SRC_CH_RESOLUTION`` but doesn't support it for every
> > > +    OUTPUT format. It returns true if the currently selected OUTPUT format
> > > +    supports this event.
> > > +
> > >  ``V4L2_CID_LASTP1``
> > >      End of the predefined control IDs (currently
> > >      ``V4L2_CID_ALPHA_COMPONENT`` + 1).
> > > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> > > index 599c1cbff3b9..a8037ff3935a 100644
> > > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > > @@ -739,6 +739,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> > >       case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:   return "Min Number of Output Buffers";
> > >       case V4L2_CID_ALPHA_COMPONENT:          return "Alpha Component";
> > >       case V4L2_CID_COLORFX_CBCR:             return "Color Effects, CbCr";
> > > +     case V4L2_CID_SUPPORTS_CH_RESOLUTION:   return "Supports Change Resolution";
> > >
> > >       /* Codec controls */
> > >       /* The MPEG controls are applicable to all codec controls
> > > @@ -1074,6 +1075,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
> > >       *flags = 0;
> > >
> > >       switch (id) {
> > > +     case V4L2_CID_SUPPORTS_CH_RESOLUTION:
> > > +             *flags |= V4L2_CTRL_FLAG_READ_ONLY;
> > >       case V4L2_CID_AUDIO_MUTE:
> > >       case V4L2_CID_AUDIO_LOUDNESS:
> > >       case V4L2_CID_AUTO_WHITE_BALANCE:
> > > diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> > > index e4ee10ee917d..c874fdd28f40 100644
> > > --- a/include/uapi/linux/v4l2-controls.h
> > > +++ b/include/uapi/linux/v4l2-controls.h
> > > @@ -141,8 +141,10 @@ enum v4l2_colorfx {
> > >  #define V4L2_CID_ALPHA_COMPONENT             (V4L2_CID_BASE+41)
> > >  #define V4L2_CID_COLORFX_CBCR                        (V4L2_CID_BASE+42)
> > >
> > > +#define V4L2_CID_SUPPORTS_CH_RESOLUTION              (V4L2_CID_BASE+43)
> > > +
> > >  /* last CID + 1 */
> > > -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+43)
> > > +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+44)
> > >
> > >  /* USER-class private control IDs */
> > >
> > >
> >

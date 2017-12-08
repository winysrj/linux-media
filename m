Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58766 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753656AbdLHQHd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 11:07:33 -0500
Date: Fri, 8 Dec 2017 14:07:25 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
Subject: Re: [Patch v6 05/12] [media] videodev2.h: Add v4l2 definition for
 HEVC
Message-ID: <20171208140717.68dd1549@vento.lan>
In-Reply-To: <1512748044.24635.1.camel@ndufresne.ca>
References: <1512724105-1778-1-git-send-email-smitha.t@samsung.com>
        <CGME20171208093649epcas1p1a4079fba04eb53bc9249a35361746ea9@epcas1p1.samsung.com>
        <1512724105-1778-6-git-send-email-smitha.t@samsung.com>
        <1512748044.24635.1.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 08 Dec 2017 10:47:24 -0500
Nicolas Dufresne <nicolas@ndufresne.ca> escreveu:

> Le vendredi 08 d=C3=A9cembre 2017 =C3=A0 14:38 +0530, Smitha T Murthy a =
=C3=A9crit :
> > Add V4L2 definition for HEVC compressed format
> >=20
> > Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> > Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> > Reviewed-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  include/uapi/linux/videodev2.h | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videod=
ev2.h
> > index 185d6a0..bd9b5d5 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -634,6 +634,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SM=
PTE 421M Annex L compliant stream */
> >  #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
> >  #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
> > +#define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC =
aka H.265 */ =20
>=20
> Wouldn't it be more consistent to call it V4L2_PIX_FMT_H265 as we have
> used H264 for the previous generation, or is there a formal rationale ?

It would, but what I'm afraid on using specs name here, due to what
happened with MPEG-4 specs. Originally, it was referred to one codec
(ASP). Then, part 10 came with a different compression codec (AVC). So,
now, when referring to MPEG-4, one need to explicitly mention if the code
is AVC or not. The ITU-T didn't make the same mistake (yet?), but nobody
can predict what will happen in the future.

So, now that an spec can be modified to include additional parts with
different codecs, it sounds less risky to use the codec name instead
of the spec number, as this shouldn't change :-)

> Also, this is byte-stream right ? With start codes ?

>=20
> > =20
> >  /*  Vendor-specific formats   */
> >  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1=
 YUV */ =20



Thanks,
Mauro

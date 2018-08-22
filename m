Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34584 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbeHVMkB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 08:40:01 -0400
Date: Wed, 22 Aug 2018 11:15:57 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Subject: Re: [PATCH 1/9] CHROMIUM: v4l: Add H264 low-level decoder API
 compound controls.
Message-ID: <20180822091557.gtnlgoebyv6yttzf@flea>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
 <20180613140714.1686-2-maxime.ripard@bootlin.com>
 <80e1d9cb49c6df06843e49332685f2b401023292.camel@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="noua72ythpkh5fic"
Content-Disposition: inline
In-Reply-To: <80e1d9cb49c6df06843e49332685f2b401023292.camel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--noua72ythpkh5fic
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 21, 2018 at 01:58:38PM -0300, Ezequiel Garcia wrote:
> On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > From: Pawel Osciak <posciak@chromium.org>
> >=20
> > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > Reviewed-by: Wu-cheng Li <wuchengli@chromium.org>
> > Tested-by: Tomasz Figa <tfiga@chromium.org>
> > [rebase44(groeck): include linux/types.h in v4l2-controls.h]
> > Signed-off-by: Guenter Roeck <groeck@chromium.org>
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >=20
> [..]
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videod=
ev2.h
> > index 242a6bfa1440..4b4a1b25a0db 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -626,6 +626,7 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 =
with start codes */
> >  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H26=
4 without start codes */
> >  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 =
MVC */
> > +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H26=
4 parsed slices */
>=20
> As pointed out by Tomasz, the Rockchip VPU driver expects start codes [1]=
, so the userspace
> should be aware of it. Perhaps we could document this pixel format better=
 as:
>=20
> #define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H264 p=
arsed slices with start codes */

I'm not sure this is something we want to do at that point. libva
doesn't give the start code, so this is only going to make the life of
the sane controllers more difficult. And if you need to have the start
code and parse it, then you're not so stateless anymore.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--noua72ythpkh5fic
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlt9KcwACgkQ0rTAlCFN
r3RpKQ//aADj5oLUZV78d16Y1whgjwjeyfX6eBcc6VmFhBvEbu68xB2blBtc0Z+J
6lo4AisRAK9YAO6WBtfNCL+ZIgWs2RD7PF+HiXah789Ksfdk2bzESGFou7EfS37o
67v9cxz1tnts7TQbPx5RQlpfb56uuvGZo6fRV+KXYq71hwCgx0IjeGhZc1QsBCdE
O3b4YiINvlTNQZQZfGUszA4wQ/+gT4OZXmtQu5SpLT2pdre57SmQ8EN9+Z5GthBQ
vhdhSlLP9L6TmZonQfA0HIPYtLsfPCPtOMbznS9KEqsLuGDJ20dUTLagXTJRVcEJ
WwgrdiX7OXoUsB6PmfNMr0I7cxWATh3k54OIl2+dSPJANdjIUwWb1s7yBAlYBwWu
5vg22giYTU7bj4oc5Vfe1MSm6huM7We0ED93Y/L7PWfq9WbDMeeKZMMh7viTg3Tq
H+L77lsxDwusG+NsWoKpFhq08UOcaOUue+dBPadRILfYEbizccrob+0x82APctWA
KBDAukqZp6sRRV8Yl0op2trS7W332pnTDv/09zXNEIrUK+yXetrxEIX74aJY4qRF
M34vgMQdok1/RJRZLo18p39kLyKQB+CZbNtFWC6VK0Ziu+vnEluXXq3wU7c2qIcb
rwMeeWQP9kNcO04AcJ7E+pAYYMme159CkaktdL4a7hL5eaiORao=
=tUm/
-----END PGP SIGNATURE-----

--noua72ythpkh5fic--

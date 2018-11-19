Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:47724 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbeKTAgY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 19:36:24 -0500
Date: Mon, 19 Nov 2018 15:12:37 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Pawel Osciak <posciak@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH v2 0/2] media: cedrus: Add H264 decoding support
Message-ID: <20181119141237.qwwdn27e6jwjvhmz@flea>
References: <20181115145650.9827-1-maxime.ripard@bootlin.com>
 <CAAFQd5DmcC23ZSktBXo=Sz-6G76oaJywha9mXtaPFSx08eV_nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zmi43yrjnqz7zkau"
Content-Disposition: inline
In-Reply-To: <CAAFQd5DmcC23ZSktBXo=Sz-6G76oaJywha9mXtaPFSx08eV_nA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zmi43yrjnqz7zkau
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomasz,

On Fri, Nov 16, 2018 at 04:04:40PM +0900, Tomasz Figa wrote:
> > I've been using the controls currently integrated into ChromeOS that
> > have a working version of this particular setup. However, these
> > controls have a number of shortcomings and inconsistencies with other
> > decoding API. I've worked with libva so far, but I've noticed already
> > that:
> >   - The kernel UAPI expects to have the nal_ref_idc variable, while
> >     libva only exposes whether that frame is a reference frame or
> >     not. I've looked at the rockchip driver in the ChromeOS tree, and
> >     our own driver, and they both need only the information about
> >     whether the frame is a reference one or not, so maybe we should
> >     change this?
>=20
> Since this is something that is actually present in the stream and the
> problem is that libva doesn't convey the information properly, I
> believe you can workaround it in the libva backend using this API by
> just setting it to 0 and some arbitrary non-zero value in a binary
> fashion.

That could work yes, thanks for the suggestion!

> >   - The H264 bitstream exposes the picture default reference list (for
> >     both list 0 and list 1), the slice reference list and an override
> >     flag. The libva will only pass the reference list to be used (so
> >     either the picture default's or the slice's) depending on the
> >     override flag. The kernel UAPI wants the picture default reference
> >     list and the slice reference list, but doesn't expose the override
> >     flag, which prevents us from configuring properly the
> >     hardware. Our video decoding engine needs the three information,
> >     but we can easily adapt to having only one. However, having two
> >     doesn't really work for us.
> >
>=20
> From what I can see in the H.264 Slice header, there are 3 related data:
>  - num_ref_idx_active_override_flag - affects the number of reference
> indices for the slice,
>  - ref_list_l{0,1}_modifications - modifications for the reference lists,
>  - ref_pic_list_modification_flag_l{0,1} - selects whether the
> modifications are applied.
>=20
> The reference lists inside the v4l2_ctrl_h264_slice_param are expected
> to already take all the above into account and be the final reference
> lists to be used for the slice. For reference, the H.264 specification
> refers to those final reference lists as RefPicList0 and RefPicList1
> and so the names of the fields in the struct.
>=20
> There is some interesting background here, though. The Rockchip VPU
> parses the slice headers itself and handles the above data on its own.
> This means that it needs to be programmed with the unmodified
> reference lists, as in v4l2_ctrl_h264_decode_param.
>=20
> Given that, it sounds like we need to have both. Your driver would
> always use the lists in v4l2_ctrl_h264_slice_param, while the Rockchip
> VPU would ignore them, use the ones in v4l2_ctrl_h264_decode_param and
> perform the per-slice modifications on its own.

I guess that would work, yep

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--zmi43yrjnqz7zkau
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW/LE1QAKCRDj7w1vZxhR
xU6lAQCzHT+UfaY4dv6lCYEoscex90eOwXS0/ocDdzhogtlupQEAmk5Cm8O2uK2v
n7r5Zwk9nm0dlXFOvMi9Auac66YJzw0=
=6I8o
-----END PGP SIGNATURE-----

--zmi43yrjnqz7zkau--

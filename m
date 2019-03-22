Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2043C4360F
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 18:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB0A721917
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 18:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="kIdUtgqb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfCVSYd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 14:24:33 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36463 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfCVSYd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 14:24:33 -0400
Received: by mail-qt1-f195.google.com with SMTP id y36so3619741qtb.3
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 11:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=OYK1Intb5otZe27B8iMGxGpx1ruYX7qXFBf7IvaCPR0=;
        b=kIdUtgqbc90Z1Y5+v4eKhbF4xyK2qaEpSB7FuoLAHxRtM/BrXS/QnpX1KaE4dFWtai
         8u+5iLnba32Zk+31h+/iiQQ2KBpr/Xyt8qSE1kgxet73syFfq4c1Zof8Ero135rQwe7O
         yAVzfhVWkA+/9TIBQ/Mym2IVANvPBNEzIJvrRGHUuhxOm/AV6+kOiM0o1B3kEL4rscGQ
         P1gSYYjg/ssY6p+Xdr3ZP082pWcgH7YmnESdgnTA5HnZAoWj0NFy7510GJBYHscI0D0y
         QJ/OlzidNV7Hzr6mfaffxLVyg2bDk2jIFGji5TjXMA7pG+zHA5SeZ7ZsAyP2ZFqL7Rgn
         w9qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=OYK1Intb5otZe27B8iMGxGpx1ruYX7qXFBf7IvaCPR0=;
        b=PCFbVjcjH7phTmGWK4fCMP1pJrDJqfKagdegAc2c7vFBuuL7VT8f0+oaPfIOYe97C7
         FfkjNZl0zASBKo+aWTekSUrFLdNQ+3XhBFVODwALrGSAjiKBnbORQx6BsDE2c0D4hJgG
         V07tYub/VIpDWNrrbGPpqDcSFoyLX7QUoxMW1TEbVG4uPlDmSMWrfWi/jAcpcl30Lke2
         S9KhsjURS6olp/tF+3BPzcJ4SOj/4VDpQcSDMZyKV1mYFw61YGGJWJZpDHjql9jgEjnG
         elPoAIZGdyzjEFRaZeBsAYpWVjjBOpvWMDMyi4b2OLf6xUGA4629BIKS2eDGaAkArtsO
         mLtw==
X-Gm-Message-State: APjAAAUybp0gzjxuY83e2UKYI4omPcBKhvvHjiTEl/JAIAckxdVYnOqq
        Dy6obAkFQ5BFEupFMFVyTFWMdg==
X-Google-Smtp-Source: APXvYqwnCJSY4qtZ7kymnYu1kgm3Uhuar+q6RGBXskfZIuUzafYfZ2/iUKFWx9ZMKj9AsQkvvGYPBA==
X-Received: by 2002:a0c:d1a7:: with SMTP id e36mr9417888qvh.127.1553279072035;
        Fri, 22 Mar 2019 11:24:32 -0700 (PDT)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id a47sm6669995qtb.79.2019.03.22.11.24.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 11:24:31 -0700 (PDT)
Message-ID: <3e804c622fdc0ce43581982d81d2db67597508ec.camel@ndufresne.ca>
Subject: Re: [RFC PATCH 18/20] lib: image-formats: Add v4l2 formats support
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-media@vger.kernel.org, Daniel Stone <daniels@collabora.com>
Date:   Fri, 22 Mar 2019 14:24:29 -0400
In-Reply-To: <20190321214455.GL3888@intel.com>
References: <20190320142739.GK3888@intel.com>
         <a13f7fdeaf1a5e97f21a6048da765705b59d64c2.camel@ndufresne.ca>
         <20190320160939.GR3888@intel.com>
         <f3f8749e30aad81bc39ed9b60cd308ac5f3c6707.camel@ndufresne.ca>
         <20190320164133.GT3888@intel.com>
         <d46b30ca8962d3c31b1273cf010ca9fb7b145fe8.camel@ndufresne.ca>
         <20190320183914.GV3888@intel.com>
         <46df4fb13636b90c147839b0aa5ad1ac33030461.camel@bootlin.com>
         <20190321163532.GG3888@intel.com>
         <ac5329d77f83af2804c240ebe479ec323b60aec3.camel@ndufresne.ca>
         <20190321214455.GL3888@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-DLJTG7WJUtgUvCkmt9/r"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-DLJTG7WJUtgUvCkmt9/r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 21 mars 2019 =C3=A0 23:44 +0200, Ville Syrj=C3=A4l=C3=A4 a =C3=A9c=
rit :
> On Thu, Mar 21, 2019 at 03:14:06PM -0400, Nicolas Dufresne wrote:
> > Le jeudi 21 mars 2019 =C3=A0 18:35 +0200, Ville Syrj=C3=A4l=C3=A4 a =C3=
=A9crit :
> > > > I'm not sure what it's worth, but there is a "pixel format guide"
> > > > project that is all about matching formats from one API to another:=
=20
> > > > https://afrantzis.com/pixel-format-guide/ (and it has an associated
> > > > tool too).
> > > >=20
> > > > On the page about DRM, it seems that they got the word that DRM for=
mats
> > > > are the native pixel order in little-endian systems:
> > > > https://afrantzis.com/pixel-format-guide/drm.html
> > >=20
> > > Looks consistent with the official word in drm_fourcc.h.
> > >=20
> > > $ python3 -m pfg find-compatible V4L2_PIX_FMT_XBGR32 drm
> > > Format: V4L2_PIX_FMT_XBGR32
> > > Is compatible on all systems with:
> > >         DRM_FORMAT_XRGB8888
> > > Is compatible on little-endian systems with:
> > > Is compatible on big-endian systems with:
> > >=20
> > > $ python3 -m pfg find-compatible DRM_FORMAT_XRGB8888 v4l2
> > > Format: DRM_FORMAT_XRGB8888
> > > Is compatible on all systems with:
> > >         V4L2_PIX_FMT_XBGR32
> > > Is compatible on little-endian systems with:
> > > Is compatible on big-endian systems with:
> > >=20
> > > Even works both ways :)
> > >=20
> > > > Perhaps some drivers have been abusing the format definitions, lead=
ing
> > > > to the inconsistencies that Nicolas could witness?
> > >=20
> > > That is quite possible, perhaps even likely. No one really
> > > seems interested in making sure big endian systems actually
> > > work properly. I believe the usual approach is to hack
> > > around semi-rnadomly until the correct colors accidentally
> > > appear on the screen.
> >=20
> > We did not hack around randomly. The code in GStreamer is exactly what
> > the DRM and Wayland dev told us to do (they provided the initial
> > patches to make it work). These are initially patches from Intel for
> > what it's worth (see the wlvideoformat.c header [0]). Even though I
> > just notice that in this file, it seems that we ended up with a
> > different mapping order for WL and DRM format in 24bit RGB (no
> > padding), clearly is a bug. That being said, there is no logical
> > meaning for little endian 24bit RGB, you can't load a pixel on CPU in a
> > single op.
>=20
> To me little endian just means "little end comes first". So if
> you think of things as just a stream of bytes CPU word size
> etc. doesn't matter. And I guess if you really wanted to you
> could even make a CPU with 24bit word size.=20
>=20
> Anyways, to make things more clear drm_fourcc.h could probably
> document things better by showing explicitly which bits go into
> which byte.
>=20
> I don't know who did what patches for whatever project, but
> clearly something has been lost in translation at some point.
>=20
> > Just saying since I would not know which one of the two
> > mapping here is right. I would probably have to go testing what DRM
> > drivers do, which may not mean anything. I would also ask and get
> > contradictory answers.
> >=20
> > I have never myself tested these on big endian drivers though, as you
> > say, nobody seems to care about graphics on those anymore. So the easy
> > statement is to say they are little endian, like you just did, and
> > ignore the legacy, but there is some catch. YUV formats has been added
> > without applying this rules.
>=20
> All drm formats follow the same rule (ignoring the recently added
> non-byte aligned stuff which I guess don't really follow any rules).
>=20
> > So V4L2 YUYV match YUYV in DRM format name
> > instead of little endian UYVY. (at least 4 tested drivers implements it
> > this way). Same for NV12, for which little endian CPU representation
> > would swap the UV paid on a 16bit word.
>=20
> DRM NV12 and YUYV (YUY2) match the NV12 and YUY2 defined here
> https://docs.microsoft.com/en-us/windows/desktop/medfound/recommended-8-b=
it-yuv-formats-for-video-rendering

Problem is that these are all expressed MSB first like (the way V4L2
and GStreamer do appart for the padding X, which is usually first in
V4L2). Let's say you have 2 pixels of YUYV in a 32bit buffer.

   buf[0] =3D Y
   buf[1] =3D U
   buf[2] =3D Y
   buf[3] =3D V

While with LSB first (was this what you wanted to say ?), this format
would be VYUY as:

  buf[0] =3D V
  buf[1] =3D Y
  buf[2] =3D U
  buf[3] =3D Y

But I tested this format on i915, xlnx, msm and imx drm drivers, and
they are all mapped as MSB. The LSB version of NV12 is called NV21 in
MS pixel formats. It would be really confusing if the LSB rule was to
be applied to these format in my opinion, because the names don't
explicitly express the placement for the components.

Anyway, to cut short, as per currently tested implementation of DRM
driver, we can keep the RGB mapping static (reversed) for now, but for
Maxime, who probably have no clue about all this, the YUYV mapping is
correct in this patch (in as of currently tested drivers).

>=20
> > To me, all the YUV stuff is the right way, because this is what the
> > rest of the world is doing, it's not ambiguous.
> >=20
> > [0] https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/maste=
r/ext/wayland/wlvideoformat.c#L86
> >=20
> >=20
> >=20
> > Nicolas

--=-DLJTG7WJUtgUvCkmt9/r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXJUoXQAKCRBxUwItrAao
HNfwAJ0Q6/LrSfs51oL6YyfmAEMMAdtmdACgppnNFsYdP0FjeGR/AoJxNxPbmOE=
=sAhk
-----END PGP SIGNATURE-----

--=-DLJTG7WJUtgUvCkmt9/r--


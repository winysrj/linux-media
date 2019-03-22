Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20CBC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 19:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67095218FE
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 19:25:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="KzPjDGdz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfCVTZq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 15:25:46 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42188 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbfCVTZq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 15:25:46 -0400
Received: by mail-qt1-f195.google.com with SMTP id p20so3802829qtc.9
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 12:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=+Leg0fPwQhiPcef+vSiWxkfMAa0gG8+929/qEKKbAuY=;
        b=KzPjDGdzIl1h21t4VMOImKTaB39dnyvO6Qa41wPU6/+fNw9Wbbqg2nPiagJF+m/Zpj
         WDUqe8iL8UBcBCrKaYDC82mx/JXkxUhCWy5eQLUTOYDA7NBxWna1I/kK1jYRY5UwVS2S
         Cq0LWODkNseJlAYdL22BkxWOZdI0JSoVAlt+ywH+55KmYoSVMTadti3VKSXQg3AyWzfj
         Jg2uLzMK32nxi1Ouon/T5memWODJxWFmNDjRhhgV0aG3aLFiwh2bP2vsJvOPl740lcdT
         0iA43HkH4bt8MeJicsSsP67+rxDqc8HxtRscSy/8fsz/zpgh8OLoQx5FWvPPJ8dwjKjW
         pN8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=+Leg0fPwQhiPcef+vSiWxkfMAa0gG8+929/qEKKbAuY=;
        b=VT2p548odX2TXZYS1rMyp7TG0TiAJvvPSwxZ42k7JCJAataydLCpyO+f4WRjRTq6cN
         2emt3i7d3wZNREyruW6ehs2Ddg7aS34P9pye9LsLUkoFjlLYlg33w9Rt9K4GvKyiUcp3
         9dWSMKT0rAzIPbqlKikStGDfB9p7Fz8+QKuJFe4q3twzAvs13Nnqwf63XdsvdbtVrJVP
         SHKjgEshmKuPUym0tilPeATX1LJUtxwBaq9HNGnO1ulYCppbkGZzrNVPdlSVoanWt79e
         TGK2BbyhzmhKRKhwcvluZYU/GFhPoGCrcWi8jBT5PUkDpecgJMlLK2ZXYGZxn2VB1dbz
         AqjQ==
X-Gm-Message-State: APjAAAWWTTP0HnuKg9/VSx4Re5JElzDiOtVnJr9c4aAwiDcYW5WX1lmm
        XqP7qcEpskVf4R62KyFqY14edQ==
X-Google-Smtp-Source: APXvYqysuvFoIhWDDDQfNUhgEwcU/01os7gWeKG7zf0xMPU2kOT5WHTk6FqDKG5u37sLOE7YpkPhjA==
X-Received: by 2002:aed:2232:: with SMTP id n47mr9978483qtc.63.1553282745117;
        Fri, 22 Mar 2019 12:25:45 -0700 (PDT)
Received: from tpx230-nicolas.collaboramtl (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id i68sm4432773qkc.63.2019.03.22.12.25.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 12:25:44 -0700 (PDT)
Message-ID: <f268aa5b83fe6527303005ab5c820e5d78e299f9.camel@ndufresne.ca>
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
Date:   Fri, 22 Mar 2019 15:25:42 -0400
In-Reply-To: <20190322184435.GJ3888@intel.com>
References: <20190320160939.GR3888@intel.com>
         <f3f8749e30aad81bc39ed9b60cd308ac5f3c6707.camel@ndufresne.ca>
         <20190320164133.GT3888@intel.com>
         <d46b30ca8962d3c31b1273cf010ca9fb7b145fe8.camel@ndufresne.ca>
         <20190320183914.GV3888@intel.com>
         <46df4fb13636b90c147839b0aa5ad1ac33030461.camel@bootlin.com>
         <20190321163532.GG3888@intel.com>
         <ac5329d77f83af2804c240ebe479ec323b60aec3.camel@ndufresne.ca>
         <20190321214455.GL3888@intel.com>
         <3e804c622fdc0ce43581982d81d2db67597508ec.camel@ndufresne.ca>
         <20190322184435.GJ3888@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-sqaul58o/kExff4ut0zE"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-sqaul58o/kExff4ut0zE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 22 mars 2019 =C3=A0 20:44 +0200, Ville Syrj=C3=A4l=C3=A4 a =C3=
=A9crit :
> On Fri, Mar 22, 2019 at 02:24:29PM -0400, Nicolas Dufresne wrote:
> > Le jeudi 21 mars 2019 =C3=A0 23:44 +0200, Ville Syrj=C3=A4l=C3=A4 a =C3=
=A9crit :
> > > On Thu, Mar 21, 2019 at 03:14:06PM -0400, Nicolas Dufresne wrote:
> > > > Le jeudi 21 mars 2019 =C3=A0 18:35 +0200, Ville Syrj=C3=A4l=C3=A4 a=
 =C3=A9crit :
> > > > > > I'm not sure what it's worth, but there is a "pixel format guid=
e"
> > > > > > project that is all about matching formats from one API to anot=
her:=20
> > > > > > https://afrantzis.com/pixel-format-guide/ (and it has an associ=
ated
> > > > > > tool too).
> > > > > >=20
> > > > > > On the page about DRM, it seems that they got the word that DRM=
 formats
> > > > > > are the native pixel order in little-endian systems:
> > > > > > https://afrantzis.com/pixel-format-guide/drm.html
> > > > >=20
> > > > > Looks consistent with the official word in drm_fourcc.h.
> > > > >=20
> > > > > $ python3 -m pfg find-compatible V4L2_PIX_FMT_XBGR32 drm
> > > > > Format: V4L2_PIX_FMT_XBGR32
> > > > > Is compatible on all systems with:
> > > > >         DRM_FORMAT_XRGB8888
> > > > > Is compatible on little-endian systems with:
> > > > > Is compatible on big-endian systems with:
> > > > >=20
> > > > > $ python3 -m pfg find-compatible DRM_FORMAT_XRGB8888 v4l2
> > > > > Format: DRM_FORMAT_XRGB8888
> > > > > Is compatible on all systems with:
> > > > >         V4L2_PIX_FMT_XBGR32
> > > > > Is compatible on little-endian systems with:
> > > > > Is compatible on big-endian systems with:
> > > > >=20
> > > > > Even works both ways :)
> > > > >=20
> > > > > > Perhaps some drivers have been abusing the format definitions, =
leading
> > > > > > to the inconsistencies that Nicolas could witness?
> > > > >=20
> > > > > That is quite possible, perhaps even likely. No one really
> > > > > seems interested in making sure big endian systems actually
> > > > > work properly. I believe the usual approach is to hack
> > > > > around semi-rnadomly until the correct colors accidentally
> > > > > appear on the screen.
> > > >=20
> > > > We did not hack around randomly. The code in GStreamer is exactly w=
hat
> > > > the DRM and Wayland dev told us to do (they provided the initial
> > > > patches to make it work). These are initially patches from Intel fo=
r
> > > > what it's worth (see the wlvideoformat.c header [0]). Even though I
> > > > just notice that in this file, it seems that we ended up with a
> > > > different mapping order for WL and DRM format in 24bit RGB (no
> > > > padding), clearly is a bug. That being said, there is no logical
> > > > meaning for little endian 24bit RGB, you can't load a pixel on CPU =
in a
> > > > single op.
> > >=20
> > > To me little endian just means "little end comes first". So if
> > > you think of things as just a stream of bytes CPU word size
> > > etc. doesn't matter. And I guess if you really wanted to you
> > > could even make a CPU with 24bit word size.=20
> > >=20
> > > Anyways, to make things more clear drm_fourcc.h could probably
> > > document things better by showing explicitly which bits go into
> > > which byte.
> > >=20
> > > I don't know who did what patches for whatever project, but
> > > clearly something has been lost in translation at some point.
> > >=20
> > > > Just saying since I would not know which one of the two
> > > > mapping here is right. I would probably have to go testing what DRM
> > > > drivers do, which may not mean anything. I would also ask and get
> > > > contradictory answers.
> > > >=20
> > > > I have never myself tested these on big endian drivers though, as y=
ou
> > > > say, nobody seems to care about graphics on those anymore. So the e=
asy
> > > > statement is to say they are little endian, like you just did, and
> > > > ignore the legacy, but there is some catch. YUV formats has been ad=
ded
> > > > without applying this rules.
> > >=20
> > > All drm formats follow the same rule (ignoring the recently added
> > > non-byte aligned stuff which I guess don't really follow any rules).
> > >=20
> > > > So V4L2 YUYV match YUYV in DRM format name
> > > > instead of little endian UYVY. (at least 4 tested drivers implement=
s it
> > > > this way). Same for NV12, for which little endian CPU representatio=
n
> > > > would swap the UV paid on a 16bit word.
> > >=20
> > > DRM NV12 and YUYV (YUY2) match the NV12 and YUY2 defined here
> > > https://docs.microsoft.com/en-us/windows/desktop/medfound/recommended=
-8-bit-yuv-formats-for-video-rendering
> >=20
> > Problem is that these are all expressed MSB first like (the way V4L2
> > and GStreamer do appart for the padding X, which is usually first in
> > V4L2). Let's say you have 2 pixels of YUYV in a 32bit buffer.
> >=20
> >    buf[0] =3D Y
> >    buf[1] =3D U
> >    buf[2] =3D Y
> >    buf[3] =3D V
>=20
> This is drm YUYV (aka. YUY2). Well, assuming buf[] is made up of bytes.
>=20
> > While with LSB first (was this what you wanted to say ?), this format
> > would be VYUY as:
> >=20
> >   buf[0] =3D V
> >   buf[1] =3D Y
> >   buf[2] =3D U
> >   buf[3] =3D Y
>=20
> This is VYUY as far as drm is concerned.
>=20
> > But I tested this format on i915, xlnx, msm and imx drm drivers, and
> > they are all mapped as MSB. The LSB version of NV12 is called NV21 in
> > MS pixel formats. It would be really confusing if the LSB rule was to
> > be applied to these format in my opinion, because the names don't
> > explicitly express the placement for the components.
>=20
> The names don't really mean anything. Don't try to give any any special
> meaning. They're just that, names. The fact that we used fourccs for
> them was a mistake IMO. IIRC I objected but ended up going with them
> to get the bikeshed painted at all.

I can only agree with you. Note, it was not obvious to me that when you
said the format are little endian you refered to the description next
to the format name inside drm_fourcc.h.

>=20
> And yes, the fact that we used a different naming scheme for packed YUV
> vs. RGB was probably a mistake by me. But it was done long ago and we
> have to live with it. Fortunately the mess has gotten much worse since
> then and we are even more inconsistent now. We now YUV formats where
> the A vs. X variants use totally different naming schemes.

Ok, so now that we are set, I'll retake this patch and simply comment
next to each badly mapped format.

>=20
> > Anyway, to cut short, as per currently tested implementation of DRM
> > driver, we can keep the RGB mapping static (reversed) for now, but for
> > Maxime, who probably have no clue about all this, the YUYV mapping is
> > correct in this patch (in as of currently tested drivers).
> >=20
> > > > To me, all the YUV stuff is the right way, because this is what the
> > > > rest of the world is doing, it's not ambiguous.
> > > >=20
> > > > [0] https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/m=
aster/ext/wayland/wlvideoformat.c#L86
> > > >=20
> > > >=20
> > > >=20
> > > > Nicolas
>=20
>=20

--=-sqaul58o/kExff4ut0zE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXJU2tgAKCRBxUwItrAao
HJzYAJoDN5ZqBx+QSf8KSmSjMEZ6B1/fiwCdG7VDqbtB5sSQS6ZJv85i9ImGQ/g=
=FZyR
-----END PGP SIGNATURE-----

--=-sqaul58o/kExff4ut0zE--


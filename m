Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:38648 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdH1SHZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 14:07:25 -0400
Received: by mail-io0-f182.google.com with SMTP id 81so4877436ioj.5
        for <linux-media@vger.kernel.org>; Mon, 28 Aug 2017 11:07:25 -0700 (PDT)
Message-ID: <1503943642.3316.7.camel@ndufresne.ca>
Subject: Re: DRM Format Modifiers in v4l2
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Brian Starkey <brian.starkey@arm.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        jonathan.chai@arm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Date: Mon, 28 Aug 2017 14:07:22 -0400
In-Reply-To: <20170824122647.GA28829@e107564-lin.cambridge.arm.com>
References: <20170821155203.GB38943@e107564-lin.cambridge.arm.com>
         <CAKMK7uFdQPUomZDCp_ak6sTsUayZuut4us08defjKmiy=24QnA@mail.gmail.com>
         <47128f36-2990-bd45-ead9-06a31ed8cde0@xs4all.nl>
         <20170824111430.GB25711@e107564-lin.cambridge.arm.com>
         <ba202456-4bc6-733e-4950-88ce64ca990e@xs4all.nl>
         <20170824122647.GA28829@e107564-lin.cambridge.arm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-sAn3iQ3EgHCdjXFmQIyv"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-sAn3iQ3EgHCdjXFmQIyv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 24 ao=C3=BBt 2017 =C3=A0 13:26 +0100, Brian Starkey a =C3=A9crit :
> > What I mean was: an application can use the modifier to give buffers fr=
om
> > one device to another without needing to understand it.
> >=20
> > But a generic video capture application that processes the video itself
> > cannot be expected to know about the modifiers. It's a custom HW specif=
ic
> > format that you only use between two HW devices or with software writte=
n
> > for that hardware.
> >=20
>=20
> Yes, makes sense.
>=20
> > >=20
> > > However, in DRM the API lets you get the supported formats for each
> > > modifier as-well-as the modifier list itself. I'm not sure how exactl=
y
> > > to provide that in a control.
> >=20
> > We have support for a 'menu' of 64 bit integers: V4L2_CTRL_TYPE_INTEGER=
_MENU.
> > You use VIDIOC_QUERYMENU to enumerate the available modifiers.
> >=20
> > So enumerating these modifiers would work out-of-the-box.
>=20
> Right. So I guess the supported set of formats could be somehow
> enumerated in the menu item string. In DRM the pairs are (modifier +
> bitmask) where bits represent formats in the supported formats list
> (commit db1689aa61bd in drm-next). Printing a hex representation of
> the bitmask would be functional but I concede not very pretty.

The problem is that the list of modifiers depends on the format
selected. Having to call S_FMT to obtain this list is quite
inefficient.

Also, be aware that DRM_FORMAT_MOD_SAMSUNG_64_32_TILE modifier has been
implemented in V4L2 with a direct format (V4L2_PIX_FMT_NV12MT). I think
an other one made it the same way recently, something from Mediatek if
I remember. Though, unlike the Intel one, the same modifier does not
have various result depending on the hardware revision.

regards,
Nicolas


--=-sAn3iQ3EgHCdjXFmQIyv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWaRb2gAKCRBxUwItrAao
HOAJAJ9XSiK8gT82E2pe/YOM+8j5nA624gCdF9GSU/Q6jBIWn4rnE750R3s9rI0=
=+Is1
-----END PGP SIGNATURE-----

--=-sAn3iQ3EgHCdjXFmQIyv--

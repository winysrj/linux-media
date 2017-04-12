Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:25604 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753550AbdDLNWF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 09:22:05 -0400
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
 <5731C7D2.4090807@ti.com> <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
 <1d801302-388b-1d00-f0be-18aaef8cf80f@ti.com>
 <5d47b07d-1866-f832-0d06-e834e7e2aebb@xs4all.nl>
CC: <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <fc682c3d-3ab3-0d0f-3bb7-f6dc62f477f6@ti.com>
Date: Wed, 12 Apr 2017 16:21:20 +0300
MIME-Version: 1.0
In-Reply-To: <5d47b07d-1866-f832-0d06-e834e7e2aebb@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="caRGJ4fRxp7k3pVGJht1gmM0tuGP8OPf6"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--caRGJ4fRxp7k3pVGJht1gmM0tuGP8OPf6
Content-Type: multipart/mixed; boundary="hlAXGR7HUk7VeBHCHXMT6VopGsuf3vunT";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hans.verkuil@cisco.com>
Message-ID: <fc682c3d-3ab3-0d0f-3bb7-f6dc62f477f6@ti.com>
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
 <5731C7D2.4090807@ti.com> <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
 <1d801302-388b-1d00-f0be-18aaef8cf80f@ti.com>
 <5d47b07d-1866-f832-0d06-e834e7e2aebb@xs4all.nl>
In-Reply-To: <5d47b07d-1866-f832-0d06-e834e7e2aebb@xs4all.nl>

--hlAXGR7HUk7VeBHCHXMT6VopGsuf3vunT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/04/17 16:03, Hans Verkuil wrote:

> I noticed while experimenting with this that tpd_disconnect() in
> drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c isn't called when
> I disconnect the HDMI cable. Is that a bug somewhere?
>=20
> I would expect that tpd_connect and tpd_disconnect are balanced. The tp=
d_enable
> and tpd_disable calls are properly balanced and I see the tpd_disable w=
hen I
> disconnect the HDMI cable.

The connect/disconnect naming there is legacy... It's not about cable
connect, it's about the initial "connect" of the drivers in the video
pipeline. It's done just once when starting omapdrm.

> The key to keeping CEC up and running, even when there is no HPD is to =
keep
> the hdmi.vdda_reg regulator enabled. Also the HDMI_IRQ_CORE should alwa=
ys be
> on, otherwise I won't get any CEC interrupts.

At the moment there's no way to enable the pipeline without enabling the
video.

> So if the omap4 CEC support is enabled in the kernel config, then alway=
s enable
> this regulator and irq, and otherwise keep the current code.

Well, I have no clue about how CEC is used, but don't we have some
userspace components using it? I presume there's an open() or something
similar that signals that the userspace is interested in CEC. That
should be the trigger to enable the HW required for CEC.

So is some other driver supporting this already? Or is the omap4 the
first platform you're trying this on?

 Tomi


--hlAXGR7HUk7VeBHCHXMT6VopGsuf3vunT--

--caRGJ4fRxp7k3pVGJht1gmM0tuGP8OPf6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJY7inQAAoJEPo9qoy8lh71rpgP/RE+lDH1kH/iaAT7D2o9/0IN
0YznmbC/So4gwbKFf9/rntL271rEQvw1azsZ2GsQhKB7kdNdgHe8DxBdwydfv4kp
v5aWpTMBq42gsqEc80gywIAHCLQR3lXEDuhZyMNBcX4tQEYtbwsoH6aAmIQuOQhS
sSmRInxWLk76qgKii43OS+xYBDEW08aSc4Lzo7snH2xoZzs3KhezMfyLNeyZdNam
GNkN7PQRdYThkmvIu++p78ahp5d9SF1sAHaFH5kc7cBpop2dklqufpDwaLAQq1Wq
aqB7V0Qac5syHif+EJswqW5qSJDljuF5xpK3qdaFZlB/uB8r5CK8t6WuzLB1DxwH
MjG7x9dGvnRmBOckeJP/aD74rMUIO1lwgGb1OOfnn7ytRzMaa/s6nW9VMGQ+CXUF
bmhiY3aLN6MRZ278tkaNmzLSKlaUsg/eDsgxK4Rql98RpMOIFSTlXenBCdmrMAAT
ZIHKmMzqZQyq0ptC6rRwpNMCrzVpYRuidy3A2t/JvkciHFtQbKHSWQzzbFQnuNbS
NYiaS7iUm8Z6Dn//kI5yiVaVbJoBURJWCesJe5WIHM7zSVr3csPDhuW70RaBrSZw
CwLwWG2nqOd0Nz2I0g9z30igUe+/lWl6UaK6jjCios+3hLcPAJakITj0lTO+yOXy
MrW6OlthJ40hzZYOwJFm
=wKRx
-----END PGP SIGNATURE-----

--caRGJ4fRxp7k3pVGJht1gmM0tuGP8OPf6--

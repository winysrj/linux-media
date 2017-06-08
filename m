Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:27301 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdFHJTy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 05:19:54 -0400
Subject: Re: [PATCH 8/8] omapdrm: hdmi4: hook up the HDMI CEC support
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
CC: <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-9-hverkuil@xs4all.nl>
 <144b95df-8eb2-1307-1157-2eb2572c51aa@xs4all.nl>
 <7d3ab159-9284-bcc8-80f0-cbc621769203@ti.com>
 <50af289e-2601-2d57-71ce-1d0a205277cb@xs4all.nl>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <e88d84fa-b92e-1491-0c3b-d61d94b58234@ti.com>
Date: Thu, 8 Jun 2017 12:19:09 +0300
MIME-Version: 1.0
In-Reply-To: <50af289e-2601-2d57-71ce-1d0a205277cb@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="AAf9gs0iAtjPCsb6eJkmFnEQOtCLpRELe"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--AAf9gs0iAtjPCsb6eJkmFnEQOtCLpRELe
Content-Type: multipart/mixed; boundary="UNtHiT5Jrh3OBAx9JvQm9mgsJiE40stRa";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hans.verkuil@cisco.com>,
 Peter Ujfalusi <peter.ujfalusi@ti.com>
Message-ID: <e88d84fa-b92e-1491-0c3b-d61d94b58234@ti.com>
Subject: Re: [PATCH 8/8] omapdrm: hdmi4: hook up the HDMI CEC support
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-9-hverkuil@xs4all.nl>
 <144b95df-8eb2-1307-1157-2eb2572c51aa@xs4all.nl>
 <7d3ab159-9284-bcc8-80f0-cbc621769203@ti.com>
 <50af289e-2601-2d57-71ce-1d0a205277cb@xs4all.nl>
In-Reply-To: <50af289e-2601-2d57-71ce-1d0a205277cb@xs4all.nl>

--UNtHiT5Jrh3OBAx9JvQm9mgsJiE40stRa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 08/06/17 10:34, Hans Verkuil wrote:

>> Peter is about to send hotplug-interrupt-handling series, I think the
>> HPD function work should be done on top of that, as otherwise it'll ju=
st
>> conflict horribly.
>=20
> Has that been merged yet? And if so, what git repo/branch should I base=

> my next version of this patch series on? If not, do you know when it is=

> expected?

No, still pending review. The patches ("[PATCH v2 0/3] drm/omap: Support
for hotplug detection") apply on top of latest drm-next, if you want to t=
ry.

 Tomi


--UNtHiT5Jrh3OBAx9JvQm9mgsJiE40stRa--

--AAf9gs0iAtjPCsb6eJkmFnEQOtCLpRELe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZORaNAAoJEPo9qoy8lh71JIIP/35f/qnPtYjIGiPjQLezAv1k
cDKwvEssJdYyI0S7Tc+coKnIkURa+CeNPCmx8X0lyZ0LvSuFz9F2eQ817K+YGeaZ
9JoiiYpomr/VR9nKG8z5rxmbx4eFnkh2wnTuAmoewkcDXDE3CG0gU48MJK0J2irz
1fbjT5MFw1kdUlgQRZdcXwq5+FZNB9zcjjTXxlnvoL3FdM/r3FzYaU5+x0yaOwQJ
P7jzCs3nupNTTw5YEvwxqSV/0cc5vE1srPUir7SnFkU8DLD7BD6noZYJ1jSNA2PS
jHEUlrp8hdZ+x4TWgLvd1fYaPWTIjD830uUTa0I9zsbc1XQKhe86Pl6dDAImxEOB
46br8PFqxahXkCit0pU1+BQFhiM8ETBDrWbpCf4VGyA/prUKn+dyzASp5m+F9HVr
7WcO4lO2o9XdHMJnDI81/G9jpYdVb8u8rQ2k3DxYs2N24DEcwpoQ9oWmGPfLw/wB
H2ymvvnvLstzB8GBgnMyknqSvAdtRbwhx6TLjNyhLiAWyeIlJ5PVSQKJIsM/Llns
sFbGArHVTpn9oZX9AzBosWpcGp+8aDj+EqwP/qsMvtGz9D4zmpte6jBm+sstx6TF
vAYkso6NLekEU4dP2t9e3Zd6fVurePJKTH8X8JL4zP9sRPTflMlu1+waVlmBAb9f
h2eZ89FSflEtKDSvb67I
=b29v
-----END PGP SIGNATURE-----

--AAf9gs0iAtjPCsb6eJkmFnEQOtCLpRELe--

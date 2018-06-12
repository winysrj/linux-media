Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39528 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933640AbeFLOmX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 10:42:23 -0400
Message-ID: <46417cb4adca9289841287c8590b0ce92059298f.camel@collabora.com>
Subject: Re: [RFC 0/2] Memory-to-memory media controller topology
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com
Date: Tue, 12 Jun 2018 10:42:17 -0400
In-Reply-To: <20180612104827.11565-1-ezequiel@collabora.com>
References: <20180612104827.11565-1-ezequiel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-0BAOrG4YxvVe1kWgkumK"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-0BAOrG4YxvVe1kWgkumK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 12 juin 2018 =C3=A0 07:48 -0300, Ezequiel Garcia a =C3=A9crit :
> As discussed on IRC, memory-to-memory need to be modeled
> properly in order to be supported by the media controller
> framework, and thus to support the Request API.
>=20
> This RFC is a first draft on the memory-to-memory
> media controller topology.
>=20
> The topology looks like this:
>=20
> Device topology
> - entity 1: input (1 pad, 1 link)
>             type Node subtype Unknown flags 0
> 	pad0: Source
> 		-> "proc":1 [ENABLED,IMMUTABLE]
>=20
> - entity 3: proc (2 pads, 2 links)
>             type Node subtype Unknown flags 0
> 	pad0: Source
> 		-> "output":0 [ENABLED,IMMUTABLE]
> 	pad1: Sink
> 		<- "input":0 [ENABLED,IMMUTABLE]
>=20
> - entity 6: output (1 pad, 1 link)
>             type Node subtype Unknown flags 0
> 	pad0: Sink
> 		<- "proc":0 [ENABLED,IMMUTABLE]

Will the end result have "device node name /dev/..." on both entity 1
and 6 ? I got told that in the long run, one should be able to map a
device (/dev/mediaN) to it's nodes (/dev/video*). In a way that if we
keep going this way, all the media devices can be enumerated from media
node rather then a mixed between media nodes and orphaned video nodes.
>=20
> The first commit introduces a register/unregister API,
> that creates/destroys all the entities and pads needed,
> and links them.
>=20
> The second commit uses this API to support the vim2m driver.
>=20
> Notes
> -----
>=20
> * A new device node type is introduced VFL_TYPE_MEM2MEM,
>   this is mostly done so the video4linux core doesn't
>   try to register other media controller entities.
>=20
> * Also, a new media entity type is introduced. Memory-to-memory
>   devices have a multi-entity description and so can't
>   be simply embedded in other structs, or cast from other structs.
>=20
> Ezequiel Garcia (1):
>   media: add helpers for memory-to-memory media controller
>=20
> Hans Verkuil (1):
>   vim2m: add media device
>=20
>  drivers/media/platform/vim2m.c         |  41 ++++++-
>  drivers/media/v4l2-core/v4l2-dev.c     |  23 ++--
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 157
> +++++++++++++++++++++++++
>  include/media/media-entity.h           |   4 +
>  include/media/v4l2-dev.h               |   2 +
>  include/media/v4l2-mem2mem.h           |   5 +
>  include/uapi/linux/media.h             |   2 +
>  7 files changed, 222 insertions(+), 12 deletions(-)
>=20
> --=20
> 2.17.1
>=20
>=20
--=-0BAOrG4YxvVe1kWgkumK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWx/byQAKCRBxUwItrAao
HC4FAKCg5WIkXkFHiDfudkAG3Qe5Q4bhygCeOB+NgM0QtvE1X+NtM23DbM6rv2Y=
=TVeN
-----END PGP SIGNATURE-----

--=-0BAOrG4YxvVe1kWgkumK--

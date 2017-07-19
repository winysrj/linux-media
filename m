Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:35359 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbdGSM3k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 08:29:40 -0400
Date: Wed, 19 Jul 2017 14:29:38 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH v5 0/4] v4l2-async: add subnotifier registration for
 subdevices
Message-ID: <20170719122938.f5zycyzcdsy4ctw4@flea>
References: <20170719104946.7322-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="hib2o4abvzr55gvi"
Content-Disposition: inline
In-Reply-To: <20170719104946.7322-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hib2o4abvzr55gvi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Wed, Jul 19, 2017 at 12:49:42PM +0200, Niklas S=F6derlund wrote:
> Hi,
>=20
> I know Sakari have posted a series '[RFC 00/19] Async sub-notifiers and=
=20
> how to use them' which address similar problems as this series. This is=
=20
> not intended to compete whit his work and Sakari includes one of my v3=20
> patches in his series. Never the less I post this updated series since=20
> it fixes some issues in my v3 implementation and contains some other=20
> fixes for the v4l2-async framework which are not addressed in Sakaris=20
> patches. I think the correct solution to the problems we both try to fix=
=20
> is a mix of our two series, would you agree Sakari?
>=20
> This series enables incremental async find and bind of subdevices,
> please se patch 4/4 for a more detailed description. This is a rewrite=20
> of the feature since v3, see changelog in this cover letter for the=20
> differences to v3. The two primary reasons for a new implementation=20
> where:
>=20
> 1. Hans expressed an interest having the async complete() callbacks to
>    happen only once all notifiers in the pipeline where complete. To do
>    this a stronger connection between the notifiers where needed, hence
>    the subnotifier is now embedded in struct v4l2_subdev.
>=20
>    Whit this change it is possible to check all notifiers in a pipeline
>    is complete before calling any of them.
>=20
> 2. There where concerns that the v3 solution was a bit to complex and
>    hard to refactor in the future if other issues in the v4l2-async
>    framework where to be addressed. By hiding the notifier in the struct
>    v4l2_subdev and adding a new function to set that structure the
>    interface towards drivers are minimized while everything else happens
>    in the v4l2-async framework. This leaves the interface in a good
>    position for possible changes in v4l2-async.
>=20
> This is tested on Renesas H3 and M3-W together with the Renesas CSI-2
> and VIN Gen3 driver (posted separately). It is based on top of the media-=
tree.

Thanks for the new iteration, you can add my
Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>

On the cadence CSI2 RX driver I sent earlier.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--hib2o4abvzr55gvi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZb1CyAAoJEBx+YmzsjxAgmKYQAIN29DSdf/Txc831eFK0uqwM
44hodigXXa/WtYC1fQ5+dfxmykYOo/JK29oUPKi5utsUF42xf4b9jIrH7F8bM8sJ
jQqE16yea4m5QmkU/rieQiVvNIkCGcbTc0X40cKo5VoixhD9zeTYUF5UzY4E0/wr
4QHn8UeRY90AesvSp5n87d0xC7uXqA9/uHmmMtGATpsLKbP38kg7hRqrxooBmNw8
3GUtoEybgfdZaAgm+8SpGpByXTVq9rONyiP0W0Ht/mLO7SnfxOBcrY3w8u+JYCJW
HvmIk4GH6QbLLjNjjsXBzxAxou5Yn10RVhVS3Ls4el78UNXRwHF3zpZ1tMWDCUGI
OxaBXy5M4Ekc1uOIyDGjlELqe/51yv3h9VZ5Z+PI1JJZHwZTC3hkECBQ+FARVtOS
C0P86RQ8UtFh0kS3hTEaBZggF245uWaIl9cbvDAOWhkasjS4UY2FumfO+9BaM2ya
TE0ADnhLqfa4+6gihI2N8FeeKrwiKqO0DQRprh3utAYPl7rGo+I8enekiq1Q+/mQ
gsMht1wZf64BRUdGgsDCl3Z0oZnpfpVqGtYLJUw2xTOC1Rn0RVmDjye4v0lvmMfb
ik7HTUXO4E4dExBLp/CZ68JHCGzf2gJNYptaFGvsGAADctpznt+RJkV9gs+EXz3p
7pi24/WdADHP+UsyuPDe
=biwl
-----END PGP SIGNATURE-----

--hib2o4abvzr55gvi--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:47131 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbeKETiV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 14:38:21 -0500
Date: Mon, 5 Nov 2018 11:19:18 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 0/4] i2c: adv748x: add support for CSI-2 TXA to work
Message-ID: <20181105101918.GH20885@w540>
References: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="byLs0wutDcxFdwtm"
Content-Disposition: inline
In-Reply-To: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--byLs0wutDcxFdwtm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Fri, Nov 02, 2018 at 05:00:05PM +0100, Niklas S=C3=B6derlund wrote:
> Hi,
>
> This series allows the TXA CSI-2 transmitter of the adv748x to function
> in 1-, 2- and 4- lane mode. Currently the driver fixes the hardware in
> 4-lane mode. The driver looks at the standard DT property 'data-lanes'
> to determine which mode it should operate in.
>
> Patch 1/4 lists the 'data-lanes' DT property as mandatory for endpoints
> describing the CSI-2 transmitters. Patch 2/4 refactors the
> initialization sequence of the adv748x to be able to reuse more code.
> Patch 3/4 adds the DT parsing and storing of the number of lanes. Patch
> 4/4 merges the TXA and TXB power up/down procedure while also taking the
> configurable number of lanes into account.
>
> The series is based on the latest media-tree master and is tested on
> Renesas M3-N in 1-, 2- and 4- lane mode.

I have now tested v3 on Ebisu E3 which has only 2 data lanes
connected.

Tested-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks
   j


>
> Niklas S=C3=B6derlund (4):
>   dt-bindings: adv748x: make data-lanes property mandatory for CSI-2
>     endpoints
>   i2c: adv748x: reuse power up sequence when initializing CSI-2
>   i2c: adv748x: store number of CSI-2 lanes described in device tree
>   i2c: adv748x: configure number of lanes used for TXA CSI-2 transmitter
>
>  .../devicetree/bindings/media/i2c/adv748x.txt |   4 +-
>  drivers/media/i2c/adv748x/adv748x-core.c      | 235 ++++++++++--------
>  drivers/media/i2c/adv748x/adv748x.h           |   1 +
>  3 files changed, 135 insertions(+), 105 deletions(-)
>
> --
> 2.19.1
>

--byLs0wutDcxFdwtm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb4BkmAAoJEHI0Bo8WoVY87S8P/RhtRhWhJPi1xRt38vBsATsQ
tFz2K7n+vBMZHzh/YHxXxbGQqd7V7ABKLjQ3ukNgLnKfD3f7DX4n2BeExefaOg9U
wevLmd/pkpjbJ8tErmzPGaEdYSWzirqYquf+xR9TVNNiKXBM0IH6syDJfGI06v7f
VjtL75YoF+wGc6o5SUl6P+dlR6wTZ5Uj8EhxEMaLbtkZ3o73+Qdp3+/2Ta8C5/pJ
hsTURYy2yg750cVK9P8Q82mT+fX+9ZbR26stKu1z2gTJshWV4IDQE7gwRuJ3zFd8
IqXTFjBT6bgi0OgVSYRKNssen2JHyGG0EH+hEco9R39+bEk6RyJlOfryKjA4c3VG
67LpXmARLsEjONqry0bGeUwxkcm1LzVUQ609V2Epp0aFGf0eyR2q6zIONYyiMpHz
Jvuj94mDtQtJXi70wbK4AawrpQdX6owSiWs7RlgLcSYrA1E3f+vkWEndR4c3C/H7
9+aDDPS+i0c9Mfm2UTrcljIpHj9MKDoSJZfs+ZHZv5CudCvXPr2ZPRgOCL9dZhr7
3XpzMK6E8OmE89hhWben2jKk3ljcbDEtauUqFBze7DKJje4Of73Aa7JQWJZqBGRs
UL7HPQyCMxMfHhLbQsoA46zFWJHGI0yrhXn1Oo7UzU9H1D0nZ0zPKMIaObkEMlBS
v0BGnBPT7tabmUTpu754
=KcXG
-----END PGP SIGNATURE-----

--byLs0wutDcxFdwtm--

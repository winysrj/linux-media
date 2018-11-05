Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:43363 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbeKER7q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 12:59:46 -0500
Date: Mon, 5 Nov 2018 09:41:06 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/4] dt-bindings: adv748x: make data-lanes property
 mandatory for CSI-2 endpoints
Message-ID: <20181105084106.GE20885@w540>
References: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se>
 <20181102160009.17267-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uTRFFR9qmiCqR05s"
Content-Disposition: inline
In-Reply-To: <20181102160009.17267-2-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uTRFFR9qmiCqR05s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Fri, Nov 02, 2018 at 05:00:06PM +0100, Niklas S=C3=B6derlund wrote:
> The CSI-2 transmitters can use a different number of lanes to transmit
> data. Make the data-lanes mandatory for the endpoints that describe the
> transmitters as no good default can be set to fallback on.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
>
> ---
> * Changes since v2
> - Update paragraph according to Laurents comments.
> ---
>  Documentation/devicetree/bindings/media/i2c/adv748x.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt b/Do=
cumentation/devicetree/bindings/media/i2c/adv748x.txt
> index 5dddc95f9cc46084..bffbabc879efd86c 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> @@ -48,7 +48,9 @@ are numbered as follows.
>  	  TXA		source		10
>  	  TXB		source		11
>
> -The digital output port nodes must contain at least one endpoint.
> +The digital output port nodes, when present, shall contain at least one
> +endpoint. Each of those endpoints shall contain the data-lanes property =
as
> +described in video-interfaces.txt.
>
>  Ports are optional if they are not connected to anything at the hardware=
 level.
>

Re-vamping my ignored comment on v2, I still think you should list here the
accepted values for each TX as they're actually a property of the hw
device itself.

 Required endpoint properties:
- data-lanes: See "video-interfaces.txt" for description. The property
  is mandatory for CSI-2 output endpoints and the accepted value
  depends on which endpoint the property is applied to:
  - TXA: accepted values are <1>, <2>, <4>
  - TXB: accepted value is <1>
> --
> 2.19.1
>

--uTRFFR9qmiCqR05s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb4AIiAAoJEHI0Bo8WoVY8HbEP/2ZoV0dKyFobPK964f06P0jf
2Xyon6AJBGzk6C3Wmf14ZwV6pkGvxZnIX9f5TPnBkWV3huLogNKqKkjctycJ5civ
5uDEu1FV+FGqB+kpoHkHvYRLLC1oDARXJzgKPv8oGfMzU0RBNjYM1McDiNygLh1o
gFre+T0J6VAi6NcqG2zaBE9JsgjwgiK+tEklb3njTOkV0TGVcoEGehyT0O5vjXy/
wKvsPTho4n6bFajIbZgnI2kh13U3skWIpBLpoM7HhKKSPhfFstztiD06n0E9jaXz
qocOVcHABGeZxl0FFhNaFEnxWBxL0WTh7Du1HHyDmuyMVUDXo08rbWGrvbWfX/i5
4xYHLygwEQmQIDpNnNS7DoP9xUF/8jsOvCZl5ZrY6GpakgcU23APjUL7ENyrPKu0
qZdW5aClIgmPUdnOKWAJkIW5H0443OORTopA6/qPKxTuKrQHp6xPdmwO3E81ggRx
f2+E43Zk4XBKTfVZFWhbIEoWMHoIBxKQZkEX9TMACPbiuVBTBW3uqSTb/wM3efL+
osgT1NRK8VTGR+ocJWfyRYTstZNfJk2WjnM60LJHPAWY044Aww/Dj8CaYufwLTnM
el2F8YcF8OGWDxGpsklwT8SY9jpdSL2gp5IMlqdprXpe5V7FXGlUCbHA4VjtpQ1z
ExuLAqkM1S37fSWcb4t8
=pDvD
-----END PGP SIGNATURE-----

--uTRFFR9qmiCqR05s--

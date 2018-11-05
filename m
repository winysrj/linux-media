Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:57952 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbeKEUCz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 15:02:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/4] dt-bindings: adv748x: make data-lanes property mandatory for CSI-2 endpoints
Date: Mon, 05 Nov 2018 12:43:59 +0200
Message-ID: <1890868.PC2OSGIH6q@avalon>
In-Reply-To: <20181102160009.17267-2-niklas.soderlund+renesas@ragnatech.se>
References: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se> <20181102160009.17267-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 2 November 2018 18:00:06 EET Niklas S=F6derlund wrote:
> The CSI-2 transmitters can use a different number of lanes to transmit
> data. Make the data-lanes mandatory for the endpoints that describe the
> transmitters as no good default can be set to fallback on.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>=20
> ---
> * Changes since v2
> - Update paragraph according to Laurents comments.
> ---
>  Documentation/devicetree/bindings/media/i2c/adv748x.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> b/Documentation/devicetree/bindings/media/i2c/adv748x.txt index
> 5dddc95f9cc46084..bffbabc879efd86c 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> @@ -48,7 +48,9 @@ are numbered as follows.
>  	  TXA		source		10
>  	  TXB		source		11
>=20
> -The digital output port nodes must contain at least one endpoint.
> +The digital output port nodes, when present, shall contain at least one
> +endpoint. Each of those endpoints shall contain the data-lanes property =
as
> +described in video-interfaces.txt.
>=20
>  Ports are optional if they are not connected to anything at the hardware
> level.


=2D-=20
Regards,

Laurent Pinchart

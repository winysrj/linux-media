Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47280 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753774AbdLHJkf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 04:40:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 14/28] rcar-vin: move media bus configuration to struct rvin_info
Date: Fri, 08 Dec 2017 11:40:53 +0200
Message-ID: <5935699.ZFW4HLYlYX@avalon>
In-Reply-To: <20171208010842.20047-15-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <20171208010842.20047-15-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday, 8 December 2017 03:08:28 EET Niklas S=F6derlund wrote:
> Bus configuration will once the driver is extended to support Gen3
> contain information not specific to only the directly connected parallel
> subdevice. Move it to struct rvin_info to show it's not always coupled
> to the parallel subdevice.

You do realize that rvin_info is a const structure and that you have moved =
the=20
fields to the rvin_dev structure, right ? :-)

> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 18 +++++++++---------
>  drivers/media/platform/rcar-vin/rcar-dma.c  | 11 ++++++-----
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  2 +-
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  9 ++++-----
>  4 files changed, 20 insertions(+), 20 deletions(-)

[snip]

> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> f8e0e7cedeaa6c38..118f45b656920d39 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -62,8 +62,6 @@ struct rvin_video_format {
>   * struct rvin_graph_entity - Video endpoint from async framework
>   * @asd:	sub-device descriptor for async framework
>   * @subdev:	subdevice matched using async framework
> - * @code:	Media bus format from source
> - * @mbus_cfg:	Media bus format from DT
>   * @source_pad:	source pad of remote subdevice
>   * @sink_pad:	sink pad of remote subdevice
>   */
> @@ -71,9 +69,6 @@ struct rvin_graph_entity {
>  	struct v4l2_async_subdev asd;
>  	struct v4l2_subdev *subdev;
>=20
> -	u32 code;
> -	struct v4l2_mbus_config mbus_cfg;
> -
>  	unsigned int source_pad;
>  	unsigned int sink_pad;
>  };
> @@ -115,6 +110,8 @@ struct rvin_info {
>   * @sequence:		V4L2 buffers sequence number
>   * @state:		keeps track of operation state
>   *
> + * @mbus_cfg:		media bus format from DT

This isn't a format, is it ?

> + * @code:		media bus coide from subdevice

s/coide/code/

and I think you should actually rewrite the description of the field=20
completely, it's not clear what it contains.

>   * @format:		active V4L2 pixel format
>   *
>   * @crop:		active cropping
> @@ -141,6 +138,8 @@ struct rvin_dev {
>  	unsigned int sequence;
>  	enum rvin_dma_state state;
>=20
> +	struct v4l2_mbus_config mbus_cfg;
> +	u32 code;
>  	struct v4l2_pix_format format;
>=20
>  	struct v4l2_rect crop;

=2D-=20
Regards,

Laurent Pinchart

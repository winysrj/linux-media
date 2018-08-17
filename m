Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43762 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbeHQUMj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Aug 2018 16:12:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>, Jacopo Mondi <jacopo@jmondi.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH v2 4/4] media: i2c: Add RDACM20 driver
Date: Fri, 17 Aug 2018 20:09:19 +0300
Message-ID: <5524303.kLxU94kiUG@avalon>
In-Reply-To: <20180808165559.29957-5-kieran.bingham@ideasonboard.com>
References: <20180808165559.29957-1-kieran.bingham@ideasonboard.com> <20180808165559.29957-5-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Wednesday, 8 August 2018 19:55:59 EEST Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>=20
> The RDACM20 is a GMSL camera supporting 1280x800 resolution images
> developed by IMI based on an Omnivision 10635 sensor and a Maxim MAX9271
> GMSL serializer.
>=20
> The GMSL link carries power, control (I2C) and video data over a
> single coax cable.
>=20
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.co=
m>
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>=20
> ---
> v2:
>  - Fix MAINTAINERS entry
>=20
>  MAINTAINERS                         |  10 +
>  drivers/media/i2c/Kconfig           |  11 +
>  drivers/media/i2c/Makefile          |   1 +
>  drivers/media/i2c/rdacm20-ov10635.h | 953 ++++++++++++++++++++++++++++
>  drivers/media/i2c/rdacm20.c         | 635 ++++++++++++++++++
>  5 files changed, 1610 insertions(+)
>  create mode 100644 drivers/media/i2c/rdacm20-ov10635.h
>  create mode 100644 drivers/media/i2c/rdacm20.c

[snip]

> diff --git a/drivers/media/i2c/rdacm20.c b/drivers/media/i2c/rdacm20.c
> new file mode 100644
> index 000000000000..352c54902d1c
> --- /dev/null
> +++ b/drivers/media/i2c/rdacm20.c
> @@ -0,0 +1,635 @@

[snip]

> +MODULE_DESCRIPTION("SoC Camera driver for MAX9286<->MAX9271<->OV10635");

You probably want to fix this. Apart from that, the code looks good to me a=
s a=20
first driver version, knowing that we will continue development and=20
refactoring to try and separate the OV10635 and MAX9271 code.

> +MODULE_AUTHOR("Vladimir Barinov");
> +MODULE_LICENSE("GPL");

=2D-=20
Regards,

Laurent Pinchart

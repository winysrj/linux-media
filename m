Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33418 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbdHRLMy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 07:12:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH 1/4] v4l: async: fix unbind error in v4l2_async_notifier_unregister()
Date: Fri, 18 Aug 2017 14:13:17 +0300
Message-ID: <3708304.dzPkAFdM1e@avalon>
In-Reply-To: <20170730223158.14405-2-niklas.soderlund+renesas@ragnatech.se>
References: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se> <20170730223158.14405-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Monday 31 Jul 2017 00:31:55 Niklas S=F6derlund wrote:
> The call to v4l2_async_cleanup() will set sd->asd to NULL so passing =
it
> to notifier->unbind() have no effect and leaves the notifier confused=
.
> Call the unbind() callback prior to cleaning up the subdevice to avoi=
d
> this.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/v4l2-async.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> b/drivers/media/v4l2-core/v4l2-async.c index
> 851f128eba2219ad..0acf288d7227ba97 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -226,14 +226,14 @@ void v4l2_async_notifier_unregister(struct
> v4l2_async_notifier *notifier)
>=20
>  =09=09d =3D get_device(sd->dev);
>=20
> +=09=09if (notifier->unbind)
> +=09=09=09notifier->unbind(notifier, sd, sd->asd);
> +
>  =09=09v4l2_async_cleanup(sd);
>=20
>  =09=09/* If we handled USB devices, we'd have to lock the parent too=
=20
*/
>  =09=09device_release_driver(d);
>=20
> -=09=09if (notifier->unbind)
> -=09=09=09notifier->unbind(notifier, sd, sd->asd);
> -
>  =09=09/*
>  =09=09 * Store device at the device cache, in order to call
>  =09=09 * put_device() on the final step

--=20
Regards,

Laurent Pinchart

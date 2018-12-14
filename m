Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CB1C6786C
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 08:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D23D2146D
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 08:36:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="ofKtQvGU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D23D2146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbeLNIgs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 03:36:48 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49598 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbeLNIgs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 03:36:48 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id AEF71549;
        Fri, 14 Dec 2018 09:36:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544776605;
        bh=G1iU8pDdLnV1DMs6xP4CeXTRBFCwg7yjGM9xNgeTpFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofKtQvGUbYPA/DJjLF+/ix5ZtirsfaUUhFalb1EFEGY3A00clYZnspqbIH1sPKF40
         G93eTh+pSqF0e/pBJcxAak5HIDKl+G1/5aX1ggu8WLJoNw5bbuE5p0eNdkVkvM/2qe
         /XaopQb+//zljdz+WH73TmmE8EUV/jUDCiJgnECo=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?ISO-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 4/4] rcar-vin: add support for suspend and resume
Date:   Fri, 14 Dec 2018 10:37:34 +0200
Message-ID: <1648503.1eWIQ13pqG@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181214061824.10296-5-niklas.soderlund+renesas@ragnatech.se>
References: <20181214061824.10296-1-niklas.soderlund+renesas@ragnatech.se> <20181214061824.10296-5-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Friday, 14 December 2018 08:18:24 EET Niklas S=F6derlund wrote:
> To be able to properly support suspend and resume the VIN and all
> subdevices involved in a running capture needs to be stopped before the
> system is suspended. Likewise the whole pipeline needs to be started
> once the system is resumed if it was running.
>=20
> Achieve this by using the existing rvin_{start,stop}_stream() functions
> while making sure the CSI-2 channel selection is applied to the VIN
> master before restarting the capture. To be able to do keep track of
> which VINs should be resumed a new internal state SUSPENDED is added to
> describe this state.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 51 +++++++++++++++++++++
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 10 ++--
>  2 files changed, 57 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> f0719ce24b97a9f9..7b34d69a97f4771d 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -862,6 +862,54 @@ static int rvin_mc_init(struct rvin_dev *vin)
>  	return ret;
>  }
>=20
> +/* ---------------------------------------------------------------------=
=2D--
> + * Suspend / Resume
> + */
> +
> +static int __maybe_unused rvin_suspend(struct device *dev)
> +{
> +	struct rvin_dev *vin =3D dev_get_drvdata(dev);
> +
> +	if (vin->state !=3D RUNNING)
> +		return 0;

Could this race with userspace starting or stopping a stream ?

> +	rvin_stop_streaming(vin);
> +
> +	vin->state =3D SUSPENDED;
> +
> +	return 0;
> +}
> +
> +static int __maybe_unused rvin_resume(struct device *dev)
> +{
> +	struct rvin_dev *vin =3D dev_get_drvdata(dev);
> +
> +	if (vin->state !=3D SUSPENDED)
> +		return 0;
> +
> +	/*
> +	 * Restore group master CHSEL setting.
> +	 *
> +	 * This needs to be by every VIN resuming not only the master
> +	 * as we don't know if and in which order the master VINs will
> +	 * be resumed.
> +	 */
> +	if (vin->info->use_mc) {
> +		unsigned int master_id =3D rvin_group_id_to_master(vin->id);
> +		struct rvin_dev *master =3D vin->group->vin[master_id];
> +		int ret;
> +
> +		if (WARN_ON(!master))
> +			return -ENODEV;
> +
> +		ret =3D rvin_set_channel_routing(master, master->chsel);
> +		if (ret)
> +			return ret;

What happens if the master isn't resumed yet, could it cause access to=20
hardware with clocks disabled ? I don't expect pm_runtime_get_sync() to=20
happily handle suspended devices.

> +	}
> +
> +	return rvin_start_streaming(vin);
> +}

Note for later, it would be nice to have suspend/resume helpers in V4L2 tha=
t=20
would stop/start streaming and generally exercise the driver through its V4=
L2=20
API only, to avoid the need for custom suspend/resume code.

>  /* ---------------------------------------------------------------------=
=2D--
>   * Platform Device Driver
>   */
> @@ -1313,9 +1361,12 @@ static int rcar_vin_remove(struct platform_device
> *pdev) return 0;
>  }
>=20
> +static SIMPLE_DEV_PM_OPS(rvin_pm_ops, rvin_suspend, rvin_resume);
> +
>  static struct platform_driver rcar_vin_driver =3D {
>  	.driver =3D {
>  		.name =3D "rcar-vin",
> +		.pm =3D &rvin_pm_ops,
>  		.of_match_table =3D rvin_of_id_table,
>  	},
>  	.probe =3D rcar_vin_probe,
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 700fae1c1225a2f3..9bbc5a57fcb2915e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -48,16 +48,18 @@ enum rvin_csi_id {
>  };
>=20
>  /**
> - * STOPPED  - No operation in progress
> - * STARTING - Capture starting up
> - * RUNNING  - Operation in progress have buffers
> - * STOPPING - Stopping operation
> + * STOPPED   - No operation in progress
> + * STARTING  - Capture starting up
> + * RUNNING   - Operation in progress have buffers
> + * STOPPING  - Stopping operation
> + * SUSPENDED - Capture is suspended

While at it, could you convert this to proper kerneldoc ?

>   */
>  enum rvin_dma_state {
>  	STOPPED =3D 0,
>  	STARTING,
>  	RUNNING,
>  	STOPPING,
> +	SUSPENDED,
>  };
>=20
>  /**

=2D-=20
Regards,

Laurent Pinchart




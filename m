Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE4DC6786C
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 08:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8B362086D
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 08:22:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="dIRDvlPy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8B362086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbeLNIWj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 03:22:39 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49352 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbeLNIWj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 03:22:39 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 56CC0549;
        Fri, 14 Dec 2018 09:22:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544775757;
        bh=VNQxDNRgYy027upeTy209RVX7BAXy+qOjg43HA1fgpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIRDvlPyDlHWgLCI6yL3GnqvmpYrOaMnB+h6+lPHchRaNtbXzPgHCnmuk/MkPpxDp
         cbvjc7YZeHeVgfSJqFeBF7XydrjA2Q0MMY4nJ0SjusLwNopCo3jUaGDbTxhAA0smXR
         pA+uFexJshmurSBMiylKmp6VNdTpNKpcnqJ/HiA4=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?ISO-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/4] rcar-vin: cache the CSI-2 channel selection value
Date:   Fri, 14 Dec 2018 10:23:25 +0200
Message-ID: <14327612.kiatMVmQX0@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181214061824.10296-3-niklas.soderlund+renesas@ragnatech.se>
References: <20181214061824.10296-1-niklas.soderlund+renesas@ragnatech.se> <20181214061824.10296-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Friday, 14 December 2018 08:18:22 EET Niklas S=F6derlund wrote:
> In preparation of suspend/resume support cache the chsel value when we
> write it to the register so it can be restored on resume if needed.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 2 ++
>  drivers/media/platform/rcar-vin/rcar-vin.h | 2 ++
>  2 files changed, 4 insertions(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> beb9248992a48a74..64f7636f94d6a0a3 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1336,6 +1336,8 @@ int rvin_set_channel_routing(struct rvin_dev *vin, =
u8
> chsel)
>=20
>  	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
>=20
> +	vin->chsel =3D chsel;
> +

Would it be useful to add a

	if (vin->chsel =3D=3D chsel)
		return 0;

at the beginning of the function, or is that impossible ?

>  	/* Restore VNMC. */
>  	rvin_write(vin, vnmc, VNMC_REG);
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> 0b13b34d03e3dce4..d21fc991b7a9da36 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -170,6 +170,7 @@ struct rvin_info {
>   * @state:		keeps track of operation state
>   *
>   * @is_csi:		flag to mark the VIN as using a CSI-2 subdevice
> + * @chsel		Cached value of the current CSI-2 channel selection

Nitpicking, the documentation for other fields don't start with a capital=20
letter.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>   *
>   * @mbus_code:		media bus format code
>   * @format:		active V4L2 pixel format
> @@ -207,6 +208,7 @@ struct rvin_dev {
>  	enum rvin_dma_state state;
>=20
>  	bool is_csi;
> +	unsigned int chsel;
>=20
>  	u32 mbus_code;
>  	struct v4l2_pix_format format;

=2D-=20
Regards,

Laurent Pinchart




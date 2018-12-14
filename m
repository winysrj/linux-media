Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2E0C67872
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 08:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33E2520879
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 08:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="BvcI1TIE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33E2520879
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbeLNI0g (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 03:26:36 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49490 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbeLNI0g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 03:26:36 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 35D25549;
        Fri, 14 Dec 2018 09:26:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544775994;
        bh=MgAufgl2JuzgglUJOvyn0UD4lBG+kOn7h9BviEHBRW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvcI1TIEqc+9p+DMNLyejFn1Au8clzdF5H0jCVLw/Ew17uPaxs99+0tAzuKYqJbJT
         bHKeTbTvGf2AHW1IrwuzgtqpBQMdnmnZRvMs8u8NAH8N13ou/tmtzxzuylWxUxLaTT
         HvaumrsKWFIvilwmXxI38ZEuPMNbHwGrryuJtjao=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?ISO-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/4] rcar-vin: make rvin_{start,stop}_streaming() available for internal use
Date:   Fri, 14 Dec 2018 10:27:22 +0200
Message-ID: <23080491.FYkgn8OxuK@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181214061824.10296-4-niklas.soderlund+renesas@ragnatech.se>
References: <20181214061824.10296-1-niklas.soderlund+renesas@ragnatech.se> <20181214061824.10296-4-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Friday, 14 December 2018 08:18:23 EET Niklas S=F6derlund wrote:
> To support suspend/resume rvin_{start,stop}_streaming() needs to be
> accessible from the suspend and resume callbacks. Up until now the only
> users of these functions have been the callbacks in struct vb2_ops so
> the arguments to the functions are not suitable for use by the driver it
> self.
>=20
> Fix this by adding wrappers for the struct vb2_ops callbacks which calls
> the new rvin_{start,stop}_streaming() using more friendly arguments.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 20 ++++++++++++++------
>  drivers/media/platform/rcar-vin/rcar-vin.h |  3 +++
>  2 files changed, 17 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> 64f7636f94d6a0a3..d11d4df1906a8962 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1143,9 +1143,8 @@ static int rvin_set_stream(struct rvin_dev *vin, int
> on) return ret;
>  }
>=20
> -static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
> +int rvin_start_streaming(struct rvin_dev *vin)
>  {
> -	struct rvin_dev *vin =3D vb2_get_drv_priv(vq);
>  	unsigned long flags;
>  	int ret;
>=20
> @@ -1187,9 +1186,13 @@ static int rvin_start_streaming(struct vb2_queue *=
vq,
> unsigned int count) return ret;
>  }
>=20
> -static void rvin_stop_streaming(struct vb2_queue *vq)
> +static int rvin_start_streaming_vq(struct vb2_queue *vq, unsigned int
> count)
> +{
> +	return rvin_start_streaming(vb2_get_drv_priv(vq));
> +}
> +
> +void rvin_stop_streaming(struct rvin_dev *vin)
>  {
> -	struct rvin_dev *vin =3D vb2_get_drv_priv(vq);
>  	unsigned long flags;
>  	int retries =3D 0;
>=20
> @@ -1238,12 +1241,17 @@ static void rvin_stop_streaming(struct vb2_queue
> *vq) vin->scratch_phys);
>  }
>=20
> +static void rvin_stop_streaming_vq(struct vb2_queue *vq)
> +{
> +	rvin_stop_streaming(vb2_get_drv_priv(vq));
> +}

You'll need a bit more than this. rvin_stop_streaming() calls=20
return_all_buffers() and dma_free_coherent() which you don't want at suspen=
d=20
time. Buffers should not be returned to userspace but kept for reuse, and i=
t's=20
pointless to free the scratch buffer at suspend time to reallocate it at=20
resume time.

>  static const struct vb2_ops rvin_qops =3D {
>  	.queue_setup		=3D rvin_queue_setup,
>  	.buf_prepare		=3D rvin_buffer_prepare,
>  	.buf_queue		=3D rvin_buffer_queue,
> -	.start_streaming	=3D rvin_start_streaming,
> -	.stop_streaming		=3D rvin_stop_streaming,
> +	.start_streaming	=3D rvin_start_streaming_vq,
> +	.stop_streaming		=3D rvin_stop_streaming_vq,
>  	.wait_prepare		=3D vb2_ops_wait_prepare,
>  	.wait_finish		=3D vb2_ops_wait_finish,
>  };
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> b/drivers/media/platform/rcar-vin/rcar-vin.h index
> d21fc991b7a9da36..700fae1c1225a2f3 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -269,4 +269,7 @@ void rvin_crop_scale_comp(struct rvin_dev *vin);
>=20
>  int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel);
>=20
> +int rvin_start_streaming(struct rvin_dev *vin);
> +void rvin_stop_streaming(struct rvin_dev *vin);
> +
>  #endif


=2D-=20
Regards,

Laurent Pinchart




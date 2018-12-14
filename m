Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B461C67872
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 08:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC9392086D
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 08:18:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Lo/sYlq3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC9392086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbeLNISo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 03:18:44 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49180 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbeLNISn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 03:18:43 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 35E08549;
        Fri, 14 Dec 2018 09:18:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544775521;
        bh=4lL21+3q0AmUbb5skhefrU+yBFa7uBBQVNxihcQMYVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lo/sYlq3QDzK03VnBnXkgARnvfDUUADMqGcteZ8+PSq8ez79KcjDgyBy8A5OW8JEu
         tXWQXF4PBVL/hwuo8kZMdO8fv+L6BNBQLHk3JzX5fIhrEEdyS+OcmWg2BNhLoGAm1j
         BeemNHxwhvK1P6+ilt3jljWa0RetWiXc8wwXI8yE=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?ISO-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/4] rcar-vin: fix wrong return value in rvin_set_channel_routing()
Date:   Fri, 14 Dec 2018 10:19:29 +0200
Message-ID: <1606894.g7i5N49tKT@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181214061824.10296-2-niklas.soderlund+renesas@ragnatech.se>
References: <20181214061824.10296-1-niklas.soderlund+renesas@ragnatech.se> <20181214061824.10296-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Friday, 14 December 2018 08:18:21 EET Niklas S=F6derlund wrote:
> If the operation in rvin_set_channel_routing() is successful the 'ret'
> variable contains the runtime PM use count for the VIN master device.
> The intention is not to return the use count to the caller but to return
> 0 on success else none zero.
>=20
> Fix this by always returning 0 if the operation is successful.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> 92323310f7352147..beb9248992a48a74 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1341,5 +1341,5 @@ int rvin_set_channel_routing(struct rvin_dev *vin, =
u8
> chsel)
>=20
>  	pm_runtime_put(vin->dev);
>=20
> -	return ret;
> +	return 0;
>  }


=2D-=20
Regards,

Laurent Pinchart




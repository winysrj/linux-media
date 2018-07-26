Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:33250 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbeGZOgB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 10:36:01 -0400
Date: Thu, 26 Jul 2018 15:19:06 +0200
From: Simon Horman <horms@verge.net.au>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?utf-8?Q?=22Niklas_S=C3=B6derlund=22?=
        <niklas.soderlund@ragnatech.se>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 00/11] convert to SPDX identifiers
Message-ID: <20180726131906.ofxxfzec7mvjtaqf@verge.net.au>
References: <87h8kmd938.wl-kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h8kmd938.wl-kuninori.morimoto.gx@renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 26, 2018 at 02:33:51AM +0000, Kuninori Morimoto wrote:
> 
> Hi Mauro, Hans
> 
> These convert license to SPDX style for Renesas related drivers
> These are using "Author's favored style", not "Linus favored style".
> 
> Kuninori Morimoto (11):
>   media: soc_camera_platform: convert to SPDX identifiers
>   media: rcar-vin: convert to SPDX identifiers
>   media: rcar-fcp: convert to SPDX identifiers
>   media: rcar_drif: convert to SPDX identifiers
>   media: rcar_fdp1: convert to SPDX identifiers
>   media: rcar_jpu: convert to SPDX identifiers
>   media: sh_veu: convert to SPDX identifiers
>   media: sh_vou: convert to SPDX identifiers
>   media: sh_mobile_ceu: convert to SPDX identifiers
>   drm: rcar-du: convert to SPDX identifiers
>   drm: shmobile: convert to SPDX identifiers

...

>  44 files changed, 46 insertions(+), 196 deletions(-)

Nice diffstat.

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>

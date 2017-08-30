Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:54236 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdH3Hgl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 03:36:41 -0400
Date: Wed, 30 Aug 2017 09:36:37 +0200
From: Simon Horman <horms@verge.net.au>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 20/20] arm64: dts: renesas: salvator: use VC1 for CVBS
Message-ID: <20170830073637.GM10398@verge.net.au>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
 <20170811095703.6170-21-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170811095703.6170-21-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 11, 2017 at 11:57:03AM +0200, Niklas Söderlund wrote:
> In order to test Virtual Channels use VC1 for CVBS input from the
> adv748x.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  arch/arm64/boot/dts/renesas/salvator-common.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/renesas/salvator-common.dtsi b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
> index 7b67efcb1d22090a..8047fe1df065d63b 100644
> --- a/arch/arm64/boot/dts/renesas/salvator-common.dtsi
> +++ b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
> @@ -41,7 +41,7 @@
>  	};
>  
>  	chosen {
> -		bootargs = "ignore_loglevel rw root=/dev/nfs ip=dhcp";
> +		bootargs = "ignore_loglevel rw root=/dev/nfs ip=dhcp adv748x.txbvc=1";
>  		stdout-path = "serial0:115200n8";
>  	};

Hi Niklas,

I'm somewhat surprised to see what appears to be a new module parameter.
I'm not going to reject this but did you give consideration to doing this
another way?

In any case I have marked this as "Deferred" pending acceptance of the
driver change. If you think it can go in now then I'm open to discussion.

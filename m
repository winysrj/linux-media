Return-path: <linux-media-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:13646 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756131AbaDHLob (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Apr 2014 07:44:31 -0400
Date: Tue, 8 Apr 2014 19:44:09 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Denis Carikli <denis@eukrea.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	<linux-arm-kernel@lists.infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<devel@driverdev.osuosl.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	<linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
	<dri-devel@lists.freedesktop.org>, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12][ 06/12] ARM: dts: imx5*, imx6*: correct
 display-timings nodes.
Message-ID: <20140408114407.GB3860@dragon>
References: <1396874691-27954-1-git-send-email-denis@eukrea.com>
 <1396874691-27954-6-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1396874691-27954-6-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 07, 2014 at 02:44:45PM +0200, Denis Carikli wrote:
> The imx-drm driver can't use the de-active and
> pixelclk-active display-timings properties yet.
> 
> Instead the data-enable and the pixel data clock
> polarity are hardcoded in the imx-drm driver.
> 
> So theses properties are now set to keep
> the same behaviour when imx-drm will start
> using them.
> 
> Signed-off-by: Denis Carikli <denis@eukrea.com>
> ---
> ChangeLog v9->v10:
> - New patch that was splitted out of:
>   "staging imx-drm: Use de-active and pixelclk-active
>   display-timings."
> ---
>  arch/arm/boot/dts/imx51-babbage.dts       |    2 ++
>  arch/arm/boot/dts/imx53-m53evk.dts        |    2 ++
>  arch/arm/boot/dts/imx53-tx53-x03x.dts     |    2 +-
>  arch/arm/boot/dts/imx6qdl-gw53xx.dtsi     |    2 ++
>  arch/arm/boot/dts/imx6qdl-gw54xx.dtsi     |    2 ++
>  arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi |    2 ++
>  arch/arm/boot/dts/imx6qdl-sabreauto.dtsi  |    2 ++
>  arch/arm/boot/dts/imx6qdl-sabrelite.dtsi  |    2 ++
>  arch/arm/boot/dts/imx6qdl-sabresd.dtsi    |    2 ++
>  9 files changed, 17 insertions(+), 1 deletion(-)

...

> diff --git a/arch/arm/boot/dts/imx53-tx53-x03x.dts b/arch/arm/boot/dts/imx53-tx53-x03x.dts
> index 0217dde3..4092a81 100644
> --- a/arch/arm/boot/dts/imx53-tx53-x03x.dts
> +++ b/arch/arm/boot/dts/imx53-tx53-x03x.dts
> @@ -93,7 +93,7 @@
>  					hsync-active = <0>;
>  					vsync-active = <0>;
>  					de-active = <1>;
> -					pixelclk-active = <1>;
> +					pixelclk-active = <0>;

@Lothar, is this change correct?

Shawn

>  				};
>  
>  				ET0500 {


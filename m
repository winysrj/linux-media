Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34209 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933307AbbHDMG4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 08:06:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: William Towle <william.towle@codethink.co.uk>
Cc: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: shmobile: lager dts: specify default-input for ADV7612
Date: Tue, 04 Aug 2015 15:07:41 +0300
Message-ID: <2031552.vcAWTm60WT@avalon>
In-Reply-To: <1438100264-17280-3-git-send-email-william.towle@codethink.co.uk>
References: <1438100264-17280-1-git-send-email-william.towle@codethink.co.uk> <1438100264-17280-3-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi William,

Thank you for the patch.

On Tuesday 28 July 2015 17:17:44 William Towle wrote:
> Set 'default-input' property for ADV7612. Enables image/video capture
> without the need to have userspace specifying routing.
> 
> Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
> Tested-by: William Towle <william.towle@codethink.co.uk>
> ---
>  arch/arm/boot/dts/r8a7790-lager.dts |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/boot/dts/r8a7790-lager.dts
> b/arch/arm/boot/dts/r8a7790-lager.dts index aec7db6..e537052 100644
> --- a/arch/arm/boot/dts/r8a7790-lager.dts
> +++ b/arch/arm/boot/dts/r8a7790-lager.dts
> @@ -552,6 +552,7 @@
>  		port {
>  			hdmi_in_ep: endpoint {
>  				remote-endpoint = <&vin0ep0>;
> +				default-input = <0>;

The default property must be placed in the adv7612 node, not in the endpoint 
node.

It looks like I've missed the patch that added the property to the DT 
bindings. I would probably have complained about it, but now it's in :-/

Nevertheless, I think it would make sense for the driver to select the default 
input automatically when only one input is connected. I'd prefer a driver 
patch that implements that behaviour instead of adding the property to the 
Lager DT.

>  			};
>  		};
>  	};

-- 
Regards,

Laurent Pinchart


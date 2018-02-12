Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:51623 "EHLO
        www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbeBLSYe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 13:24:34 -0500
Subject: Re: [PATCH v2 3/5] [RFT] ARM: dts: wheat: Fix ADV7513 address usage
To: Kieran Bingham <kbingham@kernel.org>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Simon Horman <horms@verge.net.au>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
References: <1518459117-16733-1-git-send-email-kbingham@kernel.org>
 <1518459117-16733-4-git-send-email-kbingham@kernel.org>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <bc0dfd28-652a-80e7-a08b-6909b0e34883@metafoo.de>
Date: Mon, 12 Feb 2018 19:24:22 +0100
MIME-Version: 1.0
In-Reply-To: <1518459117-16733-4-git-send-email-kbingham@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2018 07:11 PM, Kieran Bingham wrote:
[...]
> +	/*
> +	 * The adv75xx resets its addresses to defaults during low power power
> +	 * mode. Because we have two ADV7513 devices on the same bus, we must
> +	 * change both of them away from the defaults so that they do not
> +	 * conflict.
> +	 */
>  	hdmi@3d {
>  		compatible = "adi,adv7513";
> -		reg = <0x3d>;
> +		reg = <0x3d 0x2d 0x4d, 0x5d>;

To have the correct semantics this should be:
		reg = <0x3d>, <0x2d>, <0x4d>, <0x5d>;

It is a set of 4 single cell addresses. The other thing is a single 4 cell
address. It will get compiled to the same bytes, but the DT tools should
complain about it, because it doesn't match #address-cells.

> +		reg-names = "main", "cec", "edid", "packet";
>  
>  		adi,input-depth = <8>;
>  		adi,input-colorspace = "rgb";
> @@ -272,7 +279,8 @@
>  
>  	hdmi@39 {
>  		compatible = "adi,adv7513";
> -		reg = <0x39>;
> +		reg = <0x39 0x29 0x49, 0x59>;

Same here.

> +		reg-names = "main", "cec", "edid", "packet";
>  
>  		adi,input-depth = <8>;
>  		adi,input-colorspace = "rgb";
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:34978 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbdBMSf2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 13:35:28 -0500
Received: by mail-ot0-f179.google.com with SMTP id 65so75114100otq.2
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 10:35:28 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 02/10] ARM: dts: da850-evm: fix whitespace errors
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
        <1486485683-11427-3-git-send-email-bgolaszewski@baylibre.com>
Date: Mon, 13 Feb 2017 10:35:25 -0800
In-Reply-To: <1486485683-11427-3-git-send-email-bgolaszewski@baylibre.com>
        (Bartosz Golaszewski's message of "Tue, 7 Feb 2017 17:41:15 +0100")
Message-ID: <m2zihqdjma.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bartosz Golaszewski <bgolaszewski@baylibre.com> writes:

> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

I'll fold this one into the original since it's not yet merged.

Kevin

> ---
>  arch/arm/boot/dts/da850-evm.dts | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
> index c970b6e..94938a3 100644
> --- a/arch/arm/boot/dts/da850-evm.dts
> +++ b/arch/arm/boot/dts/da850-evm.dts
> @@ -301,14 +301,14 @@
>  	/* VPIF capture port */
>  	port {
>  		vpif_ch0: endpoint@0 {
> -			  reg = <0>;
> -			  bus-width = <8>;
> +			reg = <0>;
> +			bus-width = <8>;
>  		};
>  
>  		vpif_ch1: endpoint@1 {
> -			  reg = <1>;
> -			  bus-width = <8>;
> -			  data-shift = <8>;
> +			reg = <1>;
> +			bus-width = <8>;
> +			data-shift = <8>;
>  		};
>  	};
>  };

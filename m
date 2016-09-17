Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36757 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755291AbcIQKZu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Sep 2016 06:25:50 -0400
Received: by mail-lf0-f54.google.com with SMTP id g62so77142802lfe.3
        for <linux-media@vger.kernel.org>; Sat, 17 Sep 2016 03:25:50 -0700 (PDT)
Subject: Re: [PATCH 1/2] ARM: dts: lager: Add entries for VIN HDMI input
 support
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>, horms@verge.net.au
References: <20160916130909.21225-1-ulrich.hecht+renesas@gmail.com>
 <20160916130909.21225-2-ulrich.hecht+renesas@gmail.com>
Cc: geert@linux-m68k.org, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        laurent.pinchart@ideasonboard.com, william.towle@codethink.co.uk,
        Rob Taylor <rob.taylor@codethink.co.uk>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <fa19d487-941b-9b00-c280-e4acabf29615@cogentembedded.com>
Date: Sat, 17 Sep 2016 13:25:47 +0300
MIME-Version: 1.0
In-Reply-To: <20160916130909.21225-2-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 9/16/2016 4:09 PM, Ulrich Hecht wrote:

> From: William Towle <william.towle@codethink.co.uk>
>
> Add DT entries for vin0, vin0_pins, and adv7612.
>
> Sets the 'default-input' property for ADV7612, enabling image and video
> capture without the need to have userspace specifying routing.
>
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> [uli: added interrupt, renamed endpoint, merged default-input]
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  arch/arm/boot/dts/r8a7790-lager.dts | 39 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>
> diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
> index 52b56fc..fc9d129 100644
> --- a/arch/arm/boot/dts/r8a7790-lager.dts
> +++ b/arch/arm/boot/dts/r8a7790-lager.dts
[...]
> @@ -722,6 +742,25 @@
>  	status = "okay";
>  };
>
> +/* HDMI video input */
> +&vin0 {
> +	pinctrl-0 = <&vin0_pins>;
> +	pinctrl-names = "default";
> +
> +	status = "ok";

    Should be "okay", although "ok" is also valid.

[...]

MBR, Sergei


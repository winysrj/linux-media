Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:49916 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbeJaCHK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 22:07:10 -0400
Subject: Re: [PATCH 1/7] dt-bindings: mfd: ds90ux9xx: add description of TI
 DS90Ux9xx ICs
To: Vladimir Zapolskiy <vz@mleia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Marek Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sandeep Jain <Sandeep_Jain@mentor.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
References: <20181008211205.2900-1-vz@mleia.com>
 <20181008211205.2900-2-vz@mleia.com>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <fd0a91c9-6e38-5a18-12e5-955fbf81bfce@lucaceresoli.net>
Date: Tue, 30 Oct 2018 17:43:41 +0100
MIME-Version: 1.0
In-Reply-To: <20181008211205.2900-2-vz@mleia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

On 08/10/18 23:11, Vladimir Zapolskiy wrote:
> From: Sandeep Jain <Sandeep_Jain@mentor.com>
> 
> The change adds device tree binding description of TI DS90Ux9xx
> series of serializer and deserializer controllers which support video,
> audio and control data transmission over FPD-III Link connection.
[...]
> +Example:
> +
> +serializer: serializer@c {
> +	compatible = "ti,ds90ub927q", "ti,ds90ux9xx";
> +	reg = <0xc>;
> +	power-gpios = <&gpio5 12 GPIO_ACTIVE_HIGH>;
> +	ti,backward-compatible-mode = <0>;
> +	ti,low-frequency-mode = <0>;
> +	ti,pixel-clock-edge = <0>;
> +	...
> +}
> +
> +deserializer: deserializer@3c {
> +	compatible = "ti,ds90ub940q", "ti,ds90ux9xx";
> +	reg = <0x3c>;
> +	power-gpios = <&gpio6 31 GPIO_ACTIVE_HIGH>;
> +	...
> +}

Interesting patchset, thanks. At the moment I'm working on a driver for
the TI FPD-III camera serdes chips [0]. At very first sight they have
many commonalities with the display chipsets [1] you implemented. Did
you have a look into them? Do you think they could be implemented by the
same driver?

The camera serdes chips lack some features found on the display chips
(e.g. audio, white balance). OTOH they have dual or quad input
deserializers, which adds complexity.

I'm commenting on the details in reply to the following patches
documenting the DT bindings.

[0] http://www.ti.com/interface/fpd-link-serdes/camera-serdes/overview.html
[1] http://www.ti.com/interface/fpd-link-serdes/display-serdes/overview.html

Bye,
-- 
Luca

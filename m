Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22300 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab3GQQj6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 12:39:58 -0400
Message-id: <51E6C8D8.4010303@samsung.com>
Date: Wed, 17 Jul 2013 18:39:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	devicetree-discuss@lists.ozlabs.org,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] media: i2c: tvp7002: add OF support
References: <1374078016-17122-1-git-send-email-prabhakar.csengg@gmail.com>
In-reply-to: <1374078016-17122-1-git-send-email-prabhakar.csengg@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2013 06:20 PM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> add OF support for the tvp7002 driver.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  This patch depends on https://patchwork.kernel.org/patch/2828800/
>  
>  Changes for v3:
>  1: Fixed review comments pointed by Sylwester.
>  
>  .../devicetree/bindings/media/i2c/tvp7002.txt      |   43 +++++++++++++
>  drivers/media/i2c/tvp7002.c                        |   67 ++++++++++++++++++--
>  2 files changed, 103 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp7002.txt b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
> new file mode 100644
> index 0000000..744125f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
> @@ -0,0 +1,43 @@
> +* Texas Instruments TV7002 video decoder
> +
> +The TVP7002 device supports digitizing of video and graphics signal in RGB and
> +YPbPr color space.
> +
> +Required Properties :
> +- compatible : Must be "ti,tvp7002"
> +
> +- hsync-active: HSYNC Polarity configuration for endpoint.
> +
> +- vsync-active: VSYNC Polarity configuration for endpoint.

I woudn't refer to "endpoint" here, perhaps to the specific hardware
bus instead ? So it is clear what part of the device it refers to ?

> +- pclk-sample: Clock polarity of the endpoint.

This description is not very useful, my feeling is that this property
is better described in video-interfaces.txt.

> +- sync-on-green-active: Active state of Sync-on-green signal property of the
> +  endpoint, 0/1 for normal/inverted operation respectively.
> +
> +- field-even-active: Active-high Field ID polarity of the endpoint.

I find it hard to understand what this property is about exactly.
Not sure if you need to repeat detailed description of the signal
polarity properties. Perhaps its sufficient to list which properties
are relevant for this device, but I'm not opposed to having
supplementary description here. I would just make it more specific
to the TVP7002 chip.
Also please note that only 'compatible' property is required, all
other are optional. And it probably makes sense to specify what are
default values for each property when it is not specified.

Otherwise the patch looks good.

--
Thanks,
Sylwester

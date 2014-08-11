Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64401 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175AbaHKMTc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 08:19:32 -0400
Date: Mon, 11 Aug 2014 13:19:02 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Ian Molton <ian.molton@codethink.co.uk>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"lars@metafoo.de" <lars@metafoo.de>,
	"shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
	"william-towle@codethink.co.uk" <william-towle@codethink.co.uk>
Subject: Re: [PATCH 2/2] media: adv7604: Add ability to read default input
 port from DT
Message-ID: <20140811121902.GA16295@leverpostej>
References: <1407758719-12474-1-git-send-email-ian.molton@codethink.co.uk>
 <1407758719-12474-3-git-send-email-ian.molton@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407758719-12474-3-git-send-email-ian.molton@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 11, 2014 at 01:05:19PM +0100, Ian Molton wrote:
> This patch adds support to the adv7604 driver for reading the default
> selected input from the Device tree. If none is provided, the driver will not
> select an input without help from userspace.
> 
> Tested-by: William Towle <william.towle@codethink.co.uk>
> Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
> ---
>  Documentation/devicetree/bindings/media/i2c/adv7604.txt | 5 ++++-
>  drivers/media/i2c/adv7604.c                             | 9 +++++++--
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> index cc0708c..6e8ace0 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> @@ -41,11 +41,12 @@ Optional Endpoint Properties:
>  
>    - hsync-active: Horizontal synchronization polarity. Defaults to active low.
>    - vsync-active: Vertical synchronization polarity. Defaults to active low.
> -  - pclk-sample: Pixel clock polarity. Defaults to output on the falling edge.
> +  - pclk-sample:  Pixel clock polarity. Defaults to output on the falling edge.

Unrelated whitespace change?

>  
>    If none of hsync-active, vsync-active and pclk-sample is specified the
>    endpoint will use embedded BT.656 synchronization.
>  
> +  - default-input: Select which input is selected after reset.

Valid values are?

>  
>  Example:
>  
> @@ -59,6 +60,8 @@ Example:
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  
> +		default-input = <0>;
> +
>  		port@0 {
>  			reg = <0>;
>  		};
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 9f73a7f..75e1942 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -2732,7 +2732,7 @@ static int adv7604_parse_dt(struct adv7604_state *state)
>  	struct v4l2_of_endpoint bus_cfg;
>  	struct device_node *endpoint;
>  	struct device_node *np;
> -	unsigned int flags;
> +	unsigned int flags, v;
>  
>  	np = state->i2c_clients[ADV7604_PAGE_IO]->dev.of_node;
>  
> @@ -2742,6 +2742,12 @@ static int adv7604_parse_dt(struct adv7604_state *state)
>  		return -EINVAL;
>  
>  	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
> +
> +	 if (!of_property_read_u32(endpoint, "default_input", &v))

This doesn't match the binding ('_' vs '-').

Thanks,
Mark.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40052 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbeJaHZd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 03:25:33 -0400
Date: Tue, 30 Oct 2018 17:30:10 -0500
From: Rob Herring <robh@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        mark.rutland@arm.com, enrico.scholz@sigma-chemnitz.de,
        akinobu.mita@gmail.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, graphics@pengutronix.de
Subject: Re: [PATCH v2 5/6] dt-bindings: media: mt9m111: adapt documentation
 to be more clear
Message-ID: <20181030223010.GA15860@bogus>
References: <20181029182410.18783-1-m.felsch@pengutronix.de>
 <20181029182410.18783-6-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181029182410.18783-6-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 29, 2018 at 07:24:09PM +0100, Marco Felsch wrote:
> Replace the vague binding by a more verbose. Remove the remote property
> from the example since the driver don't support such a property. Also
> remove the bus-width property from the endpoint since the driver don't
> take care of it.
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  .../devicetree/bindings/media/i2c/mt9m111.txt         | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
> index 6b910036b57e..921cc48c488b 100644
> --- a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
> @@ -9,8 +9,13 @@ Required Properties:
>  - clocks: reference to the master clock.
>  - clock-names: shall be "mclk".
>  
> -For further reading on port node refer to
> -Documentation/devicetree/bindings/media/video-interfaces.txt.
> +The device node must contain one 'port' child node with one 'endpoint' child
> +sub-node for its digital output video port, in accordance with the video
> +interface bindings defined in:
> +Documentation/devicetree/bindings/media/video-interfaces.txt
> +
> +Required endpoint properties:
> +- remote-endpoint: For information see ../video-interfaces.txt.

You don't need to explicitly document this.

Otherwise,

Reviewed-by: Rob Herring <robh@kernel.org>

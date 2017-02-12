Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33288 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751507AbdBLWRE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 17:17:04 -0500
Date: Mon, 13 Feb 2017 00:16:30 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thomas Axelsson <Thomas.Axelsson@cybercom.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Device Tree formatting for multiple virtual channels in
 ti-vpe/cal driver?
Message-ID: <20170212221629.GB16975@valkosipuli.retiisi.org.uk>
References: <DB5PR0701MB1909024C800EFCDE9AD9C4A588440@DB5PR0701MB1909.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB5PR0701MB1909024C800EFCDE9AD9C4A588440@DB5PR0701MB1909.eurprd07.prod.outlook.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On Fri, Feb 10, 2017 at 09:34:46AM +0000, Thomas Axelsson wrote:
> Hi,
> 
> I have a TI AM571x CPU, and I'm trying to add support for multiple MIPI
> CSI-2 virtual channels per PHY (port) to the ti-vpe/cal.c driver
> (CAMSS/CAL peripheral, ch. 8 in Datasheet [1]). This CPU can have more
> contexts (virtual channels) per PHY than what it has DMA handlers. Each
> PHY may have up to 8 contexts, and there are 2 PHYs, but there are only 8
> DMA channels in total. It is not required to use DMA to receive data from
> the context.

Is there a use case for receiving more than eight streams concurrently? I
have to admit that this does appear quite exotic if 8 would not suffice. How
does the data end up to the system memory if there's no DMA? PIO...?

What are the limitations otherwise --- how many PHYs can be used
simultaneously? Are the 8 DMAs shared among all?

>  
> Since it will be very useful to specify which contexts will use DMA and which will 
> not, the proper place to do this seems to be the device tree.
>  
> This becomes rather messy though, since it needs to be specified in the device tree 
> node pointed to by the remote-endpoint field - yet, it's decided by the capabilities 
> of the master component (in this case the CAL), so the remote-endpoint is a weird 
> place to put it.
>  
> I have made an example [2] using the Device Tree example in 
> Documentation/devicetree/bindings/media/ti-cal.txt (my own comments).
> In the ar0330_1 endpoint, I have:
> * Put multiple virtual channels in "reg", as in 
>   Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt,
> * Added "dma-write" for specifying which virtual channels should get written 
>   directly to memory through DMA,
> * Added "vip" just to show that a Virtual Channel can go somewhere else than 
>   through DMA write.
> * Added "pix-proc" to show that pixel processing might be applied to some of the 
>   Virtual Channels.
>  
> What is your advice on how to properly move forward with adding support like this?
> 
> Thank you in advance.
> 
> Best regards,
> Thomas Axelsson
>  
> 
> [1] http://www.ti.com/lit/gpn/am5716
>  
> [2]
> --------------------------------------------------
> cal: cal@4845b000 {
>     compatible = "ti,dra72-cal";
>     ti,hwmods = "cal";
>  
>     /* snip */
>  
>     ports {
>         #address-cells = <1>;
>         #size-cells = <0>;
>         csi2_0: port@0 {
>             reg = <0>;                         /* PHY index, must match port index */
>             status = "okay";                   /* Enable */
>             endpoint {
>                 slave-mode;
>                 remote-endpoint = <&ar0330_1>;
>             };
>         };
>         csi2_1: port@1 {
>             reg = <1>;                         /* PHY Index */
>         };
>     };
> };
>  
> i2c5: i2c@4807c000 {
>     ar0330@10 {
>         compatible = "ti,ar0330";
>         reg = <0x10>;
>         port {
>             #address-cells = <1>;
>             #size-cells = <0>;
>             ar0330_1: endpoint {
>                 reg = <0 1 2>;                 /* Virtual Channels */
>                 dma-write = <0 2>;             /* Virtual Channels that will use 
>                                                   Write DMA */
>                 vip = <1>;                     /* Virtual Channel to send on to 
>                                                   Video Input Port */
>                 pix-proc = <2>;                /* Virtual channels to apply pixel
>                                                   processing on */
>                 clock-lanes = <1>;             /* Clock lane indices */
>                 data-lanes = <0 2 3 4>;        /* Data lane indices */
>                 remote-endpoint = <&csi2_0>;
>             };
>         };
>     };
> };

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:35043 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932480AbdBVOZS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 09:25:18 -0500
Date: Wed, 22 Feb 2017 08:25:15 -0600
From: Rob Herring <robh@kernel.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
Subject: Re: [PATCH RESEND 1/1] media: platform: Renesas IMR driver
Message-ID: <20170222142515.i54xtgyvxysd2qsr@rob-hp-laptop>
References: <20170211200207.273799464@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170211200207.273799464@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 11, 2017 at 11:02:01PM +0300, Sergei Shtylyov wrote:
> From: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
> 
> The image renderer light extended 4 (IMR-LX4) or the distortion correction
> engine is a drawing processor with a simple  instruction system capable of
> referencing data on an external memory as 2D texture data and performing
> texture mapping and drawing with respect to any shape that is split into
> triangular objects.
> 
> This V4L2 memory-to-memory device driver only supports image renderer found
> in the R-Car gen3 SoCs; the R-Car gen2 support  can be added later...
> 
> [Sergei: merged 2 original patches, added the patch description, removed
> unrelated parts,  added the binding document, ported the driver to the
> modern kernel, renamed the UAPI header file and the guard  macros to match
> the driver name, extended the copyrights, fixed up Kconfig prompt/depends/
> help, made use of the BIT()/GENMASK() macros, sorted #include's, removed
> leading  dots and fixed grammar in the comments, fixed up indentation to
> use tabs where possible, renamed IMR_DLSR to IMR_DLPR to match the manual,
> separated the register offset/bit #define's, removed *inline* from .c file,
> fixed lines over 80 columns, removed useless parens, operators, casts,
> braces, variables, #include's, (commented out) statements, and even
> function, inserted empty line after desclaration, removed extra empty
> lines, reordered some local variable desclarations, removed calls to
> 4l2_err() on kmalloc() failure, fixed the error returned by imr_default(),
> avoided code duplication in the IRQ handler, used '__packed' for the UAPI
> structures, enclosed the macro parameters in parens, exchanged the values
> of IMR_MAP_AUTO[SD]G macros.]
> 
> Signed-off-by: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo's 'master' branch.
> 
>  Documentation/devicetree/bindings/media/rcar_imr.txt |   23 
>  drivers/media/platform/Kconfig                       |   13 
>  drivers/media/platform/Makefile                      |    1 
>  drivers/media/platform/rcar_imr.c                    | 1923 +++++++++++++++++++
>  include/uapi/linux/rcar_imr.h                        |   94 
>  5 files changed, 2054 insertions(+)
> 
> Index: media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
> ===================================================================
> --- /dev/null
> +++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
> @@ -0,0 +1,23 @@
> +Renesas R-Car Image Renderer (Distortion Correction Engine)
> +-----------------------------------------------------------
> +
> +The image renderer  or the distortion correction  engine is a drawing processor
> +with a simple  instruction system capable of referencing data in external memory
> +as  2D texture data and performing texture mapping and drawing with respect to
> +any shape that is split into triangular objects.

Please fix extra spaces in here.

> +
> +Required properties:
> +- compatible: must be "renesas,imr-lx4" for the image renderer light extended 4
> +  (IMR-LX4)  found in the R-Car gen3 SoCs;

Needs an SoC specific compatible string too.

The description is above, so you just need to list the compatible 
strings.

> +- reg: offset and length of the register block;
> +- interrupts: interrupt specifier;

How many interrupts?

> +- clocks: clock phandle and specifier pair.

How many clocks?

> +
> +Example:
> +
> +	imr-lx4@fe860000 {
> +		compatible = "renesas,imr-lx4";
> +		reg = <0 0xfe860000 0 0x2000>;
> +		interrupts = <GIC_SPI 192 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cpg CPG_MOD 823>;
> +	};

Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40332 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbdBLPuk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 10:50:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH RESEND 1/1] media: platform: Renesas IMR driver
Date: Sun, 12 Feb 2017 17:51:03 +0200
Message-ID: <1770632.4GFlW6r2cg@avalon>
In-Reply-To: <20170211200207.273799464@cogentembedded.com>
References: <20170211200207.273799464@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

(CC'ing the dri-evel mailing list)

Thank you for the patch.

On Saturday 11 Feb 2017 23:02:01 Sergei Shtylyov wrote:
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

Let's start with the main question : given that this is a rendering engine, it 
looks like it should use the DRM subsystem.

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
> Signed-off-by: Konstantin Kozhevnikov
> <Konstantin.Kozhevnikov@cogentembedded.com> Signed-off-by: Sergei Shtylyov
> <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo's 'master' branch.
> 
>  Documentation/devicetree/bindings/media/rcar_imr.txt |   23
>  drivers/media/platform/Kconfig                       |   13
>  drivers/media/platform/Makefile                      |    1
>  drivers/media/platform/rcar_imr.c                    | 1923 +++++++++++++++
>  include/uapi/linux/rcar_imr.h                        |   94
>  5 files changed, 2054 insertions(+)

-- 
Regards,

Laurent Pinchart

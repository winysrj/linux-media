Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34645 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752657AbdCPVS6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Mar 2017 17:18:58 -0400
Date: Thu, 16 Mar 2017 16:18:54 -0500
From: Rob Herring <robh@kernel.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
Subject: Re: [PATCH v5] media: platform: Renesas IMR driver
Message-ID: <20170316211854.i3mb7nmyqgfvezaw@rob-hp-laptop>
References: <20170309200818.786255823@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170309200818.786255823@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 09, 2017 at 11:08:03PM +0300, Sergei Shtylyov wrote:
> From: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
> 
> The image renderer, or the distortion correction engine, is a drawing
> processor with a simple instruction system capable of referencing video
> capture data or data in an external memory as the 2D texture data and
> performing texture mapping and drawing with respect to any shape that is
> split into triangular objects.
> 
> This V4L2 memory-to-memory device driver only supports image renderer light
> extended 4 (IMR-LX4) found in the R-Car gen3 SoCs; the R-Car gen2 support
> can be added later...
> 
> [Sergei: merged 2 original patches, added the patch description, removed
> unrelated parts,  added the binding document, ported the driver to the
> modern kernel, renamed the UAPI header file and the  guard macros to match
> the driver name, extended the copyrights, fixed up Kconfig prompt/depends/
> help, made use of the BIT/GENMASK() macros, sorted #include's, removed
> leading  dots and fixed grammar in the comments, fixed up indentation to
> use tabs where possible, renamed DLSR, CMRCR.DY1{0|2}, and ICR bits to
> match the manual, changed the prefixes of the CMRCR[2]/TRI{M|C}R bits/
> fields to match the manual, removed non-existent TRIMR.D{Y|U}D{X|V}M bits,
> added/used the IMR/{UV|CP}DPOR/SUSR bits/fields/shifts, separated the
> register offset/bit #define's, sorted the instruction macros by opcode,
> removed unsupported LINE instruction, masked the register address in
> WTL[2]/WTS instruction macros, moved the display list #define's after
> the register #define's, removing the redundant comment, avoided setting
> reserved bits when writing CMRCCR[2]/TRIMCR, used the SR bits instead of
> a bare number, used ALIGN() macro in imr_ioctl_map(), removed *inline*
> from .c file, fixed lines over 80 columns, removed useless spaces,
> comments, parens, operators, casts, braces, variables, #include's,
> statements, and even 1 function, uppercased the abbreviations, made
> comment wording more consistent/correct, fixed the comment typos,
> reformatted some multiline comments, inserted empty line after declaration,
> removed extra empty lines, reordered some local variable desclarations,
> removed calls to 4l2_err() on kmalloc() failure, replaced '*' with 'x'
> in some format strings for v4l2_dbg(), fixed the error returned by
> imr_default(), avoided code duplication in the IRQ handler, used
> '__packed' for the UAPI structures, enclosed the macro parameters in
> parens, exchanged the values of IMR_MAP_AUTO{S|D}G macros.]
> 
> Signed-off-by: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo's 'master' branch.
> 
> Changes in version 5:
> - used ALIGN() macro in imr_ioctl_map();
> - moved the display list #define's after the register #define's, removing the
>   redundant comment;
> - uppercased the "tbd" abbreviation in the comments;
> - made the TRI instruction types A/B/C named consistently;
> - avoided quotes around the coordinate's names;
> - avoided some  hyphens in the comments;
> - removed spaces around / and before ? in the comments;
> - reworded some comments;
> - reformatted some multiline comments;
> - fixed typos in the comments.
> 
> Changes in version 4:
> - added/used the SUSR fields/shifts.
> 
> Changes in version 3:
> - added/used the {UV|CP}DPOR fields/shifts;
> - removed unsupported LINE instruction;
> - replaced '*' with 'x' in the string passed to v4l2_dbg() in
>   imr_dl_program_setup();
> - switched to prepending the SoC model to "imr-lx4" in the "compatible" prop
>   strings.
> 
> Changes in version 2:
> - renamed the ICR bits to match the manual;
> - added/used  the IMR bits;
> - changed the prefixes of the CMRCR[2]/TRI{M|C}R bits/fields to match the
>   manual;
> - renamed the CMRCR.DY1{0|2} bits to match the manual;
> - removed non-existent TRIMR.D{Y|U}D{X|V}M bits;
> - used the SR bits instead of a bare number;
> - sorted the instruction macros by opcode, removing redundant parens;
> - masked the register address in WTL[2]/WTS instruction macros;
> - avoided setting reserved bits when writing to CMRCCR[2]/TRIMCR;
> - mentioned the video capture data as a texture source in the binding and the
>   patch description;
> - documented the SoC specific "compatible" values;
> - clarified the "interrupts" and "clocks" property text;
> - updated the patch description.
> 
>  Documentation/devicetree/bindings/media/rcar_imr.txt |   27 

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/media/platform/Kconfig                       |   13 
>  drivers/media/platform/Makefile                      |    1 
>  drivers/media/platform/rcar_imr.c                    | 1943 +++++++++++++++++++
>  include/uapi/linux/rcar_imr.h                        |   94 
>  5 files changed, 2078 insertions(+)

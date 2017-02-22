Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:34715 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754954AbdBVTOH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 14:14:07 -0500
Received: by mail-lf0-f43.google.com with SMTP id g134so6345103lfe.1
        for <linux-media@vger.kernel.org>; Wed, 22 Feb 2017 11:14:06 -0800 (PST)
Subject: Re: [PATCH RESEND 1/1] media: platform: Renesas IMR driver
To: Rob Herring <robh@kernel.org>
References: <20170211200207.273799464@cogentembedded.com>
 <20170222142515.i54xtgyvxysd2qsr@rob-hp-laptop>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <cccaf6f7-0ff3-539c-5b60-e28858018b97@cogentembedded.com>
Date: Wed, 22 Feb 2017 22:05:21 +0300
MIME-Version: 1.0
In-Reply-To: <20170222142515.i54xtgyvxysd2qsr@rob-hp-laptop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 02/22/2017 05:25 PM, Rob Herring wrote:

>> From: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
>>
>> The image renderer light extended 4 (IMR-LX4) or the distortion correction
>> engine is a drawing processor with a simple  instruction system capable of
>> referencing data on an external memory as 2D texture data and performing
>> texture mapping and drawing with respect to any shape that is split into
>> triangular objects.
>>
>> This V4L2 memory-to-memory device driver only supports image renderer found
>> in the R-Car gen3 SoCs; the R-Car gen2 support  can be added later...
>>
>> [Sergei: merged 2 original patches, added the patch description, removed
>> unrelated parts,  added the binding document, ported the driver to the
>> modern kernel, renamed the UAPI header file and the guard  macros to match
>> the driver name, extended the copyrights, fixed up Kconfig prompt/depends/
>> help, made use of the BIT()/GENMASK() macros, sorted #include's, removed
>> leading  dots and fixed grammar in the comments, fixed up indentation to
>> use tabs where possible, renamed IMR_DLSR to IMR_DLPR to match the manual,
>> separated the register offset/bit #define's, removed *inline* from .c file,
>> fixed lines over 80 columns, removed useless parens, operators, casts,
>> braces, variables, #include's, (commented out) statements, and even
>> function, inserted empty line after desclaration, removed extra empty
>> lines, reordered some local variable desclarations, removed calls to
>> 4l2_err() on kmalloc() failure, fixed the error returned by imr_default(),
>> avoided code duplication in the IRQ handler, used '__packed' for the UAPI
>> structures, enclosed the macro parameters in parens, exchanged the values
>> of IMR_MAP_AUTO[SD]G macros.]
>>
>> Signed-off-by: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>
>> ---
>> This patch is against the 'media_tree.git' repo's 'master' branch.
>>
>>  Documentation/devicetree/bindings/media/rcar_imr.txt |   23
>>  drivers/media/platform/Kconfig                       |   13
>>  drivers/media/platform/Makefile                      |    1
>>  drivers/media/platform/rcar_imr.c                    | 1923 +++++++++++++++++++
>>  include/uapi/linux/rcar_imr.h                        |   94
>>  5 files changed, 2054 insertions(+)
>>
>> Index: media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
>> ===================================================================
>> --- /dev/null
>> +++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
>> @@ -0,0 +1,23 @@
>> +Renesas R-Car Image Renderer (Distortion Correction Engine)
>> +-----------------------------------------------------------
>> +
>> +The image renderer  or the distortion correction  engine is a drawing processor
>> +with a simple  instruction system capable of referencing data in external memory
>> +as  2D texture data and performing texture mapping and drawing with respect to
>> +any shape that is split into triangular objects.
>
> Please fix extra spaces in here.

    OK. Seems to be your pet peeve? :-)

>> +
>> +Required properties:
>> +- compatible: must be "renesas,imr-lx4" for the image renderer light extended 4
>> +  (IMR-LX4)  found in the R-Car gen3 SoCs;
>
> Needs an SoC specific compatible string too.

    Strings, to be precise -- there are several SoCs but the IMR-LX4 core 
seems the same among them. Well, if you say so...

> The description is above, so you just need to list the compatible
> strings.

    There's (most probably) gonna be other versions of the IMR core supported, 
(this core can be forund in gen2 SoCs too)...

>> +- reg: offset and length of the register block;
>> +- interrupts: interrupt specifier;
>
> How many interrupts?

    I thought it was clear from using singular.

>> +- clocks: clock phandle and specifier pair.
>
> How many clocks?

    Two, perhaps. I meant a single clock by using singular again.

[...]

MBR, Sergei

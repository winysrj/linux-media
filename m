Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35010 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbeAEI46 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Jan 2018 03:56:58 -0500
MIME-Version: 1.0
In-Reply-To: <14433032.8RBNSVMmkm@avalon>
References: <1515081797-17174-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515081797-17174-2-git-send-email-jacopo+renesas@jmondi.org> <14433032.8RBNSVMmkm@avalon>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 5 Jan 2018 09:56:56 +0100
Message-ID: <CAMuHMdU=CCsn21pkzmKN=9yFn4f2H6QAKSJ5DWCzRBT-F=U=dA@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] dt-bindings: media: Add Renesas CEU bindings
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Fabio Estevam <festevam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 4, 2018 at 11:28 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Thursday, 4 January 2018 18:03:09 EET Jacopo Mondi wrote:
>> Add bindings documentation for Renesas Capture Engine Unit (CEU).

>> +++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
>> @@ -0,0 +1,85 @@
>> +Renesas Capture Engine Unit (CEU)
>> +----------------------------------------------
>> +
>> +The Capture Engine Unit is the image capture interface found in the Renesas
>> +SH Mobile and RZ SoCs.
>> +
>> +The interface supports a single parallel input with data bus width of 8 or
>> 16
>> +bits.
>> +
>> +Required properties:
>> +- compatible: Must be one of the following.
>> +     - "renesas,r7s72100-ceu" for CEU units found in R7S72100 (RZ/A1) SoCs.
>> +     - "renesas,ceu" as a generic fallback.
>
> As asked in my review of patch 3/9, what's your policy for compatible strings
> ? As far as I understand there's no generic CEU, as the SH4 and RZ versions
> are not compatible. Should the "renesas,ceu" compatible string then be
> replaced by "renesas,rz-ceu" ?

If they're not compatible, it indeed doesn't make much sense to have a
generic "renesas,ceu".

Note that anything with "rz-" is a bad idea, as after RZ/A1, Renesas introduced
RZ/G1, RZ/N1, and RZ/T1, which are completely different (yes I know
we have a few of these in use, unfortunately).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

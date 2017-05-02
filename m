Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46423 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750973AbdEBVPr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 17:15:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
Subject: Re: [PATCH v5] media: platform: Renesas IMR driver
Date: Wed, 03 May 2017 00:17:03 +0300
Message-ID: <2382097.9ZIG3XAO0j@avalon>
In-Reply-To: <CAMuHMdV5-aMx4KuqShm47XtORJK8rMKzw6FUs2Hjsxia+jPfxg@mail.gmail.com>
References: <20170309200818.786255823@cogentembedded.com> <CAMuHMdV5-aMx4KuqShm47XtORJK8rMKzw6FUs2Hjsxia+jPfxg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Wednesday 22 Mar 2017 10:34:16 Geert Uytterhoeven wrote:
> On Thu, Mar 9, 2017 at 9:08 PM, Sergei Shtylyov wrote:
> > --- /dev/null
> > +++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
> > @@ -0,0 +1,27 @@
> > +Renesas R-Car Image Renderer (Distortion Correction Engine)
> > +-----------------------------------------------------------
> > +
> > +The image renderer, or the distortion correction engine, is a drawing
> > processor
> > +with a simple instruction system capable of referencing video capture
> > data or
> > +data in an external memory as 2D texture data and performing texture
> > mapping
> > +and drawing with respect to any shape that is split into triangular
> > objects.
> > +
> > +Required properties:
> > +
> > +- compatible: "renesas,<soctype>-imr-lx4", "renesas,imr-lx4" as a
> > fallback for
> > +  the image renderer light extended 4 (IMR-LX4) found in the R-Car gen3
> > SoCs,
> > +  where the examples with <soctype> are:
> > +  - "renesas,r8a7795-imr-lx4" for R-Car H3,
> > +  - "renesas,r8a7796-imr-lx4" for R-Car M3-W.
> 
> Laurent: what do you think about the need for SoC-specific compatible
> values for the various IM* blocks?

There's no documented IP core version register, but when dumping all 
configuration registers on H3 and M3-W I noticed that register 0x002c, not 
documented in the datasheet, reads 0x14060514 on all four IMR instances in H3, 
and 0x20150505 on both instances in M3-W.

This looks like a version register to me. If my assumption is correct, we 
could do without any SoC-specific compatible string.

-- 
Regards,

Laurent Pinchart

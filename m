Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52991 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938698AbcJXJqt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 05:46:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/4] dt-bindings: Add Renesas R-Car FDP1 bindings
Date: Mon, 24 Oct 2016 12:46:46 +0300
Message-ID: <1923730.zaykC4sXJR@avalon>
In-Reply-To: <CAMuHMdUGy0+bv-t=8HXeQf0BpoMJMNP85cd2tubQzD4Zj8X9Gw@mail.gmail.com>
References: <1477299818-31935-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1477299818-31935-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAMuHMdUGy0+bv-t=8HXeQf0BpoMJMNP85cd2tubQzD4Zj8X9Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Monday 24 Oct 2016 11:14:11 Geert Uytterhoeven wrote:
> On Mon, Oct 24, 2016 at 11:03 AM, Laurent Pinchart wrote:
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,fdp1.txt
> > @@ -0,0 +1,33 @@
> > +Renesas R-Car Fine Display Processor (FDP1)
> > +-------------------------------------------
> > +
> > +The FDP1 is a de-interlacing module which converts interlaced video to
> > +progressive video. It is capable of performing pixel format conversion
> > between +YCbCr/YUV formats and RGB formats. Only YCbCr/YUV formats are
> > supported as +an input to the module.
> > +
> > + - compatible: Must be the following
> > +
> > +   - "renesas,fdp1" for generic compatible
> > +
> > + - reg: the register base and size for the device registers
> > + - interrupts : interrupt specifier for the FDP1 instance
> > + - clocks: reference to the functional clock
> > + - renesas,fcp: reference to the FCPF connected to the FDP1
> > +
> > +Optional properties:
> > + - power-domains : power-domain property defined with a power domain
> > specifier
>                       "power domain"?
> 
> > +                            to respective power domain.
> 
> Still, too many power domains in one sentence?

How about

 - power-domains : reference to the power domain that the FDP1 belongs to, if
   any.

-- 
Regards,

Laurent Pinchart


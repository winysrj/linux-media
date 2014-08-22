Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:53940 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbaHVOU4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 10:20:56 -0400
Received: by mail-la0-f49.google.com with SMTP id hz20so9806174lab.8
        for <linux-media@vger.kernel.org>; Fri, 22 Aug 2014 07:20:55 -0700 (PDT)
Date: Fri, 22 Aug 2014 18:20:53 +0400
From: Mikhail Ulianov <mikhail.ulyanov@cogentembedded.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: m.chehab@samsung.com, horms@verge.net.au, magnus.damm@gmail.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	linux-sh@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 6/6] devicetree: bindings: Document Renesas JPEG
 Processing Unit.
Message-ID: <20140822182053.62667c32@bones>
In-Reply-To: <3694359.xqEjcGBlOG@avalon>
References: <1408452653-14067-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
	<1408452653-14067-7-git-send-email-mikhail.ulyanov@cogentembedded.com>
	<3694359.xqEjcGBlOG@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your comments.

On Thu, 21 Aug 2014 01:01:43 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> Hi Mikhail,
> 
> Thank you for the patch.
> 
> On Tuesday 19 August 2014 16:50:53 Mikhail Ulyanov wrote:  
> > Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> > ---
> >  .../devicetree/bindings/media/renesas,jpu.txt      | 23
> > +++++++++++++++++++ 1 file changed, 23 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/media/renesas,jpu.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/renesas,jpu.txt
> > b/Documentation/devicetree/bindings/media/renesas,jpu.txt new file
> > mode 100644
> > index 0000000..44b07df
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,jpu.txt
> > @@ -0,0 +1,23 @@
> > +* Renesas VSP1 Video Processing Engine  
> 
> Copy & paste ? :-)
>   
Yeah. Will fix it.

> > +
> > +The JPEG processing unit (JPU) incorporates the JPEG codec with an
> > encoding +and decoding function conforming to the JPEG baseline
> > process, so that the JPU
> > +can encode image data and decode JPEG data quickly.
> > +It can be found in the Renesas R-Car first and second generation
> > SoCs.  
> 
> Is there a difference between the first and second generation JPUs ?
>   
There should be no difference because in practice maximum supported
resolution for Gen2 is 4096x4096 (not 8000x8000 as in overview section
of documentation). And in Gen1 documentation(overview section) maximum
supported resolution is also 4096x4096. 


> > +
> > +Required properties:
> > +  - compatible: should containg one of the following:
> > +			- "renesas,jpu-r8a7790" for R-Car H2
> > +			- "renesas,jpu-r8a7791" for R-Car M2  
> 
> How about adding a "renesas,jpu" generic compatible, and listing both
> the SoC- specific and the generic values (in that order) in the
> compatible property ?
>   
Could be a good idea, but there is no JPU in some R-Car Gen1 SoCs
e.g. E1. Plus we don't have full documentation on JPU in Gen1 SoCs.
So for now Gen1 is not supported. Or this doesn't matter in that case?


> > +  - reg: Base address and length of the registers block for the
> > JPU.
> > +  - interrupts: JPU interrupt specifier.
> > +  - clocks: A phandle + clock-specifier pair for the JPU
> > functional clock. +
> > +Example: R8A7790 (R-Car H2) JPU node
> > +	jpeg-codec@fe980000 {
> > +		compatible = "renesas,jpu-r8a7790";
> > +		reg = <0 0xfe980000 0 0x10300>;
> > +		interrupts = <0 272 IRQ_TYPE_LEVEL_HIGH>;
> > +		clocks = <&mstp1_clks R8A7790_CLK_JPU>;
> > +	};  
>   

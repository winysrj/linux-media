Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36954 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbcDYN06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 09:26:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 01/13] dt-bindings: Add Renesas R-Car FCP DT bindings
Date: Mon, 25 Apr 2016 16:27:19 +0300
Message-ID: <2291064.PDKHfW7Am5@avalon>
In-Reply-To: <CAMuHMdVaoD7gU0_WvSN0mFSCRyeWntZ1PHtkZ5ccFzCS-H-HUg@mail.gmail.com>
References: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1461455400-28767-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAMuHMdVaoD7gU0_WvSN0mFSCRyeWntZ1PHtkZ5ccFzCS-H-HUg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thank you for the review.

On Monday 25 Apr 2016 09:32:04 Geert Uytterhoeven wrote:
> On Sun, Apr 24, 2016 at 1:49 AM, Laurent Pinchart wrote:
> > The FCP is a companion module of video processing modules in the Renesas
> > R-Car Gen3 SoCs. It provides data compression and decompression, data
> > caching, and conversion of AXI transaction in order to reduce the memory
> 
> transactions
> 
> > bandwidth.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  .../devicetree/bindings/media/renesas,fcp.txt      | 31 +++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >  create mode 100644
> >  Documentation/devicetree/bindings/media/renesas,fcp.txt
> > 
> > Cc: devicetree@vger.kernel.org
> > 
> > diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt
> > b/Documentation/devicetree/bindings/media/renesas,fcp.txt new file mode
> > 100644
> > index 000000000000..46beec97d625
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
> > @@ -0,0 +1,31 @@
> > +Renesas R-Car Frame Compression Processor (FCP)
> > +-----------------------------------------------
> > +
> > +The FCP is a companion module of video processing modules in the Renesas
> > R-Car +Gen3 SoCs. It provides data compression and decompression, data
> > caching, and +conversion of AXI transaction in order to reduce the memory
> > bandwidth.
>
> transactions

I'll fix the typos.
 
> > +There are three types of FCP whose configuration and behaviour highly
> > depend +on the module they are paired with.
> 
> + - compatible: Must be one or more of the following
> +
> +   - "renesas,r8a7795-fcpv" for R8A7795 (R-Car H3) compatible 'FCP for VSP'
> +   - "renesas,fcpv" for generic compatible 'FCP for VSP'
> 
> As you list only one compatible value, I guess the type is determined
> automatically at run-time?

No, it's just that the bindings only support the FCPV at the moment, the other 
two variants are not supported yet.

-- 
Regards,

Laurent Pinchart


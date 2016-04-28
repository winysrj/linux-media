Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39683 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbcD1Gfq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 02:35:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rob Herring <robh@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v2 01/13] dt-bindings: Add Renesas R-Car FCP DT bindings
Date: Thu, 28 Apr 2016 09:36:08 +0300
Message-ID: <7242073.I0M81bb6ct@avalon>
In-Reply-To: <20160428025429.GA11679@rob-hp-laptop>
References: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1461620198-13428-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20160428025429.GA11679@rob-hp-laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Wednesday 27 Apr 2016 21:54:29 Rob Herring wrote:
> On Tue, Apr 26, 2016 at 12:36:26AM +0300, Laurent Pinchart wrote:
> > The FCP is a companion module of video processing modules in the Renesas
> > R-Car Gen3 SoCs. It provides data compression and decompression, data
> > caching, and conversion of AXI transactions in order to reduce the
> > memory bandwidth.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  .../devicetree/bindings/media/renesas,fcp.txt      | 31
> >  ++++++++++++++++++++++ 1 file changed, 31 insertions(+)
> >  create mode 100644
> >  Documentation/devicetree/bindings/media/renesas,fcp.txt
> > 
> > Cc: devicetree@vger.kernel.org
> > 
> > diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt
> > b/Documentation/devicetree/bindings/media/renesas,fcp.txt new file mode
> > 100644
> > index 000000000000..0c72ca24379f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
> > @@ -0,0 +1,31 @@
> > +Renesas R-Car Frame Compression Processor (FCP)
> > +-----------------------------------------------
> > +
> > +The FCP is a companion module of video processing modules in the Renesas
> > R-Car +Gen3 SoCs. It provides data compression and decompression, data
> > caching, and +conversion of AXI transactions in order to reduce the
> > memory bandwidth. +
> > +There are three types of FCP whose configuration and behaviour highly
> > depend +on the module they are paired with.
> 
> 3 types?, but I only see one compatible and no relationship with said
> module described.

The bindings currently support a single type, as that's all the driver 
currently supports and I'm not comfortable merging bindings without at least 
one test implementation. Should I clarify that with something as "These DT 
bindings currently support the "FCP for Video" type only" ?

-- 
Regards,

Laurent Pinchart


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32951 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbcEYRgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 13:36:16 -0400
Date: Wed, 25 May 2016 12:36:14 -0500
From: Rob Herring <robh@kernel.org>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 2/7] media: s5p-mfc: use generic reserved memory
 bindings
Message-ID: <20160525173614.GA8309@rob-hp-laptop>
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-3-git-send-email-m.szyprowski@samsung.com>
 <a14c4f45-64c9-f72d-532b-ad1ff53fa9eb@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a14c4f45-64c9-f72d-532b-ad1ff53fa9eb@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 25, 2016 at 11:18:59AM -0400, Javier Martinez Canillas wrote:
> Hello Marek,
> 
> On 05/24/2016 09:31 AM, Marek Szyprowski wrote:
> > Use generic reserved memory bindings and mark old, custom properties
> > as obsoleted.
> > 
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  .../devicetree/bindings/media/s5p-mfc.txt          | 39 +++++++++++++++++-----
> >  1 file changed, 31 insertions(+), 8 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
> > index 2d5787e..92c94f5 100644
> > --- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
> > +++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
> > @@ -21,15 +21,18 @@ Required properties:
> >    - clock-names : from common clock binding: must contain "mfc",
> >  		  corresponding to entry in the clocks property.
> >  
> > -  - samsung,mfc-r : Base address of the first memory bank used by MFC
> > -		    for DMA contiguous memory allocation and its size.
> > -
> > -  - samsung,mfc-l : Base address of the second memory bank used by MFC
> > -		    for DMA contiguous memory allocation and its size.
> > -
> >  Optional properties:
> >    - power-domains : power-domain property defined with a phandle
> >  			   to respective power domain.
> > +  - memory-region : from reserved memory binding: phandles to two reserved
> > +	memory regions, first is for "left" mfc memory bus interfaces,
> > +	second if for the "right" mfc memory bus, used when no SYSMMU
> > +	support is available
> > +
> > +Obsolete properties:
> > +  - samsung,mfc-r, samsung,mfc-l : support removed, please use memory-region
> > +	property instead
> > +
> > 
> 
> I wonder if we should maintain backward compatibility for this driver
> since s5p-mfc memory allocation won't work with an old FDT if support
> for the old properties are removed.

Well, minimally the commit log should indicate that compatibility is 
being broken.

Rob

Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([213.240.235.226]:33755 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab2F0NzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 09:55:24 -0400
Message-ID: <1340804521.3675.6.camel@iivanov-desktop>
Subject: Re: [PATCH] omap3isp: preview: Add support for non-GRBG Bayer
 patterns
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	Jean-Philippe Francois <jp.francois@cynove.com>
Date: Wed, 27 Jun 2012 16:42:01 +0300
In-Reply-To: <2750049.lYuKrB1hfJ@avalon>
References: <1340029853-2648-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <20120623082237.GA17925@valkosipuli.retiisi.org.uk>
	 <2750049.lYuKrB1hfJ@avalon>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi, 

On Tue, 2012-06-26 at 03:30 +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Saturday 23 June 2012 11:22:37 Sakari Ailus wrote:
> > On Mon, Jun 18, 2012 at 04:30:53PM +0200, Laurent Pinchart wrote:
> > > Rearrange the CFA interpolation coefficients table based on the Bayer
> > > pattern. Modifying the table during streaming isn't supported anymore,
> > > but didn't make sense in the first place anyway.
> > 
> > Why not? I could imagine someone might want to change the table while
> > streaming to change the white balance, for example. Gamma tables or the SRGB
> > matrix can be used to do mostly the same but we should leave the decision
> > which one to use to the user space.
> 
> Because making the CFA table runtime-configurable brings an additional 
> complexity without a use case I'm aware of. The preview engine has separate 
> gamma tables, white balance matrices, and RGB-to-RGB and RGB-to-YUV matrices 
> that can be modified during streaming. If a user really needs to modify the 
> CFA tables during streaming I'll be happy to implement that (and even happier 
> to receive a patch :-)), but I'm a bit reluctant to add complexity to an 
> already complex code without a real use case.
> 

Sorry for not following this thread very closely. One use case for 
changing CFA table is to adjust sharpness of the frames coming out
of the ISP. And we are doing exactly this in N9.

Regards,
Ivan.



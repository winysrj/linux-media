Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49618 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2F0NyN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 09:54:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	Jean-Philippe Francois <jp.francois@cynove.com>
Subject: Re: [PATCH] omap3isp: preview: Add support for non-GRBG Bayer patterns
Date: Wed, 27 Jun 2012 15:54:16 +0200
Message-ID: <2983598.xxGvaJclHQ@avalon>
In-Reply-To: <1340804521.3675.6.camel@iivanov-desktop>
References: <1340029853-2648-1-git-send-email-laurent.pinchart@ideasonboard.com> <2750049.lYuKrB1hfJ@avalon> <1340804521.3675.6.camel@iivanov-desktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ivan,

On Wednesday 27 June 2012 16:42:01 Ivan T. Ivanov wrote:
> On Tue, 2012-06-26 at 03:30 +0200, Laurent Pinchart wrote:
> > On Saturday 23 June 2012 11:22:37 Sakari Ailus wrote:
> > > On Mon, Jun 18, 2012 at 04:30:53PM +0200, Laurent Pinchart wrote:
> > > > Rearrange the CFA interpolation coefficients table based on the Bayer
> > > > pattern. Modifying the table during streaming isn't supported anymore,
> > > > but didn't make sense in the first place anyway.
> > > 
> > > Why not? I could imagine someone might want to change the table while
> > > streaming to change the white balance, for example. Gamma tables or the
> > > SRGB matrix can be used to do mostly the same but we should leave the
> > > decision which one to use to the user space.
> > 
> > Because making the CFA table runtime-configurable brings an additional
> > complexity without a use case I'm aware of. The preview engine has
> > separate
> > gamma tables, white balance matrices, and RGB-to-RGB and RGB-to-YUV
> > matrices that can be modified during streaming. If a user really needs to
> > modify the CFA tables during streaming I'll be happy to implement that
> > (and even happier to receive a patch :-)), but I'm a bit reluctant to add
> > complexity to an already complex code without a real use case.
> 
> Sorry for not following this thread very closely. One use case for
> changing CFA table is to adjust sharpness of the frames coming out
> of the ISP. And we are doing exactly this in N9.

Thank you for the valuable feedback. Now we have a use case :-) I'll make sure 
the CFA table can be updated during streaming then. Are you fine with always 
specifying the table in SGRBG order, and letting the driver rearrange the 4 
blocks based on the input bayer pattern ?

-- 
Regards,

Laurent Pinchart


Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55450 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab2EHSn6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 14:43:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: soc-camera: (cosmetic) use a more explicit name for a host handler
Date: Tue, 08 May 2012 20:43:59 +0200
Message-ID: <20252573.z5E6mOzyEi@avalon>
In-Reply-To: <Pine.LNX.4.64.1205081941490.7085@axis700.grange>
References: <Pine.LNX.4.64.1205081856180.7085@axis700.grange> <CAKnK67Q8W-JB700qCBN_ma-JCQZXX19qi+PD9xW=kAjzMhYPTQ@mail.gmail.com> <Pine.LNX.4.64.1205081941490.7085@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 08 May 2012 19:44:11 Guennadi Liakhovetski wrote:
> On Tue, 8 May 2012, Aguirre, Sergio wrote:
> > On Tue, May 8, 2012 at 12:00 PM, Guennadi Liakhovetski wrote:
> > > Use "enum_framesizes" instead of "enum_fsizes" to more precisely follow
> > > the name of the respective ioctl().
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > Looks good to me!
> 
> Thanks
> 
> > I'll redo my patch following this ioctl name matching.
> 
> Well, but naming was just one doubt about your patch - and in fact the
> least important one. What about the other one - the actually important one
> - do we really want to abuse struct v4l2_frmivalenum, or we want to switch
> to the one, used for pad operations or we want to invent something new? We
> still haven't got any opinions on that...

What about switching to pad operations altogether ? :-)


-- 
Regards,

Laurent Pinchart


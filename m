Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57564 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab1GNWsS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 18:48:18 -0400
Date: Fri, 15 Jul 2011 00:48:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: linux-media@vger.kernel.org
Subject: Re: [RFC] Binning on sensors
In-Reply-To: <20110714223519.GJ27451@valkosipuli.localdomain>
Message-ID: <Pine.LNX.4.64.1107150047090.10688@axis700.grange>
References: <20110714113201.GD27451@valkosipuli.localdomain>
 <Pine.LNX.4.64.1107141955280.10688@axis700.grange>
 <20110714212638.GH27451@valkosipuli.localdomain> <Pine.LNX.4.64.1107142353350.10688@axis700.grange>
 <20110714223519.GJ27451@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 Jul 2011, Sakari Ailus wrote:

> On Fri, Jul 15, 2011 at 12:02:06AM +0200, Guennadi Liakhovetski wrote:
> > On Fri, 15 Jul 2011, Sakari Ailus wrote:
> > 
> > > Hi Guennadi,
> > > 
> > > Thanks for the comments.
> > > 
> > > On Thu, Jul 14, 2011 at 07:56:10PM +0200, Guennadi Liakhovetski wrote:
> > > > On Thu, 14 Jul 2011, Sakari Ailus wrote:
> > > > 
> > > > > Hi all,
> > > > > 
> > > > > I was thinking about the sensor binning controls.
> > > > 
> > > > What wrong with just doing S_FMT on the subdev pad? Binning does in fact 
> > > > implement scaling.
> > > 
> > > Nothing really. Supporting setting binning using S_FMT is fine.
> > > 
> > > However, the interface does not express binning capabilities in any way. To
> > > effectively use binning settings one must know the capabilities. Binning is
> > > scaling but the choices are so coarse that the capabilities are a must.
> > > 
> > > The capabilities could be found implicitly by trying out different formats
> > > and looking back at the result. That's still not quite trivial.
> > > 
> > > If there would be a good way to enumerate the binning capabilities, combined
> > > with S_FMT it'd be close to perfect.
> > 
> > Then how about something like ENUM_SCALE(S)?
> 
> For enumerating scaler capabilities?
> 
> The capabilities and features vary wildly --- actually binning (and
> skipping) are probably the only types of scaling the properties of which can
> be fully expressed so tersely. What would you think about enumerating only
> binning and skipping?

Those are the scalers, that can be easily enumerated, yes. Others simply 
wouldn't implement this method. Similar to ENUM_FRAMESIZES etc.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

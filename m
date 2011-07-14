Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:51768 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab1GNWfX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 18:35:23 -0400
Date: Fri, 15 Jul 2011 01:35:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC] Binning on sensors
Message-ID: <20110714223519.GJ27451@valkosipuli.localdomain>
References: <20110714113201.GD27451@valkosipuli.localdomain>
 <Pine.LNX.4.64.1107141955280.10688@axis700.grange>
 <20110714212638.GH27451@valkosipuli.localdomain>
 <Pine.LNX.4.64.1107142353350.10688@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1107142353350.10688@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 15, 2011 at 12:02:06AM +0200, Guennadi Liakhovetski wrote:
> On Fri, 15 Jul 2011, Sakari Ailus wrote:
> 
> > Hi Guennadi,
> > 
> > Thanks for the comments.
> > 
> > On Thu, Jul 14, 2011 at 07:56:10PM +0200, Guennadi Liakhovetski wrote:
> > > On Thu, 14 Jul 2011, Sakari Ailus wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > I was thinking about the sensor binning controls.
> > > 
> > > What wrong with just doing S_FMT on the subdev pad? Binning does in fact 
> > > implement scaling.
> > 
> > Nothing really. Supporting setting binning using S_FMT is fine.
> > 
> > However, the interface does not express binning capabilities in any way. To
> > effectively use binning settings one must know the capabilities. Binning is
> > scaling but the choices are so coarse that the capabilities are a must.
> > 
> > The capabilities could be found implicitly by trying out different formats
> > and looking back at the result. That's still not quite trivial.
> > 
> > If there would be a good way to enumerate the binning capabilities, combined
> > with S_FMT it'd be close to perfect.
> 
> Then how about something like ENUM_SCALE(S)?

For enumerating scaler capabilities?

The capabilities and features vary wildly --- actually binning (and
skipping) are probably the only types of scaling the properties of which can
be fully expressed so tersely. What would you think about enumerating only
binning and skipping?

-- 
Sakari Ailus
sakari.ailus@iki.fi

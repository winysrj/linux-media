Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:55020 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab1GNWCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 18:02:10 -0400
Date: Fri, 15 Jul 2011 00:02:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: linux-media@vger.kernel.org
Subject: Re: [RFC] Binning on sensors
In-Reply-To: <20110714212638.GH27451@valkosipuli.localdomain>
Message-ID: <Pine.LNX.4.64.1107142353350.10688@axis700.grange>
References: <20110714113201.GD27451@valkosipuli.localdomain>
 <Pine.LNX.4.64.1107141955280.10688@axis700.grange>
 <20110714212638.GH27451@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 Jul 2011, Sakari Ailus wrote:

> Hi Guennadi,
> 
> Thanks for the comments.
> 
> On Thu, Jul 14, 2011 at 07:56:10PM +0200, Guennadi Liakhovetski wrote:
> > On Thu, 14 Jul 2011, Sakari Ailus wrote:
> > 
> > > Hi all,
> > > 
> > > I was thinking about the sensor binning controls.
> > 
> > What wrong with just doing S_FMT on the subdev pad? Binning does in fact 
> > implement scaling.
> 
> Nothing really. Supporting setting binning using S_FMT is fine.
> 
> However, the interface does not express binning capabilities in any way. To
> effectively use binning settings one must know the capabilities. Binning is
> scaling but the choices are so coarse that the capabilities are a must.
> 
> The capabilities could be found implicitly by trying out different formats
> and looking back at the result. That's still not quite trivial.
> 
> If there would be a good way to enumerate the binning capabilities, combined
> with S_FMT it'd be close to perfect.

Then how about something like ENUM_SCALE(S)?

Thanks
Guennadi

> 
> > > I have a sensor which can do binning both horizontally and vertically, but
> > > the two are connected. So, the sensor supports e.g. 3x1 and 1x3 binning but
> > > not 3x3.
> > > 
> > > However, most (I assume) sensors do not have dependencies between the two.
> > > The interface which would be provided to the user still should be able to
> > > tell what is supported, whether the two are independent or not.
> > > 
> > > I have a few ideas how to achieve this.
> > > 
> > > 1. Implement dependent binning as a menu control. The user will have an easy
> > > way to enumerate binning and select it. If horizontal and vertical binning
> > > factors are independent, two integer controls are provided. The downside is
> > > that there are two ways to do this, and integer to string and back
> > > conversions involved.
> > > 
> > > 2. Menu control is used all the time. The benefit is that the user gets a
> > > single interface, but the downside is that if there are many possible
> > > binning factors both horizontally and vertically, the size of the menu grows
> > > large. Typically binning ends at 2 or 4, though.
> > > 
> > > 3. Implement two integer controls. The user is responsible for selecting a
> > > valid configuration. A way to enumerate possible values would have to be
> > > implemented. One option would be an ioctl but I don't like the idea.
> > > 
> > > Comments are welcome as always.
> > > 
> > > Cheers,
> > > 
> > > -- 
> > > Sakari Ailus
> > > sakari.ailus@iki.fi
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 
> -- 
> Sakari Ailus
> sakari.ailus@iki.fi
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

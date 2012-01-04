Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40128 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab2ADJjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 04:39:14 -0500
Date: Wed, 4 Jan 2012 11:39:09 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: v4l: how to get blanking clock count?
Message-ID: <20120104093909.GA9323@valkosipuli.localdomain>
References: <CAHG8p1Ao8UDuCytunFjvGZ1Ugd_xVU9cf_iXv6YjcRD41aMYtw@mail.gmail.com>
 <20111230213301.GA3677@valkosipuli.localdomain>
 <CAHG8p1ACi7CGFEBVaSr5G1cUMqtH8wX2mRY6n1yKF8TqgJ0oYw@mail.gmail.com>
 <20111231113529.GC3677@valkosipuli.localdomain>
 <4EFEFA08.805@gmail.com>
 <CAHG8p1AjoV1gBhQGFm0rEYSkHrpG+XtQB7kYXc8x5nuqjW4Z4g@mail.gmail.com>
 <20120104082742.GL3677@valkosipuli.localdomain>
 <CAHG8p1DxPJthH8JOH9AEmLyCwas4O0f16ytk3FeknaPLnP_-2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHG8p1DxPJthH8JOH9AEmLyCwas4O0f16ytk3FeknaPLnP_-2g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 04, 2012 at 05:10:40PM +0800, Scott Jiang wrote:
> 2012/1/4 Sakari Ailus <sakari.ailus@iki.fi>:
> > Hi Scott,
> >
> > On Wed, Jan 04, 2012 at 01:50:17PM +0800, Scott Jiang wrote:
> >> >> I the case of your bridge, that may not be possible, but that's the only one
> >> >> I've heard of so I think it's definitely a special case. In that case the
> >> >> sensor driver can't be allowed to change the blanking periods while
> >> >> streaming is ongoing.
> >> >
> >> > I agree, it's just a matter of adding proper logic at the sensor driver.
> >> > However it might be a bit tricky, the bridge would have to validate blanking
> >> > values before actually enabling streaming.
> >> >
> >> Yes, this value doesn't affect the result image. The hardware only
> >> raises a error interrupt to signify that a horizontal tracking
> >> overflow has
> >> occurred, that means the programmed number of samples did not match up
> >> with the actual number of samples counted between assertions of
> >> HSYNC(I can only set active samples now).
> >
> > Is there no way to disable this tracking, and just rely on hsync as everyone
> > else does? Sounds like the hardware tries to do something it shouldn't...
> >
> If I disable this interrupt, other errors like fifo underflow are ignored.
> Perhaps I can add a parameter in platform data to let user decide to
> register this interrupt or not.

I think a more generic solution would be preferrable. If that causes
ignoring real errors, that's of course bad. I  wonder if there would be a
way around that.

Is there a publicly available datasheet for the bridge that I could take a
look at?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk

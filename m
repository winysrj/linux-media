Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44749 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751567AbbFLXCQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 19:02:16 -0400
Date: Sat, 13 Jun 2015 02:01:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] omap3isp: Fix sub-device power management code
Message-ID: <20150612230143.GV5904@valkosipuli.retiisi.org.uk>
References: <1432855083-25969-1-git-send-email-sakari.ailus@iki.fi>
 <2107807.pFBTyZhm9E@avalon>
 <20150610213811.GR5904@valkosipuli.retiisi.org.uk>
 <1434096127.3f3fQLryEJ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1434096127.3f3fQLryEJ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Jun 12, 2015 at 10:24:28AM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Thursday 11 June 2015 00:38:11 Sakari Ailus wrote:
> > On Wed, Jun 10, 2015 at 03:52:50AM +0300, Laurent Pinchart wrote:
> > > On Friday 29 May 2015 02:17:47 Sakari Ailus wrote:
> > > > The power management code was reworked a little due to interface changes
> > > > in the MC. Due to those changes the power management broke a bit, fix it
> > > > so the functionality is reverted to old behaviour.
> > > 
> > > I found the commit message a bit vague. How about
> > > 
> > > "Commit 813f5c0ac5cc ("media: Change media device link_notify behaviour")
> > > modified the media controller link setup notification API and updated the
> > > OMAP3 ISP driver accordingly. As a side effect it introduced a bug by
> > > turning power on after setting the link instead of before. This results
> > > in powered off entities being accessed. Fix it."
> > > 
> > > Or have I misunderstood the problem ?
> > 
> > Not entirely, but it's not just that: depending on the order in which the
> > links are changed and the video nodes opened or closed, the use counts may
> > end up being too high or too low (even negative).
> 
> OK. Could you please update the commit message accordingly ?

Hmm. I'm still not fully certain how did I manage to reproduce that, but in
a few occasions the sensor was powered down when it shouldn't have been and
the power count was decreased more than it was first increased.

What's indeed easy to see is that in post notification of enabling the links
the use counts of the partial pipelines are in fact not those of the
partial, but the complete one, and thus end up being twice as much they
should be.

I'm fine with using the commit message you suggested, the bottom line still
is that it was broken, and the patch fixes it.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

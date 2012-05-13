Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58371 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751731Ab2EMAGx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 May 2012 20:06:53 -0400
Date: Sun, 13 May 2012 03:06:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v4 10/12] V4L: Add auto focus targets to the
 selections API
Message-ID: <20120513000645.GE3373@valkosipuli.retiisi.org.uk>
References: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
 <1336156337-10935-11-git-send-email-s.nawrocki@samsung.com>
 <4FA6C155.6030100@iki.fi>
 <4FA8F977.8020707@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA8F977.8020707@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tue, May 08, 2012 at 12:46:15PM +0200, Sylwester Nawrocki wrote:
> Hi Sakari!
> 
> On 05/06/2012 08:22 PM, Sakari Ailus wrote:
> > Hi Sylwester,
> > 
> > Thanks for the patch.
> > 
> > Sylwester Nawrocki wrote:
> >> The camera automatic focus algorithms may require setting up
> >> a spot or rectangle coordinates or multiple such parameters.
> >>
> >> The automatic focus selection targets are introduced in order
> >> to allow applications to query and set such coordinates. Those
> >> selections are intended to be used together with the automatic
> >> focus controls available in the camera control class.
> > 
> > Have you thought about multiple autofocus windows, and how could they be
> > implemented on top of this patch?
> > 
> > I'm not saying that we should implement them now, but at least we should
> > think how we _would_ implement them when needed. They aren't that exotic
> > functionality these days after all.
> > 
> > I'd guess this would involve an additional bitmask control and defining
> > a set of new targets. A comment in the source might help here ---
> > perhaps a good rule is to start new ranges at 0x1000 as you're doing
> > already.
> 
> There was also an idea to convert part of the reserved[] field to a window
> index IIRC. Not sure which approach is better. I didn't want to make any
> assumptions about features I don't have exact knowledge about, neither that
> I currently need. The large offset in the auto focus target is to better
> indicate they are really different than current selection targets we have,
> I also had in mind reserving a target pool for AF targets as you are
> pointing out.
> That said I'm not really sure right now what additional exact comments
> would need to be added.

I was thinking about reserving a bunch of targets for just AF windows, but
the idea of adding a window ID is interesting. Then there's only need for a
single target which does sound a lot cleaner.

This would be a quite nice way to implement passing the face detection info
to user space, too: face detection target and object identifier. The target
field would map nicely to id in events, too.

It might make sense to implement a new IOCTL for passing multiple events but
that's fine optimisation.

> Hopefully there isn't anything blocking further expansion in this patches.
> 
> I didn't decided yet if I want to send this selection/auto focus patches
> out for v3.5. I'm also considering dropping just the V4L2_AUTO_FOCUS_AREA
> control from "12/12 V4L: Add camera auto focus controls" patch this time.
> 
> The bitmask control for multiple windows selection makes a lot of sense
> to me. I suppose it would be better to use an additional 'index' field
> in the selection data structures for AF window selection.

I agree.

I'd like to get a conclusion to whether or not to drop ACTUAL / ACTIVE
before I give my ack to this patch.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk

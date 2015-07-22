Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41946 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752304AbbGVV20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 17:28:26 -0400
Date: Thu, 23 Jul 2015 00:27:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Bjornar Salberg <bsalberg@cisco.com>
Subject: Re: [RFC] How to get current position/status of
 iris/focus/pan/tilt/zoom?
Message-ID: <20150722212750.GB12092@valkosipuli.retiisi.org.uk>
References: <559527D7.1030408@xs4all.nl>
 <20150722082147.GA12092@valkosipuli.retiisi.org.uk>
 <55AF5986.5080106@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55AF5986.5080106@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Jul 22, 2015 at 10:51:18AM +0200, Hans Verkuil wrote:
> On 07/22/15 10:21, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Thu, Jul 02, 2015 at 02:00:23PM +0200, Hans Verkuil wrote:
> >> When using V4L2_CID_IRIS/FOCUS/PAN/TILT/ZOOM_ABSOLUTE/RELATIVE, how do you know
> >> when the new position has been reached? If this is controlled through a motor,
> >> then it may take some time and ideally you would like to be able to get the
> >> current absolute position (if the hardware knows) and whether the final position
> >> has been reached or not.
> > 
> > On voice coil lenses it's also not possible to know when the position has
> > been reached, however you can estimate when it has happened based on the
> > intended movement and algorithm used to move the lens. This is far from
> > trivial though.
> > 
> > For low-level lends drivers knowing where the lens is is not feasible IMO at
> > the moment.
> > 
> >>
> >> In addition, it should be possible to raise fault conditions.
> > 
> > Do you know of hardware that can do this? The only non-buffer related
> > devices that can do this I'm aware of are flash controllers.
> 
> If a motor is involved to move things around, then that motor can cause
> failures that you want to signal. For example if something is blocking the
> motor from moving any further, overheating, whatever. I hate moving parts :-)

I don't argue about whether or not to tell it to the user, but can the
hardware tell that to the driver? If it can, naturally the user should be
told.

What I think would be nice to pay closer attention to at some point would be
voice coil lens controls. These are typically cheap and difficult to control
devices, as you apply a current that's going to move a lens rather than
telling it to be moved to a certain position. The higher level control is,
in my understanding, often more or less tightly coupled with the AF
algorithms. At the very least the existing drivers are quite low level
drivers. We should look what are the commonalities among those. But that'd
be a new topic likely requiring multiple RFCs...

This will quite probably look at least somewhat different in terms of
controls compared to current manual focus controls.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

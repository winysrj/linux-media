Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39754 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934059AbdGTQOF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 12:14:05 -0400
Date: Thu, 20 Jul 2017 19:14:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Subject: Re: [RFC 00/19] Async sub-notifiers and how to use them
Message-ID: <20170720161400.ijud3kppizb44acw@valkosipuli.retiisi.org.uk>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
 <eb0ff309-bdf5-30f9-06da-2fc6c35fbf6a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb0ff309-bdf5-30f9-06da-2fc6c35fbf6a@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

On Wed, Jul 19, 2017 at 01:42:55PM +0200, Hans Verkuil wrote:
> On 18/07/17 21:03, Sakari Ailus wrote:
> > Hi folks,
> > 
> > This RFC patchset achieves a number of things which I've put to the same
> > patchset for they need to be show together to demonstrate the use cases.
> > 
> > I don't really intend this to compete with Niklas's patchset but much of
> > the problem area addressed by the two is the same.
> > 
> > Comments would be welcome.
> > 
> > - Add AS3645A LED flash class driver.
> > 
> > - Add async notifiers (by Niklas).
> > 
> > - V4L2 sub-device node registration is moved to take place at the same time
> >   with the registration of the sub-device itself. With this change,
> >   sub-device node registration behaviour is aligned with video node
> >   registration.
> > 
> > - The former is made possible by moving the bound() callback after
> >   sub-device registration.
> > 
> > - As all the device node registration and link creation is done as the
> >   respective devices are probed, there is no longer dependency to the
> >   notifier complete callback which as itself is seen problematic. The
> >   complete callback still exists but there's no need to use it, pending
> >   changes in individual drivers.
> > 
> >   See:
> >   <URL:http://www.spinics.net/lists/linux-media/msg118323.html>
> > 
> >   As a result, if a part of the media device fails to initialise because it
> >   is e.g. physically broken, it will be possible to use what works.
> 
> I've got major problems with this from a userspace point of view. In the vast
> majority of cases you just want to bail out if one or more subdevs fail.

I admit it's easier for the user space if the device becomes available only
when all its component drivers have registered.

Also remember that video nodes are registered in the file system right on
device probe time. It's only sub-device and media device node registration
that has taken place in the notifier's complete handler.

There are things how we could do this easier, for instance providing events
on the media device on entity registration and possibly registration state
(whether all entities have been registered).

This way the user space can easily choose whether it would like to proceed
using a partially functional device (or not).

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

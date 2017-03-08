Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48142 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750888AbdCHPH1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 10:07:27 -0500
Date: Wed, 8 Mar 2017 15:20:54 +0100
From: Greg KH <greg@kroah.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] atomisp2: unify some ifdef cases caused by format changes
Message-ID: <20170308142054.GA11016@kroah.com>
References: <148879924465.10733.17814546240558419917.stgit@acox1-desk1.ger.corp.intel.com>
 <90583522-0afb-e556-b1a6-dea0efc5392d@xs4all.nl>
 <20170308133947.GB5221@kroah.com>
 <b13609bf-0e14-685a-01a7-0ba88e15db8c@xs4all.nl>
 <2540e923-6468-a283-26ff-9e48a4f18157@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2540e923-6468-a283-26ff-9e48a4f18157@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 08, 2017 at 02:55:44PM +0100, Hans Verkuil wrote:
> On 08/03/17 14:45, Hans Verkuil wrote:
> > On 08/03/17 14:39, Greg KH wrote:
> > > On Wed, Mar 08, 2017 at 01:49:23PM +0100, Hans Verkuil wrote:
> > > > OK, so I discovered that these patches are for a driver added to linux-next
> > > > without it ever been cross-posted to linux-media.
> > > > 
> > > > To be polite, I think that's rather impolite.
> > > 
> > > They were, but got rejected due to the size :(
> > > 
> > > Mauro was cc:ed directly, he knew these were coming...
> > > 
> > > I can take care of the cleanup patches for now, you don't have to review
> > > them if you don't want to.
> > 
> > Please do.
> > 
> > For the next time if the patches are too large: at least post a message with
> > a link to a repo for people to look at. I would like to know what's going
> > on in staging/media, especially since I will do a lot of the reviewing (at
> > least if it is a V4L2 driver) when they want to move it out of staging.
> 
> Same issue BTW with the bcm2835 driver. That too landed in staging without
> ever being posted to the linux-media mailinglist. Size is no excuse for that
> driver since it isn't that large.
> 
> I'll handle cleanup patches for the bcm2835 driver since it is now in our tree.

Nope, it got moved out as it didn't belong there yet :)

It's now in drivers/staging/vc04_services/ as all of the issues so far
aren't media ones, but vc04 api issues.  Once those get ironed out, then
the media people can have at it :)

thanks,

greg k-h

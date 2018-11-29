Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:27779 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbeK3Hol (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 02:44:41 -0500
Date: Thu, 29 Nov 2018 22:37:53 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: Possible regression in v4l2-async
Message-ID: <20181129203752.lw6cy4gopxmoc7fe@kekkonen.localdomain>
References: <20181129184710.GA10382@bigcity.dyn.berto.se>
 <d2eb601a-80a8-41d5-ebd0-56159d339604@gmail.com>
 <880ff893-9e7a-6140-0261-4b8d88c69b5b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <880ff893-9e7a-6140-0261-4b8d88c69b5b@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve, Niklas,

On Thu, Nov 29, 2018 at 11:41:32AM -0800, Steve Longerbeam wrote:
> 
> 
> On 11/29/18 11:26 AM, Steve Longerbeam wrote:
> > Hi Niklas,
> > 
> > On 11/29/18 10:47 AM, Niklas Söderlund wrote:
> > > Hi Steve, Sakari and Hans,
> > > 
> > > I have been made aware of a possible regression by a few users of
> > > rcar-vin and I'm a bit puzzled how to best handle it. Maybe you can help
> > > me out?
> > > 
> > > The issue is visible when running with LOCKDEP enabled and it prints a
> > > warning about a possible circular locking dependency, see end of mail.
> > > The warning is triggered because rcar-vin takes a mutex (group->lock) in
> > > its async bound call back while the async framework already holds one
> > > (lisk_lock).
> > 
> > I see two possible solutions to this:
> > 
> > A. Remove acquiring the list_lock in v4l2_async_notifier_init().
> > 
> > B. Move the call to v4l2_async_notifier_init()**to the top of
> > rvin_mc_parse_of_graph() (before acquiring group->lock).
> > 
> > It's most likely safe to remove the list_lock from
> > v4l2_async_notifier_init(), because all drivers should be calling that
> > function at probe start, before it begins to add async subdev
> > descriptors to their notifiers. But just the same, I think it would be
> > safer to keep list_lock in v4l2_async_notifier_init(), just in case of
> > some strange corner case (such as a driver that adds descriptors in a
> > separate thread from the thread that calls v4l2_async_notifier_init()).
> 
> Well, on second thought that's probably a lame example, no driver should be
> doing that. So removing the list_lock from v4l2_async_notifier_init() is
> probably safe. The notifier is not registered with v4l2-async at that point.

I agree, apart from "probably". It is safe.

Niklas: would you like to send a patch? :-)

-- 
Sakari Ailus
sakari.ailus@linux.intel.com

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:58636 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeILRBW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 13:01:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        mchehab@kernel.org
Subject: Re: [PATCH 1/1] v4l: event: Prevent freeing event subscriptions while accessed
Date: Wed, 12 Sep 2018 14:57:20 +0300
Message-ID: <1845994.88l34GQLCY@avalon>
In-Reply-To: <20180912100056.5upn2zrmy6tbeluu@kekkonen.localdomain>
References: <20180912085232.26950-1-sakari.ailus@linux.intel.com> <9df0d0b6-2f28-2479-5018-c715b3085934@xs4all.nl> <20180912100056.5upn2zrmy6tbeluu@kekkonen.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, 12 September 2018 13:00:57 EEST Sakari Ailus wrote:
> On Wed, Sep 12, 2018 at 11:27:35AM +0200, Hans Verkuil wrote:
> > On 09/12/18 10:52, Sakari Ailus wrote:
> >> The event subscriptions are added to the subscribed event list while
> >> holding a spinlock, but that lock is subsequently released while still
> >> accessing the subscription object. This makes it possible to unsubscribe
> >> the event --- and freeing the subscription object's memory --- while
> >> the subscription object is simultaneously accessed.
> > 
> > Hmm, the (un)subscribe ioctls are serialized through the ioctl lock,
> > so this could only be a scenario with drivers that do not use this
> > lock. Off-hand the only driver I know that does this is uvc.
> > Unfortunately,
> > that's a rather popular one.
> 
> On video nodes, perhaps. But how about sub-device nodes? Generally drivers
> tend to do locking themselves, whether or not that is the best for most
> drivers.

I tend to agree with Sakari. Furthermore, having fine-grained locking is 
better in my opinion than locking everything at the ioctl level, for drivers 
that wish to do so. We should thus strive for self-contained locking in the 
different helper libraries of V4L2.

> >> Prevent this by adding a mutex to serialise the event subscription and
> >> unsubscription. This also gives a guarantee to the callback ops that the
> >> add op has returned before the del op is called.
> >> 
> >> This change also results in making the elems field less special:
> >> subscriptions are only added to the event list once they are fully
> >> initialised.
> >> 
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> ---
> >> Hi folks,
> >> 
> >> I noticed this while working to add support for media events. This seems
> >> like material for the stable trees.
> > 
> > I'd say 'no need for this' if it wasn't for uvc.
> > 
> >>  drivers/media/v4l2-core/v4l2-event.c | 35 ++++++++++++++++-------------
> >>  drivers/media/v4l2-core/v4l2-fh.c    |  2 ++
> >>  include/media/v4l2-fh.h              |  4 ++++
> >>  3 files changed, 24 insertions(+), 17 deletions(-)

[snip]

> >> diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
> >> index ea73fef8bdc0..1be45a5f6383 100644
> >> --- a/include/media/v4l2-fh.h
> >> +++ b/include/media/v4l2-fh.h
> >> @@ -42,6 +42,9 @@ struct v4l2_ctrl_handler;
> >>   * @available: list of events waiting to be dequeued
> >>   * @navailable: number of available events at @available list
> >>   * @sequence: event sequence number
> >> + * @mutex: hold event subscriptions during subscribing;
> >> + *	   guarantee that the add and del event callbacks are orderly called

Could you try to describe what this mutex protects in terms of data ?

> >> + *

Extra blank line ?

> >>   * @m2m_ctx: pointer to &struct v4l2_m2m_ctx
> >>   */
> >>  
> >>  struct v4l2_fh {
> >> @@ -56,6 +59,7 @@ struct v4l2_fh {
> >>  	struct list_head	available;
> >>  	unsigned int		navailable;
> >>  	u32			sequence;
> >> +	struct mutex		mutex;
> > 
> > I don't like the name 'mutex'. Perhaps something more descriptive like:
> > 'subscribe_lock'?
> > 
> >>  #if IS_ENABLED(CONFIG_V4L2_MEM2MEM_DEV)
> >>  
> >>  	struct v4l2_m2m_ctx	*m2m_ctx;
> > 
> > Overall I think this patch makes sense. The code is cleaner and easier to
> > follow. Just give 'mutex' a better name :-)
> 
> How about "subscribe_mutex"? It's a mutex... "subscribe_lock" would use a
> similar convention elsewhere in V4L2 where mutexes are commonly called
> locks, so I'm certainly fine with that as well.

We indeed use lock for both mutexes and spinlocks. I have a slight preference 
for the name lock myself, but I don't mind too much.

-- 
Regards,

Laurent Pinchart

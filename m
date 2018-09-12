Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13326 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbeIMC6n (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:58:43 -0400
Date: Thu, 13 Sep 2018 00:52:12 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        mchehab@kernel.org
Subject: Re: [PATCH 1/1] v4l: event: Prevent freeing event subscriptions
 while accessed
Message-ID: <20180912215211.c4hw72d2uff5yaff@kekkonen.localdomain>
References: <20180912085232.26950-1-sakari.ailus@linux.intel.com>
 <9df0d0b6-2f28-2479-5018-c715b3085934@xs4all.nl>
 <20180912100056.5upn2zrmy6tbeluu@kekkonen.localdomain>
 <1845994.88l34GQLCY@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1845994.88l34GQLCY@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Sep 12, 2018 at 02:57:20PM +0300, Laurent Pinchart wrote:
> Hello,
> 
> On Wednesday, 12 September 2018 13:00:57 EEST Sakari Ailus wrote:
> > On Wed, Sep 12, 2018 at 11:27:35AM +0200, Hans Verkuil wrote:
> > > On 09/12/18 10:52, Sakari Ailus wrote:
> > >> The event subscriptions are added to the subscribed event list while
> > >> holding a spinlock, but that lock is subsequently released while still
> > >> accessing the subscription object. This makes it possible to unsubscribe
> > >> the event --- and freeing the subscription object's memory --- while
> > >> the subscription object is simultaneously accessed.
> > > 
> > > Hmm, the (un)subscribe ioctls are serialized through the ioctl lock,
> > > so this could only be a scenario with drivers that do not use this
> > > lock. Off-hand the only driver I know that does this is uvc.
> > > Unfortunately,
> > > that's a rather popular one.
> > 
> > On video nodes, perhaps. But how about sub-device nodes? Generally drivers
> > tend to do locking themselves, whether or not that is the best for most
> > drivers.
> 
> I tend to agree with Sakari. Furthermore, having fine-grained locking is 
> better in my opinion than locking everything at the ioctl level, for drivers 
> that wish to do so. We should thus strive for self-contained locking in the 
> different helper libraries of V4L2.
> 
> > >> Prevent this by adding a mutex to serialise the event subscription and
> > >> unsubscription. This also gives a guarantee to the callback ops that the
> > >> add op has returned before the del op is called.
> > >> 
> > >> This change also results in making the elems field less special:
> > >> subscriptions are only added to the event list once they are fully
> > >> initialised.
> > >> 
> > >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >> ---
> > >> Hi folks,
> > >> 
> > >> I noticed this while working to add support for media events. This seems
> > >> like material for the stable trees.
> > > 
> > > I'd say 'no need for this' if it wasn't for uvc.
> > > 
> > >>  drivers/media/v4l2-core/v4l2-event.c | 35 ++++++++++++++++-------------
> > >>  drivers/media/v4l2-core/v4l2-fh.c    |  2 ++
> > >>  include/media/v4l2-fh.h              |  4 ++++
> > >>  3 files changed, 24 insertions(+), 17 deletions(-)
> 
> [snip]
> 
> > >> diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
> > >> index ea73fef8bdc0..1be45a5f6383 100644
> > >> --- a/include/media/v4l2-fh.h
> > >> +++ b/include/media/v4l2-fh.h
> > >> @@ -42,6 +42,9 @@ struct v4l2_ctrl_handler;
> > >>   * @available: list of events waiting to be dequeued
> > >>   * @navailable: number of available events at @available list
> > >>   * @sequence: event sequence number
> > >> + * @mutex: hold event subscriptions during subscribing;
> > >> + *	   guarantee that the add and del event callbacks are orderly called
> 
> Could you try to describe what this mutex protects in terms of data ?

The purpose actually changed a bit after I wrote the text. That could be
the reason why it's sort of detached from the reality. :-) How about this:

mutex: serialise changes to the subscribed list; guarantee that the add and
       del event callbacks are orderly called

> 
> > >> + *
> 
> Extra blank line ?

A line that separates the event related fields from the m2m context.
There's one above the event related ones, too. I didn't think it's worth
mentioning that in the patch description. :-)

-- 
Sakari Ailus
sakari.ailus@linux.intel.com

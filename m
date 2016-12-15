Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48645 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936409AbcLOPGb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 10:06:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg KH <greg@kroah.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Shuah Khan <shuahkh@osg.samsung.com>, javier@osg.samsung.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
Date: Thu, 15 Dec 2016 17:07:03 +0200
Message-ID: <1493768.35UTxJ6OiJ@avalon>
In-Reply-To: <20161215123112.GA26269@kroah.com>
References: <20161214151406.20380-1-mchehab@s-opensource.com> <3043978.ViByGAdkJL@avalon> <20161215123112.GA26269@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Thursday 15 Dec 2016 04:31:12 Greg KH wrote:
> On Thu, Dec 15, 2016 at 02:13:42PM +0200, Laurent Pinchart wrote:
> > Hi Mauro,
> > 
> > (CC'ing Greg)
> > 
> > On Wednesday 14 Dec 2016 13:14:06 Mauro Carvalho Chehab wrote:
> > > Avoid calling streamoff without having the media structs allocated.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > 
> > The driver has a maintainer listed in MAINTAINERS, and you know that
> > Sakari is also actively involved here. You could have CC'ed us.
> > 
> > > ---
> > > 
> > > Javier,
> > > 
> > > Could you please test this patch?
> > > 
> > > Thanks!
> > > Mauro
> > > 
> > >  drivers/media/platform/omap3isp/ispvideo.c | 10 ++++++++--
> > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> > > b/drivers/media/platform/omap3isp/ispvideo.c index
> > > 7354469670b7..f60995ed0a1f 100644
> > > --- a/drivers/media/platform/omap3isp/ispvideo.c
> > > +++ b/drivers/media/platform/omap3isp/ispvideo.c
> > > @@ -1488,11 +1488,17 @@ int omap3isp_video_register(struct isp_video
> > > *video, struct v4l2_device *vdev) "%s: could not register video device
> > > (%d)\n",> > 
> > >  			__func__, ret);
> > > 
> > > +	/* Prevent destroying MC before unregistering */
> > > +	kobject_get(vdev->v4l2_dev->mdev->devnode->dev.parent);
> > 
> > This doesn't even compile. Please make sure to at least compile-test
> > patches you send for review, otherwise you end up wasting time for all
> > reviewers and testers. I assume you meant
> > 
> > 	kobject_get(&vdev->mdev->devnode->dev.parent->kobj);
> > 
> > and similarly below.
> > 
> > That's a long list of pointer dereferences, going deep down the device
> > core. Greg, are drivers allowed to do this by the driver model ?
> 
> WTF?
> 
> Eeek, no no no no!
> 
> First off, no driver should EVER have to call a "raw" kobject call,
> that's a huge sign that you are doing something really really wrong.
> 
> Secondly, you NEVER grab a reference to a structure like this, you use
> the "correct" driver/bus api calls.
> 
> Thirdly, ugh, how to say this nicely...  The whole idea that something
> like this could actually be a real solution to a problem is insane.
> 
> Look at what you are really doing here, trying to grab an extra
> reference on something that in reality, should never go away anyhow.
> Your parent structure should already always have the reference count
> incremented and will not disappear underneath you at all.  And if this
> isn't your "parent", you have no right at all to go grab random
> references across the device tree for no reason other than you feel you
> don't want it to go away.  If you don't want something to go away, you
> properly get the reference (hint, you already should have if you have
> this type of pointer chain to the object.)
> 
> If this type of solution is somehow the "correct" one, the v4l driver
> model interaction is severely broken and needs to be fixed.
> 
> What bug is this that caused this type of hack to even be proposed?  Is
> it a bug or a regression?  If a regression, can someone show me the
> commit that would cause such a monstrosity to be proposed?
> 
> Laurent, sorry, I know I said I was going to debug a USB V4L reference
> counting problem last week, I had to travel and haven't had the chance
> to do so.  I'll try to get to it today.  Hopefully that issue has
> nothing to do with this problem.  Because if so, ugh...

No worries, it's not urgent. The problem has nothing to do with this. I've 
used the uvcvideo driver to trigger it, but it's probably independent of V4L2 
(although sometimes I'm beginning to wonder :-)).

> Mauro, again, please never propose something like this again.

-- 
Regards,

Laurent Pinchart


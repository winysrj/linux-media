Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38143
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755135AbcLOQ6m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 11:58:42 -0500
Date: Thu, 15 Dec 2016 14:58:34 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Greg KH <greg@kroah.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <shuahkh@osg.samsung.com>, javier@osg.samsung.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
Message-ID: <20161215145834.48a93457@vento.lan>
In-Reply-To: <20161215123112.GA26269@kroah.com>
References: <20161214151406.20380-1-mchehab@s-opensource.com>
        <3043978.ViByGAdkJL@avalon>
        <20161215123112.GA26269@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 15 Dec 2016 04:31:12 -0800
Greg KH <greg@kroah.com> escreveu:

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
> > The driver has a maintainer listed in MAINTAINERS, and you know that Sakari is 
> > also actively involved here. You could have CC'ed us.
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
> > > @@ -1488,11 +1488,17 @@ int omap3isp_video_register(struct isp_video *video,
> > > struct v4l2_device *vdev) "%s: could not register video device (%d)\n",
> > >  			__func__, ret);
> > > 
> > > +	/* Prevent destroying MC before unregistering */
> > > +	kobject_get(vdev->v4l2_dev->mdev->devnode->dev.parent);  
> > 
> > This doesn't even compile. Please make sure to at least compile-test patches 
> > you send for review, otherwise you end up wasting time for all reviewers and 
> > testers. I assume you meant
> > 
> > 	kobject_get(&vdev->mdev->devnode->dev.parent->kobj);
> > 
> > and similarly below.
> > 
> > That's a long list of pointer dereferences, going deep down the device core. 
> > Greg, are drivers allowed to do this by the driver model ?  
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

Greg,

This patch is generating a lot of noise for no good reason.

It was meant to be sent just to Javier, as I currently don't have a working
OMAP3 board with V4L2 hardware.

Unfortunately, I have this on my .git/config, and it ended by being
sent to the public ML as well by mistake:

	[format]
		numbered = auto
	to = Linux Media Mailing List <linux-media@vger.kernel.org>

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

The problem here is that the Nokia N9 hardware (with uses the omap3 isp
driver) drops the /dev/media device and all associated structures too early
if unbound.

Btw, it is not clear to me why userspace would want to unbind the
V4L2 driver on such hardware, as it is not hot-pluggable.

> What bug is this that caused this type of hack to even be proposed?  Is
> it a bug or a regression?  If a regression, can someone show me the
> commit that would cause such a monstrosity to be proposed?

It is a bug, since day zero. That's why reverting patches won't fix
anything. The problem happens when the device is streaming on one (or more)
of their /dev/video?? devnodes, and it is requested to unbound
(either by removing the module or by accessing the module unbind via sysfs.

The way OMAP3 driver's code does is:

At .probe(), the OMAP3 isp driver creates a struct media_device that
it is used by other OMAP3 drivers to store the hardware setup used to
stream video inside a list. It also creates a struct media_devnode
with embeeds struct cdev to control the media pipelines, via /dev/media0.

Originally, struct media_devnode were embedded at struct media_device.
Now, media_devnode is allocated dynamically, allowing the removal of
/dev/media0 without freeing struct media_device[1].

In any case, the unbind code doesn't have any special logic to handle
disconnections.

So, when an unbind is requested, the device the device driver will free
all the data associated with struct media_device, including the hardware
setup.

It will also destroy struct media_devnode, if not used anymore (with
the current code, this is properly protected via struct device kref).

Later on, when /dev/video?? is closed, the .release() fops callback
will call the streamoff code, with depends on the data that were
freed earlier.

There are some solutions for this bug:

1) stop streaming at unbind - something similar to what we do on USB
   drivers with the .disconnect() calls, where we stop URBs and
   don't accept the driver to stream on again;

2) add a kref inside the OMAP3 driver that would only call the
   code that releases struct media_device when the last /dev/video??
   device is closed.

3) add kref for all data used by the OMAP3 driver: struct media_device,
   struct media_entity, struct media_link, ... (we could eventually
   embed it at struct media_gobj - as I proposed in mid 2015).

[1] The three patches that Sakari proposed to remove on his RFC series,
without explaining why, are those that allocate media_devnode dynamically.

> Laurent, sorry, I know I said I was going to debug a USB V4L reference
> counting problem last week, I had to travel and haven't had the chance
> to do so.  I'll try to get to it today.  Hopefully that issue has
> nothing to do with this problem.  Because if so, ugh...
> 
> Mauro, again, please never propose something like this again.
> 
> greg k-h

Thanks,
Mauro

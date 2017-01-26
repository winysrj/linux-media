Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45729
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751774AbdAZJKP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jan 2017 04:10:15 -0500
Date: Thu, 26 Jan 2017 07:10:02 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.co.uk>
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab
 references as needed
Message-ID: <20170126071002.38795fb9@vento.lan>
In-Reply-To: <20170125110231.GL3205@valkosipuli.retiisi.org.uk>
References: <20161109154608.1e578f9e@vento.lan>
        <20161213102447.60990b1c@vento.lan>
        <20161215113041.GE16630@valkosipuli.retiisi.org.uk>
        <7529355.zfqFdROYdM@avalon>
        <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl>
        <20161216150723.GL16630@valkosipuli.retiisi.org.uk>
        <20161219074655.3238113b@vento.lan>
        <20170102075348.GF3958@valkosipuli.retiisi.org.uk>
        <20170124084902.07414171@vento.lan>
        <20170125110231.GL3205@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 25 Jan 2017 13:02:31 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Tue, Jan 24, 2017 at 08:49:02AM -0200, Mauro Carvalho Chehab wrote:
> > Hi Sakari,
> > 
> > Just returned this week from vacations. I'm reading my long e-mail backlog,
> > starting from my main inbox...
> > 
> > Em Mon, 2 Jan 2017 09:53:49 +0200
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Hi Mauro,
> > > 
> > > On Mon, Dec 19, 2016 at 07:46:55AM -0200, Mauro Carvalho Chehab wrote:  
> > > > Em Fri, 16 Dec 2016 17:07:23 +0200
> > > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > > >     
> > > > > Hi Hans,    
> > > >     
> > > > > > chrdev_open in fs/char_dev.c increases the refcount on open() and decreases it
> > > > > > on release(). Thus ensuring that the cdev can never be removed while in an
> > > > > > ioctl.      
> > > > > 
> > > > > It does, but it does not affect memory which is allocated separately of that.
> > > > > 
> > > > > See this:
> > > > > 
> > > > > <URL:https://www.mail-archive.com/linux-media@vger.kernel.org/msg106390.html>    
> > > > 
> > > > That sounds promising. If this bug issues other drivers than OMAP3,
> > > > then indeed the core has a bug.
> > > > 
> > > > I'll see if I can reproduce it here with some USB drivers later this week.    
> > > 
> > > It's not a driver problem so yes, it is reproducible on other hardware.  
> > 
> > Didn't have time to test it before entering into vacations.
> > 
> > I guess I won't have any time this week to test those issues on
> > my hardware, as I suspect that my patch queue is full. Also, we're
> > approaching the next merge window. So, unfortunately, I won't have
> > much time those days to do much testing. 
> > 
> > Btw, Hans commented that you were planning to working on it this month.
> > 
> > Do you have some news with regards to the media controller bind/unbind
> > fixes?  
> 
> I have a bunch of meeting notes to send from the Oslo meeting with Hans and
> Laurent; I should have that ready by the end of the week. The RFC patchset
> certainly needs changes based on that.

OK. I'll wait for your notes and the new patchset.

> > > > While IMHO it is overkill trying to support hot plug on omap3, I won't
> > > > mind if you do that, provided that your patch series can be applied in
> > > > a way that it won't cause regressions for real hot-pluggable hardware.    
> > > 
> > > This is not really about the OMAP3 ISP driver hotplug support; it is indeed
> > > about the framework's ability to support hotpluggable hardware. The current
> > > painpoint is removing hardware; the current frameworks aren't quite up to
> > > that at the moment.  
> > 
> > The point here is that, while it would be fun to allow unbinding OMAP3
> > V4L2 drivers, OMAP3 doesn't really require hotplug support. On the other
> > hand, on USB drivers, where unbind is a requirement, the current status
> > of the tree is that hotplug works. I did some massive parallel bind/unbind
> > loops here to double check, when we added such fixup patches. Granted, I
> > won't doubt that there are still some rare race conditions that I was
> > unable to reproduce on the time I tested. I also didn't try to hack the
> > Kernel to introduce extra delays to make those race conditions more
> > likely to happen.
> > 
> > Anyway, my main concern with this patch is that it breaks hotplug on devices
> > that really need it, while it fix support only for OMAP3 (with doesn't need).  
> 
> I don't disagree with you. Obviously the intent is not to break
> hot-pluggable hardware, albeit the changes needed to avoid that haven't been
> implemented yet. (One of the reasons it's been RFC all the time.)
> 
> > 
> > Also, it starts with a series of patches that will cause regressions.
> > 
> > I won't matter changing the solution to some other approach that would
> > work, provided that the patches are added on an incremented way, and
> > won't introduce regressions to USB drivers.  
> 
> It may be possible to avoid increasing the time window during which bad
> things could happen before fully removing them.

The fix should be to protecting those windows by either a kref, lock or
a lockless (RCU) approach.

> However the patchset is a
> lot easier to work with without bundling the reverts into other (and likely
> multiple) patches as the reverted patches took quite a different direction
> than is followed in this patchset.

Doing the reverts before doing the fixes do break things. What you're
reverting is basically the logic that unbinds the struct media_devnode
from struct media_device. This is independent from whatever changes
you would be doing at struct media_device. So, you could do all changes
there, apply such changes on OMAP3 and on the USB drivers and then
rebind struct media_devnode at struct media_device[1].

[1] assuming that everyone agrees that rebinding it is for the best.
I still think that having a separate struct is better - but this is
something that I'll analise again after seeing the hole picture after
your changes - and the rationale for it.

> 
> Let's discuss this later, at the time when we have a patchset that produces
> a sound code base (on the top of that patchset) that is understood to be
> free of object lifetime issues as long as hot-pluggable hardware goes.

Let's discuss it later when you submit your newer RFC patchset on the
top of the upstream code.

> >   
> > > > On that matter, just like we use vivid as a testbench and as an
> > > > example for other drivers, it would be great if we could merge
> > > > the vimc driver. What's the status of Helen's patchset?    
> > > 
> > > That's a good point. I wasn't reviewing that driver back then when the
> > > patches were posted, but should it go in, it should make a good example for
> > > writing other drivers as well.
> > >   
> > 
> > I saw Laurent's comments about Helen's last patch series. From his
> > comments:
> > 
> > 	"I've reviewed the whole patch but haven't had time to test it. I've also 
> > 	 skipped the items marked as TODO or FIXME as they're obviously not ready yet 
> > 	 :-) Overall this looks good to me, all the issues are minor."
> > 
> > Helen promised a new version fixing those minor issues. Perhaps we should merge
> > her next series upstream with such issues addressed and see how it behaves.  
> 
> I'll review Helen's set next.

Thanks!


Regards,
Mauro

Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40192 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758310AbcLWRzS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Dec 2016 12:55:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references as needed
Date: Fri, 23 Dec 2016 19:55:49 +0200
Message-ID: <4441306.NYk05BUe5p@avalon>
In-Reply-To: <20161215150826.0ca646a3@vento.lan>
References: <20161109154608.1e578f9e@vento.lan> <47bf7ca7-2375-3dfa-775c-a56d6bd9dabd@xs4all.nl> <20161215150826.0ca646a3@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 15 Dec 2016 15:08:26 Mauro Carvalho Chehab wrote:
> Em Thu, 15 Dec 2016 16:26:19 +0100 Hans Verkuil escreveu:
> >> Should all the entities stick around until all references to media
> >> device are gone? If an application has /dev/media open, does that
> >> mean all entities should not be free'd until this app. exits? What
> >> should happen if an app. is streaming? Should the graph stay intact
> >> until the app. exits?
> > 
> > Yes, everything must stay around until the last user has disappeared.
> > 
> > In general unplugs can happen at any time. So applications can be in the
> > middle of an ioctl, and removing memory during that time is just
> > impossible.
> > 
> > On unplug you:
> > 
> > 1) stop any HW DMA (highly device dependent)
> > 2) wake up any filehandles that wait for an event
> > 3) unregister any device nodes
> > 
> > Then just sit back and wait for refcounts to go down as filehandles are
> > closed by the application.
> > 
> > Note: the v4l2/media/cec/IR/whatever core is typically responsible for
> > rejecting any ioctls/mmap/etc. once the device node has been
> > unregistered. The only valid file operation is release().
> 
> Agreed. The problem on OMAP3 is that it doesn't stop HW DMA when
> struct media_devnode is released. It tries to do it later, when the
> V4L2 core is unbind, by trying to dig into the media controller
> struct that the driver removed before.

Note that stopping the hardware doesn't mean updating the pipeline state to 
mark it as stopped. Unlike stopping the hardware that is mandatory at unbind 
time as hardware access is not allowed after the unbind handler returns, how 
we handle the software state is entirely up to us. I'm not saying it can't be 
done at unbind time, but I'm not sure yet whether it should either.

> That's said, for OMAP3 and all other drivers that don't support hot unplug,
> I would just use suppress_bind_attrs, as I fail to see any need to allow
> unbinding them.

That's akin to breaking the thermometer to cure the patient from fever. I'm 
not completely opposed to making drivers non-unbindable in a case-by-case 
basis (and based on the author's will), but if a driver author wants to make a 
driver unbindable the core should allow that to be implemented.

-- 
Regards,

Laurent Pinchart


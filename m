Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52678 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750834AbdABHxz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 02:53:55 -0500
Date: Mon, 2 Jan 2017 09:53:49 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.co.uk>
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
Message-ID: <20170102075348.GF3958@valkosipuli.retiisi.org.uk>
References: <20161109154608.1e578f9e@vento.lan>
 <20161213102447.60990b1c@vento.lan>
 <20161215113041.GE16630@valkosipuli.retiisi.org.uk>
 <7529355.zfqFdROYdM@avalon>
 <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl>
 <20161216150723.GL16630@valkosipuli.retiisi.org.uk>
 <20161219074655.3238113b@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161219074655.3238113b@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Dec 19, 2016 at 07:46:55AM -0200, Mauro Carvalho Chehab wrote:
> Em Fri, 16 Dec 2016 17:07:23 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Hans,
> 
> > > chrdev_open in fs/char_dev.c increases the refcount on open() and decreases it
> > > on release(). Thus ensuring that the cdev can never be removed while in an
> > > ioctl.  
> > 
> > It does, but it does not affect memory which is allocated separately of that.
> > 
> > See this:
> > 
> > <URL:https://www.mail-archive.com/linux-media@vger.kernel.org/msg106390.html>
> 
> That sounds promising. If this bug issues other drivers than OMAP3,
> then indeed the core has a bug.
> 
> I'll see if I can reproduce it here with some USB drivers later this week.

It's not a driver problem so yes, it is reproducible on other hardware.

> 
> > > If the omap3 is used as a testbed, then that's fine by me, but even then I
> > > probably wouldn't want the omap3 code that makes this possible in the kernel.
> > > It's just additional code for no purpose.  
> > 
> > The same problems exist on other devices, whether platform, pci or USB, as
> > the problems are in the core frameworks rather than (only) in the drivers.
> > 
> > On platform devices, this happens also when removing the module.
> > 
> > I've used omap3isp as an example since it demonstrates well the problems and
> > a lot of people have the hardware as well. Also, Mauro has requested all
> > drivers to be converted to the new API. I'm fine doing that for the actually
> > hot-pluggable hardware.
> 
> While IMHO it is overkill trying to support hot plug on omap3, I won't
> mind if you do that, provided that your patch series can be applied in
> a way that it won't cause regressions for real hot-pluggable hardware.

This is not really about the OMAP3 ISP driver hotplug support; it is indeed
about the framework's ability to support hotpluggable hardware. The current
painpoint is removing hardware; the current frameworks aren't quite up to
that at the moment.

I haven't checked how many plain V4L2 drivers do this correctly but the
problem domain becomes a lot more complex when you add V4L2 sub-device and
Media controller nodes. Having a driver that does implement this correctly
is important for writing new drivers, hence the changes to the OMAP3 ISP
driver.

> 
> I still think that keeping cdev embedded in a structure that it is
> created dynamically when registering the device node, instead of
> embedding it at struct media_device. Yet, if you prove that this does
> more harm than good, I'm ok on re-embeeding it. However, on such case,
> you need to put the patches re-embeeding it at the end of the patch
> series (and not at the beginning), as otherwise you'll be causing
> regressions.
> 
> > One additional reason is that as the omap3isp driver has been used as an
> > example to write a number of other drivers, people do see what's the right
> > way to do these things, instead of copying code from a driver doing it
> > wrong.
> 
> Interesting argument. Yet, IMHO, the best would be to do the proper
> review on the first platform driver that would support hot-plug,
> and use this as an example. It is a shame that project Aurora was
> discontinued, as media drivers for such kind of hardware would be an
> interesting example.
> 
> On that matter, just like we use vivid as a testbench and as an
> example for other drivers, it would be great if we could merge
> the vimc driver. What's the status of Helen's patchset?

That's a good point. I wasn't reviewing that driver back then when the
patches were posted, but should it go in, it should make a good example for
writing other drivers as well.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

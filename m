Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44849
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750914AbdCOAyp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 20:54:45 -0400
Date: Tue, 14 Mar 2017 21:54:31 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: Re: media / v4l2-mc: wishlist for complex cameras (was Re: [PATCH
 v4 14/36] [media] v4l2-mc: add a function to inherit controls from a
 pipeline)
Message-ID: <20170314215420.6fc63c67@vento.lan>
In-Reply-To: <20170314223254.GA7141@amd>
References: <c679f755-52a6-3c6f-3d65-277db46676cc@xs4all.nl>
        <20170310140124.GV21222@n2100.armlinux.org.uk>
        <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
        <20170310125342.7f047acf@vento.lan>
        <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
        <20170311082549.576531d0@vento.lan>
        <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
        <20170314004533.3b3cd44b@vento.lan>
        <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
        <20170314072143.498cde9b@vento.lan>
        <20170314223254.GA7141@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Mar 2017 23:32:54 +0100
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> > > > Even if they were merged, if we keep the same mean time to develop a
> > > > libv4l plugin, that would mean that a plugin for i.MX6 could take 2-3
> > > > years to be developed.
> > > > 
> > > > There's a clear message on it:
> > > > 	- we shouldn't keep pushing for a solution via libv4l.    
> > > 
> > > Or:
> > > 
> > > 	- userspace plugin development had a very a low priority and
> > > 	  never got the attention it needed.  
> > 
> > The end result is the same: we can't count on it.
> >   
> > > 
> > > I know that's *my* reason. I rarely if ever looked at it. I always assumed
> > > Sakari and/or Laurent would look at it. If this reason is also valid for
> > > Sakari and Laurent, then it is no wonder nothing has happened in all that
> > > time.
> > > 
> > > We're all very driver-development-driven, and userspace gets very little
> > > attention in general. So before just throwing in the towel we should take
> > > a good look at the reasons why there has been little or no development: is
> > > it because of fundamental design defects, or because nobody paid attention
> > > to it?  
> > 
> > No. We should look it the other way: basically, there are patches
> > for i.MX6 driver that sends control from videonode to subdevs. 
> > 
> > If we nack apply it, who will write the userspace plugin? When
> > such change will be merged upstream?  
> 
> Well, I believe first question is: what applications would we want to
> run on complex devices? Will sending control from video to subdevs
> actually help?

I would say: camorama, xawtv3, zbar, google talk, skype. If it runs
with those, it will likely run with any other application.

> mplayer is useful for testing... but that one already works (after you
> setup the pipeline, and configure exposure/gain).
> 
> But thats useful for testing, not really for production. Image will be
> out of focus and with wrong white balance.
> 
> What I would really like is an application to get still photos. For
> taking pictures with manual settings we need
> 
> a) units for controls: user wants to focus on 1m, and take picture
> with ISO200, 1/125 sec. We should also tell him that lens is f/5.6 and
> focal length is 20mm with 5mm chip.
> 
> But... autofocus/autogain would really be good to have. Thus we need:
> 
> b) for each frame, we need exposure settings and focus position at
> time frame was taken. Otherwise autofocus/autogain will be too
> slow. At least focus position is going to be tricky -- either kernel
> would have to compute focus position for us (not trivial) or we'd need
> enough information to compute it in userspace.
> 
> There are more problems: hardware-accelerated preview is not trivial
> to set up (and I'm unsure if it can be done in generic way). Still
> photos application needs to switch resolutions between preview and
> photo capture. Probably hardware-accelerated histograms are needed for
> white balance, auto gain and auto focus, ....
> 
> It seems like there's a _lot_ of stuff to be done before we have
> useful support for complex cameras...

Taking still pictures using a hardware-accelerated preview is
a sophisticated use case. I don't know any userspace application
that does that. Ok, several allow taking snapshots, by simply
storing the image of the current frame.

> (And I'm not sure... when application such as skype is running, is
> there some way to run autogain/autofocus/autowhitebalance? Is that
> something we want to support?)

Autofocus no. Autogain/Autowhite can be done via libv4l, provided that
it can access the device's controls via /dev/video devnode. Other
applications may be using some other similar algorithms.

Ok, they don't use histograms provided by the SoC. So, they do it in
software, with is slower. Still, it works fine when the light
conditions don't change too fast.

> > If we don't have answers to any of the above questions, we should not
> > nack it.
> > 
> > That's said, that doesn't prevent merging a libv4l plugin if/when
> > someone can find time/interest to develop it.  
> 
> I believe other question is: will not having same control on main
> video device and subdevs be confusing? Does it actually help userspace
> in any way? Yes, we can make controls accessible to old application,
> but does it make them more useful? 

Yes. As I said, libv4l (and some apps) have logic inside to adjust
the image via bright, contrast and white balance controls, using the
video devnode. They don't talk subdev API. So, if those controls
aren't exported, they won't be able to provide a good quality image.

> > > In addition, I suspect end-users of these complex devices don't really care
> > > about a plugin: they want full control and won't typically use generic
> > > applications. If they would need support for that, we'd have seen much more
> > > interest. The main reason for having a plugin is to simplify testing and
> > > if this is going to be used on cheap hobbyist devkits.  
> > 
> > What are the needs for a cheap hobbyist devkit owner? Do we currently
> > satisfy those needs? I'd say that having a functional driver when
> > compiled without the subdev API, that implements the ioctl's/controls  
> 
> Having different interface based on config options... is just
> weird. What about poor people (like me) trying to develop complex
> applications?

Well, that could be done using other mechanisms, like a modprobe
parameter or by switching the behaviour if a subdev interface is
opened. I don't see much trouble on allowing accessing a control via
both interfaces.

> 
> > [1] Yet, I might eventually do that for fun, an OMAP3 board with tvp5150
> > just arrived here last week. It would be nice to have xawtv3 running on it :-)
> > So, if I have a lot of spare time (with is very unlikely), I might eventually 
> > do something for it to work.
> >   
> > > I know it took me a very long time before I had a working omap3.  
> > 
> > My first OMAP3 board with working V4L2 source just arrived last week
> > :-)  
> 
> You can get Nokia N900 on aliexpress. If not, they are still available
> between people :-)

I have one. Unfortunately, I never had a chance to use it, as the display
stopped working one week after I get it.

Thanks,
Mauro

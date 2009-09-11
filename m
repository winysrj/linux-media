Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33739 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbZIKRE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 13:04:28 -0400
Date: Fri, 11 Sep 2009 14:03:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: RFCv2: Media controller proposal
Message-ID: <20090911140356.7a408159@caramujo.chehab.org>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940436BA522B@dbde02.ent.ti.com>
References: <200909100913.09065.hverkuil@xs4all.nl>
	<20090910172013.55825d2e@caramujo.chehab.org>
	<200909102335.52770.hverkuil@xs4all.nl>
	<20090911121342.08dd1939@caramujo.chehab.org>
	<829197380909110846t493deb9cga3a2af754f2e40cd@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E73940436BA522B@dbde02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Sep 2009 21:23:50 +0530
"Hiremath, Vaibhav" <hvaibhav@ti.com> escreveu:

> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Devin Heitmueller
> > Sent: Friday, September 11, 2009 9:16 PM
> > To: Mauro Carvalho Chehab
> > Cc: Hans Verkuil; linux-media@vger.kernel.org
> > Subject: Re: RFCv2: Media controller proposal
> > 
> > On Fri, Sep 11, 2009 at 11:13 AM, Mauro Carvalho Chehab
> > <mchehab@infradead.org> wrote:
> > > Em Thu, 10 Sep 2009 23:35:52 +0200
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > >
> <snip>
> > >
> > > I was talking not about specific attributes, but about the V4L2
> > API controls
> > > that you may eventually need to "hijack" (using that context-
> > sensitive
> > > thread-unsafe approach you described).
> > >
> > > Anyway, by using sysfs, you won't have any thread issues, since
> > you'll be able
> > > to address each sub-device individually:
> > >
> > > echo 1 >/sys/class/media/mc0/video:dsp0/enable_stats
> > >
> > >
> > >
> > > Cheers,
> > > Mauro
> > 
> > Mauro,
> > 
> > Please, *seriously* reconsider the notion of making sysfs a
> > dependency
> > of V4L.  While sysfs is great for a developer who wants to poke
> > around
> > at various properties from a command line during debugging, it is an
> > absolute nightmare for any developer who wants to write an
> > application
> > in C that is expected to actually use the interface.  The amount of
> > extra code for all the string parsing alone would be ridiculous
> > (think
> > of how many calls you're going to have to make to sscanf or atoi).
> > It's so much more straightforward to be able to have ioctl() calls
> > that can return an actual struct with nice things like enumeration
> > data types etc.

The complexity of the interface will greatly depend on the way things will be
mapped there, and the number of tree levels will be used. Also, as sysfs
accepts soft links, we may have the same node pointed on different places.
This can be useful to ek speed.

In order to have something optimized for application, we can imagine having,
for example, under /sys/class/media/mc0/subdevs, links to all the several subdevs,
like:

	video:vin0
	video:vin1
	audio:audio0
	audio:audio1
	dsp:dsp0
	dsp:dsp0
	dvb:adapter0
	i2c:vin0:tvp5150
	...

each of them being a link to some specific sysfs node, all of this created by
V4L2 core, to be sure that all devices will implement it at the standard way.

If some parameter should be bind, for example at the video input device 0, you
just need to write to a node like:
	/sys/class/media/mc0/subdevs/attr/<atribute>

(all the above names are just examples - we'll need to properly define the
sysfs tree we need to fulfill the requirements).

Also, it should be noticed that you'll need to use sysfs anyway, to get subdev's
major/minor numbers and to associate them with a file name under /dev.

> > 
> > Just my opinion, of course.
> > 
> [Hiremath, Vaibhav] Mauro,
> 
> Definitely SYSFS interface is a nightmare for the application developer, and again we have not thought of backward compatibility here.

What do you mean by backward compatibility? An application using the standard
V4L2 API will keep working, but if they'll use the media controller sysfs, they'll have
extra functionality.

I'm not saying that we should use what we currently have, but to use sysfs to
create standard classes (and/or buses) that fulfill the needs for media
controller to match the RFC requirements.

> How application would know/decide on which node is exist and stuff? Every video board will have his separate way of notions for creating SYSFS nodes and maintaining standard between them would be really mess. 

Yes, but none currently have a media controller node. As sysfs provides links,
we can link the media controller to the old nodes or vice versa (for the few
devices that already have their proper nodes).

> There has to be enumeration kind of interface to make standard application work seamlessly.

That's for sure.



Cheers,
Mauro

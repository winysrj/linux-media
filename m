Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55637 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbZIQMLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 08:11:41 -0400
Date: Thu, 17 Sep 2009 09:11:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: RFCv2: Media controller proposal
Message-ID: <20090917091104.34806d1e@pedra.chehab.org>
In-Reply-To: <200909170834.23449.hverkuil@xs4all.nl>
References: <200909100913.09065.hverkuil@xs4all.nl>
	<20090916175043.0d462a18@pedra.chehab.org>
	<A69FA2915331DC488A831521EAE36FE40155157118@dlee06.ent.ti.com>
	<200909170834.23449.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Sep 2009 08:34:23 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Thursday 17 September 2009 00:28:38 Karicheri, Muralidharan wrote:
> > >
> > >> And as I explained above, a v4l2_subdev just implements an interface. It
> > >has
> > >> no relation to devices. And yes, I'm beginning to agree with you that
> > >subdevice
> > >> was a bad name because it suggested something that it simply isn't.
> > >>
> > >> That said, I also see some advantages in doing this. For statistics or
> > >> histogram sub-devices you can implement a read() call to read the data
> > >> instead of using ioctl. It is more flexible in that respect.
> > >
> > >I think this will be more flexible and will be less complex than creating a
> > >proxy
> > >device. For example, as you'll be directly addressing a device, you don't
> > >need to
> > >have any locking to avoid the risk that different threads accessing
> > >different
> > >sub-devices at the same time would result on a command sending to the wrong
> > >device.
> > >So, both kernel driver and userspace app can be simpler.
> > 
> > 
> > Not really. User application trying to parse the output of a histogram which
> > really will about 4K in size as described by Laurent. Imagine application does lot of parsing to decode the values thrown by the sysfs. Again on different platform, they can be different formats. With ioctl, each of these platforms provides api to access them and it is much simpler to use. Same for configuring IPIPE on DM355/DM365 where there are hundreds of parameters and write a lot of code in sysfs to parse each of these variables. I can see it as a nightmare for user space library or application developer.
> 
> I believe Mauro was talking about normal device nodes, not sysfs.

Yes.

> What is a bit more complex in Mauro's scheme is that to get hold of the right
> device node needed to access a sub-device you will need to first get the
> subdev's entity information from the media controller, then go to libudev to
> translate major/minor numbers to an actual device path, and then open that.

Good point. This reforces my thesis that the media controller (or, at least his
enumeration function) will be better done via sysfs.

As Andy pointed, one of the biggest advantages is that udev can enrich the
user's experience by calling some tweak applications or by calling special
applications (like lirc) when certain media devices are created.

Cheers,
Mauro

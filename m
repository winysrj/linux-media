Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40924 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbZA2KWb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 05:22:31 -0500
Date: Thu, 29 Jan 2009 08:22:04 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Michael Schimek <mschimek@gmx.at>
Subject: Re: Merging the v4l2 spec?
Message-ID: <20090129082204.48aceb4c@caramujo.chehab.org>
In-Reply-To: <200901291037.55037.hverkuil@xs4all.nl>
References: <200901290951.04874.hverkuil@xs4all.nl>
	<20090129073056.675dd4b4@caramujo.chehab.org>
	<200901291037.55037.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009 10:37:54 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Thursday 29 January 2009 10:30:56 Mauro Carvalho Chehab wrote:
> > On Thu, 29 Jan 2009 09:51:04 +0100
> >
> > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > Hi Mauro,
> > >
> > > Is it possible to merge the v4l2 spec from my tree soon? With all the
> > > various new API additions that are being discussed it would help a lot
> > > if they can also make patches against the documentation at the same
> > > time.
> >
> > I'd like to give a few more days to Michael Schimek to ack on this. Since
> > we are in a period of the year where lots of people gets vacation, it is
> > better to give Michael some more time on this.
> 
> I haven't heard from him since my first mail on this subject on December 
> 7th. That's almost two months ago! Even in Europe people don't have that 
> much vacation time :-)

:) Let's wait until Feb. Then, if we don't have any answer from him, I'll merge
it.
> 
> > > BTW, I'm working on improving the qv4l2 tool to make it much more
> > > useful for testing. I'm integrating it with the v4lconvert lib and
> > > added capture support as well. It should become a proper testbench for
> > > drivers. All the other tools around are really crappy, so I decided to
> > > extend qv4l2 instead.
> >
> > Good news! IMO, you should also add the new tool to get sysfs patch
> > integrated on it. I was planning to do it later, but, since you're
> > already working with qv4l2, maybe you can add this feature on it as well.
> > The drawback is that it requires libsysfs-devel in order to compile.
> > Maybe this can be an optional feature.
> 
> Can you give me a pointer? I've no idea what you are referring to.

v4l2-apps/util/v4l2_sysfs_path.c

There were some discussions that started on pvrusb2 about how to uniquely
identify a /dev/video that ended on standardizing the way the USB drivers
answers at bus_info on VIDIOC_QUERYCAP. With the current status, the above
utility is capable of retrieving the proper sysfs path for a given device.
Using that info, it is possible not only to know if a device is unique, but
also know that the device has DVB, ALSA and INPUT modules associated.

> > > I've also bought a bunch of old hardware from ebay. I should be able to
> > > test various old v4l1 drivers and convert them to v4l2. I basically
> > > want to be able to test pretty much the whole v4l2 API, preferably with
> > > qv4l2. Yesterday two webcams came in, so I can now test w9968cf and
> > > se401.
> >
> > Great! IMO, the better would be to make those cams as sub-drivers of
> > gspca.
> 
> That was my idea as well.

Good.

> > > Check out my qv4l2 tree for progress on this tool!
> >
> > I'll take a look soon.
> >
> > > Now all I need is lots more time :-(
> >
> > I know what you're meaning... I'm also needing more time here... I just
> > wrote some tools to help me with patchwork stuff. Hopefully, this week,
> > I'll have all pending patches (there that aren't being reviewed by
> > somebody else) updated.
> 
> Cool.

Ok, most of the patches there were already handled.

Cheers,
Mauro

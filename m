Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:61195 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843Ab0ISSiO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 14:38:14 -0400
Subject: Re: RFC: BKL, locking and ioctls
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <201009191810.34189.hverkuil@xs4all.nl>
References: <fm127xqs7xbmiabppyr1ifai.1284910330767@email.android.com>
	 <201009191810.34189.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 14:38:02 -0400
Message-ID: <1284921482.2079.57.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2010-09-19 at 18:10 +0200, Hans Verkuil wrote:
> On Sunday, September 19, 2010 17:38:18 Andy Walls wrote:
> > The device node isn't even the right place for drivers that provide
> multiple device nodes that can possibly access the same underlying
> data or register sets.
> > 
> > Any core/infrastructure approach is likely doomed in the general
> case.  It's trying to protect data and registers in a driver it knows
> nothing about, by protecting the *code paths* that take essentially
> unknown actions on that data and registers. :{
> 
> Just to clarify: struct video_device gets a *pointer* to a mutex. The mutex
> itself can be either at the top-level device or associated with the actual
> video device, depending on the requirements of the driver.

OK.  Or the mutex can be NULL, where the driver does everything for
itself.

Locking at the device node level for ioctl()'s is better than the
v4l2_fh proposal, which serializes too much in some contexts and not
enough for others.

<obvious>
Any driver that creates ALSA, dvb, or fb device nodes, or another video
device node, with access to the same underlying data structures or
registers, will still need to perform proper locking.  The lock for the
ioctl() code paths will have to apply at a higher level than the device
node in these cases.
</obvious>

We're still preserving one of the main headaches of the BKL: "What
exactly is this lock protecting in this driver?".  We're just adding a
smaller scoped version to our own infrastructure.  At least maybe for
ioctl()'s in v4l2 the answer to the question is simpler: we're generally
protecting against concurrent access to the many and varied
v4l2_subdev's.
(Although that doesn't apply to VIDIOC_QUERYCAP and similar ioctl()'s.)


> > Videobuf is the right place to protect videobuf data.
> 
> vb_lock is AFAIK there to protect the streaming of data. And that's definitely
> per device node since only one filehandle per device node can do streaming.
> 
> Also remember that we are trying to get rid of the BKL, so staying bug-compatible
> is enough for a first version :-)

Sure.

Regards,
Andy


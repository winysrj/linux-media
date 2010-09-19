Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2497 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab0ISTqP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 15:46:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: RFC: BKL, locking and ioctls
Date: Sun, 19 Sep 2010 21:45:52 +0200
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
References: <fm127xqs7xbmiabppyr1ifai.1284910330767@email.android.com> <4C96600E.8090905@redhat.com> <201009192138.08412.hverkuil@xs4all.nl>
In-Reply-To: <201009192138.08412.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009192145.52914.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, September 19, 2010 21:38:08 Hans Verkuil wrote:
> On Sunday, September 19, 2010 21:10:06 Mauro Carvalho Chehab wrote:
> > Em 19-09-2010 15:38, Andy Walls escreveu:
> > > On Sun, 2010-09-19 at 18:10 +0200, Hans Verkuil wrote:
> > >> On Sunday, September 19, 2010 17:38:18 Andy Walls wrote:
> > >>> The device node isn't even the right place for drivers that provide
> > >> multiple device nodes that can possibly access the same underlying
> > >> data or register sets.
> > >>>
> > >>> Any core/infrastructure approach is likely doomed in the general
> > >> case.  It's trying to protect data and registers in a driver it knows
> > >> nothing about, by protecting the *code paths* that take essentially
> > >> unknown actions on that data and registers. :{
> > >>
> > >> Just to clarify: struct video_device gets a *pointer* to a mutex. The mutex
> > >> itself can be either at the top-level device or associated with the actual
> > >> video device, depending on the requirements of the driver.
> > > 
> > > OK.  Or the mutex can be NULL, where the driver does everything for
> > > itself.
> > 
> > Yes. If you don't like it, or have a better idea, you can just pass NULL
> > and do whatever you want on your driver.
> > > 
> > > Locking at the device node level for ioctl()'s is better than the
> > > v4l2_fh proposal, which serializes too much in some contexts and not
> > > enough for others.
> > 
> > The per-fh allows fine graining when needed. As it is a pointer, you can opt
> > to have per-device or per-fh locks (or even per-driver lock).
> > Open/close/mmap/read/poll need to be serialized anyway, as they generally
> > touch at the same data that you need to protect on ioctl.
> > 
> > By having a global locking schema like that, it is better to over-protect than
> > to leave some race conditions.
> 
> That makes no sense. It is overly fine-grained locking schemes that lead to
> race conditions. Overly course-grained schemes can lead to performance issues.
> The problem is finding the right balance. Which to me is at the device node
> level. AFAIK there is not a single driver that does locking at the file handle
> level. It's either at the top level or at the device node level (usually through
> videobuf's vb_lock).

BTW, something I just thought of: every V4L driver has by definition a video_device
struct. But there are still drivers that don't have the top-level v4l2_device struct
and many that do not have the v4l2_fh struct. So struct video_device is also the
place of the least impact on drivers.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

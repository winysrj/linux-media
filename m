Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52700 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab2ENOMO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 10:12:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 5/5] v4l2-dev: add flag to have the core lock all file operations.
Date: Mon, 14 May 2012 16:12:22 +0200
Message-ID: <2327692.A1DZxDNp18@avalon>
In-Reply-To: <201205141542.37504.hverkuil@xs4all.nl>
References: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl> <9761581.bJ0QrOc7Gv@avalon> <201205141542.37504.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 14 May 2012 15:42:37 Hans Verkuil wrote:
> On Mon May 14 2012 14:31:32 Laurent Pinchart wrote:
> > On Thursday 10 May 2012 09:05:14 Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > This used to be the default if the lock pointer was set, but now that
> > > lock is by default only used for ioctl serialization.
> > 
> > Shouldn't that be documented ?
> > Documentation/video4linux/v4l2-framework.txt
> > still states that the lock is taken for each file operation.
> 
> I'd have sworn I'd done that, but obviously my memory is playing tricks on
> me.
> 
> Will fix.

Thanks.

> > > Those drivers that already used core locking have this flag set
> > > explicitly, except for some drivers where it was obvious that there was
> > > no need to serialize any file operations other than ioctl.
> > > 
> > > The drivers that didn't need this flag were:
> > > 
> > > drivers/media/radio/dsbr100.c
> > > drivers/media/radio/radio-isa.c
> > > drivers/media/radio/radio-keene.c
> > > drivers/media/radio/radio-miropcm20.c
> > > drivers/media/radio/radio-mr800.c
> > > drivers/media/radio/radio-tea5764.c
> > > drivers/media/radio/radio-timb.c
> > > drivers/media/video/vivi.c
> > > sound/i2c/other/tea575x-tuner.c
> > 
> > Be careful that drivers for hot-pluggable devices can use the core lock to
> > serialize open/disconnect. The dsbr100 driver takes the core lock in its
> > disconnect handler for instance. Have you double-checked that no race
> > condition exists in those cases ?
> 
> Yes. This drivers use core helper functions for open/release/poll where we
> know that there is no race condition.
> 
> > > The other drivers that use core locking and where it was not immediately
> > > obvious that this flag wasn't needed were changed so that the flag is
> > > set together with a comment that that driver needs work to avoid having
> > > to set that flag. This will often involve taking the core lock in the
> > > fops themselves.
> > 
> > Or not using the core lock :-)
> > 
> > > Eventually this flag should go and it should not be used in new drivers.
> > 
> > Could you please add a comment above the flag to state that new drivers
> > must not use it ?
> 
> Good one. Will do.
> 
> > > There are a few reasons why we want to avoid core locking of non-ioctl
> > > fops: in the case of mmap this can lead to a deadlock in rare situations
> > > since when mmap is called the mmap_sem is held and it is possible for
> > > other parts of the code to take that lock as well
> > > (copy_from_user()/copy_to_user() perform a down_read(&mm->mmap_sem) when
> > > a page fault occurs).
> > 
> > This patch won't solve the problem. We have (at least) two AB-BA deadlock
> > issues with the mm->mmap_sem. Both of them share the fact that the mmap()
> > handler is called with mm->mmap_sem held and will then take a
> > device-related lock (could be a global driver lock, a device-wide lock or
> > a queue-specific lock). I don't think we can do anything about that.
> > 
> > The first problem was solved some time ago. VIDIOC_QBUF is called with the
> > same device-related lock held and then needs to take mm->mmap_sem. We
> > solved that be calling the queue wait_prepare() and wait_finish() around
> > down(&mm-> 
> > >mmap_sem) and up(&mm->mmap_sem). Maybe not ideal, but that seems to work.
> > 
> > The second problem comes from the copy_from_user()/copy_to_user() code in
> > video_usercopy(). That function is called by video_ioctl2() which is
> > itself called with the device lock held. Copying from/to user can fault if
> > the userspace memory has been paged out, in which case the fault handler
> > needs to take mm->mmap_sem to solve the fault. This can deadlock with
> > mmap().
> > 
> > To solve the second issue we must delay taking the device lock until after
> > copying from user, as we can't forbid the mmap() handler from taking the
> > device lock (that would introduce race conditions). I think that can be
> > done by pushing the device lock into __video_do_ioctl.
> 
> Good idea, but for 3.6. This will be a nice one to combine with my
> v4l2-ioctl.c reorganization.

I'm fine with 3.6, but then I'd appreciate if you could reword your commit 
message. It gives the false impression that this commit solves the issue.

-- 
Regards,

Laurent Pinchart


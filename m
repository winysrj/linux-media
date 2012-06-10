Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1398 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2FJRdF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 13:33:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1 PATCH 00/32] Core and vb2 enhancements
Date: Sun, 10 Jun 2012 19:32:36 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <4FD4CF7C.3020000@redhat.com>
In-Reply-To: <4FD4CF7C.3020000@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206101932.36886.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun June 10 2012 18:46:52 Mauro Carvalho Chehab wrote:
> Em 10-06-2012 07:25, Hans Verkuil escreveu:
> > Hi all,
> > 
> > This large patch series makes a number of changes to the core (ioctl
> > handling in particular) and vb2. It all builds on one another, so there
> > wasn't much point in splitting it. Most patches are fairly trivial, so it
> > is not as bad as it looks :-)
> > 
> > I will go through the patches one by one:
> > 
> > - Regression fixes.
> > 
> > This is a small patch that fixes a number of regressions that are relevant to
> > this patch series. These fixes have already been posted to the list.
> > 
> > - v4l2-ioctl.c: move a block of code down, no other changes.
> > 
> > Just move code around, no other changes.
> > 
> > - v4l2-ioctl.c: introduce INFO_FL_CLEAR to replace switch.
> > 
> > This replaces the switch that determines how much of the struct needs to be
> > copied from userspace with a simple table lookup.
> > 
> > - v4l2-ioctl.c: v4l2-ioctl: add debug and callback/offset functionality.
> > 
> > Prepare for the next step where the large switch is replaced by table lookups.
> > 
> > - v4l2-ioctl.c: remove an unnecessary #ifdef.
> > 
> > A small fix for the table: keep the DBG_G/S_REGISTER ioctl in the table. All
> > the right checks are already made, and this way you will actually see the ioctl
> > name in the debug messages if you use it.
> > 
> > - v4l2-ioctl.c: use the new table for querycap and i/o ioctls.
> > - v4l2-ioctl.c: use the new table for priority ioctls.
> > - v4l2-ioctl.c: use the new table for format/framebuffer ioctls.
> > - v4l2-ioctl.c: use the new table for overlay/streamon/off ioctls.
> > - v4l2-ioctl.c: use the new table for std/tuner/modulator ioctls.
> > - v4l2-ioctl.c: use the new table for queuing/parm ioctls.
> > - v4l2-ioctl.c: use the new table for control ioctls.
> > - v4l2-ioctl.c: use the new table for selection ioctls.
> > - v4l2-ioctl.c: use the new table for compression ioctls.
> > - v4l2-ioctl.c: use the new table for debug ioctls.
> > - v4l2-ioctl.c: use the new table for preset/timings ioctls.
> > - v4l2-ioctl.c: use the new table for the remaining ioctls.
> > 
> > Here the switch is replaced by table lookups section-by-section.
> > 
> > - v4l2-ioctl.c: finalize table conversion.
> > 
> > Remove the last part of the switch.
> > 
> > - v4l2-dev.c: add debug sysfs entry.
> > 
> > The video_device debug field is pretty useful, if only you could set it. The
> > solution is simple: export it in sysfs. That way you can easily set the debug
> > level per device node. Works like a charm.
> > 
> > - v4l2-ioctl: remove v4l_(i2c_)print_ioctl
> > 
> > Clean up a few rarely used macros.
> > 
> > - ivtv: don't mess with vfd->debug.
> > - cx18: don't mess with vfd->debug.
> > 
> > Rely on the new sysfs debug mechanism instead.
> > 
> > - v4l2-dev/ioctl.c: add vb2_queue support to video_device.
> > 
> > Add core support for vb2 to struct video_device. This will be used in the next patch.
> > Note: this assumes that there is no more than one vb2_queue per device node. So this
> > can't be used for mem2mem.
> > 
> > - videobuf2-core: add helper functions.
> > 
> > These helpers simplify using vb2: If you set vdev->queue and vdev->queue_lock then these
> > helpers will take care of queue ownership and locking. So as soon as REQBUFS or
> > CREATE_BUFFERS is called, that file handle owns the queue and no other filehandle can do
> > anything with it except for QUERYBUF and mmap. I'm not sure about mmap: should that also
> > be limited to the owner?
> > 
> > The locking has been changed: it is now possible to specify a mutex that protects the
> > queue (vdev->queue_lock), and that will be taken instead of the core lock (vdev->lock) when
> > the vb2 ioctls are called. If you need to serialize against the core lock, then you should
> > take that lock in the vb2 ops you implemented. So queue_lock is always taken before vdev->lock.
> > 
> > This approach should remove the need for disabling locking for specific ioctls which was
> > introduced in 3.5. I believe that was the wrong approach.
> > 
> > I have refactored reqbufs and request_buffers a bit: they call the same code to check for
> > valid memory and buffer types. In addition, these functions will always return -EINVAL if
> > the types are invalid, and only then will they check for busy state. That way code like qv4l2
> > that tries to detect which memory types are available can still do that, even if streaming
> > is in progress. Currently you can get -EBUSY back and that hides whether the memory type
> > was valid.
> > 
> > create_buffers now also supports count == 0: if count == 0, then you will never get -EBUSY.
> > 
> > - create_bufs: handle count == 0.
> > 
> > Update documentation.
> > 
> > - vivi: remove pointless g/s_std support
> > - vivi: embed struct video_device instead of allocating it.
> > - vivi: use vb2 helper functions.
> > 
> > Two vivi cleanups and implement the vb2 helpers in vivi.
> > 
> > - v4l2-dev.c: also add debug support for the fops.
> > 
> > Show debugging when the fops are called if vdev->debug is set.
> > 
> > - v4l2-ioctl.c: shorten the lines of the table.
> > 
> > Make the ioctl table more readable.
> > 
> > - pwc: use the new vb2 helpers.
> > 
> > Implement the vb2 helpers in pwc.
> > 
> > - pwc: v4l2-compliance fixes.
> > 
> > Fix some complaints from v4l2-compliance.
> > 
> > This patch series is also available here:
> > 
> > git://linuxtv.org/hverkuil/media_tree.git ioctlv5
> > 
> > Personally I think that the table conversion is fairly trivial (just a lot of work).
> > The interesting bits are with the new debug sysfs entry, the vb2 helpers and the way
> > the core handles vb2 locking (and yes, you don't have to use vb2 locking, but then
> > you most likely still have to write wrapper functions).
> > 
> > Comments? Ideas?
> > 
> 
> I just a quick look at the patch series, but I have a few generic
> comments:
> 
> 1) Why are you commenting things on patch 0/0, instead of adding a better description
> inside each patch? Some patches deserve descriptions, like this one "v4l2-ioctl.c: finalize table conversion."
> The description says nothing, and it seems that it does more than just "Remove the last part of the switch"
> as said above.

For this particular patch it should have said:

"To finalize the table conversion implement the default case and remove the switch."

And I agree that the descriptions can be improved. Something for RFCv2.

> 2) The check you're using to know if an ioctl exists is:
> 
> 1948 bool v4l2_is_known_ioctl(unsigned int cmd)
> 1949 {
> 1950         if (_IOC_NR(cmd) >= V4L2_IOCTLS)
> 1951                 return false;
> 1952         return v4l2_ioctls[_IOC_NR(cmd)].ioctl == cmd;
> 1953 }
> 
> That assumes that: 
> 	a) there's just one ioctl using the same number.

Correct.

> 	b) all ioctl's using numbers from 0 to ARRAY_SIZE(v4l2_ioctls) are valid;

No. The invalid ioctls have an empty entry in the table, so for those
v4l2_ioctls[_IOC_NR(cmd)].ioctl == 0, and 0 != cmd. So these are automatically
marked as invalid.

> 
> With regards to (a), an ioctl code is given not only by its number, but also by
> its size, it could be possible that two ioctls would share the same number,
> but having different sizes.
> 
> Subsystems like input use that for some things: there, GET/SET ioctl's share
> the same number (with different read/write flags). Also, different versions
> of an ioctl uses different struct sizes.
> 
> We currently don't use this way (although it migh be required in the future, if we
> need to extend some ioctl out of the current reserved range). So, it may be
> interesting to add some note there about the current restriction added by this
> patchset.

Good idea.

> With regards to (b), this is more serious, as, if an ioctl number is not used, the
> code may be doing wrong things (and even OOPSing). 
> 
> There are actually some unused numbers: 3, 6, 7, ... Also, as time goes by, ioctl's
> can be deprecated and removed (like VIDIOC_G_JPEGCOMP/VIDIOC_S_JPEGCOMP). So,
> it is important to actually look inside one of the ioctl fields, to check if the table
> entry is really filled.
> 
> 3) it would be interesting if you could benchmark the previous code and the new
> one, to see what gains this change introduced, in terms of v4l2-core footprint and
> performance.

I'll try that, should be interesting. Actually, my prediction is that I won't notice any
difference. Todays CPUs are so fast that the overhead of the switch is probably hard to
measure.

Regards,

	Hans

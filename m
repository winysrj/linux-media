Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:48670 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab0EFNCi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 09:02:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [videobuf] Query: Condition bytesize limit in videobuf_reqbufs -> buf_setup() call?
Date: Thu, 6 May 2010 15:03:16 +0200
Cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE894455257D13@dlee02.ent.ti.com> <201005061009.08474.laurent.pinchart@ideasonboard.com> <4BE2B84C.1060607@redhat.com>
In-Reply-To: <4BE2B84C.1060607@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005061503.17806.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 06 May 2010 14:38:36 Mauro Carvalho Chehab wrote:
> Laurent Pinchart wrote:
> > On Thursday 06 May 2010 01:29:54 Aguirre, Sergio wrote:
> >>> -----Original Message-----
> >>> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
> >>> Sent: Wednesday, May 05, 2010 6:24 PM
> >>> To: Aguirre, Sergio
> >>> Cc: linux-media@vger.kernel.org
> >>> Subject: Re: [videobuf] Query: Condition bytesize limit in
> >>> videobuf_reqbufs -> buf_setup() call?
> >>> 
> >>> Aguirre, Sergio wrote:
> >>>> Hi all,
> >>>> 
> >>>> While working on an old port of the omap3 camera-isp driver,
> >>>> I have faced some problem.
> >>>> 
> >>>> Basically, when calling VIDIOC_REQBUFS with a certain buffer
> >>>> 
> >>>> Count, we had a software limit for total size, calculated depending on:
> >>>>   Total bytesize = bytesperline x height x count
> >>>> 
> >>>> So, we had an arbitrary limit to, say 32 MB, which was generic.
> >>>> 
> >>>> Now, we want to condition it ONLY when MMAP buffers will be used.
> >>>> Meaning, we don't want to keep that policy when the kernel is not
> >>>> allocating the space
> >>>> 
> >>>> But the thing is that, according to videobuf documentation, buf_setup
> >>>> is the one who should put a RAM usage limit. BUT the memory type
> >>>> passed to reqbufs is not propagated to buf_setup, therefore forcing me
> >>>> to go to a non-standard memory limitation in my reqbufs callback
> >>>> function, instead of doing it properly inside buf_setup.
> >>>> 
> >>>> Is this scenario a good consideration to change buf_setup API, and
> >>>> propagate buffers memory type aswell?
> >>> 
> >>> I don't see any problem on propagating the memory type to buffer_setup,
> >>> if this is really needed. Yet, I can't see why you would restrict the
> >>> buffer size to 32 MB on one case, and not restrict the size at all with
> >>> non-MMAP types.
> >> 
> >> Ok, my reason for doing that is because I thought that there should be a
> >> memory limit in whichever place you're doing the buffer allocations.
> >> 
> >> MMAP is allocating buffers in kernel, so kernel should provide a memory
> >> restriction, if applies.
> >> 
> >> USERPTR is allocating buffers in userspace, so userspace should provide
> >> a memory restriction, if applies.
> > 
> > I agree with the intend here, but not with the current implementation
> > which has a hardcoded arbitrary limit. Do you think it would be possible
> > to compute a meaningful default limit in the V4L2 core, with a way for
> > userspace to modify it (with root privileges of course) ?
> 
> On almost all drivers, the limit is not arbitrary. It is a reasonable
> number of buffers (like 16 buffers). A limit in terms of the number of
> buffers is meaningful for V4L2 API, and also, has a "physical meaning":
> considering that almost all drivers that use videobuf can do at maximum 30
> fps, 16 buffers mean that the maximum delay that the driver will apply to
> the stream is 533 ms.
> 
> Some drivers even provide a modprobe parameter to allow changing this limit
> (for example, bttv allows changing it up to 32 buffers), but only during
> module load time. I can't foresee any use case where this maximum limit
> would need to be dynamically adjusted. Root can always change it by
> removing and re-inserting the module with a new maximum size.

I wasn't talking about the limit on the number of buffers, but on the amount 
of memory. That's what Sergio was mentioning, and that's what is done in the 
OMAP3 ISP driver.

-- 
Regards,

Laurent Pinchart

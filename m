Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:49062 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab0EFOvx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 10:51:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [videobuf] Query: Condition bytesize limit in videobuf_reqbufs -> buf_setup() call?
Date: Thu, 6 May 2010 16:52:21 +0200
Cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE894455257D13@dlee02.ent.ti.com> <201005061503.17806.laurent.pinchart@ideasonboard.com> <4BE2C2BE.3020904@redhat.com>
In-Reply-To: <4BE2C2BE.3020904@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005061652.24464.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 06 May 2010 15:23:10 Mauro Carvalho Chehab wrote:
> Laurent Pinchart wrote:
> > On Thursday 06 May 2010 14:38:36 Mauro Carvalho Chehab wrote:
> >> Laurent Pinchart wrote:
> >>> On Thursday 06 May 2010 01:29:54 Aguirre, Sergio wrote:
> >>>>> -----Original Message-----
> >>>>> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
> >>>>> Sent: Wednesday, May 05, 2010 6:24 PM
> >>>>> To: Aguirre, Sergio
> >>>>> Cc: linux-media@vger.kernel.org
> >>>>> Subject: Re: [videobuf] Query: Condition bytesize limit in
> >>>>> videobuf_reqbufs -> buf_setup() call?

[snip]

> >>>>> I don't see any problem on propagating the memory type to
> >>>>> buffer_setup, if this is really needed. Yet, I can't see why you
> >>>>> would restrict the buffer size to 32 MB on one case, and not
> >>>>> restrict the size at all with non-MMAP types.
> >>>> 
> >>>> Ok, my reason for doing that is because I thought that there should be
> >>>> a memory limit in whichever place you're doing the buffer
> >>>> allocations.
> >>>> 
> >>>> MMAP is allocating buffers in kernel, so kernel should provide a
> >>>> memory restriction, if applies.
> >>>> 
> >>>> USERPTR is allocating buffers in userspace, so userspace should
> >>>> provide a memory restriction, if applies.
> >>> 
> >>> I agree with the intend here, but not with the current implementation
> >>> which has a hardcoded arbitrary limit. Do you think it would be
> >>> possible to compute a meaningful default limit in the V4L2 core, with
> >>> a way for userspace to modify it (with root privileges of course) ?
> >> 
> >> On almost all drivers, the limit is not arbitrary. It is a reasonable
> >> number of buffers (like 16 buffers). A limit in terms of the number of
> >> buffers is meaningful for V4L2 API, and also, has a "physical meaning":
> >> considering that almost all drivers that use videobuf can do at maximum
> >> 30 fps, 16 buffers mean that the maximum delay that the driver will
> >> apply to the stream is 533 ms.
> >> 
> >> Some drivers even provide a modprobe parameter to allow changing this
> >> limit (for example, bttv allows changing it up to 32 buffers), but only
> >> during module load time. I can't foresee any use case where this
> >> maximum limit would need to be dynamically adjusted. Root can always
> >> change it by removing and re-inserting the module with a new maximum
> >> size.
> > 
> > I wasn't talking about the limit on the number of buffers, but on the
> > amount of memory. That's what Sergio was mentioning, and that's what is
> > done in the OMAP3 ISP driver.
> 
> The memory consumption is basically dictated by the maximum size of an
> image (resolution x bpp / 8) and the number of buffers. An arbitrary value
> in terms of megabytes is meaningless: it is just a random number above
> some reasonable limit.
> 
> The proper way to limit memory is to do something like:
> 
> #define MAX_HRES	1920
> #define MAX_VRES	1650
> #define MAX_DEPTH	3
> #define MAX_BUFS	4
> 
> #define MAX_MEMSIZE	(MAX_HRES * MAX_VRES * MAX_DEPTH * MAX_BUFS)
> 
> buf_setup(...)
> {
> 	if (size > MAX_MEMSIZE)
> 		fix_it_by_reducing_number_of_buffers();
> }

That's what we do. The limit is this not a number of buffers, but a memory 
limit. You an allocate more than 4 buffers in small resolutions. This is still 
a somewhat arbitrary limit. The OMAP3 ISP driver has 7 video nodes (a 8th one 
is possible). If we let userspace application allocate 3 buffers of the 
maximum size (think about 4096x4096 and 2 bytes per pixel, could be even 
higher for some of the blocks), the total is 256MB. That's quite a lot. A 
device-global memory limit might need to be enforced.

-- 
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60092 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2JJNeH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 09:34:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv9 00/25] Integration of videobuf2 with DMABUF
Date: Wed, 10 Oct 2012 15:34:50 +0200
Message-ID: <3949478.Zn3eOk6i7V@avalon>
In-Reply-To: <20121010075418.6a18a867@redhat.com>
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com> <20121010075418.6a18a867@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 10 October 2012 07:54:18 Mauro Carvalho Chehab wrote:
> Em Tue, 02 Oct 2012 16:27:11 +0200 Tomasz Stanislawski escreveu:
> > Hello everyone,
> > This patchset adds support for DMABUF [2] importing and exporting to V4L2
> > stack.
> > 
> > v9:
> > - rebase on 3.6
> > - change type for fs to __s32
> > - add support for vb2_ioctl_expbuf
> > - remove patch 'v4l: vb2: add support for DMA_ATTR_NO_KERNEL_MAPPING',
> >   it will be posted as a separate patch
> > - fix typos and style in Documentation (from Hans Verkuil)
> > - only vb2-core and vb2-dma-contig selects DMA_SHARED_BUFFER in Kconfig
> > - use data_offset and length while queueing DMABUF
> > - return the most recently used fd at VIDIOC_DQBUF
> > - use (buffer-type, index, plane) tuple instead of mem_offset
> >   to identify a for exporting (from Hans Verkuil)
> > - support for DMABUF mmap in vb2-dma-contig (from Laurent Pinchart)
> > - add testing alignment of vaddr and size while verifying userptr
> >   against DMA capabilities (from Laurent Pinchart)
> > - substitute VM_DONTDUMP with VM_RESERVED
> > - simplify error handling in vb2_dc_get_dmabuf (from Laurent Pinchart)
> 
> For now, NACK. See below.
> 
> I spent 4 days trying to setup an environment that would allow testing
> DMABUF with video4linux without success (long story, see below). Also,
> Laurent tried the same without any luck, and it seems that it even
> corrupted his test machine.

To be exact, the i915 driver crashed, not due to DMABUF but because it lacks 
support for YUV frame buffer on the CRTC (YUV is only supported in extra 
planes) and failed to properly reject the set mode ioctl.

My test machine is doing fine :-)

I'll modify the test application to create a YUV plane and will let you know 
about the result.

> Basically Samsung generously donated me two boards that it could be
> used on this test (Origen and SMDK310). None of them actually worked
> with the upstream kernel: patches are needed to avoid OOPSes on
> Origen; both Origen/SMDK310 defconfigs are completely broken, and drivers
> don't even boot if someone tries to use the Kernel's defconfigs.
> 
> Even after spending _days_ trying to figure out the needed .config options
> (as the config files are not easily available), both boards have... issues:
> 
> 	- lack of any display output driver at SMDK310;
> 
> 	- lack of any network driver at Origen: it seems that none of
> the available network options on Origen was upstreamed: no Bluetooth, no
> OTG, no Wifi.
> 
> The only test I was able to do (yesterday, late night), the DMABUF caused
> an OOPS at the Origen board. So, for sure it is not ready for upstream.
> 
> It is now, too late for 3.7. I might consider it to 3.8, if something
> can be done to fix the existing issues, and setup a proper setup, using
> the upstream Kernel.

-- 
Regards,

Laurent Pinchart


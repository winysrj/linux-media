Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:45719 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab3JCOAu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Oct 2013 10:00:50 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-mips@linux-mips.org, linux-media@vger.kernel.org
Date: Thu, 03 Oct 2013 16:00:47 +0200
MIME-Version: 1.0
Message-ID: <m3eh82a1yo.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Suspected cache coherency problem on V4L2 and AR7100 CPU
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm debugging a problem with a SOLO6110-based H.264 PCI video encoder on
Atheros AR7100-based (MIPS, big-endian) platform.

The problem manifests itself with stale data being returned by the
driver (using ioctl VIDIOC_DQBUF). The stale date always starts and ends
on 32-byte cache line boundary.

The driver is drivers/staging/media/solo6x10.

Initially I thought the encoder hardware is at fault (though it works on
i686 and on (both endians) ARM). But I've eliminated actual DMA accesses
from the driver and the problems still persists.

The control flow is now basically the following:
- userspace program initializes the adapter and allocates 192 KB long
  buffers (at least 2 of them):
	open(/dev/video1);

	various ioctl() calls

	for (cnt = 0; cnt < buffer_count; cnt++) {
		struct v4l2_buffer buf = {
			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
			.memory = V4L2_MEMORY_MMAP,
			.index = cnt,
		};
		ioctl(stream->fd, VIDIOC_QUERYBUF, &buf);
		mmap(NULL, buf.length, PROT_READ | PROT_WRITE, MAP_SHARED, stream->fd, buf.m.offset);
        }

and then:

	for (cnt = 0; cnt < buffer_count; cnt++) {
		struct v4l2_buffer buf = {
			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
			.memory = V4L2_MEMORY_MMAP,
			.index = cnt,
		ioctl(stream->fd, VIDIOC_QBUF, &buf);
	}

The buffers are now queued. The driver (upon receiving an encoded frame)
now mostly does:

	various spin_lock() etc.
	vb = list_first_entry(&solo_enc->vidq_active, struct solo_vb2_buf, list);
	list_del(&vb->list);

	struct vb2_dma_sg_desc *vbuf = vb2_dma_sg_plane_desc(vb, 0);

        /* now we have vbuf->sglist which corresponds to a single
	userspace 192-KB buffer */

	vb2_set_plane_payload(vb, 0, 1024 /* bytes */);

	static u32 n = 0; /* a counter to mark each buffer */

        /* the following is normally done using dma_map_sg() and DMA,
        and also with sg_copy_from_buffer() - eliminated for now */

	/* I do the following instead */
	struct page *page = sg_page(vbuf->sglist);
	u32 *addr = kmap_atomic(page);

	/* 4 times as large, I know, the buffer is much longer though */
	for (i = 0; i < 1024; i++)
		addr[i] = n;

	flush_dcache_page(page); /* and/or */
	flush_kernel_dcache_page(page);

	kunmap_atomic(addr);

	vb->v4l2_buf.sequence = solo_enc->sequence++;
	vb->v4l2_buf.timestamp.tv_sec = vop_sec(vh);
	vb->v4l2_buf.timestamp.tv_usec = vop_usec(vh);

	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);

The userspace server now does ioctl(VIDIOC_DQBUF), sends it using UDP,
and populates buffer pool again with ioctl(VIDIOC_QBUF).

The driver uses directly-mapped cached (kernel) pointers to access the
buffers (0x80000000->0x9FFFFFFF kseg0 region) while (obviously)
userspace uses TLB-mapped pointers.

I have verified with a JTAG-based debugger (OpenOCD) that the buffers
are flushed to DRAM (0xAxxxxxxx uncached directly-mapped region has
valid data), however the userspace TLB-mapped buffers (which correspond
to the same physical DRAM addresses) partially contain old cached data
(from previous iterations).

The question is which part of the code is at fault, and how do I fix it.
I understand invalidating (and perhaps first flushing) userspace buffers
(cache) should generally fix the problem.

This could also be a simple bug rather than API/platform incompatibility
because usually (though not always) only 1 of the buffers gets corrupted
(the second one of two).

It looks like this - valid buffer, counter n = 0x499, a fragment
of actual UDP packet:
        0x0030:  0000 0499 0000 0499 0000 0499 0000 0499  ................
        0x0040:  0000 0499 0000 0499 0000 0499 0000 0499  ................
        0x0050:  0000 0499 0000 0499 0000 0499 0000 0499  ................
        0x0060:  0000 0499 0000 0499 0000 0499 0000 0499  ................
        0x0070:  0000 0499 0000 0499 0000 0499 0000 0499  ................
        0x0080:  0000 0499 0000 0499 0000 0499 0000 0499  ................
        0x0090:  0000 0499 0000 0499 0000 0499 0000 0499  ................
        0x00a0:  0000 0499 0000 0499 0000 0499 0000 0499  ................
        0x00b0:  0000 0499 0000 0499 0000 0499 0000 0499  ................

next buffer is corrupted, n = 0x49A:
        0x0030:  0000 049a 0000 049a 0000 049a 0000 049a  ................
        0x0040:  0000 049a 0000 0468 0000 0468 0000 0468  .......h...h...h
        0x0050:  0000 0468 0000 0468 0000 0468 0000 0468  ...h...h...h...h
        0x0060:  0000 0468 0000 049a 0000 049a 0000 049a  ...h............
        0x0070:  0000 049a 0000 049a 0000 049a 0000 049a  ................
        0x0080:  0000 049a 0000 049a 0000 049a 0000 049a  ................
        0x0090:  0000 049a 0000 049a 0000 049a 0000 049a  ................
        0x00a0:  0000 049a 0000 049a 0000 049a 0000 049a  ................
        0x00b0:  0000 049a 0000 049a 0000 049a 0000 049a  ................
        0x00c0:  0000 049a 0000 0478 0000 0478 0000 0478  .......x...x...x
        0x00d0:  0000 0478 0000 0478 0000 0478 0000 0478  ...x...x...x...x
        0x00e0:  0000 0478 0000 049a 0000 049a 0000 049a  ...x............
        0x00f0:  0000 049a 0000 049a 0000 049a 0000 049a  ................
        0x0100:  0000 049a 0000 049a 0000 049a 0000 049a  ................

Additional details: Ubiquity RouterStation Pro, gcc-4.7.3, Linux v3.11.

Any ideas?
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland

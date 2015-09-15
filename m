Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37227 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbbIOJHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 05:07:00 -0400
Message-ID: <55F7DF82.8030803@xs4all.nl>
Date: Tue, 15 Sep 2015 11:06:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@linaro.org,
	robdclark@gmail.com, daniel.vetter@ffwll.ch, labbott@redhat.com,
	Samu Onkalo <samu.onkalo@intel.com>
Subject: Re: [RFC RESEND 05/11] v4l2-core: Don't sync cache for a buffer if
 so requested
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <1441972234-8643-6-git-send-email-sakari.ailus@linux.intel.com> <55F30B65.4040309@xs4all.nl> <55F7D540.9020403@linux.intel.com>
In-Reply-To: <55F7D540.9020403@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/15/15 10:22, Sakari Ailus wrote:
> Could you rebase and re-post what's not in upstream of that set, please?

Done. Available here:

http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=vb2-cpu-access

These drivers need work to replace vb2_plane_vaddr by
vb2_plane_begin/end_cpu_access():

$ git grep vb2_plane_vaddr
drivers/media/pci/netup_unidvb/netup_unidvb_core.c:     u8 *p = vb2_plane_vaddr(&buf->vb, 0);
drivers/media/platform/coda/coda-bit.c: n = kfifo_in(&ctx->bitstream_fifo, vb2_plane_vaddr(src_buf, 0),
drivers/media/platform/coda/coda-bit.c: if (vb2_plane_vaddr(src_buf, 0) == NULL) {
drivers/media/platform/coda/coda-bit.c:         memset(vb2_plane_vaddr(buf, 0), 0, 64);
drivers/media/platform/coda/coda-bit.c:                 if (((char *)vb2_plane_vaddr(buf, 0))[i] != 0)
drivers/media/platform/coda/coda-bit.c: memcpy(header, vb2_plane_vaddr(buf, 0), *size);
drivers/media/platform/coda/coda-bit.c:         memcpy(vb2_plane_vaddr(dst_buf, 0),
drivers/media/platform/coda/coda-bit.c:         memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->vpu_header_size[0],
drivers/media/platform/coda/coda-bit.c:         memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->vpu_header_size[0] +
drivers/media/platform/coda/coda-jpeg.c:        void *vaddr = vb2_plane_vaddr(vb, 0);
drivers/media/platform/exynos4-is/fimc-capture.c:                       vaddr = vb2_plane_vaddr(&v_buf->vb, plane);
drivers/media/platform/rcar_jpu.c:              void *buffer = vb2_plane_vaddr(vb, 0);
drivers/media/platform/rcar_jpu.c:      buffer = vb2_plane_vaddr(vb, 0);
drivers/media/usb/au0828/au0828-vbi.c:  buf->mem = vb2_plane_vaddr(vb, 0);
drivers/media/usb/au0828/au0828-video.c:                outp = vb2_plane_vaddr(&buf->vb, 0);
drivers/media/usb/au0828/au0828-video.c:                vbioutp = vb2_plane_vaddr(&vbi_buf->vb, 0);
drivers/media/usb/au0828/au0828-video.c:                                        vbioutp = vb2_plane_vaddr(
drivers/media/usb/au0828/au0828-video.c:                                        outp = vb2_plane_vaddr(&buf->vb, 0);
drivers/media/usb/au0828/au0828-video.c:        buf->mem = vb2_plane_vaddr(vb, 0);
drivers/media/usb/au0828/au0828-video.c:                vid_data = vb2_plane_vaddr(&buf->vb, 0);
drivers/media/usb/au0828/au0828-video.c:                vbi_data = vb2_plane_vaddr(&buf->vb, 0);

The coda and exynos4-is I never converted and the others are new.

Regards,

	Hans

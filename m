Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43312 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3FRIqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 04:46:05 -0400
Date: Tue, 18 Jun 2013 09:43:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Inki Dae <inki.dae@samsung.com>
Cc: 'Maarten Lankhorst' <maarten.lankhorst@canonical.com>,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	'Rob Clark' <robdclark@gmail.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	'Daniel Vetter' <daniel@ffwll.ch>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
	framework
Message-ID: <20130618084308.GU2718@n2100.arm.linux.org.uk>
References: <1371112088-15310-1-git-send-email-inki.dae@samsung.com> <1371467722-665-1-git-send-email-inki.dae@samsung.com> <51BEF458.4090606@canonical.com> <012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com> <20130617133109.GG2718@n2100.arm.linux.org.uk> <CAAQKjZO_t_kZkU46bUPTpoJs_oE1KkEqS2OTrTYjjJYZzBf+XA@mail.gmail.com> <20130617154237.GJ2718@n2100.arm.linux.org.uk> <CAAQKjZOokFKN85pygVnm7ShSa+O0ZzwxvQ0rFssgNLp+RO5pGg@mail.gmail.com> <20130617182127.GM2718@n2100.arm.linux.org.uk> <007301ce6be4$8d5c6040$a81520c0$%dae@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007301ce6be4$8d5c6040$a81520c0$%dae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 18, 2013 at 02:27:40PM +0900, Inki Dae wrote:
> So I'd like to ask for other DRM maintainers. How do you think about it? it
> seems like that Intel DRM (maintained by Daniel), OMAP DRM (maintained by
> Rob) and GEM CMA helper also have same issue Russell pointed out. I think
> not only the above approach but also the performance is very important.

CMA uses coherent memory to back their buffers, though that might not be
true of memory obtained from other drivers via dma_buf.  Plus, there is
no support in the CMA helper for exporting or importng these buffers.

I guess Intel i915 is only used on x86, which is a coherent platform and
requires no cache maintanence for DMA.

OMAP DRM does not support importing non-DRM buffers buffers back into
DRM.  Moreover, it will suffer from the problems I described if any
attempt is made to write to the buffer after it has been re-imported.

Lastly, I should point out that the dma_buf stuff is really only useful
when you need to export a dma buffer from one driver and import it into
another driver - for example to pass data from a camera device driver to
a display device driver.  It shouldn't be used within a single driver
as a means of passing buffers between userspace and kernel space.

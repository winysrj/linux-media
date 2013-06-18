Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43325 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3FRJjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 05:39:12 -0400
Date: Tue, 18 Jun 2013 10:38:23 +0100
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
Message-ID: <20130618093823.GV2718@n2100.arm.linux.org.uk>
References: <51BEF458.4090606@canonical.com> <012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com> <20130617133109.GG2718@n2100.arm.linux.org.uk> <CAAQKjZO_t_kZkU46bUPTpoJs_oE1KkEqS2OTrTYjjJYZzBf+XA@mail.gmail.com> <20130617154237.GJ2718@n2100.arm.linux.org.uk> <CAAQKjZOokFKN85pygVnm7ShSa+O0ZzwxvQ0rFssgNLp+RO5pGg@mail.gmail.com> <20130617182127.GM2718@n2100.arm.linux.org.uk> <007301ce6be4$8d5c6040$a81520c0$%dae@samsung.com> <20130618084308.GU2718@n2100.arm.linux.org.uk> <008a01ce6c02$e00a9f50$a01fddf0$%dae@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008a01ce6c02$e00a9f50$a01fddf0$%dae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 18, 2013 at 06:04:44PM +0900, Inki Dae wrote:
> 
> 
> > -----Original Message-----
> > From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> > Sent: Tuesday, June 18, 2013 5:43 PM
> > To: Inki Dae
> > Cc: 'Maarten Lankhorst'; 'linux-fbdev'; 'Kyungmin Park'; 'DRI mailing
> > list'; 'Rob Clark'; 'myungjoo.ham'; 'YoungJun Cho'; 'Daniel Vetter';
> > linux-arm-kernel@lists.infradead.org; linux-media@vger.kernel.org
> > Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
> > framework
> > 
> > On Tue, Jun 18, 2013 at 02:27:40PM +0900, Inki Dae wrote:
> > > So I'd like to ask for other DRM maintainers. How do you think about it?
> > it
> > > seems like that Intel DRM (maintained by Daniel), OMAP DRM (maintained
> > by
> > > Rob) and GEM CMA helper also have same issue Russell pointed out. I
> > think
> > > not only the above approach but also the performance is very important.
> > 
> > CMA uses coherent memory to back their buffers, though that might not be
> > true of memory obtained from other drivers via dma_buf.  Plus, there is
> > no support in the CMA helper for exporting or importng these buffers.
> > 
> 
> It's not so. Please see Dave's drm next. recently dmabuf support for the CMA
> helper has been merged to there.

The point stands: CMA is DMA coherent memory.  It doesn't need and must
never be dma-map-sg'd or dma-sync'd or dma-unmap'd.

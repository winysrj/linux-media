Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47251 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2BQStP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 13:49:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Rob Clark <rob@ti.com>, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Alexander Deucher <alexander.deucher@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-fbdev@vger.kernel.org
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC 2012 - Notes
Date: Fri, 17 Feb 2012 19:49:01 +0100
Message-ID: <20147090.P4saEu3B42@avalon>
In-Reply-To: <CAB2ybb_-ULCsfS48u7HQiRDLG5y-X2rmyXvHBcCRtc=m-732hQ@mail.gmail.com>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com> <1775349.d0yvHiVdjB@avalon> <CAB2ybb_-ULCsfS48u7HQiRDLG5y-X2rmyXvHBcCRtc=m-732hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sumit,

On Friday 17 February 2012 16:37:35 Semwal, Sumit wrote:
> On Fri, Feb 17, 2012 at 4:55 AM, Laurent Pinchart wrote: 
> > Hello everybody,
> > 
> > First of all, I would like to thank all the attendees for their
> > participation in the mini-summit that helped make the meeting a success.
> 
> <snip>
> 
> > ***  dma-buf Implementation in V4L2 ***
> > 
> >  Goal: Implement the dma-buf API in V4L2.
> > 
> >  Sumit Semwal has submitted patches to implement the dma-buf importer role
> > in videobuf2. Tomasz Stanislawski has then submitted incremental patches
> > to add exporter role support.
> > 
> >  Action points:
> >  - Create a git branch to host all the latest patches. Sumit will provide
> >    that.
> 
> Against my Action Item: I have created the following branch at my
> github (obviously, it is an RFC branch only)

That was very fast :-) Thank you for your work on this.

> tree: git://github.com/sumitsemwal/kernel-omap4.git
> branch: 3.3rc3-v4l2-dmabuf-RFCv1
> 
> As the name partially suggests, it is based out of:
> 3.3-rc3 +
> dmav6 [1] +
> some minor dma-buf updates [2] +
> my v4l2-as-importer RFC [3] +
> Tomasz' RFC for v4l2-as-exporter (and related patches) [4]
> 
> Since Tomasz' RFC had a patch-pair which first removed and then added
> drivers/media/video/videobuf2-dma-contig.c file, I 'combined' these
> into one - but since the patch-pair heavily refactored the file, I am
> not able to take responsibility of completeness / correctness of the
> same.

No worries. The branch's main purpose is to provide people with a starting 
point to use dma-buf, patch review will go through mailing lists anyway.

> [1]:
> http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/3.3
> -rc2-dma-v6 [2]: git://git.linaro.org/people/sumitsemwal/linux-3.x.git 'dev'
> branch [3]:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/4296
> 6/focus=42968 [4]:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/4379
> 3

-- 
Regards,

Laurent Pinchart

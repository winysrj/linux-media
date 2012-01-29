Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:62290 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab2A2LEP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jan 2012 06:04:15 -0500
Message-ID: <4F25278B.3090903@iki.fi>
Date: Sun, 29 Jan 2012 13:03:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, rob@ti.com,
	patches@linaro.org
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com> <201201201729.00230.laurent.pinchart@ideasonboard.com> <000601ccd9ae$5bd5fff0$1381ffd0$%szyprowski@samsung.com> <201201231048.47433.laurent.pinchart@ideasonboard.com> <CAKMK7uGSWQSq=tdoSp54ksXuwUD6z=FusSJf7=uzSp5Jm6t6sA@mail.gmail.com> <20120125232816.GA15297@valkosipuli.localdomain> <20120126112726.GC3896@phenom.ffwll.local>
In-Reply-To: <20120126112726.GC3896@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

Daniel Vetter wrote:
> On Thu, Jan 26, 2012 at 01:28:16AM +0200, Sakari Ailus wrote:
>> Why you "should not hang onto mappings forever"? This is currently done by
>> virtually all V4L2 drivers where such mappings are relevant. Not doing so
>> would really kill the performance i.e. it's infeasible. Same goes to (m)any
>> other multimedia devices dealing with buffers containing streaming video
>> data.
> 
> Because I want dynamic memory managemt simple because everything else does
> not make sense. I know that in v4l things don't work that way, but in drm
> they _do_. And if you share tons of buffers with drm drivers and don't
> follow the rules, the OOM killer will come around and shot at your apps.
> Because at least in i915 we do slurp in as much memory as we can until the
> oom killer starts growling, at which point we kick out stuff.
> 
> I know that current dma_buf isn't there and for many use-cases discussed
> here we can get away without that complexity. So you actually can just map
> your dma_buf and never ever let go of that mapping again in many cases.
> 
> The only reason I'm such a stuborn bastard about all this is that drm/*
> will do dynamic bo management even with dma_buf sooner or later and you
> should better know that and why and the implications if you choose to
> ignore it.
> 
> And obviously, the generic dma_buf interface needs to be able to support
> it.

I do not think we should completely ignore this issue, but I think we
might want to at least postpone the implementation for non-DRM
subsystems to an unknown future date. The reason is simply that it's
currently unfeasible for various reasons.

Sharing large buffers with GPUs (where you might want to manage them
independently of the user space) is uncommon; typically you're sharing
buffers for viewfinder that tend to be around few megabytes in size and
there may be typically up to five of them. Also, we're still far from
getting things working in the first place. Let's not complicate them
more than we have to.

The very reason why we're pre-allocating these large buffers in
applications is that you can readily use them when you need them.
Consider camera, for example: a common use case is to have a set of 24
MB buffers (for 12 Mp images) prepared while the viewfinder is running.
These buffers must be immediately usable when the user presses the
shutter button.

We don't want to continuously map and unmap buffers in viewfinder
either: that adds a significan CPU load for no technical reason
whatsoever. Typically viewfinder also involves running software
algorithms that consume much of the available CPU time, so adding an
unnecessary CPU hog to the picture doesn't sound that enticing.

If the performance of memory management can be improved to such an
extent it really takes much less than a millisecond or so to perform all
the pinning-to-memory, IOMMU mapping and so on systems for 24 MB buffers
on regular embedded systems I think I wouldn't have much against doing
so. Currently I think we're talking about numbers that are at least
100-fold.

If you want to do this to buffers used only in DRM I'm fine with that.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi

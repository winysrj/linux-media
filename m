Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57655 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab2AZL11 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 06:27:27 -0500
Received: by wgbed3 with SMTP id ed3so515536wgb.1
        for <linux-media@vger.kernel.org>; Thu, 26 Jan 2012 03:27:26 -0800 (PST)
Date: Thu, 26 Jan 2012 12:27:26 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, rob@ti.com,
	patches@linaro.org
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Message-ID: <20120126112726.GC3896@phenom.ffwll.local>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
 <201201201729.00230.laurent.pinchart@ideasonboard.com>
 <000601ccd9ae$5bd5fff0$1381ffd0$%szyprowski@samsung.com>
 <201201231048.47433.laurent.pinchart@ideasonboard.com>
 <CAKMK7uGSWQSq=tdoSp54ksXuwUD6z=FusSJf7=uzSp5Jm6t6sA@mail.gmail.com>
 <20120125232816.GA15297@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120125232816.GA15297@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 26, 2012 at 01:28:16AM +0200, Sakari Ailus wrote:
> Why you "should not hang onto mappings forever"? This is currently done by
> virtually all V4L2 drivers where such mappings are relevant. Not doing so
> would really kill the performance i.e. it's infeasible. Same goes to (m)any
> other multimedia devices dealing with buffers containing streaming video
> data.

Because I want dynamic memory managemt simple because everything else does
not make sense. I know that in v4l things don't work that way, but in drm
they _do_. And if you share tons of buffers with drm drivers and don't
follow the rules, the OOM killer will come around and shot at your apps.
Because at least in i915 we do slurp in as much memory as we can until the
oom killer starts growling, at which point we kick out stuff.

I know that current dma_buf isn't there and for many use-cases discussed
here we can get away without that complexity. So you actually can just map
your dma_buf and never ever let go of that mapping again in many cases.

The only reason I'm such a stuborn bastard about all this is that drm/*
will do dynamic bo management even with dma_buf sooner or later and you
should better know that and why and the implications if you choose to
ignore it.

And obviously, the generic dma_buf interface needs to be able to support
it.

Cheers, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

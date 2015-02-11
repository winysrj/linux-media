Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:45981 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbBKMzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 07:55:51 -0500
Received: by mail-we0-f182.google.com with SMTP id l61so3189130wev.13
        for <linux-media@vger.kernel.org>; Wed, 11 Feb 2015 04:55:49 -0800 (PST)
Date: Wed, 11 Feb 2015 13:56:46 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Rob Clark <robdclark@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	linux-mm <linux-mm@kvack.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>,
	Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [RFCv3 2/2] dma-buf: add helpers for sharing attacher
 constraints with dma-parms
Message-ID: <20150211125646.GR24485@phenom.ffwll.local>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
 <1422347154-15258-2-git-send-email-sumit.semwal@linaro.org>
 <54DB12B5.4080000@samsung.com>
 <20150211111258.GP8656@n2100.arm.linux.org.uk>
 <CAF6AEGscETLVnhg7zTFHQbj2KmX150VPaVHsqjvyJnVfHnHkOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGscETLVnhg7zTFHQbj2KmX150VPaVHsqjvyJnVfHnHkOQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 11, 2015 at 06:23:52AM -0500, Rob Clark wrote:
> On Wed, Feb 11, 2015 at 6:12 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > As I've already pointed out, there's a major problem if you have already
> > had a less restrictive attachment which has an active mapping, and a new
> > more restrictive attachment comes along later.
> >
> > It seems from Rob's descriptions that we also need another flag in the
> > importer to indicate whether it wants to have a valid struct page in the
> > scatter list, or whether it (correctly) uses the DMA accessors on the
> > scatter list - so that exporters can reject importers which are buggy.
> 
> to be completely generic, we would really need a way that the device
> could take over only just the last iommu (in case there were multiple
> levels of address translation)..

I still hold that if the dma api steals the iommu your gpu needs for
context switching then that's a bug in the platform setup code. dma api
really doesn't have any concept of switchable hw contexts. So trying to
work around this brokeness by mandating it as a valid dma-buf use-case is
totally backwards.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

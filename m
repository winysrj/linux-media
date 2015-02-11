Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:56952 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbbBKNax (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 08:30:53 -0500
MIME-Version: 1.0
In-Reply-To: <20150211125646.GR24485@phenom.ffwll.local>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
	<1422347154-15258-2-git-send-email-sumit.semwal@linaro.org>
	<54DB12B5.4080000@samsung.com>
	<20150211111258.GP8656@n2100.arm.linux.org.uk>
	<CAF6AEGscETLVnhg7zTFHQbj2KmX150VPaVHsqjvyJnVfHnHkOQ@mail.gmail.com>
	<20150211125646.GR24485@phenom.ffwll.local>
Date: Wed, 11 Feb 2015 08:30:52 -0500
Message-ID: <CAF6AEGuzex2Y7+=hP73Sp9CtOnn1t0veHRdzJrs3w8p6b8_rEg@mail.gmail.com>
Subject: Re: [RFCv3 2/2] dma-buf: add helpers for sharing attacher constraints
 with dma-parms
From: Rob Clark <robdclark@gmail.com>
To: Rob Clark <robdclark@gmail.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
	Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 11, 2015 at 7:56 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Feb 11, 2015 at 06:23:52AM -0500, Rob Clark wrote:
>> On Wed, Feb 11, 2015 at 6:12 AM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > As I've already pointed out, there's a major problem if you have already
>> > had a less restrictive attachment which has an active mapping, and a new
>> > more restrictive attachment comes along later.
>> >
>> > It seems from Rob's descriptions that we also need another flag in the
>> > importer to indicate whether it wants to have a valid struct page in the
>> > scatter list, or whether it (correctly) uses the DMA accessors on the
>> > scatter list - so that exporters can reject importers which are buggy.
>>
>> to be completely generic, we would really need a way that the device
>> could take over only just the last iommu (in case there were multiple
>> levels of address translation)..
>
> I still hold that if the dma api steals the iommu your gpu needs for
> context switching then that's a bug in the platform setup code. dma api
> really doesn't have any concept of switchable hw contexts. So trying to
> work around this brokeness by mandating it as a valid dma-buf use-case is
> totally backwards.

sure, my only point is that if I'm the odd man out, I can live with a
hack (ie. requiring drm/msm to be aware enough of the platform to know
if there is >1 level of address translation and frob'ing my 'struct
device' accordingly)... no point in a generic solution for one user.
I like to be practical.

BR,
-R

> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

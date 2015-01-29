Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:34886 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbbA2T0Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 14:26:24 -0500
Date: Thu, 29 Jan 2015 19:26:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Clark <robdclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFCv3 2/2] dma-buf: add helpers for sharing attacher
 constraints with dma-parms
Message-ID: <20150129192610.GE26493@n2100.arm.linux.org.uk>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
 <1422347154-15258-2-git-send-email-sumit.semwal@linaro.org>
 <20150129143908.GA26493@n2100.arm.linux.org.uk>
 <CAO_48GEOQ1pBwirgEWeVVXW-iOmaC=Xerr2VyYYz9t1QDXgVsw@mail.gmail.com>
 <20150129154718.GB26493@n2100.arm.linux.org.uk>
 <CAF6AEGtTmFg66TK_AFkQ-xp7Nd9Evk3nqe6xCBp7K=77OmXTxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGtTmFg66TK_AFkQ-xp7Nd9Evk3nqe6xCBp7K=77OmXTxA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 29, 2015 at 01:52:09PM -0500, Rob Clark wrote:
> Quite possibly for some of these edge some of cases, some of the
> dma-buf exporters are going to need to get more clever (ie. hand off
> different scatterlists to different clients).  Although I think by far
> the two common cases will be "I can support anything via an iommu/mmu"
> and "I need phys contig".
> 
> But that isn't an issue w/ dma-buf itself, so much as it is an issue
> w/ drivers.  I guess there would be more interest in fixing up drivers
> when actual hw comes along that needs it..

However, validating the attachments is the business of dma-buf.  This
is actual infrastructure, which should ensure some kind of sanity such
as the issues I've raised.

The whole "we can push it onto our users" is really on - what that
results in is the users ignoring most of the requirements and just doing
their own thing, which ultimately ends up with the whole thing turning
into a disgusting mess - one which becomes very difficult to fix later.

Now, if we're going to do the "more clever" thing you mention above,
that rather negates the point of this two-part patch set, which is to
provide the union of the DMA capabilities of all users.  A union in
that case is no longer sane as we'd be tailoring the SG lists to each
user.

If we aren't going to do the "more clever" thing, then yes, we need this
code to calculate that union, but we _also_ need it to do sanity checking
right from the start, and refuse conditions which ultimately break the
ability to make use of that union - in other words, when the union of
the DMA capabilities means that the dmabuf can't be represented.

Unless we do that, we'll just end up with random drivers interpreting
what they want from the DMA capabilities, and we'll have some drivers
exporting (eg) scatterlists which satisfy the maximum byte size of an
element, but ignoring the maximum number of entries or vice versa, and
that'll most probably hide the case of "too small a union".

It really doesn't make sense to do both either: that route is even more
madness, because we'll end up with two classes of drivers - those which
use the union approach, and those which don't.

The KISS principle applies here.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.

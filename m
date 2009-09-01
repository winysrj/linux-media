Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38503 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbZIAOSb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 10:18:31 -0400
Date: Tue, 1 Sep 2009 15:18:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Steven Walter <stevenrwalter@gmail.com>,
	David Xiao <dxiao@broadcom.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
	get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <20090901141812.GT19719@n2100.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com> <20090901132824.GN19719@n2100.arm.linux.org.uk> <200909011543.48439.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909011543.48439.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 01, 2009 at 03:43:48PM +0200, Laurent Pinchart wrote:
> I might be missing something obvious, but I fail to see how VIVT caches
> could work at all with multiple mappings. If a kernel-allocated buffer
> is DMA'ed to, we certainly want to invalidate all cache lines that store
> buffer data. As the cache doesn't care about physical addresses we thus
> need to invalidate all virtual mappings for the buffer. If the buffer is
> mmap'ed in userspace I don't see how that would be done.

You need to ask MM gurus about that.  I don't touch the Linux MM very
often so tend to keep forgetting how it works.  However, it does work
for shared mappings of files on CPUs with VIVT caches.

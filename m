Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756866Ab2JKLNq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 07:13:46 -0400
Date: Thu, 11 Oct 2012 08:13:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Dave Airlie <airlied@gmail.com>,
	Robert Morell <rmorell@nvidia.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linaro-mm-sig@lists.linaro.org, rob@ti.com,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20121011081327.46045e12@redhat.com>
In-Reply-To: <201210110920.12560.hverkuil@xs4all.nl>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<CAPM=9tzQohMuC4SKTzVWoj2WdiZ8EVBpwgD38wNb3T1bNoZjbQ@mail.gmail.com>
	<20121010221119.6a623417@redhat.com>
	<201210110920.12560.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 11 Oct 2012 09:20:12 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > my understaning is
> > that the drivers/media/ authors should also ack with this licensing
> > (possible) change. I am one of the main contributors there. Alan also has 
> > copyrights there, and at other parts of the Linux Kernel, including the driver's
> > core, from where all Linux Kernel drivers are derivative work, including this one.
> > 
> > As Alan well said, many other core Linux Kernel authors very likely share 
> > this point of view.
> > 
> > So, developers implicitly or explicitly copied in this thread that might be
> > considering the usage of dmabuf on proprietary drivers should consider
> > this email as a formal notification of my viewpoint: e. g. that I consider
> > any attempt of using DMABUF or media core/drivers together with proprietary
> > Kernelspace code as a possible GPL infringement.
> 
> As long as dmabuf uses EXPORT_SYMBOL_GPL that is definitely correct. Does your
> statement also hold if dmabuf would use EXPORT_SYMBOL? (Just asking)

If you read the Kernel COPYING file, it is explicitly said there that the Kernel
is licensing with GPLv2. The _ONLY_ exception there is the allowance to use
the kernel via normal syscalls:

	   "NOTE! This copyright does *not* cover user programs that use kernel
	 services by normal system calls - this is merely considered normal use
	 of the kernel, and does *not* fall under the heading of "derived work".
	 Also note that the GPL below is copyrighted by the Free Software
	 Foundation, but the instance of code that it refers to (the Linux
	 kernel) is copyrighted by me and others who actually wrote it."

The usage of EXPORT_SYMBOL() is not covered there, so those symbols are also
covered by GPLv2.

As the usage of a kernel symbol by a proprietary driver is not explicitly
listed there as a GPLv2 exception, the only concrete results of this patch is
to spread FUD, as EXPORT_SYMBOL might generate some doubts on people that
don't read the Kernel's COPYING file. 

With or without this patch, anyone with intelectual rights in the Kernel may
go to court to warrant their rights against the infringing closed source drivers.
By not making it explicitly, you're only trying to fool people that using
it might be allowed.

> BTW, we should consider changing the control framework API to EXPORT_SYMBOL_GPL.

Agreed.

> The number of contributors to v4l2-ctrls.c is very limited, and I have no
> problem moving that to GPL. For me dmabuf is the rare exception where I prefer
> EXPORT_SYMBOL to prevent the worse evil of forcing vendors to create incompatible
> APIs. It's a sad but true that many GPU drivers are still closed source,
> particularly in the embedded world for which dmabuf was primarily designed.

My understanding is that even the creation of incompatible Kernel API
is a presumed GPL violation, as it is an attempt to circumvent the license.

Basically, if vendors want to work with closed source, there are other options
in the market. But if they want to work with Linux, they should be contributing
upstream, instead of doing proprietary blobs.

Regards,
Mauro

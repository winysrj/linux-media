Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1196 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab2JKHUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 03:20:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Date: Thu, 11 Oct 2012 09:20:12 +0200
Cc: Dave Airlie <airlied@gmail.com>,
	Robert Morell <rmorell@nvidia.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linaro-mm-sig@lists.linaro.org, rob@ti.com,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com> <CAPM=9tzQohMuC4SKTzVWoj2WdiZ8EVBpwgD38wNb3T1bNoZjbQ@mail.gmail.com> <20121010221119.6a623417@redhat.com>
In-Reply-To: <20121010221119.6a623417@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210110920.12560.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu October 11 2012 03:11:19 Mauro Carvalho Chehab wrote:
> Em Thu, 11 Oct 2012 09:22:34 +1000
> Dave Airlie <airlied@gmail.com> escreveu:
> 
> > On Thu, Oct 11, 2012 at 4:17 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > On Wed, 10 Oct 2012 08:56:32 -0700
> > > Robert Morell <rmorell@nvidia.com> wrote:
> > >
> > >> EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
> > >> issue, and not really an interface".  The dma-buf infrastructure is
> > >> explicitly intended as an interface between modules/drivers, so it
> > >> should use EXPORT_SYMBOL instead.
> > >
> > > NAK. This needs at the very least the approval of all rights holders for
> > > the files concerned and all code exposed by this change.
> > 
> > I think he has that. Maybe he just needs to list them. 
> 
> My understanding it that he doesn't, as the dmabuf interface exposes not only
> the code written by this driver's author, but other parts of the Kernel.
> 
> Even if someone consider just the dmabuf driver, I participated and actively
> contributed, together with other open source developers, during the 3 days 
> discussions that happened at Linaro's forum where most of dmabuf design was
> decided, and participated, reviewed, gave suggestions approved the code, etc
> via email. So, even not writing the dmabuf stuff myself, I consider myself as 
> one of the intelectual authors of the solution.
> 
> Also, as dmabuf will also expose media interfaces,

That's new to me. All it does is represent a buffer. It doesn't expose any
interfaces, media or otherwise.

> my understaning is
> that the drivers/media/ authors should also ack with this licensing
> (possible) change. I am one of the main contributors there. Alan also has 
> copyrights there, and at other parts of the Linux Kernel, including the driver's
> core, from where all Linux Kernel drivers are derivative work, including this one.
> 
> As Alan well said, many other core Linux Kernel authors very likely share 
> this point of view.
> 
> So, developers implicitly or explicitly copied in this thread that might be
> considering the usage of dmabuf on proprietary drivers should consider
> this email as a formal notification of my viewpoint: e. g. that I consider
> any attempt of using DMABUF or media core/drivers together with proprietary
> Kernelspace code as a possible GPL infringement.

As long as dmabuf uses EXPORT_SYMBOL_GPL that is definitely correct. Does your
statement also hold if dmabuf would use EXPORT_SYMBOL? (Just asking)

BTW, we should consider changing the control framework API to EXPORT_SYMBOL_GPL.
The number of contributors to v4l2-ctrls.c is very limited, and I have no
problem moving that to GPL. For me dmabuf is the rare exception where I prefer
EXPORT_SYMBOL to prevent the worse evil of forcing vendors to create incompatible
APIs. It's a sad but true that many GPU drivers are still closed source,
particularly in the embedded world for which dmabuf was primarily designed.

Regards,

	Hans

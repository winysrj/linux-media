Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54324 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JKCuI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 22:50:08 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so1246046obb.19
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2012 19:50:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121010221119.6a623417@redhat.com>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<20121010191702.404edace@pyramind.ukuu.org.uk>
	<CAPM=9tzQohMuC4SKTzVWoj2WdiZ8EVBpwgD38wNb3T1bNoZjbQ@mail.gmail.com>
	<20121010221119.6a623417@redhat.com>
Date: Thu, 11 Oct 2012 12:50:07 +1000
Message-ID: <CAPM=9tzobkzKczMVYpojbwyWCp0wHQmzFfdqJcK1aZMn+XF5iw@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
From: Dave Airlie <airlied@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Robert Morell <rmorell@nvidia.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linaro-mm-sig@lists.linaro.org, rob@ti.com,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> On Thu, Oct 11, 2012 at 4:17 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > On Wed, 10 Oct 2012 08:56:32 -0700
>> > Robert Morell <rmorell@nvidia.com> wrote:
>> >
>> >> EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
>> >> issue, and not really an interface".  The dma-buf infrastructure is
>> >> explicitly intended as an interface between modules/drivers, so it
>> >> should use EXPORT_SYMBOL instead.
>> >
>> > NAK. This needs at the very least the approval of all rights holders for
>> > the files concerned and all code exposed by this change.
>>
>> I think he has that. Maybe he just needs to list them.
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
> Also, as dmabuf will also expose media interfaces, my understaning is
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

Though that does beg the question why you care about this patch :-)

Dave.

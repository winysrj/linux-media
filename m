Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4877 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2JKG6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 02:58:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Rob Clark <rob@ti.com>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Date: Thu, 11 Oct 2012 08:57:15 +0200
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Robert Morell <rmorell@nvidia.com>,
	linaro-mm-sig@lists.linaro.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com> <20121010191702.404edace@pyramind.ukuu.org.uk> <CAF6AEGvzfr2-QHpX4zwm2EPz-vxCDe9SaLUjo4_Fn7HhjWJFsg@mail.gmail.com>
In-Reply-To: <CAF6AEGvzfr2-QHpX4zwm2EPz-vxCDe9SaLUjo4_Fn7HhjWJFsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210110857.15660.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed October 10 2012 23:02:06 Rob Clark wrote:
> On Wed, Oct 10, 2012 at 1:17 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > On Wed, 10 Oct 2012 08:56:32 -0700
> > Robert Morell <rmorell@nvidia.com> wrote:
> >
> >> EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
> >> issue, and not really an interface".  The dma-buf infrastructure is
> >> explicitly intended as an interface between modules/drivers, so it
> >> should use EXPORT_SYMBOL instead.
> >
> > NAK. This needs at the very least the approval of all rights holders for
> > the files concerned and all code exposed by this change.
> 
> Well, for my contributions to dmabuf, I don't object.. and I think
> because we are planning to use dma-buf in userspace for dri3 /
> dri-next, I think that basically makes it a userspace facing kernel
> infrastructure which would be required for open and proprietary
> drivers alike.  So I don't see much alternative to making this
> EXPORT_SYMBOL().  Of course, IANAL.

The whole purpose of this API is to let DRM and V4L drivers share buffers for
zero-copy pipelines. Unfortunately it is a fact that several popular DRM drivers
are closed source. So we have a choice between keeping the export symbols GPL
and forcing those closed-source drivers to make their own incompatible API,
thus defeating the whole point of DMABUF, or using EXPORT_SYMBOL and letting
the closed source vendors worry about the legality. They are already using such
functions (at least nvidia is), so they clearly accept that risk.

I prefer the evil where the DMABUF API uses EXPORT_SYMBOL to prevent the worse
evil where an incompatible API is created to work around the EXPORT_SYMBOL_GPL
limitation. Neither situation is paradise, but at least one is a slightly less
depressing world than the other :-)

In other words, I'm OK with EXPORT_SYMBOL for whatever it is worth as I did not
do any coding but only some initial design help and reviewing.

Regards,

	Hans

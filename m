Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:31803 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2JKMKk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 08:10:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Date: Thu, 11 Oct 2012 14:10:13 +0200
Cc: Rob Clark <rob@ti.com>, Robert Morell <rmorell@nvidia.com>,
	linaro-mm-sig@lists.linaro.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com> <20121011123407.63b5ecbe@pyramind.ukuu.org.uk> <201210111336.45574.hverkuil@xs4all.nl>
In-Reply-To: <201210111336.45574.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210111410.13144.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 11 October 2012 13:36:45 Hans Verkuil wrote:
> On Thu 11 October 2012 13:34:07 Alan Cox wrote:
> > > The whole purpose of this API is to let DRM and V4L drivers share buffers for
> > > zero-copy pipelines. Unfortunately it is a fact that several popular DRM drivers
> > > are closed source. So we have a choice between keeping the export symbols GPL
> > > and forcing those closed-source drivers to make their own incompatible API,
> > > thus defeating the whole point of DMABUF, or using EXPORT_SYMBOL and letting
> > > the closed source vendors worry about the legality. They are already using such
> > > functions (at least nvidia is), so they clearly accept that risk.
> > 
> > Then they can accept the risk of ignoring EXPORT_SYMBOL_GPL and
> > calling into it anyway can't they. Your argument makes no rational sense
> > of any kind.
> 
> Out of curiosity: why do we have both an EXPORT_SYMBOL and an EXPORT_SYMBOL_GPL
> if there is no legal difference?
> 
> And if there is a difference between the two, then what is it?

Answering myself:

http://lwn.net/Articles/154602/

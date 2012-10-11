Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35708 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab2JKL3Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 07:29:16 -0400
Date: Thu, 11 Oct 2012 12:34:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Rob Clark <rob@ti.com>, Robert Morell <rmorell@nvidia.com>,
	linaro-mm-sig@lists.linaro.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20121011123407.63b5ecbe@pyramind.ukuu.org.uk>
In-Reply-To: <201210110857.15660.hverkuil@xs4all.nl>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<20121010191702.404edace@pyramind.ukuu.org.uk>
	<CAF6AEGvzfr2-QHpX4zwm2EPz-vxCDe9SaLUjo4_Fn7HhjWJFsg@mail.gmail.com>
	<201210110857.15660.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The whole purpose of this API is to let DRM and V4L drivers share buffers for
> zero-copy pipelines. Unfortunately it is a fact that several popular DRM drivers
> are closed source. So we have a choice between keeping the export symbols GPL
> and forcing those closed-source drivers to make their own incompatible API,
> thus defeating the whole point of DMABUF, or using EXPORT_SYMBOL and letting
> the closed source vendors worry about the legality. They are already using such
> functions (at least nvidia is), so they clearly accept that risk.

Then they can accept the risk of ignoring EXPORT_SYMBOL_GPL and
calling into it anyway can't they. Your argument makes no rational sense
of any kind.

Alan

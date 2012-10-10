Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34334 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab2JJSMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 14:12:17 -0400
Date: Wed, 10 Oct 2012 19:17:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Morell <rmorell@nvidia.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	linaro-mm-sig@lists.linaro.org, rob@ti.com,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20121010191702.404edace@pyramind.ukuu.org.uk>
In-Reply-To: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Oct 2012 08:56:32 -0700
Robert Morell <rmorell@nvidia.com> wrote:

> EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
> issue, and not really an interface".  The dma-buf infrastructure is
> explicitly intended as an interface between modules/drivers, so it
> should use EXPORT_SYMBOL instead.

NAK. This needs at the very least the approval of all rights holders for
the files concerned and all code exposed by this change.

Also I'd note if you are trying to do this for the purpose of combining
it with proprietary code then you are still in my view as a (and the view
of many other) rights holder to the kernel likely to be in breach
of the GPL requirements for a derivative work. You may consider that
formal notification of my viewpoint. Your corporate legal team can
explain to you why the fact you are now aware of my view is important to
them.

Alan

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933868AbbELWmR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 18:42:17 -0400
Date: Tue, 12 May 2015 15:42:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, rmk+kernel@arm.linux.org.uk,
	airlied@linux.ie, kgene@kernel.org, thierry.reding@gmail.com,
	pawel@osciak.com, m.szyprowski@samsung.com,
	mchehab@osg.samsung.com, linaro-kernel@lists.linaro.org,
	robdclark@gmail.com, daniel@ffwll.ch
Subject: Re: [PATCH v3] dma-buf: add ref counting for module as exporter
Message-ID: <20150512224216.GA16712@kroah.com>
References: <1431092563-19799-1-git-send-email-sumit.semwal@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1431092563-19799-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 08, 2015 at 07:12:43PM +0530, Sumit Semwal wrote:
> Add reference counting on a kernel module that exports dma-buf and
> implements its operations. This prevents the module from being unloaded
> while DMABUF file is in use.
> 
> The original patch [1] was submitted by Tomasz Stanislawski, but this
> is a simpler way to do it.
> 
> v3: call module_put() as late as possible, per gregkh's comment.
> v2: move owner to struct dma_buf, and use DEFINE_DMA_BUF_EXPORT_INFO
>     macro to simplify the change.
> 
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> 
> [1]: https://lkml.org/lkml/2012/8/8/163
> ---
>  drivers/dma-buf/dma-buf.c | 10 +++++++++-
>  include/linux/dma-buf.h   | 10 ++++++++--
>  2 files changed, 17 insertions(+), 3 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

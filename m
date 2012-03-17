Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45724 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2CQUSv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Mar 2012 16:18:51 -0400
Date: Sat, 17 Mar 2012 20:17:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Tom Cooksey" <tom.cooksey@arm.com>
Cc: "'Rob Clark'" <rob.clark@linaro.org>,
	<linaro-mm-sig@lists.linaro.org>,
	<dri-devel@lists.freedesktop.org>, <linux-media@vger.kernel.org>,
	rschultz@google.com, Rob Clark <rob@ti.com>,
	sumit.semwal@linaro.org, patches@linaro.org
Subject: Re: [PATCH] RFC: dma-buf: userspace mmap support
Message-ID: <20120317201719.121f4104@pyx>
In-Reply-To: <000001cd0399$9e57db90$db0792b0$@cooksey@arm.com>
References: <1331775148-5001-1-git-send-email-rob.clark@linaro.org>
	<000001cd0399$9e57db90$db0792b0$@cooksey@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > dma-buf file descriptor.  Userspace access to the buffer should be
> > bracketed with DMA_BUF_IOCTL_{PREPARE,FINISH}_ACCESS ioctl calls to
> > give the exporting driver a chance to deal with cache synchronization
> > and such for cached userspace mappings without resorting to page

There should be flags indicating if this is necessary. We don't want extra
syscalls on hardware that doesn't need it. The other question is what
info is needed as you may only want to poke a few pages out of cache and
the prepare/finish on its own gives no info.

> E.g. If another device was writing to the buffer, the prepare ioctl
> could block until that device had finished accessing that buffer.

How do you avoid deadlocks on this ? We need very clear ways to ensure
things always complete in some form given multiple buffer
owner/requestors and the fact this API has no "prepare-multiple-buffers"
support.

Alan

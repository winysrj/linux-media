Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44424 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932843AbcJYKkQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 06:40:16 -0400
Date: Tue, 25 Oct 2016 13:39:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v5] [media] vb2: Add support for
 capture_dma_bidirectional queue flag
Message-ID: <20161025103935.GN9460@valkosipuli.retiisi.org.uk>
References: <1477383749-16208-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477383749-16208-1-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 25, 2016 at 10:22:29AM +0200, Thierry Escande wrote:
> From: Pawel Osciak <posciak@chromium.org>
> 
> When this flag is set for CAPTURE queues by the driver on calling
> vb2_queue_init(), it forces the buffers on the queue to be
> allocated/mapped with DMA_BIDIRECTIONAL direction flag instead of
> DMA_FROM_DEVICE. This allows the device not only to write to the
> buffers, but also read out from them. This may be useful e.g. for codec
> hardware which may be using CAPTURE buffers as reference to decode
> other buffers.
> 
> This flag is ignored for OUTPUT queues as we don't want to allow HW to
> be able to write to OUTPUT buffers.
> 
> This patch introduces 2 macros:
> VB2_DMA_DIR(q) returns the corresponding dma_dir for the passed queue
> type, tanking care of the capture_dma_birectional flag.
> 
> VB2_DMA_DIR_CAPTURE(d) is a test macro returning true if the passed DMA
> direction refers to a capture buffer. This test is used to map virtual
> addresses for writing and to mark pages as dirty.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Tested-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

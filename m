Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45086 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbeH3WC4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 18:02:56 -0400
Date: Thu, 30 Aug 2018 10:59:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Matwey V . Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>, kernel@collabora.com,
        Keiichi Watanabe <keiichiw@chromium.org>
Subject: Re: [RFC 3/3] stk1160: Use non-coherent buffers for USB transfers
Message-ID: <20180830175937.GB11521@infradead.org>
References: <20180830172030.23344-1-ezequiel@collabora.com>
 <20180830172030.23344-4-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180830172030.23344-4-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> +	dma_sync_single_for_cpu(&urb->dev->dev, urb->transfer_dma,
> +		urb->transfer_buffer_length, DMA_FROM_DEVICE);

You can't ue dma_sync_single_for_cpu on non-coherent dma buffers,
which is one of the major issues with them.

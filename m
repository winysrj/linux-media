Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43478 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbeH3WCL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 18:02:11 -0400
Date: Thu, 30 Aug 2018 10:58:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Matwey V . Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>, kernel@collabora.com,
        Keiichi Watanabe <keiichiw@chromium.org>
Subject: Re: [RFC 2/3] USB: core: Add non-coherent buffer allocation helpers
Message-ID: <20180830175850.GA11521@infradead.org>
References: <20180830172030.23344-1-ezequiel@collabora.com>
 <20180830172030.23344-3-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180830172030.23344-3-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please don't introduce new DMA_ATTR_NON_CONSISTENT users, it is
a rather horrible interface, and I plan to kill it off rather sooner
than later.  I plan to post some patches for a better interface
that can reuse the normal dma_sync_single_* interfaces for ownership
transfers.  I can happily include usb in that initial patch set based
on your work here if that helps.

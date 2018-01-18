Return-path: <linux-media-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:51288 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756290AbeAROMD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 09:12:03 -0500
Date: Thu, 18 Jan 2018 09:11:58 -0500 (EST)
Message-Id: <20180118.091158.142992647744220505.davem@davemloft.net>
To: helgaas@kernel.org
Cc: hch@lst.de, bhelgaas@google.com, mchehab@kernel.org,
        kong.lai@tundra.com, linux-pci@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] tsi108_eth: use dma API properly
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180118000818.GD53542@bhelgaas-glaptop.roam.corp.google.com>
References: <20180110180322.30186-1-hch@lst.de>
        <20180110180322.30186-4-hch@lst.de>
        <20180118000818.GD53542@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bjorn Helgaas <helgaas@kernel.org>
Date: Wed, 17 Jan 2018 18:08:18 -0600

> [+cc David, FYI, I plan to merge this via PCI along with the rest of
> Christoph's series]

No problem.

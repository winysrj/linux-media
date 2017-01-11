Return-path: <linux-media-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:33558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdAKBU2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 20:20:28 -0500
Date: Tue, 10 Jan 2017 20:20:24 -0500 (EST)
Message-Id: <20170110.202024.798810764764725086.davem@davemloft.net>
To: hch@lst.de
Cc: linux-pci@vger.kernel.org, mchehab@s-opensource.com,
        netdev@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: kill off pci_enable_msi_{exact,range}
From: David Miller <davem@davemloft.net>
In-Reply-To: <1483994260-19797-1-git-send-email-hch@lst.de>
References: <1483994260-19797-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Christoph Hellwig <hch@lst.de>
Date: Mon,  9 Jan 2017 21:37:37 +0100

> I had hope that we could kill these old interfaces of for 4.10-rc,
> but as of today Linus tree still has two users:
> 
>  (1) the cobalt media driver, for which I sent a patch long time ago,
>      it got missed in the merge window.
>  (2) the new xgbe driver was merged in 4.10-rc but used the old interfaces
>      anyway
> 
> This series resend the patch for (1) and adds a new one for (2), as well
> as having the final removal patch behind it.  Maybe we should just queue
> up all three together in the PCI tree for 4.11?

Feel free to toss this into the PCI tree.

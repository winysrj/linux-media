Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34424 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754459AbeAOPLw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 10:11:52 -0500
Date: Mon, 15 Jan 2018 07:11:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kong Lai <kong.lai@tundra.com>, linux-pci@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tsi108_eth: use dma API properly
Message-ID: <20180115151148.GA7317@infradead.org>
References: <20180110180322.30186-1-hch@lst.de>
 <20180110180322.30186-4-hch@lst.de>
 <CAHp75VeyM+ctSPO5p3DGizR34woFn3=B+b0Uf+pxM5oXkbS=Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeyM+ctSPO5p3DGizR34woFn3=B+b0Uf+pxM5oXkbS=Zw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 10, 2018 at 10:09:20PM +0200, Andy Shevchenko wrote:
> > +       struct platform_device *pdev;
> 
> Do you really need platform_defice reference?
> 
> Perhaps
> 
> struct device *hdev; // hardware device
> 
> 
> data->hdev = &pdev->dev;
> 
> Another idea
> 
> dev->dev.parent = &pdev->dev;
> 
> No new member needed.

Maybe.  But what I've done is the simplest change in a long obsolete
driver that I don't understand at all.  I'd rather keep it simple.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from tatiana.utanet.at ([213.90.36.46]:51298 "EHLO tatiana.utanet.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755283AbeDYRrF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 13:47:05 -0400
Subject: Re: [Mjpeg-users] [PATCH] media: zoran: move to dma-mapping interface
To: MJPEG-tools user list <mjpeg-users@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20180424204158.2764095-1-arnd@arndb.de>
 <20180425061537.GA23383@infradead.org>
 <CAK8P3a06ragAPWpHGm-bGoZ8t6QyAttWJfD0jU_wcGy7FqLb5w@mail.gmail.com>
 <20180425072138.GA16375@infradead.org>
From: Bernhard Praschinger <shadowlord@utanet.at>
Message-ID: <9841d9a0-fd2e-96a6-3092-d12efa92ea6c@utanet.at>
Date: Wed, 25 Apr 2018 19:27:49 +0200
MIME-Version: 1.0
In-Reply-To: <20180425072138.GA16375@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hallo

Christoph Hellwig wrote:
> On Wed, Apr 25, 2018 at 09:08:13AM +0200, Arnd Bergmann wrote:
>>> That probably also means it can use dma_mmap_coherent instead of the
>>> handcrafted remap_pfn_range loop and the PageReserved abuse.
>>
>> I'd rather not touch that code. How about adding a comment about
>> the fact that it should use dma_mmap_coherent()?
>
> Maybe the real question is if there is anyone that actually cares
> for this driver, or if we are better off just removing it?
>
> Same is true for various other virt_to_bus using drivers, e.g. the
> grotty atm drivers.

I would appreciate if somebody would removes the driver from the linux 
kernel. I suggested that some years ago 2014-06-23 (just scroll down):
https://sourceforge.net/p/mjpeg/mailman/mjpeg-users/?viewmonth=201406

You should also find that thread in the kernel-janitors@vger.kernel.org 
and linux-media@vger.kernel.org Mailinglist archive.

I know of one person that is still using this old type of card's but he 
uses a 2.6.x Kernel on a old machine, using old software releases.
https://sourceforge.net/p/mjpeg/mailman/mjpeg-users/?viewmonth=201709

That type of card were introduced about ~20 years ago. I think it is a 
good moment to say goodbye to that type of cards.

auf hoffentlich bald,

Berni the Chaos of Woodquarter

Email: shadowlord@utanet.at
www: http://www.lysator.liu.se/~gz/bernhard

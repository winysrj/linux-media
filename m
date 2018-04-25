Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56008 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754612AbeDYP0j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 11:26:39 -0400
Date: Wed, 25 Apr 2018 08:26:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        mjpeg-users@lists.sourceforge.net,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: zoran: move to dma-mapping interface
Message-ID: <20180425152636.GC27076@infradead.org>
References: <20180424204158.2764095-1-arnd@arndb.de>
 <20180425061537.GA23383@infradead.org>
 <CAK8P3a06ragAPWpHGm-bGoZ8t6QyAttWJfD0jU_wcGy7FqLb5w@mail.gmail.com>
 <20180425072138.GA16375@infradead.org>
 <CAK8P3a1cs_SPesadAQhV3QU97WjNE8bLPSQCfaMQRU7zr_oh3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1cs_SPesadAQhV3QU97WjNE8bLPSQCfaMQRU7zr_oh3w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 01:15:18PM +0200, Arnd Bergmann wrote:
> That thought had occurred to me as well. I removed the oldest ISDN
> drivers already some years ago, and the OSS sound drivers
> got removed as well, and comedi got converted to the dma-mapping
> interfaces, so there isn't much left at all now. This is what we
> have as of v4.17-rc1:

Yes, I've been looking at various grotty old bits to purge.  Usually
I've been looking for some non-tree wide patches and CCed the last
active people to see if they care.  In a few cases people do, but
most often no one does.

> My feeling is that we want to keep most of the arch specific
> ones, in particular removing the m68k drivers would break
> a whole class of machines.

For the arch specific ones it would good to just ping the relevant
maintainers.  Especially m68k and parisc folks seems to be very
responsive.

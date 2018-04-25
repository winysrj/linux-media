Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35278 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754847AbeDYRWj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 13:22:39 -0400
Date: Wed, 25 Apr 2018 14:22:29 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        mjpeg-users@lists.sourceforge.net,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Trent Piepho <tpiepho@impinj.com>
Subject: Re: [PATCH] media: zoran: move to dma-mapping interface
Message-ID: <20180425142229.25d756ed@vento.lan>
In-Reply-To: <CAK8P3a0CHSC7yP3x8xDJgcg5xMzD1-sC-rmBJECtYvGFmyG4vQ@mail.gmail.com>
References: <20180424204158.2764095-1-arnd@arndb.de>
        <20180425061537.GA23383@infradead.org>
        <CAK8P3a06ragAPWpHGm-bGoZ8t6QyAttWJfD0jU_wcGy7FqLb5w@mail.gmail.com>
        <20180425072138.GA16375@infradead.org>
        <CAK8P3a1cs_SPesadAQhV3QU97WjNE8bLPSQCfaMQRU7zr_oh3w@mail.gmail.com>
        <20180425152636.GC27076@infradead.org>
        <CAK8P3a0CHSC7yP3x8xDJgcg5xMzD1-sC-rmBJECtYvGFmyG4vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 25 Apr 2018 17:58:25 +0200
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Wed, Apr 25, 2018 at 5:26 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Wed, Apr 25, 2018 at 01:15:18PM +0200, Arnd Bergmann wrote:  
> >> That thought had occurred to me as well. I removed the oldest ISDN
> >> drivers already some years ago, and the OSS sound drivers
> >> got removed as well, and comedi got converted to the dma-mapping
> >> interfaces, so there isn't much left at all now. This is what we
> >> have as of v4.17-rc1:  
> >
> > Yes, I've been looking at various grotty old bits to purge.  Usually
> > I've been looking for some non-tree wide patches and CCed the last
> > active people to see if they care.  In a few cases people do, but
> > most often no one does.  
> 
> Let's start with this one (zoran) then, as Mauro is keen on having
> all media drivers compile-testable on x86-64 and arm.
> 
> Trent Piepho and Hans Verkuil both worked on this driver in the
> 2008/2009 timeframe and those were the last commits from anyone
> who appears to have tested their patches on actual hardware.

Zoran is a driver for old hardware. I don't doubt that are people
out there still using it, but who knows?

I have a few those boards packed somewhere. I haven't work with PCI
hardware for a while. If needed, I can try to seek for them and
do some tests. I need first to unpack a machine with PCI slots...
the NUCs I generally use for development don't have any :-)

Anyway, except for virt_to_bus() and related stuff, I think that this
driver is in good shape, as Hans did a lot of work in the past to
make it to use the current media framework.

> 
> Trent, Hans: do you have reason to believe that there might still
> be users out there?
> 
>        Arnd



Thanks,
Mauro

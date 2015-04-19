Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36243 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbbDSHgK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2015 03:36:10 -0400
Received: by oift201 with SMTP id t201so104901271oif.3
        for <linux-media@vger.kernel.org>; Sun, 19 Apr 2015 00:36:09 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 19 Apr 2015 10:36:09 +0300
Message-ID: <CAM_ZknVRzewY23-ZGJrZxEmLa2k6DXyxb1pH-1dJ9tLV7VZ03w@mail.gmail.com>
Subject: On register r/w macros/procedures of drivers/media/pci
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Linux Media <linux-media@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"hans.verkuil" <hans.verkuil@cisco.com>, khalasa <khalasa@piap.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am starting a work on driver for techwell tw5864 media grabber&encoder.
I am basing on tw68 driver (mentorship, advising and testing by board
owners are appreciated). And here (and in some other
drivers/media/pci/ drivers) I see what confuses me:

tw68-core.c:
        dev->lmmio = ioremap(pci_resource_start(pci_dev, 0),
                             pci_resource_len(pci_dev, 0));
        dev->bmmio = (__u8 __iomem *)dev->lmmio;

tw68.h:
#define tw_readl(reg)           readl(dev->lmmio + ((reg) >> 2))
#define tw_readb(reg)           readb(dev->bmmio + (reg))
#define tw_writel(reg, value)   writel((value), dev->lmmio + ((reg) >> 2))
#define tw_writeb(reg, value)   writeb((value), dev->bmmio + (reg))

I am mostly userland developer and I wouldn't expect bmmio pointer to
contain value numerically different from lmmio after such simple
casting.
But still, if this is correct, then how should I implement
tw_{read,write}w to operate on 2 bytes (a word)? Similarly, it would
look like this:
#define tw_readl(reg)           readl(dev->lmmio + ((reg) >> 1))
That looks odd.

In contrary, in drivers/media/pci/dm1105, we see no explicit shifting
of register address. It uses {in,out}{b,w,l} macros, which seem to
turn out the same {read,write}{b,w,l} (with some reservations):
http://lxr.free-electrons.com/source/include/asm-generic/io.h#L354

dm1105.c:#define dm_io_mem(reg) ((unsigned long)(&dev->io_mem[reg]))
dm1105.c:#define dm_readb(reg)          inb(dm_io_mem(reg))
dm1105.c:#define dm_writeb(reg, value)  outb((value), (dm_io_mem(reg)))
dm1105.c:#define dm_readw(reg)          inw(dm_io_mem(reg))
dm1105.c:#define dm_writew(reg, value)  outw((value), (dm_io_mem(reg)))
dm1105.c:#define dm_readl(reg)          inl(dm_io_mem(reg))
dm1105.c:#define dm_writel(reg, value)  outl((value), (dm_io_mem(reg)))

This looks like contradiction to me (shifting register address vs. no
shifting), so that one practice may be even just wrong and broken
(which is hard to believe due to active maintenance of all drivers).
I highly appreciate your help me in determining the best practice to
follow in this new driver.
Thanks.

-- 
Bluecherry developer.

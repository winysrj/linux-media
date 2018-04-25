Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33880 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752864AbeDYLPU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 07:15:20 -0400
MIME-Version: 1.0
In-Reply-To: <20180425072138.GA16375@infradead.org>
References: <20180424204158.2764095-1-arnd@arndb.de> <20180425061537.GA23383@infradead.org>
 <CAK8P3a06ragAPWpHGm-bGoZ8t6QyAttWJfD0jU_wcGy7FqLb5w@mail.gmail.com> <20180425072138.GA16375@infradead.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 25 Apr 2018 13:15:18 +0200
Message-ID: <CAK8P3a1cs_SPesadAQhV3QU97WjNE8bLPSQCfaMQRU7zr_oh3w@mail.gmail.com>
Subject: Re: [PATCH] media: zoran: move to dma-mapping interface
To: Christoph Hellwig <hch@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        mjpeg-users@lists.sourceforge.net,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 9:21 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Apr 25, 2018 at 09:08:13AM +0200, Arnd Bergmann wrote:
>> > That probably also means it can use dma_mmap_coherent instead of the
>> > handcrafted remap_pfn_range loop and the PageReserved abuse.
>>
>> I'd rather not touch that code. How about adding a comment about
>> the fact that it should use dma_mmap_coherent()?
>
> Maybe the real question is if there is anyone that actually cares
> for this driver, or if we are better off just removing it?
>
> Same is true for various other virt_to_bus using drivers, e.g. the
> grotty atm drivers.

That thought had occurred to me as well. I removed the oldest ISDN
drivers already some years ago, and the OSS sound drivers
got removed as well, and comedi got converted to the dma-mapping
interfaces, so there isn't much left at all now. This is what we
have as of v4.17-rc1:

$ git grep -wl '\<bus_to_virt\|virt_to_bus\>' drivers/
drivers/atm/ambassador.c
drivers/atm/firestream.c
drivers/atm/horizon.c
drivers/atm/zatm.c
drivers/block/swim3.c # power mac specific
drivers/gpu/drm/mga/mga_dma.c # commented out
drivers/infiniband/hw/nes/nes_verbs.c # commented out
drivers/isdn/hisax/netjet.c
drivers/net/appletalk/ltpc.c
drivers/net/ethernet/amd/au1000_eth.c # mips specific
drivers/net/ethernet/amd/ni65.c # only in comment
drivers/net/ethernet/apple/bmac.c # power mac specific
drivers/net/ethernet/apple/mace.c # power mac specific
drivers/net/ethernet/dec/tulip/de4x5.c  # trivially fixable
drivers/net/ethernet/i825xx/82596.c # m68k specific
drivers/net/ethernet/i825xx/lasi_82596.c # parisc specific
drivers/net/ethernet/i825xx/lib82596.c # only in comment
drivers/net/ethernet/sgi/ioc3-eth.c # mips specific
drivers/net/wan/cosa.c
drivers/net/wan/lmc/lmc_main.c
drivers/net/wan/z85230.c
drivers/scsi/3w-xxxx.c # only in comment
drivers/scsi/BusLogic.c
drivers/scsi/a2091.c # m68k specific
drivers/scsi/a3000.c # m68k specific
drivers/scsi/dc395x.c # only in comment
drivers/scsi/dpt_i2o.c
drivers/scsi/gvp11.c # m68k specific
drivers/scsi/mvme147.c # m68k specific
drivers/scsi/qla1280.c # comment only
drivers/staging/netlogic/xlr_net.c # mips specific
drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c # ppc32 specific
drivers/vme/bridges/vme_ca91cx42.c

My feeling is that we want to keep most of the arch specific
ones, in particular removing the m68k drivers would break
a whole class of machines.

For the ones that don't have a comment on them, they
probably won't be missed much, but it's hard to know for
sure. What we do know is that they never worked on
x86_64, and most of them are for ISA cards.

        Arnd

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32919 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754324AbdHIRB6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 13:01:58 -0400
Received: by mail-wm0-f68.google.com with SMTP id q189so201521wmd.0
        for <linux-media@vger.kernel.org>; Wed, 09 Aug 2017 10:01:58 -0700 (PDT)
Date: Wed, 9 Aug 2017 19:01:52 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        rjkm@metzlerbros.de
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de
Subject: Re: [PATCH v2 03/14] [media] ddbridge: bump ddbridge code to
 version 0.9.29
Message-ID: <20170809190152.3c94adaa@macbox>
In-Reply-To: <20170809134731.60f97705@vento.lan>
References: <20170729112848.707-1-d.scheller.oss@gmail.com>
        <20170729112848.707-4-d.scheller.oss@gmail.com>
        <20170809134731.60f97705@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 9 Aug 2017 13:47:31 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> Em Sat, 29 Jul 2017 13:28:37 +0200
> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> 
> > From: Daniel Scheller <d.scheller@gmx.net>
> > 
> > This huge patch bumps the ddbridge driver to version 0.9.29.
> > Compared to the vendor driver package, DD OctoNET including GTL
> > link support, and all DVB-C Modulator card support has been removed
> > since this requires large changes to the underlying DVB core API,
> > which should eventually be done separately, and, after that, the
> > functionality/device support can be added back rather easy.
> > 
> > While the diff is rather large, the bump is mostly a big refactor
> > of all data structures. Yet, the MSI support (message signaled
> > interrupts) is greatly improved, also all currently available CI
> > single/duo bridge cards are fully supported.
> > 
> > More changes compared to the upstream driver:
> >  - the DDB_USE_WORKER flag/define was removed, kernel worker
> > functionality will be used.
> >  - coding style is properly fixed (zero complaints from checkpatch)
> >  - all (not much though) CamelCase has been fixed to kernel_case
> > 
> > Great care has been taken to keep all previous changes and fixes
> > (e.g. kernel logging via dev_*(), pointer annotations and such)
> > intact.
> > 
> > Permission to reuse and mainline the driver code was formally
> > granted by Ralph Metzler <rjkm@metzlerbros.de>.
> > 
> > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> > Tested-by: Richard Scobie <r.scobie@clear.net.nz>
> > Tested-by: Jasmin Jessich <jasmin@anw.at>
> > Tested-by: Dietmar Spingler <d_spingler@freenet.de>
> > Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
> > ---
> >  drivers/media/pci/ddbridge/ddbridge-core.c | 3496
> > ++++++++++++++++++++++------
> > drivers/media/pci/ddbridge/ddbridge-i2c.c  |  217 +-
> > drivers/media/pci/ddbridge/ddbridge-i2c.h  |   41 +-
> > drivers/media/pci/ddbridge/ddbridge-main.c |  490 ++--
> > drivers/media/pci/ddbridge/ddbridge-regs.h |  138 +-
> > drivers/media/pci/ddbridge/ddbridge.h      |  366 ++- 6 files
> > changed, 3613 insertions(+), 1135 deletions(-)
> > 
> > diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c
> > b/drivers/media/pci/ddbridge/ddbridge-core.c index
> > 7e164a370273..5045ad6c36fe 100644 ---
> > a/drivers/media/pci/ddbridge/ddbridge-core.c +++
> > b/drivers/media/pci/ddbridge/ddbridge-core.c @@ -1,7 +1,10 @@
> > [...]snip[...]
> > +struct ddb_i2c_msg {
> > +	__u8   bus;
> > +	__u8   adr;
> > +	__u8  *hdr;
> > +	__u32  hlen;
> > +	__u8  *msg;
> > +	__u32  mlen;
> >  };
> >  
> > -#define IOCTL_DDB_FLASHIO  _IOWR(DDB_MAGIC, 0x00, struct
> > ddb_flashio) +#define IOCTL_DDB_FLASHIO    _IOWR(DDB_MAGIC, 0x00,
> > struct ddb_flashio) +#define IOCTL_DDB_GPIO_IN    _IOWR(DDB_MAGIC,
> > 0x01, struct ddb_gpio) +#define IOCTL_DDB_GPIO_OUT
> > _IOWR(DDB_MAGIC, 0x02, struct ddb_gpio) +#define
> > IOCTL_DDB_ID         _IOR(DDB_MAGIC, 0x03, struct ddb_id) +#define
> > IOCTL_DDB_READ_REG   _IOWR(DDB_MAGIC, 0x04, struct ddb_reg)
> > +#define IOCTL_DDB_WRITE_REG  _IOW(DDB_MAGIC, 0x05, struct ddb_reg)
> > +#define IOCTL_DDB_READ_MEM   _IOWR(DDB_MAGIC, 0x06, struct
> > ddb_mem) +#define IOCTL_DDB_WRITE_MEM  _IOR(DDB_MAGIC, 0x07, struct
> > ddb_mem) +#define IOCTL_DDB_READ_MDIO  _IOWR(DDB_MAGIC, 0x08,
> > struct ddb_mdio) +#define IOCTL_DDB_WRITE_MDIO _IOR(DDB_MAGIC,
> > 0x09, struct ddb_mdio) +#define IOCTL_DDB_READ_I2C
> > _IOWR(DDB_MAGIC, 0x0a, struct ddb_i2c_msg) +#define
> > IOCTL_DDB_WRITE_I2C  _IOR(DDB_MAGIC, 0x0b, struct ddb_i2c_msg)  
> 
> That part of the driver is not OK. Those are part of some
> proprietary API. We need to discuss carefully all APIs that we're
> willing to introduce, to be sure that, whatever is there won't
> conflict with an existing API on Linux, and if it makes sense.

Uhh. Hm, well, these are just some IOCTLs solely used
on /dev/ddbridge/cardX devnodes to ie. be able to flash updated FPGA
code onto the cards using the dddvb userspace apps (and other things),
nothing thats intended for global use throughout the rest of the
kernel. While we can strip this from this patchset (together with the
ioctl handler), I really "prefer" not to do so since this will cause
breakage for users wanting to perform such updates.

Ping Ralph, really need help on this one. Can "some" of these go or is
DDB_FLASHIO enough for all tuner cards?

> Even if we accept it, those new APIs should be well documented.

What and where should that go? As mentioned, this is stuff solely used
for DD card control...

> Btw, I noticed that even the existing driver has already one such
> API, with is currently undocumented (IOCTL_DDB_FLASHIO). What's its
> purpose?

FPGA flashing as described above.

> PS.: As patches 1 and 2 are just code rearrangements, I'm applying
> them.

Thanks.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst

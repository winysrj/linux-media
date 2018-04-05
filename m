Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:43157 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751262AbeDEUpf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 16:45:35 -0400
Received: by mail-wr0-f193.google.com with SMTP id p53so30543584wrc.10
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2018 13:45:35 -0700 (PDT)
Date: Thu, 5 Apr 2018 22:45:29 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: Re: [PATCH 00/20] dddvb/ddbridge-0.9.33
Message-ID: <20180405224529.09980e1f@lt530>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon,  2 Apr 2018 20:24:07 +0200
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> This series brings all relevant changes from the upstream dddvb-0.9.33
> driver package to the in-kernel ddbridge and stv0910, though a few
> changes were picked up and merged previously already.
> 
> Summary of changes:
> * stv0910: initialisation fixes and fixed CNR reporting (uvalue vs.
>   svalue)
> * ddbridge: general code move, cleanups and fixups
> * ddbridge: fixes and improvements to the IRQ setup and handling, and
>   MSI-X support
> * ddbridge: configurable DMA buffers (via modparam)
> * ddbridge: dummy tuner option, useful for debugging and stress
> testing purposes
> * ddbridge: support for the new MCI card types, and namely the new
> MaxSX8 cards
> 
> Patches were build-tested in their order and are bisect safe. Besides
> the modparam move, everything is picked up from dddvb-0.9.33.
> 
> The series adds the new ddbridge-mci.[c|h] files. Here, SPDX headers
> were already put in place, but until things have been fully sorted
> out, the original GPL boiler plate is kept in place for now.
> 
> Please pick up and merge.
> 
> Daniel Scheller (20):
>   [media] dvb-frontends/stv0910: add init values for TSINSDELM/L
>   [media] dvb-frontends/stv0910: increase parallel TS output speed
>   [media] dvb-frontends/stv0910: fix CNR reporting in read_snr()
>   [media] ddbridge: move modparams to ddbridge-core.c
>   [media] ddbridge: move ddb_wq and the wq+class initialisation to
> -core [media] ddbridge: move MSI IRQ cleanup to a helper function
>   [media] ddbridge: request/free_irq using pci_irq_vector, enable
> MSI-X [media] ddbridge: add helper for IRQ handler setup
>   [media] ddbridge: add macros to handle IRQs in nibble and byte
> blocks [media] ddbridge: improve separated MSI IRQ handling
>   [media] ddbridge: use spin_lock_irqsave() in output_work()
>   [media] ddbridge: fix output buffer check
>   [media] ddbridge: set devid entry for link 0
>   [media] ddbridge: make DMA buffer count and size
> modparam-configurable [media] ddbridge: support dummy tuners with
> 125MByte/s dummy data stream
>   [media] ddbridge: initial support for MCI-based MaxSX8 cards
>   [media] ddbridge/max: implement MCI/MaxSX8 attach function
>   [media] ddbridge: add hardware defs and PCI IDs for MCI cards
>   [media] ddbridge: recognize and attach the MaxSX8 cards
>   [media] ddbridge: set driver version to 0.9.33-integrated
> 
>  drivers/media/dvb-frontends/stv0910.c      |  12 +-
>  drivers/media/pci/ddbridge/Kconfig         |   1 +
>  drivers/media/pci/ddbridge/Makefile        |   2 +-
>  drivers/media/pci/ddbridge/ddbridge-core.c | 299 +++++++++++-----
>  drivers/media/pci/ddbridge/ddbridge-hw.c   |  11 +
>  drivers/media/pci/ddbridge/ddbridge-i2c.c  |   5 +-
>  drivers/media/pci/ddbridge/ddbridge-main.c |  91 ++---
>  drivers/media/pci/ddbridge/ddbridge-max.c  |  42 +++
>  drivers/media/pci/ddbridge/ddbridge-max.h  |   1 +
>  drivers/media/pci/ddbridge/ddbridge-mci.c  | 550
> +++++++++++++++++++++++++++++
> drivers/media/pci/ddbridge/ddbridge-mci.h  | 152 ++++++++
> drivers/media/pci/ddbridge/ddbridge.h      |  50 +-- 12 files
> changed, 1030 insertions(+), 186 deletions(-) create mode 100644
> drivers/media/pci/ddbridge/ddbridge-mci.c create mode 100644
> drivers/media/pci/ddbridge/ddbridge-mci.h
> 

Please refrain from merging this as it is now. Recently, one issue has
been discovered with one of the stv0910 patches which renders at least
the CineS2 V7A cards (specifically the tuners soldered on them,
extensions will still work fine) unusable. Upstream has this issue
aswell. This is currently under investigation.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst

Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33392 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbeLCSgY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 13:36:24 -0500
Date: Mon, 3 Dec 2018 16:36:15 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.21] dvb fixes
Message-ID: <20181203163615.46222441@coco.lan>
In-Reply-To: <20181128194030.ywip2czls6euurr6@gofer.mess.org>
References: <20181128194030.ywip2czls6euurr6@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 28 Nov 2018 19:40:30 +0000
Sean Young <sean@mess.org> escreveu:

> Hi Mauro,
> 
> So I've gone through the outstanding DVB patches and picked up the easier
> ones to deal with first. Please scrutinise.

Thanks! Just one note. See below.


> 
> Thanks,
> 
> Sean
> 
> The following changes since commit 708d75fe1c7c6e9abc5381b6fcc32b49830383d0:
> 
>   media: dvb-pll: don't re-validate tuner frequencies (2018-11-23 12:27:18 -0500)
> 
> are available in the Git repository at:
> 
>   git://linuxtv.org/syoung/media_tree.git for-v4.21b
> 
> for you to fetch changes up to b2d148f755fc60840fbaec52388152896f8339be:
> 
>   media: sony-cxd2880: add optional vcc regulator to bindings (2018-11-27 16:04:16 +0000)
> 
> ----------------------------------------------------------------
> Colin Ian King (1):
>       media: dib0700: fix spelling mistake "Amplifyer" -> "Amplifier"
> 
> Hans Verkuil (1):
>       media: dib0900: fix smatch warnings
> 
> Julia Lawall (1):
>       media: mxl5xx: constify dvb_frontend_ops structure
> 
> Malcolm Priestley (1):
>       media: dvb-usb-v2: Fix incorrect use of transfer_flags URB_FREE_BUFFER
> 


> Neil Armstrong (3):
>       media: cxd2880-spi: fix probe when dvb_attach fails
>       media: cxd2880-spi: Add optional vcc regulator

Looks fine. You only forgot to add a:
    Acked-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

To the above patches. The Acked was written to patch 0/2. Patchwork
doesn't automatically handle replies to patch 0/x, so you need to
add the ack yourself ;-)

I added it myself and merged.

>       media: sony-cxd2880: add optional vcc regulator to bindings
> 
> Sean Young (1):
>       media: saa7134: rc-core maintains users count, no need to duplicate
> 
> Victor Toso (2):
>       media: af9033: Remove duplicated switch statement
>       media: dvb: Use WARM definition from identify_state()
> 
> zhong jiang (2):
>       media: usb: Use kmemdup instead of duplicating its function.
>       media: dvb-frontends: Use kmemdup instead of duplicating its function
> 
>  .../devicetree/bindings/media/spi/sony-cxd2880.txt |  4 ++
>  drivers/media/dvb-frontends/af9033.c               | 12 +---
>  drivers/media/dvb-frontends/dib0090.c              | 32 +++++-----
>  drivers/media/dvb-frontends/lgdt3306a.c            |  6 +-
>  drivers/media/dvb-frontends/mxl5xx.c               |  2 +-
>  drivers/media/pci/saa7134/saa7134-core.c           |  8 +--
>  drivers/media/pci/saa7134/saa7134-input.c          | 68 ++++------------------
>  drivers/media/pci/saa7134/saa7134.h                |  9 ++-
>  drivers/media/spi/cxd2880-spi.c                    | 17 ++++++
>  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |  6 +-
>  drivers/media/usb/dvb-usb-v2/gl861.c               |  3 +-
>  drivers/media/usb/dvb-usb-v2/usb_urb.c             |  5 +-
>  drivers/media/usb/dvb-usb/dib0700_devices.c        |  2 +-
>  13 files changed, 66 insertions(+), 108 deletions(-)



Thanks,
Mauro

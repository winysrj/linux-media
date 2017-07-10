Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36374 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753426AbdGJPb3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 11:31:29 -0400
Received: by mail-wr0-f195.google.com with SMTP id 77so25671177wrb.3
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 08:31:28 -0700 (PDT)
Date: Mon, 10 Jul 2017 17:31:24 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, jasmin@anw.at, d_spingler@gmx.de
Subject: Re: [PATCH 00/14] ddbridge: bump to ddbridge-0.9.29
Message-ID: <20170710173124.653286e7@audiostation.wuest.de>
In-Reply-To: <22883.13973.46880.749847@morden.metzler>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
        <22883.13973.46880.749847@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 10 Jul 2017 10:11:01 +0200
schrieb Ralph Metzler <rjkm@metzlerbros.de>:

> Daniel Scheller writes:
>  > Stripped functionality compared to dddvb:
>  > 
>  >  - DVB-C modulator card support removed (requires DVB core API)  
> 
> not really besides one device name entry.

... and a header :-) Maybe we should start another thread on this for a
probable follow-up project.

>  >  - OctoNET SAT>IP server/box support removed (requires API aswell)
>  >  - with this, GT link support was removed (only on OctoNET
>  > hardware)  
> 
> There is other PCIe based hardware which uses/will use this.

Umm, good to know - thus better shouldn't (even accidentally)
throw away the remove-revert of the GTL support for future cards.

>  >  drivers/media/pci/ddbridge/ddbridge-core.c | 4242
>  > ++++++++++++++++++----------
>  > drivers/media/pci/ddbridge/ddbridge-hw.c   |  299 ++
>  > drivers/media/pci/ddbridge/ddbridge-hw.h   |   52 +
>  > drivers/media/pci/ddbridge/ddbridge-i2c.c  |  310 ++
>  > drivers/media/pci/ddbridge/ddbridge-io.h   |   71 +
>  > drivers/media/pci/ddbridge/ddbridge-irq.c  |  161 ++
>  > drivers/media/pci/ddbridge/ddbridge-main.c |  393 +++
>  > drivers/media/pci/ddbridge/ddbridge-regs.h |  138 +-
>  > drivers/media/pci/ddbridge/ddbridge.h      |  355 ++-  
> 
> I thought we settled on core, i2c, main, (and mod, ns, which you do
> not include). This will diverge then from my code.

IIRC this was -main.c, and basically the code split, but no specific
file. However, each of the additionals (hw, io, irq) were done with a
reason (please also see their commit messages at patches 4-6):

-io.h is there since the comparably complex functions in the original
ddbridge.h sort of scared me off and IMHO shouldn't live together with
struct definitions and such, so I moved them to a separate object
first. With the GTL things removed, the remainder was rather small, and
Jasmin pointed me in the "make it static inline in a header instead"
direction. When eventually GTL gets added back, it should go into it's
own object/module.

-hw.c/h moves all things hardware-definition/info related like regmaps
into one single place, currently it's spread out into -main and -core,
which might make things difficult to find.

-irq.c gets rid of the need of additional ifdefs related to
CONFIG_PCI_MSI, in that "defined but unused function" warnings are
generated if this isn't defined. Again, also makes it easier to find,
rather than search through ~3800 lines of -core :)

If you're comfortable with this, I will propose it via a GitHub PR as
well (alongside the other things I'd like to push out to you). For the
in-kernel code, I'd prefer to keep it like this.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst

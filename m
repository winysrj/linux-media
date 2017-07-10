Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:14355 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbdGJILc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 04:11:32 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <22883.13973.46880.749847@morden.metzler>
Date: Mon, 10 Jul 2017 10:11:01 +0200
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, jasmin@anw.at, d_spingler@gmx.de,
        rjkm@metzlerbros.de
Subject: [PATCH 00/14] ddbridge: bump to ddbridge-0.9.29
In-Reply-To: <20170709194221.10255-1-d.scheller.oss@gmail.com>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel Scheller writes:
 > Stripped functionality compared to dddvb:
 > 
 >  - DVB-C modulator card support removed (requires DVB core API)

not really besides one device name entry.

 >  - OctoNET SAT>IP server/box support removed (requires API aswell)
 >  - with this, GT link support was removed (only on OctoNET hardware)

There is other PCIe based hardware which uses/will use this.


 >  drivers/media/pci/ddbridge/ddbridge-core.c | 4242 ++++++++++++++++++----------
 >  drivers/media/pci/ddbridge/ddbridge-hw.c   |  299 ++
 >  drivers/media/pci/ddbridge/ddbridge-hw.h   |   52 +
 >  drivers/media/pci/ddbridge/ddbridge-i2c.c  |  310 ++
 >  drivers/media/pci/ddbridge/ddbridge-io.h   |   71 +
 >  drivers/media/pci/ddbridge/ddbridge-irq.c  |  161 ++
 >  drivers/media/pci/ddbridge/ddbridge-main.c |  393 +++
 >  drivers/media/pci/ddbridge/ddbridge-regs.h |  138 +-
 >  drivers/media/pci/ddbridge/ddbridge.h      |  355 ++-

I thought we settled on core, i2c, main, (and mod, ns, which you do not include).
This will diverge then from my code.


Regards,
Ralph

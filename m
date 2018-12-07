Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,T_DKIMWL_WL_HIGH autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 601F4C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 14:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19C9F20892
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 14:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544192249;
	bh=6NcJ3xQ9A5qrp3uJXpYMPTByQyxFENmNHF+19jjjdvA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=gji5JBS0ZFeujGlPzIROc5+/ariFWXl25eWzSR+e4h24tMvWbZOomJ7QRpHiVLVaT
	 dXBnMK7OVCESH+5zKBbBf52wZZV0WMl80JJT0GoWn9DpEBdILeel9P1moZJ0g/bQU0
	 RhipYjcSqmoIXTJqU0Ukohiw5JfPnbd0S8g8eqxc=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19C9F20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbeLGOR2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 09:17:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:33550 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbeLGOR2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 09:17:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3NJUg+OqzgRjTt43Q2UALvblhgcINV7FtZosa5ILxyo=; b=YYmnuT8u5xPrluezcle5n6zXtY
        jyyflnWNKOTCM0KrjszrbpQIJh4AipRDvoq+yH3MT6cJUX5XPB/ajIfam7WWmu15WAdatpn/6iY82
        kMBNDM9+JaPEDkeYT1Wv8WIpz8n8Zdb0Bexrd4xx9WSOxD1x+Xhy25hKUvboL6IFfCbPGwxsj+gmc
        ZxMCKHR57j9TdL4+HPSvNQdO+6ZA/+23pCnY9m7Rs+4vucSXir4hhJUshSde4CfIsM/9HooDi8vPe
        wg66MozzNEExuZCEbnrRKKjvVIBELtPrw7vhFpqXF5HeD6XWhzD1q8itHchIRt7yr57rZlcnlWbuq
        41KE5iIw==;
Received: from [179.95.33.236] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVGwT-0004CS-Ha; Fri, 07 Dec 2018 14:17:22 +0000
Date:   Fri, 7 Dec 2018 12:17:16 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com>
Cc:     <linux-media@vger.kernel.org>,
        "Masami Hiramatsu" <masami.hiramatsu@linaro.org>,
        "Jassi Brar" <jaswinder.singh@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Sean Young <sean@mess.org>, Brad Love <brad@nextdimension.cc>
Subject: Re: [PATCH v2 0/7] add UniPhier DVB Frontend system support
Message-ID: <20181207121716.17521ac2@coco.lan>
In-Reply-To: <000301d43ffe$9e6e9f80$db4bde80$@socionext.com>
References: <20180808052519.14528-1-suzuki.katsuhiro@socionext.com>
        <000301d43ffe$9e6e9f80$db4bde80$@socionext.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Katsuhiro-san,

Em Thu, 30 Aug 2018 10:13:11 +0900
"Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com> escreveu:

> Hello Mauro,
> 
> This is ping...

Sorry for taking a long time to look into it.

Reviewing new drivers take some time, and need to be done right.

I usually let the sub-maintainers to do a first look, but they
probably missed this one. So, let me copy them. Hopefully they
can do review on it soon.

I'll try to do a review myself, but I won't be able to do it
until mid next week.

Regards,
Mauro

> 
> > -----Original Message-----
> > From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> > Sent: Wednesday, August 8, 2018 2:25 PM
> > To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>;
> > linux-media@vger.kernel.org
> > Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>; Jassi Brar
> > <jaswinder.singh@linaro.org>; linux-arm-kernel@lists.infradead.org;
> > linux-kernel@vger.kernel.org; Suzuki, Katsuhiro 
> > <suzuki.katsuhiro@socionext.com>
> > Subject: [PATCH v2 0/7] add UniPhier DVB Frontend system support
> > 
> > This series adds support for DVB Frontend system named HSC support
> > for UniPhier LD11/LD20 SoCs. This driver supports MPEG2-TS serial
> > signal input from external demodulator and DMA MPEG2-TS stream data
> > onto memory.
> > 
> > UniPhier HSC driver provides many ports of TS input. Since the HSC
> > has mixed register map for those ports. It hard to split each register
> > areas.
> > 
> > ---
> > 
> > Changes from v1:
> >   DT bindings
> >     - Fix mistakes of spelling
> >     - Rename uniphier,hsc.txt -> socionext,uniphier-hsc.txt
> >   Kconfig, Makefile
> >     - Add COMPILE_TEST, REGMAP_MMIO
> >     - Add $(srctree) to include path option
> >   Headers
> >     - Split large patch
> >     - Remove more unused definitions
> >     - Remove unneeded const
> >     - Replace enum that has special value into #define
> >     - Remove weird macro from register definitions
> >     - Remove field_get/prop inline functions
> >   Modules
> >     - Split register definitions, function prototypes
> >     - Fix include lines
> >     - Fix depended config
> >     - Remove redundant conditions
> >     - Drop adapter patches, and need no patches to build
> >     - Merge uniphier-adapter.o into each adapter drivers
> >     - Split 3 modules (core, ld11, ld20) to build adapter drivers as
> >       module
> >     - Fix compile error if build as module
> >     - Use hardware spec table to remove weird macro from register
> >       definitions
> >     - Use usleep_range instead of msleep
> >     - Use shift and mask instead of field_get/prop inline functions
> > 
> > Katsuhiro Suzuki (7):
> >   media: uniphier: add DT bindings documentation for UniPhier HSC
> >   media: uniphier: add DMA common file of HSC
> >   media: uniphier: add CSS common file of HSC
> >   media: uniphier: add TS common file of HSC
> >   media: uniphier: add ucode load common file of HSC
> >   media: uniphier: add platform driver module of HSC
> >   media: uniphier: add LD11/LD20 HSC support
> > 
> >  .../bindings/media/socionext,uniphier-hsc.txt |  38 ++
> >  drivers/media/platform/Kconfig                |   1 +
> >  drivers/media/platform/Makefile               |   2 +
> >  drivers/media/platform/uniphier/Kconfig       |  19 +
> >  drivers/media/platform/uniphier/Makefile      |   5 +
> >  drivers/media/platform/uniphier/hsc-core.c    | 515 ++++++++++++++++++
> >  drivers/media/platform/uniphier/hsc-css.c     | 250 +++++++++
> >  drivers/media/platform/uniphier/hsc-dma.c     | 212 +++++++
> >  drivers/media/platform/uniphier/hsc-ld11.c    | 273 ++++++++++
> >  drivers/media/platform/uniphier/hsc-reg.h     | 272 +++++++++
> >  drivers/media/platform/uniphier/hsc-ts.c      | 127 +++++
> >  drivers/media/platform/uniphier/hsc-ucode.c   | 416 ++++++++++++++
> >  drivers/media/platform/uniphier/hsc.h         | 389 +++++++++++++
> >  13 files changed, 2519 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/media/socionext,uniphier-hsc.txt
> >  create mode 100644 drivers/media/platform/uniphier/Kconfig
> >  create mode 100644 drivers/media/platform/uniphier/Makefile
> >  create mode 100644 drivers/media/platform/uniphier/hsc-core.c
> >  create mode 100644 drivers/media/platform/uniphier/hsc-css.c
> >  create mode 100644 drivers/media/platform/uniphier/hsc-dma.c
> >  create mode 100644 drivers/media/platform/uniphier/hsc-ld11.c
> >  create mode 100644 drivers/media/platform/uniphier/hsc-reg.h
> >  create mode 100644 drivers/media/platform/uniphier/hsc-ts.c
> >  create mode 100644 drivers/media/platform/uniphier/hsc-ucode.c
> >  create mode 100644 drivers/media/platform/uniphier/hsc.h
> > 
> > --
> > 2.18.0  
> 
> 
> 



Thanks,
Mauro

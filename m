Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0108.outbound.protection.outlook.com ([104.47.36.108]:38806
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750854AbeEJEkR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 May 2018 00:40:17 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <mchehab+samsung@kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <fabien.dessenne@st.com>, <jean-christophe.trotin@st.com>,
        <sakari.ailus@linux.intel.com>
CC: <mcgrof@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <Yasunari.Takiguchi@sony.com>
Subject: RE: Are media drivers abusing of GFP_DMA? - was: Re: [LSF/MM TOPIC
 NOTES] x86 ZONE_DMA love
Date: Thu, 10 May 2018 04:39:58 +0000
Message-ID: <02699364973B424C83A42A84B04FDA854A3893@JPYOKXMS113.jp.sony.com>
References: <20180426215406.GB27853@wotan.suse.de>
 <20180505130815.53a26955@vento.lan>
In-Reply-To: <20180505130815.53a26955@vento.lan>
Content-Language: ja-JP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mauro

> -----Original Message-----
> 
> There was a recent discussion about the use/abuse of GFP_DMA flag when
> allocating memories at LSF/MM 2018 (see Luis notes enclosed).
> 
> The idea seems to be to remove it, using CMA instead. Before doing that,
> better to check if what we have on media is are valid use cases for it,
> or
> if it is there just due to some misunderstanding (or because it was
> copied from some other code).
> 
> Hans de Goede sent us today a patch stopping abuse at gspca, and I'm
> also posting today two other patches meant to stop abuse of it on USB
> drivers. Still, there are 4 platform drivers using it:
> 
> 	$ git grep -l -E "GFP_DMA\\b" drivers/media/
> 	drivers/media/platform/omap3isp/ispstat.c
> 	drivers/media/platform/sti/bdisp/bdisp-hw.c
> 	drivers/media/platform/sti/hva/hva-mem.c
> 	drivers/media/spi/cxd2880-spi.c
> 
> Could you please check if GFP_DMA is really needed there, or if it is
> just because of some cut-and-paste from some other place?
About drivers/media/spi/cxd2880-spi.c,
we referred to kmalloc of driver/spi/spi.c spi_write_then_read() function and made this code. 

Regards,
Takiguchi

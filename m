Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55810 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752276AbeEGPT1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 11:19:27 -0400
Date: Mon, 7 May 2018 12:19:16 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Fabien Dessenne <fabien.dessenne@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: Are media drivers abusing of GFP_DMA? - was: Re: [LSF/MM TOPIC
 NOTES] x86 ZONE_DMA love
Message-ID: <20180507121916.4eb7f5b2@vento.lan>
In-Reply-To: <3561479.qPIcrWnXEC@avalon>
References: <20180426215406.GB27853@wotan.suse.de>
        <20180505130815.53a26955@vento.lan>
        <3561479.qPIcrWnXEC@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 07 May 2018 16:26:08 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Saturday, 5 May 2018 19:08:15 EEST Mauro Carvalho Chehab wrote:
> > There was a recent discussion about the use/abuse of GFP_DMA flag when
> > allocating memories at LSF/MM 2018 (see Luis notes enclosed).
> > 
> > The idea seems to be to remove it, using CMA instead. Before doing that,
> > better to check if what we have on media is are valid use cases for it, or
> > if it is there just due to some misunderstanding (or because it was
> > copied from some other code).
> > 
> > Hans de Goede sent us today a patch stopping abuse at gspca, and I'm
> > also posting today two other patches meant to stop abuse of it on USB
> > drivers. Still, there are 4 platform drivers using it:
> > 
> > 	$ git grep -l -E "GFP_DMA\\b" drivers/media/
> > 	drivers/media/platform/omap3isp/ispstat.c
> > 	drivers/media/platform/sti/bdisp/bdisp-hw.c
> > 	drivers/media/platform/sti/hva/hva-mem.c
> > 	drivers/media/spi/cxd2880-spi.c
> > 
> > Could you please check if GFP_DMA is really needed there, or if it is
> > just because of some cut-and-paste from some other place?  
> 
> I started looking at that for the omap3isp driver but Sakari beat me at 
> submitting a patch. GFP_DMA isn't needed for omap3isp.
> 
Thank you both for looking into it.

Regards,
Mauro



Thanks,
Mauro

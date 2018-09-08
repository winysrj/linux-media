Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:33874 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726472AbeIHOvi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Sep 2018 10:51:38 -0400
Subject: Re: [PATCH 0/2] Follow-up patches for Cedrus v9
To: Paul Kocialkowski <contact@paulk.fr>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-sunxi@googlegroups.com,
        Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20180907163347.32312-1-contact@paulk.fr>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <11104c03-97ac-8b36-7d75-dfecb8fcce10@xs4all.nl>
Date: Sat, 8 Sep 2018 12:06:15 +0200
MIME-Version: 1.0
In-Reply-To: <20180907163347.32312-1-contact@paulk.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2018 06:33 PM, Paul Kocialkowski wrote:
> This brings the requested modifications on top of version 9 of the
> Cedrus VPU driver, that implements stateless video decoding using the
> Request API.
> 
> Paul Kocialkowski (2):
>   media: cedrus: Fix error reporting in request validation
>   media: cedrus: Add TODO file with tasks to complete before unstaging
> 
>  drivers/staging/media/sunxi/cedrus/TODO     |  7 +++++++
>  drivers/staging/media/sunxi/cedrus/cedrus.c | 15 ++++++++++++---
>  2 files changed, 19 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/staging/media/sunxi/cedrus/TODO
> 

So close...

When compiling under e.g. intel I get errors since it doesn't know about
the sunxi_sram_claim/release function and the PHYS_PFN_OFFSET define.

Is it possible to add stub functions to linux/soc/sunxi/sunxi_sram.h
if CONFIG_SUNXI_SRAM is not defined? That would be the best fix for that.

The use of PHYS_PFN_OFFSET is weird: are you sure this is the right
way? I see that drivers/of/device.c also sets dev->dma_pfn_offset, which
makes me wonder if this information shouldn't come from the device tree.

You are the only driver that uses this define directly, which makes me
suspicious.

Regards,

	Hans

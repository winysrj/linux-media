Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23006 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbbFLJXF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 05:23:05 -0400
Date: Fri, 12 Jun 2015 14:54:24 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
	dmaengine@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] genalloc: rename of_get_named_gen_pool() to
 of_gen_pool_get()
Message-ID: <20150612092424.GF28601@localhost>
References: <1434029192-7082-1-git-send-email-vladimir_zapolskiy@mentor.com>
 <1434029312-7288-1-git-send-email-vladimir_zapolskiy@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1434029312-7288-1-git-send-email-vladimir_zapolskiy@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 11, 2015 at 04:28:32PM +0300, Vladimir Zapolskiy wrote:
> To be consistent with other kernel interface namings, rename
> of_get_named_gen_pool() to of_gen_pool_get(). In the original
> function name "_named" suffix references to a device tree property,
> which contains a phandle to a device and the corresponding
> device driver is assumed to register a gen_pool object.
> 
> Due to a weak relation and to avoid any confusion (e.g. in future
> possible scenario if gen_pool objects are named) the suffix is
> removed.
> 
> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> ---
>  drivers/dma/mmp_tdma.c                    | 2 +-
For this:

Acked-by: Vinod Koul <vinod.koul@intel.com>

-- 
~Vinod


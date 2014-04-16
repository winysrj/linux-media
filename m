Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30496 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaDPGhu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 02:37:50 -0400
Date: Wed, 16 Apr 2014 11:57:54 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: dmaengine@vger.kernel.org, linux-media@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] [media] platform: Fix timberdale dependencies
Message-ID: <20140416062754.GI32284@intel.com>
References: <20140403113206.0aab763f@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403113206.0aab763f@endymion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 03, 2014 at 11:32:06AM +0200, Jean Delvare wrote:
> VIDEO_TIMBERDALE selects TIMB_DMA which itself depends on
> MFD_TIMBERDALE, so VIDEO_TIMBERDALE should either select or depend on
> MFD_TIMBERDALE as well. I chose to make it depend on it because I
> think it makes more sense and it is consistent with what other options
> are doing.
> 
> Adding a "|| HAS_IOMEM" to the TIMB_DMA dependencies silenced the
> kconfig warning about unmet direct dependencies but it was wrong:
> without MFD_TIMBERDALE, TIMB_DMA is useless as the driver has no
> device to bind to.

Applied, thanks

-- 
~Vinod

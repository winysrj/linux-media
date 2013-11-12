Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab3KLEqc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 23:46:32 -0500
Date: Tue, 12 Nov 2013 09:20:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolin Chen <b42378@freescale.com>
Cc: akpm@linux-foundation.org, joe@perches.com, nsekhar@ti.com,
	khilman@deeprootsystems.com, linux@arm.linux.org.uk,
	dan.j.williams@intel.com, m.chehab@samsung.com, hjk@hansjkoch.de,
	gregkh@linuxfoundation.org, perex@perex.cz, tiwai@suse.de,
	lgirdwood@gmail.com, broonie@kernel.org,
	rmk+kernel@arm.linux.org.uk, eric.y.miao@gmail.com,
	haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH][RESEND 3/8] dma: mmp_tdma: use gen_pool_dma_alloc() to
 allocate descriptor
Message-ID: <20131112035035.GD8834@intel.com>
References: <cover.1383306365.git.b42378@freescale.com>
 <b7d5dce9fcc118a60261824196c820de6fb434a2.1383306365.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7d5dce9fcc118a60261824196c820de6fb434a2.1383306365.git.b42378@freescale.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 01, 2013 at 07:48:16PM +0800, Nicolin Chen wrote:
> Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod

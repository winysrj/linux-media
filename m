Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:46480 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbcCGOqa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2016 09:46:30 -0500
Date: Mon, 7 Mar 2016 20:20:37 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Benoit Parrot <bparrot@ti.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Jiri Kosina <trivial@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Alexandre Bounine <alexandre.bounine@idt.com>,
	linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-nvdimm@lists.01.org
Subject: Re: [TRIVIAL PATCH] treewide: Remove unnecessary 0x prefixes before
 %pa extension uses
Message-ID: <20160307145037.GF11154@localhost>
References: <dcdebc08a17023fac93595312281cb8e91185668.1457162650.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcdebc08a17023fac93595312281cb8e91185668.1457162650.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 04, 2016 at 11:46:32PM -0800, Joe Perches wrote:
> Since commit 3cab1e711297 ("lib/vsprintf: refactor duplicate code
> to special_hex_number()") %pa uses have been ouput with a 0x prefix.
> 
> These 0x prefixes in the formats are unnecessary.
> 

For this:
>  drivers/dma/at_hdmac_regs.h              | 2 +-

Acked-by: Vinod Koul <vinod.koul@intel.com>

-- 
~Vinod

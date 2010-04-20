Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:42672 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab0DTHBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 03:01:07 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Pawel Osciak <p.osciak@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Date: Tue, 20 Apr 2010 12:30:59 +0530
Subject: RE: [PATCH v4 0/2] Mem-to-mem device framework
Message-ID: <19F8576C6E063C45BE387C64729E7394044E137814@dbde02.ent.ti.com>
References: <1271680218-32395-1-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1271680218-32395-1-git-send-email-p.osciak@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Pawel Osciak [mailto:p.osciak@samsung.com]
> Sent: Monday, April 19, 2010 6:00 PM
> To: linux-media@vger.kernel.org
> Cc: p.osciak@samsung.com; m.szyprowski@samsung.com;
> kyungmin.park@samsung.com; Hiremath, Vaibhav
> Subject: [PATCH v4 0/2] Mem-to-mem device framework
> 
> Hello,
> 
> this is the fourth version of the mem-to-mem device framework.
> 
> Changes in v4:
> - v4l2_m2m_poll() now also reports POLLOUT | POLLWRNORM when an output
>   buffer is ready to be dequeued
> - more cleaning up, addressing most of the comments to v3
> 
> Vaibhav: your clean-up patch didn't apply after my changes. I incorporated
> most
> of your clean-up changes. If you prefer it to be separate, we will have
> to prepare another one somehow. 
[Hiremath, Vaibhav] No need to create separate patch for this, it's ok as long as you included all the required changes.

You can add "Tested-By" Or "Reviewed-By" in your patch series, that should be ok.

I will take a final look to this patch and respond.

> Also, sorry, but I cannot agree with
> changing
> unsigned types into u32, I do not see any reason to use fixed-width types
> there.
> 
[Hiremath, Vaibhav] As I mentioned there no strict rule for this, it was learning from my first patch.

Thanks,
Vaibhav
> This series contains:
> [PATCH v4 1/2] v4l: Add memory-to-memory device helper framework for
> videobuf.
> [PATCH v4 2/2] v4l: Add a mem-to-mem videobuf framework test device.
> 
> Best regards
> --
> Pawel Osciak
> Linux Platform Group
> Samsung Poland R&D Center

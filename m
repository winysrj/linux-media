Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:45739 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932095Ab2JBQk1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 12:40:27 -0400
Date: Tue, 2 Oct 2012 09:40:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ido Yariv <ido@wizery.com>
Cc: Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/5] iommu/omap: Merge iommu2.h into iommu.h
Message-ID: <20121002164021.GS4840@atomide.com>
References: <20120927195526.GP4840@atomide.com>
 <1349131591-10804-1-git-send-email-ido@wizery.com>
 <1349131591-10804-2-git-send-email-ido@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349131591-10804-2-git-send-email-ido@wizery.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Ido Yariv <ido@wizery.com> [121001 15:48]:
> Since iommu is not supported on OMAP1 and will not likely to ever be
> supported, merge plat/iommu2.h into iommu.h so only one file would have
> to move to platform_data/ as part of the single zImage effort.

Thanks I'll be applying patches 2 - 5 once we have -rc1 available.

Regards,

Tony

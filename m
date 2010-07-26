Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:44944 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab0GZTek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 15:34:40 -0400
From: "Sin, David" <davidsin@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Kanigeri, Hari" <h-kanigeri2@ti.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
	"Molnar, Lajos" <molnar@ti.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 26 Jul 2010 14:34:30 -0500
Subject: RE: [RFC 4/8] TILER-DMM: TILER Memory Manager interface and
	implementation
Message-ID: <513FF747EED39B4AADBB4D6C9D9F9F7903D63B9DD3@dlee02.ent.ti.com>
References: <1279927348-21750-1-git-send-email-davidsin@ti.com>
 <1279927348-21750-2-git-send-email-davidsin@ti.com>
 <1279927348-21750-3-git-send-email-davidsin@ti.com>
 <1279927348-21750-4-git-send-email-davidsin@ti.com>
 <1279927348-21750-5-git-send-email-davidsin@ti.com>
 <20100724080118.GB15064@n2100.arm.linux.org.uk>
In-Reply-To: <20100724080118.GB15064@n2100.arm.linux.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK -- I will revisit this.  Thanks for the explanation.

-David

-----Original Message-----
From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] 
Sent: Saturday, July 24, 2010 3:01 AM
To: Sin, David
Cc: linux-arm-kernel@lists.arm.linux.org.uk; linux-omap@vger.kernel.org; Tony Lindgren; Kanigeri, Hari; Ohad Ben-Cohen; Hiremath, Vaibhav; Shilimkar, Santosh; Molnar, Lajos
Subject: Re: [RFC 4/8] TILER-DMM: TILER Memory Manager interface and implementation

On Fri, Jul 23, 2010 at 06:22:24PM -0500, David Sin wrote:
> +/* allocate and flush a page */
> +static struct mem *alloc_mem(void)
> +{
> +	struct mem *m = kzalloc(sizeof(*m), GFP_KERNEL);
> +	if (!m)
> +		return NULL;
> +
> +	m->pg = alloc_page(GFP_KERNEL | GFP_DMA);
> +	if (!m->pg) {
> +		kfree(m);
> +		return NULL;
> +	}
> +
> +	m->pa = page_to_phys(m->pg);
> +
> +	/* flush the cache entry for each page we allocate. */
> +	dmac_flush_range(page_address(m->pg),
> +				page_address(m->pg) + PAGE_SIZE);
> +	outer_flush_range(m->pa, m->pa + PAGE_SIZE);

NAK.  This is an abuse of these interfaces, and is buggy in any case.

ARMv6 and ARMv7 CPUs speculatively prefetch memory, which means that
there's no guarantee that if you flush the caches for a particular
range of virtual space, that it will stay flushed until you decide
to read it.  So flushing the caches in some memory allocator can't
guarantee that when you eventually get around to using the page that
there won't be cache lines associated with it.

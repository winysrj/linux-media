Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41629 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab0GZT2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 15:28:23 -0400
From: "Sin, David" <davidsin@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Kanigeri, Hari" <h-kanigeri2@ti.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
	"Molnar, Lajos" <molnar@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 26 Jul 2010 14:28:17 -0500
Subject: RE: [RFC 1/8] TILER-DMM: DMM-PAT driver for TI TILER
Message-ID: <513FF747EED39B4AADBB4D6C9D9F9F7903D63B9DC0@dlee02.ent.ti.com>
References: <1279927348-21750-1-git-send-email-davidsin@ti.com>
 <1279927348-21750-2-git-send-email-davidsin@ti.com>
 <20100724080915.GC15064@n2100.arm.linux.org.uk>
In-Reply-To: <20100724080915.GC15064@n2100.arm.linux.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, Russel, for your comments.  I will rework the RFC and send out a v2 soon.  

-----Original Message-----
From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] 
Sent: Saturday, July 24, 2010 3:09 AM
To: Sin, David
Cc: linux-arm-kernel@lists.arm.linux.org.uk; linux-omap@vger.kernel.org; Tony Lindgren; Kanigeri, Hari; Ohad Ben-Cohen; Hiremath, Vaibhav; Shilimkar, Santosh; Molnar, Lajos
Subject: Re: [RFC 1/8] TILER-DMM: DMM-PAT driver for TI TILER

On Fri, Jul 23, 2010 at 06:22:21PM -0500, David Sin wrote:
> +static struct platform_driver dmm_driver_ldm = {
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = "dmm",
> +	},
> +	.probe = NULL,
> +	.shutdown = NULL,
> +	.remove = NULL,
> +};

What's the point of this driver structure? [dhs] -- This is pretty much incomplete.  I will revist this based on the suggestions you and Santosh have given in the other e-mail replies. 

> +s32 dmm_pat_refill(struct dmm *dmm, struct pat *pd, enum pat_mode mode)
> +{
> +	void __iomem *r;
> +	u32 v;
> +
> +	/* Only manual refill supported */
> +	if (mode != MANUAL)
> +		return -EFAULT;
> +
> +	/* Check that the DMM_PAT_STATUS register has not reported an error */
> +	r = dmm->base + DMM_PAT_STATUS__0;
> +	v = __raw_readl(r);
> +	if (WARN(v & 0xFC00, KERN_ERR "dmm_pat_refill() error.\n"))
> +		return -EIO;
> +
> +	/* Set "next" register to NULL */
> +	r = dmm->base + DMM_PAT_DESCR__0;
> +	v = __raw_readl(r);
> +	v = SET_FLD(v, 31, 4, (u32) NULL);
> +	__raw_writel(v, r);
> +
> +	/* Set area to be refilled */
> +	r = dmm->base + DMM_PAT_AREA__0;
> +	v = __raw_readl(r);
> +	v = SET_FLD(v, 30, 24, pd->area.y1);
> +	v = SET_FLD(v, 23, 16, pd->area.x1);
> +	v = SET_FLD(v, 14, 8, pd->area.y0);
> +	v = SET_FLD(v, 7, 0, pd->area.x0);
> +	__raw_writel(v, r);
> +	wmb();

Maybe use writel() (which will contain the barrier _before_ the write op.) [dhs] -- I didn't know this.  Thanks for this input.

> +
> +	/* First, clear the DMM_PAT_IRQSTATUS register */
> +	r = dmm->base + DMM_PAT_IRQSTATUS;
> +	__raw_writel(0xFFFFFFFF, r);
> +	wmb();

And consider using:
	writel(0xffffffff, dmm->base + DMM_PAT_IRQSTATUS);

In any case, writes to devices are ordered, so there's no real need to
add barriers between each write - in which case writel_relaxed() or
__raw_writel() can be used (which'll be added soon.) [dhs] -- OK, will incorporate in RFC v2.

> +
> +	r = dmm->base + DMM_PAT_IRQSTATUS_RAW;
> +	while (__raw_readl(r) != 0)
> +		;

It's normal to use cpu_relax() in busy-wait loops.  What if the IRQ status
never becomes zero? [dhs] -- I will revist this as well.

> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("davidsin@ti.com");
> +MODULE_AUTHOR("molnar@ti.com");

MODULE_AUTHOR("Name <email>"); or just MODULE_AUTHOR("Name");

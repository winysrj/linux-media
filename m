Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46681 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab3F0It4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 04:49:56 -0400
Date: Thu, 27 Jun 2013 09:49:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-fbdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	t.figa@samsung.com, jg1.han@samsung.com, dh09.lee@samsung.com,
	kishon@ti.com, inki.dae@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, plagnioj@jcrosoft.com,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
Message-ID: <20130627084902.GB4283@n2100.arm.linux.org.uk>
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com> <20130625150649.GA21334@arwen.pp.htv.fi> <51CB0212.3050103@samsung.com> <20130627061713.GF15455@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627061713.GF15455@arwen.pp.htv.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 27, 2013 at 09:17:13AM +0300, Felipe Balbi wrote:
> On Wed, Jun 26, 2013 at 05:00:34PM +0200, Sylwester Nawrocki wrote:
> > Hi,
> > 
> > On 06/25/2013 05:06 PM, Felipe Balbi wrote:
> > >> +static struct platform_driver exynos_video_phy_driver = {
> > >> > +	.probe	= exynos_video_phy_probe,
> > >
> > > you *must* provide a remove method. drivers with NULL remove are
> > > non-removable :-)
> > 
> > Actually the remove() callback can be NULL, it's just missing module_exit
> > function that makes a module not unloadable.
> 
> look at the implementation of platform_drv_remove():
> 
>  499 static int platform_drv_remove(struct device *_dev)
>  500 {
>  501         struct platform_driver *drv = to_platform_driver(_dev->driver);
>  502         struct platform_device *dev = to_platform_device(_dev);
>  503         int ret;
>  504 
>  505         ret = drv->remove(dev);
>  506         if (ACPI_HANDLE(_dev))
>  507                 acpi_dev_pm_detach(_dev, true);
>  508 
>  509         return ret;
>  510 }
> 
> that's not a conditional call right :-)

Wrong.

        if (drv->remove)
                drv->driver.remove = platform_drv_remove;

The function you quote will only be used if drv->remove is non-NULL.
You do not need to provide a remove method.

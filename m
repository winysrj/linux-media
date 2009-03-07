Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:59987 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbZCGPYu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 10:24:50 -0500
Subject: Re: [PATCH 1/9] omap3isp: Add ISP main driver and register
 definitions
From: Alexey Klimov <klimov.linux@gmail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	saaguirre@ti.com, tuukka.o.toivonen@nokia.com,
	dongsoo.kim@gmail.com
In-Reply-To: <49AFB8E3.9070909@maxwell.research.nokia.com>
References: <49AD0128.5090503@maxwell.research.nokia.com>
	 <1236074816-30018-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
	 <1236081373.10927.15.camel@tux.localhost>
	 <49AFB8E3.9070909@maxwell.research.nokia.com>
Content-Type: text/plain
Date: Sat, 07 Mar 2009 18:25:28 +0300
Message-Id: <1236439528.1863.22.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-03-05 at 13:34 +0200, Sakari Ailus wrote:
> Thanks for the comments, Alexey!
> 
> Alexey Klimov wrote:
> >> +static int isp_probe(struct platform_device *pdev)
> >> +{
> >> +	struct isp_device *isp;
> >> +	int ret_err = 0;
> >> +	int i;
> >> +
> >> +	isp = kzalloc(sizeof(*isp), GFP_KERNEL);
> >> +	if (!isp) {
> >> +		dev_err(&pdev->dev, "could not allocate memory\n");
> >> +		return -ENODEV;
> > 
> > return -ENOMEM; ?
> 
> Done.
> 
> >> +	}
> >> +
> >> +	platform_set_drvdata(pdev, isp);
> >> +
> >> +	isp->dev = &pdev->dev;
> >> +
> >> +	for (i = 0; i <= OMAP3_ISP_IOMEM_CSI2PHY; i++) {
> >> +		struct resource *mem;
> >> +		/* request the mem region for the camera registers */
> >> +		mem = platform_get_resource(pdev, IORESOURCE_MEM, i);
> >> +		if (!mem) {
> >> +			dev_err(isp->dev, "no mem resource?\n");
> >> +			return -ENODEV;
> > 
> > Maybe ENODEV is not apropriate here too..
> 
> What else it could be? ENOENT comes to mind but I'm not sure it's 
> significantly better.

ENODEV is okay, sorry.

-- 
Best regards, Klimov Alexey


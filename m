Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:40967 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZCELfU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 06:35:20 -0500
Message-ID: <49AFB8E3.9070909@maxwell.research.nokia.com>
Date: Thu, 05 Mar 2009 13:34:59 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Alexey Klimov <klimov.linux@gmail.com>
CC: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	saaguirre@ti.com, tuukka.o.toivonen@nokia.com,
	dongsoo.kim@gmail.com
Subject: Re: [PATCH 1/9] omap3isp: Add ISP main driver and register definitions
References: <49AD0128.5090503@maxwell.research.nokia.com>	 <1236074816-30018-1-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1236081373.10927.15.camel@tux.localhost>
In-Reply-To: <1236081373.10927.15.camel@tux.localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the comments, Alexey!

Alexey Klimov wrote:
>> +static int isp_probe(struct platform_device *pdev)
>> +{
>> +	struct isp_device *isp;
>> +	int ret_err = 0;
>> +	int i;
>> +
>> +	isp = kzalloc(sizeof(*isp), GFP_KERNEL);
>> +	if (!isp) {
>> +		dev_err(&pdev->dev, "could not allocate memory\n");
>> +		return -ENODEV;
> 
> return -ENOMEM; ?

Done.

>> +	}
>> +
>> +	platform_set_drvdata(pdev, isp);
>> +
>> +	isp->dev = &pdev->dev;
>> +
>> +	for (i = 0; i <= OMAP3_ISP_IOMEM_CSI2PHY; i++) {
>> +		struct resource *mem;
>> +		/* request the mem region for the camera registers */
>> +		mem = platform_get_resource(pdev, IORESOURCE_MEM, i);
>> +		if (!mem) {
>> +			dev_err(isp->dev, "no mem resource?\n");
>> +			return -ENODEV;
> 
> Maybe ENODEV is not apropriate here too..

What else it could be? ENOENT comes to mind but I'm not sure it's 
significantly better.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

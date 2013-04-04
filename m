Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58484 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188Ab3DDL1g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 07:27:36 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKQ00MNQAFKTH60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Apr 2013 12:27:34 +0100 (BST)
Message-id: <515D63A4.2060108@samsung.com>
Date: Thu, 04 Apr 2013 13:27:32 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Mike Turquette <mturquette@linaro.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] omap3isp: Use the common clock framework
References: <1365073719-8038-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1365073719-8038-2-git-send-email-laurent.pinchart@ideasonboard.com>
 <20130404112004.GG10541@valkosipuli.retiisi.org.uk>
In-reply-to: <20130404112004.GG10541@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 04/04/2013 01:20 PM, Sakari Ailus wrote:
> Hi Laurent,
> 
> I don't remember when did I see equally nice patch to the omap3isp driver!
> :-) Thanks!
> 
> A few comments below.
> 
> On Thu, Apr 04, 2013 at 01:08:38PM +0200, Laurent Pinchart wrote:
> ...

>> +		xclk->lookup = kzalloc(sizeof(*xclk->lookup), GFP_KERNEL);
> 
> How about devm_kzalloc()? You'd save a bit of error handling (which is btw.
> missing now, as well as kfree in cleanup).

clkdev_drop() will free memory allocated here. So using devm_kzalloc()
wouldn't be correct.

>> +		if (xclk->lookup == NULL)
>> +			return -ENOMEM;
>> +
>> +		xclk->lookup->con_id = pdata->xclks[i].con_id;
>> +		xclk->lookup->dev_id = pdata->xclks[i].dev_id;
>> +		xclk->lookup->clk = clk;
>> +
>> +		clkdev_add(xclk->lookup);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void isp_xclk_cleanup(struct isp_device *isp)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
>> +		struct isp_xclk *xclk = &isp->xclks[i];
>> +
>> +		if (xclk->lookup)
>> +			clkdev_drop(xclk->lookup);
>> +	}
>> +}

Regards,
Sylwester


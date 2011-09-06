Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:4438 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab1IFDaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 23:30:23 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [media] at91: add code to initialize and manage theISI_MCK for Atmel ISI driver.
Date: Tue, 6 Sep 2011 11:29:50 +0800
Message-ID: <4C79549CB6F772498162A641D92D532802A09D8F@penmb01.corp.atmel.com>
In-Reply-To: <20110905103339.GG6619@n2100.arm.linux.org.uk>
References: <1315218593-10822-1-git-send-email-josh.wu@atmel.com> <20110905103339.GG6619@n2100.arm.linux.org.uk>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: <g.liakhovetski@gmx.de>, <linux-media@vger.kernel.org>,
	<plagnioj@jcrosoft.com>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Russell

On 09/05/2011 6:34 PM Russell King wrote:

> On Mon, Sep 05, 2011 at 06:29:53PM +0800, Josh Wu wrote:
>> +static int initialize_mck(struct atmel_isi *isi,
>> +			struct isi_platform_data *pdata)
>> +{
>> +	int ret;
>> +	struct clk *pck_parent;
>> +
>> +	if (!strlen(pdata->pck_name) || !strlen(pdata->pck_parent_name))
>> +		return -EINVAL;
>> +
>> +	/* ISI_MCK is provided by PCK clock */
>> +	isi->mck = clk_get(NULL, pdata->pck_name);

> No, this is not how you use the clk API.  You do not pass clock names via
> platform data.

> You pass clk_get() the struct device.  You then pass clk_get() a
> _connection id_ on that _device_ if you have more than one struct clk
> associated with the _device_.  You then use clkdev to associate the
> struct device plus the connection id with the appropriate struct clk.

I think I missed the struct device when called clk_get(). I will fix it in v2 version.

Best Regards,
Josh Wu

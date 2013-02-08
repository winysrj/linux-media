Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46055 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947074Ab3BHW3T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2013 17:29:19 -0500
Message-ID: <51157C36.6030505@gmail.com>
Date: Fri, 08 Feb 2013 23:29:10 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 01/10] s5p-csis: Add device tree support
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-2-git-send-email-s.nawrocki@samsung.com> <5112E907.4080100@wwwdotorg.org>
In-Reply-To: <5112E907.4080100@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/2013 12:36 AM, Stephen Warren wrote:
> On 02/01/2013 12:09 PM, Sylwester Nawrocki wrote:
>> s5p-csis is platform device driver for MIPI-CSI frontend to the FIMC
>> device. This patch support for binding the driver to the MIPI-CSIS
>> devices instantiated from device tree and for parsing all SoC and
>> board specific properties.
>
>> diff --git a/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
>b/Documentation/devicetree/bindings/media/soc/samsung-mipi-csis.txt
>
>> +Optional properties:
>> +
>> +- clock-frequency : The IP's main (system bus) clock frequency in Hz, default
>> +		    value when this property is not specified is 166 MHz;
>
> Shouldn't this be a "clocks" property, so that the driver can call
> clk_get(), clk_prepare_enable(), clk_get_rate(), etc. on it?

Hi Stephen,

Thanks for your review!

I also use "clocks" and "clock-names" property, but didn't specify
it here, because the Exynos SoCs clocks driver is not in the mainline yet.

There are two clocks the driver needs to be aware of. One of them needs
to have a specific parent clock set and the frequency set properly,
so when it is put into a data pipeline with other IPs there is no overflows
of their input/output FIFOs.

devfreq may change those frequencies if enabled, however its another topic.
I wanted to ensure the device has initially correct local clock frequency
set, with which it can operate.

--

Thanks,
Sylwester

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:47435 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab3BHX0y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2013 18:26:54 -0500
Message-ID: <511589B9.7030007@gmail.com>
Date: Sat, 09 Feb 2013 00:26:49 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 05/10] s5p-fimc: Add device tree based sensors registration
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-6-git-send-email-s.nawrocki@samsung.com> <5112EA60.6090209@wwwdotorg.org>
In-Reply-To: <5112EA60.6090209@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/2013 12:42 AM, Stephen Warren wrote:
> On 02/01/2013 12:09 PM, Sylwester Nawrocki wrote:
>> The sensor (I2C and/or SPI client) devices are instantiated by their
>> corresponding control bus drivers. Since the I2C client's master clock
>> is often provided by a video bus receiver (host interface) or other
>> than I2C/SPI controller device, the drivers of those client devices
>> are not accessing hardware in their driver's probe() callback. Instead,
>> after enabling clock, the host driver calls back into a sub-device
>> when it wants to activate them. This pattern is used by some in-tree
>> drivers and this patch also uses it for DT case. This patch is intended
>> as a first step for adding device tree support to the S5P/Exynos SoC
>> camera drivers. The second one is adding support for asynchronous
>> sub-devices registration and clock control from sub-device driver
>> level. The bindings shall not change when asynchronous probing support
>> is added.
>
>> diff --git a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
>
>> +The sensor device nodes should be added as their control bus controller
>
> I think "as" should be "to"?

Yes, something is wrong here. Hopefully this is more correct:

The sensor device nodes should be added to their control bus controller
(e.g. I2C0) nodes and linked to a port node in the csis or parallel-ports

>> +(e.g. I2C0) child nodes and linked to a port node in the csis or parallel-ports
>> +node, using common the common video interfaces bindings, i.e. port/endpoint
                ^^^^^^^^
And this needs correction too.

>> +node pairs. The implementation of this binding requires clock-frequency
>> +property to be present in the sensor device nodes.

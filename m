Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:57117 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259Ab3CZMRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 08:17:10 -0400
MIME-Version: 1.0
In-Reply-To: <514DAAC3.4050202@gmail.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
	<1362754765-2651-2-git-send-email-arun.kk@samsung.com>
	<514DAAC3.4050202@gmail.com>
Date: Tue, 26 Mar 2013 17:47:09 +0530
Message-ID: <CALt3h7_nXSd6A2t55fi3PD+BkpZh5Lo4suWcg-ZF=jDq+V3NXA@mail.gmail.com>
Subject: Re: [RFC 01/12] exynos-fimc-is: Adding device tree nodes
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kgene.kim@samsung.com, kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thank you for the review.


>> +Sensor sub-nodes:
>> +
>> +FIMC-IS IP supports custom built sensors to be controlled exclusively by
>> +the FIMC-IS firmware. These sensor properties are to be defined here.
>

[snip]

>
> Defining image sensor nodes in a standard way as ISP I2C bus controller
> nodes has an disadvantage that we need dummy I2C bus controller driver,
> at least this is how I have written the driver for Exynos4x12. In some
> version of it I had sensor nodes put in a isp-i2c fimc-is sub-node, but
> then there was an issue that this was not a fully specified I2C bus
> controller node.
>
> You can refer to my exynos4 fimc-is patch series for details on how this
> is now implemented.
>
> Handling the image sensor in a standard way, as regular I2C client devices
> has an advantage that we can put pinctrl properties in relevant device
> nodes,
> where available, which more closely describes the hardware structure.
>
> I'm not really sure in 100% if all this complication is required. It would
> allow to use same DT blob for different Imaging Subsystem SW architecture.
> For example some parts of functionality handled currently by FIMC-IS (ARM
> Cortex-A5) could be moved to host CPU, without any change in the device
> tree structure. The kernel could decide e.g. if it uses image sensor driver
> implemented in the ISP firmware, or a driver run on the host CPU.
>
> What do you think ?
>

I have seen your Exynos4 FIMC-IS patchset and you have made a dummy
I2C sensor driver there.
That mode would work fine in Exynos4 since the sensor and ISP will be used
by the same media controller pipeline. So the ISP component in the pipeline
will ensure that the HW is initialized and sensor is working.

But in Exynos5, we are using sensor in pipeline0 and ISP in pipeline1.
So there is a possibility of using sensor subdev independently
without using pipeline1 ISP components.

So with the driver I sent, the pipeline0 can still work like this -->

ISP sensor ---> MIPI-CSIS ---> FIMC-LITE ---> Memory

This cannot be done if a dummy I2C driver is made for ISP sensor.
What is your suggestion on this?

Regards
Arun

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:37110 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab3CZWvd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 18:51:33 -0400
Message-ID: <51522671.5080706@gmail.com>
Date: Tue, 26 Mar 2013 23:51:29 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arunkk.samsung@gmail.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kgene.kim@samsung.com, kilyeon.im@samsung.com
Subject: Re: [RFC 01/12] exynos-fimc-is: Adding device tree nodes
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com> <1362754765-2651-2-git-send-email-arun.kk@samsung.com> <514DAAC3.4050202@gmail.com> <CALt3h7_nXSd6A2t55fi3PD+BkpZh5Lo4suWcg-ZF=jDq+V3NXA@mail.gmail.com>
In-Reply-To: <CALt3h7_nXSd6A2t55fi3PD+BkpZh5Lo4suWcg-ZF=jDq+V3NXA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/26/2013 01:17 PM, Arun Kumar K wrote:
>>> +Sensor sub-nodes:
>>> +
>>> +FIMC-IS IP supports custom built sensors to be controlled exclusively by
>>> +the FIMC-IS firmware. These sensor properties are to be defined here.
>
> [snip]
>
>> Defining image sensor nodes in a standard way as ISP I2C bus controller
>> nodes has an disadvantage that we need dummy I2C bus controller driver,
>> at least this is how I have written the driver for Exynos4x12. In some
>> version of it I had sensor nodes put in a isp-i2c fimc-is sub-node, but
>> then there was an issue that this was not a fully specified I2C bus
>> controller node.
>>
>> You can refer to my exynos4 fimc-is patch series for details on how this
>> is now implemented.
>>
>> Handling the image sensor in a standard way, as regular I2C client devices
>> has an advantage that we can put pinctrl properties in relevant device
>> nodes,
>> where available, which more closely describes the hardware structure.
>>
>> I'm not really sure in 100% if all this complication is required. It would
>> allow to use same DT blob for different Imaging Subsystem SW architecture.
>> For example some parts of functionality handled currently by FIMC-IS (ARM
>> Cortex-A5) could be moved to host CPU, without any change in the device
>> tree structure. The kernel could decide e.g. if it uses image sensor driver
>> implemented in the ISP firmware, or a driver run on the host CPU.
>>
>> What do you think ?
>
> I have seen your Exynos4 FIMC-IS patchset and you have made a dummy
> I2C sensor driver there.
> That mode would work fine in Exynos4 since the sensor and ISP will be used
> by the same media controller pipeline. So the ISP component in the pipeline
> will ensure that the HW is initialized and sensor is working.
>
> But in Exynos5, we are using sensor in pipeline0 and ISP in pipeline1.
> So there is a possibility of using sensor subdev independently
> without using pipeline1 ISP components.
>
> So with the driver I sent, the pipeline0 can still work like this -->
>
> ISP sensor --->  MIPI-CSIS --->  FIMC-LITE --->  Memory
>
> This cannot be done if a dummy I2C driver is made for ISP sensor.

Why not ? I'm not sure what the problem is here.

I realize that describing image sensors in DT as standard I2C slave devices
is not helpful with current firmware architecture. It adds some unnecessary
complication, OTOH it could simplify the sensors registration and media 
graph
initialization code, by unifying it for the firmware based ISP specific
sensors and the external ones with a built-in ISP. Also we could avoid 
having
the bindings defined by current architecture of the driver.

Nevertheless, coming back to your question, the I2C controller driver would
be in same module as the FIMC-IS driver. From user space perspective nothing
changes when you add I2C bus driver and register the sensor in a 
standard way.
What exactly couldn't be done in the kernel ?

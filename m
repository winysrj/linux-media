Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23704 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab1HIIKo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 04:10:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LPN00ER9IPUGJ10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Aug 2011 09:10:42 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPN00JQMIPTR7@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Aug 2011 09:10:41 +0100 (BST)
Date: Tue, 09 Aug 2011 10:10:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC] The clock dependencies between sensor subdevs and the host
 interface drivers
In-reply-to: <201108081744.37953.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Marek Szyprowski/Poland R&D Center-Linux (MSS)/./????"
	<m.szyprowski@samsung.com>
Message-id: <4E40EB80.7080302@samsung.com>
References: <4E400280.7070100@samsung.com>
 <201108081744.37953.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 08/08/2011 05:44 PM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Monday 08 August 2011 17:36:32 Sylwester Nawrocki wrote:
>> Hi everyone,
>>
>> Nowadays many of the V4L2 camera device drivers heavily depend on the board
>> code to set up voltage supplies, clocks, and some control signals, like
>> 'reset' and 'standby' signals for the sensors. Those things are often
>> being done by means of the driver specific platform data callbacks.
>>
>> There has been recently quite a lot effort on ARM towards migration to the
>> device tree. Unfortunately the custom platform data callbacks effectively
>> prevent the boards to be booted and configured through the device tree
>> bindings.
>>
>> The following is usually handled in the board files:
>>
>> 1) sensor/frontend power supply
>> 2) sensor's master clock (provided by the host device)
>> 3) reset and standby signals (GPIO)
>> 4) other signals applied by the host processor to the sensor device, e.g.
>>    I2C level shifter enable, etc.
>>
>> For 1), the regulator API should possibly be used. It should be applicable
>> for most, if not all cases.
>> 3) and 4) are a bit hard as there might be huge differences across boards
>> as how many GPIOs are used, what are the required delays between changes
>> of their states, etc. Still we could try to find a common description of
>> the behaviour and pass such information to the drivers.
>>
>> For 2) I'd like to propose adding a callback to struct v4l2_device, for
>> instance as in the below patch. The host driver would implement such an
>> operation and the sensor subdev driver would use it in its s_power op.
> 
> What about using a struct clk object ? There has been lots of work in the ARM 
> tree to make struct clk generic. I'm not sure if all patches have been pushed 
> to mainline yet, but I think that's the direction we should follow.

But is the 'struct clk' tried to be unified across all archs, not only ARM ?
I'm afraid it's not the case.

By "using a struct clk object" do you also mean implementing some/all ops
of this object by the driver which exports it ? 

I suppose we can't rely only on the clock controller functionality exposed
through the clock API.

Some devices may need to be brought to an active state before the clock can
be used outside. Some may have internal frequency dividers which need to be
handled in addition to the clock path in the clock controller.

For instance, on Exynos4 the FIMC devices belong to a power domain that needs
to be enabled so the clock is not  blocked, and this is done through the
runtime PM calls.

Normally the host device driver runtime resumes the device when /dev/video*
is opened. But we might want to use the clock before it happens, when only a
/dev/v4l-subdev* is opened, to play with the sensor device only. In this
situation the host device needs to be runtime resumed first.

Thus the driver would need to (re)implement the clock ops to also handle
the details which are not covered by the clock controller driver.

I also wonder how could we support the boards which choose to use some extra
external oscillator to provide clock to the sensors, rather than the one
derived from the host.


Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center

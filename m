Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:45368 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab3BHXQc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2013 18:16:32 -0500
Message-ID: <5115874A.6050406@gmail.com>
Date: Sat, 09 Feb 2013 00:16:26 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 02/10] s5p-fimc: Add device tree support for FIMC devices
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-3-git-send-email-s.nawrocki@samsung.com> <5112E9EF.8090908@wwwdotorg.org>
In-Reply-To: <5112E9EF.8090908@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/2013 12:40 AM, Stephen Warren wrote:
>> diff --git a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
>
>> +Samsung S5P/EXYNOS SoC Camera Subsystem (FIMC)
>> +----------------------------------------------
>> +
>> +The Exynos Camera subsystem comprises of multiple sub-devices that are
>> +represented by separate platform devices. Some of the IPs come in different
>
> "platform devices" is a rather Linux-centric term, and DT bindings
> should be OS-agnostic. Perhaps use "device tree nodes" here?

Indeed, thank you for the suggestion, I'll change it.

>> +variants across the SoC revisions (FIMC) and some remain mostly unchanged
>> +(MIPI CSIS, FIMC-LITE).
>> +
>> +All those sub-subdevices are defined as parent nodes of the common device
>
> s/parent nodes/child node/ I think?

Yeah, 'parent nodes' doesn't really make sense. Thanks for catching it.

>> +For every fimc node a numbered alias should be present in the aliases node.
>> +Aliases are of the form fimc<n>, where<n>  is an integer (0...N) specifying
>> +the IP's instance index.
>
> Why? Isn't it up to the DT author whether they care if each fimc node is
> assigned a specific identification v.s. whether identification is
> assigned automatically?

There are at least three different kinds of IPs that come in multiple
instances in an SoC. To activate data links between them each instance
needs to be clearly identified. There are also differences between
instances of same device. Hence it's important these aliases don't have
random values.

Some more details about the SoC can be found at [1]. The aliases are
also already used in the Exynos5 GScaler bindings [2] in a similar way.

>> +Optional properties
>> +
>> + - clock-frequency - maximum FIMC local clock (LCLK) frequency
>
> Again, I'd expect a clocks property here instead.

Please see my comment to patch 01/10. Analogously, I needed this clock
frequency to ensure reliable video data pipeline operation.

[1] http://tinyurl.com/anw9udm
[2] http://www.spinics.net/lists/arm-kernel/msg200036.html

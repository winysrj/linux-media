Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:41714 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294Ab3BHXV1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2013 18:21:27 -0500
Message-ID: <51158873.3060508@wwwdotorg.org>
Date: Fri, 08 Feb 2013 16:21:23 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 02/10] s5p-fimc: Add device tree support for FIMC devices
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-3-git-send-email-s.nawrocki@samsung.com> <5112E9EF.8090908@wwwdotorg.org> <5115874A.6050406@gmail.com>
In-Reply-To: <5115874A.6050406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/08/2013 04:16 PM, Sylwester Nawrocki wrote:
> On 02/07/2013 12:40 AM, Stephen Warren wrote:
>>> diff --git
>>> a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
>>> b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
>>
>>> +Samsung S5P/EXYNOS SoC Camera Subsystem (FIMC)
>>> +----------------------------------------------
...
>>> +For every fimc node a numbered alias should be present in the
>>> aliases node.
>>> +Aliases are of the form fimc<n>, where<n>  is an integer (0...N)
>>> specifying
>>> +the IP's instance index.
>>
>> Why? Isn't it up to the DT author whether they care if each fimc node is
>> assigned a specific identification v.s. whether identification is
>> assigned automatically?
> 
> There are at least three different kinds of IPs that come in multiple
> instances in an SoC. To activate data links between them each instance
> needs to be clearly identified. There are also differences between
> instances of same device. Hence it's important these aliases don't have
> random values.
> 
> Some more details about the SoC can be found at [1]. The aliases are
> also already used in the Exynos5 GScaler bindings [2] in a similar way.

Hmmm. I'd expect explicit DT properties to represent the
instance-specific "configuration", or even different compatible values.
Relying on the alias ID seems rather indirect; what if in e.g.
Exynos6/... the mapping from instance/alias ID to feature set changes.
With explicit DT properties, that'd just be a .dts change, whereas by
requiring alias IDs now, you'd need a driver change to support this.

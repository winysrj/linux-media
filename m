Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:55072 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947483Ab3BIAFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2013 19:05:13 -0500
Message-ID: <511592B4.5050406@gmail.com>
Date: Sat, 09 Feb 2013 01:05:08 +0100
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
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-3-git-send-email-s.nawrocki@samsung.com> <5112E9EF.8090908@wwwdotorg.org> <5115874A.6050406@gmail.com> <51158873.3060508@wwwdotorg.org>
In-Reply-To: <51158873.3060508@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/2013 12:21 AM, Stephen Warren wrote:
> On 02/08/2013 04:16 PM, Sylwester Nawrocki wrote:
>> On 02/07/2013 12:40 AM, Stephen Warren wrote:
>>>> diff --git
>>>> a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
>>>> b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
>>>
>>>> +Samsung S5P/EXYNOS SoC Camera Subsystem (FIMC)
>>>> +----------------------------------------------
> ...
>>>> +For every fimc node a numbered alias should be present in the
>>>> aliases node.
>>>> +Aliases are of the form fimc<n>, where<n>   is an integer (0...N)
>>>> specifying
>>>> +the IP's instance index.
>>>
>>> Why? Isn't it up to the DT author whether they care if each fimc node is
>>> assigned a specific identification v.s. whether identification is
>>> assigned automatically?
>>
>> There are at least three different kinds of IPs that come in multiple
>> instances in an SoC. To activate data links between them each instance
>> needs to be clearly identified. There are also differences between
>> instances of same device. Hence it's important these aliases don't have
>> random values.
>>
>> Some more details about the SoC can be found at [1]. The aliases are
>> also already used in the Exynos5 GScaler bindings [2] in a similar way.
>
> Hmmm. I'd expect explicit DT properties to represent the
> instance-specific "configuration", or even different compatible values.
> Relying on the alias ID seems rather indirect; what if in e.g.
> Exynos6/... the mapping from instance/alias ID to feature set changes.
> With explicit DT properties, that'd just be a .dts change, whereas by
> requiring alias IDs now, you'd need a driver change to support this.

In the initial version of this patch series I used cell-index property,
but then Grant pointed out in some other mail thread it should be
avoided. Hence I used the node aliases.

Different compatible values might not work, when for example there
are 3 IPs out of 4 of one type and the fourth one of another type.
It wouldn't even by really different types, just quirks/little
differences between them, e.g. no data path routed to one of other IPs.

Then to connect e.g. MIPI-CSIS.0 to FIMC.2 at run time an index of the
MIPI-CSIS needs to be written to the FIMC.2 data input control register.
Even though MIPI-CSIS.N are same in terms of hardware structure they still
need to be distinguished as separate instances.


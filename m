Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18267 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaDILOg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 07:14:36 -0400
Message-id: <53452B97.8020700@samsung.com>
Date: Wed, 09 Apr 2014 13:14:31 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Rahul Sharma <r.sh.open@gmail.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	sunil joshi <joshi@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Rob Herring <robh+dt@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Grant Likely <grant.likely@linaro.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Rahul Sharma <rahul.sharma@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] phy: Add exynos-simple-phy driver
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
 <1396967856-27470-2-git-send-email-t.stanislaws@samsung.com>
 <534506B1.4040908@samsung.com>
 <CAPdUM4M109_kzY6cUMJQPSwgazvWmNDWL1JeXgiqnzvH8dhK2Q@mail.gmail.com>
In-reply-to: <CAPdUM4M109_kzY6cUMJQPSwgazvWmNDWL1JeXgiqnzvH8dhK2Q@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rahul,

On 04/09/2014 11:12 AM, Rahul Sharma wrote:
> Hi Tomasz,
> 
> On 9 April 2014 14:07, Andrzej Hajda <a.hajda@samsung.com> wrote:
>> Hi Tomasz,
>>
>> On 04/08/2014 04:37 PM, Tomasz Stanislawski wrote:
>>> Add exynos-simple-phy driver to support a single register
>>> PHY interfaces present on Exynos4 SoC.
>>>
>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

[snip]

>>> +
>>> +     regs = devm_ioremap(dev, res->start, res->end - res->start);
>>> +     if (!regs) {
>>> +             dev_err(dev, "failed to ioremap registers\n");
>>> +             return -EFAULT;
>>> +     }
>>
>> Why not devm_ioremap_resource? If not, resource_size function calculates
>> length of resource correctly.
>>
>> Anyway I like the idea of implementing multiple phys in one driver.
>> The only drawback I see is that some phys will be created even there are
>> no consumers for them. To avoid such situation you can try to use
>> lazy approach - create phy only if there is request for it,
>> exynos_phy_xlate callback should allow this.
>>
>> Regards
>> Andrzej
>>
> 
> Idea looks good. How about keeping compatible which is independent
> of SoC, something like "samsung,exynos-simple-phy" and provide Reg
> and Bit through phy provider node. This way we can avoid SoC specific
> hardcoding in phy driver and don't need to look into dt bindings for
> each new SoC.

A very nice idea BUT there is a very strong pressure from DT guys
to avoid adding any bit fields/offsets/masks in DT nodes.

Hopefully, as long as driver name starts with "exynos-" prefix
one can hide SoCs specific tricks deep inside driver code.

The idea behind this driver was not to create a generic phy for 1-bit
devices but rather to hide SoC-specific issues from client drivers
like DRM-HDMI.

> 
> We can use syscon interface to access PMU bits like USB phy.
> PMU is already registered as system controller
> 

Ok. I will try to use it in PATCHv3.

> Regards,
> Rahul Sharma.
> 

Regards,
Tomasz Stanislawski



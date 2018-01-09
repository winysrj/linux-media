Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:35724 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbeAIICr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 03:02:47 -0500
Subject: Re: [PATCH v3 0/6] arm: sunxi: IR support for A83T
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sean Young <sean@mess.org>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        wens@csie.org, linux@armlinux.org.uk, p.zabel@pengutronix.de,
        andi.shyti@samsung.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
References: <20171219080747.4507-1-embed3d@gmail.com>
 <20180105120253.zvwaz25scuk76bnt@gofer.mess.org>
 <20180105145913.ddb5l5dyt7yn3kwc@flea.lan>
From: Philipp Rossak <embed3d@gmail.com>
Message-ID: <bdaaea4c-4145-3b93-2f97-00c5c6449ddd@gmail.com>
Date: Tue, 9 Jan 2018 09:02:43 +0100
MIME-Version: 1.0
In-Reply-To: <20180105145913.ddb5l5dyt7yn3kwc@flea.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05.01.2018 15:59, Maxime Ripard wrote:
> Hi,
> 
> On Fri, Jan 05, 2018 at 12:02:53PM +0000, Sean Young wrote:
>> On Tue, Dec 19, 2017 at 09:07:41AM +0100, Philipp Rossak wrote:
>>> This patch series adds support for the sunxi A83T ir module and enhances
>>> the sunxi-ir driver. Right now the base clock frequency for the ir driver
>>> is a hard coded define and is set to 8 MHz.
>>> This works for the most common ir receivers. On the Sinovoip Bananapi M3
>>> the ir receiver needs, a 3 MHz base clock frequency to work without
>>> problems with this driver.
>>>
>>> This patch series adds support for an optinal property that makes it able
>>> to override the default base clock frequency and enables the ir interface
>>> on the a83t and the Bananapi M3.
>>>
>>> changes since v2:
>>> * reorder cir pin (alphabetical)
>>> * fix typo in documentation
>>>
>>> changes since v1:
>>> * fix typos, reword Documentation
>>> * initialize 'b_clk_freq' to 'SUNXI_IR_BASE_CLK' & remove if statement
>>> * change dev_info() to dev_dbg()
>>> * change naming to cir* in dts/dtsi
>>> * Added acked Ackedi-by to related patch
>>> * use whole memory block instead of registers needed + fix for h3/h5
>>>
>>> changes since rfc:
>>> * The property is now optinal. If the property is not available in
>>>    the dtb the driver uses the default base clock frequency.
>>> * the driver prints out the the selected base clock frequency.
>>> * changed devicetree property from base-clk-frequency to clock-frequency
>>>
>>> Regards,
>>> Philipp
>>>
>>>
>>> Philipp Rossak (6):
>>>    media: rc: update sunxi-ir driver to get base clock frequency from
>>>      devicetree
>>>    media: dt: bindings: Update binding documentation for sunxi IR
>>>      controller
>>>    arm: dts: sun8i: a83t: Add the cir pin for the A83T
>>>    arm: dts: sun8i: a83t: Add support for the cir interface
>>>    arm: dts: sun8i: a83t: bananapi-m3: Enable IR controller
>>>    arm: dts: sun8i: h3-h8: ir register size should be the whole memory
>>>      block
>>
>> I can take this series (through rc-core, i.e. linux-media), but I need an
>> maintainer Acked-by: for the sun[x8]i dts changes (all four patches).
> 
> We'll merge them through our tree. We usually have a rather big number
> of patches around, so we'd be better off avoiding conflicts :)
> 
> Philipp, can you resubmit the DTs as soon as -rc1 is out?
> 
> Thanks!
> Maxime
> 
Yes, I can do this!

Regards,
Philipp

Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55633 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab3GAFZI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jul 2013 01:25:08 -0400
Message-ID: <51D1128C.90009@ti.com>
Date: Mon, 1 Jul 2013 10:54:28 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	<linux-fbdev@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
	<t.figa@samsung.com>, <jg1.han@samsung.com>,
	<dh09.lee@samsung.com>, <balbi@ti.com>, <inki.dae@samsung.com>,
	<kyungmin.park@samsung.com>, Hui Wang <jason77.wang@gmail.com>,
	<kgene.kim@samsung.com>, <plagnioj@jcrosoft.com>,
	<devicetree-discuss@lists.ozlabs.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
References: <1372258946-15607-1-git-send-email-s.nawrocki@samsung.com> <1372258946-15607-2-git-send-email-s.nawrocki@samsung.com> <51CD4698.3070409@gmail.com> <51CD6153.5050406@samsung.com> <51CEA197.8070207@ti.com> <51CF36AB.4010300@gmail.com>
In-Reply-To: <51CF36AB.4010300@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sunday 30 June 2013 01:04 AM, Sylwester Nawrocki wrote:
> Hi,
>
> On 06/29/2013 10:57 AM, Kishon Vijay Abraham I wrote:
>> On Friday 28 June 2013 03:41 PM, Sylwester Nawrocki wrote:
>>> On 06/28/2013 10:17 AM, Hui Wang wrote:
>>>> On 06/26/2013 11:02 PM, Sylwester Nawrocki wrote:
>>>>> Add a PHY provider driver for the Samsung S5P/Exynos SoC MIPI CSI-2
>>>>> receiver and MIPI DSI transmitter DPHYs.
>>>>>
>>>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>> ---
>>>>> Changes since v2:
>>>>> - adapted to the generic PHY API v9: use phy_set/get_drvdata(),
>>>>> - fixed of_xlate callback to return ERR_PTR() instead of NULL,
>>>>> - namespace cleanup, put "GPL v2" as MODULE_LICENSE, removed pr_debug,
>>>>> - removed phy id check in __set_phy_state().
>>>>> ---
>>>> [...]
>>>>> +
>>>>> + if (IS_EXYNOS_MIPI_DSIM_PHY_ID(id))
>>>>> + reset = EXYNOS_MIPI_PHY_MRESETN;
>>>>> + else
>>>>> + reset = EXYNOS_MIPI_PHY_SRESETN;
>>>>> +
>>>>> + spin_lock_irqsave(&state->slock, flags);
>>>>
>>>> Sorry for one stupid question here, why do you use spin_lock_irqsave()
>>>> rather than spin_lock(),
>>>> I don't see the irq handler will use this spinlock anywhere in this c
>>>> file.
>>>
>>> Yes, there is no chance the PHY users could call the phy ops from within
>>> an interrupt context. Especially now when there is a per phy object
>>> mutex used in the PHY operation helpers. So I'll replace it with plain
>>> spin_lock/unlock. Thank you for the review.
>>
>> Now that PHY ops is already protected, do you really need a spin_lock here?
>
> It is still needed, to synchronize access to the control register from
> two separate PHY objects. The mutex is per PHY object, while the spinlock
> is per PHY provider.

Ok. Makes sense.

Thanks
Kishon

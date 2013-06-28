Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43190 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3F1KLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 06:11:34 -0400
Message-id: <51CD6153.5050406@samsung.com>
Date: Fri, 28 Jun 2013 12:11:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hui Wang <jason77.wang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, kishon@ti.com,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	balbi@ti.com, t.figa@samsung.com,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	dh09.lee@samsung.com, jg1.han@samsung.com, inki.dae@samsung.com,
	plagnioj@jcrosoft.com, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v3 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
References: <1372258946-15607-1-git-send-email-s.nawrocki@samsung.com>
 <1372258946-15607-2-git-send-email-s.nawrocki@samsung.com>
 <51CD4698.3070409@gmail.com>
In-reply-to: <51CD4698.3070409@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2013 10:17 AM, Hui Wang wrote:
> On 06/26/2013 11:02 PM, Sylwester Nawrocki wrote:
>> Add a PHY provider driver for the Samsung S5P/Exynos SoC MIPI CSI-2
>> receiver and MIPI DSI transmitter DPHYs.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> Changes since v2:
>>   - adapted to the generic PHY API v9: use phy_set/get_drvdata(),
>>   - fixed of_xlate callback to return ERR_PTR() instead of NULL,
>>   - namespace cleanup, put "GPL v2" as MODULE_LICENSE, removed pr_debug,
>>   - removed phy id check in __set_phy_state().
>> ---
> [...]
>> +
>> +	if (IS_EXYNOS_MIPI_DSIM_PHY_ID(id))
>> +		reset = EXYNOS_MIPI_PHY_MRESETN;
>> +	else
>> +		reset = EXYNOS_MIPI_PHY_SRESETN;
>> +
>> +	spin_lock_irqsave(&state->slock, flags);
>
> Sorry for one stupid question here, why do you use spin_lock_irqsave() 
> rather than spin_lock(),
> I don't see the irq handler will use this spinlock anywhere in this c file.

Yes, there is no chance the PHY users could call the phy ops from within
an interrupt context. Especially now when there is a per phy object 
mutex used in the PHY operation helpers. So I'll replace it with plain 
spin_lock/unlock. Thank you for the review.

Regards,
Sylwester

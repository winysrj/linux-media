Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:34554 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbbIWOhw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2015 10:37:52 -0400
Subject: Re: [PATCH 15/17] ir-hix5hd2: drop the use of IRQF_NO_SUSPEND
To: zhangfei <zhangfei.gao@linaro.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1442850433-5903-1-git-send-email-sudeep.holla@arm.com>
 <1442850433-5903-16-git-send-email-sudeep.holla@arm.com>
 <5602B6A1.2090309@linaro.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Guoxiong Yan <yanguoxiong@huawei.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Sudeep Holla <sudeep.holla@arm.com>
Message-ID: <5602B93B.7040108@arm.com>
Date: Wed, 23 Sep 2015 15:37:47 +0100
MIME-Version: 1.0
In-Reply-To: <5602B6A1.2090309@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 23/09/15 15:26, zhangfei wrote:
>
>
> On 09/21/2015 08:47 AM, Sudeep Holla wrote:
>> This driver doesn't claim the IR transmitter to be wakeup source. It
>> even disables the clock and the IR during suspend-resume cycle.
>>
>> This patch removes yet another misuse of IRQF_NO_SUSPEND.
>>
>> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> Cc: Zhangfei Gao <zhangfei.gao@linaro.org>
>> Cc: Patrice Chotard <patrice.chotard@st.com>
>> Cc: Fabio Estevam <fabio.estevam@freescale.com>
>> Cc: Guoxiong Yan <yanguoxiong@huawei.com>
>> Cc: linux-media@vger.kernel.org
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> ---
>>    drivers/media/rc/ir-hix5hd2.c | 2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
>> index 1c087cb76815..d0549fba711c 100644
>> --- a/drivers/media/rc/ir-hix5hd2.c
>> +++ b/drivers/media/rc/ir-hix5hd2.c
>> @@ -257,7 +257,7 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
>>    		goto clkerr;
>>
>>    	if (devm_request_irq(dev, priv->irq, hix5hd2_ir_rx_interrupt,
>> -			     IRQF_NO_SUSPEND, pdev->name, priv) < 0) {
>> +			     0, pdev->name, priv) < 0) {
>>    		dev_err(dev, "IRQ %d register failed\n", priv->irq);
>>    		ret = -EINVAL;
>>    		goto regerr;
>>
>
> ir is wakeup source for hix5hd2, so we use IRQF_NO_SUSPEND.

OK, but from the existing implementation of suspend/resume callbacks, I
read that the clocks as well as the IP block is powered off. Is part of
the logic always-on ?

> However, it is true the wakeup mechanism is not realized on hix5hd2 yet.

OK, then I assume you can add the right APIs(enable_irq_wake and
friends) when you add that feature.

> I am fine with either using IRQF_NO_SUSPEND or not.
>

No using IRQF_NO_SUSPEND for wakeup is simply wrong and hence this patch
series removes all those misuse. If you need it as wakeup, then you need
to use right APIs for that. Since I don't see any support for wakeup in
this driver I decided to just remove the flag. Please feel free to add
the support making use of right APIs.

Regards,
Sudeep

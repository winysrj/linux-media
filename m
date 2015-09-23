Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35887 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbbIWO0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2015 10:26:48 -0400
Received: by pacgz1 with SMTP id gz1so7923032pac.3
        for <linux-media@vger.kernel.org>; Wed, 23 Sep 2015 07:26:48 -0700 (PDT)
Message-ID: <5602B6A1.2090309@linaro.org>
Date: Wed, 23 Sep 2015 07:26:41 -0700
From: zhangfei <zhangfei.gao@linaro.org>
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>, linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Guoxiong Yan <yanguoxiong@huawei.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 15/17] ir-hix5hd2: drop the use of IRQF_NO_SUSPEND
References: <1442850433-5903-1-git-send-email-sudeep.holla@arm.com> <1442850433-5903-16-git-send-email-sudeep.holla@arm.com>
In-Reply-To: <1442850433-5903-16-git-send-email-sudeep.holla@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/21/2015 08:47 AM, Sudeep Holla wrote:
> This driver doesn't claim the IR transmitter to be wakeup source. It
> even disables the clock and the IR during suspend-resume cycle.
>
> This patch removes yet another misuse of IRQF_NO_SUSPEND.
>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Cc: Zhangfei Gao <zhangfei.gao@linaro.org>
> Cc: Patrice Chotard <patrice.chotard@st.com>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Guoxiong Yan <yanguoxiong@huawei.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>   drivers/media/rc/ir-hix5hd2.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
> index 1c087cb76815..d0549fba711c 100644
> --- a/drivers/media/rc/ir-hix5hd2.c
> +++ b/drivers/media/rc/ir-hix5hd2.c
> @@ -257,7 +257,7 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
>   		goto clkerr;
>
>   	if (devm_request_irq(dev, priv->irq, hix5hd2_ir_rx_interrupt,
> -			     IRQF_NO_SUSPEND, pdev->name, priv) < 0) {
> +			     0, pdev->name, priv) < 0) {
>   		dev_err(dev, "IRQ %d register failed\n", priv->irq);
>   		ret = -EINVAL;
>   		goto regerr;
>

ir is wakeup source for hix5hd2, so we use IRQF_NO_SUSPEND.
However, it is true the wakeup mechanism is not realized on hix5hd2 yet.
I am fine with either using IRQF_NO_SUSPEND or not.

Thanks for the patch.

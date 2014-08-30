Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53111 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaH3NZC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Aug 2014 09:25:02 -0400
Received: by mail-pa0-f46.google.com with SMTP id eu11so8416150pac.5
        for <linux-media@vger.kernel.org>; Sat, 30 Aug 2014 06:25:01 -0700 (PDT)
Message-ID: <5401D0A4.4070504@linaro.org>
Date: Sat, 30 Aug 2014 21:24:52 +0800
From: zhangfei <zhangfei.gao@linaro.org>
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, arnd@arndb.de,
	haifeng.yan@linaro.org, jchxue@gmail.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, Guoxiong Yan <yanguoxiong@huawei.com>
Subject: Re: [PATCH v3 2/3] rc: Introduce hix5hd2 IR transmitter driver
References: <1409238977-19444-1-git-send-email-zhangfei.gao@linaro.org> <1409238977-19444-3-git-send-email-zhangfei.gao@linaro.org> <20140828162231.GA3429@gofer.mess.org>
In-Reply-To: <20140828162231.GA3429@gofer.mess.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sean

On 08/29/2014 12:22 AM, Sean Young wrote:
> On Thu, Aug 28, 2014 at 11:16:16PM +0800, Zhangfei Gao wrote:
>> From: Guoxiong Yan <yanguoxiong@huawei.com>
>>
>> IR transmitter driver for Hisilicon hix5hd2 soc
>>
>> By default all protocols are disabled.
>> For example nec decoder can be enabled by either
>> 1. ir-keytable -p nec
>> 2. echo nec > /sys/class/rc/rc0/protocols
>> See see Documentation/ABI/testing/sysfs-class-rc
>
> I'm not sure that's true any more. All protocols are enabled, right?
By default, all protocols are disabled

#cat /sys/class/rc/rc0/protocols
other [unknown] rc-5 nec rc-6 jvc sony rc-5-sz sanyo sharp mce_kbd lirc xmp

>> +config IR_HIX5HD2
>> +	tristate "Hisilicon hix5hd2 IR remote control"
>> +	depends on RC_CORE
>> +	help
>> +	 Say Y here if you want to use hisilicon remote control.
>> +	 The driver passes raw pulse and space information to the LIRC decoder.
>> +	 To compile this driver as a module, choose M here: the module will be
>> +	 called hisi_ir.
>
> The module won't be called that.
Yes, change to ir-hix5hd2r.

>> +struct hix5hd2_ir_priv {
>> +	int			irq;
>> +	void			*base;
>> +	struct device		*dev;
>> +	struct rc_dev		*rdev;
>> +	struct regmap		*regmap;
>> +	struct clk		*clock;
>> +	const char		*map_name;
>
> map_name member is only assigned, it's unused.
OK

>> +static irqreturn_t hix5hd2_ir_rx_interrupt(int irq, void *data)
>> +{
>> +	u32 symb_num, symb_val, symb_time;
>> +	u32 data_l, data_h;
>> +	u32 irq_sr, i;
>> +	struct hix5hd2_ir_priv *priv = data;
>> +
>> +	irq_sr = readl_relaxed(priv->base + IR_INTS);
>> +	if (irq_sr & INTMS_OVERFLOW) {
>> +		/*
>> +		 * we must read IR_DATAL first, then we can clean up
>> +		 * IR_INTS availably since logic would not clear
>> +		 * fifo when overflow, drv do the job
>> +		 */
>> +		ir_raw_event_reset(priv->rdev);
>> +		symb_num = readl_relaxed(priv->base + IR_DATAH);
>> +		for (i = 0; i < symb_num; i++)
>> +			readl_relaxed(priv->base + IR_DATAL);
>> +
>> +		writel_relaxed(INT_CLR_OVERFLOW, priv->base + IR_INTC);
>> +		dev_info(priv->dev, "overflow, level=%d\n",
>> +			 IR_CFG_INT_THRESHOLD);
>> +	}
>> +
>> +	if ((irq_sr & INTMS_SYMBRCV) || (irq_sr & INTMS_TIMEOUT)) {
>> +		DEFINE_IR_RAW_EVENT(ev);
>> +
>> +		symb_num = readl_relaxed(priv->base + IR_DATAH);
>> +		for (i = 0; i < symb_num; i++) {
>> +			symb_val = readl_relaxed(priv->base + IR_DATAL);
>> +			data_l = ((symb_val & 0xffff) * 10);
>> +			data_h =  ((symb_val >> 16) & 0xffff) * 10;
>> +			symb_time = (data_l + data_h) / 10;
>> +
>> +			ev.duration = US_TO_NS(data_l);
>> +			ev.pulse = true;
>> +			ir_raw_event_store(priv->rdev, &ev);
>> +
>> +			if (symb_time < IR_CFG_SYMBOL_MAXWIDTH) {
>> +				ev.duration = US_TO_NS(data_h);
>> +				ev.pulse = false;
>> +				ir_raw_event_store(priv->rdev, &ev);
>> +			} else {
>> +				hix5hd2_ir_send_lirc_timeout(priv->rdev);
>
> Surely this is when IR goes idle.
>
> 				ir_raw_event_set_idle(priv->rdev, true);
>
> This will set up idle processing and send the timeout IR event.

Yes, ir_raw_event_set_idle is simpler.

>> +static int hix5hd2_ir_open(struct rc_dev *rdev)
>> +{
>> +	struct hix5hd2_ir_priv *priv = rdev->priv;
>> +
>> +	hix5hd2_ir_enable(priv, true);
>> +	hix5hd2_ir_config(priv);
>
> hix5hd2_ir_config can fail, the error can be returned to userspace rather
> than silently failing.

Change to return hix5hd2_ir_config(priv);

>> +	if (devm_request_irq(dev, priv->irq, hix5hd2_ir_rx_interrupt,
>> +			     IRQF_NO_SUSPEND, pdev->name, priv) < 0) {
>> +		dev_err(dev, "IRQ %d register failed\n", priv->irq);
>> +		return -EINVAL;
>> +	}
>
> You've requested the interrupts too early, if an interrupts arrives before
> you've set up all the members in priv it'll go bang in the interrupt handler.

Will move request_irq after rc_register_device
However, ir controller only be enabled in open.

>> +
>> +	/**
>> +	 * for LIRC_MODE_MODE2 or LIRC_MODE_PULSE or LIRC_MODE_RAW
>> +	 * lircd expects a long space first before a signal train to sync.
>> +	 */
>> +	hix5hd2_ir_send_lirc_timeout(rdev);
>
> I don't know why this is needed, sounds like a lircd oddity.
To be honst, I don't know either.
This is refer to st_rc.c
Currently I only test with nec decoder.
Will remove this until it is required.

>> +static struct platform_driver hix5hd2_ir_driver = {
>> +	.driver = {
>> +		.name = IR_HIX5HD2_NAME,
>> +		.of_match_table = hix5hd2_ir_table,
>> +		.pm     = &hix5hd2_ir_pm_ops,
>> +	},
>> +	.probe = hix5hd2_ir_probe,
>> +	.remove = hix5hd2_ir_remove,
>> +};
>> +
>> +module_platform_driver(hix5hd2_ir_driver);
>> +
>> +MODULE_DESCRIPTION("RC Transceiver driver for hix5hd2 platforms");
>
> A transceiver can transmit as well as receive; this driver can only do one.
Change to "IR controller driver for hix5hd2 platforms"


Thanks for your kind review

Regards
Zhangfei

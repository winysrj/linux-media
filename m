Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45399 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab2BVGkn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 01:40:43 -0500
Message-ID: <4F448DE1.2020807@codeaurora.org>
Date: Wed, 22 Feb 2012 12:10:33 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
MIME-Version: 1.0
To: James Hogan <james@albanarts.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Trilok soni <tsoni@codeaurora.org>,
	David Brown <davidb@codeaurora.org>, bryanh@codeaurora.org,
	Jarod Wilson <jarod@redhat.com>,
	Anssi Hannula <anssi.hannula@iki.fi>,
	"Juan J. Garcia de Soria" <skandalfo@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] rc: Add support for GPIO based IR Receiver driver.
References: <1329731272-31476-1-git-send-email-kumarrav@codeaurora.org> <20120220202930.GB32005@balrog>
In-Reply-To: <20120220202930.GB32005@balrog>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/21/2012 1:59 AM, James Hogan wrote:
> On Mon, Feb 20, 2012 at 03:17:52PM +0530, Ravi Kumar V wrote:
>> Adds GPIO based IR Receiver driver. It decodes signals using decoders
>> available in rc framework.
>>
>> Signed-off-by: Ravi Kumar V<kumarrav@codeaurora.org>
>> ---
>>   drivers/media/rc/Kconfig        |    9 ++
>>   drivers/media/rc/Makefile       |    1 +
>>   drivers/media/rc/gpio-ir-recv.c |  189 +++++++++++++++++++++++++++++++++++++++
>>   include/media/gpio-ir-recv.h    |   23 +++++
>>   4 files changed, 222 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/media/rc/gpio-ir-recv.c
>>   create mode 100644 include/media/gpio-ir-recv.h
>>
>> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
>> index aeb7f43..6f63ded 100644
>> --- a/drivers/media/rc/Kconfig
>> +++ b/drivers/media/rc/Kconfig
>> @@ -256,4 +256,13 @@ config RC_LOOPBACK
>>   	   To compile this driver as a module, choose M here: the module will
>>   	   be called rc_loopback.
>>
>> +config IR_GPIO_CIR
>> +	tristate "GPIO IR remote control"
>> +	depends on RC_CORE
>> +	---help---
>> +	   Say Y if you want to use GPIO based IR Receiver.
>> +
>> +	   To compile this driver as a module, choose M here: the module will
>> +	   be called gpio-ir-recv.
>> +
>>   endif #RC_CORE
>> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
>> index 2156e78..9b3568e 100644
>> --- a/drivers/media/rc/Makefile
>> +++ b/drivers/media/rc/Makefile
>> @@ -25,3 +25,4 @@ obj-$(CONFIG_IR_REDRAT3) += redrat3.o
>>   obj-$(CONFIG_IR_STREAMZAP) += streamzap.o
>>   obj-$(CONFIG_IR_WINBOND_CIR) += winbond-cir.o
>>   obj-$(CONFIG_RC_LOOPBACK) += rc-loopback.o
>> +obj-$(CONFIG_IR_GPIO_CIR) += gpio-ir-recv.o
>> diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
>> new file mode 100644
>> index 0000000..cf6e7f6
>> --- /dev/null
>> +++ b/drivers/media/rc/gpio-ir-recv.c
>> @@ -0,0 +1,189 @@
>> +/* Copyright (c) 2012, Code Aurora Forum. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include<linux/kernel.h>
>> +#include<linux/init.h>
>> +#include<linux/module.h>
>> +#include<linux/interrupt.h>
>> +#include<linux/gpio.h>
>> +#include<linux/slab.h>
>> +#include<linux/platform_device.h>
>> +#include<linux/irq.h>
>> +#include<media/rc-core.h>
>> +#include<media/gpio-ir-recv.h>
>> +
>> +#define GPIO_IR_DRIVER_NAME	"gpio-rc-recv"
>> +#define GPIO_IR_DEVICE_NAME	"gpio_ir_recv"
>> +
>> +struct gpio_rc_dev {
>> +	struct rc_dev *rcdev;
>> +	struct mutex lock;
>
> I could be completely wrong here, but is this lock necessary since data
> is only read, and it's only used by a single interrupt handler?
>
Yes i have checked you are right, i will take it out

>> +	unsigned int gpio_nr;
>> +	bool active_low;
>> +	bool can_wakeup;
>> +};
>> +
>> +static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
>> +{
>> +	struct gpio_rc_dev *gpio_dev = dev_id;
>> +	unsigned int gval;
>> +	int rc = 0;
>> +	enum raw_event_type type = IR_SPACE;
>> +
>> +	mutex_lock(&gpio_dev->lock);
>> +	gval = gpio_get_value_cansleep(gpio_dev->gpio_nr);
>> +
>> +	if (gval<  0)
>> +		goto err_get_value;
>> +
>> +	if (gpio_dev->active_low)
>> +		gval = !gval;
>> +
>> +	if (gval == 1)
>> +		type = IR_PULSE;
>> +
>> +	rc = ir_raw_event_store_edge(gpio_dev->rcdev, type);
>> +	if (rc<  0)
>> +		goto err_get_value;
>
> Since ir_raw_event_store_edge just puts the event into a kfifo for the
> ir-raw thread to handle, does this really have to be a threaded IRQ? I'd
> have thought you'd get more accurate time measurements (especially on
> slower/embedded CPUs) if the IRQ is serviced as soon as possible.
>
> If it needs to be threaded so that the gpio read can sleep, perhaps it
> could make use of a hard irq if the gpio can be accessed atomically, and
> fall back to threaded if not.
>
yes you are right i will see, I will distinguish between gpio atomic & 
sleep by using gpio_cansleep in probe and switch to appropriate 
hard/threaded irq.

>> +
>> +	ir_raw_event_handle(gpio_dev->rcdev);
>> +
>> +err_get_value:
>> +	mutex_unlock(&gpio_dev->lock);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
>> +{
>> +	struct gpio_rc_dev *gpio_dev;
>> +	struct rc_dev *rcdev;
>> +	const struct gpio_ir_recv_platform_data *pdata =
>> +					pdev->dev.platform_data;
>> +	int rc;
>> +
>> +	if (!pdata)
>> +		return -EINVAL;
>> +
>> +	if (pdata->gpio_nr<  0)
>> +		return -EINVAL;
>> +
>> +	gpio_dev = kzalloc(sizeof(struct gpio_rc_dev), GFP_KERNEL);
>> +	if (!gpio_dev)
>> +		return -ENOMEM;
>> +
>> +	mutex_init(&gpio_dev->lock);
>> +
>> +	rcdev = rc_allocate_device();
>> +	if (!rcdev) {
>> +		rc = -ENOMEM;
>> +		goto err_allocate_device;
>> +	}
>> +
>> +	rcdev->driver_type = RC_DRIVER_IR_RAW;
>> +	rcdev->allowed_protos = RC_TYPE_NEC;
>
> Is this necessary, since the driver is protocol agnostic?

I will change it to RC_TYPE_ALL

>
>> +	rcdev->input_name = GPIO_IR_DEVICE_NAME;
>> +	rcdev->input_id.bustype = BUS_HOST;
>> +	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
>> +	rcdev->map_name = RC_MAP_EMPTY;
>> +
>> +	gpio_dev->rcdev = rcdev;
>> +	gpio_dev->gpio_nr = pdata->gpio_nr;
>> +	gpio_dev->active_low = pdata->active_low;
>> +	gpio_dev->can_wakeup = pdata->can_wakeup;
>> +
>> +
>> +	rc = gpio_request(pdata->gpio_nr, "gpio-ir-recv");
>> +	if (rc<  0)
>> +		goto err_gpio_request;
>> +	rc  = gpio_direction_input(pdata->gpio_nr);
>> +	if (rc<  0)
>> +		goto err_gpio_direction_input;
>> +
>> +	rc = rc_register_device(rcdev);
>> +	if (rc<  0) {
>> +		dev_err(&pdev->dev, "failed to register rc device\n");
>> +		goto err_register_rc_device;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, gpio_dev);
>> +
>> +	rc = request_threaded_irq(gpio_to_irq(pdata->gpio_nr),
>> +			NULL, gpio_ir_recv_irq,
>> +			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
>> +			"gpio-ir-recv-irq", gpio_dev);
>> +	if (rc<  0)
>> +		goto err_request_irq;
>> +
>> +	if (pdata->can_wakeup == true) {
>> +		rc = enable_irq_wake(gpio_to_irq(pdata->gpio_nr));
>> +		if (rc<  0)
>> +			goto err_enable_irq_wake;
>
> would this be better done in a suspend/resume callback, along with
> device_may_wakeup and device_set_wakeup_capable/device_init_wakeup so
> that it can be enabled and disabled with sysfs?
>
Yes i will look into this

> Cheers
> James
>
>> +	}
>> +
>> +	return 0;
>> +
>> +err_enable_irq_wake:
>> +	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
>> +err_request_irq:
>> +	platform_set_drvdata(pdev, NULL);
>> +	rc_unregister_device(rcdev);
>> +err_register_rc_device:
>> +err_gpio_direction_input:
>> +	gpio_free(pdata->gpio_nr);
>> +err_gpio_request:
>> +	rc_free_device(rcdev);
>> +	rcdev = NULL;
>> +err_allocate_device:
>> +	mutex_destroy(&gpio_dev->lock);
>> +	kfree(gpio_dev);
>> +	return rc;
>> +}
>> +
>> +static int __devexit gpio_ir_recv_remove(struct platform_device *pdev)
>> +{
>> +	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
>> +
>> +	disable_irq_wake(gpio_to_irq(gpio_dev->gpio_nr));
>> +	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
>> +	platform_set_drvdata(pdev, NULL);
>> +	rc_unregister_device(gpio_dev->rcdev);
>> +	gpio_free(gpio_dev->gpio_nr);
>> +	rc_free_device(gpio_dev->rcdev);
>> +	mutex_destroy(&gpio_dev->lock);
>> +	kfree(gpio_dev);
>> +	return 0;
>> +}
>> +
>> +static struct platform_driver gpio_ir_recv_driver = {
>> +	.probe  = gpio_ir_recv_probe,
>> +	.remove = __devexit_p(gpio_ir_recv_remove),
>> +	.driver = {
>> +		.name   = GPIO_IR_DRIVER_NAME,
>> +		.owner  = THIS_MODULE,
>> +	},
>> +};
>> +
>> +static int __init gpio_ir_recv_init(void)
>> +{
>> +	return platform_driver_register(&gpio_ir_recv_driver);
>> +}
>> +module_init(gpio_ir_recv_init);
>> +
>> +static void __exit gpio_ir_recv_exit(void)
>> +{
>> +	platform_driver_unregister(&gpio_ir_recv_driver);
>> +}
>> +module_exit(gpio_ir_recv_exit);
>> +
>> +MODULE_DESCRIPTION("GPIO IR Receiver driver");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/include/media/gpio-ir-recv.h b/include/media/gpio-ir-recv.h
>> new file mode 100644
>> index 0000000..3eab611
>> --- /dev/null
>> +++ b/include/media/gpio-ir-recv.h
>> @@ -0,0 +1,23 @@
>> +/* Copyright (c) 2012, Code Aurora Forum. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef __GPIO_IR_RECV_H__
>> +#define __GPIO_IR_RECV_H__
>> +
>> +struct gpio_ir_recv_platform_data {
>> +	unsigned int gpio_nr;
>> +	bool active_low;
>> +	bool can_wakeup;
>> +};
>> +
>> +#endif /* __GPIO_IR_RECV_H__ */
>> +
>> --
>> Sent by a consultant of the Qualcomm Innovation Center, Inc.
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

Thanks,
Ravi Kumar V
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

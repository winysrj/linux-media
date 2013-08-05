Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f51.google.com ([209.85.212.51]:38024 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab3HEOW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 10:22:26 -0400
MIME-Version: 1.0
In-Reply-To: <51FD793C.8030904@gmail.com>
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com>
	<1375455762-22071-4-git-send-email-arun.kk@samsung.com>
	<51FD793C.8030904@gmail.com>
Date: Mon, 5 Aug 2013 19:52:25 +0530
Message-ID: <CALt3h79FxKU+CJGjAXqC+9sk-n-c2Q3v_ooRtPxKL0PFq1z6Lw@mail.gmail.com>
Subject: Re: [RFC v3 03/13] [media] exynos5-fimc-is: Add driver core files
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sun, Aug 4, 2013 at 3:12 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 08/02/2013 05:02 PM, Arun Kumar K wrote:
>>
>> This driver is for the FIMC-IS IP available in Samsung Exynos5
>> SoC onwards. This patch adds the core files for the new driver.
>>
>> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
>> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
>> ---
>>   drivers/media/platform/exynos5-is/fimc-is-core.c |  394
>> ++++++++++++++++++++++
>>   drivers/media/platform/exynos5-is/fimc-is-core.h |  122 +++++++
>>   2 files changed, 516 insertions(+)
>>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-core.c
>>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-core.h
>>
>> diff --git a/drivers/media/platform/exynos5-is/fimc-is-core.c
>> b/drivers/media/platform/exynos5-is/fimc-is-core.c
>> new file mode 100644
>> index 0000000..7b7762b
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos5-is/fimc-is-core.c
>> @@ -0,0 +1,394 @@
>> +/*
>> + * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
>> +*
>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>> + * Arun Kumar K<arun.kk@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include<linux/bug.h>
>> +#include<linux/ctype.h>
>> +#include<linux/device.h>
>> +#include<linux/debugfs.h>
>> +#include<linux/delay.h>
>> +#include<linux/errno.h>
>> +#include<linux/err.h>
>> +#include<linux/firmware.h>
>> +#include<linux/fs.h>
>> +#include<linux/gpio.h>
>> +#include<linux/interrupt.h>
>> +#include<linux/kernel.h>
>> +#include<linux/list.h>
>> +#include<linux/module.h>
>> +#include<linux/types.h>
>> +#include<linux/platform_device.h>
>> +#include<linux/pm_runtime.h>
>> +#include<linux/slab.h>
>> +#include<linux/videodev2.h>
>> +#include<linux/of.h>
>> +#include<linux/of_gpio.h>
>> +#include<linux/of_address.h>
>> +#include<linux/of_platform.h>
>> +#include<linux/of_irq.h>
>> +#include<linux/pinctrl/consumer.h>
>> +
>> +#include<media/v4l2-device.h>
>> +#include<media/v4l2-ioctl.h>
>> +#include<media/v4l2-mem2mem.h>
>> +#include<media/v4l2-of.h>
>> +#include<media/videobuf2-core.h>
>> +#include<media/videobuf2-dma-contig.h>
>> +
>> +#include "fimc-is.h"
>> +#include "fimc-is-i2c.h"
>> +
>> +#define CLK_MCU_ISP_DIV0_FREQ  (200 * 1000000)
>> +#define CLK_MCU_ISP_DIV1_FREQ  (100 * 1000000)
>> +#define CLK_ISP_DIV0_FREQ      (134 * 1000000)
>> +#define CLK_ISP_DIV1_FREQ      (68 * 1000000)
>> +#define CLK_ISP_DIVMPWM_FREQ   (34 * 1000000)
>> +
>> +static char *fimc_is_clock_name[] = {
>> +       [IS_CLK_ISP]            = "isp",
>> +       [IS_CLK_MCU_ISP]        = "mcu_isp",
>> +       [IS_CLK_ISP_DIV0]       = "isp_div0",
>> +       [IS_CLK_ISP_DIV1]       = "isp_div1",
>> +       [IS_CLK_ISP_DIVMPWM]    = "isp_divmpwm",
>> +       [IS_CLK_MCU_ISP_DIV0]   = "mcu_isp_div0",
>> +       [IS_CLK_MCU_ISP_DIV1]   = "mcu_isp_div1",
>> +};
>> +
>> +static void fimc_is_put_clocks(struct fimc_is *is)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i<  IS_CLK_MAX_NUM; i++) {
>> +               if (IS_ERR(is->clock[i]))
>> +                       continue;
>> +               clk_unprepare(is->clock[i]);
>> +               clk_put(is->clock[i]);
>> +               is->clock[i] = NULL;
>> +       }
>> +}
>> +
>> +static int fimc_is_get_clocks(struct fimc_is *is)
>> +{
>> +       struct device *dev =&is->pdev->dev;
>>
>> +       int i, ret;
>> +
>> +       for (i = 0; i<  IS_CLK_MAX_NUM; i++) {
>> +               is->clock[i] = clk_get(dev, fimc_is_clock_name[i]);
>> +               if (IS_ERR(is->clock[i]))
>> +                       goto err;
>> +               ret = clk_prepare(is->clock[i]);
>> +               if (ret<  0) {
>> +                       clk_put(is->clock[i]);
>> +                       is->clock[i] = ERR_PTR(-EINVAL);
>> +                       goto err;
>> +               }
>> +       }
>> +       return 0;
>> +err:
>> +       fimc_is_put_clocks(is);
>> +       pr_err("Failed to get clock: %s\n", fimc_is_clock_name[i]);
>> +       return -ENXIO;
>> +}
>> +
>> +static int fimc_is_configure_clocks(struct fimc_is *is)
>> +{
>> +       int i, ret;
>> +
>> +       for (i = 0; i<  IS_CLK_MAX_NUM; i++)
>> +               is->clock[i] = ERR_PTR(-EINVAL);
>> +
>> +       ret = fimc_is_get_clocks(is);
>> +       if (ret)
>> +               return ret;
>> +
>> +       /* Set rates */
>> +       ret = clk_set_rate(is->clock[IS_CLK_MCU_ISP_DIV0],
>> +                       CLK_MCU_ISP_DIV0_FREQ);
>> +       if (ret)
>> +               return ret;
>> +       ret = clk_set_rate(is->clock[IS_CLK_MCU_ISP_DIV1],
>> +                       CLK_MCU_ISP_DIV1_FREQ);
>> +       if (ret)
>> +               return ret;
>> +       ret = clk_set_rate(is->clock[IS_CLK_ISP_DIV0], CLK_ISP_DIV0_FREQ);
>> +       if (ret)
>> +               return ret;
>> +       ret = clk_set_rate(is->clock[IS_CLK_ISP_DIV1], CLK_ISP_DIV1_FREQ);
>> +       if (ret)
>> +               return ret;
>> +       ret = clk_set_rate(is->clock[IS_CLK_ISP_DIVMPWM],
>> +                       CLK_ISP_DIVMPWM_FREQ);
>> +       return ret;
>> +}
>> +
>> +static void fimc_is_pipelines_destroy(struct fimc_is *is)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i<  is->num_instance; i++)
>> +               fimc_is_pipeline_destroy(&is->pipeline[i]);
>> +}
>> +
>> +static int fimc_is_parse_sensor_config(struct fimc_is *is, unsigned int
>> index,
>> +                                               struct device_node *node)
>> +{
>> +       struct fimc_is_sensor *sensor =&is->sensor[index];
>>
>> +       u32 tmp = 0;
>> +       int ret;
>> +
>> +       sensor->drvdata = exynos5_is_sensor_get_drvdata(node);
>> +       if (!sensor->drvdata) {
>> +               dev_err(&is->pdev->dev, "no driver data found for: %s\n",
>> +                                                        node->full_name);
>> +               return -EINVAL;
>> +       }
>> +
>> +       node = v4l2_of_get_next_endpoint(node, NULL);
>> +       if (!node)
>> +               return -ENXIO;
>> +
>> +       node = v4l2_of_get_remote_port(node);
>> +       if (!node)
>> +               return -ENXIO;
>> +
>> +       /* Use MIPI-CSIS channel id to determine the ISP I2C bus index. */
>> +       ret = of_property_read_u32(node, "reg",&tmp);
>> +       if (ret<  0) {
>> +               dev_err(&is->pdev->dev, "reg property not found at: %s\n",
>> +                                                        node->full_name);
>> +               return ret;
>> +       }
>> +
>> +       sensor->i2c_bus = tmp - FIMC_INPUT_MIPI_CSI2_0;
>> +       return 0;
>> +}
>> +
>> +static int fimc_is_parse_sensor(struct fimc_is *is)
>> +{
>> +       struct device_node *i2c_bus, *child;
>> +       int ret, index = 0;
>> +
>> +       for_each_compatible_node(i2c_bus, NULL, FIMC_IS_I2C_COMPATIBLE) {
>> +               for_each_available_child_of_node(i2c_bus, child) {
>> +                       ret = fimc_is_parse_sensor_config(is, index,
>> child);
>> +
>> +                       if (ret<  0 || index>= FIMC_IS_NUM_SENSORS) {
>> +                               of_node_put(child);
>> +                               return ret;
>> +                       }
>> +                       index++;
>> +               }
>> +       }
>> +       return 0;
>> +}
>> +
>> +static int fimc_is_probe(struct platform_device *pdev)
>> +{
>> +       struct device *dev =&pdev->dev;
>>
>> +       struct resource *res;
>> +       struct fimc_is *is;
>> +       void __iomem *regs;
>> +       struct device_node *node;
>> +       int irq, ret;
>> +       int i;
>> +
>> +       pr_debug("FIMC-IS Probe Enter\n");
>
>
> dev_dbg() ?
>
>> +       if (!pdev->dev.of_node)
>> +               return -ENODEV;
>> +
>> +       is = devm_kzalloc(&pdev->dev, sizeof(*is), GFP_KERNEL);
>> +       if (!is)
>> +               return -ENOMEM;
>> +
>> +       is->pdev = pdev;
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       regs = devm_ioremap_resource(dev, res);
>> +       if (IS_ERR(regs))
>> +               return PTR_ERR(regs);
>> +
>> +       /* Get the PMU base */
>> +       node = of_get_child_by_name(dev->of_node, "pmu");
>> +       if (!node)
>> +               return -ENODEV;
>> +       is->pmu_regs = of_iomap(node, 0);
>> +       if (!is->pmu_regs)
>> +               return -ENOMEM;
>> +
>> +       irq = irq_of_parse_and_map(dev->of_node, 0);
>> +       if (irq<  0) {
>> +               dev_err(dev, "Failed to get IRQ\n");
>> +               return irq;
>> +       }
>> +
>> +       ret = of_property_read_u32(pdev->dev.of_node, "num-instance",
>> +                       &is->num_instance);
>> +       if (ret&&  !is->num_instance) {
>>
>> +               dev_err(dev, "Error num instances\n");
>
>
> Hmm, what is this property ? I can't see it listed in the binding document.
>

It is the number of parallel instances that the IS-firmware can handle.
For 5250, its only 1, but in future SoCs, it can handle multiple
parallel pipelines
for supporting multiple sensors simultaneously. I have now moved it to
driver data instead of DT as its a firmware property.

>
>> +               return -EINVAL;
>> +       }
>> +
>> +       ret = fimc_is_configure_clocks(is);
>> +       if (ret<  0) {
>> +               dev_err(dev, "Clock config failed\n");
>
>
> s/Clock config/clocks configration ?
>
>
>> +               goto err_clk;
>> +       }
>> +
>> +       platform_set_drvdata(pdev, is);
>> +       pm_runtime_enable(dev);
>> +
>> +       ret = pm_runtime_get_sync(dev);
>> +       if (ret<  0)
>> +               goto err_pm;
>> +
>> +       is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
>> +       if (IS_ERR(is->alloc_ctx)) {
>> +               ret = PTR_ERR(is->alloc_ctx);
>> +               goto err_vb;
>> +       }
>> +
>> +       /* Get IS-sensor contexts */
>> +       ret = fimc_is_parse_sensor(is);
>> +       if (ret<  0)
>> +               goto err_vb;
>> +
>> +       /* Initialize FIMC Pipeline */
>> +       for (i = 0; i<  is->num_instance; i++) {
>> +               ret = fimc_is_pipeline_init(&is->pipeline[i], i, is);
>> +               if (ret<  0)
>> +                       goto err_sd;
>> +       }
>> +
>> +       /* Initialize FIMC Interface */
>> +       ret = fimc_is_interface_init(&is->interface, regs, irq);
>> +       if (ret<  0)
>> +               goto err_sd;
>> +
>> +       pm_runtime_put(dev);
>> +
>> +       dev_dbg(dev, "FIMC-IS registered successfully\n");
>> +
>> +       return 0;
>> +
>> +err_sd:
>> +       fimc_is_pipelines_destroy(is);
>> +err_vb:
>> +       vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
>> +err_pm:
>> +       pm_runtime_put(dev);
>> +err_clk:
>> +       fimc_is_put_clocks(is);
>> +
>> +       return ret;
>> +}
>> +
>> +int fimc_is_clk_enable(struct fimc_is *is)
>> +{
>> +       int ret;
>> +
>> +       ret = clk_enable(is->clock[IS_CLK_ISP]);
>> +       if (ret)
>> +               return ret;
>> +       ret = clk_enable(is->clock[IS_CLK_MCU_ISP]);
>> +       return ret;
>> +}
>> +
>> +void fimc_is_clk_disable(struct fimc_is *is)
>> +{
>> +       clk_disable(is->clock[IS_CLK_ISP]);
>> +       clk_disable(is->clock[IS_CLK_MCU_ISP]);
>> +}
>> +
>> +static int fimc_is_pm_resume(struct device *dev)
>> +{
>> +       struct fimc_is *is = dev_get_drvdata(dev);
>> +       int ret;
>> +
>> +       ret = fimc_is_clk_enable(is);
>> +       if (ret<  0) {
>> +               dev_err(dev, "Could not enable clocks\n");
>> +               return ret;
>> +       }
>> +       return 0;
>> +}
>> +
>> +static int fimc_is_pm_suspend(struct device *dev)
>> +{
>> +       struct fimc_is *is = dev_get_drvdata(dev);
>> +
>> +       fimc_is_clk_disable(is);
>> +       return 0;
>> +}
>> +
>> +static int fimc_is_runtime_resume(struct device *dev)
>> +{
>> +       return fimc_is_pm_resume(dev);
>> +}
>> +
>> +static int fimc_is_runtime_suspend(struct device *dev)
>> +{
>> +       return fimc_is_pm_suspend(dev);
>> +}
>> +
>> +#ifdef CONFIG_PM_SLEEP
>> +static int fimc_is_resume(struct device *dev)
>> +{
>> +       return fimc_is_pm_resume(dev);
>
>
> You're using same function for system sleep and runtime PM, fimc_is_resume()
> should not attempt to disable the clocks if they are already disabled, i.e.
> the device is not active.
>

Ok I havent implemented system sleep functionality yet. I will keep
it as a TODO for now. Hope its ok.

>> +}
>> +

Regards
Arun

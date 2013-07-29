Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17674 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3G2PvU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 11:51:20 -0400
Message-id: <51F68F73.9060603@samsung.com>
Date: Mon, 29 Jul 2013 17:51:15 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: gregkh@linuxfoundation.org, kyungmin.park@samsung.com,
	balbi@ti.com, jg1.han@samsung.com, kgene.kim@samsung.com,
	stern@rowland.harvard.edu, broonie@kernel.org,
	tomasz.figa@gmail.com, arnd@arndb.de, devicetree@vger.kernel.org,
	linux-fbdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	swarren@nvidia.com, balajitk@ti.com, linux-doc@vger.kernel.org,
	tony@atomide.com, Tomasz Figa <t.figa@samsung.com>,
	linux-usb@vger.kernel.org, nsekhar@ti.com,
	linux-kernel@vger.kernel.org, grant.likely@linaro.org,
	linux@arm.linux.org.uk, akpm@linux-foundation.org,
	linux-omap@vger.kernel.org, george.cherian@ti.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [RESEND PATCH v10 1/8] drivers: phy: add generic PHY framework
References: <1374842963-13545-1-git-send-email-kishon@ti.com>
 <1374842963-13545-2-git-send-email-kishon@ti.com>
In-reply-to: <1374842963-13545-2-git-send-email-kishon@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/26/2013 02:49 PM, Kishon Vijay Abraham I wrote:
> The PHY framework provides a set of APIs for the PHY drivers to
> create/destroy a PHY and APIs for the PHY users to obtain a reference to the
> PHY with or without using phandle. For dt-boot, the PHY drivers should
> also register *PHY provider* with the framework.
> 
> PHY drivers should create the PHY by passing id and ops like init, exit,
> power_on and power_off. This framework is also pm runtime enabled.
> 
> The documentation for the generic PHY framework is added in
> Documentation/phy.txt and the documentation for dt binding can be found at
> Documentation/devicetree/bindings/phy/phy-bindings.txt
> 
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  .../devicetree/bindings/phy/phy-bindings.txt       |   66 ++
>  Documentation/phy.txt                              |  166 +++++
>  MAINTAINERS                                        |    8 +
>  drivers/Kconfig                                    |    2 +
>  drivers/Makefile                                   |    2 +
>  drivers/phy/Kconfig                                |   18 +
>  drivers/phy/Makefile                               |    5 +
>  drivers/phy/phy-core.c                             |  714 ++++++++++++++++++++
>  include/linux/phy/phy.h                            |  270 ++++++++
>  9 files changed, 1251 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/phy-bindings.txt
>  create mode 100644 Documentation/phy.txt
>  create mode 100644 drivers/phy/Kconfig
>  create mode 100644 drivers/phy/Makefile
>  create mode 100644 drivers/phy/phy-core.c
>  create mode 100644 include/linux/phy/phy.h
> 
> diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt b/Documentation/devicetree/bindings/phy/phy-bindings.txt
> new file mode 100644
> index 0000000..8ae844f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/phy-bindings.txt
> @@ -0,0 +1,66 @@
> +This document explains only the device tree data binding. For general
> +information about PHY subsystem refer to Documentation/phy.txt
[...]
> @@ -0,0 +1,166 @@
> +			    PHY SUBSYSTEM
> +		  Kishon Vijay Abraham I <kishon@ti.com>
> +
> +This document explains the Generic PHY Framework along with the APIs provided,
> +and how-to-use.
> +
> +1. Introduction
> +
> +*PHY* is the abbreviation for physical layer. It is used to connect a device
> +to the physical medium e.g., the USB controller has a PHY to provide functions
> +such as serialization, de-serialization, encoding, decoding and is responsible
> +for obtaining the required data transmission rate. Note that some USB
> +controllers have PHY functionality embedded into it and others use an external
> +PHY. Other peripherals that use PHY include Wireless LAN, Ethernet,
> +SATA etc.
> +
> +The intention of creating this framework is to bring the PHY drivers spread
> +all over the Linux kernel to drivers/phy to increase code re-use and for
> +better code maintainability.
> +
> +This framework will be of use only to devices that use external PHY (PHY
> +functionality is not embedded within the controller).
> +
> +2. Registering/Unregistering the PHY provider
> +
> +PHY provider refers to an entity that implements one or more PHY instances.
> +For the simple case where the PHY provider implements only a single instance of
> +the PHY, the framework provides its own implementation of of_xlate in
> +of_phy_simple_xlate. If the PHY provider implements multiple instances, it
> +should provide its own implementation of of_xlate. of_xlate is used only for
> +dt boot case.
> +
> +#define of_phy_provider_register(dev, xlate)    \
> +        __of_phy_provider_register((dev), THIS_MODULE, (xlate))
> +
> +#define devm_of_phy_provider_register(dev, xlate)       \
> +        __of_phy_provider_register((dev), THIS_MODULE, (xlate))

This needs to be:

	__devm_of_phy_provider_register((dev), THIS_MODULE, (xlate))

as Kamil pointed out. We've tested it here with v9 and it makes
Bad Things happen. ;)

> +of_phy_provider_register and devm_of_phy_provider_register macros can be used to
> +register the phy_provider and it takes device and of_xlate as
> +arguments. For the dt boot case, all PHY providers should use one of the above
> +2 macros to register the PHY provider.
> +
> +void devm_of_phy_provider_unregister(struct device *dev,
> +	struct phy_provider *phy_provider);
> +void of_phy_provider_unregister(struct phy_provider *phy_provider);
> +
> +devm_of_phy_provider_unregister and of_phy_provider_unregister can be used to
> +unregister the PHY.
> +
[...]
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> new file mode 100644
> index 0000000..f1d15e5
> --- /dev/null
> +++ b/drivers/phy/phy-core.c
> @@ -0,0 +1,714 @@
[...]
> +static struct phy *phy_lookup(struct device *device, const char *port)
> +{
> +	unsigned int count;
> +	struct phy *phy;
> +	struct device *dev;
> +	struct phy_consumer *consumers;
> +	struct class_dev_iter iter;
	
Don't you need something like

	if (phy->init_data == NULL)	
		return ERR_PTR(-EINVAL);

to ensure there is no attempt to dereference NULL platform data ?

> +	class_dev_iter_init(&iter, phy_class, NULL, NULL);
> +	while ((dev = class_dev_iter_next(&iter))) {
> +		phy = to_phy(dev);
> +		count = phy->init_data->num_consumers;
> +		consumers = phy->init_data->consumers;
> +		while (count--) {
> +			if (!strcmp(consumers->dev_name, dev_name(device)) &&
> +					!strcmp(consumers->port, port)) {
> +				class_dev_iter_exit(&iter);
> +				return phy;
> +			}
> +			consumers++;
> +		}
> +	}
> +
> +	class_dev_iter_exit(&iter);
> +	return ERR_PTR(-ENODEV);
> +}
> +
[...]
> +int phy_init(struct phy *phy)
> +{
> +	int ret;
> +
> +	ret = phy_pm_runtime_get_sync(phy);
> +	if (ret < 0 && ret != -ENOTSUPP)
> +		return ret;
> +
> +	mutex_lock(&phy->mutex);
> +	if (phy->init_count++ == 0 && phy->ops->init) {
> +		ret = phy->ops->init(phy);
> +		if (ret < 0) {
> +			dev_err(&phy->dev, "phy init failed --> %d\n", ret);
> +			goto out;

Is this 'goto' and similar ones below really needed ?

> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&phy->mutex);
> +	phy_pm_runtime_put(phy);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phy_init);
> +
> +int phy_exit(struct phy *phy)
> +{
> +	int ret;
> +
> +	ret = phy_pm_runtime_get_sync(phy);
> +	if (ret < 0 && ret != -ENOTSUPP)
> +		return ret;
> +
> +	mutex_lock(&phy->mutex);
> +	if (--phy->init_count == 0 && phy->ops->exit) {
> +		ret = phy->ops->exit(phy);
> +		if (ret < 0) {
> +			dev_err(&phy->dev, "phy exit failed --> %d\n", ret);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&phy->mutex);
> +	phy_pm_runtime_put(phy);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phy_exit);
> +
> +int phy_power_on(struct phy *phy)
> +{
> +	int ret = -ENOTSUPP;
> +
> +	ret = phy_pm_runtime_get_sync(phy);
> +	if (ret < 0 && ret != -ENOTSUPP)
> +		return ret;
> +
> +	mutex_lock(&phy->mutex);
> +	if (phy->power_count++ == 0 && phy->ops->power_on) {
> +		ret = phy->ops->power_on(phy);
> +		if (ret < 0) {
> +			dev_err(&phy->dev, "phy poweron failed --> %d\n", ret);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&phy->mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phy_power_on);
> +
> +int phy_power_off(struct phy *phy)
> +{
> +	int ret = -ENOTSUPP;
> +
> +	mutex_lock(&phy->mutex);
> +	if (--phy->power_count == 0 && phy->ops->power_off) {
> +		ret =  phy->ops->power_off(phy);
> +		if (ret < 0) {
> +			dev_err(&phy->dev, "phy poweroff failed --> %d\n", ret);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&phy->mutex);
> +	phy_pm_runtime_put(phy);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phy_power_off);

--
Thanks,
Sylwester

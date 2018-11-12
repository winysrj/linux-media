Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllv0015.ext.ti.com ([198.47.19.141]:41818 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbeKLT4Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 14:56:16 -0500
Subject: Re: [PATCH v2 2/9] phy: Add configuration interface
To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>
CC: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
 <4d0506aa0a61d234610b42a268a8326d9ea18466.1541516029.git-series.maxime.ripard@bootlin.com>
From: Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <3a9a28df-8139-1036-a884-0de64aa07df1@ti.com>
Date: Mon, 12 Nov 2018 15:32:25 +0530
MIME-Version: 1.0
In-Reply-To: <4d0506aa0a61d234610b42a268a8326d9ea18466.1541516029.git-series.maxime.ripard@bootlin.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On 06/11/18 8:24 PM, Maxime Ripard wrote:
> The phy framework is only allowing to configure the power state of the PHY
> using the init and power_on hooks, and their power_off and exit
> counterparts.
> 
> While it works for most, simple, PHYs supported so far, some more advanced
> PHYs need some configuration depending on runtime parameters. These PHYs
> have been supported by a number of means already, often by using ad-hoc
> drivers in their consumer drivers.
> 
> That doesn't work too well however, when a consumer device needs to deal
> with multiple PHYs, or when multiple consumers need to deal with the same
> PHY (a DSI driver and a CSI driver for example).
> 
> So we'll add a new interface, through two funtions, phy_validate and
> phy_configure. The first one will allow to check that a current
> configuration, for a given mode, is applicable. It will also allow the PHY
> driver to tune the settings given as parameters as it sees fit.
> 
> phy_configure will actually apply that configuration in the phy itself.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/phy/phy-core.c  | 61 ++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/phy/phy.h | 58 ++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 119 insertions(+)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 35fd38c5a4a1..7bd3ed65c708 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -408,6 +408,67 @@ int phy_calibrate(struct phy *phy)
>  EXPORT_SYMBOL_GPL(phy_calibrate);
>  
>  /**
> + * phy_configure() - Changes the phy parameters
> + * @phy: the phy returned by phy_get()
> + * @opts: New configuration to apply
> + *
> + * Used to change the PHY parameters. phy_init() must have been called
> + * on the phy. The configuration will be applied on the current phy
> + * mode, that can be changed using phy_set_mode().
> + *
> + * Returns: 0 if successful, an negative error code otherwise
> + */
> +int phy_configure(struct phy *phy, union phy_configure_opts *opts)
> +{
> +	int ret;
> +
> +	if (!phy)
> +		return -EINVAL;
> +
> +	if (!phy->ops->configure)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&phy->mutex);
> +	ret = phy->ops->configure(phy, opts);
> +	mutex_unlock(&phy->mutex);
> +
> +	return ret;
> +}

EXPORT_SYMBOL_GPL is missing here and below.
> +
> +/**
> + * phy_validate() - Checks the phy parameters
> + * @phy: the phy returned by phy_get()
> + * @mode: phy_mode the configuration is applicable to.
> + * @opts: Configuration to check
> + *
> + * Used to check that the current set of parameters can be handled by
> + * the phy. Implementations are free to tune the parameters passed as
> + * arguments if needed by some implementation detail or
> + * constraints. It will not change any actual configuration of the
> + * PHY, so calling it as many times as deemed fit will have no side
> + * effect.
> + *
> + * Returns: 0 if successful, an negative error code otherwise
> + */
> +int phy_validate(struct phy *phy, enum phy_mode mode,
> +		  union phy_configure_opts *opts)

We are planning to switch to mode/submode combination [1], so this might have
to change.

Thanks
Kishon

[1] -> https://patchwork.kernel.org/cover/10673295/
> +{
> +	int ret;
> +
> +	if (!phy)
> +		return -EINVAL;
> +
> +	if (!phy->ops->validate)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&phy->mutex);
> +	ret = phy->ops->validate(phy, mode, opts);
> +	mutex_unlock(&phy->mutex);
> +
> +	return ret;
> +}
> +
> +/**
>   * _of_phy_get() - lookup and obtain a reference to a phy by phandle
>   * @np: device_node for which to get the phy
>   * @index: the index of the phy
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index d5c2ac7369f2..89cf8b685546 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -46,6 +46,12 @@ enum phy_mode {
>  };
>  
>  /**
> + * union phy_configure_opts - Opaque generic phy configuration
> + */
> +union phy_configure_opts {
> +};
> +
> +/**
>   * struct phy_ops - set of function pointers for performing phy operations
>   * @init: operation to be performed for initializing phy
>   * @exit: operation to be performed while exiting
> @@ -62,6 +68,37 @@ struct phy_ops {
>  	int	(*power_on)(struct phy *phy);
>  	int	(*power_off)(struct phy *phy);
>  	int	(*set_mode)(struct phy *phy, enum phy_mode mode);
> +
> +	/**
> +	 * @configure:
> +	 *
> +	 * Optional.
> +	 *
> +	 * Used to change the PHY parameters. phy_init() must have
> +	 * been called on the phy.
> +	 *
> +	 * Returns: 0 if successful, an negative error code otherwise
> +	 */
> +	int	(*configure)(struct phy *phy, union phy_configure_opts *opts);
> +
> +	/**
> +	 * @validate:
> +	 *
> +	 * Optional.
> +	 *
> +	 * Used to check that the current set of parameters can be
> +	 * handled by the phy. Implementations are free to tune the
> +	 * parameters passed as arguments if needed by some
> +	 * implementation detail or constraints. It must not change
> +	 * any actual configuration of the PHY, so calling it as many
> +	 * times as deemed fit by the consumer must have no side
> +	 * effect.
> +	 *
> +	 * Returns: 0 if the configuration can be applied, an negative
> +	 * error code otherwise
> +	 */
> +	int	(*validate)(struct phy *phy, enum phy_mode mode,
> +			    union phy_configure_opts *opts);
>  	int	(*reset)(struct phy *phy);
>  	int	(*calibrate)(struct phy *phy);
>  	struct module *owner;
> @@ -166,6 +203,9 @@ int phy_exit(struct phy *phy);
>  int phy_power_on(struct phy *phy);
>  int phy_power_off(struct phy *phy);
>  int phy_set_mode(struct phy *phy, enum phy_mode mode);
> +int phy_configure(struct phy *phy, union phy_configure_opts *opts);
> +int phy_validate(struct phy *phy, enum phy_mode mode,
> +		 union phy_configure_opts *opts);
>  static inline enum phy_mode phy_get_mode(struct phy *phy)
>  {
>  	return phy->attrs.mode;
> @@ -305,6 +345,24 @@ static inline int phy_calibrate(struct phy *phy)
>  	return -ENOSYS;
>  }
>  
> +static inline int phy_configure(struct phy *phy,
> +				union phy_configure_opts *opts)
> +{
> +	if (!phy)
> +		return 0;
> +
> +	return -ENOSYS;
> +}
> +
> +static inline int phy_validate(struct phy *phy, enum phy_mode mode,
> +			       union phy_configure_opts *opts)
> +{
> +	if (!phy)
> +		return 0;
> +
> +	return -ENOSYS;
> +}
> +
>  static inline int phy_get_bus_width(struct phy *phy)
>  {
>  	return -ENOSYS;
> 

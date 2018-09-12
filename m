Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllv0015.ext.ti.com ([198.47.19.141]:47376 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbeILMqp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 08:46:45 -0400
Subject: Re: [PATCH 02/10] phy: Add configuration interface
To: Maxime Ripard <maxime.ripard@bootlin.com>
CC: Boris Brezillon <boris.brezillon@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
 <a739a2d623c3e60373a73e1ec206c2aa35c4a742.1536138624.git-series.maxime.ripard@bootlin.com>
 <1ed01c1f-76d5-fa96-572b-9bfd269ad11b@ti.com>
 <20180906145622.kwxvkcuerbeqsj6b@flea>
From: Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <1a169fad-72b7-fac0-1254-cac5d8304740@ti.com>
Date: Wed, 12 Sep 2018 13:12:31 +0530
MIME-Version: 1.0
In-Reply-To: <20180906145622.kwxvkcuerbeqsj6b@flea>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thursday 06 September 2018 08:26 PM, Maxime Ripard wrote:
> Hi Kishon,
> 
> On Thu, Sep 06, 2018 at 02:57:58PM +0530, Kishon Vijay Abraham I wrote:
>> On Wednesday 05 September 2018 02:46 PM, Maxime Ripard wrote:
>>> The phy framework is only allowing to configure the power state of the PHY
>>> using the init and power_on hooks, and their power_off and exit
>>> counterparts.
>>>
>>> While it works for most, simple, PHYs supported so far, some more advanced
>>> PHYs need some configuration depending on runtime parameters. These PHYs
>>> have been supported by a number of means already, often by using ad-hoc
>>> drivers in their consumer drivers.
>>>
>>> That doesn't work too well however, when a consumer device needs to deal
>>> multiple PHYs, or when multiple consumers need to deal with the same PHY (a
>>> DSI driver and a CSI driver for example).
>>>
>>> So we'll add a new interface, through two funtions, phy_validate and
>>> phy_configure. The first one will allow to check that a current
>>> configuration, for a given mode, is applicable. It will also allow the PHY
>>> driver to tune the settings given as parameters as it sees fit.
>>>
>>> phy_configure will actually apply that configuration in the phy itself.
>>>
>>> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>>> ---
>>>  drivers/phy/phy-core.c  | 62 ++++++++++++++++++++++++++++++++++++++++++-
>>>  include/linux/phy/phy.h | 42 ++++++++++++++++++++++++++++-
>>>  2 files changed, 104 insertions(+)
>>>
>>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>>> index 35fd38c5a4a1..6eaf655e370f 100644
>>> --- a/drivers/phy/phy-core.c
>>> +++ b/drivers/phy/phy-core.c
>>> @@ -408,6 +408,68 @@ int phy_calibrate(struct phy *phy)
>>>  EXPORT_SYMBOL_GPL(phy_calibrate);
>>>  
>>>  /**
>>> + * phy_configure() - Changes the phy parameters
>>> + * @phy: the phy returned by phy_get()
>>> + * @mode: phy_mode the configuration is applicable to.
>>
>> mode should be used if the same PHY can be configured in multiple modes. But
>> with phy_set_mode() and phy_calibrate() we could achieve the same.
> 
> So you would change the prototype to have a configuration applying
> only to the current mode set previously through set_mode?

yeah.
With phy_configure, if the PHY is not in @mode, it should return an error? Or
will it set the PHY to @mode and apply the configuration in @opts?
> 
> Can we have PHY that operate in multiple modes at the same time?

Not at the same time. But the same PHY can operate in multiple modes (For
example we have PHYs that can be used either with PCIe or USB3)
> 
>>> + * @opts: New configuration to apply
>>
>> Should these configuration come from the consumer driver?
> 
> Yes

How does the consumer driver get these configurations? Is it from user space or
dt associated with consumer device.
> 
>> Can't the helper functions be directly invoked by the PHY driver for
>> the configuration.
> 
> Not really. The helpers are here to introduce functions that give you
> the defaults provided by the spec for a given configuration, and to
> validate that a given configuration is within the spec boundaries. I
> expect some consumers to need to change the defaults for some more
> suited parameters that are still within the boundaries defined by the
> spec.
> 
> And I'd really want to have that interface being quite generic, and
> applicable to other phy modes as well. The allwinner USB PHY for
> example require at the moment an extra function that could be moved to
> this API:
> https://elixir.bootlin.com/linux/latest/source/drivers/phy/allwinner/phy-sun4i-usb.c#L512
> 
>>> + *
>>> + * Used to change the PHY parameters. phy_init() must have
>>> + * been called on the phy.
>>> + *
>>> + * Returns: 0 if successful, an negative error code otherwise
>>> + */
>>> +int phy_configure(struct phy *phy, enum phy_mode mode,
>>> +		  union phy_configure_opts *opts)
>>> +{> +	int ret;
>>> +
>>> +	if (!phy)
>>> +		return -EINVAL;
>>> +
>>> +	if (!phy->ops->configure)
>>> +		return 0;
>>> +
>>> +	mutex_lock(&phy->mutex);
>>> +	ret = phy->ops->configure(phy, mode, opts);
>>> +	mutex_unlock(&phy->mutex);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>> +/**
>>> + * phy_validate() - Checks the phy parameters
>>> + * @phy: the phy returned by phy_get()
>>> + * @mode: phy_mode the configuration is applicable to.
>>> + * @opts: Configuration to check
>>> + *
>>> + * Used to check that the current set of parameters can be handled by
>>> + * the phy. Implementations are free to tune the parameters passed as
>>> + * arguments if needed by some implementation detail or
>>> + * constraints. It will not change any actual configuration of the
>>> + * PHY, so calling it as many times as deemed fit will have no side
>>> + * effect.
>>> + *
>>> + * Returns: 0 if successful, an negative error code otherwise
>>> + */
>>> +int phy_validate(struct phy *phy, enum phy_mode mode,
>>> +		  union phy_configure_opts *opts)
>>
>> IIUC the consumer driver will pass configuration options (or PHY parameters)
>> which will be validated by the PHY driver and in some cases the PHY driver can
>> modify the configuration options? And these modified configuration options will
>> again be given to phy_configure?
>>
>> Looks like it's a round about way of doing the same thing.
> 
> Not really. The validate callback allows to check whether a particular
> configuration would work, and try to negotiate a set of configurations
> that both the consumer and the PHY could work with.

Maybe the PHY should provide the list of supported features to the consumer
driver and the consumer should select a supported feature?

> 
> For example, DRM requires this to filter out display modes (ie,
> resolutions) that wouldn't be achievable by the PHY so that it's never

Can't the consumer driver just tell the required resolution to the PHY and PHY
figuring out all the parameters for the resolution or an error if that
resolution cannot be supported?

Thanks
Kishon

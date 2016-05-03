Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:40746 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbcECVjA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2016 17:39:00 -0400
Date: Tue, 3 May 2016 23:38:45 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@axentia.se>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>, Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Crestez Dan Leonard <leonard.crestez@intel.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Peter Rosin <peda@lysator.liu.se>
Subject: Re: [PATCH v7 18/24] i2c-mux: relax locking of the top i2c adapter
 during mux-locked muxing
Message-ID: <20160503213844.GB2018@tetsubishi>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
 <1461165484-2314-19-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461165484-2314-19-git-send-email-peda@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> +static int i2c_mux_trylock_bus(struct i2c_adapter *adapter, int flags)
> +{
> +	struct i2c_mux_priv *priv = adapter->algo_data;
> +	struct i2c_adapter *parent = priv->muxc->parent;
> +
> +	if (!rt_mutex_trylock(&parent->mux_lock))
> +		return 0;
> +	if (!(flags & I2C_LOCK_ADAPTER))
> +		return 1;
> +	if (parent->trylock_bus(parent, flags))
> +		return 1;
> +	rt_mutex_unlock(&parent->mux_lock);
> +	return 0;
> +}

This function needs a few short comments why we can leave in this or
that state. Not everyone knows the exit values of trylock by heart and
then it can look a little confusing.

>  static int i2c_parent_trylock_bus(struct i2c_adapter *adapter, int flags)
> @@ -111,7 +189,12 @@ static int i2c_parent_trylock_bus(struct i2c_adapter *adapter, int flags)
>  	struct i2c_mux_priv *priv = adapter->algo_data;
>  	struct i2c_adapter *parent = priv->muxc->parent;
>  
> -	return parent->trylock_bus(parent, flags);
> +	if (!rt_mutex_trylock(&parent->mux_lock))
> +		return 0;
> +	if (parent->trylock_bus(parent, flags))
> +		return 1;
> +	rt_mutex_unlock(&parent->mux_lock);
> +	return 0;
>  }

Same comment as i2c_mux_trylock_bus.

>  struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
>  				   struct device *dev, int max_adapters,
> @@ -140,6 +250,8 @@ struct i2c_mux_core *i2c_mux_alloc(struct i2c_adapter *parent,
>  
>  	muxc->parent = parent;
>  	muxc->dev = dev;
> +	if (flags & I2C_MUX_LOCKED)
> +		muxc->mux_locked = 1;

s/1/true/;


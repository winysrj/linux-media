Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:49302 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586AbcDMNiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 09:38:05 -0400
Subject: Re: [PATCH v6 01/24] i2c-mux: add common data for every i2c-mux
 instance
To: Wolfram Sang <wsa@the-dreams.de>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
 <1459673574-11440-2-git-send-email-peda@lysator.liu.se>
 <20160411204630.GA10401@katana>
Cc: linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
From: Peter Rosin <peda@lysator.liu.se>
Message-ID: <570E4BAE.7060108@lysator.liu.se>
Date: Wed, 13 Apr 2016 15:37:50 +0200
MIME-Version: 1.0
In-Reply-To: <20160411204630.GA10401@katana>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On 2016-04-11 22:46, Wolfram Sang wrote:
> Hi Peter,
> 
> first high-level review:
> 
>> +int i2c_mux_reserve_adapters(struct i2c_mux_core *muxc, int adapters)
> 
> I'd suggest to rename 'adapters' into 'num_adapters' throughout this
> patch. I think it makes the code a lot easier to understand.

Hmm, you mean just the variable names, right? And not function names
such as i2c_mux_reserve_(num_)adapters?

>> +{
>> +	struct i2c_adapter **adapter;
>> +
>> +	if (adapters <= muxc->max_adapters)
>> +		return 0;
>> +
>> +	adapter = devm_kmalloc_array(muxc->dev,
>> +				     adapters, sizeof(*adapter),
>> +				     GFP_KERNEL);
>> +	if (!adapter)
>> +		return -ENOMEM;
>> +
>> +	if (muxc->adapter) {
>> +		memcpy(adapter, muxc->adapter,
>> +		       muxc->max_adapters * sizeof(*adapter));
>> +		devm_kfree(muxc->dev, muxc->adapter);
>> +	}
>> +
>> +	muxc->adapter = adapter;
>> +	muxc->max_adapters = adapters;
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(i2c_mux_reserve_adapters);
> 
> Despite that I wonder why not using some of the realloc functions, I

When I wrote it, I found no devm_ version of realloc. I'm not finding
anything now either...

> wonder even more if we couldn't supply num_adapters to i2c_mux_alloc()
> and reserve the memory statically. i2c busses are not
> dynamic/hot-pluggable so that should be good enough?

Yes, that would work, but it would take some restructuring in some of
the drivers that currently don't know how many child adapters they
are going to need when they call i2c_mux_alloc.

Because you thought about removing i2c_mux_reserve_adapters completely,
and not provide any means of adding more adapters than specified in
the i2c_mux_alloc call, right?

>> -	WARN(sysfs_create_link(&priv->adap.dev.kobj, &mux_dev->kobj, "mux_device"),
>> -			       "can't create symlink to mux device\n");
>> +	WARN(sysfs_create_link(&priv->adap.dev.kobj, &muxc->dev->kobj,
>> +			       "mux_device"),
> 
> Ignoring the 80 char limit here makes the code more readable.

That is only true if you actually have more than 80 characters, so I don't
agree. Are you adamant about it? (I'm not)

>> +	     "can't create symlink to mux device\n");
>>  
>>  	snprintf(symlink_name, sizeof(symlink_name), "channel-%u", chan_id);
>> -	WARN(sysfs_create_link(&mux_dev->kobj, &priv->adap.dev.kobj, symlink_name),
>> -			       "can't create symlink for channel %u\n", chan_id);
>> +	WARN(sysfs_create_link(&muxc->dev->kobj, &priv->adap.dev.kobj,
>> +			       symlink_name),
> 
> ditto.
> 
>> +	     "can't create symlink for channel %u\n", chan_id);
>>  	dev_info(&parent->dev, "Added multiplexed i2c bus %d\n",
>>  		 i2c_adapter_id(&priv->adap));
>>  
>> -	return &priv->adap;
>> +	muxc->adapter[muxc->adapters++] = &priv->adap;
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(i2c_mux_add_adapter);
>> +
>> +struct i2c_mux_core *i2c_mux_one_adapter(struct i2c_adapter *parent,
>> +					 struct device *dev, int sizeof_priv,
>> +					 u32 flags, u32 force_nr,
>> +					 u32 chan_id, unsigned int class,
>> +					 int (*select)(struct i2c_mux_core *,
>> +						       u32),
> 
> ditto
> 
>> +					 int (*deselect)(struct i2c_mux_core *,
>> +							 u32))
> 
> ditto
> 
>> +{
>> +	struct i2c_mux_core *muxc;
>> +	int ret;
>> +
>> +	muxc = i2c_mux_alloc(parent, dev, sizeof_priv, flags, select, deselect);
>> +	if (!muxc)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	ret = i2c_mux_add_adapter(muxc, force_nr, chan_id, class);
>> +	if (ret) {
>> +		devm_kfree(dev, muxc);
>> +		return ERR_PTR(ret);
>> +	}
>> +
>> +	return muxc;
>> +}
>> +EXPORT_SYMBOL_GPL(i2c_mux_one_adapter);
> 
> Are you sure the above function pays off? Its argument list is very
> complex and it doesn't save a lot of code. Having seperate calls is
> probably more understandable in drivers? Then again, I assume it makes
> the conversion of existing drivers easier.

I added it in v4, you can check earlier versions if you like. Without
it most gate-muxes (i.e. typically the muxes in drivers/media) grew
since the i2c_add_mux_adapter call got replaced by two calls, i.e.
i2c_mux_alloc followed by i2c_max_add_adapter, and coupled with
error checks made it look more complex than before. So, this wasn't
much of a cleanup from the point of those drivers.

> So much for now. Thanks!

Yeah, thanks!

Cheers,
Peter

Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:33199 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbcDKUqq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2016 16:46:46 -0400
Date: Mon, 11 Apr 2016 22:46:30 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@lysator.liu.se>
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
Subject: Re: [PATCH v6 01/24] i2c-mux: add common data for every i2c-mux
 instance
Message-ID: <20160411204630.GA10401@katana>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
 <1459673574-11440-2-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <1459673574-11440-2-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

first high-level review:

> +int i2c_mux_reserve_adapters(struct i2c_mux_core *muxc, int adapters)

I'd suggest to rename 'adapters' into 'num_adapters' throughout this
patch. I think it makes the code a lot easier to understand.

> +{
> +	struct i2c_adapter **adapter;
> +
> +	if (adapters <=3D muxc->max_adapters)
> +		return 0;
> +
> +	adapter =3D devm_kmalloc_array(muxc->dev,
> +				     adapters, sizeof(*adapter),
> +				     GFP_KERNEL);
> +	if (!adapter)
> +		return -ENOMEM;
> +
> +	if (muxc->adapter) {
> +		memcpy(adapter, muxc->adapter,
> +		       muxc->max_adapters * sizeof(*adapter));
> +		devm_kfree(muxc->dev, muxc->adapter);
> +	}
> +
> +	muxc->adapter =3D adapter;
> +	muxc->max_adapters =3D adapters;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(i2c_mux_reserve_adapters);

Despite that I wonder why not using some of the realloc functions, I
wonder even more if we couldn't supply num_adapters to i2c_mux_alloc()
and reserve the memory statically. i2c busses are not
dynamic/hot-pluggable so that should be good enough?

> -	WARN(sysfs_create_link(&priv->adap.dev.kobj, &mux_dev->kobj, "mux_devic=
e"),
> -			       "can't create symlink to mux device\n");
> +	WARN(sysfs_create_link(&priv->adap.dev.kobj, &muxc->dev->kobj,
> +			       "mux_device"),

Ignoring the 80 char limit here makes the code more readable.

> +	     "can't create symlink to mux device\n");
> =20
>  	snprintf(symlink_name, sizeof(symlink_name), "channel-%u", chan_id);
> -	WARN(sysfs_create_link(&mux_dev->kobj, &priv->adap.dev.kobj, symlink_na=
me),
> -			       "can't create symlink for channel %u\n", chan_id);
> +	WARN(sysfs_create_link(&muxc->dev->kobj, &priv->adap.dev.kobj,
> +			       symlink_name),

ditto.

> +	     "can't create symlink for channel %u\n", chan_id);
>  	dev_info(&parent->dev, "Added multiplexed i2c bus %d\n",
>  		 i2c_adapter_id(&priv->adap));
> =20
> -	return &priv->adap;
> +	muxc->adapter[muxc->adapters++] =3D &priv->adap;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(i2c_mux_add_adapter);
> +
> +struct i2c_mux_core *i2c_mux_one_adapter(struct i2c_adapter *parent,
> +					 struct device *dev, int sizeof_priv,
> +					 u32 flags, u32 force_nr,
> +					 u32 chan_id, unsigned int class,
> +					 int (*select)(struct i2c_mux_core *,
> +						       u32),

ditto

> +					 int (*deselect)(struct i2c_mux_core *,
> +							 u32))

ditto

> +{
> +	struct i2c_mux_core *muxc;
> +	int ret;
> +
> +	muxc =3D i2c_mux_alloc(parent, dev, sizeof_priv, flags, select, deselec=
t);
> +	if (!muxc)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ret =3D i2c_mux_add_adapter(muxc, force_nr, chan_id, class);
> +	if (ret) {
> +		devm_kfree(dev, muxc);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return muxc;
> +}
> +EXPORT_SYMBOL_GPL(i2c_mux_one_adapter);

Are you sure the above function pays off? Its argument list is very
complex and it doesn't save a lot of code. Having seperate calls is
probably more understandable in drivers? Then again, I assume it makes
the conversion of existing drivers easier.

So much for now. Thanks!

   Wolfram


--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXDA0lAAoJEBQN5MwUoCm2HswQAKtNuTfMBpUoo7AigaI3Fpxd
LLJzQxBDJMJ98MgPpUyIuVZhMSi3BXtfCpbNCzNlr0p2VwPtKO50EJGVy95raOrX
FESTq7soy3HQsqfaQjzXeF0YMsKkOvsxiKpL9vBz/bazIjzKDVWlJkLapGwOgchV
hPyRAIC5f0+imUl9g3HVCIQcV6mtc5uGQRCMQA7NljM9FAvdAPBXWzAC4QSS2PZz
6kNUxoJPNpvLwMm1htg2qBofIxbI5H7veNqnJm6QhiXjCkt9MsaJRPGw9+srZbnT
R2VlfRqC6nhdarFcF0NCqWUdiyM2ogRQFMwrgxu6SIppQGUc9ZYTyZhJgIvAouEJ
Xx5/W1BtcUd0RnS43Q/XX8ibi3IF6tQPH5SHT2nIulBe2wJ0j7/hPImxH2pc4vTN
XcPGTBWoH4F0typK0RnvqcO5KctzJtelczOeQbGF4MhbMsxp6CIVSGqX1YDaZlT3
w1ruL4FoLl/Zx5DLRjSNkIfE3gv/d73DXgE/NjVXcEcblNDVPp7a2eOuk8nKhb8x
eeqmtFs+GvQeNoOLFtwtktMvMhDMSAk1FRher+5mPjMEl+nllT6RSX4c7UHuvF8r
VNQeqE1xNt6Zv/aWc/pAlxdOz96a886yQntXgEImnOcTMof+KEFCUj0ZIxzH6195
2a4U0wa6gVECaJytR+We
=8CWa
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--

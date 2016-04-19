Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859AbcDSP7R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2016 11:59:17 -0400
Subject: Re: [PATCH v6 08/24] iio: imu: inv_mpu6050: convert to use an
 explicit i2c mux core
To: Peter Rosin <peda@lysator.liu.se>, linux-kernel@vger.kernel.org
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
 <1459673574-11440-9-git-send-email-peda@lysator.liu.se>
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
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
From: Crestez Dan Leonard <leonard.crestez@intel.com>
Message-ID: <57165593.4040700@intel.com>
Date: Tue, 19 Apr 2016 18:58:11 +0300
MIME-Version: 1.0
In-Reply-To: <1459673574-11440-9-git-send-email-peda@lysator.liu.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/03/2016 11:52 AM, Peter Rosin wrote:
> From: Peter Rosin <peda@axentia.se>
> 
> Allocate an explicit i2c mux core to handle parent and child adapters
> etc. Update the select/deselect ops to be in terms of the i2c mux core
> instead of the child adapter.
> 
> --- a/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
> +++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
> @@ -136,16 +133,15 @@ static int inv_mpu_probe(struct i2c_client *client,
>  		return result;
>  
>  	st = iio_priv(dev_get_drvdata(&client->dev));
> -	st->mux_adapter = i2c_add_mux_adapter(client->adapter,
> -					      &client->dev,
> -					      client,
> -					      0, 0, 0,
> -					      inv_mpu6050_select_bypass,
> -					      inv_mpu6050_deselect_bypass);
> -	if (!st->mux_adapter) {
> -		result = -ENODEV;
> +	st->muxc = i2c_mux_one_adapter(client->adapter, &client->dev, 0, 0,
> +				       0, 0, 0,
> +				       inv_mpu6050_select_bypass,
> +				       inv_mpu6050_deselect_bypass);
> +	if (IS_ERR(st->muxc)) {
> +		result = PTR_ERR(st->muxc);
>  		goto out_unreg_device;
>  	}
> +	st->muxc->priv = client;

I just tested this patch on mpu9150 (combo mpu6050+ak8975) and I got a
crash on probe which looks sort of like this:

[    5.565374] RIP: 0010:[<ffffffff81481aed>] [<ffffffff81481aed>]
mutex_lock+0xd/0x30
[    5.565374] Call Trace:
[    5.565374]  [<ffffffff813be34c>] inv_mpu6050_select_bypass+0x1c/0xa0
...
[    5.565374]  [<ffffffff81392141>] i2c_transfer+0x51/0x90
...
[    5.565374]  [<ffffffff81392cb5>] i2c_smbus_read_i2c_block_data+0x45/0xd0
[    5.565374]  [<ffffffff813bec5a>] ak8975_probe+0x14a/0x5c0
...
[    5.565374]  [<ffffffff813933d8>] i2c_new_device+0x178/0x1e0
[    5.565374]  [<ffffffff8139362d>] of_i2c_register_device+0xdd/0x1a0
[    5.565374]  [<ffffffff8139372b>] of_i2c_register_devices+0x3b/0x60
[    5.565374]  [<ffffffff81393e88>] i2c_register_adapter+0x178/0x410
[    5.565374]  [<ffffffff81394203>] i2c_add_adapter+0x73/0x90
[    5.565374]  [<ffffffff81395f3d>] i2c_mux_add_adapter+0x2ed/0x400
[    5.565374]  [<ffffffff81396091>] i2c_mux_one_adapter+0x41/0x70
[    5.565374]  [<ffffffff813be48a>] inv_mpu_probe+0xba/0x1a0

This happens because muxc->priv is not initialized when probing devices
behind the mux as described by devicetree. This can be easily fixed by
using muxc->dev instead of muxc->priv, or perhaps by calling
i2c_mux_alloc, initializing priv and later doing i2c_mux_add_adapter.

These fixes are driver-specific and other drivers might experience
similar issues. Perhaps i2c_mux_one_adapter should take void *priv just
like old i2c_add_mux_adapter?

After I fix this locally the deadlock when reading from both devices no
longer happens.

--
Regards,
Leonard

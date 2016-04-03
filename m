Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:39193 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbcDCLvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2016 07:51:17 -0400
Message-ID: <570103AE.1020707@lysator.liu.se>
Date: Sun, 03 Apr 2016 13:51:10 +0200
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
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
Subject: Re: [PATCH v6 08/24] iio: imu: inv_mpu6050: convert to use an explicit
 i2c mux core
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se> <1459673574-11440-9-git-send-email-peda@lysator.liu.se> <5700F594.9090105@kernel.org>
In-Reply-To: <5700F594.9090105@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-04-03 12:51, Jonathan Cameron wrote:
> On 03/04/16 09:52, Peter Rosin wrote:
>> From: Peter Rosin <peda@axentia.se>
>>
>> Allocate an explicit i2c mux core to handle parent and child adapters
>> etc. Update the select/deselect ops to be in terms of the i2c mux core
>> instead of the child adapter.
>>
>> Signed-off-by: Peter Rosin <peda@axentia.se>
> I'm mostly fine with this (though one unrelated change seems to have snuck
> in).  However, I'm not set up to test it - hence other than fixing the change
> you can have my ack, but ideal would be a tested by from someone with
> relevant hardware...  However, it looks to be a fairly mechanical change so
> if no one is currently setup to test it, then don't let it hold up the
> series too long!
> 
> Acked-by: Jonathan Cameron <jic23@kernel.org>

Thanks for your acks!

> Jonathan
>> ---
>>  drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c |  2 +-
>>  drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |  1 -
>>  drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c  | 32 +++++++++++++-----------------
>>  drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  |  3 ++-
>>  4 files changed, 17 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
>> index 2771106fd650..f62b8bd9ad7e 100644
>> --- a/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
>> +++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_acpi.c
>> @@ -183,7 +183,7 @@ int inv_mpu_acpi_create_mux_client(struct i2c_client *client)
>>  			} else
>>  				return 0; /* no secondary addr, which is OK */
>>  		}
>> -		st->mux_client = i2c_new_device(st->mux_adapter, &info);
>> +		st->mux_client = i2c_new_device(st->muxc->adapter[0], &info);
>>  		if (!st->mux_client)
>>  			return -ENODEV;
>>  	}
>> diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
>> index d192953e9a38..0c2bded2b5b7 100644
>> --- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
>> +++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
>> @@ -23,7 +23,6 @@
>>  #include <linux/kfifo.h>
>>  #include <linux/spinlock.h>
>>  #include <linux/iio/iio.h>
>> -#include <linux/i2c-mux.h>
>>  #include <linux/acpi.h>
>>  #include "inv_mpu_iio.h"
>>  
>> diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c
>> index f581256d9d4c..0d429d788106 100644
>> --- a/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c
>> +++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c
>> @@ -15,7 +15,6 @@
>>  #include <linux/delay.h>
>>  #include <linux/err.h>
>>  #include <linux/i2c.h>
>> -#include <linux/i2c-mux.h>
>>  #include <linux/iio/iio.h>
>>  #include <linux/module.h>
>>  #include "inv_mpu_iio.h"
>> @@ -52,10 +51,9 @@ static int inv_mpu6050_write_reg_unlocked(struct i2c_client *client,
>>  	return 0;
>>  }
>>  
>> -static int inv_mpu6050_select_bypass(struct i2c_adapter *adap, void *mux_priv,
>> -				     u32 chan_id)
>> +static int inv_mpu6050_select_bypass(struct i2c_mux_core *muxc, u32 chan_id)
>>  {
>> -	struct i2c_client *client = mux_priv;
>> +	struct i2c_client *client = i2c_mux_priv(muxc);
>>  	struct iio_dev *indio_dev = dev_get_drvdata(&client->dev);

Here, the existing code uses drv_get_drvdata to get from i2c_client to iio_dev...

>>  	struct inv_mpu6050_state *st = iio_priv(indio_dev);
>>  	int ret = 0;
>> @@ -84,10 +82,9 @@ write_error:
>>  	return ret;
>>  }
>>  
>> -static int inv_mpu6050_deselect_bypass(struct i2c_adapter *adap,
>> -				       void *mux_priv, u32 chan_id)
>> +static int inv_mpu6050_deselect_bypass(struct i2c_mux_core *muxc, u32 chan_id)
>>  {
>> -	struct i2c_client *client = mux_priv;
>> +	struct i2c_client *client = i2c_mux_priv(muxc);
>>  	struct iio_dev *indio_dev = dev_get_drvdata(&client->dev);

...and here too...

>>  	struct inv_mpu6050_state *st = iio_priv(indio_dev);
>>  
>> @@ -136,16 +133,15 @@ static int inv_mpu_probe(struct i2c_client *client,
>>  		return result;
>>  
>>  	st = iio_priv(dev_get_drvdata(&client->dev));
>> -	st->mux_adapter = i2c_add_mux_adapter(client->adapter,
>> -					      &client->dev,
>> -					      client,
>> -					      0, 0, 0,
>> -					      inv_mpu6050_select_bypass,
>> -					      inv_mpu6050_deselect_bypass);
>> -	if (!st->mux_adapter) {
>> -		result = -ENODEV;
>> +	st->muxc = i2c_mux_one_adapter(client->adapter, &client->dev, 0, 0,
>> +				       0, 0, 0,
>> +				       inv_mpu6050_select_bypass,
>> +				       inv_mpu6050_deselect_bypass);
>> +	if (IS_ERR(st->muxc)) {
>> +		result = PTR_ERR(st->muxc);
>>  		goto out_unreg_device;
>>  	}
>> +	st->muxc->priv = client;
>>  
>>  	result = inv_mpu_acpi_create_mux_client(client);
>>  	if (result)
>> @@ -154,7 +150,7 @@ static int inv_mpu_probe(struct i2c_client *client,
>>  	return 0;
>>  
>>  out_del_mux:
>> -	i2c_del_mux_adapter(st->mux_adapter);
>> +	i2c_mux_del_adapters(st->muxc);
>>  out_unreg_device:
>>  	inv_mpu_core_remove(&client->dev);
>>  	return result;
>> @@ -162,11 +158,11 @@ out_unreg_device:
>>  
>>  static int inv_mpu_remove(struct i2c_client *client)
>>  {
>> -	struct iio_dev *indio_dev = i2c_get_clientdata(client);
>> +	struct iio_dev *indio_dev = dev_get_drvdata(&client->dev);
> Why this change?  Seems unrelated.

...which is why I made this change. Maybe a bad call, but the inconsistency
disturbed me and I was changing the function anyway. I could split it out
to its own commit I suppose, or should I just not bother at all?

Cheers,
Peter

>>  	struct inv_mpu6050_state *st = iio_priv(indio_dev);
>>  
>>  	inv_mpu_acpi_delete_mux_client(client);
>> -	i2c_del_mux_adapter(st->mux_adapter);
>> +	i2c_mux_del_adapters(st->muxc);
>>  
>>  	return inv_mpu_core_remove(&client->dev);
>>  }
>> diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
>> index e302a49703bf..bb3cef6d7059 100644
>> --- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
>> +++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
>> @@ -11,6 +11,7 @@
>>  * GNU General Public License for more details.
>>  */
>>  #include <linux/i2c.h>
>> +#include <linux/i2c-mux.h>
>>  #include <linux/kfifo.h>
>>  #include <linux/spinlock.h>
>>  #include <linux/iio/iio.h>
>> @@ -127,7 +128,7 @@ struct inv_mpu6050_state {
>>  	const struct inv_mpu6050_hw *hw;
>>  	enum   inv_devices chip_type;
>>  	spinlock_t time_stamp_lock;
>> -	struct i2c_adapter *mux_adapter;
>> +	struct i2c_mux_core *muxc;
>>  	struct i2c_client *mux_client;
>>  	unsigned int powerup_count;
>>  	struct inv_mpu6050_platform_data plat_data;
>>
> 

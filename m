Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-am1on0133.outbound.protection.outlook.com ([157.56.112.133]:31432
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753505AbcD1VIk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 17:08:40 -0400
Subject: Re: [PATCH v7 16/24] i2c: allow adapter drivers to override the
 adapter locking
To: Wolfram Sang <wsa@the-dreams.de>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
 <1461165484-2314-17-git-send-email-peda@axentia.se>
 <20160428205018.GA3553@katana>
CC: <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
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
	<linux-i2c@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-iio@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<devicetree@vger.kernel.org>, Peter Rosin <peda@lysator.liu.se>
From: Peter Rosin <peda@axentia.se>
Message-ID: <470abe38-ab5f-2d0a-305b-e1a3253ce5a9@axentia.se>
Date: Thu, 28 Apr 2016 23:08:26 +0200
MIME-Version: 1.0
In-Reply-To: <20160428205018.GA3553@katana>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2016-04-28 22:50, Wolfram Sang wrote:
> On Wed, Apr 20, 2016 at 05:17:56PM +0200, Peter Rosin wrote:
>> Add i2c_lock_bus() and i2c_unlock_bus(), which call the new lock_bus and
>> unlock_bus ops in the adapter. These funcs/ops take an additional flags
>> argument that indicates for what purpose the adapter is locked.
>>
>> There are two flags, I2C_LOCK_ADAPTER and I2C_LOCK_SEGMENT, but they are
>> both implemented the same. For now. Locking the adapter means that the
>> whole bus is locked, locking the segment means that only the current bus
>> segment is locked (i.e. i2c traffic on the parent side of mux is still
>> allowed even if the child side of the mux is locked.
>>
>> Also support a trylock_bus op (but no function to call it, as it is not
>> expected to be needed outside of the i2c core).
>>
>> Implement i2c_lock_adapter/i2c_unlock_adapter in terms of the new locking
>> scheme (i.e. lock with the I2C_LOCK_ADAPTER flag).
>>
>> Annotate some of the locking with explicit I2C_LOCK_SEGMENT flags.
>>
>> Signed-off-by: Peter Rosin <peda@axentia.se>
> Letting you know that I start reviewing the 2nd part of your series. Did
> the first glimpse today. Will hopefully do the in-depth part this
> weekend. One thing already:
>
>> +static void i2c_adapter_lock_bus(struct i2c_adapter *adapter, int flags)
> Shouldn't flags be unsigned?
>

Yes, obviously... I'll make that change locally and wait for the rest.

Cheers,
Peter


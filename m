Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0125.outbound.protection.outlook.com ([157.55.234.125]:13785
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750839AbcD2ElT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 00:41:19 -0400
Subject: Re: [PATCH v7 22/24] [media] rtl2832: change the i2c gate to be
 mux-locked
To: Wolfram Sang <wsa@the-dreams.de>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
 <1461165484-2314-23-git-send-email-peda@axentia.se>
 <20160428214758.GA4531@katana>
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
Message-ID: <4ae65dd6-1197-11d6-ef0a-714c0525cf3a@axentia.se>
Date: Fri, 29 Apr 2016 06:41:01 +0200
MIME-Version: 1.0
In-Reply-To: <20160428214758.GA4531@katana>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-04-28 23:47, Wolfram Sang wrote:
> On Wed, Apr 20, 2016 at 05:18:02PM +0200, Peter Rosin wrote:
>> The root i2c adapter lock is then no longer held by the i2c mux during
>> accesses behind the i2c gate, and such accesses need to take that lock
>> just like any other ordinary i2c accesses do.
>>
>> So, declare the i2c gate mux-locked, and zap the regmap overrides
>> that makes the i2c accesses unlocked and use plain old regmap
>> accesses. This also removes the need for the regmap wrappers used by
>> rtl2832_sdr, so deconvolute the code further and provide the regmap
>> handle directly instead of the wrapper functions.
>>
>> Signed-off-by: Peter Rosin <peda@axentia.se>
> Antti, I'd need some tag from you since this is not the i2c realm.
>

Antti sent this:

https://lkml.org/lkml/2016/4/20/828

and I added a Tested-by in v8

https://github.com/peda-r/i2c-mux/commit/c023584d34db7aacbc59f28386378131cfa970d2

but the patch was never sent as an email, only as part of a pull request for

https://github.com/peda-r/i2c-mux/commits/mux-core-and-locking-8

So, I think all is ok, or do you need more than Tested-by?

Cheers,
Peter

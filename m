Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:3703 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbcDUMdg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 08:33:36 -0400
From: Crestez Dan Leonard <leonard.crestez@intel.com>
Subject: Re: [PATCH v7 00/24] i2c mux cleanup and locking update
To: Peter Rosin <peda@axentia.se>, linux-kernel@vger.kernel.org
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
Cc: Wolfram Sang <wsa@the-dreams.de>, Jonathan Corbet <corbet@lwn.net>,
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
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Peter Rosin <peda@lysator.liu.se>
Message-ID: <5718C896.9070302@intel.com>
Date: Thu, 21 Apr 2016 15:33:26 +0300
MIME-Version: 1.0
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/20/2016 06:17 PM, Peter Rosin wrote:
> v7 compared to v6:
> - Removed i2c_mux_reserve_adapters, and all realloc attempts in
>   i2c_mux_add_adapter. Supply a maximum number of adapters in i2c_mux_alloc
>   instead.
> - Removed i2c_mux_one_adapter since it is was hard to use correctly, which
>   was evident from the crash in the mpu6050 driver (on a mpu9150 chip) reported
>   by Crestez Dan Leonard. Also, it didn't make things all that much simpler
>   anyway (even if used correctly).
> - Rename i2c_mux_core:adapters into i2c_mux_core:num_adapters.
> - Some grammar and spelling fixes.

I tested this new version on mpu9150 and there are no more obvious
deadlocks or crashes. The magnetometer and accel/gyro can be used at the
same time without issues.

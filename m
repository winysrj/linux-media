Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45140 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbcDUBLW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 21:11:22 -0400
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
From: Antti Palosaari <crope@iki.fi>
Message-ID: <571828A3.7090007@iki.fi>
Date: Thu, 21 Apr 2016 04:10:59 +0300
MIME-Version: 1.0
In-Reply-To: <1461165484-2314-1-git-send-email-peda@axentia.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/20/2016 06:17 PM, Peter Rosin wrote:

Retested all the previously tested + now I tested also cx231xx with 
Hauppauge 930C HD device having eeprom other mux port and demod on the 
other port.

>    [media] si2168: change the i2c gate to be mux-locked
>    [media] m88ds3103: convert to use an explicit i2c mux core
>    [media] rtl2830: convert to use an explicit i2c mux core
>    [media] rtl2832: convert to use an explicit i2c mux core
>    [media] si2168: convert to use an explicit i2c mux core
>    [media] cx231xx: convert to use an explicit i2c mux core
>    [media] rtl2832: change the i2c gate to be mux-locked
>    [media] rtl2832_sdr: get rid of empty regmap wrappers
>    [media] rtl2832: regmap is aware of lockdep, drop local locking hack

I really hope that this whole patch series will arrive asap to mainline.

regards
Antti

-- 
http://palosaari.fi/

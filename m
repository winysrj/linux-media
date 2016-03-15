Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54058 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932591AbcCORIZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 13:08:25 -0400
Subject: Re: [PATCH v4 00/18] i2c mux cleanup and locking update
To: Peter Rosin <peda@lysator.liu.se>, linux-kernel@vger.kernel.org
References: <1457044050-15230-1-git-send-email-peda@lysator.liu.se>
 <56E817AE.2090005@lysator.liu.se>
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
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
	Adriana Reus <adriana.reus@intel.com>,
	Viorel Suman <viorel.suman@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56E84178.2020204@iki.fi>
Date: Tue, 15 Mar 2016 19:08:08 +0200
MIME-Version: 1.0
In-Reply-To: <56E817AE.2090005@lysator.liu.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2016 04:09 PM, Peter Rosin wrote:

> The series will be posted again for review. This is just a heads up.
>
> v5 compared to v4:
> - Rebase on top of v4.5-rc7.
> - A new patch making me maintainer of i2c muxes (also sent separately).
> - A new file Documentation/i2c/i2c-topology that describes various muxing
>    issues.
> - Rename "i2c-controlled" muxes "self-locked" instead, as it is perfectly
>    reasonable to have i2c-controlled muxes that use the pre-existing locking
>    scheme. The pre-existing locking scheme for i2c muxes is from here on
>    called "parent-locked".
> - Rename i2c-mux.c:i2c_mux_master_xfer to __i2c_mux_master_xfer since it
>    calls __i2c_transfer, which leaves room for a new i2c_mux_master_xfer
>    that calls i2c_transfer. Similar rename shuffle for i2c_mux_smbus_xfer.
> - Use sizeof(*priv) instead of sizeof(struct i2c_mux_priv). One instance.
> - Some follow-up patches that were posted in response to v2-v4 cleaning up
>    and simplifying various i2c muxes outside drivers/i2c/, among those is
>    an unrelated cleanup patch to drivers/media/dvb-frontends/rtl2832.c that
>    I carry here since it conflicts (trivially) with this series. That
>    unrelated patch is (currently) the last patch in the series.
>
>
> The series looks like this now:
>
> The following changes since commit f6cede5b49e822ebc41a099fe41ab4989f64e2cb:
>
>    Linux 4.5-rc7 (2016-03-06 14:48:03 -0800)
>
> are available in the git repository at:
>
>    https://github.com/peda-r/i2c-mux.git mux-core-and-locking-5

I reviewed and tested these patches:

c1ef4a2 [media] rtl2832: regmap is aware of lockdep, drop local locking hack
6636178 [media] rtl2832_sdr: get rid of empty regmap wrappers
001ad6b [media] rtl2832: declare that the i2c gate is self-locked
e2e82e4 [media] si2168: declare that the i2c gate is self-locked
b52f766 [media] si2168: convert to use an explicit i2c mux core
4ba9115 [media] rtl2832: convert to use an explicit i2c mux core
3f1778b [media] rtl2830: convert to use an explicit i2c mux core
5c8bfc8 [media] m88ds3103: convert to use an explicit i2c mux core


Reviewed-by: Antti Palosaari <crope@iki.fi>
Tested-by: Antti Palosaari <crope@iki.fi>

regards
Antti

-- 
http://palosaari.fi/

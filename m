Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:42478 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbcDKNgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2016 09:36:19 -0400
Subject: Re: [PATCH v6 00/24] i2c mux cleanup and locking update
To: Wolfram Sang <wsa@the-dreams.de>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
 <20160411123959.GA4719@katana>
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
Message-ID: <570BA845.1060309@lysator.liu.se>
Date: Mon, 11 Apr 2016 15:36:05 +0200
MIME-Version: 1.0
In-Reply-To: <20160411123959.GA4719@katana>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On 2016-04-11 14:39, Wolfram Sang wrote:
> Hi Peter,
>
>> To summarize the series, there's some i2c-mux infrastructure cleanup work
>> first (I think that part stands by itself as desireable regardless), the
>> locking changes are in 16/24 and after with the real meat in 18/24. There
>> is some documentation added in 19/24 while 20/24 and after are cleanups to
>> existing drivers utilizing the new stuff.
>
> My idea is to review and pull in the infrastructure work for 4.7 and the
> locking changes to 4.8. This gives us one cycle to fix regressions (if
> any) in the infrastructure work first. Is that okay with you?

I was just thinking about how it appears impossible to get it all of it
merged in one go and what to do about it...

The untra-defensive approach is only merge stuff that has actually been
tested on real hw, and to hold off the rest until someone has tested. That
can obviously take forever. At the same time, many of the patches are kind
of mechanical, and feels rather safe.

  1 i2c-mux: add common data for every i2c-mux instance
  2 i2c: i2c-mux-gpio: convert to use an explicit i2c mux core
  3 i2c: i2c-mux-pinctrl: convert to use an explicit i2c mux core
  4 i2c: i2c-arb-gpio-challenge: convert to use an explicit i2c mux core
  5 i2c: i2c-mux-pca9541: convert to use an explicit i2c mux core
  6 i2c: i2c-mux-pca954x: convert to use an explicit i2c mux core
  7 i2c: i2c-mux-reg: convert to use an explicit i2c mux core
  8 iio: imu: inv_mpu6050: convert to use an explicit i2c mux core
  9 [media] m88ds3103: convert to use an explicit i2c mux core
10 [media] rtl2830: convert to use an explicit i2c mux core
11 [media] rtl2832: convert to use an explicit i2c mux core
12 [media] si2168: convert to use an explicit i2c mux core
13 [media] cx231xx: convert to use an explicit i2c mux core
14 of/unittest: convert to use an explicit i2c mux core
15 i2c-mux: drop old unused i2c-mux api
16 i2c: allow adapter drivers to override the adapter locking
17 i2c: muxes always lock the parent adapter
18 i2c-mux: relax locking of the top i2c adapter during mux-locked muxing
19 i2c-mux: document i2c muxes and elaborate on parent-/mux-locked muxes
20 iio: imu: inv_mpu6050: change the i2c gate to be mux-locked
21 [media] si2168: change the i2c gate to be mux-locked
22 [media] rtl2832: change the i2c gate to be mux-locked
23 [media] rtl2832_sdr: get rid of empty regmap wrappers
24 [media] rtl2832: regmap is aware of lockdep, drop local locking hack

I have tested 1, 2, 14, 16, 17 and 18 on real hw.
Antti has tested 9, 10, 11, 12, 16, 17, 21, 22, 23 and 24, but they
have been rebased since and 22 in particular is not a pure rebase since
the driver moved underneath me. And the locking was not 100% the same
either, not that I expect things to have gone south, but...
15 is a functional no-op once 2-14 are merged.
19 is docs only.
Jonathan acked 8 and 20, but 20 needs a tested-by from Daniel Baluta
and/or Adriana Reus.

That leaves 3, 4, 5, 6, 7, 13, but all those fall in the mechanical
category, with the possible exception of 13 which is more complex
than the other patches in the 2-14 range. But 13 builds, and besides,
what can possibly go wrong with a patch with that number? :-)

IIUC, your suggestion is to push 1-15 for 4.7, i.e. hope for the best
with 3, 4, 5, 6, 7 and 13. And then hopefully get testing for 20, and
retesting for 21, 22, 23 and 24 and merge 16-24 for 4.8.

That seems like a good plan to me.

Maybe we should give Antti some more time to re-add his tested-by tags
on 9-12 before they are merged into non-rewritable branches?

Cheers,
Peter

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0128.outbound.protection.outlook.com ([157.55.234.128]:34848
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751696AbcDVHyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 03:54:20 -0400
From: Peter Rosin <peda@axentia.se>
To: Wolfram Sang <wsa@the-dreams.de>, Peter Rosin <peda@axentia.se>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Jonathan Corbet" <corbet@lwn.net>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	"Guenter Roeck" <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	"Hartmut Knaack" <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	"Peter Meerwald" <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	"Frank Rowand" <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Kalle Valo" <kvalo@codeaurora.org>, Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>,
	"Arnd Bergmann" <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	"Crestez Dan Leonard" <leonard.crestez@intel.com>,
	"linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Peter Rosin <peda@lysator.liu.se>
Subject: Re: [PATCH v7 00/24] i2c mux cleanup and locking update
Date: Fri, 22 Apr 2016 07:54:12 +0000
Message-ID: <AM4PR02MB1299DD7DBCE30E8EFE9E1259BC6F0@AM4PR02MB1299.eurprd02.prod.outlook.com>
Content-Language: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wolfram,

Wolfram Sang wrote:
> This was the diff of v6:
> 
> >  32 files changed, 1277 insertions(+), 915 deletions(-)
> 
> This is v7:
> 
> >  32 files changed, 1225 insertions(+), 916 deletions(-)
> 
> So, we gained a little overall. And while the individual drivers have a
> few lines more now, I still think it is more readable.
> 
> So, thanks for doing that!

Most, if not all, of these ~50 lines gained in v7 come from removing
i2c_mux_reserve_adapters and realloc. I.e., I think we might even have
lost a few lines with the i2c_mux_one_adapter removal, but not that many.
If the doc patch is taken out of the equation, we gain new functionality,
fix a bug and lose lines of code. Feels good!
However, this is not why I'm writing this message...

> I'll give people some time for testing. I'll have a further look, too.
> Hopefully, I can pick up patches 1-14 by the end of the week.

The reason for this message is that I just realized a couple of things.

First, you have suggested to merge patches 1-14 about now, and I assumed
that implied merging with Linus for 4.6, but on rereading I realize that
you have consistently targeted 4.7. I must be sloppy, and that had escaped
me. Is it really necessary to be that cautious? Maybe I'm overly confident,
but is 1-14 really such a big deal that it has to float in next for a whole
cycle?

The problem with waiting until 4.8 with the rest of the series is that it
will likely go stale, e.g. patch 22 ([media] rtl2832: change the i2c gate
to be mux-locked) touches a ton of register accesses in that driver since
it removes a regmap wrapper that is rendered obsolete. Expecting that
patch to work for 4.8 is overly optimistic, and while patching things up
is (probably) easy, it also renders any previous testing suspect.

That said, maybe I'm just impatient and reckless?

Second, should we not add 15-24 to the next branch now as well to get
testing going asap, even if we do not intend to merge it just yet or even
in that exact form? Or is that abusing the next branch?

Third, should we deprecate the old i2c_add_mux_adapter, so that new
users do not crop up behind our backs in the transition? Or not bother?

Fourth, I forgot to change patch 8 (iio: imu: inv_mpu6050: convert to
use an explicit i2c mux core) to not change i2c_get_clientdata() ->
dev_get_drvdata() as requested by Jonathan Cameron. How should I handle
that? There are also some new Tested-by tags that I have added to my
local branch but have not pushed anywhere. I'm ready to push all that
to a new branch once you are ready to take it.

Cheers,
Peter

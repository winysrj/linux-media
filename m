Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54221 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086AbcEBTUl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2016 15:20:41 -0400
Subject: Re: [PATCH v7 16/24] i2c: allow adapter drivers to override the
 adapter locking
To: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
 <1461165484-2314-17-git-send-email-peda@axentia.se>
 <20160428205018.GA3553@katana>
 <470abe38-ab5f-2d0a-305b-e1a3253ce5a9@axentia.se>
 <20160429071604.GB1870@katana>
 <357e6fda-73b3-fb7f-c341-97f09af1943f@axentia.se>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
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
Message-ID: <5727A873.4080400@iki.fi>
Date: Mon, 2 May 2016 22:20:19 +0300
MIME-Version: 1.0
In-Reply-To: <357e6fda-73b3-fb7f-c341-97f09af1943f@axentia.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/29/2016 12:16 PM, Peter Rosin wrote:
> On 2016-04-29 09:16, Wolfram Sang wrote:
>>> Yes, obviously... I'll make that change locally and wait for the rest.
>> Another nit: You could use '--strict' with checkpatch and see if you
>> want to fix the issues reported. I am not keen on those (except for
>> 'space around operators'), it's a matter of taste I guess, but maybe you
>> like some of the suggestions.
>>
> Yes, they look like reasonable complaints.
>
> So, I fixed all of them locally except the complaint about lack of comment
> on the new struct mutex member in struct si2168_dev (patch 21/24),
> because that patch is Anttis and he's the maintainer of that driver...
>
> Antti, if you want that fixed as part of this series, send a suitable comment
> for the mutex this way and I'll incorporate it.

Ah, I never ran checkpatch with --strict option...

CHECK: struct mutex definition without comment
#202: FILE: drivers/media/dvb-frontends/si2168_priv.h:32:
+	struct mutex i2c_mutex;

If you wish you could add some comment for it, but for me it is still 
pretty much self explaining. It is lock to protect firmware command 
execution. Command is executed always with I2C write and then poll reply 
using I2C read until it timeouts or answers with "ready" status.

regards
Antti

-- 
http://palosaari.fi/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db3on0133.outbound.protection.outlook.com ([157.55.234.133]:14412
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750911AbcEDOLF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 10:11:05 -0400
Subject: Re: [PATCH v7 16/24] i2c: allow adapter drivers to override the
 adapter locking
To: Wolfram Sang <wsa@the-dreams.de>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
 <1461165484-2314-17-git-send-email-peda@axentia.se>
 <20160428205018.GA3553@katana>
 <470abe38-ab5f-2d0a-305b-e1a3253ce5a9@axentia.se>
 <20160429071604.GB1870@katana>
 <357e6fda-73b3-fb7f-c341-97f09af1943f@axentia.se>
 <20160503213908.GC2018@tetsubishi>
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
Message-ID: <87de4033-3b58-3ef6-d22b-b90901885b39@axentia.se>
Date: Wed, 4 May 2016 16:10:49 +0200
MIME-Version: 1.0
In-Reply-To: <20160503213908.GC2018@tetsubishi>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2016-05-03 23:39, Wolfram Sang wrote:
>> Yes, they look like reasonable complaints.
> 
> Thanks for fixing them. I just sent out my latest comments and when you
> fix those and send V8, I'll apply that right away. I think we are safe
> to fix the rest incrementally if needed. Note that I didn't review the

Sounds like a plan.

> IIO and media patches, I trust the reviewers on those.
> 
> Thanks for your work on this! I need a break now, this is
> mind-boggling...

And thanks for reviewing it!

A question on best practices here... I already did a v8 (but only as
a branch) so I think this will be v9, bit that's a minor detail. The
real question is what I should do about patches 1-15 that are already
in next? Send them too? If not, should I send 16-24 with the same old
patch numbers or should they be numbered 1-9 now? And should such a
shortened series be rebased on 1-15 in next?

Or does it not really matter?

Cheers,
Peter

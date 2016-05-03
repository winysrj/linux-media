Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:40771 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbcECVjZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2016 17:39:25 -0400
Date: Tue, 3 May 2016 23:39:08 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@axentia.se>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
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
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Peter Rosin <peda@lysator.liu.se>
Subject: Re: [PATCH v7 16/24] i2c: allow adapter drivers to override the
 adapter locking
Message-ID: <20160503213908.GC2018@tetsubishi>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
 <1461165484-2314-17-git-send-email-peda@axentia.se>
 <20160428205018.GA3553@katana>
 <470abe38-ab5f-2d0a-305b-e1a3253ce5a9@axentia.se>
 <20160429071604.GB1870@katana>
 <357e6fda-73b3-fb7f-c341-97f09af1943f@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <357e6fda-73b3-fb7f-c341-97f09af1943f@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Yes, they look like reasonable complaints.

Thanks for fixing them. I just sent out my latest comments and when you
fix those and send V8, I'll apply that right away. I think we are safe
to fix the rest incrementally if needed. Note that I didn't review the
IIO and media patches, I trust the reviewers on those.

Thanks for your work on this! I need a break now, this is
mind-boggling...


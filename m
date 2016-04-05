Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:51386 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbcDEHui (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2016 03:50:38 -0400
Message-ID: <57036E48.9080404@lysator.liu.se>
Date: Tue, 05 Apr 2016 09:50:32 +0200
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org
CC: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
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
Subject: Re: [PATCH v6 19/24] i2c-mux: document i2c muxes and elaborate on
 parent-/mux-locked muxes
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se> <1459673574-11440-20-git-send-email-peda@lysator.liu.se> <5700F9DA.1040501@kernel.org>
In-Reply-To: <5700F9DA.1040501@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-04-03 13:09, Jonathan Cameron wrote:
> On 03/04/16 09:52, Peter Rosin wrote:
>> From: Peter Rosin <peda@axentia.se>
>>
>> Signed-off-by: Peter Rosin <peda@axentia.se>
> Very nice, one typo that I could see.

Thanks!

*snip*

>> +     and the actual transfer (e.g. if the child mux is auto-closing
>> +     and the parent mux issus i2c-transfers as part of its select).
>> +     This is especailly the case if the parent mux is mux-locked, but
> especially

Fixed now in my local repo.

Cheers,
Peter

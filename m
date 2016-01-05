Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:55254 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbcAETB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 14:01:59 -0500
Message-ID: <568C131F.3040703@lysator.liu.se>
Date: Tue, 05 Jan 2016 20:01:51 +0100
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Peter Rosin <peda@axentia.se>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Adriana Reus <adriana.reus@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Olli Salonen <olli.salonen@iki.fi>, linux-i2c@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/8] i2c mux cleanup and locking update
References: <1452009438-27347-1-git-send-email-peda@lysator.liu.se> <20160105184819.GA1743@katana>
In-Reply-To: <20160105184819.GA1743@katana>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wolfram,

On 2016-01-05 19:48, Wolfram Sang wrote:
> Peter,
> 
>> PS. needs a bunch of testing, I do not have access to all the involved hw
> 
> First of all, thanks for diving into this topic and the huge effort you
> apparently have put into it.

Yeah, I started with dipping just the toes, but now it rather feels like
I'm fully submerged at the deep end...

> It is obviously a quite intrusive series, so it needs careful review.
> TBH, I can't really tell when I have the bandwidth to do that, so I hope
> other people will step up. And yes, it needs serious testing.
> 
> To all: Although I appreciate any review support, I'd think the first
> thing to be done should be a very high level review - is this series
> worth the huge update? Is the path chosen proper? Stuff like this. I'd
> appreciate Acks or Revs for that. Stuff like fixing checkpatch warnings
> and other minor stuff should come later.

Right, I'll hold back on sending updates for trivial stuff until the
big picture stuff has been cleared.

Cheers,
Peter

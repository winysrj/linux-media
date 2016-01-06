Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35435 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbcAFNXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2016 08:23:43 -0500
Received: by mail-lb0-f175.google.com with SMTP id bc4so190264239lbc.2
        for <linux-media@vger.kernel.org>; Wed, 06 Jan 2016 05:23:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160105184819.GA1743@katana>
References: <1452009438-27347-1-git-send-email-peda@lysator.liu.se> <20160105184819.GA1743@katana>
From: Crt Mori <cmo@melexis.com>
Date: Wed, 6 Jan 2016 14:23:02 +0100
Message-ID: <CAKv63uvvdjmQj3J73UJZFLJ=U0c+Z=dmknm3UH=3MvYU0oqNNg@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] i2c mux cleanup and locking update
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Peter Rosin <peda@lysator.liu.se>, Peter Rosin <peda@axentia.se>,
	Rob Herring <robh+dt@kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wolfram and Peter,
I will give my opinion about the path chosen although it should be
taken lightly.

I can see that hardware guys missed the software guys again on the
development path, but since this happens more often than not, I would
say it seems OK to have support for this as long as it does not make
more complex (longer) standard i2c transfers. I would support to have
additional mutex before mux as that will make less chance that someone
forgets to lock mutex before mux and proposed solution seems valid.

Regards,
Crt

On 5 January 2016 at 19:48, Wolfram Sang <wsa@the-dreams.de> wrote:
> Peter,
>
>> PS. needs a bunch of testing, I do not have access to all the involved hw
>
> First of all, thanks for diving into this topic and the huge effort you
> apparently have put into it.
>
> It is obviously a quite intrusive series, so it needs careful review.
> TBH, I can't really tell when I have the bandwidth to do that, so I hope
> other people will step up. And yes, it needs serious testing.
>
> To all: Although I appreciate any review support, I'd think the first
> thing to be done should be a very high level review - is this series
> worth the huge update? Is the path chosen proper? Stuff like this. I'd
> appreciate Acks or Revs for that. Stuff like fixing checkpatch warnings
> and other minor stuff should come later.
>
> Thanks,
>
>    Wolfram
>

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:35415 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbcAGIVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jan 2016 03:21:44 -0500
Message-ID: <568E2010.4000202@lysator.liu.se>
Date: Thu, 07 Jan 2016 09:21:36 +0100
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: Rob Herring <robh@kernel.org>
CC: Wolfram Sang <wsa@the-dreams.de>, Peter Rosin <peda@axentia.se>,
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
Subject: Re: [PATCH v2 8/8] i2c-mux: relax locking of the top i2c adapter
 during i2c controlled muxing
References: <1452009438-27347-1-git-send-email-peda@lysator.liu.se> <1452009438-27347-9-git-send-email-peda@lysator.liu.se> <20160106144947.GA13257@rob-hp-laptop>
In-Reply-To: <20160106144947.GA13257@rob-hp-laptop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On 2016-01-06 15:49, Rob Herring wrote:
> On Tue, Jan 05, 2016 at 04:57:18PM +0100, Peter Rosin wrote:
>> From: Peter Rosin <peda@axentia.se>
>>
>> With a i2c topology like the following
>>
>>                        GPIO ---|  ------ BAT1
>>                         |      v /
>>    I2C  -----+----------+---- MUX
>>              |                   \
>>            EEPROM                 ------ BAT2
> 
> Yuck. One would think you would just use an I2C controlled mux in this 
> case...
>  
>> there is a locking problem with the GPIO controller since it is a client
>> on the same i2c bus that it muxes. Transfers to the mux clients (e.g. BAT1)
>> will lock the whole i2c bus prior to attempting to switch the mux to the
>> correct i2c segment. In the above case, the GPIO device is an I/O expander
>> with an i2c interface, and since the GPIO subsystem knows nothing (and
>> rightfully so) about the lockless needs of the i2c mux code, this results
>> in a deadlock when the GPIO driver issues i2c transfers to modify the
>> mux.
>>
>> So, observing that while it is needed to have the i2c bus locked during the
>> actual MUX update in order to avoid random garbage on the slave side, it
>> is not strictly a must to have it locked over the whole sequence of a full
>> select-transfer-deselect mux client operation. The mux itself needs to be
>> locked, so transfers to clients behind the mux are serialized, and the mux
>> needs to be stable during all i2c traffic (otherwise individual mux slave
>> segments might see garbage, or worse).
>>
>> Add devive tree properties (bool named i2c-controlled) to i2c-mux-gpio and
>> i2c-mux-pinctrl that asserts that the the gpio/pinctrl is controlled via
>> the same i2c bus that it muxes.
> 
> Can't you determine this condition by checking the mux parent and gpio 
> parent are the same i2c controller?

Good suggestion, I wrote code that implements this, and will include it in
v3. Do not expect v3 to hit the dt crowd though, since no dt changes will
be needed then, but I'm sure that is not a problem...

> Alternatively, can't you just always do the locking like i2c-controlled 
> is set when a mux is involved? What is the harm in doing that if the 
> GPIO is controlled somewhere else?

No, that is not possible. If you change a non-i2c-controlled gpio in the
middle of some i2c-access, the slave side of the mux might see partial
i2c transfers, and that is a recipe for disaster.

> I would prefer to see a solution not requiring DT updates to fix and 
> this change seems like it is working around kernel issues.

Right, I'll make it so.

Cheers,
Peter

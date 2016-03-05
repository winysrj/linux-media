Return-path: <linux-media-owner@vger.kernel.org>
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:56817 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbcCERtC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2016 12:49:02 -0500
Subject: Re: [PATCH v3 0/8] i2c mux cleanup and locking update
To: Wolfram Sang <wsa@the-dreams.de>, Peter Rosin <peda@lysator.liu.se>
References: <1452265496-22475-1-git-send-email-peda@lysator.liu.se>
 <20160302172904.GC5439@katana>
Cc: Peter Rosin <peda@axentia.se>,
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
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Olli Salonen <olli.salonen@iki.fi>, linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
From: Jonathan Cameron <jic23@kernel.org>
Message-ID: <56DB1C07.4040008@kernel.org>
Date: Sat, 5 Mar 2016 17:48:55 +0000
MIME-Version: 1.0
In-Reply-To: <20160302172904.GC5439@katana>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/03/16 17:29, Wolfram Sang wrote:
> On Fri, Jan 08, 2016 at 04:04:48PM +0100, Peter Rosin wrote:
>> From: Peter Rosin <peda@axentia.se>
>>
>> Hi!
>>
>> [doing a v3 even if there is no "big picture" feedback yet, but
>>  previous versions has bugs that make them harder to test than
>>  needed, and testing is very much desired]
>>
>> I have a pair of boards with this i2c topology:
>>
>>                        GPIO ---|  ------ BAT1
>>                         |      v /
>>    I2C  -----+------B---+---- MUX
>>              |                   \
>>            EEPROM                 ------ BAT2
>>
>> 	(B denotes the boundary between the boards)
>>
>> The problem with this is that the GPIO controller sits on the same i2c bus
>> that it MUXes. For pca954x devices this is worked around by using unlocked
>> transfers when updating the MUX. I have no such luck as the GPIO is a general
>> purpose IO expander and the MUX is just a random bidirectional MUX, unaware
>> of the fact that it is muxing an i2c bus, and extending unlocked transfers
>> into the GPIO subsystem is too ugly to even think about. But the general hw
>> approach is sane in my opinion, with the number of connections between the
>> two boards minimized. To put is plainly, I need support for it.
>>
>> So, I observe that while it is needed to have the i2c bus locked during the
>> actual MUX update in order to avoid random garbage on the slave side, it
>> is not strictly a must to have it locked over the whole sequence of a full
>> select-transfer-deselect operation. The MUX itself needs to be locked, so
>> transfers to clients behind the mux are serialized, and the MUX needs to be
>> stable during all i2c traffic (otherwise individual mux slave segments
>> might see garbage).
>>
>> This series accomplishes this by adding code to i2c-mux-gpio and
>> i2c-mux-pinctrl that determines if all involved devices used to update the
>> mux are controlled by the same root i2c adapter that is muxed. When this
>> is the case, the select-transfer-deselect operations should be locked
>> individually to avoid the deadlock. The i2c bus *is* still locked
>> during muxing, since the muxing happens as part of i2c transfers. This
>> is true even if the MUX is updated with several transfers to the GPIO (at
>> least as long as *all* MUX changes are using the i2s master bus). A lock
>> is added to the mux so that transfers through the mux are serialized.
>>
>> Concerns:
>> - The locking is perhaps too complex?
>> - I worry about the priority inheritance aspect of the adapter lock. When
>>   the transfers behind the mux are divided into select-transfer-deselect all
>>   locked individually, low priority transfers get more chances to interfere
>>   with high priority transfers.
>> - When doing an i2c_transfer() in_atomic() context or with irqs_disabled(),
>>   there is a higher possibility that the mux is not returned to its idle
>>   state after a failed (-EAGAIN) transfer due to trylock.
>> - Is the detection of i2c-controlled gpios and pinctrls sane (i.e. the
>>   usage of the new i2c_root_adapter() function in 8/8)?
>>
>> To summarize the series, there's some i2c-mux infrastructure cleanup work
>> first (I think that part stands by itself as desireable regardless), the
>> locking changes are in the last three patches of the series, with the real
>> meat in 8/8.
>>
>> PS. needs a bunch of testing, I do not have access to all the involved hw
> 
> I want to let you know that I am currently thinking about this series.
> 
> There seems to be a second occasion where it could have helped AFAICT.
> http://patchwork.ozlabs.org/patch/584776/ (check my comments there from
> yesterday and today)
> 
> First of all, really thank you that you tried to find the proper
> solution and went all the way for it. It is easy to do a fire&forget
> hack here, but you didn't.
> 
> I hope you understand, though, that I need to make a balance between
> features and complexity in my subsystem to have maintainable and stable
> code.
> 
> As I wrote in the mentioned thread already: "However, I am still
> undecided if that series should go upstream because it makes the mux
> code another magnitude more complex. And while this seems to be the
> second issue which could be fixed by that series, both issues seem to
> be corner cases, so I am not sure it is worth the complexity."
> 
> And for the cleanup series using struct mux_core. It is quite an
> intrusive change and, frankly, the savings look surprisingly low. I
> would have expected more, but you never find out until you do it. So, I
> am unsure here as well.
> 
> I am not decided and open for discussion. This is just where we are
> currently. All interested parties, I am looking forward to more
> thoughts.
> 
> Thanks,
Perhaps it's one to let sit into at least the next cycle (and get some testing
on those media devices if we can) but, whilst it is fiddly the gains seen in
individual drivers (like the example Peter put in response to the V4 series)
make it look worthwhile to me.  Also, whilst the invensense part is plain odd
in many ways, the case Peter had looks rather more normal.

At the end of the day, sometimes fiddly problems need fiddly code. 
(says a guy who doesn't have to maintain it!)

It certainly helps that Peter has done a thorough job, broken the patches
up cleanly and provided clean descriptions of what he is doing.

Jonathan
> 
>    Wolfram
> 


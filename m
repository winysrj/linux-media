Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:36280 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbcCGIjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 03:39:06 -0500
Message-ID: <56DD3E1E.5040003@lysator.liu.se>
Date: Mon, 07 Mar 2016 09:38:54 +0100
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>,
	Jonathan Cameron <jic23@kernel.org>
CC: Peter Rosin <peda@axentia.se>,
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
Subject: Re: [PATCH v3 0/8] i2c mux cleanup and locking update
References: <1452265496-22475-1-git-send-email-peda@lysator.liu.se> <20160302172904.GC5439@katana> <56DB1C07.4040008@kernel.org> <20160305182934.GA1394@katana>
In-Reply-To: <20160305182934.GA1394@katana>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-03-05 19:29, Wolfram Sang wrote:
> 
>> Perhaps it's one to let sit into at least the next cycle (and get some testing
>> on those media devices if we can) but, whilst it is fiddly the gains seen in
>> individual drivers (like the example Peter put in response to the V4 series)
>> make it look worthwhile to me.  Also, whilst the invensense part is plain odd
>> in many ways, the case Peter had looks rather more normal.
>>
>> At the end of the day, sometimes fiddly problems need fiddly code. 
>> (says a guy who doesn't have to maintain it!)
>>
>> It certainly helps that Peter has done a thorough job, broken the patches
>> up cleanly and provided clean descriptions of what he is doing.
> 
> Yes, Peter has done a great job so far and the latest results were very
> convincing (fixing the invensense issue and the savings for rtl2832).
> 
> And yes, I am reluctant to maintain this code alone, so my question
> would be:
> 
> Peter, are you interested in becoming the i2c-mux maintainer and look
> after the code even after it was merged? (From "you reviewing patches and
> me picking them up" to "you have your own branch which I pull", we can
> discuss the best workflow.)

My code wouldn't be worth much if I didn't offer to look after it myself. On
the other hand, I am also reluctant to be the go-to person for all things
i2c-mux, as I don't have a clear picture of how much work it's going to be.
My offer is going to be this, I'll look after any unforeseen future problems
caused by this rework, and I can be the i2c-mux maintainer. But if being
the i2c-mux maintainer turns out to be a huge time-sink, there is no way I
can stay on in the long run. But I guess that is the same for any maintainer
(whose job description does not explicitly include being maintainer).

> If that would be the case, I have the same idea like Jonathan: Give it
> another cycle for more review & test and aim for the 4.7 merge window.

Yes, sounds good. One of the reasons for doing things right (or at least
trying to) is to have more people look at the work. *I* think it's good,
but more eyes can't hurt.

> I have to admit that I still haven't done a more thorough review, so I
> can't say if I see a show-stopper in this series. Yet, even if so I am
> positive it can be sorted out. Oh, and we should call for people with
> special experience in locking.
> 
> What do people think?
> 
> Regards,
> 
>    Wolfram
> 
> PS: Peter, have you seen my demuxer driver in my for-next branch? I hope
> it won't spoil your design?

I had a brief look, and I can't see anything in the demux that's affected by
the mux update. The main commonality of the demux and the preexisting muxes
seems to be that the name includes "mux" and that it is all about i2c. Agreed?

In short, I see no problems.

Cheers,
Peter

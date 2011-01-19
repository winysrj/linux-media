Return-path: <mchehab@pedra>
Received: from mout.perfora.net ([74.208.4.195]:50379 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab1ASTCc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 14:02:32 -0500
Message-ID: <4D373501.2010301@vorgon.com>
Date: Wed, 19 Jan 2011 12:01:21 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DViCO FusionHDTV7 Dual Express I2C write failed
References: <20101207190753.GA21666@io.frii.com>	<20110110021439.GA70495@io.frii.com>	<AANLkTingFP9ajGckXXy2wScHHGxhz+KTyOBa-mE7SUs5@mail.gmail.com> <AANLkTi=59dytuN25H3DVRrPAB8GAcn6N88Ji_dkorsGB@mail.gmail.com>
In-Reply-To: <AANLkTi=59dytuN25H3DVRrPAB8GAcn6N88Ji_dkorsGB@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

So what would a "mainstream" dual (or more) tuner card be? I've found 
these Fusions to be flaky. Had one die and another went flaky when I 
enabled the sleep mode. Can't really afford any more now, but am always 
watching. A company called Ceton seems to havea  quad, but it's a cable 
card tuner costing $450.

On 1/19/2011 9:13 AM, Devin Heitmueller wrote:
> On Wed, Jan 19, 2011 at 10:59 AM, VDR User<user.vdr@gmail.com>  wrote:
>> Can someone please look into this and possibly provide a fix for the
>> bug?  I'm surprised it hasn't happened yet after all this time but
>> maybe it's been forgotten the bug existed.
>
> You shouldn't be too surprised.  In many cases device support for more
> obscure products comes not from the maintainer of the actual driver
> but rather from some random user who hacked in an additional board
> profile (in many cases, not doing it correctly but good enough so it
> "works for them").  In cases like that, the changes get committed, the
> original submitter disappears, and then when things break there is
> nobody with the appropriate knowledge and the hardware to debug the
> problem.
>
> Devin
>

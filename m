Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54577 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbaLHRqP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 12:46:15 -0500
Message-ID: <5485E3E4.80005@iki.fi>
Date: Mon, 08 Dec 2014 19:46:12 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] mn88472: fix firmware loading
References: <1417990203-758-1-git-send-email-benjamin@southpole.se> <1417990203-758-2-git-send-email-benjamin@southpole.se> <5484D666.6060605@iki.fi> <5485CC0E.2090201@southpole.se>
In-Reply-To: <5485CC0E.2090201@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 12/08/2014 06:04 PM, Benjamin Larsson wrote:
> On 12/07/2014 11:36 PM, Antti Palosaari wrote:
>> On 12/08/2014 12:10 AM, Benjamin Larsson wrote:
>>> The firmware must be loaded one byte at a time via the 0xf6 register.
>>
>> I don't think so. Currently it downloads firmware in 22 byte chunks
>> and it seems to work, at least for me, both mn88472 and mn88473.
>
> Ok, I have now tried the driver with my defaults patch in and with your
> method of loading the firmware and my patch. I have my antenna placed in
> a bad location with bad reception. With my patch I am getting data from
> the device, without my patch I am not. So whatever my code does it makes
> the device more sensitive.
>
> And then there is this comment in the regmap code:
>
> regmap_bulk_write(): Write multiple registers to the device
>
> In this case we want to write multiple bytes to the same register. So I
> think that my patch is correct in principle.

You haven't make any test whether it is possible to write that firmware 
in a large chunks *or* writing one byte (smallest possible ~chuck) at 
the time? I think it does not matter. I suspect you could even download 
whole firmware as one go - but rtl2832p I2C adapter does support only 22 
bytes on one xfer.

Even those are written to one register, chip knows how many bytes one 
message has and could increase its internal address counter. That is 
usually called register address auto-increment.

A) writing:
f6 00
f6 01
f6 02
f6 03
f6 04
f6 05
f6 06
f6 07
f6 08
f6 09

B) writing:
f6 00 01 02 03 04
f6 05 06 07 08 09

will likely end up same. B is better as only 2 xfers are done - much 
less IO.

regards
Antti

-- 
http://palosaari.fi/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35262 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957AbaLHRff (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 12:35:35 -0500
Message-ID: <5485E165.2040506@iki.fi>
Date: Mon, 08 Dec 2014 19:35:33 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] mn88472: fix firmware loading
References: <1417990203-758-1-git-send-email-benjamin@southpole.se> <1417990203-758-2-git-send-email-benjamin@southpole.se> <5484D666.6060605@iki.fi> <548587AA.80200@southpole.se>
In-Reply-To: <548587AA.80200@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 12/08/2014 01:12 PM, Benjamin Larsson wrote:
> On 12/07/2014 11:36 PM, Antti Palosaari wrote:
>> On 12/08/2014 12:10 AM, Benjamin Larsson wrote:
>>> The firmware must be loaded one byte at a time via the 0xf6 register.
>>
>> I don't think so. Currently it downloads firmware in 22 byte chunks
>> and it seems to work, at least for me, both mn88472 and mn88473.
>
> With both these changes I get much better sensitivity. So something is
> better then before. I will track down the needed changes and respin the
> patches.

I suspect it is that initialization of all registers which has something 
to do with sensitivity. I haven't tested if firmware uploading is 
critical, what happens when some byte is skipped or so...

Did you saw there is config parameter i2c_wr_max? Setting it to '1' does 
same what that your patch did, but leaves amount of max I2C bytes 
configurable...

Anyhow, good finding, which needs to be track down.

regards
Antti

-- 
http://palosaari.fi/

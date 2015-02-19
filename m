Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52584 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbbBSPif (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 10:38:35 -0500
Message-ID: <54E60378.6030604@iki.fi>
Date: Thu, 19 Feb 2015 17:38:32 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>,
	Benjamin Larsson <benjamin@southpole.se>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] mn88472: reduce firmware download chunk size
References: <1424337200-6446-1-git-send-email-a.seppala@gmail.com>	<54E5B028.5080900@southpole.se> <CAKv9HNaSqgFpC+TmMm86Y7mrgXvZ9U+wqdgjM4n=hf80p2W1jg@mail.gmail.com>
In-Reply-To: <CAKv9HNaSqgFpC+TmMm86Y7mrgXvZ9U+wqdgjM4n=hf80p2W1jg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/19/2015 12:21 PM, Antti Seppälä wrote:
> On 19 February 2015 at 11:43, Benjamin Larsson <benjamin@southpole.se> wrote:
>> On 2015-02-19 10:13, Antti Seppälä wrote:
>>>
>>> It seems that currently the firmware download on the mn88472 is
>>> somehow wrong for my Astrometa HD-901T2.
>>>
>>> Reducing the download chunk size (mn88472_config.i2c_wr_max) to 2
>>> makes the firmware download consistently succeed.
>>>
>>
>>
>> Hi, try adding the workaround patch I sent for this.
>>
>> [PATCH 1/3] rtl28xxu: lower the rc poll time to mitigate i2c transfer errors
>>
>> I now see that it hasn't been merged. But I have been running with this
>> patch for a few months now without any major issues.
>>
>
> The patch really did improve firmware loading. Weird...
>
> Even with it I still get occasional i2c errors from r820t:
>
> [   15.874402] r820t 8-003a: r820t_write: i2c wr failed=-32 reg=0a len=1: da
> [   81.455517] r820t 8-003a: r820t_read: i2c rd failed=-32 reg=00
> len=4: 69 74 e6 df
> [   99.949702] r820t 8-003a: r820t_read: i2c rd failed=-32 reg=00
> len=4: 69 74 e6 df
>
> These errors seem to appear more often if I'm reading the signal
> strength values using e.g. femon.

Could you disable whole IR polling and test
modprobe dvb_usb_v2 disable_rc_polling=1

It is funny that *increasing* RC polling makes things better, though...

regards
Antti
-- 
http://palosaari.fi/

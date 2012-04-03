Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58811 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab2DCPlR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 11:41:17 -0400
Message-ID: <4F7B1A1A.5000007@iki.fi>
Date: Tue, 03 Apr 2012 18:41:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] fc0011: Reduce number of retries
References: <20120403110503.392c8432@milhouse> <4F7B1624.8020401@iki.fi> <20120403173320.2d3df3f8@milhouse>
In-Reply-To: <20120403173320.2d3df3f8@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.04.2012 18:33, Michael Büsch wrote:
> On Tue, 03 Apr 2012 18:24:20 +0300
> Antti Palosaari<crope@iki.fi>  wrote:
>
>> On 03.04.2012 12:05, Michael Büsch wrote:
>>> Now that i2c transfers are fixed, 3 retries are enough.
>>>
>>> Signed-off-by: Michael Buesch<m@bues.ch>
>>
>> Applied, thanks!
>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental
>>
>> I think I will update original af9035 PULL request soon for the same
>> level as af9035_experimental is currently.
>
> That's great. The driver really works well for me.
>
> On another thing:
> The af9035 driver doesn't look multi-device safe. There are lots of static
> variables around that keep device state. So it looks like this will
> blow up if multiple devices are present in the system. Unlikely, but still... .
> Are there any plans to fix this up?
> If not, I'll probably take a look at this. But don't hold your breath.

That's true and same applies for many other DVB USB drivers. Main reason 
for current hackish situation is DVB USB core limits. For example priv 
is not available until frontend attach etc. It "just" works even a 
little bit luck. Good example is that sequence counter, if you have 
multiple devices it runs wrongly as all increases same counter. But as a 
firmware does not care sequence numbers it still works. Remote 
controller is other big problem - coming from same limitations. And that 
is not first time these are spoken :)

I have thought to redesign whole DVB USB framework, but as I am too busy 
always I haven't done that. Feel free to start fixing.


regards
Antti
-- 
http://palosaari.fi/

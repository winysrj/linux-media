Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58180 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab3AMQiV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 11:38:21 -0500
Message-ID: <50F2E2D7.7000208@iki.fi>
Date: Sun, 13 Jan 2013 18:37:43 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jacek Konieczny <jajcus@jajcus.net>
CC: linux-media@vger.kernel.org
Subject: Re: [BUG] Problem with LV5TDLX DVB-T USB and the 3.7.1 kernel
References: <20130105150539.32186362@lolek.nigdzie> <50E83874.5060700@iki.fi> <20130107121034.7da1a00a@jajo.eggsoft>
In-Reply-To: <20130107121034.7da1a00a@jajo.eggsoft>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/07/2013 01:10 PM, Jacek Konieczny wrote:
> On Sat, 05 Jan 2013 16:28:04 +0200
> Antti Palosaari <crope@iki.fi> wrote:
>
>> Take USB sniffs, make scripts to generate e4000 register write code
>> from the sniffs, copy & paste that code from the sniffs until it
>> starts working. After it starts working it is quite easy to comment
>> out / tweak with driver in order to find problem. With the experience
>> and luck it is only few hours to fix, but without a experience you
>> will likely need to learn a lot of stuff first.
>
> I have not experience with the linux media drivers coding, so it probably
> would take me much more than a few hours or require lots of luck.
>
>> Of course those sniffs needed to take from working case, which just
>> makes successful tuning to 746000000 or 698000000.
>>
>> Also you could use to attenuate or amplifier signal to see if it
>> helps.
>
> Already tried that, with various levels of attenuation and amplification,
> the results vary from snr always 0000 to, at best, approximately every
> second line of tzap output shows non-zero snr.
>
>> I don't have much time / money, no interest, no equipment (DVB-T
>> modulator) to start optimizing it currently.
>
> I see. Can sending the device to you help in any way? In case I cannot make
> it work, I can, as well, send it to someone who could do good use of it.
> But first, I will try to fix it myself somehow.
>
> I'll try my luck with code. Maybe comparing the drivers with those from
> Realtek, which used to work for me, will help. Thanks for all the hints.

I haven't tested whole device as someone else has added that USB ID. 
That makes me thinking if there has been test mistake or testing at all. 
As it is still e4000 reference design it should work just like all the 
others, but you never know... Small hw difference with a driver bug 
(like some wrong GPIO) and it could lead situation like that. GPIO based 
antenna switch?

Feel free to send it for me if you don't find problem yourself. Address 
could be found from my LinuxTV project page:
http://palosaari.fi/linux/

regard
Antti

-- 
http://palosaari.fi/

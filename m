Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57170 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526AbbGTOav (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 10:30:51 -0400
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants -
 testers reqd.
To: Steven Toth <stoth@kernellabs.com>, tonyc@wincomm.com.tw
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <55AD0617.7060007@iki.fi>
Date: Mon, 20 Jul 2015 17:30:47 +0300
MIME-Version: 1.0
In-Reply-To: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/2015 01:21 AM, Steven Toth wrote:
> http://git.linuxtv.org/cgit.cgi/stoth/hvr1275.git/log/?h=hvr-1275
>
> Patches above are available for test.
>
> Antti, note the change to SI2168 to add support for enabling and
> disabling the SI2168 transport bus dynamically.
>
> I've tested with a combo card, switching back and forward between QAM
> and DVB-T, this works fine, just remember to select a different
> frontend as we have two frontends on the same adapter,
> adapter0/frontend0 is QAM/8SVB, adapter0/frontend1 is DVB-T/T2.
>
> If any testers have the ATSC or DVB-T, I'd expect these to work
> equally well, replease report feedback here.

That does not work. I added debug to see what it does and result is that 
whole si2168_set_ts_mode() function is called only once - when frontend 
is opened first time. I used dvbv5-scan.

I am not sure why you even want to that. Is it because of 2 demods are 
connected to same TS bus? So you want disable always another? Or is is 
just power-management, as leaving TS active leaks potentially some current.

Anyway, if you want control TS as runtime why you just don't add TS 
disable to si2168_sleep()? If you enable TS on si2168_init() then 
correct place to disable it is si2168_sleep().

regards
Antti

-- 
http://palosaari.fi/

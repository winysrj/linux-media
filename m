Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55081 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1ASUIj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 15:08:39 -0500
Received: by qwa26 with SMTP id 26so1228673qwa.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 12:08:38 -0800 (PST)
References: <1295205650.2400.27.camel@localhost> <1295234982.2407.38.camel@localhost> <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com> <1295439718.2093.17.camel@morgan.silverblock.net> <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net> <1295444282.4317.20.camel@morgan.silverblock.net> <20110119145002.6f94f800@endymion.delvare> <D7F0E4A6-5A23-4A28-95F8-0A088F1D6114@wilsonet.com> <20110119184322.0e5d12cd@endymion.delvare>
In-Reply-To: <20110119184322.0e5d12cd@endymion.delvare>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <0281052D-AFBF-4764-ADFF-64EF0A0CC2CB@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Andy Walls <awalls@md.metrocast.net>, Mike Isely <isely@isely.net>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
Date: Wed, 19 Jan 2011 15:08:53 -0500
To: Jean Delvare <khali@linux-fr.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 19, 2011, at 12:43 PM, Jean Delvare wrote:

> On Wed, 19 Jan 2011 12:12:49 -0500, Jarod Wilson wrote:
>> On Jan 19, 2011, at 8:50 AM, Jean Delvare wrote:
>> 
>>> Hi Andy,
>>> 
>>> On Wed, 19 Jan 2011 08:38:02 -0500, Andy Walls wrote:
>>>> As I understand it, the rules/guidelines for I2C probing are now
>>>> something like this:
>>>> 
>>>> 1. I2C device driver modules (ir-kbd-i2c, lirc_zilog, etc.) should not
>>>> do hardware probes at all.  They are to assume the bridge or platform
>>>> drivers verified the I2C slave hardware's existence somehow.
>>>> 
>>>> 2. Bridge drivers (pvrusb, hdpvr, cx18, ivtv, etc.) should not ask the
>>>> I2C subsystem to probe hardware that it knows for sure exists, or knows
>>>> for sure does not exist.  Just add the I2C device or not.
>>>> 
>>>> 3. Bridge drivers should generally ask the I2C subsystem to probe for
>>>> hardware that _may_ exist.
>>>> 
>>>> 4. If the default I2C subsystem hardware probe method doesn't work on a
>>>> particular hardware unit, the bridge driver may perform its own hardware
>>>> probe or provide a custom hardware probe method to the I2C subsystem.
>>>> hdpvr and pvrusb2 currently do the former.
>>> 
>>> Yes, that's exactly how things are supposed to work now. And hopefully
>>> it makes sense and helps you all write cleaner code (that was the
>>> intent at least.)
>> 
>> One more i2c question...
>> 
>> Am I correct in assuming that since the zilog is a single device, which
>> can be accessed via two different addresses (0x70 for tx, 0x71 for rx),
>> that i2c_new_device() just once with both addresses in i2c_board_info
>> is correct, vs. calling i2c_new_device() once for each address?
> 
> Preliminary technical nitpicking: you can't actually pass two addresses
> in i2c_board_info, so the second address has to be passed as platform
> data.
> 
> I am sorry if you expected an authoritative answer, but... both options
> are actually possible.
> 
> If you use a single call to i2c_new_device(), you'll have a single
> i2c_client to start with, and you'll have to instantiate the second one
> in the probe function using i2c_new_dummy().
> 
> If you instead decide to call i2c_new_device() twice, there will be two
> calls to the probe function (which can be the same one in a single
> driver, or two different ones in separate drivers, at your option.) If
> any synchronization is needed between the two i2c_clients, you have to
> use the bridge driver as a relay, as Andy proposed doing already.
> 
> Really, both are possible, and the two options aren't that different in
> the end. I can't think of anything that can be done with one that
> couldn't be achieved with the other.

Yeah, see my follow-up mail. The code in hdpvr-i2c.c is clearly a bit
off now, and only worked in my testing, as at the time, I was using
an older lirc_zilog from prior to Andy's changes that still used the
old style binding and probing directly in the driver. I'm working on
fixing up hdpvr-i2c further right now, and will do some more prodding
with pvrusb2, the code for which looks correct with two i2c_new_device()
calls in it, one for each address, so I just need to figure out why
lirc_zilog is getting an -EIO trying to get tx brought up.

-- 
Jarod Wilson
jarod@wilsonet.com




Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56587 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1ASRjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 12:39:00 -0500
Received: by qyk12 with SMTP id 12so1180829qyk.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 09:38:59 -0800 (PST)
References: <1295205650.2400.27.camel@localhost> <1295234982.2407.38.camel@localhost> <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com> <1295439718.2093.17.camel@morgan.silverblock.net> <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net> <1295444282.4317.20.camel@morgan.silverblock.net> <20110119145002.6f94f800@endymion.delvare> <D7F0E4A6-5A23-4A28-95F8-0A088F1D6114@wilsonet.com>
In-Reply-To: <D7F0E4A6-5A23-4A28-95F8-0A088F1D6114@wilsonet.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <2ED85E98-FCAE-4851-9A42-E32D16C820F5@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Andy Walls <awalls@md.metrocast.net>, Mike Isely <isely@isely.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
Date: Wed, 19 Jan 2011 12:39:13 -0500
To: Jean Delvare <khali@linux-fr.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 19, 2011, at 12:12 PM, Jarod Wilson wrote:

> On Jan 19, 2011, at 8:50 AM, Jean Delvare wrote:
> 
>> Hi Andy,
>> 
>> On Wed, 19 Jan 2011 08:38:02 -0500, Andy Walls wrote:
>>> As I understand it, the rules/guidelines for I2C probing are now
>>> something like this:
>>> 
>>> 1. I2C device driver modules (ir-kbd-i2c, lirc_zilog, etc.) should not
>>> do hardware probes at all.  They are to assume the bridge or platform
>>> drivers verified the I2C slave hardware's existence somehow.
>>> 
>>> 2. Bridge drivers (pvrusb, hdpvr, cx18, ivtv, etc.) should not ask the
>>> I2C subsystem to probe hardware that it knows for sure exists, or knows
>>> for sure does not exist.  Just add the I2C device or not.
>>> 
>>> 3. Bridge drivers should generally ask the I2C subsystem to probe for
>>> hardware that _may_ exist.
>>> 
>>> 4. If the default I2C subsystem hardware probe method doesn't work on a
>>> particular hardware unit, the bridge driver may perform its own hardware
>>> probe or provide a custom hardware probe method to the I2C subsystem.
>>> hdpvr and pvrusb2 currently do the former.
>> 
>> Yes, that's exactly how things are supposed to work now. And hopefully
>> it makes sense and helps you all write cleaner code (that was the
>> intent at least.)
> 
> One more i2c question...
> 
> Am I correct in assuming that since the zilog is a single device, which
> can be accessed via two different addresses (0x70 for tx, 0x71 for rx),
> that i2c_new_device() just once with both addresses in i2c_board_info
> is correct, vs. calling i2c_new_device() once for each address?
> 
> At least, I'm reasonably sure that was the key to making the hdpvr IR
> behave with lirc_zilog, and after lunch, I should know if that's also
> the case for pvrusb2 devices w/a zilog IR chip.

Actually, in looking at things closer and talking to Andy on irc, it
looks like this:

static struct i2c_board_info pvr2_xcvr_i2c_board_info = {
        I2C_BOARD_INFO("ir_tx_z8f0811_haup", Z8F0811_IR_TX_I2C_ADDR),
        I2C_BOARD_INFO("ir_rx_z8f0811_haup", Z8F0811_IR_RX_I2C_ADDR),
};

Expands to:

static struct i2c_board_info pvr2_xcvr_i2c_board_info = {
        .type = "ir_tx_z8f0811_haup",
	.addr = Z8F0811_IR_TX_I2C_ADDR,
        .type = "ir_rx_z8f0811_haup",
	.addr = Z8F0811_IR_RX_I2C_ADDR,
};

In which case, we're actually only registering 0x71 -- i2c_new_device()
certainly only appears to act on a single address, anyway.

-- 
Jarod Wilson
jarod@wilsonet.com




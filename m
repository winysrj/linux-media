Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:42695 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbcDEPiq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2016 11:38:46 -0400
Message-ID: <5703DBFC.6030103@lysator.liu.se>
Date: Tue, 05 Apr 2016 17:38:36 +0200
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
CC: Peter Rosin <peda@axentia.se>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] si2168: use i2c controlled mux interface
References: <1452058920-9797-1-git-send-email-crope@iki.fi> <56F2CB4D.4030104@lysator.liu.se> <5703D0C3.7010201@iki.fi>
In-Reply-To: <5703D0C3.7010201@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-04-05 16:50, Antti Palosaari wrote:
> On 03/23/2016 06:58 PM, Peter Rosin wrote:
>> On 2016-01-06 06:42, Antti Palosaari wrote:
>>> Recent i2c mux locking update offers support for i2c controlled i2c
>>> muxes. Use it and get the rid of homemade hackish i2c adapter
>>> locking code.
>>
>> [actual patch elided]
>>
>> I had a 2nd look and it seems that the saa7164 driver has support for
>> a HVR2055 card with dual si2168 chips. These two chips appear to sit
>> on the same i2c-bus with different i2c-addresses (0x64 and 0x66) and
>> with gates (implemented as muxes) to two identical tuners with the
>> same i2c-address (0x60). Do I read it right?
> 
> saa7164 has 3 different I2C adapters.
> 
> saa7164 I2C bus #0:
> * eeprom
> * Si2157 #1
> 
> saa7164 I2C bus #1:
> * Si2157 #2
> 
> saa7164 I2C bus #2:
> * Si2168 #1
> * Si2168 #2
> 
> So both of the Si2157 tuners could have same addresses.
> 
> (It is Hauppauge WinTV-HVR2205, not HVR-2055).

Ok, so I did read it right.

>> With the current i2c-mux-locking (parent-locked muxes), this works
>> fine as an access to one of the tuners locks the root i2c adapter
>> and thus the other tuner is also locked out. But with the upcoming
>> i2c-mux-locking for i2c-controlled muxes (self-locked muxes), the
>> root i2c adapter would no longer be locked for the full transaction
>> when one of the tuners is accessed. This means that accesses to the
>> two tuners may interleave and cause all kinds of trouble, should
>> both gates be open at the same time. So, is it really correct and
>> safe to change the si2168 driver to use a self-locked mux?
>>
>> Unless there is some other mechanism that prevents the two tuners
>> from being accessed in parallel, I think not. But maybe there is such
>> a mechanism?
> 
> Good point. Actually there is pretty often this kind of configuration used for those dual tuner devices and it will cause problems... Currently all of those implements hackish i2c_gate_ctrl() callback to switch mux.
> 
>  ____________           ____________           ____________
> |I2C-adapter |         |  I2C-mux   |         | I2C-client |
> |------------|         |------------|         |------------|
> |            |         | addr 0x1c  |         | addr 0x60  |
> |            |         |            |         |            |
> |            |-+-I2C---|-----/ -----|---I2C---|            |
> |____________| |       |____________|         |____________|
>                |        ____________           ____________
>                |       |  I2C-mux   |         | I2C-client |
>                |       |------------|         |------------|
>                |       | addr 0x1d  |         | addr 0x60  |
>                |       |            |         |            |
>                +-I2C---|-----/ -----|---I2C---|            |
>                        |____________|         |____________|

Right, so self-locked muxes (as in v5 [1]) can't do the job,
but mux-locked muxes (as in v6 [2]) should be fine. The v6 mux-
locked muxes grab a new mux_lock in the parent adapter where
the v5 self-locked muxes grabbed a lock in the mux itself. Which
means that sibling muxes will lock each other out with v6 when
they go for the same lock, which is what we want.

Cheers,
Peter

(v5 and v6 refer to the mux locking update patch series)

[1] http://marc.info/?l=linux-i2c&m=145805103325611&w=2
[2] http://marc.info/?l=linux-i2c&m=145967417924732&w=2

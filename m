Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35260 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab2DANTs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 09:19:48 -0400
Message-ID: <4F7855F2.4010201@iki.fi>
Date: Sun, 01 Apr 2012 16:19:46 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <daniel-gl@gmx.net>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy
 T Stick [0ccd:0093]
References: <4F75A7FE.8090405@iki.fi> <20120330234545.45f4e2e8@milhouse> <4F762CF5.9010303@iki.fi> <20120331001458.33f12d82@milhouse> <20120331160445.71cd1e78@milhouse> <4F771496.8080305@iki.fi> <20120331182925.3b85d2bc@milhouse> <4F77320F.8050009@iki.fi> <4F773562.6010008@iki.fi> <20120331185217.2c82c4ad@milhouse> <4F77DED5.2040103@iki.fi> <20120401103315.1149d6bf@milhouse> <20120401141940.04e5220c@milhouse> <4F784A13.5000704@iki.fi> <20120401151153.637d2393@milhouse>
In-Reply-To: <20120401151153.637d2393@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.04.2012 16:11, Michael Büsch wrote:
> On Sun, 01 Apr 2012 15:29:07 +0300
> Antti Palosaari<crope@iki.fi>  wrote:
>> buf[1] = msg[0].addr<<  1;
>> Maybe you have given I2C address as a "8bit" format?
>
> Uhh, the address is leftshifted by one.
> So I changed the i2c address from 0xC0 to 0x60.

That's a very common mistake, I2C addresses are 7 bit and LSB is 
direction. But it is very common to see used it as a "8bit" format, 0xC0 
write address and 0xc1 as a read address. Even some data-sheets have 
that "wrong" naming.
There is many drivers that is wrong and causing confusion, even my old 
AF9015... :]

> The i2c write seems to work now. At least it doesn't complain anymore
> and it sorta seems to tune to the right frequency.
> But i2c read may be broken.
> I had to enable the commented read code, but it still fails to read
> the VCO calibration value:
>
> [ 3101.940765] i2c i2c-8: Failed to read VCO calibration value (got 20)
>
> It doesn't run into this check on the other af903x driver.
> So I suspect an i2c read issue here.

That could be I2C adapter issue too, TUA9001 does not use it and thus 
not tested at all... But for my eyes it looks logically correct still.

> Attached: The patches.

Lets see.

regards
Antti
-- 
http://palosaari.fi/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59890 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab1K1QCf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 11:02:35 -0500
Message-ID: <4ED3B099.8050706@iki.fi>
Date: Mon, 28 Nov 2011 18:02:33 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jens Erdmann <Jens.Erdmann@web.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: Add Terratec Cinergy HTC Stick
References: <11607963.5467764.1322494881126.JavaMail.fmail@mwmweb051>
In-Reply-To: <11607963.5467764.1322494881126.JavaMail.fmail@mwmweb051>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

On 11/28/2011 05:41 PM, Jens Erdmann wrote:
> just a few quetstions:
> 1. Why is the device named EM2884_BOARD_CINERGY_HTC_STICK and not
>      EM2884_BOARD_TERRATEC_HTC_STICK like all the other devices from that
>      vendor? Looks inconsistent to me.

Developer have just chosen some value. Maybe he have not looked so 
carefully about naming. Feel free to fix :) I think correct name is 
something chip version + "board" + vendor name + device name and model. 
If name goes something like very long it could be shortened.

> 2. I stumbled over http://linux.terratec.de/tv_en.html where they list a NXP TDA18271
>      as used tuner for H5 and HTC Stick devices. I dont have any experience in this
>      kind of stuff but i am just asking.

DVB device contain logically three chips. Those are;
1. interface chip (USB, PCI)
2. demodulator
3. tuner

Those parts can be integrated even as one silicon (called 3-in-1). Very 
commonly it seen combination 1.+2. in one chip and 3. in other == total 
2 chips.

EM2884 is interface chip. It is called usually DVB USB bridge since it 
transfers bits from demod to computer.
TDA18271 is tuner. On the other side of chip is antenna connected as 
signal input and output is IF (intermediate frequency). Tuner can be 
thought as chip that transfers signal from RF (radio frequency) to IF 
(intermediate frequency). Demodulator then takes that IF from tuner and 
encodes bits out from signal. Interface between demodulator and bridge 
is bit interface and it is called MPEG2 TS (transport stream) interface.

There is also second interface for controlling each chip. That interface 
is usually I2C bus. Each chip (demod and tuner) is connected to the 
I2C-bus-adapter which is part of bridge. All command to chips are send 
using that I2C interface.

regards
Antti


-- 
http://palosaari.fi/

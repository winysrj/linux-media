Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34383 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab1INBEF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 21:04:05 -0400
Message-ID: <4E6FFD7E.2060500@iki.fi>
Date: Wed, 14 Sep 2011 04:03:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: recursive locking problem
References: <4E68EE98.90201@iki.fi> <20110909114634.GA22776@minime.bse>
In-Reply-To: <20110909114634.GA22776@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/2011 02:46 PM, Daniel Glöckner wrote:
> On Thu, Sep 08, 2011 at 07:34:32PM +0300, Antti Palosaari wrote:
>> I am working with AF9015 I2C-adapter lock. I need lock I2C-bus since
>> there is two tuners having same I2C address on same bus, demod I2C
>> gate is used to select correct tuner.
>
> Would it be possible to use the i2c-mux framework to handle this?
> Each tuner will then have its own i2c bus.

Interesting idea, but it didn't worked. It deadlocks. I think it locks 
since I2C-mux is controlled by I2C "switch" in same I2C bus, not GPIO or 
some other HW.

* tuner does I2C xfer on I2C-mux adapter
* I2C-mux adapter calls demod .i2c_gate_ctrl()
* demod does register access using I2C
* DEADLOCK

Maybe since tuner I2C xfer have already locked I2C-adater. Then demod 
access same adapter and it is locked.

But nice I2C mux anyhow.

@David Daney, see that pic in order to get understanding what kind of 
problem I am working;
http://palosaari.fi/linux/v4l-dv/controlling_tuner_af9015_dual_demod.txt


regards
Antti


-- 
http://palosaari.fi/

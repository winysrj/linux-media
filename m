Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57066 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab1INKpx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 06:45:53 -0400
Message-ID: <4E7085DB.2050809@iki.fi>
Date: Wed, 14 Sep 2011 13:45:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: recursive locking problem
References: <4E68EE98.90201@iki.fi> <20110909114634.GA22776@minime.bse> <4E6FFD7E.2060500@iki.fi> <20110914061922.GA1851@minime.bse>
In-Reply-To: <20110914061922.GA1851@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2011 09:19 AM, Daniel Glöckner wrote:
> On Wed, Sep 14, 2011 at 04:03:58AM +0300, Antti Palosaari wrote:
>> On 09/09/2011 02:46 PM, Daniel Glöckner wrote:
>>> On Thu, Sep 08, 2011 at 07:34:32PM +0300, Antti Palosaari wrote:
>>>> I am working with AF9015 I2C-adapter lock. I need lock I2C-bus since
>>>> there is two tuners having same I2C address on same bus, demod I2C
>>>> gate is used to select correct tuner.
>>>
>>> Would it be possible to use the i2c-mux framework to handle this?
>>> Each tuner will then have its own i2c bus.
>>
>> Interesting idea, but it didn't worked. It deadlocks. I think it
>> locks since I2C-mux is controlled by I2C "switch" in same I2C bus,
>> not GPIO or some other HW.
>
> Take a look at drivers/i2c/muxes/pca954x.c. You need to use
> parent->algo->master_xfer/smbus_xfer directly as the lock that
> protects you from having both gates open is the lock of the
> root i2c bus.

Ah yes, rather similar case. I see it as commented in pca954x.c:
/* Write to mux register. Don't use i2c_transfer()/i2c_smbus_xfer()
    for this as they will try to lock adapter a second time */

This looks even more hackish solution than calling existing demod 
.i2c_gate_ctrl() callback from USB-interface driver. But yes, it must 
work - not beautiful but workable workaround.


regards
Antti

-- 
http://palosaari.fi/

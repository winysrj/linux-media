Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41958 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbaHGK1S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Aug 2014 06:27:18 -0400
Message-ID: <53E35484.5040606@iki.fi>
Date: Thu, 07 Aug 2014 13:27:16 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] support for DVBSky dvb-s2 usb: add some config andset_voltage
 for m88ds3103
References: <201408061227374212345@gmail.com> <201408071731141714723@gmail.com>
In-Reply-To: <201408071731141714723@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 08/07/2014 12:31 PM, nibble.max wrote:
>>> @@ -523,6 +508,17 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
>>>    
>>>    	priv->delivery_system = c->delivery_system;
>>>    
>>> +	if (priv->cfg->start_ctrl) {
>>> +		for (len = 0; len < 30 ; len++) {
>>> +			m88ds3103_read_status(fe, &status);
>>> +			if (status & FE_HAS_LOCK) {
>>> +				priv->cfg->start_ctrl(fe);
>>> +				break;
>>> +			}
>>> +			msleep(20);
>>> +		}
>>> +	}
>>> +
>>
>> What is idea of that start_ctrl logic? It looks ugly. Why it is needed?
>> What is wrong with default DVB-core implementation? You should not need
>> to poll demod lock here and then call streaming control callback from
>> USB driver. If you implement .streaming_ctrl() callback to DVB USB
>> driver, it is called automatically for you.
> It is nothing with streaming_ctrl of DVB USB driver.
> It relates with the hardware chip problem.
> The m88ds3103 will not output ts clock when it powers up at the first time.
> It starts to output ts clock as soon as it locks the signal.
> But the slave fifo of Cypress usb chip really need this clock to work.
> If there is no this clock, the salve fifo will stop.
> start_ctrl logic is used to restart the salve fifo when the ts clock is valid.

OK. Then we have to find out some solution... Is there anyone who has a
nice idea how to signal USB interface driver when demod gains a lock?
Sure USB driver could poll read_status() too, but it does not sound good
solution neither.

How about overriding FE .read_status() callback. It is called all the
time by DVB-core when frontend is open. Hook .read_status() to USB
interface driver, then call original .read_status() (implemented by
m88ds3103 driver), and after each call check if status is LOCKED or NOT
LOCKED. When status changes from NOT LOCKED to LOCKED call that board
specific routine which restarts TS FIFO. No change for demod driver
needed at all.

regards
Antto

-- 
http://palosaari.fi/

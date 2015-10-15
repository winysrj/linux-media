Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57550 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbbJOGyb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2015 02:54:31 -0400
Received: from dyn3-82-128-191-173.psoas.suomi.net ([82.128.191.173] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1ZmcQo-0002N8-21
	for linux-media@vger.kernel.org; Thu, 15 Oct 2015 09:54:30 +0300
Subject: Re: [PATCH] rtl28xxu: fix control message flaws
To: linux-media@vger.kernel.org
References: <1444495530-1674-1-git-send-email-crope@iki.fi>
 <20151014221124.GA31954@minime.bse>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <561F4DA5.2040806@iki.fi>
Date: Thu, 15 Oct 2015 09:54:29 +0300
MIME-Version: 1.0
In-Reply-To: <20151014221124.GA31954@minime.bse>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/15/2015 01:11 AM, Daniel Glöckner wrote:
> On Sat, Oct 10, 2015 at 07:45:30PM +0300, Antti Palosaari wrote:
>> Add lock to prevent concurrent access for control message as control
>> message function uses shared buffer. Without the lock there may be
>> remote control polling which messes the buffer causing IO errors.
>
> This patch fixes the Problems I had with my Astrometa stick's I2C bus
> locking up at the end of each dvbv5-scan run until it is disconnected.
> There is another source of IO errors in the current driver, though.
> The delayed work closing the I2C gate to the tuner is often executed
> after rtl2832_power_ctrl has disabled the PLL. This will cause the
> USB transfer accessing the gate control register to fail with -EPIPE.

I saw that few times too, but it does not cause any other harm than 
error printing. It went away when canceled that delayed gate closing 
timer during demod sleep. But that was device which doesn't have slave 
demod at all, so it does not apply to your case as integrated demod 
sleep is not called at all. I think some callback which does opposite 
than "enable_slave_ts()" is needed. Like "disable_slave_ts()" which 
kills that timer before demod is powered off.

regards
Antti

-- 
http://palosaari.fi/

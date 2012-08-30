Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48389 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab2H3QAh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 12:00:37 -0400
Message-ID: <503F8E14.4010006@iki.fi>
Date: Thu, 30 Aug 2012 19:00:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgQ2FyZG9uYQ==?= <remi.cardona@smartjog.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] ds3000: properly report firmware loading
 issues
References: <1346319391-19015-1-git-send-email-remi.cardona@smartjog.com> <1346319391-19015-3-git-send-email-remi.cardona@smartjog.com> <503F6D18.2060804@iki.fi> <503F84F5.9010304@smartjog.com>
In-Reply-To: <503F84F5.9010304@smartjog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2012 06:21 PM, Rémi Cardona wrote:
> Hi Antti,
>
> On 08/30/2012 03:39 PM, Antti Palosaari wrote:
>> As I understand firmware downloading failure is coming from the fact
>> that register read fails => fails to detect if firmware is already
>> running or not.
>
> Well we actually see 2 cases:
>
>   - the register read failure (when ds3000_readreg() returns negative
> values). This case is fairly rare, and no changes we've done to the
> driver allowed us to make those cards work.

hmm, looks like ds3000_readreg() logic is still a little bit broken. It 
checks count of sent messages and compares it to 2. But if I2C-adapter 
sends only 1 message or 3 (which should not be possible) function return 
that count instead of -EREMOTEIO. OK, quite rare situation, but one 
point more to fail if I2C-adapter has also bug.

But that happens for return value 0 too. Could it be the issue? 
I2C-adapter returns 0 for some reason? Bug in I2C-adapter with bug in 
ds3000_readreg() implementation?

>   - the register read returning 0. Looking at the current code, it looks
> like the 0xb2 register is supposed to mean that a firmware is loaded.
> This case is fairly common: we've had many cards randomly saying that a
> firmware was loaded when none had been. Often, a simple reboot will do
> the trick. But sometimes, forcing the firmware upload (ie, bypassing the
> 0xb2 register check) allows the stubborn cards to function properly.
>
>> Original behavior to expect firmware is loaded and running when register
>> read fails is very stupid and your fix seems much better.
>
> Well, this patch should not really change the behavior. It just
> propagates register read errors to ds3000_initfe(). It'll just fail earlier.
>
>> So first priority should be try fix that issue with register read. Is it
>> coming from the USB stack (eg. error 110 timeout) or some other error
>> coming from the fact chip answers wrong?
>
> The cards we're using are PCIe (and not the ones with an embedded USB
> controller).

The idea of my question was to ask where those errors are coming from (I 
spoke mistakenly about USB because I usually play with USB devices).

You basically see two different kind of errors, 1) bus communication 
fails, eg. usb timeouts. 2) chips returns error status. Later cases the 
error could come from the this could come from the firmware if chip uses 
firmware or from the silicon. It could be from the I2C-adapter firmware.

>> Do you see other register I/O failing too?
>
> I'll see if I can get you an answer for that, since the cards are
> shipped with the appliance we send to our customers. Remote debugging is
> somewhat tricky.
>
>> Does adding few usec sleep help?
>
> I'm not quite sure where to add those sleeps. In the register
> reading/writing functions? 10us? 100us?

Add sleep after the each operation. Good place to add sleep is 
I2C-adapter. I2C-adapters usually supports two different operations, 
write and read + write using repeated START condition. Former us used 
typically for register write and later for register read.

500us is good choice. If it is only that one register read which causes 
problems, how about repeating it?

>
> Many thanks
>
> Rémi
>


-- 
http://palosaari.fi/

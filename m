Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44119 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3J3Pf0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 11:35:26 -0400
Message-ID: <5271273C.4090604@iki.fi>
Date: Wed, 30 Oct 2013 17:35:24 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] rtl2830: add parent for I2C adapter
References: <1382386335-3879-1-git-send-email-crope@iki.fi> <52658CA7.5080104@iki.fi> <20131030151620.GB3663@katana>
In-Reply-To: <20131030151620.GB3663@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30.10.2013 17:16, Wolfram Sang wrote:
> Hi,
>
> sorry for the delay. The Kernel Summit made a pretty busy time out of
> the last weeks...
>
>> I found one of my drivers was crashing when DTV USB stick was
>> plugged. Patch in that mail patch fixes the problem.
>
> Well, if you have a parent, it should be set. This is always a good
> idea. Can't really tell why not having it causes the BUG, though.
>
>> I quickly looked possible I2C patches causing the problem and saw
>> that one as most suspicions:
>>
>> commit 3923172b3d700486c1ca24df9c4c5405a83e2309
>> i2c: reduce parent checking to a NOOP in non-I2C_MUX case
>
> Did you try reverting it? I am not sure this is the one.

Nope, not to mentio bisect. I have done bisect few times and I am not 
going to waste whole day of compiling and booting new kernels.

Crash disappeared whit that little patch. I did also some DVB USB core 
changes for 3.12, but I cannot see it could be root of cause that crash.


>>> i2c i2c-6: adapter [RTL2830 tuner I2C adapter] registered
>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000220
>>> IP: [<ffffffffa0002900>] i2c_register_adapter+0x130/0x390 [i2c_core]
>
> Can we have the full BUG output?

See attachement.

Anyway, I am going to ask Mauro to merge that I2C parent patch and maybe 
try to sent it stable too as it is likely a bit too late for 3.12 RC.


regards
Antti

-- 
http://palosaari.fi/

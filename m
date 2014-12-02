Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.southpole.se ([37.247.8.11]:33359 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbaLBLwa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 06:52:30 -0500
Message-ID: <547DA7EF.50600@southpole.se>
Date: Tue, 02 Dec 2014 12:52:15 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, Akihiro TSUKADA <tskd08@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Random memory corruption of fe[1]->dvb pointer
References: <547BAC79.50702@southpole.se> <547CF9FC.5010101@southpole.se> <547D8AA0.4000403@gmail.com> <547D8E1A.5050307@iki.fi> <547D976D.2040205@southpole.se> <547D9B92.8060900@iki.fi>
In-Reply-To: <547D9B92.8060900@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-12-02 11:59, Antti Palosaari wrote:
> [...]
>> So the solution is to change rtl2832.c to the I2C model? And does this
>> issue only affect the mn8847x drivers ?
>
> It likely affects some other dvb-usb-v2 drivers too. But not af9035 as 
> I fixed it initially there I think.
>
>> If this is the case would a patch that does not free the buffer but
>> leaks the memory be ok ? I can add a todo item and log it in syslog.
>> That would for sure be better then crashing the subsystem and the driver
>> is still in staging for a reason.
>
> Maybe yes, but it does not sound absolute any good. I think you will 
> need to set FE pointer NULL after driver is removed.

It is NULL now, that is why it is crashing, or the current code leads to 
random corruptions.

> Then unregister frontend will not call members of that struct anymore, 
> but leak memory?

Well any solution that does not randomly crash the kernel when unloading 
the module is fine by me. My suggestion is to leak the memory and put a 
note about it in syslog. But I guess there are only a handful of users 
of this driver so maybe leave it as it is right now? It must be fixed 
anyway before the driver is moved out of staging.

>
> regards
> Antti
>

MvH
Benjamin Larsson

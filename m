Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.constalant.com ([195.138.135.178]:18120 "EHLO
	mail.constalant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbZBBQq0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 11:46:26 -0500
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Message-Id: <A2649F37-D1A0-4F7A-AEF0-4AF86AD2F9FA@constalant.com>
From: Getcho Getchev <ggetchev@constalant.com>
To: Matthias Schwarzott <zzam@gentoo.org>
In-Reply-To: <200902021245.45185.zzam@gentoo.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: PV143N watchdog
Date: Mon, 2 Feb 2009 18:12:41 +0200
References: <C528BDC8-8F63-4ED6-AED9-56F0F27C702F@constalant.com> <200902021245.45185.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again,
Yes, indeed the correct address is 0x2B. I2C bus is 7 bit so the  
address 0x56 must be shifted 1 position right before passed to  
i2c_master_send() or i2c_transfer() functions.
Now it works.
Thank you very much.
By the way it will be good if such useful functions are implemented by  
the V4L driver. There are many tv-cards with additional features on  
them (like watchdog, motion detection, etc).

On Feb 2, 2009, at 1:45 PM, Matthias Schwarzott wrote:

> On Monday 02 February 2009 10:34, Getcho Getchev wrote:
>> Greetings,
>> I am trying to control the PV143N watchdog via bttv driver under  
>> linux
>> kernel 2.6.24.3.
>> According to the specification the watchdog is located at address
>> 0x56, subaddress 0x01.
>> However when I try to write something (a value of 0, 1 or 2) on that
>> address I get NACK result.
>> I am using i2c_master_send() function and software bitbanging
>> algorithm, implemented in bttv-i2c.c
>> At the beginning I suspected the SCL line (the clock for the
>> communication must be set at 100 KHz) but when I saw the delay time  
>> is
>> 5 microseconds I realized the period is 10 microseconds which makes
>> 100 KHz. I tried to write the same data on address 0x2B and I
>> succeeded (although I do not know what is there on that address) so  
>> it
>
> That really sounds like a common i2c miss-understanding.
> Linux kernel i2c functions use only the 7bit address part of the i2c  
> address.
> So it sounds like your device has address 0x56 for writing and 0x57  
> for
> reading. (is this correct?)
> Now you give i2c_master_send or i2c_transfer the 7bit part, 0x56 >>  
> 1, and
> that is 0x2B.
>
> Regards
> Matthias
>


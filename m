Return-path: <linux-media-owner@vger.kernel.org>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:35645 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935794Ab3DRRjZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 13:39:25 -0400
Date: Thu, 18 Apr 2013 19:27:16 +0200 (CEST)
From: Juergen Lock <nox@jelal.kn-bremen.de>
Message-Id: <201304181727.r3IHRGbc018638@triton8.kn-bremen.de>
To: crope@iki.fi
Subject: Re: [PATCH v2 00/31] Add r820t support at rtl28xxu
In-Reply-To: <516DF31A.3030101@iki.fi>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In article <516DF31A.3030101@iki.fi> you write:
>Tested-by: Antti Palosaari <crope@iki.fi>
>
Tested-by: Juergen Lock <nox@jelal.kn-bremen.de>
>
>On 04/17/2013 03:42 AM, Mauro Carvalho Chehab wrote:
>> Add a tuner driver for Rafael Micro R820T silicon tuner.
>>
>> This tuner seems to be popular those days. Add support for it
>> at rtl28xxu.
>>
>> This tuner was written from scratch, based on rtl-sdr driver.
>>
>> Mauro Carvalho Chehab (31):
>>    [media] r820t: Add a tuner driver for Rafael Micro R820T silicon tuner
>>    [media] rtl28xxu: add support for Rafael Micro r820t
>>    [media] r820t: Give a better estimation of the signal strength
>>    [media] r820t: Set gain mode to auto
>>    [media] rtl28xxu: use r820t to obtain the signal strength
>>    [media] r820t: proper lock and set the I2C gate
>>    [media] rtl820t: Add a debug msg when PLL gets locked
>>    [media] r820t: Fix IF scale
>>    [media] rtl2832: add code to bind r820t on it
>>    [media] r820t: use the right IF for the selected TV standard
>>    [media] rtl2832: properly set en_bbin for r820t
>>    [media] r820t: Invert bits for read ops
>>    [media] r820t: use the second table for 7MHz
>>    [media] r820t: Show the read data in the bit-reversed order
>>    [media] r820t: add support for diplexer
>>    [media] r820t: better report signal strength
>>    [media] r820t: split the function that read cached regs
>>    [media] r820t: fix prefix of the r820t_read() function
>>    [media] r820t: use usleep_range()
>>    [media] r820t: proper initialize the PLL register
>>    [media] r820t: add IMR calibrate code
>>    [media] r820t: add a commented code for GPIO
>>    [media] r820t: Allow disabling IMR callibration
>>    [media] r820t: avoid rewrite all regs when not needed
>>    [media] r820t: Don't put it in standby if not initialized yet
>>    [media] r820t: fix PLL calculus
>>    [media] r820t: Fix hp_cor filter mask
>>    [media] r820t: put it into automatic gain mode
>>    [media] rtl2832: Fix IF calculus
>>    [media] r820t: disable auto gain/VGA setting
>>    [media] r820t: Don't divide the IF by two
>>
>>   drivers/media/dvb-frontends/rtl2832.c      |   85 +-
>>   drivers/media/dvb-frontends/rtl2832.h      |    1 +
>>   drivers/media/dvb-frontends/rtl2832_priv.h |   28 +
>>   drivers/media/tuners/Kconfig               |    7 +
>>   drivers/media/tuners/Makefile              |    1 +
>>   drivers/media/tuners/r820t.c               | 2352 ++++++++++++++++++++++++++++
>>   drivers/media/tuners/r820t.h               |   58 +
>>   drivers/media/usb/dvb-usb-v2/Kconfig       |    1 +
>>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c    |   34 +
>>   drivers/media/usb/dvb-usb-v2/rtl28xxu.h    |    1 +
>>   10 files changed, 2548 insertions(+), 20 deletions(-)
>>   create mode 100644 drivers/media/tuners/r820t.c
>>   create mode 100644 drivers/media/tuners/r820t.h
>>
>
>
>-- 
>http://palosaari.fi/



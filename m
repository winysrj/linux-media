Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:52524 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbbBSQZS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 11:25:18 -0500
Received: by mail-yk0-f179.google.com with SMTP id 9so4490370ykp.10
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2015 08:25:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54E60BFD.6090409@iki.fi>
References: <1424337200-6446-1-git-send-email-a.seppala@gmail.com>
	<54E5B028.5080900@southpole.se>
	<CAKv9HNaSqgFpC+TmMm86Y7mrgXvZ9U+wqdgjM4n=hf80p2W1jg@mail.gmail.com>
	<54E60378.6030604@iki.fi>
	<CAKv9HNZPLws9=dpigcVtL7zedWYRit=yK_dw9EkdzH2VD55qMQ@mail.gmail.com>
	<54E60BFD.6090409@iki.fi>
Date: Thu, 19 Feb 2015 11:25:17 -0500
Message-ID: <CALzAhNUYQeSDeZ5RFqaRm__a6UDXj7EGZi51vACG2injgBeeRA@mail.gmail.com>
Subject: Re: [RFC PATCH] mn88472: reduce firmware download chunk size
From: Steven Toth <stoth@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>,
	Benjamin Larsson <benjamin@southpole.se>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I tried loading the driver with polling disabled and it fails completely:
>>
>> [ 5526.693563] mn88472 7-0018: downloading firmware from file
>> 'dvb-demod-mn88472-02.fw'
>> [ 5527.032209] mn88472 7-0018: firmware download failed=-32
>> [ 5527.033864] rtl2832 7-0010: i2c reg write failed -32
>> [ 5527.033874] r820t 8-003a: r820t_write: i2c wr failed=-32 reg=05 len=1:
>> 83
>> [ 5527.036014] rtl2832 7-0010: i2c reg write failed -32
>>
>> I have no idea why the device behaves so counter-intuitively. Is there
>> maybe some sorf of internal power-save mode the device enters when
>> there is no i2c traffic for a while or something?
>
>
> IR polling does not use I2C but some own commands. Could you make more
> tests. Use rtl28xxu module parameter to disable IR and test. It will disable
> both IR interrupts and polling. Then make some tests with different IR
> polling intervals to see how it behaves.
>
> I have 3 mn88472 and 1 mn88473 device and all those seems to work fine for
> me. I don't care to buy anymore devices to find out one which does not work.
> Somehow root of cause should be find - it is not proper fix to repeat or
> break I2C messages to multiple smaller ones.

Ack.

Its the job of the I2C controller to manage the I2C bus
implementation, including any fragmentation needs, not the
tuner/demod/other driver.

Find and fix the resource contention bug in the bridge and the mn88472
will work as is. I suspect something is broken with I2C locking.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:43800 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab3AHRpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 12:45:41 -0500
Received: by mail-la0-f45.google.com with SMTP id ep20so786615lab.18
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2013 09:45:40 -0800 (PST)
Message-ID: <50EC5B60.7000207@googlemail.com>
Date: Tue, 08 Jan 2013 18:46:08 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: BUG: bttv does not load module ir-kbd-i2c for Hauppauge model
 37284, rev B421
References: <50E831F2.70400@googlemail.com> <20130105135734.237068c5@redhat.com> <50E9E05D.9090403@googlemail.com> <20130107142938.6e8f2c73@redhat.com>
In-Reply-To: <20130107142938.6e8f2c73@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<snip>
>
>>> It probably makes sense to add a "has_ir_i2c" field at bttv, add a flag
>>> there at modprobe to prevent the autoload, and start tagging the boards
>>> with I2C IR with such tag.
>> Without having looked into the code, it seems that the driver detects
>> the i2c rc already without a board flag.
>> Otherwise it wouldn't register the i2c device. Unfortunately, it doesn't
>> display a message.
> No. In the past (kernel 2.4 and upper), I2C bus used to work with 0-len
> reads to scan the used I2C addresses. The I2C drivers like tuners, demods,
> IR's etc used to register to the I2C core saying that they were to be used
> on TV boards. The I2C logic binds them to the I2C bus driver when they were
> detected, during the scanning process.
>
> That's why it is so hard to know what boards are using I2C remotes, on
> those older drivers.

Hmmm... so the I2C subystem probes a list of addresses and just
registers all devices it finds, but the driver itself doesn't know if
one of them is a RC device ?
Sounds odd. Will have to check the code to understand what's going on...

Regards,
Frank


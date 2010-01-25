Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:36931 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182Ab0AYQMw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 11:12:52 -0500
Message-ID: <4B5DC2EA.3090706@arcor.de>
Date: Mon, 25 Jan 2010 17:12:26 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy Hybrid XE (TM6010 Mediachip)
References: <4B547EBF.6080105@arcor.de> <4B5DAC3A.6000408@redhat.com>
In-Reply-To: <4B5DAC3A.6000408@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 25.01.2010 15:35, schrieb Mauro Carvalho Chehab:
> Stefan Ringel wrote:
>   
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>  
>> Hi Davin,
>> I have a question. How are loaded the base firmware into xc3028, in
>> once or in a split ? It's importent for TM6010, the USB-Analyzer said
>> that it load it in once and then send a quitting reqeuest.
>>     
> The way the original driver for tm6000/tm6010 does varies from firmware
> version to firmware version. That part of the driver works fine for
> both tm6000 and tm6010, with the devices I used here, with firmwares 1.e 
> and 2.7. However, on tm6000, it sends the firmware on packages with
> up to 12 or 13 bytes, and it requires a delay before sending the next
> packet, otherwise the tm6000 hangs.
>
> Another problem is that the firmware load may fail (due to the bad
> implementation of the i2c on tm6000/tm6010). So, the code should ideally
> check if the firmware were loaded, by reading the firmware version at the
> end. However, reading from i2c is very problematic, since it sometimes
> read from the wrong place. On the tests I did here, the original drivers
> weren't reading back the firmware version, probably due to this bug.
>   
My hybrid-stick with tm6010 chip use a special request ( requests 0x32 +
0x33) for quitting i2c transfer. so it can write correct the firmware
and can read tuner number and versions. Actually I tested next patch for
sync between tuner and demodulator and I have data by scanning digital
channels (one time), but  other test dos not data. I've test firmware
load 13, 64  and 3500 bytes and all works.

Cheers,

Stefan Ringel

-- 
Stefan Ringel <stefan.ringel@arcor.de>


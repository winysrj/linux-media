Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:59454 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbZKIXlZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 18:41:25 -0500
Message-ID: <13029.64.213.30.2.1257810088.squirrel@webmail.exetel.com.au>
In-Reply-To: <20091109144647.2f876934@pedra.chehab.org>
References: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
    <20091109144647.2f876934@pedra.chehab.org>
Date: Tue, 10 Nov 2009 10:41:28 +1100 (EST)
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
From: "Robert Lowery" <rglowery@exemail.com.au>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Em Mon, 9 Nov 2009 12:13:22 +0100
> Valerio Bontempi <valerio.bontempi@gmail.com> escreveu:
>
>> Hi all,
>>
>> I have a problem trying to user Terratec Cinergy T XS (usb dvb only
>> adapter) with XC3028 tuner:
>> v4l dvb driver installed in last kernel versions (actually I am using
>> 2.6.31 from ubuntu 9.10) detects this device but then looks for the
>> wrong firmware xc3028-v27.fw, and, moreover, seems to not contain
>> correct device firmware at all.
>> This makes the device to be detected but dvb device /dev/dvb is not
>> created by the kernel.
>>
>> Is there a way to make this device to work with last kernel versions
>> and last v4l-dvb driver versions?
>
> Earlier versions of Ubuntu used to contain an out-of-tree driver for
> xc3028,
> that used a different firmware format.
>
> Due to license issues, distros can't package the firmware files (since the
> vendor
> didn't give any redistribution rights for the firmwares up to now).
>
> So, you'll need to download a driver with the firmware inside and run a
> script to
> create the firmware.
>
> For more info and instructions on how to get the firmware, please see:
> 	http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Firmware
>
> Cheers,
> Mauro

Mauro,

Although the xc3028-v27.fw generated from
HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip using the above process works fine
for me, the firmware is a couple of years old now and I can't help
wondering if there might be a newer version in the latest Windows drivers
out there containing performance or stability fixes it in.

Do you think it would be worthwhile extracting a newer version of firmware?

-Rob


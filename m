Return-path: <mchehab@pedra>
Received: from mail.nagios.lastar.com ([64.129.117.10]:51783 "EHLO
	mail.lastar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab1EUS1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 14:27:53 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.lastar.com (Postfix) with ESMTP id 5242E2A6006
	for <linux-media@vger.kernel.org>; Sat, 21 May 2011 14:19:30 -0400 (EDT)
Received: from mail.lastar.com ([127.0.0.1])
	by localhost (mail.lastar.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xg8l6AHuos3e for <linux-media@vger.kernel.org>;
	Sat, 21 May 2011 14:19:30 -0400 (EDT)
Received: from V-EXMAILBOX.ctg.com (v-exmailbox.ctg.com [192.168.74.76])
	by mail.lastar.com (Postfix) with ESMTP id 185112A6004
	for <linux-media@vger.kernel.org>; Sat, 21 May 2011 14:19:30 -0400 (EDT)
From: Jason Gauthier <jgauthier@lastar.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: Enable IR on hdpvr
Date: Sat, 21 May 2011 18:19:28 +0000
Message-ID: <65DE7931C559BF4DBEE42C3F8246249A2AB1230E@V-EXMAILBOX.ctg.com>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
	 <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com>
	 <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com>
	 <93CE8497-D6AB-43BA-A239-EE32D51582FC@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B6A54C7@V-ALBEXCHANGE.ctg.com>,<1294875902.2485.19.camel@morgan.silverblock.net>
 <65DE7931C559BF4DBEE42C3F8246249A0B6A9B4A@V-ALBEXCHANGE.ctg.com>
In-Reply-To: <65DE7931C559BF4DBEE42C3F8246249A0B6A9B4A@V-ALBEXCHANGE.ctg.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

All,

>>If all goes well, with Jarrod's change, you should be able to test the
>>hdpvr module with the ir-kbd-i2c module and test IR Rx.

>>Strictly speaking, lirc_zilog needs some rework to use the kernel
>>internal interfaces properly.  It might still work, but don't be
>>surprised if it doesn't.

>>I might get to working on lirc_zilog tonight, but otherwise not until
>>this weekend.

>Sounds good. Will give any feedback I can!  Is Tx completely a no show at this point?  From my circle of friends that >use the hdpvr, they all use >the Tx for channel changing to cable boxes.  This small sample might not be indicative of >the larger hdpvr user base, though! :)

Well, it's been a few very busy months!    I've upgraded my distribution, and coupled that with a move to kernel 2.6.38.  I noticed that many patches for hdpvr and zilog have made it into the kernel source (at least staging)

Well, I am trying this out, and zilog does not probe the Tx on the HDPVR. Is that expected?
Well, it sort of does.

May 21 12:51:06 jgauthier-mythtv kernel: [   42.519404] lirc_zilog: Zilog/Hauppauge IR driver initializing
May 21 12:51:06 jgauthier-mythtv kernel: [   42.521233] lirc_zilog: probing IR Rx on Hauppage HD PVR I2C (i2c-1)
May 21 12:51:06 jgauthier-mythtv kernel: [   42.521239] lirc_zilog: probe of IR Rx on Hauppage HD PVR I2C (i2c-1) done. Waiting on IR Tx.
May 21 12:51:06 jgauthier-mythtv kernel: [   42.521245] lirc_zilog: probing IR Tx on Hauppage HD PVR I2C (i2c-1)
May 21 12:51:06 jgauthier-mythtv kernel: [   42.521372] i2c i2c-1: lirc_dev: driver lirc_zilog registered at minor = 1
May 21 12:51:06 jgauthier-mythtv kernel: [   43.088260] lirc_zilog: Zilog/Hauppauge IR blaster firmware version 2.1.0 loaded
May 21 12:51:06 jgauthier-mythtv kernel: [   43.088265] lirc_zilog: probe of IR Tx on Hauppage HD PVR I2C (i2c-1) done. IR unit ready.
May 21 12:51:06 jgauthier-mythtv kernel: [   43.088279] lirc_zilog: probing IR Rx on Hauppage HD PVR I2C (i2c-2)
May 21 12:51:06 jgauthier-mythtv kernel: [   43.088282] lirc_zilog: ir_probe: probing IR Rx on Hauppage HD PVR I2C (i2c-2) failed with 1
May 21 12:51:06 jgauthier-mythtv kernel: [   43.088288] Zilog/Hauppauge i2c IR: probe of 2-0071 failed with error 1
May 21 12:51:06 jgauthier-mythtv kernel: [   43.088293] lirc_zilog: probing IR Tx on Hauppage HD PVR I2C (i2c-2)
May 21 12:51:06 jgauthier-mythtv kernel: [   43.088295] lirc_zilog: ir_probe: probing IR Tx on Hauppage HD PVR I2C (i2c-2) failed with 1
May 21 12:51:06 jgauthier-mythtv kernel: [   43.088298] Zilog/Hauppauge i2c IR: probe of 2-0070 failed with error 1
May 21 12:51:06 jgauthier-mythtv kernel: [   43.088329] lirc_zilog: initialization complete

Admittedly, I do not understand exactly what I am reading.  It seems to probe the IR Tx (i2c-1) successfully:
May 21 12:51:06 jgauthier-mythtv kernel: [   43.088265] lirc_zilog: probe of IR Tx on Hauppage HD PVR I2C (i2c-1) done. IR unit ready.

But, then below on (i2c-2) is failed:
May 21 12:51:06 jgauthier-mythtv kernel: [   43.088282] lirc_zilog: ir_probe: probing IR Rx on Hauppage HD PVR I2C (i2c-2) failed with 1
May 21 12:51:06 jgauthier-mythtv kernel: [   43.088288] Zilog/Hauppauge i2c IR: probe of 2-0071 failed with error 1

Either way irsend doesn't work:

irsend: command failed: SEND_ONCE blaster 0_74_KEY_2
irsend: hardware does not support sending

Are there other pieces I need to glue together?
I attempted to move to lirc 0.9, and recompiled everything (including zilog) against it, (I read it somewhere) but that did not really make a difference.

Thanks,

Jason

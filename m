Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback7.mail.ru ([94.100.181.128]:55379 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbbF2W5U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 18:57:20 -0400
Received: from smtp19.mail.ru (smtp19.mail.ru [94.100.176.156])
	by fallback7.mail.ru (mPOP.Fallback_MX) with ESMTP id 6D59513FEB42E
	for <linux-media@vger.kernel.org>; Tue, 30 Jun 2015 01:55:16 +0300 (MSK)
Message-ID: <357E138A1D8D42758FFE05CFC73FDEB1@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: <linux-media@vger.kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	"Steven Toth" <stoth@kernellabs.com>
References: <DB7ACFD5239247FCB3C1CA323B56E88D@unknown><20150626062210.6ee035ec@recife.lan> <CAGoCfiyjRSxRrzdWVPREVaXoMK_iowu19n2+FJosg90UskumHA@mail.gmail.com>
Subject: Re: XC5000C 0x14b4 status
Date: Tue, 30 Jun 2015 05:55:07 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> IMHO, the best is to get the latest firmware licensed is the best
>> thing to do.
>>
>> Does that "new" xc5000c come with a firmware pre-loaded already?
> 
> I've got firmware here that is indicated as being for the xc5300 (i.e.
> 0x14b4).  That said, I am not sure if it's the same as the original
> 5000c firmware.  Definitely makes sense to do an I2C dump and compare
> the firmware images since using the wrong firmware can damage the
> part.
> 
> I'm not against an additional #define for the 0x14b4 part ID, but it
> shouldn't be accepted upstream until we have corresponding firmware
> and have seen the tuner working.  Do you have digital signal lock
> working with this device under Linux and the issue is strictly with
> part identification?

I just finished extraction of firmware for xc5000c.
By the way found one even for xc4000/4100.
xc5000c matches by size, signatures, but I have not tested it on a hardware.
xc4000/4100 matches only by a beginning signature, but should be ok. Have not tested it on a hardware too.
files:
http://beholder.ru/bb/download/file.php?id=868
http://beholder.ru/bb/download/file.php?id=869
How to extract it yourself:
Again, you have to download zipped file from http://beholder.ru/files/drv_v5510.zip
Unpack beholder.bin from it, and then use that commands to extract firmware:
dd if=beholder.bin  bs=1 skip=27663 count=16497 of=latest-dvb-fe-xc5000c-0.6.30.5.fw
dd if=beholder.bin  bs=1 skip=1718 count=13567 of=unconfirmed-dvb-fe-xc4000-xc4100-1.04.26.fw

Best regards.

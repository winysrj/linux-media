Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp11.mail.ru ([94.100.179.252]:38036 "EHLO smtp11.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbbFZLjh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 07:39:37 -0400
Message-ID: <70768F550F7841098B5BC3E9EEDFB33C@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: <linux-media@vger.kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>
References: <DB7ACFD5239247FCB3C1CA323B56E88D@unknown><20150626062210.6ee035ec@recife.lan> <CAGoCfiyjRSxRrzdWVPREVaXoMK_iowu19n2+FJosg90UskumHA@mail.gmail.com>
Subject: Re: XC5000C 0x14b4 status
Date: Fri, 26 Jun 2015 18:39:27 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
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

As I have understood, reading Poduct ID register (together with reading 
checksum register) is  primarily for check integrity of uploaded FW.
It's not indicates IC's P/N which FW should belong.

> I'm not against an additional #define for the 0x14b4 part ID, but it
> shouldn't be accepted upstream until we have corresponding firmware
> and have seen the tuner working.  Do you have digital signal lock
> working with this device under Linux and the issue is strictly with
> part identification?

With that RF tuner IC, Linux driver and public available FW for XC5000C
(from Kernel Labs) I successfully received analog and digital transmissions
over an air. Didn't checked it with DVC-C though.

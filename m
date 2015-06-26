Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp35.i.mail.ru ([94.100.177.95]:60594 "EHLO smtp35.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbbFZLv5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 07:51:57 -0400
Message-ID: <B3C502409DDD44C1BF8B9EA021AFA3B3@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: <linux-media@vger.kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>
References: <DB7ACFD5239247FCB3C1CA323B56E88D@unknown><20150626062210.6ee035ec@recife.lan><2DCE24E5218441A2AD205B5EA707CB62@unknown> <CAGoCfixD8VwQX9jB8a3_8urGu4y3D+x=JhZvq8PbpTpPcqrGzQ@mail.gmail.com>
Subject: Re: XC5000C 0x14b4 status
Date: Fri, 26 Jun 2015 18:51:42 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> It's not "new" IC. It's XC5000C. Maybe i was interpreted wrong.
>> As I have understood, such behaviour can depends from FW version.
>> HW vendor says, that with his latest FW he always gets response 0x14b4.
> 
> Ah, so you're running a completely different firmware image?  Well in
> that case that would explain the different response for the firmware
> loaded indication.

No no no. I used a FW image, which was taken from KernelLabs site, and it
was intended for use with XC5000C. And partnumber of IC was XC5000C
( I have opened RF shild to check it)

>> Not a 0x1388. And I think, that these ICs still come without pre-loaded FW.
>> HW vendor also didn't says anything about FW pre-load possibility.
> 
> Correct.  These are not parts that have any form of default firmware
> in their ROM mask (i.e. not like the silabs or micronas parts which
> have a default firmware and the ability to patch the ROM via a
> software loaded code update).  The firmware must be loaded every time
> the chip is brought out of reset or it won't work at all.


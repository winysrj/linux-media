Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.mail.ru ([94.100.179.57]:51855 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbbFZMTT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 08:19:19 -0400
Message-ID: <DB50FB6BCC774E06B4CD8BAB39BA9F55@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: "Steven Toth" <stoth@kernellabs.com>
Cc: <linux-media@vger.kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	"Devin Heitmueller" <dheitmueller@kernellabs.com>
References: <DB7ACFD5239247FCB3C1CA323B56E88D@unknown><20150626062210.6ee035ec@recife.lan><2DCE24E5218441A2AD205B5EA707CB62@unknown><CAGoCfixD8VwQX9jB8a3_8urGu4y3D+x=JhZvq8PbpTpPcqrGzQ@mail.gmail.com> <CALzAhNUrAAuPa1y6duaOSuNvpW_AP9g-ttwHkYSXBfdncvCKkA@mail.gmail.com>
Subject: Re: XC5000C 0x14b4 status
Date: Fri, 26 Jun 2015 19:19:03 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Correct.  These are not parts that have any form of default firmware
>> in their ROM mask (i.e. not like the silabs or micronas parts which
>> have a default firmware and the ability to patch the ROM via a
>> software loaded code update).  The firmware must be loaded every time
>> the chip is brought out of reset or it won't work at all.
>
> An image of the top of the tuner clearly showing any manufacturing
> markings would be welcome - assuming its accessible.

It's a best picture I could find:
http://www.reviews.ru/clause/over/T7_2/image41.jpg

Also, at least 2 users was successful with using Behold TV T7 tuner with
"my" Linux driver for it, then I shared it with others a year ago.

HW vendor also says, that Linux FW 4.1.30.7 for XC5000C (from KernelLabs)
reminds him "an old 4.1" numeration scheme from 2010 year. But he was unable to
understand it's date.

Also he says, that for XC5000C they are already long time using 0.6.30.5, and it's
always gives a 0x14b4.
// Filename : Xc5000_firmwares.h
// Generated : 2012/3/5 ¤W¤È 08:34:27
// Firmware version : 0.6; Release Number: 30.5



Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp44.i.mail.ru ([94.100.177.104]:53063 "EHLO smtp44.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbbGAVlv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jul 2015 17:41:51 -0400
Message-ID: <1C57786FDF8648B4A6CAD96753EFD82E@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>,
	"Steven Toth" <stoth@kernellabs.com>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	<linux-media@vger.kernel.org>
References: <DB7ACFD5239247FCB3C1CA323B56E88D@unknown><20150626062210.6ee035ec@recife.lan> <CAGoCfiyjRSxRrzdWVPREVaXoMK_iowu19n2+FJosg90UskumHA@mail.gmail.com>
Subject: Re: XC5000C 0x14b4 status
Date: Thu, 2 Jul 2015 04:41:33 +0700
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
> 
> I'm not against an additional #define for the 0x14b4 part ID, but it
> shouldn't be accepted upstream until we have corresponding firmware
> and have seen the tuner working.  Do you have digital signal lock
> working with this device under Linux and the issue is strictly with
> part identification?

Hello.

There are new details.

My assumption, that such behaviour of IC can be because of an old or incorrect
(for that HW) firmware, was wrong. It does not matter which FW version we use.
With a fresh (beginning of 2015) media_build, even with an "old" firmware, RF
tuner always and stably returns status 0x14b4. Also it's stably detects an already
loaded firmware from another instance of the driver (analog part initialisation).
And there is no i2c errors.

With an old media_build from beginning of 2014, there is some problem with
detection of already loaded firmware, there is i2c errors, and it gives the 50/50 status
either 0x1388 or 0x14b4.
My mistake I didn't checked a fresh media_build before.

So, the only thing we need is to add an additional #define for the 0x14b4 part ID to a
driver's code, as I wrote before.

If you have any more questions, please ask.

Best regards.

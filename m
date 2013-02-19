Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:42172 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab3BSToe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 14:44:34 -0500
Received: by mail-ee0-f47.google.com with SMTP id e52so3560323eek.20
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2013 11:44:32 -0800 (PST)
Message-ID: <5123D651.1090108@googlemail.com>
Date: Tue, 19 Feb 2013 20:45:21 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mr Goldcove <goldcove@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Wrongly identified easycap em28xx
References: <512294CA.3050401@gmail.com> <51229C2D.8060700@googlemail.com> <5122ACDF.1020705@gmail.com> <5123ACA0.2060503@googlemail.com> <20130219153024.6f468d43@redhat.com> <5123C849.6080207@googlemail.com> <20130219155303.25c5077a@redhat.com>
In-Reply-To: <20130219155303.25c5077a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 19.02.2013 19:53, schrieb Mauro Carvalho Chehab:
> Em Tue, 19 Feb 2013 19:45:29 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>>> I don't like the idea of merging those two entries. As far as I remember
>>> there are devices that works out of the box with
>>> EM2860_BOARD_SAA711X_REFERENCE_DESIGN. A change like that can break
>>> the driver for them.
>> As described above, there is a good chance to break devices with both
>> solutions.
>>
>> What's your suggestion ? ;-)
>>
> As I said, just leave it as-is (documenting at web) 

That seems to be indeed the only 100%-regression-safe solution.
But also _no_ solution for this device.
A device which works only with a special module parameter passed on
driver loading isn't much better than an unsupported device.

It comes down to the following question:
Do we want to refuse fixing known/existing devices for the sake of
avoiding regression for unknown devices which even might not exist ? ;-)

I have no strong and final opinion yet. Still hoping someone knows how
the Empia driver handles these cases...


> or to use the AC97
> chip ID as a hint. This works fine for devices that don't come with
> Empiatech em202, but with something else, like the case of the Realtek
> chip found on this device. The reference design for sure uses em202.

How could the AC97 chip ID help us in this situation ?
As far as I understand, it doesn't matter which AC97 IC is used.
They are all compatible and at least our driver uses the same code for
all of them.

So even if you are are right and the Empia reference design uses an EMP202,
EM2860_BOARD_SAA711X_REFERENCE_DESIGN might work for devices with other
AC97-ICs, too.
We should also expect manufacturers to switch between them whenever they
want (e.g. because of price changes).

Regards,
Frank


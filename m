Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:46769 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaJCFpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Oct 2014 01:45:20 -0400
Received: by mail-qg0-f41.google.com with SMTP id f51so520760qge.0
        for <linux-media@vger.kernel.org>; Thu, 02 Oct 2014 22:45:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <542E2BF6.2090800@iki.fi>
References: <1412275758-31340-1-git-send-email-knightrider@are.ma>
	<542E2BF6.2090800@iki.fi>
Date: Fri, 3 Oct 2014 14:45:19 +0900
Message-ID: <CAKnK8-QOU7szWNcC1BsBZtNmHBLiLqZuCVYpjsVBkpfNCxGa-A@mail.gmail.com>
Subject: Re: [PATCH] pt3 (pci, tc90522, mxl301rf, qm1d1c0042):
 pt3_unregister_subdev(), pt3_unregister_subdev(), cleanups...
From: "AreMa Inc." <info@are.ma>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	mchehab@osg.samsung.com, Hans De Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro & Antti

Please drop & replace Tsukada's PT3 patches.
There are too many weird & violating codes in it.

Thanks
-Bud


2014-10-03 13:54 GMT+09:00 Antti Palosaari <crope@iki.fi>:
> On 10/02/2014 09:49 PM, Буди Романто, AreMa Inc wrote:
>>
>> DVB driver for Earthsoft PT3 PCIE ISDB-S/T receiver
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> Status: stable
>>
>> Changes:
>> - demod & tuners converted to I2C binding model
>> - i586 & x86_64 clean compile
>> - lightweight & yet precise CNR calculus
>> - raw CNR (DVBv3)
>> - DVBv5 CNR @ 0.0001 dB (ref: include/uapi/linux/dvb/frontend.h, not
>> 1/1000 dB!)
>> - removed (unused?) tuner's *_release()
>> - demod/tuner binding: pt3_unregister_subdev(), pt3_unregister_subdev()
>> - some cleanups
>
>
> These drivers are already committed, like you have noticed. There is surely
> a lot of issues that could be improved, but it cannot be done by big patch
> which replaces everything. You need to just take one issue at the time,
> fix/improve it, send patch to mailing list for review. One patch per one
> logical change.
>
> regards
> Antti
>
> --
> http://palosaari.fi/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:40703 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3CUSUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 14:20:09 -0400
Received: by mail-ea0-f170.google.com with SMTP id a15so1012186eae.15
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 11:20:07 -0700 (PDT)
Message-ID: <514B4F8E.3030705@googlemail.com>
Date: Thu, 21 Mar 2013 19:21:02 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: commit aab3125c43d8fecc7134e5f1e729fabf4dd196da broke
 HVR 900
References: <201303210933.41537.hverkuil@xs4all.nl> <20130321070327.772c6301@redhat.com> <201303211634.13057.hverkuil@xs4all.nl>
In-Reply-To: <201303211634.13057.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 21.03.2013 16:34, schrieb Hans Verkuil:
> On Thu March 21 2013 11:03:27 Mauro Carvalho Chehab wrote:
>> Em Thu, 21 Mar 2013 09:33:41 +0100
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>> I tried to use my HVR 900 stick today and discovered that it no longer worked.
>>> I traced it to commit aab3125c43d8fecc7134e5f1e729fabf4dd196da: "em28xx: add
>>> support for registering multiple i2c buses".
>>>
>>> The kernel messages for when it fails are:
>> ...
>>> Mar 21 09:26:57 telek kernel: [ 1396.542517] xc2028 12-0061: attaching existing instance
>>> Mar 21 09:26:57 telek kernel: [ 1396.542521] xc2028 12-0061: type set to XCeive xc2028/xc3028 tuner
>>> Mar 21 09:26:57 telek kernel: [ 1396.542523] em2882/3 #0: em2882/3 #0/2: xc3028 attached
>> ...
>>> Mar 21 09:26:57 telek kernel: [ 1396.547833] xc2028 12-0061: Error on line 1293: -19
>> Probably, the I2C speed is wrong. I noticed a small bug on this patch.
>> The following patch should fix it. Could you please test?
> No luck, it didn't help.

I can't test it at the moment, but I have the same device and also
tested at least two other (non-em28xx) devices with the xc3028 during
the last weeks.
With all devices, I'm often getting i2c errors like this, too. Usually
only a few not affecting the device operation, but sometimes the log is
full of them and I have to unplugg the device and plug it in again to
make it work.
So something might be wrong with the xc3028 driver...
Maybe you just had bad luck when you tested this patch ?

Regards,
Frank


>
> Regards,
>
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


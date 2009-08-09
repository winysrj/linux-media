Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:50694 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZHII2O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Aug 2009 04:28:14 -0400
Received: by ewy10 with SMTP id 10so2412035ewy.37
        for <linux-media@vger.kernel.org>; Sun, 09 Aug 2009 01:28:13 -0700 (PDT)
Message-ID: <4A7E8899.7080206@gmail.com>
Date: Sun, 09 Aug 2009 10:28:09 +0200
From: =?UTF-8?B?RXJpayBBbmRyw6lu?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: About some sensor drivers in mc5602 gspca driver
References: <5e9665e10908090057n25103147s8b048bb0eb1d2d5b@mail.gmail.com> <4A7E86DF.1070901@gmail.com>
In-Reply-To: <4A7E86DF.1070901@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Erik Andrén wrote:
> 
> Dongsoo, Nathaniel Kim wrote:
>> Hello,
>>
>> It has been years I've working on linux multimedia drivers, but what a
>> shame I found that there were already sensor drivers that I've already
>> implemented. Precisely speaking, soc camera devices from Samsung named
>> s5k4aa* and s5k83a* were already in Linux kernel and even seems to
>> have been there for years.
>> But a thing that I'm curious is those drivers are totally mc602 and
>> gspca oriented. So some users who are intending to use those samsung
>> camera devices but not using gspca and mc5602 H/W have to figure out
>> another way.
>> As you know, the s5k* camera devices are actually ISP devices which
>> are made in SoC device and can be used independently with any kind of
>> ITU or MIPI supporting host devices.
>> However, I see that gspca and mc5602 have their own driver structure
>> so it seems to be tough to split out the sensor drivers from them.
>> So, how should we coordinate our drivers if a new s5k* driver is
>> getting adopted in the Linux kernel? different version of s5k* drivers
>> in gspca and subdev or gspca also is able to use subdev drivers?
>> I am very willing to contribute several drivers for s5k* soc camera
>> isp devices and in the middle of researching to prepare for
>> contribution those s5k* drivers popped up.
>> Please let me know whether it is arrangeable or not.
>> Cheers,
>>
> 
> Hi Nathaniel,
> The sensor sharing question pops up now and then and I'm sure that
> if you search the mailing list archive you can find several threads
> discussing this.
> IIRC the main problem is that in an usb webcam consisting of a
> sensor and an usb bridge. The sensor is often configured in a very
> specific way tied to the particular usb bridge. It is also common
> that much of the initialization is reverse engineered and that we
> may have little or no understanding what we're actually doing.
> (Often just mimicing a windows webcam driver).
> I think the conclusion reached now is that it's not worth the effort
> considering that the sensors usually don't need that much setup to
> get working. Of course this may need to be reevaluated from time to
> time. If someone could device a clever solution I would be all for
> trying to create some kind of driver sharing.
> 
> In the gspca-m5602-s5k* case everything is reverse-engineered, as I
> don't possess any datasheets of the ALi m5602 nor the s5k83a,
> s5k4aa. I would be much happy if you Samsung folks would be able to
> provide with me with datasheets for the s5k* sensors.
> 
> Best regards,
> Erik
> 
Resending due to UTF-8 fail.


>> Nate
>>
> 

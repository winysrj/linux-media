Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.211.177]:53138 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934138AbZHEKnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 06:43:06 -0400
Received: by ywh7 with SMTP id 7so6165302ywh.21
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2009 03:43:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908042346.52257.pboettcher@kernellabs.com>
References: <200908042138.11938.send2ph@googlemail.com>
	 <200908042346.52257.pboettcher@kernellabs.com>
Date: Wed, 5 Aug 2009 12:43:06 +0200
Message-ID: <23d3cce10908050343n42720c04x9e3a21538df6b613@mail.gmail.com>
Subject: Re: [patch] Added Support for STK7700D (DVB)
From: Pete Hildebrandt <send2ph@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Boettcher <pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

Here is my signed-off-by-line.

Signed-off-by: Pete Hildebrandt <send2ph@googlemail.com>

Thanks
Pete

2009/8/4 Patrick Boettcher <pboettcher@kernellabs.com>:
> Hi Pete,
>
> On Tuesday 04 August 2009 21:38:11 Pete Hildebrandt wrote:
>> Hello,
>>
>> To this mail I attached two patch-files to add support for the STK7700D
>> USB-DVB-Device.
>>
>> lsusb identifies it as:
>> idVendor           0x1164 YUAN High-Tech Development Co., Ltd
>> idProduct          0x1efc
>>  iProduct                2 STK7700D
>>
>> My two patches mainly just add the new product-ID.
>>
>> I have tested the modification with the 2.6.28 and the 2.6.30 kernel. The
>> patches are for the 2.6.30 kernel.
>>
>> The device is build into my laptop (Samsung R55-T5500) and works great
>> after applying the patches.
>
> I will apply your patches tomorrow, but before I need your Signed-off-by-line.
> So something like that:
>
> Signed-off-by: Name <email>
>
> thanks,
> --
> Patrick Boettcher - Kernel Labs
> http://www.kernellabs.com
>

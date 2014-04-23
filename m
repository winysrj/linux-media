Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:45954 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaDWUmc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 16:42:32 -0400
Received: by mail-qg0-f50.google.com with SMTP id 63so1577916qgz.9
        for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 13:42:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <535823E6.8020802@dragonslave.de>
References: <535823E6.8020802@dragonslave.de>
Date: Wed, 23 Apr 2014 16:42:31 -0400
Message-ID: <CAGoCfizxAopbb4pEtGXVtSSuccqAfu7iqB8Oc2Lb6TOS=6QL8g@mail.gmail.com>
Subject: Re: Terratec Cinergy T XS Firmware (Kernel 3.14.1)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Daniel Exner <dex@dragonslave.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 23, 2014 at 4:34 PM, Daniel Exner <dex@dragonslave.de> wrote:
> Hi,
>
> (Please keep me in CC as I'm currently not subscribed to this Mailinglist)
>
> I happened to inherit one of those DVB-T Sticks
>
>> ID 0ccd:0043 TerraTec Electronic GmbH Cinergy T XS
>
> and of course it isn't working as exspected.
>
> So far I extracted the firmware the tuner_xc2028 module was telling me
> (xc3028-v27.fw) and the module loaded.
> But no dvb device nodes where created.
>
> I tried connecting directly to it using xawtv and that gave me a load of
> "Incorrect readback of firmware version." messages.
>
> Then I tried loading the module with debug=1 and now I see:
>
>> Device is Xceive 34584 version 8.7, firmware version 1.8
>
> So I guess the driver is trying to use the wrong firmware file.
>
> I extracted some file named merlinC.rom from the Terratec Windows
> Drivers that I suspect to contain the firmware.
>
> Now I need some help how to verify that and create a usable fw File for
> the driver.

You can get the firmware via the following procedure:

http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Firmware

or if you're on Ubuntu it's already packaged in
linux-firmware-nonfree.  The file itself is 66220 bytes and has an MD5
checksum of 293dc5e915d9a0f74a368f8a2ce3cc10.

Note that if you have that file in /lib/firmware, it's entirely
possible that the driver is just broken (this happens quite often).
The values read back by dmesg are from the device itself, so if the
chip wasn't properly initialized fields such as the version will
contain garbage values.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

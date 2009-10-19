Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62496 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbZJSVvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 17:51:44 -0400
Received: by fxm18 with SMTP id 18so5636944fxm.37
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 14:51:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380910191341p484e070ftd190143f73b1d10e@mail.gmail.com>
References: <51bd605b0910181441l7d6ac90g53978e3e4436f6ba@mail.gmail.com>
	 <829197380910191218u2c281553pad57bff61ffbd3b5@mail.gmail.com>
	 <51bd605b0910191328i3b58c955ha3ade305b4af928d@mail.gmail.com>
	 <829197380910191341p484e070ftd190143f73b1d10e@mail.gmail.com>
Date: Mon, 19 Oct 2009 23:51:48 +0200
Message-ID: <51bd605b0910191451x22287c5ai3f829f2af0243879@mail.gmail.com>
Subject: Re: pctv nanoStick Solo not recognized
From: Matteo Miraz <telegraph.road@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin,

thanks for the support.

In the meanwhile, can I try to force the "new" vendor id?
Since I have another pinnacle USB device, I was thinking about
creating a new vendor (something like USB_VID_PINNACLE2).
Is it enough to add it just after the USB_VID_PINNACLE definition and
change the 57th line to

{ USB_DEVICE(USB_VID_PINNACLE2, USB_PID_PINNACLE_PCTV73ESE) },

or should I do something else?

Thank you again,
Matteo


On Mon, Oct 19, 2009 at 10:41 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Mon, Oct 19, 2009 at 4:28 PM, Matteo Miraz <telegraph.road@gmail.com> wrote:
>> in the changeset 12886:ba22a9decfab was added a device called
>> USB_PID_PINNACLE_PCTV73ESE, with id 0245
>>
>> However, the vendor is USB_VID_PINNACLE ( 0x2304 ) instead of 0x2013 (
>> as reported for my usb dvb by lsusb )
>>
>> How can I fix it? How can I create a new vendor with the correct ID,
>> and try if the module works? I'm new to the kernel development, so I'm
>> afraid to make mistakes!
>
> I've sent some email to the engineer I know over at PCTV Systems, and
> will report back when I know more.  My suspicion is that they changed
> the USB ID and we just need to update the driver to allow for either
> USB ID to be associated with the device.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>



-- 
ciao, teo

20 minutes is the average that a Windows based PC lasts
before it's compromised. (Internet Storm Center)

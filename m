Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50713 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbZJSU2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 16:28:47 -0400
Received: by fxm18 with SMTP id 18so5542825fxm.37
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 13:28:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380910191218u2c281553pad57bff61ffbd3b5@mail.gmail.com>
References: <51bd605b0910181441l7d6ac90g53978e3e4436f6ba@mail.gmail.com>
	 <829197380910191218u2c281553pad57bff61ffbd3b5@mail.gmail.com>
Date: Mon, 19 Oct 2009 22:28:50 +0200
Message-ID: <51bd605b0910191328i3b58c955ha3ade305b4af928d@mail.gmail.com>
Subject: Re: pctv nanoStick Solo not recognized
From: Matteo Miraz <telegraph.road@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Devin,

in the changeset 12886:ba22a9decfab was added a device called
USB_PID_PINNACLE_PCTV73ESE, with id 0245

However, the vendor is USB_VID_PINNACLE ( 0x2304 ) instead of 0x2013 (
as reported for my usb dvb by lsusb )

How can I fix it? How can I create a new vendor with the correct ID,
and try if the module works? I'm new to the kernel development, so I'm
afraid to make mistakes!

Thanks,
Matteo

On Mon, Oct 19, 2009 at 9:18 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Sun, Oct 18, 2009 at 5:41 PM, Matteo Miraz <telegraph.road@gmail.com> wrote:
>> Hi,
>>
>> I've just bought a new DVB USB card, but it seems that the current
>> version of linux tv does not recognize it at all.
>> I tried both the ubuntu kernel (9.04 and 9.10) and the latest drivers
>> downloaded with mercurial from http://linuxtv.org/hg/v4l-dvb
>>
>> The card is a PCTV nanoStick Solo, and chip seems to be a "73E SE".
>> Looking at the lsusb output (reported below), it seems that it is not
>> a pinnacle, but a new brand (the Vendor ID is different from the
>> pinnacle's one).
>>
>> Can you help me?
>>
>> Thanks,
>> Matteo
>
> As far as I can see, support for the PCTV 73E-SE (usb id 2013:0245)
> was introduced in hg rev 12886 on September 2nd.  This would have been
> too late to make it for the Karmic release.
>
> You can get the device working in your environment by installing the
> latest v4l-dvb tree.  You can find directions here:
>
> http://linuxtv.org/repo
>
> Cheers,
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

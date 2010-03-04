Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab0CDLSj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Mar 2010 06:18:39 -0500
Message-ID: <4B8F974A.4090001@redhat.com>
Date: Thu, 04 Mar 2010 12:19:38 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Gspca USB driver zc3xx and STV06xx probe the same device ..
References: <1820d69d1003030445n18b35839r407d4d277b1bf48d@mail.gmail.com> <62e5edd41003030517g6fa9b64awdf18578d6c5db7e@mail.gmail.com>
In-Reply-To: <62e5edd41003030517g6fa9b64awdf18578d6c5db7e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/03/2010 02:17 PM, Erik Andrén wrote:
> 2010/3/3 Gabriel C<nix.or.die@googlemail.com>:
>> Hello,
>>
>> I own a QuickCam Messanger webcam.. I didn't used it in ages but today
>> I plugged it in..
>> ( Device 002: ID 046d:08da Logitech, Inc. QuickCam Messanger )
>>
>> Now zc3xx and stv06xx are starting both to probe the device .. In
>> 2.6.33 that result in a not working webcam.
>> ( rmmod both&&  modprobe zc3xx one seems to fix that )
>>
>> On current git head zc3xx works fine even when both are probing the device.
>>
>> Also I noticed stv06xx fails anyway for my webcam with this error:
>> ....
>>
>> [  360.910243] STV06xx: Configuring camera
>> [  360.910244] STV06xx: st6422 sensor detected
>> [  360.910245] STV06xx: Initializing camera
>> [  361.161948] STV06xx: probe of 6-1:1.0 failed with error -32
>> [  361.161976] usbcore: registered new interface driver STV06xx
>> [  361.161978] STV06xx: registered
>> .....
>>
>> Next thing is stv06xx tells it is an st6422 sensor and does not work
>> with it while zc3xx tells it is an HV7131R(c) sensor and works fine
>> with it.
>>
>> What is right ?
>
> Hans,
> As you added support for the st6422 sensor to the stv06xx subdriver I
> imagine you best know what's going on.
>

I took the USB-ID in question from the out of tree v4l1 driver I was basing my
st6422 work on. Looking at the other ID's (which are very close together) and
combining that with this bug report, I think it is safe to say that the USB-ID
in question should be removed from the stv06xx driver.

Erik will you handle this, or shall I ?

Regards,

Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:41277 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab0CGOg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 09:36:26 -0500
MIME-Version: 1.0
In-Reply-To: <62e5edd41003061146x689527c9s5b3ab81eec3425a0@mail.gmail.com>
References: <1820d69d1003030445n18b35839r407d4d277b1bf48d@mail.gmail.com>
	 <62e5edd41003030517g6fa9b64awdf18578d6c5db7e@mail.gmail.com>
	 <4B8F974A.4090001@redhat.com>
	 <62e5edd41003040336x16253369ycb1905a9938432db@mail.gmail.com>
	 <4B8F9FC6.9030105@redhat.com>
	 <62e5edd41003061146x689527c9s5b3ab81eec3425a0@mail.gmail.com>
Date: Sun, 7 Mar 2010 15:36:24 +0100
Message-ID: <1820d69d1003070636y7fee5ce1q5e60f40d93379065@mail.gmail.com>
Subject: Re: Gspca USB driver zc3xx and STV06xx probe the same device ..
From: Gabriel C <nix.or.die@googlemail.com>
To: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/3/6 Erik Andrén <erik.andren@gmail.com>:
> 2010/3/4 Hans de Goede <hdegoede@redhat.com>:
>> Hi,
>>
>> On 03/04/2010 12:36 PM, Erik Andrén wrote:
>>>
>>> 2010/3/4 Hans de Goede<hdegoede@redhat.com>:
>>>>
>>>> Hi,
>>>>
>>>> On 03/03/2010 02:17 PM, Erik Andrén wrote:
>>>>>
>>>>> 2010/3/3 Gabriel C<nix.or.die@googlemail.com>:
>>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> I own a QuickCam Messanger webcam.. I didn't used it in ages but today
>>>>>> I plugged it in..
>>>>>> ( Device 002: ID 046d:08da Logitech, Inc. QuickCam Messanger )
>>>>>>
>>>>>> Now zc3xx and stv06xx are starting both to probe the device .. In
>>>>>> 2.6.33 that result in a not working webcam.
>>>>>> ( rmmod both&&    modprobe zc3xx one seems to fix that )
>>>>>>
>>>>>> On current git head zc3xx works fine even when both are probing the
>>>>>> device.
>>>>>>
>>>>>> Also I noticed stv06xx fails anyway for my webcam with this error:
>>>>>> ....
>>>>>>
>>>>>> [  360.910243] STV06xx: Configuring camera
>>>>>> [  360.910244] STV06xx: st6422 sensor detected
>>>>>> [  360.910245] STV06xx: Initializing camera
>>>>>> [  361.161948] STV06xx: probe of 6-1:1.0 failed with error -32
>>>>>> [  361.161976] usbcore: registered new interface driver STV06xx
>>>>>> [  361.161978] STV06xx: registered
>>>>>> .....
>>>>>>
>>>>>> Next thing is stv06xx tells it is an st6422 sensor and does not work
>>>>>> with it while zc3xx tells it is an HV7131R(c) sensor and works fine
>>>>>> with it.
>>>>>>
>>>>>> What is right ?
>>>>>
>>>>> Hans,
>>>>> As you added support for the st6422 sensor to the stv06xx subdriver I
>>>>> imagine you best know what's going on.
>>>>>
>>>>
>>>> I took the USB-ID in question from the out of tree v4l1 driver I was
>>>> basing
>>>> my
>>>> st6422 work on. Looking at the other ID's (which are very close together)
>>>> and
>>>> combining that with this bug report, I think it is safe to say that the
>>>> USB-ID
>>>> in question should be removed from the stv06xx driver.
>>>>
>>>> Erik will you handle this, or shall I ?
>>>>
>>> Either way is fine by me.
>>> I can try to do it tonight.
>>>
>>
>> If you could take care of this that would be great!
>>
>> Thanks,
>>
>> Hans
>>
>
> Sorry for delaying this, real life came in the way.
> I'm pasting in a patch that removes the usb id.
> I'm also attaching it as an attachment as gmail probably will stomp on
> the inline version.
>

Sorry too also I was busy these days.

> Gabriel, could you please apply and test this patch and verify that it
> works as intended, i. e. the stv06xx driver _doesn't_ bind to your
> camera but the zx3xx driver instead does.
> If it works as intended could you please reply to this mail with a

Yes does work.

> tested-by: your name <email> tag.
>

tested-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

> Best regards,
> Erik
>
> From 6f40494d48c5641326168115a96659581cea6273 Mon Sep 17 00:00:00 2001
> From: =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
> Date: Sat, 6 Mar 2010 20:34:51 +0100
> Subject: [PATCH 1/1] gspca-stv06xx: Remove the 046d:08da usb id from
> linking to the stv06xx driver
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: 8bit
>
> The 046d:08da usb id shouldn't be associated with the stv06xx driver
> as they're not compatible with each other.
> This fixes a bug where Quickcam Messenger cams fail to use its proper
> driver (gspca-zc3xx), rendering the camera inoperable.
>
> Signed-off-by: Erik Andrén <erik.andren@gmail.com>
> ---
>  drivers/media/video/gspca/stv06xx/stv06xx.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/video/gspca/stv06xx/stv06xx.c
> b/drivers/media/video/gspca/stv06xx/stv06xx.c
> index de823ed..b1f7e28 100644
> --- a/drivers/media/video/gspca/stv06xx/stv06xx.c
> +++ b/drivers/media/video/gspca/stv06xx/stv06xx.c
> @@ -497,8 +497,6 @@ static const __devinitdata struct usb_device_id
> device_table[] = {
>        {USB_DEVICE(0x046D, 0x08F5), .driver_info = BRIDGE_ST6422 },
>        /* QuickCam Messenger (new) */
>        {USB_DEVICE(0x046D, 0x08F6), .driver_info = BRIDGE_ST6422 },
> -       /* QuickCam Messenger (new) */
> -       {USB_DEVICE(0x046D, 0x08DA), .driver_info = BRIDGE_ST6422 },
>        {}
>  };
>  MODULE_DEVICE_TABLE(usb, device_table);
> --
> 1.6.3.3
>

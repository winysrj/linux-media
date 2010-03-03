Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51191 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab0CCNSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Mar 2010 08:18:01 -0500
MIME-Version: 1.0
In-Reply-To: <1820d69d1003030445n18b35839r407d4d277b1bf48d@mail.gmail.com>
References: <1820d69d1003030445n18b35839r407d4d277b1bf48d@mail.gmail.com>
Date: Wed, 3 Mar 2010 14:17:59 +0100
Message-ID: <62e5edd41003030517g6fa9b64awdf18578d6c5db7e@mail.gmail.com>
Subject: Re: Gspca USB driver zc3xx and STV06xx probe the same device ..
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Gabriel C <nix.or.die@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/3/3 Gabriel C <nix.or.die@googlemail.com>:
> Hello,
>
> I own a QuickCam Messanger webcam.. I didn't used it in ages but today
> I plugged it in..
> ( Device 002: ID 046d:08da Logitech, Inc. QuickCam Messanger )
>
> Now zc3xx and stv06xx are starting both to probe the device .. In
> 2.6.33 that result in a not working webcam.
> ( rmmod both && modprobe zc3xx one seems to fix that )
>
> On current git head zc3xx works fine even when both are probing the device.
>
> Also I noticed stv06xx fails anyway for my webcam with this error:
> ....
>
> [  360.910243] STV06xx: Configuring camera
> [  360.910244] STV06xx: st6422 sensor detected
> [  360.910245] STV06xx: Initializing camera
> [  361.161948] STV06xx: probe of 6-1:1.0 failed with error -32
> [  361.161976] usbcore: registered new interface driver STV06xx
> [  361.161978] STV06xx: registered
> .....
>
> Next thing is stv06xx tells it is an st6422 sensor and does not work
> with it while zc3xx tells it is an HV7131R(c) sensor and works fine
> with it.
>
> What is right ?

Hans,
As you added support for the st6422 sensor to the stv06xx subdriver I
imagine you best know what's going on.

Best regards,
Erik

>
>
> Best Regards,
>
> Gabriel C
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

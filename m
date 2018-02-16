Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out-1.itc.rwth-aachen.de ([134.130.5.46]:35482 "EHLO
        mail-out-1.itc.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750800AbeBPWqe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 17:46:34 -0500
From: =?iso-8859-1?Q?Br=FCns=2C_Stefan?= <Stefan.Bruens@rwth-aachen.de>
To: Olli Salonen <olli.salonen@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: Mygica 230C defined in two drivers
Date: Fri, 16 Feb 2018 22:46:32 +0000
Message-ID: <1929443.C4S24bI1rz@sbruens-linux>
References: <CAAZRmGzMyQv4DZiU33+N3qWkZkuXb53fZZiK881NU3u+SS0O6Q@mail.gmail.com>
In-Reply-To: <CAAZRmGzMyQv4DZiU33+N3qWkZkuXb53fZZiK881NU3u+SS0O6Q@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <D64D12DBCF557842B0E125C041779E1C@rwth-ad.de>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Freitag, 5. Januar 2018 16:39:20 CET Olli Salonen wrote:
> Hi Stefan and all,
> 
> I noticed that the Mygica 230C is currently defined in two different
> drivers.
> 
> in dvbsky.c:
> 
>     { DVB_USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230C,
>         &mygica_t230c_props, "MyGica Mini DVB-T2 USB Stick T230C",
>         RC_MAP_TOTAL_MEDIA_IN_HAND_02) },
> 
> 
> in cxusb.c:
> 
>     [MYGICA_T230] = {
>         USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230)
>     },
>     [MYGICA_T230C] = {
>         USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230+1)
>     },
> 
> and in dvb-usb-ids.h:
> 
> #define USB_PID_MYGICA_T230                    0xc688
> #define USB_PID_MYGICA_T230C                0xc689
> 
> I think you've played around with this device earlier. Do you have any
> insight on which driver works better or all they all the same?
> 
> Cheers,
> -olli


An patch addressing this issue has been lingering in patchwork for 5+ weeks 
...

https://patchwork.linuxtv.org/patch/46404/
https://patchwork.linuxtv.org/patch/46403/

Regards,

Stefan

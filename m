Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42380 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaAHTPF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 14:15:05 -0500
Received: by mail-ob0-f169.google.com with SMTP id wm4so2173593obc.14
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 11:15:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiws5YdmiY8wYkE4_=yKSc3WxABMyUZiT22rTafs-g4SnA@mail.gmail.com>
References: <CABMudhTFmbv-PrNiGcW2yoGPiXuJ13fCmoqDFFBJfEjLk=gSgw@mail.gmail.com>
	<CAGoCfizK7ZFgHTcLgaJRaP-Bvjriv7+fu+=yw+btMEC+GvoU7w@mail.gmail.com>
	<CABMudhQ16ZhvFcwoTdHnU4B9cjVScV4Ohh81izoQDstWsV8X_A@mail.gmail.com>
	<CAGoCfiws5YdmiY8wYkE4_=yKSc3WxABMyUZiT22rTafs-g4SnA@mail.gmail.com>
Date: Wed, 8 Jan 2014 11:15:04 -0800
Message-ID: <CABMudhTjgXpitX83K2x6_Lyse=Rts0h+t-9LZpUNCAV8yacOJw@mail.gmail.com>
Subject: Re: How can I find out what is the driver for device node '/dev/video11'
From: m silverstri <michael.j.silverstri@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks.

I am studying android source code.
>From here,  it has code which open("/dev/video11", O_RDWR, 0) as
decoding device.

http://androidxref.com/4.4.2_r1/xref/hardware/samsung_slsi/exynos5/libhwjpeg/ExynosJpegBase.cpp

I want to find out which is the corresponding driver code for device
'/dev/video11'.

Thank you very much.




On Wed, Jan 8, 2014 at 11:08 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Wed, Jan 8, 2014 at 2:03 PM, m silverstri
> <michael.j.silverstri@gmail.com> wrote:
>> Thanks. I don't have the a running hardware.
>> If I can only search within the code space, how can I find out which
>> driver is for '/dev/video11'?
>>
>> Is there a config file which I can look it up?
>
> If you don't actually have the hardware platform, then determining it
> just from the source code is a huge undertaking (unless it's some well
> known device which happens to always create it at that offset).
>
> What is the hardware platform, and what is the capture device?
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

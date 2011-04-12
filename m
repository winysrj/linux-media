Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64045 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab1DLRxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 13:53:43 -0400
Received: by vxi39 with SMTP id 39so5091803vxi.19
        for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 10:53:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTim0RgsZ5J5RAiGxVjTTEi8qGf4DCg@mail.gmail.com>
References: <BANLkTink9O=Gd1o0ytnS2OUot=0tdCTP3g@mail.gmail.com> <BANLkTim0RgsZ5J5RAiGxVjTTEi8qGf4DCg@mail.gmail.com>
From: =?UTF-8?Q?Zden=C4=9Bk_Materna?= <zdenek.materna@gmail.com>
Date: Tue, 12 Apr 2011 19:53:22 +0200
Message-ID: <BANLkTinfxRNmXe69-sg57MdDVgHfcVsywQ@mail.gmail.com>
Subject: Re: Genius webcam problem on ARM
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I'm sorry for another mail. It works with quirks 128 and uncompressed
YUV format. Is there any way how to use compressed MJPEG? Should I try
compile never uvcvideo driver?

Dne 12. dubna 2011 18:55 Zdeněk Materna <zdenek.materna@gmail.com> napsal(a):
> Hello again,
>
> now I discovered, that it's possible to change module parameters even
> if they are compiled in kernel... So I did:
>
> echo 2 > /sys/module/uvcvideo/parameters/quirks
>
> And v4l example now ends like this:
>
> VIDIOC_S_FMT error 28, No space left on device
>
> Error "No space left" indicates problem with USB bandwidth? How can I
> solve it? I tried to change resolution in v4l example from 640x480 to
> 160x120 but it didn't help.
>
> Dne 12. dubna 2011 18:37 Zdeněk Materna <zdenek.materna@gmail.com> napsal(a):
>> Hello,
>>
>> I have problem with UVC webcam. It's Genius Facecam 1000. I would like
>> to use it with mjpg-streamer. Before this model, I had Facecam 1320,
>> but it wasn't mjpeg capable, so mjpg-streamer had to do jpeg
>> compresion and it was quite slow. Facecam 1000 can provide mjpg stream
>> by itself and it works great on x86, but it doesn't work on ARM. To
>> exclude problem in mjpg-streamer I compiled v4l capture example
>> (http://v4l2spec.bytesex.org/spec-single/v4l2.html#CAPTURE-EXAMPLE)
>> and it's same - works on x86 a not on ARM.
>>
>> On embedded platform I'm using AT91SAM9260 (Olimex kit L9260) which
>> has USB2.0, but only full-speed - is it problem? I don't think so -
>> previous webcam works great.
>>
>> On x86 I use kernel 2.6.35 and glibc. On ARM there is kernel
>> 2.6.33.7.2-rt30 and uClibc.
>>
>> v4l example fails with this error: VIDIOC_STREAMON error 5, Input/output error
>>
>> webcam is detected correctly:
>> [ 2042.100000] usb 1-1: new full speed USB device using at91_ohci and address 3
>> [ 2042.290000] usb 1-1: New USB device found, idVendor=0458, idProduct=707e
>> [ 2042.290000] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> [ 2042.310000] usb 1-1: Product: FaceCam 1000
>> [ 2042.320000] usb 1-1: Manufacturer: KYE SYSTEMS CORP.
>> [ 2042.400000] uvcvideo: Found UVC 1.00 device FaceCam 1000 (0458:707e)
>> [ 2042.460000] input: FaceCam 1000 as
>> /devices/platform/at91_ohci/usb1/1-1/1-1:1.0/input/input1
>>
>> Thanks for any advice!
>>
>> Best regards
>> Zdenek Materna
>>
>

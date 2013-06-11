Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:43144 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3FKXEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 19:04:34 -0400
Received: by mail-ie0-f178.google.com with SMTP id at1so17048846iec.23
        for <linux-media@vger.kernel.org>; Tue, 11 Jun 2013 16:04:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51B660FE.4010605@gmail.com>
References: <519D6CFA.2000506@gmail.com>
	<CALF0-+UqJaNc7v86qakVTNEJx5npMFPqFp-=9rAByFV_+FEaww@mail.gmail.com>
	<519E41AC.3040707@gmail.com>
	<CALF0-+U5dFktwHwO5-h_7RJ1xyjc3JbHUWqG3g=WSPA=HcHnnw@mail.gmail.com>
	<519E6046.8050509@gmail.com>
	<CALF0-+UZnt9rfmQFSecqaf_9L29mwKeNV22w1XmMQQG0AE=jJw@mail.gmail.com>
	<519E76F3.4070006@gmail.com>
	<519EB8E6.5000503@gmail.com>
	<20130525070020.GA2122@dell.arpanet.local>
	<CALF0-+XS0urZ=G=jCLgKifs6NeC=rNqZB_ft2PXpcEVezuG=rw@mail.gmail.com>
	<51AFE7DC.9040801@gmail.com>
	<CALF0-+Use=xFe5XmoDMCTCw-CM11FZXTGoOnYwRSS9OL7Dk7Aw@mail.gmail.com>
	<51B076A2.9000903@gmail.com>
	<CALF0-+UBKXVeMxDob2NZWi5hervieRf48LoiTP80+_ZD58iw0g@mail.gmail.com>
	<51B660FE.4010605@gmail.com>
Date: Tue, 11 Jun 2013 20:04:33 -0300
Message-ID: <CALF0-+XMXzjo=TOkkfjAZHw3REJVz7EHa=J83cjMZ-LaCaR20w@mail.gmail.com>
Subject: Re: Audio: no sound
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: =?ISO-8859-1?Q?Alejandro_A=2E_Vald=E9s?= <av2406@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ale,

On Mon, Jun 10, 2013 at 8:27 PM, "Alejandro A. Valdés" <av2406@gmail.com> wrote:
[...]
>
>
> Besides, please find the kernel configuration file attached t this note.
> Seems that the STK1160_AC97 is already there (Ln 4151 AND SS).
>

Yes, it seems your configuration is correct.
I have a device here that behaves in a similar way. When I plug it I
get this output:

[12677.625434] usb 2-2: new high-speed USB device number 8 using ehci-pci
[12677.740513] usb 2-2: New device Syntek Semiconductor USB 2.0 Video
Capture Controller @ 480 Mbps (05e1:0408, interface 0, class 0)
[12677.740517] usb 2-2: video interface 0 found
[12678.217418] stk1160: driver ver 0.9.5 successfully loaded
[12678.220618] AC'97 0 access is not valid [0x0], removing mixer.
[12678.220623] stk1160: registers to NTSC like standard
[12678.221681] stk1160 2-2:1.0: V4L2 device registered as video1

Notice the "...removing mixer" line? It's reporting there's no AC97
decoder on the device.

The STK1160 chip has a built-in audio 8-bit ADC block, which is not
yet implemented
by the current driver. If you crack-open your device you should find
it has only two chips:
one should be stk1160, and the other should be saa711x compatible
(such as gm7113).
They are the USB bridge and the video decoder chip, respectively.

Some devices also have a third chip, which should be the AC97 decoder.

Currently, we only support this last family of devices. Namely the
ones with an AC97 decoder chip. The built-in sound ADC is not
supported.

If you want, feel free to check the above on your device. You should
check there's only
two chips and that the kernel says "AC'97 0 access is not valid [0x0],
removing mixer.".

I'll see if I can add support for the built-in sound ADC soon. With
some luck we might
have it this month!
-- 
    Ezequiel

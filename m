Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:54526 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3FGMOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 08:14:37 -0400
Received: by mail-ie0-f181.google.com with SMTP id x14so9892907ief.26
        for <linux-media@vger.kernel.org>; Fri, 07 Jun 2013 05:14:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51B076A2.9000903@gmail.com>
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
Date: Fri, 7 Jun 2013 09:14:37 -0300
Message-ID: <CALF0-+UBKXVeMxDob2NZWi5hervieRf48LoiTP80+_ZD58iw0g@mail.gmail.com>
Subject: Re: Audio: no sound
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: =?ISO-8859-1?Q?Alejandro_A=2E_Vald=E9s?= <av2406@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ale,

Mmm..

On Thu, Jun 6, 2013 at 8:46 AM, "Alejandro A. Valdés" <av2406@gmail.com> wrote:
> Sure. This is it:
>
>  0 [PCH            ]: HDA-Intel - HDA Intel PCH
>                       HDA Intel PCH at 0xd0600000 irq 43
>  1 [Controlle      ]: USB-Audio - USB 2.0 Video Capture Controlle
>                       Syntek Semiconductor USB 2.0 Video Capture Controlle
> at usb-0000:00:1d.0-1.3, h
>
>

You should see an stk1160 mixer as explained here:

http://easycap.blogspot.com.ar/2012/07/new-driver-for-easycap-dc60-stk1160.html

Maybe you don't have the STK1160_AC97 kernel option selected?
Mind pasting me / attaching your kernel configuration somewhere?

Remember, I'm aware there are some devices that don't have this audio
ac97 capability.
I'll try to look at adding it these days, it's an old issue so maybe
it's time to fix it!

-- 
    Ezequiel

Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38371 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab1ATXTU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 18:19:20 -0500
Received: by ewy5 with SMTP id 5so640836ewy.19
        for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 15:19:19 -0800 (PST)
Date: Fri, 21 Jan 2011 08:20:08 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] tm6000: add/rework reg.defines
Message-ID: <20110121082008.415bcabe@glory.local>
In-Reply-To: <4D388C44.7040500@arcor.de>
References: <4CAD5A78.3070803@redhat.com>
	<4CAF0602.6050002@redhat.com>
	<20101012142856.2b4ee637@glory.local>
	<4CB492D4.1000609@arcor.de>
	<20101129174412.08f2001c@glory.local>
	<4CF51C9E.6040600@arcor.de>
	<20101201144704.43b58f2c@glory.local>
	<4CF67AB9.6020006@arcor.de>
	<20101202134128.615bbfa0@glory.local>
	<4CF71CF6.7080603@redhat.com>
	<20101206010934.55d07569@glory.local>
	<4CFBF62D.7010301@arcor.de>
	<20101206190230.2259d7ab@glory.local>
	<4CFEA3D2.4050309@arcor.de>
	<20101208125539.739e2ed2@glory.local>
	<4CFFAD1E.7040004@arcor.de>
	<20101214122325.5cdea67e@glory.local>
	<4D079ADF.2000705@arcor.de>
	<20101215164634.44846128@glory.local>
	<4D08E43C.8080002@arcor.de>
	<20101216183844.6258734e@glory.local>
	<4D0A4883.20804@arcor.de>
	<20101217104633.7c9d10d7@glory.local>
	<4D0AF2A7.6080100@arcor.de>
	<20101217160854.16a1f754@glory.local>
	<4D0BFF4B.3060001@redhat.com>
	<20110120150508.53c9b55e@glory.local>
	<4D388C44.7040500@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Stefan

> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1

snip

> > #define TM6010_REQ08_RF2_LEFT_CHANNEL_VOL 0x08, 0xf2
> >
> > Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov
> > <d.belimov@gmail.com>
> >
> >
> > With my best regards, Dmitry.
> Dmitry, that are good news! And that anwers my questions. Now I think
> we must separate the both chipsets in any points:
> 
>     *  audio standards
>     *  video standards
>     * in tm6000-alsa the functions " _tm6000_start_audio_dma" and
>       "_tm6000_stop_audio_dma"
>     * in tm6000-input "tm6000_ir_config"
>     * in tm6000-core ?? "init_analog_mode" and "init_digital_mode"
>     * in tm6000-core "tm6000_set_audio_bitrate"
> 
> My rework in tm6000-video, isoc usb buffer and vbi device, I move this
> into summer 2011!!

Ok. I work too. :)
I have Software Programmers Guide from Trident for TM6000 and TM6010 under NDA.
If you have any question about any registers you can ask me.

With my best regards, Dmitry.

> Stefan Ringel
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.12 (MingW32)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>  
> iQEcBAEBAgAGBQJNOIxEAAoJEAWtPFjxMvFG3LQIAKlIMVWYTTPA5RD45Sw4QBQH
> I+yqhs89Qe7bKl+JjDrSiCG/ttRDtTy0+ksUFmicglntLmmtPVQnv59tIU9evQmn
> Yt7n1XWHcq442+ySbQ/3fVLay1WG1eJ3UEsC7bkpT2hSUhmUf6zjSZ3ockIJfxEJ
> geqFOy630vfwcKcS7KWgAJO8LKYQXcW8TLmkb3/D4W1G8o7zCKIH624Q5u+k1IGk
> mmm5CiqO17FS/oK0pxTZAY8uqWr3DH3UUqiMR3GdGoivaOR+1QCdrrYZXkQxklai
> zPQ6AYx/zPStZK8iUSSOHpVkfqHTgB3f6BSpsWhNGT3mgW8tTxnAz/MyECUiEms=
> =Cxjk
> -----END PGP SIGNATURE-----
> 

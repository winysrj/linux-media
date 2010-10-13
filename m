Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44371 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab0JMAMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Oct 2010 20:12:19 -0400
Received: by ewy20 with SMTP id 20so1702446ewy.19
        for <linux-media@vger.kernel.org>; Tue, 12 Oct 2010 17:12:18 -0700 (PDT)
Date: Wed, 13 Oct 2010 10:13:02 -0400
From: Dmitri Belimov <d.belimov@gmail.com>
To: Stefan Ringel <stefan.ringel@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH] Audio standards on tm6000
Message-ID: <20101013101302.2c6a5ccf@glory.local>
In-Reply-To: <4CB492D4.1000609@arcor.de>
References: <4CAD5A78.3070803@redhat.com>
	<20101008150301.2e3ceaff@glory.local>
	<4CAF0602.6050002@redhat.com>
	<20101012142856.2b4ee637@glory.local>
	<4CB492D4.1000609@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Stefan

> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>  
> Am 12.10.2010 20:28, schrieb Dmitri Belimov:
> > Hi
> >
> >> Em 08-10-2010 16:03, Dmitri Belimov escreveu:
> >>> Hi Mauro
> >>>
> >>> Not so good. Audio with this patch has bad white noise
> >>> sometimes and bad quality. I try found better configuration for
> >>> SECAM-DK.
> >>
> >> Ok. Well, feel free to modify it. I think that this approach may
> >> be better, especially if we need to add later some sort of code
> >> to detect and change audio standard for some standards that have
> >> more than one audio standard associated (we needed do to it on
> >> other drivers, in order to work in Russia and other Countries
> >> that use different variants of the audio standard).
> >>
> >> The association between video and audio standard is not complete.
> >> For example, it misses NTSC-Kr and NTSC-Jp.
> >
> > Rework audio. Add SECAM-DK, move SECAM to SECAM-B | SECAM-G. Add
> > some new audio standards and tricks for future, see
> > tm6000_set_audio_std For SECAM-DK it works. Try on your standards.
> >
> >
> > Two files in attach. Patch after latest patch from Mauro and full
> > file tm6000-std.c
> >
> >> Cheers, Mauro.
> >>
> >
> > With my best regards, Dmitry.
> Where is defined "tv_audio_mode"?

This is concept only for future. I didn't understand how to do it.
When audio was working use this for set MONO or audio languige channel.

With my best regards, Dmitry.

> Stefan Ringel
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.12 (MingW32)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>  
> iQEcBAEBAgAGBQJMtJLTAAoJEAWtPFjxMvFGnFAH/Rrk274byzL8IvQd6fjAIl4D
> izk31/k4CY1Y2EdHvygef4ZQxIGE4PGDaOogWEIBLtlHTx6XHUASpiZ8aJW1z7oF
> YQk9rtfC3ZChmaGQDBzwLI+EUg9t7TzeQ8BpC11WxiOapyKLXFv0SdMNs2Y0WHOz
> BNlQkL+9kZ+Hq6nSdJJxOihu+tiwbmvvSd7b/Cz9kdLpSNGr99F+ELbM0g3oU2Ts
> ue7r3FnvHFnpNlV7Ceiuj7jF5ozeo3jSdWJI3S8ph4Wdi3CkPxTnTQXJAU09JU1k
> we8+/TdplP+3Rdf206r/SL4RlI5wiZr/jm4IdLcwLOm/9yHthb89qyuW5upvV6k=
> =LQiB
> -----END PGP SIGNATURE-----
> 

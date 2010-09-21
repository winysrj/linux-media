Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34745 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab0IUF4G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 01:56:06 -0400
Received: by ewy23 with SMTP id 23so1816130ewy.19
        for <linux-media@vger.kernel.org>; Mon, 20 Sep 2010 22:56:04 -0700 (PDT)
Date: Tue, 21 Sep 2010 15:56:26 -0400
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Felipe Sanches <juca@members.fsf.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
Subject: Re: [PATCH v2] tm6000+audio
Message-ID: <20100921155626.65a31f29@glory.local>
In-Reply-To: <4C9820E3.3050508@redhat.com>
References: <20100622180521.614eb85d@glory.loctelecom.ru>
	<4C20D91F.500@redhat.com>
	<4C212A90.7070707@arcor.de>
	<4C213257.6060101@redhat.com>
	<4C222561.4040605@arcor.de>
	<4C224753.2090109@redhat.com>
	<4C225A5C.7050103@arcor.de>
	<20100716161623.2f3314df@glory.loctelecom.ru>
	<4C4C4DCA.1050505@redhat.com>
	<20100728113158.0f1495c0@glory.loctelecom.ru>
	<4C4FD659.9050309@arcor.de>
	<20100729140936.5bddd275@glory.loctelecom.ru>
	<4C51ADB5.7010906@redhat.com>
	<20100731122428.4ee569b4@glory.loctelecom.ru>
	<4C53A837.3070700@redhat.com>
	<20100825043746.225a352a@glory.local>
	<4C7543DA.1070307@redhat.com>
	<AANLkTimr3=1QHzX3BzUVyo6uqLdCKt8SS9sDtHfZtHGZ@mail.gmail.com>
	<4C767302.7070506@redhat.com>
	<20100920160715.7594ee2e@glory.local>
	<4C9820E3.3050508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

> Hi Dmitri,
> Em 20-09-2010 17:07, Dmitri Belimov escreveu:
> > Hi 
> > 
> > I rework my last patch for audio and now audio works well. This
> > patch can be submited to GIT tree Quality of audio now is good for
> > SECAM-DK. For other standard I set some value from datasheet need
> > some tests.
> > 
> > 1. Fix pcm buffer overflow
> > 2. Rework pcm buffer fill method
> > 3. Swap bytes in audio stream
> > 4. Change some registers value for TM6010
> > 5. Change pcm buffer size
> 
> One small compilation fix for your patch:
> 
> diff --git a/drivers/staging/tm6000/tm6000-stds.c
> b/drivers/staging/tm6000/tm6000-stds.c index 6bf4a73..fe22f42 100644
> --- a/drivers/staging/tm6000/tm6000-stds.c
> +++ b/drivers/staging/tm6000/tm6000-stds.c
> @@ -32,7 +32,7 @@ struct tm6000_std_tv_settings {
>  	v4l2_std_id id;
>  	struct tm6000_reg_settings sif[12];
>  	struct tm6000_reg_settings nosif[12];
> -	struct tm6000_reg_settings common[25];
> +	struct tm6000_reg_settings common[26];
>  };
>  

Ooops :)

> I'll do some tests on it.

Ok

With my best regards, Dmitry.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40124 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZKJBga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 20:36:30 -0500
Received: by fxm21 with SMTP id 21so637359fxm.21
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 17:36:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0911092134440.4289@axis700.grange>
References: <Pine.LNX.4.64.0911061127240.4389@axis700.grange>
	<c09aa50a0911090242l35d0dfb2vec0cdeff8b86d33e@mail.gmail.com>
	<Pine.LNX.4.64.0911091530030.4289@axis700.grange> <c09aa50a0911091218i681449e0r5cb96b9db3e0def6@mail.gmail.com>
	<Pine.LNX.4.64.0911092134440.4289@axis700.grange>
From: Ian Molton <ian@mnementh.co.uk>
Date: Tue, 10 Nov 2009 01:36:13 +0000
Message-ID: <c09aa50a0911091736k27d66483t9012e296bfbf578a@mail.gmail.com>
Subject: Re: [PATCH/RFC] tmio_mmc: keep card-detect interrupts enabled
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well if they are only masked they shouldnt stop being asserted. But we
should unmask them again.

Im not really sure we should mask them anyway, with the card possibly
being gone... Will need to look into it further.

2009/11/9 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> (re-adding accidentally dropped ML)
>
> On Mon, 9 Nov 2009, Ian Molton wrote:
>
>> Well, I presume we want to know when the card gets removed :)
>
> Sure, that's why we shouldn't mask those interrupts:-) If they do get
> masked and missed, I do not know, if the interrupt remains pending in this
> case, because they never get detected then:)
>
>>
>> 2009/11/9 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>> > Hi Ian
>> >
>> > Why did you drop all CCs?
>> >
>> > On Mon, 9 Nov 2009, Ian Molton wrote:
>> >
>> >> I havent looked at the consequences for the driver if a insert IRQ
>> >> occurs during IO, however it seems logical that we should not
>> >> permanently mask the IRQ.
>> >>
>> >> I presume that the IRQ remains pending?
>> >
>> > Don't know, never checked. Is this important to know?
>> >
>> > Thanks
>> > Guennadi
>> >
>> >>
>> >> 2009/11/6 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>> >> > On SuperH platforms the SDHI controller does not produce any command IRQs
>> >> > after a completed IO. This leads to card-detect interrupts staying
>> >> > disabled. Do not disable card-detect interrupts on DATA IRQs.
>> >> >
>> >> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> >> > ---
>> >> >
>> >> > Marked as RFC because I'm not really sure this is a correct approach to
>> >> > fix this problem, and whether this will have negative effect on other
>> >> > tmio_mmc MFD users.
>> >> >
>> >> > diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
>> >> > index c676767..0b31d44 100644
>> >> > --- a/drivers/mmc/host/tmio_mmc.h
>> >> > +++ b/drivers/mmc/host/tmio_mmc.h
>> >> > @@ -55,10 +55,8 @@
>> >> >  /* Define some IRQ masks */
>> >> >  /* This is the mask used at reset by the chip */
>> >> >  #define TMIO_MASK_ALL           0x837f031d
>> >> > -#define TMIO_MASK_READOP  (TMIO_STAT_RXRDY | TMIO_STAT_DATAEND | \
>> >> > -               TMIO_STAT_CARD_REMOVE | TMIO_STAT_CARD_INSERT)
>> >> > -#define TMIO_MASK_WRITEOP (TMIO_STAT_TXRQ | TMIO_STAT_DATAEND | \
>> >> > -               TMIO_STAT_CARD_REMOVE | TMIO_STAT_CARD_INSERT)
>> >> > +#define TMIO_MASK_READOP  (TMIO_STAT_RXRDY | TMIO_STAT_DATAEND)
>> >> > +#define TMIO_MASK_WRITEOP (TMIO_STAT_TXRQ | TMIO_STAT_DATAEND)
>> >> >  #define TMIO_MASK_CMD     (TMIO_STAT_CMDRESPEND | TMIO_STAT_CMDTIMEOUT | \
>> >> >                TMIO_STAT_CARD_REMOVE | TMIO_STAT_CARD_INSERT)
>> >> >  #define TMIO_MASK_IRQ     (TMIO_MASK_READOP | TMIO_MASK_WRITEOP | TMIO_MASK_CMD)
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>



-- 
Ian Molton
Linux, Automotive, and other hacking:
http://www.mnementh.co.uk/

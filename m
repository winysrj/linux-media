Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0AFEC04EBF
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 19:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A421F20878
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 19:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mI/GA1M2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A421F20878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbeLDTEv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 14:04:51 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40564 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbeLDTEu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 14:04:50 -0500
Received: by mail-wm1-f67.google.com with SMTP id q26so10421012wmf.5;
        Tue, 04 Dec 2018 11:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iArjsd8D/6NBfzIjUFM8/RIE4xSFq/81usK1VGylZHc=;
        b=mI/GA1M2vHIySTglwpARRJnJ9ndD7Alx7CfvPpfEOXNR8gHnyCUJl7J5tTu1ZGw2st
         yoPpQYf5TUqAwuJWYMUaay1z6Jx+/IaCTDVfXG7y4rqoYZ9Cosrf3DXV8zBMVYn0cTl/
         Y5OyKnBO2KnVQHZVY8YuykBSHnaGnKKMroz2T4cor4N+LgT1tZgWoWkPY/DgvHCItWde
         HKbL22Ie41R7ST3hontE++VnP7tfFF9whl+/74oCwZn6bRAIpYZx+IXhhM4weBoQhDfZ
         cvnAxPwtiymIQNox81pwKoz3hdzepi+W9TRzpF+4US/GkDVUwPhyl9qjhq0ndlk/hcvF
         YmfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iArjsd8D/6NBfzIjUFM8/RIE4xSFq/81usK1VGylZHc=;
        b=adjUIftpk/MCrt0CQFZX4cKcxybZ5lBTRivNXkT60FONUeoEEablxORs+ILI+nHG2z
         O1X7YOn6/RJ7nVoPEeWnSHrboBke32IJApizCJFYaqsr/Ldc7I7ZXhlzE2xAtXhPk/bx
         lXTbK5/EB/r1cBtPRcKEr4byTrK7ddJLYiCQgKTfcdJ46WOVxq4vnkRtz5G2fq2Tj+Pa
         n0LAEbTDo2wmZ19sK2gDG+BxS+WIOvYDImOPlfNiUeGoqz/Ot/N3sIKxgnWw3ZwcQA2k
         mmxfpSixKLBFnof8QtG7Vl2N2IbueAY697+aIKdRjcXNnWPphrNaDgatTNTRQD4hhbFJ
         8NcQ==
X-Gm-Message-State: AA+aEWbvLXLCCW/ZTgebW84Uo8YcBsgMvQrGdyfdLnlVA7ntDDCEptg6
        ZOgRcv22po97SqzZe1lKWjBrTLyw+z0=
X-Google-Smtp-Source: AFSGD/UsZZMMZucGUlm7+/N0qT23JIM2Rlf0a37QR9vIsCWsz1y7pi8PoOYHVUZXuqJaGLB6xnbcXQ==
X-Received: by 2002:a1c:c303:: with SMTP id t3mr12734118wmf.94.1543950287522;
        Tue, 04 Dec 2018 11:04:47 -0800 (PST)
Received: from flashbox ([2a01:4f8:10b:24a5::2])
        by smtp.gmail.com with ESMTPSA id v4sm8173631wme.6.2018.12.04.11.04.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Dec 2018 11:04:46 -0800 (PST)
Date:   Tue, 4 Dec 2018 12:04:44 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Sean Young <sean@mess.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] dib7000p: Remove dead code
Message-ID: <20181204190444.GA9298@flashbox>
References: <20180915054739.14117-1-natechancellor@gmail.com>
 <CAKwvOdmQ4pbbPuvYrVYB9myD8ap36h6nLjEdL-mSbYjM37UJ_g@mail.gmail.com>
 <20180917193936.33e90d5a@coco.lan>
 <20181204102639.3qsvfxrzmsvybiop@gofer.mess.org>
 <20181204095714.60ee5b95@coco.lan>
 <20181204133922.aaxvzu3qumbfakzu@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204133922.aaxvzu3qumbfakzu@gofer.mess.org>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Dec 04, 2018 at 01:39:22PM +0000, Sean Young wrote:
> On Tue, Dec 04, 2018 at 09:57:14AM -0200, Mauro Carvalho Chehab wrote:
> > Em Tue, 4 Dec 2018 10:26:40 +0000
> > Sean Young <sean@mess.org> escreveu:
> > 
> > > On Mon, Sep 17, 2018 at 07:39:36PM -0300, Mauro Carvalho Chehab wrote:
> > > > Em Mon, 17 Sep 2018 10:58:32 -0700
> > > > Nick Desaulniers <ndesaulniers@google.com> escreveu:
> > > >   
> > > > > On Fri, Sep 14, 2018 at 10:47 PM Nathan Chancellor
> > > > > <natechancellor@gmail.com> wrote:  
> > > > > >
> > > > > > Clang warns that 'interleaving' is assigned to itself in this function.
> > > > > >
> > > > > > drivers/media/dvb-frontends/dib7000p.c:1874:15: warning: explicitly
> > > > > > assigning value of variable of type 'int' to itself [-Wself-assign]
> > > > > >         interleaving = interleaving;
> > > > > >         ~~~~~~~~~~~~ ^ ~~~~~~~~~~~~
> > > > > > 1 warning generated.
> > > > > >
> > > > > > It's correct. Just removing the self-assignment would sufficiently hide
> > > > > > the warning but all of this code is dead because 'tmp' is zero due to
> > > > > > being multiplied by zero. This doesn't appear to be an issue with
> > > > > > dib8000, which this code was copied from in commit 041ad449683b
> > > > > > ("[media] dib7000p: Add DVBv5 stats support").
> > > > > >
> > > > > > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > > > > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > > > > > ---
> > > > > >  drivers/media/dvb-frontends/dib7000p.c | 10 ++--------
> > > > > >  1 file changed, 2 insertions(+), 8 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
> > > > > > index 58387860b62d..25843658fc68 100644
> > > > > > --- a/drivers/media/dvb-frontends/dib7000p.c
> > > > > > +++ b/drivers/media/dvb-frontends/dib7000p.c
> > > > > > @@ -1800,9 +1800,8 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)    
> > > > > 
> > > > > Something looks wrong here (with this function).  The patch is no
> > > > > functional change, since as you point out `interleaving` is
> > > > > initialized to 0, then never updated before read, but I think there's
> > > > > an underlying bug here that should be fixed differently.  Thanks for
> > > > > the patch though, as it does raise the question.
> > > > > 
> > > > > dib7000p_get_time_us has this comment above it:
> > > > > 
> > > > >   1798 /* FIXME: may require changes - this one was borrowed from
> > > > > dib8000 */  
> > > > 
> > > > The goal of dib7000p_get_time_us() is to estimate how much time it
> > > > takes, with current tuning parameters, to have a certain number of
> > > > DVB-T packets. This is used for block error count. That's said,
> > > > on a quick look, it seems that the code is not right on many ways.
> > > > 
> > > > It should be aligned with the amount of data it is required for
> > > > dib7000 to update the block/bit error counters. There are two kinds
> > > > of implementation:
> > > > 
> > > > 1) the frontend has an internal counter that it is shifted and made
> > > >    available to the driver after a certain amount of received data
> > > >    (usually in the order of 10^5 to 10^7 bits);
> > > > 
> > > > 2) the frontend has an internal timer that shifts the data from its
> > > >    internal counter after a certain amount of time (usually at the
> > > >    seconds range).
> > > > 
> > > > Different vendors opt for either one of the strategy. Some updates
> > > > a counter with the amount of bits taken. Unfortunately, this is not
> > > > the case of those dib* frontends. So, the Kernel has to estimate
> > > > it, based on the tuning parameters.
> > > > 
> > > > From the code, it seems that, for block errors, it waits for 1,250,000
> > > > bits to arrive (e. g. about 766 packets), so, it uses type (1) strategy:
> > > > 
> > > >                 /* Estimate the number of packets based on bitrate */
> > > >                 if (!time_us)
> > > >                         time_us = dib7000p_get_time_us(demod);
> > > > 
> > > >                 if (time_us) {
> > > >                         blocks = 1250000ULL * 1000000ULL;	// the multiply here is to convert to microsseconds...
> > > >                         do_div(blocks, time_us * 8 * 204);	// As here it divides by the time in microsseconds
> > > >                         c->block_count.stat[0].scale = FE_SCALE_COUNTER;
> > > >                         c->block_count.stat[0].uvalue += blocks;
> > > >                 }
> > > > 
> > > > For BER, the logic assumes that the bit error count should be divided
> > > > by 10^-8:
> > > > 
> > > >                 c->post_bit_count.stat[0].uvalue += 100000000;
> > > > 
> > > > and the counter is updated every second. So, it uses (2).
> > > >   
> > > > > 
> > > > > Wondering if it has the same bug, it seems it does not:
> > > > > drivers/media/dvb-frontends/dib8000.c#dib8000_get_time_us():3986
> > > > > 
> > > > > dib8000_get_time_us() seems to loop over multiple layers, and then
> > > > > assigns interleaving to the final layers interleaving (that looks like
> > > > > loop invariant code to me).
> > > > > 
> > > > > Mauro, should dib7000p_get_time_us() use c->layer[???].interleaving?  
> > > > 
> > > > I don't think that time interleaving would affect the bit rate.
> > > > I suspect that the dead code on dib8000 is just a dead code.
> > > >   
> > > > > I don't see a single reference to `layer` in
> > > > > drivers/media/dvb-frontends/dib7000p.c.  
> > > > 
> > > > Layers are specific for ISDB-T, but I think DVB-T (or at least DVB-T2)
> > > > may use time interleaving. 
> > > > 
> > > > Yet, as I said, the goal is to estimate the streaming bit rate. 
> > > > 
> > > > I don't remember anymore from where the dib8000 formula came.
> > > > 
> > > > My guts tell that time interleaving shouldn't do much changes (if any)
> > > > to the bit rate. I suspect that removing the dead code is likely
> > > > OK, but I'll try to see if I can find something related to where this
> > > > formula came.  
> > > 
> > > So we have two issues. One is the clang issue and clearly the code needs
> > > fixing up. The second issue is that we're not sure about the algorithm;
> > > I've been reading up on mpeg-ts but I'm not anywhere near getting to an
> > > answer on this.
> > > 
> > > How about we merge a patch which just fixes the clang issue and leave
> > > the rest of the code as-is for now?
> > 
> > I'm ok with that, but it would be better to add a FIXME note somewhere.
> > 
> > > 
> > > Thanks,
> > > 
> > > Sean
> > > 
> > > ---
> > > From c6e4c5f514c38511d2054c69f7b103e98c520af4 Mon Sep 17 00:00:00 2001
> > > From: Sean Young <sean@mess.org>
> > > Date: Tue, 4 Dec 2018 09:59:10 +0000
> > > Subject: [PATCH v2] media: dib7000p: Remove dead code
> > > 
> > > Clang warns that 'interleaving' is assigned to itself in this function.
> > > 
> > > drivers/media/dvb-frontends/dib7000p.c:1874:15: warning: explicitly
> > > assigning value of variable of type 'int' to itself [-Wself-assign]
> > >         interleaving = interleaving;
> > >         ~~~~~~~~~~~~ ^ ~~~~~~~~~~~~
> > > 1 warning generated.
> > > 
> > > Just remove the self-assign and leave existing code in place for now.
> > > 
> > > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > > Signed-off-by: Sean Young <sean@mess.org>
> > > ---
> > >  drivers/media/dvb-frontends/dib7000p.c | 2 --
> > >  1 file changed, 2 deletions(-)
> > > 
> > > diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
> > > index 58387860b62d..cd84320c61c9 100644
> > > --- a/drivers/media/dvb-frontends/dib7000p.c
> > > +++ b/drivers/media/dvb-frontends/dib7000p.c
> > > @@ -1871,8 +1871,6 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
> > >  		break;
> > >  	}
> > >  
> > > -	interleaving = interleaving;
> > > -
> > >  	denom = bits_per_symbol * rate_num * fft_div * 384;
> > 
> > something like:
> > 
> > 	/* 
> > 	 * FIXME: check if the math makes sense. If so, fill the
> > 	 * interleaving var.
> > 	 */
> > >  
> > >  	/* If calculus gets wrong, wait for 1s for the next stats */
> > 
> 
> Good point. 
> 
> Sean
> 
> From a31c18315830da40561db6443d3b90b8584d5232 Mon Sep 17 00:00:00 2001
> From: Sean Young <sean@mess.org>
> Date: Tue, 4 Dec 2018 09:59:10 +0000
> Subject: [PATCH v3] media: dib7000p: Remove dead code
> 
> Clang warns that 'interleaving' is assigned to itself in this function.
> 
> drivers/media/dvb-frontends/dib7000p.c:1874:15: warning: explicitly
> assigning value of variable of type 'int' to itself [-Wself-assign]
>         interleaving = interleaving;
>         ~~~~~~~~~~~~ ^ ~~~~~~~~~~~~
> 1 warning generated.
> 
> Just remove the self-assign and leave existing code in place for now.
> 
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Sean Young <sean@mess.org>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  drivers/media/dvb-frontends/dib7000p.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
> index 58387860b62d..2818e8def1b3 100644
> --- a/drivers/media/dvb-frontends/dib7000p.c
> +++ b/drivers/media/dvb-frontends/dib7000p.c
> @@ -1871,10 +1871,13 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
>  		break;
>  	}
>  
> -	interleaving = interleaving;
> -
>  	denom = bits_per_symbol * rate_num * fft_div * 384;
>  
> +	/*
> +	 * FIXME: check if the math makes sense. If so, fill the
> +	 * interleaving var.
> +	 */
> +
>  	/* If calculus gets wrong, wait for 1s for the next stats */
>  	if (!denom)
>  		return 0;
> -- 
> 2.19.2
> 

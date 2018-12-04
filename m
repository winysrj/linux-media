Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2748C04EB8
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 13:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DDCE206B6
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 13:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DDCE206B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mess.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbeLDNj0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 08:39:26 -0500
Received: from gofer.mess.org ([88.97.38.141]:54559 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbeLDNj0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Dec 2018 08:39:26 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 15A8360EED; Tue,  4 Dec 2018 13:39:23 +0000 (GMT)
Date:   Tue, 4 Dec 2018 13:39:22 +0000
From:   Sean Young <sean@mess.org>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] dib7000p: Remove dead code
Message-ID: <20181204133922.aaxvzu3qumbfakzu@gofer.mess.org>
References: <20180915054739.14117-1-natechancellor@gmail.com>
 <CAKwvOdmQ4pbbPuvYrVYB9myD8ap36h6nLjEdL-mSbYjM37UJ_g@mail.gmail.com>
 <20180917193936.33e90d5a@coco.lan>
 <20181204102639.3qsvfxrzmsvybiop@gofer.mess.org>
 <20181204095714.60ee5b95@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204095714.60ee5b95@coco.lan>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org
Message-ID: <20181204133922.kcBPeaJSqL6sFHCDLxlrbj6WzvPWdzIxuq4mI1t8llI@z>

On Tue, Dec 04, 2018 at 09:57:14AM -0200, Mauro Carvalho Chehab wrote:
> Em Tue, 4 Dec 2018 10:26:40 +0000
> Sean Young <sean@mess.org> escreveu:
> 
> > On Mon, Sep 17, 2018 at 07:39:36PM -0300, Mauro Carvalho Chehab wrote:
> > > Em Mon, 17 Sep 2018 10:58:32 -0700
> > > Nick Desaulniers <ndesaulniers@google.com> escreveu:
> > >   
> > > > On Fri, Sep 14, 2018 at 10:47 PM Nathan Chancellor
> > > > <natechancellor@gmail.com> wrote:  
> > > > >
> > > > > Clang warns that 'interleaving' is assigned to itself in this function.
> > > > >
> > > > > drivers/media/dvb-frontends/dib7000p.c:1874:15: warning: explicitly
> > > > > assigning value of variable of type 'int' to itself [-Wself-assign]
> > > > >         interleaving = interleaving;
> > > > >         ~~~~~~~~~~~~ ^ ~~~~~~~~~~~~
> > > > > 1 warning generated.
> > > > >
> > > > > It's correct. Just removing the self-assignment would sufficiently hide
> > > > > the warning but all of this code is dead because 'tmp' is zero due to
> > > > > being multiplied by zero. This doesn't appear to be an issue with
> > > > > dib8000, which this code was copied from in commit 041ad449683b
> > > > > ("[media] dib7000p: Add DVBv5 stats support").
> > > > >
> > > > > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > > > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > > > > ---
> > > > >  drivers/media/dvb-frontends/dib7000p.c | 10 ++--------
> > > > >  1 file changed, 2 insertions(+), 8 deletions(-)
> > > > >
> > > > > diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
> > > > > index 58387860b62d..25843658fc68 100644
> > > > > --- a/drivers/media/dvb-frontends/dib7000p.c
> > > > > +++ b/drivers/media/dvb-frontends/dib7000p.c
> > > > > @@ -1800,9 +1800,8 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)    
> > > > 
> > > > Something looks wrong here (with this function).  The patch is no
> > > > functional change, since as you point out `interleaving` is
> > > > initialized to 0, then never updated before read, but I think there's
> > > > an underlying bug here that should be fixed differently.  Thanks for
> > > > the patch though, as it does raise the question.
> > > > 
> > > > dib7000p_get_time_us has this comment above it:
> > > > 
> > > >   1798 /* FIXME: may require changes - this one was borrowed from
> > > > dib8000 */  
> > > 
> > > The goal of dib7000p_get_time_us() is to estimate how much time it
> > > takes, with current tuning parameters, to have a certain number of
> > > DVB-T packets. This is used for block error count. That's said,
> > > on a quick look, it seems that the code is not right on many ways.
> > > 
> > > It should be aligned with the amount of data it is required for
> > > dib7000 to update the block/bit error counters. There are two kinds
> > > of implementation:
> > > 
> > > 1) the frontend has an internal counter that it is shifted and made
> > >    available to the driver after a certain amount of received data
> > >    (usually in the order of 10^5 to 10^7 bits);
> > > 
> > > 2) the frontend has an internal timer that shifts the data from its
> > >    internal counter after a certain amount of time (usually at the
> > >    seconds range).
> > > 
> > > Different vendors opt for either one of the strategy. Some updates
> > > a counter with the amount of bits taken. Unfortunately, this is not
> > > the case of those dib* frontends. So, the Kernel has to estimate
> > > it, based on the tuning parameters.
> > > 
> > > From the code, it seems that, for block errors, it waits for 1,250,000
> > > bits to arrive (e. g. about 766 packets), so, it uses type (1) strategy:
> > > 
> > >                 /* Estimate the number of packets based on bitrate */
> > >                 if (!time_us)
> > >                         time_us = dib7000p_get_time_us(demod);
> > > 
> > >                 if (time_us) {
> > >                         blocks = 1250000ULL * 1000000ULL;	// the multiply here is to convert to microsseconds...
> > >                         do_div(blocks, time_us * 8 * 204);	// As here it divides by the time in microsseconds
> > >                         c->block_count.stat[0].scale = FE_SCALE_COUNTER;
> > >                         c->block_count.stat[0].uvalue += blocks;
> > >                 }
> > > 
> > > For BER, the logic assumes that the bit error count should be divided
> > > by 10^-8:
> > > 
> > >                 c->post_bit_count.stat[0].uvalue += 100000000;
> > > 
> > > and the counter is updated every second. So, it uses (2).
> > >   
> > > > 
> > > > Wondering if it has the same bug, it seems it does not:
> > > > drivers/media/dvb-frontends/dib8000.c#dib8000_get_time_us():3986
> > > > 
> > > > dib8000_get_time_us() seems to loop over multiple layers, and then
> > > > assigns interleaving to the final layers interleaving (that looks like
> > > > loop invariant code to me).
> > > > 
> > > > Mauro, should dib7000p_get_time_us() use c->layer[???].interleaving?  
> > > 
> > > I don't think that time interleaving would affect the bit rate.
> > > I suspect that the dead code on dib8000 is just a dead code.
> > >   
> > > > I don't see a single reference to `layer` in
> > > > drivers/media/dvb-frontends/dib7000p.c.  
> > > 
> > > Layers are specific for ISDB-T, but I think DVB-T (or at least DVB-T2)
> > > may use time interleaving. 
> > > 
> > > Yet, as I said, the goal is to estimate the streaming bit rate. 
> > > 
> > > I don't remember anymore from where the dib8000 formula came.
> > > 
> > > My guts tell that time interleaving shouldn't do much changes (if any)
> > > to the bit rate. I suspect that removing the dead code is likely
> > > OK, but I'll try to see if I can find something related to where this
> > > formula came.  
> > 
> > So we have two issues. One is the clang issue and clearly the code needs
> > fixing up. The second issue is that we're not sure about the algorithm;
> > I've been reading up on mpeg-ts but I'm not anywhere near getting to an
> > answer on this.
> > 
> > How about we merge a patch which just fixes the clang issue and leave
> > the rest of the code as-is for now?
> 
> I'm ok with that, but it would be better to add a FIXME note somewhere.
> 
> > 
> > Thanks,
> > 
> > Sean
> > 
> > ---
> > From c6e4c5f514c38511d2054c69f7b103e98c520af4 Mon Sep 17 00:00:00 2001
> > From: Sean Young <sean@mess.org>
> > Date: Tue, 4 Dec 2018 09:59:10 +0000
> > Subject: [PATCH v2] media: dib7000p: Remove dead code
> > 
> > Clang warns that 'interleaving' is assigned to itself in this function.
> > 
> > drivers/media/dvb-frontends/dib7000p.c:1874:15: warning: explicitly
> > assigning value of variable of type 'int' to itself [-Wself-assign]
> >         interleaving = interleaving;
> >         ~~~~~~~~~~~~ ^ ~~~~~~~~~~~~
> > 1 warning generated.
> > 
> > Just remove the self-assign and leave existing code in place for now.
> > 
> > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  drivers/media/dvb-frontends/dib7000p.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
> > index 58387860b62d..cd84320c61c9 100644
> > --- a/drivers/media/dvb-frontends/dib7000p.c
> > +++ b/drivers/media/dvb-frontends/dib7000p.c
> > @@ -1871,8 +1871,6 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
> >  		break;
> >  	}
> >  
> > -	interleaving = interleaving;
> > -
> >  	denom = bits_per_symbol * rate_num * fft_div * 384;
> 
> something like:
> 
> 	/* 
> 	 * FIXME: check if the math makes sense. If so, fill the
> 	 * interleaving var.
> 	 */
> >  
> >  	/* If calculus gets wrong, wait for 1s for the next stats */
> 

Good point. 

Sean

From a31c18315830da40561db6443d3b90b8584d5232 Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Tue, 4 Dec 2018 09:59:10 +0000
Subject: [PATCH v3] media: dib7000p: Remove dead code

Clang warns that 'interleaving' is assigned to itself in this function.

drivers/media/dvb-frontends/dib7000p.c:1874:15: warning: explicitly
assigning value of variable of type 'int' to itself [-Wself-assign]
        interleaving = interleaving;
        ~~~~~~~~~~~~ ^ ~~~~~~~~~~~~
1 warning generated.

Just remove the self-assign and leave existing code in place for now.

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/dvb-frontends/dib7000p.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 58387860b62d..2818e8def1b3 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -1871,10 +1871,13 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
 		break;
 	}
 
-	interleaving = interleaving;
-
 	denom = bits_per_symbol * rate_num * fft_div * 384;
 
+	/*
+	 * FIXME: check if the math makes sense. If so, fill the
+	 * interleaving var.
+	 */
+
 	/* If calculus gets wrong, wait for 1s for the next stats */
 	if (!denom)
 		return 0;
-- 
2.19.2


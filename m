Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55370 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZH3XPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 19:15:10 -0400
Date: Sun, 30 Aug 2009 20:15:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steven Toth <stoth@kernellabs.com>
Cc: Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	linux-media@vger.kernel.org, bob@turbosight.com
Subject: Re: [PATCH] cx23885: fix support for TBS 6920 card
Message-ID: <20090830201505.064c2144@pedra.chehab.org>
In-Reply-To: <8103ad500908200838v3b456052re0f3a17b06b523f@mail.gmail.com>
References: <20090819232002.a941c388.kosio.dimitrov@gmail.com>
	<4A8D4984.4000309@kernellabs.com>
	<8103ad500908200838v3b456052re0f3a17b06b523f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven,

As I'm understanding that you're reveiwing it, I'm marking this patch as such
at Patchwork.

Cheers,
Mauro.

Em Thu, 20 Aug 2009 18:38:46 +0300
Konstantin Dimitrov <kosio.dimitrov@gmail.com> escreveu:

> On Thu, Aug 20, 2009 at 4:03 PM, Steven Toth<stoth@kernellabs.com> wrote:
> > On 8/19/09 7:20 PM, Konstantin Dimitrov wrote:
> >>
> >> fix: GPIO initialization for TBS 6920
> >> fix: wrong I2C address for demod on TBS 6920
> >> fix: wrong I2C bus number for demod on TBS 6920
> >> fix: wrong "gen_ctrl_val" value for TS1 port on TBS 6920 (and some other
> >> cards)
> >> add: module_param "lnb_pwr_ctrl" as option to choose between "type 0" and
> >> "type 1" of LNB power control (two TBS 6920 boards no matter that they are
> >> marked as the same hardware revision may have different types of LNB power
> >> control)
> >> fix: LNB power control function for type 0 doesn't preserve the previous
> >> GPIO state, which is critical
> >> add: LNB power control function for type 1
> >>
> >> Signed-off-by: Bob Liu<bob@turbosight.com>
> >> Signed-off-by: Konstantin Dimitrov<kosio.dimitrov@gmail.com>
> > Hmm. A custom hanging off of a gpio to something that looks like an i2c
> > power control device. I want to review some of these generic (and
> > no-so-generic) changes before we merge this patch.
> >
> > Is the datasheet for the LNB power control device available to the public?
> > I'd like to understand some of the register details.
> 
> the datasheet is not available at least to me and i don't know any
> more details. the code in question was given to me by the author under
> GPLv2 license and that's why i put it in separate file
> "tbs_lnb_pwr.c".
> 
> also, the cards that use this type of LNB power control, which i
> called for short "type 1", have the same device IDs as the one that
> don't use it and use "type 0" of LNB power control instead.
> 
> --konstantin
> 
> >
> > Thanks,
> >
> > --
> > Steven Toth - Kernel Labs
> > http://www.kernellabs.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro

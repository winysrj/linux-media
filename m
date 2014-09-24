Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37362 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbaIXJ2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 05:28:18 -0400
Date: Wed, 24 Sep 2014 06:28:12 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 3/4] tc90522: add driver for Toshiba TC90522 quad
 demodulator
Message-ID: <20140924062812.6308f584@recife.lan>
In-Reply-To: <542233E5.5070201@gmail.com>
References: <1410196843-26168-1-git-send-email-tskd08@gmail.com>
	<1410196843-26168-4-git-send-email-tskd08@gmail.com>
	<20140923170730.4d5d167e@recife.lan>
	<542233E5.5070201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 24 Sep 2014 12:00:53 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> 
> Hi,
> 
> On 2014年09月24日 05:07, Mauro Carvalho Chehab wrote:
> > I applied this series, as we're discussing it already for a long time,
> > and it seems in a good shape...
> 
> thanks for your reviews and advices.
> 
> >> +static int tc90522s_read_status(struct dvb_frontend *fe, fe_status_t *status)
> ...........
> >> +	if (reg & 0x60) /* carrier? */
> >> +		return 0;
> > 
> > Sure about that? Wouldn't it be, instead, reg & 0x60 == 0x60?
> 
> Yes, I'm pretty sure about that.
> The register indicates errors in the various demod stages,
> and if all go well, the reg should be 0.
> 
> >> +static int tc90522t_read_status(struct dvb_frontend *fe, fe_status_t *status)
> ..............
> > The entire series of checks above seems wrong on my eyes too.
> > 
> > For example, if reg = 0x20 or 0x40 or 0x80 or ..., it will return
> > FE_HAS_LOCK.
> 
> This register 0x96 should indicates "lock" status for each layers,
> and since layer config can vary in ISDB-T, the driver checks that
> any of the three bits is set, for faster lock detection.
> and the register 0x80 is the same kind of the one in the above ISDB-S case.

Ah, ok. It could be useful to document it, and eventually to add some
debug printk's that would print the locks for each layer. Such printk
were very useful for me to discover why dib8000 driver were not locking
to a layer encoded using interleave equal to 4:

commit 34ba2e65bab3693cdd7c2ee0b8ba6477bd8c366b
Author: Mauro Carvalho Chehab <m.chehab@samsung.com>
Date:   Fri Jul 4 14:15:27 2014 -0300

    [media] dib8000: Fix handling of interleave bigger than 2
    
    If interleave is bigger than 2, the code will set it to 0, as
    dib8000 registers use a log2(). So, change the code to handle
    it accordingly.
    
    Acked-By: Patrick Boettcher <pboettcher@kernellabs.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>


Btw, please check if your driver is handling it well, as the valid
values for interleave are 0, 1, 2, 4 (actually, dib8000 also
supports interleaving equal to 8, if sound_broadcast).

> 
> > PS.: could you also test (and send us patches as needed) for ISDB-S
> > support at libdvbv5 and dvbv5-utils[1]?
> I'll have a try.

Ok, thanks!

Regards,
Mauro

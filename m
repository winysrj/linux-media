Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37837 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729494AbeGaNII (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 09:08:08 -0400
Date: Tue, 31 Jul 2018 12:28:15 +0100
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: read out of bounds if bpf reports high
 protocol number
Message-ID: <20180731112815.vzavjhs3bfhtybbq@gofer.mess.org>
References: <20180728091115.16971-1-sean@mess.org>
 <20180730192018.fadzkzfjudyxgy2t@lenny.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730192018.fadzkzfjudyxgy2t@lenny.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hias,

On Mon, Jul 30, 2018 at 09:20:18PM +0200, Matthias Reichl wrote:
> On Sat, Jul 28, 2018 at 10:11:15AM +0100, Sean Young wrote:
> > The repeat period is read from a static array. If a keydown event is
> > reported from bpf with a high protocol number, we read out of bounds. This
> > is unlikely to end up with a reasonable repeat period at the best of times,
> > in which case no timely key up event is generated.
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  drivers/media/rc/rc-main.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> > index 2e222d9ee01f..a24850be1f4f 100644
> > --- a/drivers/media/rc/rc-main.c
> > +++ b/drivers/media/rc/rc-main.c
> > @@ -679,6 +679,14 @@ static void ir_timer_repeat(struct timer_list *t)
> >  	spin_unlock_irqrestore(&dev->keylock, flags);
> >  }
> >  
> > +unsigned int repeat_period(int protocol)
> > +{
> > +	if (protocol >= ARRAY_SIZE(protocols))
> > +		return 100;
> 
> 100 seems a bit arbitrarily chosen to me. Wouldn't it be better to
> (re-)use eg protocols[RC_PROTO_UNKNOWN].repeat_period here?

That's a good idea! I think the patch is already on its way to be merged,
but we can patch this later.

What we really need is a way to set the repeat period and minimum timeout
for a bpf protocol.


Sean

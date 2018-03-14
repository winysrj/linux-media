Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:41692 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbeCNQgv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 12:36:51 -0400
Received: by mail-lf0-f49.google.com with SMTP id m69-v6so5746693lfe.8
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2018 09:36:50 -0700 (PDT)
Date: Wed, 14 Mar 2018 17:36:46 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: jacopo mondi <jacopo@jmondi.org>
Cc: kieran.bingham@ideasonboard.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com
Subject: Re: [PATCH 1/3] rcar-vin: remove duplicated check of state in irq
 handler
Message-ID: <20180314163646.GH10974@bigcity.dyn.berto.se>
References: <20180310000953.25366-1-niklas.soderlund+renesas@ragnatech.se>
 <20180310000953.25366-2-niklas.soderlund+renesas@ragnatech.se>
 <a6fa3bbf-52e5-5576-fbea-3a280a1c8bb1@ideasonboard.com>
 <20180313175654.GE10974@bigcity.dyn.berto.se>
 <20180314151733.GC16424@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180314151733.GC16424@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 2018-03-14 16:17:33 +0100, Jacopo Mondi wrote:
> Hi Niklas, Kieran,
> 
> On Tue, Mar 13, 2018 at 06:56:54PM +0100, Niklas Söderlund wrote:
> > Hi Kieran,
> >
> > Thanks for your feedback.
> >
> > On 2018-03-13 17:42:25 +0100, Kieran Bingham wrote:
> > > Hi Niklas,
> > >
> > > Thanks for the patch series :) - I've been looking forward to seeing this one !
> > >
> > > On 10/03/18 01:09, Niklas Söderlund wrote:
> > > > This is an error from when the driver where converted from soc-camera.
> > > > There is absolutely no gain to check the state variable two times to be
> > > > extra sure if the hardware is stopped.
> > >
> > > I'll not say this isn't a redundant check ... but isn't the check against two
> > > different states, and thus the remaining check doesn't actually catch the case
> > > now where state == STOPPED ?
> >
> > Thanks for noticing this, you are correct. I think I need to refresh my
> > glasses subscription after missing this :-)
> >
> > >
> > > (Perhaps state != RUNNING would be better ?, but I haven't checked the rest of
> > > the code)
> >
> > I will respin this in a v2 and either use state != RUNNING or at least
> > combine the two checks to prevent future embarrassing mistakes like
> > this.
> 
> I am sorry I have missed this comment, but I think your patch has some
> merits. Ofc no need to hold on v2 of this series for this, but still I
> think you can re-propose this later (and I didn't get from
> your commit message you were confusing STOPPED/STOPPING).
> 
> In rvin_stop_streaming(), you enter STOPPING state, disable the
> interface cleaning ME bit in VnMC and single/continuous capture mode
> in VnFC, and then poll on CA bit of VnMS until the VIN peripheral has
> not been stopped, at this  point you set interface state to STOPPED.
> 
> As you loop you can still receive interrupts, as you are releasing the
> spinlock when sleeping before testing the ME bit again, so it's fine
> checking for STOPPING state in irq handler.
> It seems to me though, that once you enter STOPPED state, you are sure the
> peripheral has stopped and you should not receive any more interrupt, spurious
> ones apart or when the peripheral fails to stop at all, but things went
> south already at that point.
> 
> Again no need to have this part of this series, but you may want to
> take into consideration this for the future, as with this change you can
> remove the STOPPED state at all from the driver.

You are correct.

This patch was extracted from another series I plan to post after the 
VIN Gen3 beast is done. The aim of that series is to add SEQ_TB/BT 
support to VIN and to do so another state STARTING is needed to handle 
the first few fields. But to avoid growing that series too large I 
thought I could get away with adding this cleanup to this series which 
cleans up the interrupt handler. So this patch will comeback in some 
form when I post that series :-)

But for now I'm happy to drop it as the performance gain with this 
patch-set applied are so nice when running into buffer starved 
situations.

> 
> Thanks
>    j
> 
> >
> > >
> > > --
> > > Kieran
> > >
> > >
> > > >
> > > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > > ---
> > > >  drivers/media/platform/rcar-vin/rcar-dma.c | 6 ------
> > > >  1 file changed, 6 deletions(-)
> > > >
> > > > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> > > > index 23fdff7a7370842e..b4be75d5009080f7 100644
> > > > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > > > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > > > @@ -916,12 +916,6 @@ static irqreturn_t rvin_irq(int irq, void *data)
> > > >  	rvin_ack_interrupt(vin);
> > > >  	handled = 1;
> > > >
> > > > -	/* Nothing to do if capture status is 'STOPPED' */
> > > > -	if (vin->state == STOPPED) {
> > > > -		vin_dbg(vin, "IRQ while state stopped\n");
> > > > -		goto done;
> > > > -	}
> > > > -
> > > >  	/* Nothing to do if capture status is 'STOPPING' */
> > > >  	if (vin->state == STOPPING) {
> > > >  		vin_dbg(vin, "IRQ while state stopping\n");
> > > >
> >
> > --
> > Regards,
> > Niklas Söderlund



-- 
Regards,
Niklas Söderlund
